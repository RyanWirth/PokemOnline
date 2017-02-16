package com.cloakentertainment.pokemonline.world
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.GameManager;
	import com.cloakentertainment.pokemonline.multiplayer.MultiplayerManager;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.cloakentertainment.pokemonline.ui.UILoadingSprite;
	import com.cloakentertainment.pokemonline.world.entity.*;
	import com.cloakentertainment.pokemonline.world.entity.Entity;
	import com.cloakentertainment.pokemonline.world.entity.EntityManager;
	import com.cloakentertainment.pokemonline.world.map.ChunkManager;
	import com.cloakentertainment.pokemonline.world.map.MapManager;
	import com.cloakentertainment.pokemonline.world.PlayerManager;
	import com.cloakentertainment.pokemonline.world.region.RegionManager;
	import com.cloakentertainment.pokemonline.world.tile.TileManager;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.ui.MessageCenter;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class WorldManager
	{
		private static var started:Boolean = false;
		public static var loadingSprite:UILoadingSprite;
		
		private static var _renderer:WorldRenderer;
		private static var _juggler:Juggler;
		private static var _starling:Starling;
		
		private static var _player:Entity;
		
		public function WorldManager()
		{
		
		}
		
		public static function startOverworld(retry:Boolean = false):void
		{
			if (started) return;
			started = true;
			
			loadingSprite = new UILoadingSprite();
			if (_starling) _starling.nativeOverlay.addChild(loadingSprite);
			else Configuration.STAGE.addChild(loadingSprite);
			
			if (retry) loadingSprite.updateStatus("Load failed, retrying...");
			
			// This will initialize the TileManager and cause it to resize the BitmapData for the tileset
			var tileManager:TileManager = new TileManager();
			tileManager = null;
			
			// Now, load the map!
			MapManager.loadMap(Configuration.ACTIVE_TRAINER.MAP, finishLoadingMap);
		}
		
		public static function mapLoadError():void
		{
			started = false;
			if (_starling) _starling.nativeOverlay.removeChild(loadingSprite);
			else Configuration.STAGE.removeChild(loadingSprite);
			loadingSprite.destroy();
			loadingSprite = null;
			
			startOverworld(true);
		}
		
		public static function destroyOverworld():void
		{
			Configuration.ACTIVE_TRAINER.deactivateClock();
			
			MapManager.destroy();
			EntityManager.destroy();
			RegionManager.destroy();
			PlayerManager.destroy();
			ChunkManager.destroy();
			KeyboardManager.cleanup();
			MessageCenter.cleanup();
			
			_renderer.removeChildren(0, -1, true);
			_renderer.dispose();
			_renderer = null;
			
			started = false;
		}
		
		public static function switchOverworld(newMapType:String, newSpawnXT:int, newSpawnYT:int, fadeWhite:Boolean = false):void
		{
			Configuration.FADE_OUT_AND_IN(finishSwitchingOverworld, fadeWhite, -1, [newSpawnXT, newSpawnYT, newMapType]);
		}
		
		private static function finishSwitchingOverworld(newSpawnXT:int, newSpawnYT:int, newMapType:String):void
		{
			if(PlayerManager.PLAYER) PlayerManager.PLAYER.setMobility(false);
			PlayerManager.destroyEventListeners();
			destroyOverworld();
			Configuration.ACTIVE_TRAINER.updateLocation(newSpawnXT, newSpawnYT, newMapType);
			EntityManager._animateDoorUponLoad = true;
			startOverworld();
		}
		
		private static function finishLoadingMap():void
		{
			loadingSprite.updateStatus("Initializing...");
			
			if (_starling)
			{
				finishCreatingStarling(null);
				return;
			}
			
			_starling = new Starling(WorldRenderer, Configuration.STAGE, Configuration.VIEWPORT);
			_starling.addEventListener(Event.CONTEXT3D_CREATE, finishInitializingStarling);
			_starling.addEventListener(Event.ROOT_CREATED, finishCreatingStarling);
			_starling.start();
		}
		
		private static function finishInitializingStarling(e:Event):void
		{
			_starling.removeEventListener(Event.CONTEXT3D_CREATE, finishInitializingStarling);
			
			loadingSprite.updateStatus("Preparing...");
		}
		
		public static function isStillLoading():Boolean
		{
			if (loadingSprite) return true;
			else return false;
		}
		
		private static function finishCreatingStarling(e:Event):void
		{
			_starling.removeEventListener(Event.ROOT_CREATED, finishCreatingStarling);
			
			_renderer = Starling.current.root as WorldRenderer;
			_juggler = Starling.juggler;
			
			// Prepare the destination coordinates
			var destinationXTile:int = MapManager.map.properties.properties["spawnXT"];
			var destinationYTile:int = MapManager.map.properties.properties["spawnYT"];
			if (Configuration.ACTIVE_TRAINER.X_TILE != -1) destinationXTile = Configuration.ACTIVE_TRAINER.X_TILE;
			if (Configuration.ACTIVE_TRAINER.Y_TILE != -1) destinationYTile = Configuration.ACTIVE_TRAINER.Y_TILE;
			
			if (MapManager.map.properties.properties.hasOwnProperty("overworldXT")) PlayerManager.updateLastOverworldLocation(MapManager.map.properties.properties["overworldXT"], MapManager.map.properties.properties["overworldYT"]);
			
			EntityManager.prepareEntityObjects(MapManager.ENTITIES);
			ChunkManager.prepareSprites();
			ChunkManager.centerTile(destinationXTile, destinationYTile);
			RegionManager.processRegions(MapManager.REGIONS);
			
			removeLoadingSprite();
			
			if (EntityManager._animateDoorUponLoad) EntityManager.animateTile(_player.X_TILE, _player.Y_TILE - 1, _player, true);
			
			// We can now connect to PlayerIO!
			if (MultiplayerManager.CONNECTION == null) GameManager.connectToPlayerIO();
			else 
			{
				EntityManager.sendOurLocation();
			}
			
			if (MapManager.map.properties.properties.hasOwnProperty("onEnter")) EntityManager.executeCommand(MapManager.map.properties.properties.onEnter, null, null);
			if (MapManager.map.properties.properties.hasOwnProperty("noRunning") && MapManager.map.properties.properties.noRunning == "true") PlayerManager.RUNNINGALLOWED = false;
			else PlayerManager.RUNNINGALLOWED = true;
		}
		
		public static function createPlayer(xTile:int, yTile:int):void
		{
			var playerClass:Class = Configuration.ACTIVE_TRAINER.TYPE == TrainerType.HERO_FEMALE ? EHeroFemale : EHeroMale;
			
			_player = EntityManager.createEntity(playerClass, xTile, yTile, AnimationType.WALK_DOWN, true);
			_player.stop();
			
			if (Configuration.ACTIVE_TRAINER.initialDirection != "")
			{
				PlayerManager.initialTurnDirection = Configuration.ACTIVE_TRAINER.initialDirection;
				Configuration.ACTIVE_TRAINER.initialDirection = "";
			}
			
			PlayerManager.setEntityAsPlayer(_player);
			PlayerManager.createEventListeners();
			
			RegionManager.checkForRegionChange(xTile, yTile);
			
			Configuration.ACTIVE_TRAINER.activateClock();
		}
		
		private static function removeLoadingSprite():void
		{
			if (!loadingSprite) return;
			
			if (_starling.nativeOverlay.contains(loadingSprite)) _starling.nativeOverlay.removeChild(loadingSprite);
			else if (Configuration.STAGE.contains(loadingSprite)) Configuration.STAGE.removeChild(loadingSprite);
			
			loadingSprite.destroy();
			loadingSprite = null;
			
		}
		
		public static function get RENDERER():WorldRenderer
		{
			return _renderer;
		}
		
		public static function get JUGGLER():Juggler
		{
			return _juggler;
		}
	
	}

}