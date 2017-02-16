package com.cloakentertainment.pokemonline.world 
{
	import com.cloakentertainment.pokemonline.battle.BattleManager;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.multiplayer.MultiplayerManager;
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.ui.MenuType;
	import com.cloakentertainment.pokemonline.ui.MessageCenter;
	import com.cloakentertainment.pokemonline.world.entity.Entity;
	import com.cloakentertainment.pokemonline.world.entity.EntityManager;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerManager 
	{
		private static var _player:Entity;
		private static var _pressKeyIntervalID:int;
		
		public static var playerWillBeMobile:Boolean = true;
		public static var initialTurnDirection:String = "down";
		public static var RUNNINGALLOWED:Boolean = true;
		
		public function PlayerManager() 
		{
			
		}
		
		public static function destroy():void
		{
			_player = null;
			
			destroyEventListeners();
		}
		
		public static function startBeingBusy():void
		{
			if(MultiplayerManager.CONNECTION) MultiplayerManager.CONNECTION.send("BusyState", true);
		}
		
		public static function stopBeingBusy():void
		{
			if(MultiplayerManager.CONNECTION) MultiplayerManager.CONNECTION.send("BusyState", false);
		}
		
		public static function setEntityAsPlayer(e:Entity):void
		{
			_player = e;
			_player.setMobility(playerWillBeMobile);
			playerWillBeMobile = true;
			_player.turn(initialTurnDirection);
			EntityManager.sendOurDirection();
			initialTurnDirection = "down";
		}
		
		public static function createEventListeners():void
		{
			KeyboardManager.registerKey(Configuration.DOWN_KEY, pressKey, InputGroups.OVERWORLD, true);
			KeyboardManager.registerKey(Configuration.UP_KEY, pressKey, InputGroups.OVERWORLD, true);
			KeyboardManager.registerKey(Configuration.RIGHT_KEY, pressKey, InputGroups.OVERWORLD, true);
			KeyboardManager.registerKey(Configuration.LEFT_KEY, pressKey, InputGroups.OVERWORLD, true);
			KeyboardManager.registerKey(Configuration.ENTER_KEY, pressEnter, InputGroups.OVERWORLD, true);
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressKey, InputGroups.OVERWORLD, true);
			KeyboardManager.registerKey(Configuration.START_KEY, pressStart, InputGroups.OVERWORLD, true);
			
			_pressKeyIntervalID = setInterval(pressKey, 100);
		}
		
		private static function pressStart():void
		{
			if (PLAYER.MOBILE == false || PLAYER.MOVING || MessageCenter.isMessageOpen() || Configuration.isInGameMenuOpen() || BattleManager.isBattleOccuring()) return;
			
			
			SoundManager.playSoundEffect(SoundEffect.IN_GAME_MENU_OPEN);
			Configuration.createMenu(MenuType.IN_GAME_MENU);
		}
		
		private static function pressKey():void
		{
			if (PLAYER.MOBILE == false || MessageCenter.isMessageOpen() || Configuration.isInGameMenuOpen() || BattleManager.isBattleOccuring()) return;
			
			// Check which key is pressed
			if (KeyboardManager.isKeyPressed(Configuration.CANCEL_KEY) && PLAYER.isJumping() == false)
			{
				if (!PLAYER.isRunning && RUNNINGALLOWED && Configuration.ACTIVE_TRAINER.getState("LRrunningshoes") == "true") 
				{
					if(MultiplayerManager.CONNECTION != null) MultiplayerManager.CONNECTION.send("RunState", true);
					PLAYER.startRunning();
				}
			} else 
			{
				stopRunning();
			}
			
			if (KeyboardManager.isKeyPressed(Configuration.DOWN_KEY)) EntityManager.moveEntity(PLAYER, "down");
			else if (KeyboardManager.isKeyPressed(Configuration.UP_KEY)) EntityManager.moveEntity(PLAYER, "up");
			else if (KeyboardManager.isKeyPressed(Configuration.LEFT_KEY)) EntityManager.moveEntity(PLAYER, "left");
			else if (KeyboardManager.isKeyPressed(Configuration.RIGHT_KEY)) EntityManager.moveEntity(PLAYER, "right");
			else
			{
				PLAYER.setNextMove("", -1, -1);
				PLAYER.finishJustMoving();
			}
		}
		
		private static function pressEnter():void
		{
			if (PLAYER.MOBILE == false || Configuration.isInGameMenuOpen() || MessageCenter.isMessageOpen() || BattleManager.isBattleOccuring() || !KeyboardManager.isInputGroupEnabled(InputGroups.OVERWORLD)) return; // Don't let immobilized players activate any entities!
			
			EntityManager.checkForActivatableEntity(PLAYER.DIRECTION);
		}
		
		public static function stopRunning():void 
		{
			if (PLAYER.isRunning)
			{
				if (MultiplayerManager.CONNECTION != null) MultiplayerManager.CONNECTION.send("RunState", false);
				PLAYER.stopRunning();
			}
		}
		
		public static function isEntityThePlayer(e:Entity):Boolean
		{
			if (PLAYER == e) return true;
			else return false;
		}
		
		public static function destroyEventListeners():void
		{
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, pressKey);
			KeyboardManager.unregisterKey(Configuration.UP_KEY, pressKey);
			KeyboardManager.unregisterKey(Configuration.LEFT_KEY, pressKey);
			KeyboardManager.unregisterKey(Configuration.RIGHT_KEY, pressKey);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, pressEnter);
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, pressKey);
			KeyboardManager.unregisterKey(Configuration.START_KEY, pressStart);
			
			clearInterval(_pressKeyIntervalID);
		}
		
		public static function get PLAYER():Entity
		{
			return _player;
		}
		
		private static var _lastOverworldXTile:int = -1;
		private static var _lastOverworldYTile:int = -1;
		public static function updateLastOverworldLocation(xTile:int, yTile:int):void
		{
			_lastOverworldXTile = xTile;
			_lastOverworldYTile = yTile;
		}
		
		public static function get LAST_OVERWORLD_XTILE():int
		{
			return _lastOverworldXTile;
		}
		
		public static function get LAST_OVERWORLD_YTILE():int
		{
			return _lastOverworldYTile;
		}
		
	}

}