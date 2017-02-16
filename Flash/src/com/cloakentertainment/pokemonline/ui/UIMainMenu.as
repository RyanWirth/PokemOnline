package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.ui.MessageCenter;
	import com.cloakentertainment.pokemonline.ui.Message;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIMainMenu extends Sprite implements UIElement
	{	
		private var _login:UITextBox;
		private var _newAccount:UITextBox;
		private var _options:UITextBox;
		private var _about:UITextBox;
		
		public function UIMainMenu() 
		{
			construct();
		}
		
		public function construct():void
		{
			this.graphics.beginFill(0x8890f8, 1);
			this.graphics.drawRect(0, 0, Configuration.VIEWPORT.width, Configuration.VIEWPORT.height);
			this.graphics.endFill();
			
			if (Configuration.MAIN_MENU_PLAYED_MESSAGES == false) TweenLite.delayedCall(20, createMessages, null, true);
			else createMessages();
		}
		
		public function destroy():void
		{
			this.graphics.clear();
			
			if (_login)
			{
				this.removeChild(_login);
				_login.destroy();
				
				this.removeChild(_newAccount);
				_newAccount.destroy();
				
				this.removeChild(_options);
				_options.destroy();
				
				this.removeChild(_about);
				_about.destroy();
				
				_login = _newAccount = _options = _about = null;
			}
			
			unregisterKeys();
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
		
		private function createMessages():void 
		{
			if (Configuration.MAIN_MENU_PLAYED_MESSAGES)
			{
				createOptions();
				return;
			}
			
			for (var i:int = 0; i < Configuration.MAIN_MENU_MOTDs.length; i++)
			{
				var data:Array = Configuration.MAIN_MENU_MOTDs[i].split("//");
				var canSkip:Boolean = data.length == 1 || data[1] == "true" ? true : false;
				MessageCenter.addMessage(Message.createMessage(data[0], canSkip, canSkip ? 0 : 2000, i == Configuration.MAIN_MENU_MOTDs.length - 1 ? createOptions : null));
			}
			
			if (Configuration.MAIN_MENU_MOTDs.length == 0) createOptions();
			//createOptions();
		}
		
		private function createOptions():void
		{
			Configuration.MAIN_MENU_PLAYED_MESSAGES = true;
			
			_login = new UITextBox("LOG IN", 224, 32, 7, 4, 7, 4);
			_login.y = 0;
			_login.x = Configuration.VIEWPORT.width / 2 - _login.width / 2;
			this.addChild(_login);
			
			_newAccount = new UITextBox("CREATE ACCOUNT", 224, 32, 7, 4, 7, 4);
			_newAccount.y = _login.height;
			_newAccount.x = _login.x;
			this.addChild(_newAccount);
			
			_options = new UITextBox("OPTIONS", 224, 32, 7, 4, 7, 4);
			_options.x = _login.x;
			_options.y = _newAccount.y + _newAccount.height;
			this.addChild(_options);
			
			_about = new UITextBox("ABOUT", 224, 32, 7, 4, 7, 4);
			_about.x = _login.x;
			_about.y = _options.y + _options.height;
			this.addChild(_about);
			
			selectOption(Configuration.MAIN_MENU_CURRENT_OPTION);
			
			TweenLite.delayedCall(15, registerKeys, null, true);
		}
		
		private function pressEnter():void
		{
			SoundManager.playEnterKeySoundEffect();
			switch(_selectedOpNum)
			{
				case 1:
					loginToAccount();
					break;
				case 2:
					createAccount();
					break;
			}
		}
		
		private function loginToAccount():void
		{
			unregisterKeys();
			Configuration.FADE_OUT_AND_IN(finishLoggingInToAccount);
		}
		
		private function finishLoggingInToAccount():void
		{
			destroy();
			Configuration.createMenu(MenuType.LOGIN);
		}
		
		private function createAccount():void
		{
			unregisterKeys();
			Configuration.FADE_OUT_AND_IN(finishCreatingAccount);
		}
		
		private function finishCreatingAccount():void
		{
			destroy();
			Configuration.createMenu(MenuType.CREATE_ACCOUNT);
		}
		
		private function pressUp():void
		{
			SoundManager.playEnterKeySoundEffect();
			selectOption(_selectedOpNum - 1);
		}
		
		private function pressDown():void
		{
			SoundManager.playEnterKeySoundEffect();
			selectOption(_selectedOpNum + 1);
		}
		
		private var _selectedOpNum:int;
		private function selectOption(opNum:int):void
		{
			if (opNum < 1) opNum = 4;
			if (opNum > 4) opNum = 1;
			
			_selectedOpNum = opNum;
			
			Configuration.MAIN_MENU_CURRENT_OPTION = _selectedOpNum;
			
			_login.dim();
			_newAccount.dim();
			_options.dim();
			_about.dim();
			
			switch(_selectedOpNum)
			{
				case 1:
					_login.undim();
					break;
				case 2:
					_newAccount.undim();
					break;
				case 3:
					_options.undim();
					break;
				case 4:
					_about.undim();
					break;
			}
		}
		
		private function unregisterKeys():void 
		{
			KeyboardManager.unregisterKey(Configuration.UP_KEY, pressUp);
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, pressDown);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, pressEnter);
		}
		
		private function registerKeys():void 
		{
			KeyboardManager.registerKey(Configuration.UP_KEY, pressUp, InputGroups.MAIN_MENU, true);
			KeyboardManager.registerKey(Configuration.DOWN_KEY, pressDown, InputGroups.MAIN_MENU, true);
			KeyboardManager.registerKey(Configuration.ENTER_KEY, pressEnter, InputGroups.MAIN_MENU, true);
		}
		
	}

}