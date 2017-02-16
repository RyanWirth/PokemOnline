package com.cloakentertainment.pokemonline.world.region
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.multiplayer.MultiplayerManager;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.world.sprite.SRegionPopup;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import com.cloakentertainment.pokemonline.world.PlayerManager;
	import com.cloakentertainment.pokemonline.stats.PokemonFactory;
	import com.cloakentertainment.pokemonline.stats.PokemonRarity;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import io.arkeus.tiled.TiledObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RegionManager
	{
		
		private static var _currentRegion:TiledObject;
		private static var _processedRegions:Vector.<TiledObject>;
		
		private static var _regionPopup:SRegionPopup;
		
		public function RegionManager()
		{
		
		}
		
		private static var _ignoringRegionChanges:Boolean = false;
		public static function startIgnoringRegionChanges(on:Boolean = true):void
		{
			_ignoringRegionChanges = on;
		}
		
		public static function destroy():void
		{
			_currentRegion = null;
			for (var i:int = 0; i < _processedRegions.length; i++) 
			{
				_processedRegions[i].destroy();
				_processedRegions[i] = null;
			}
			_processedRegions = null;
			
			destroyRegionPopup();
		}
		
		public static function processRegions(regions:Vector.<TiledObject>):void
		{
			_processedRegions = new Vector.<TiledObject>();
			
			if (!regions) return;
			
			for (var i:int = 0; i < regions.length; i++)
			{
				regions[i].x = Math.floor(regions[i].x / 16);
				regions[i].y = Math.floor(regions[i].y / 16);
				regions[i].width = Math.floor(regions[i].width / 16);
				regions[i].height = Math.floor(regions[i].height / 16);
				
				_processedRegions.push(regions[i]);
			}
			
			if(PlayerManager.PLAYER) checkForRegionChange(PlayerManager.PLAYER.X_TILE, PlayerManager.PLAYER.Y_TILE);
		}
		
		/** Finds the region the given x and y tile coordinates are in and compares it to the current region. If the coordinates are in a different region, cues up an SRegionPopup animation. */
		public static function checkForRegionChange(xTile:int, yTile:int):void
		{
			var region:TiledObject;
			var tempNewRegion:TiledObject;
			if (!_processedRegions) return;
			for (var i:int = 0; i < _processedRegions.length; i++)
			{
				region = _processedRegions[i];
				
				if (xTile >= region.x && xTile <= region.x + region.width && yTile >= region.y && yTile <= region.y + region.height)
				{
					// We're inside this region!
					tempNewRegion = region;
				}
			}
			
			if (tempNewRegion != null && _currentRegion != tempNewRegion)
			{
				_currentRegion = tempNewRegion;
				
				// Send our new region
				if (MultiplayerManager.CONNECTION != null) MultiplayerManager.CONNECTION.send("LocationRegion", CURRENT_REGION_NAME);
				Configuration.chatModule.regionSwitched(_currentRegion.properties.properties["name"]);
				
				if (_ignoringRegionChanges) return;
				
				playNewMusic();
				
				// Show the new popup, but first kill any pending changes (such as when the player moves repeatedly back and forth between regions.)
				if (_regionPopup) removeRegionPopup();
				TweenLite.delayedCall(0.51, displayRegionPopup);
			}
			
			region = null;
			tempNewRegion = null;
		}
		
		public static function playNewMusic():void
		{
			if (_currentRegion && _currentRegion.properties.properties.hasOwnProperty("music")) SoundManager.playMusicTrack(int(_currentRegion.properties.properties["music"]));
		}
		
		public static function stepInGrass():Pokemon
		{
			/// Pokemon data is defined as follows: [PokemonName]-[levelMin]/[levelMax]-[probability]-[rarity];[...], where probability is a number from 1 to 100.
			/// The rarity is used to determine the actual chance of encountering the Pokemon and should be derived from the "probability" variable.
			
			if (_currentRegion.properties.properties.hasOwnProperty("pokemon") == false) throw(new Error("Undefined Pokemon array for " + _currentRegion.name));
			var pokemon:Array = String(_currentRegion.properties.properties.pokemon).split(";");
			for (var i:int = 0; i < pokemon.length; i++)
			{
				if (pokemon[i] == "") continue;
				var pokemonData:Array = String(pokemon[i]).split("-");
				var name:String = String(pokemonData[0]);
				var levelData:Array = String(pokemonData[1]).split("/");
				var lowerLevel:int = int(levelData[0]);
				var upperLevel:int = int(levelData[1]);
				var level:int = (Math.floor(Math.random() * (upperLevel - lowerLevel + 1)) + lowerLevel);
				var rarity:String = String(pokemonData[3]);
				
				if (checkRarity(rarity))
				{
					// We'll return this pokemon!
					return PokemonFactory.createPokemon(name, level, _currentRegion.properties.properties.name);
				}
				
			}
			
			return null;
		}
		
		/** Given a specified rarityType, determines if the occurrence will result in a wild battle or not. */
		private static function checkRarity(rarityType:String):Boolean
		{
			var probability:Number = 0;
			switch(rarityType)
			{
				case PokemonRarity.VERY_COMMON:
					probability = 10 / 187.5;
					break;
				case PokemonRarity.COMMON:
					probability = 8.5 / 187.5;
					break;
				case PokemonRarity.SEMI_RARE:
					probability = 6.75 / 187.5;
					break;
				case PokemonRarity.RARE:
					probability = 3.33 / 187.5;
					break;
				case PokemonRarity.VERY_RARE:
					probability = 1.25 / 187.5;
					break;
				default:
					throw(new Error("Unknown PokemonRarity '" + rarityType + "'!"));
					break;
			}
			probability /= 1.3;
			if (Math.random() <= probability)	return true;
			else return false;
		}
		
		private static function displayRegionPopup():void
		{
			if (_regionPopup) destroyRegionPopup();
			
			if (_currentRegion.properties.properties["type"] == "nodisplay") return;
			
			_regionPopup = new SRegionPopup(_currentRegion.properties.properties["type"], _currentRegion.properties.properties["name"]);
			WorldManager.RENDERER.addChild(_regionPopup);
			_regionPopup.y = -_regionPopup.height;
			
			TweenLite.to(_regionPopup, 0.5, {ease: Linear.easeOut, y: 0, onComplete: holdRegionPopup});
		}
		
		private static function holdRegionPopup():void
		{
			if (!_regionPopup) return;
			
			TweenLite.delayedCall(2.5, removeRegionPopup);
		}
		
		private static function removeRegionPopup():void
		{
			if (!_regionPopup) return;
			TweenLite.killDelayedCallsTo(displayRegionPopup);
			TweenLite.killDelayedCallsTo(removeRegionPopup);
			TweenLite.killTweensOf(_regionPopup);
			TweenLite.to(_regionPopup, 0.5, {ease: Linear.easeIn, y: -_regionPopup.height, onComplete: destroyRegionPopup});
		}
		
		public static function hideRegionIcon():void
		{
			TweenLite.killDelayedCallsTo(displayRegionPopup);
			TweenLite.killDelayedCallsTo(removeRegionPopup);
			removeRegionPopup();
		}
		
		private static function destroyRegionPopup():void
		{
			if (!_regionPopup) return;
			
			WorldManager.RENDERER.removeChild(_regionPopup);
			_regionPopup.destroy();
			_regionPopup = null;
		}
		
		public static function get CURRENT_REGION():TiledObject
		{
			return _currentRegion;
		}
		
		public static function get CURRENT_REGION_NAME():String
		{
			if (_currentRegion == null || _currentRegion.name == null || _currentRegion.name == "") return "Unknown";
			return _currentRegion.name;
		}
	
	}

}