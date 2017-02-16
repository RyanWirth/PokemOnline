package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.stats.PokemonType;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.multiplayer.AccountStatus;
	import com.cloakentertainment.pokemonline.multiplayer.AccountManager;
	import com.greensock.TweenLite;
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIInGameMenu extends Sprite implements UIElement
	{	
		private var uiQuestionTextBox:UIQuestionTextBox;
		private var _callback:Function;
		private var menuOptions:Vector.<String>;
		
		public function UIInGameMenu(callback:Function = null):void
		{	
			_callback = callback;
			construct();
		}
		
		public function construct():void
		{
			Configuration.ACTIVE_TRAINER.deactivateClock();
			menuOptions = new Vector.<String>();
			var TRAINER_NAME:String = Configuration.ACTIVE_TRAINER.NAME;
			var trainerNameWidth:int = TRAINER_NAME.length * 7;
			var textBoxWidth:int = trainerNameWidth > 72 ? trainerNameWidth : 72;
			if (Configuration.ACTIVE_TRAINER.getState("POKéDEX") == "true") menuOptions.push("POKéDEX");
			if (Configuration.ACTIVE_TRAINER.getState("LRhaspokemon") == "true") menuOptions.push("POKéMON");
			menuOptions.push("BAG");
			if (Configuration.ACTIVE_TRAINER.getState("POKéNAV") == "true") menuOptions.push("POKéNAV");
			menuOptions.push(TRAINER_NAME, "SAVE", "OPTION", "EXIT");
			
			trace("REMINDER: TRAINER NAME cannot be an option within the InGameMenu.");
			uiQuestionTextBox = new UIQuestionTextBox(menuOptions, UIQuestionTextBox.AUTO_SCALE, 16 * menuOptions.length + 32, 14, 8, 14, 8, selectOption);
			uiQuestionTextBox.x = Configuration.VIEWPORT.width - uiQuestionTextBox.width;
			uiQuestionTextBox.selectLine(Configuration.IN_GAME_MENU_CURRENT_OPTION, false);
			this.addChild(uiQuestionTextBox);
			
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressCancel, InputGroups.IN_GAME_MENU, true);
			TweenLite.delayedCall(15, KeyboardManager.registerKey, [Configuration.START_KEY, pressCancel, InputGroups.IN_GAME_MENU, true], true);
			KeyboardManager.disableInputGroup(InputGroups.OVERWORLD);
		}
		
		private function pressCancel():void
		{
			_option = menuOptions[uiQuestionTextBox.CURRENT_LINE - 1];
			findCurrentOption();
			
			Configuration.ACTIVE_TRAINER.activateClock();
			SoundManager.playEnterKeySoundEffect();
			
			KeyboardManager.enableInputGroup(InputGroups.OVERWORLD);
			if (_callback != null) _callback();
			_callback = null;
			
			destroy();
		}
		
		private var _option:String;
		private function selectOption(option:String):void
		{
			_option = option;
			
			findCurrentOption();
			
			if (option == "EXIT")
			{
				exitMenu();
			} else
			if (option == "SAVE")
			{
				AccountManager.saveAccountWithMessage();
				exitMenu();
			}
			else 
			{
				KeyboardManager.disableInputGroup(InputGroups.OVERWORLD);
				Configuration.FADE_OUT_AND_IN(openMenu);
			}
		}
		
		private function openMenu():void
		{
			if (_option == "POKéDEX")
			{
				// Open the POKéDEX!
				destroy();
				Configuration.createMenu(MenuType.POKEDEX);
			} else
			if (_option == "POKéMON")
			{
				destroy();
				Configuration.createMenu(MenuType.POKEMON);
			} else
			if (_option == "BAG")
			{
				destroy();
				Configuration.createMenu(MenuType.BAG);
			} else
			if (_option == Configuration.ACTIVE_TRAINER.NAME)
			{
				destroy();
				Configuration.createMenu(MenuType.TRAINER);
			} else
			{
				MessageCenter.addMessage(Message.createMessage("Opening " + _option + " menu.", true));
				destroy();
			}
		}
		
		private function findCurrentOption():void 
		{
			for (var i:int = 0; i < menuOptions.length; i++)
			{
				if (menuOptions[i] == _option) Configuration.IN_GAME_MENU_CURRENT_OPTION = i + 1;
			}
		}
		
		private function exitMenu():void 
		{
			Configuration.ACTIVE_TRAINER.activateClock();
			KeyboardManager.enableInputGroup(InputGroups.OVERWORLD);
			if (_callback != null) _callback();
			_callback = null;
			destroy();
		}
		
		public function destroy():void
		{
			this.removeChild(uiQuestionTextBox);
			uiQuestionTextBox.destroy();
			uiQuestionTextBox = null;
			
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
			
			_callback = null;
			menuOptions = null;
			
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, pressCancel);
			KeyboardManager.unregisterKey(Configuration.START_KEY, pressCancel);
		}
		
	}

}