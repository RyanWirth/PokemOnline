package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.cloakentertainment.pokemonline.multiplayer.AccountManager;
	import com.cloakentertainment.pokemonline.multiplayer.AccountStatus;
	import flash.text.TextFieldType;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UICreateAccountNameMenu extends Sprite implements UIElement
	{
		private var _title:TextField;
		private var _usernameLabel:TextField;
		private var _passwordLabel:TextField;
		private var _passwordVerifyLabel:TextField;
		private var _usernameInput:TextField;
		private var _passwordVerifyInput:TextField;
		private var _passwordInput:TextField;
		private var _uiBox:UIBox;
		private var _loginButton:UITextBox;
		private var _belowUsernameInput:Sprite;
		private var _belowPasswordInput:Sprite;
		private var _belowPasswordVerifyInput:Sprite;
		private var _feedback:TextField;
		private var _successCallback:Function;
		
		public function UICreateAccountNameMenu(successCallback:Function):void
		{
			_successCallback = successCallback;
			construct();
		}
		
		public function construct():void
		{
			this.graphics.beginFill(0x8890f8, 1);
			this.graphics.drawRect(0, 0, Configuration.VIEWPORT.width, Configuration.VIEWPORT.height);
			this.graphics.endFill();
			
			_uiBox = new UIBox(200, 120);
			_uiBox.x = Configuration.VIEWPORT.width / 2 - _uiBox.width / 2;
			_uiBox.y = Configuration.VIEWPORT.height / 2 - _uiBox.height / 2;
			this.addChild(_uiBox);
			
			_title = new TextField();
			Configuration.setupTextfield(_title, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
			_title.width = 200 * Configuration.SPRITE_SCALE;
			_title.x = _uiBox.x + 8 * Configuration.SPRITE_SCALE;
			_title.y = _uiBox.y + 5 * Configuration.SPRITE_SCALE;
			_title.text = "PokémOnline: Create Account";
			this.addChild(_title);
			
			_usernameLabel = new TextField();
			Configuration.setupTextfield(_usernameLabel, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			_usernameLabel.textColor = 0x606060;
			_usernameLabel.width = 140 * Configuration.SPRITE_SCALE;
			_usernameLabel.x = _uiBox.x + 8 * Configuration.SPRITE_SCALE;
			_usernameLabel.y = _uiBox.y + 30 * Configuration.SPRITE_SCALE;
			_usernameLabel.text = "Username:";
			this.addChild(_usernameLabel);
			_passwordLabel = new TextField();
			Configuration.setupTextfield(_passwordLabel, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			_passwordLabel.textColor = 0x606060;
			_passwordLabel.width = 140 * Configuration.SPRITE_SCALE;
			_passwordLabel.x = _uiBox.x + 8 * Configuration.SPRITE_SCALE;
			_passwordLabel.y = _uiBox.y + 50 * Configuration.SPRITE_SCALE;
			_passwordLabel.text = "Password:";
			this.addChild(_passwordLabel);
			_passwordLabel.height = _usernameLabel.height = 14 * Configuration.SPRITE_SCALE;
			_passwordVerifyLabel = new TextField();
			Configuration.setupTextfield(_passwordVerifyLabel, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			_passwordVerifyLabel.textColor = 0x606060;
			_passwordVerifyLabel.width = 140 * Configuration.SPRITE_SCALE;
			_passwordVerifyLabel.x = _uiBox.x + 8 * Configuration.SPRITE_SCALE;
			_passwordVerifyLabel.y = _uiBox.y + 70 * Configuration.SPRITE_SCALE;
			_passwordVerifyLabel.text = "Password (Verify):";
			this.addChild(_passwordVerifyLabel);
			_passwordVerifyLabel.height = _usernameLabel.height = 14 * Configuration.SPRITE_SCALE;
			
			_usernameInput = new TextField();
			Configuration.setupTextfield(_usernameInput, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			_usernameInput.textColor = 0x606060;
			_usernameInput.selectable = true;
			_usernameInput.maxChars = 24;
			_usernameInput.restrict = "A-Za-z0-9";
			_usernameInput.type = TextFieldType.INPUT;
			_usernameInput.height = 14 * Configuration.SPRITE_SCALE;
			_usernameInput.width = 135 * Configuration.SPRITE_SCALE;
			_usernameInput.x = _uiBox.x + 56 * Configuration.SPRITE_SCALE;
			_usernameInput.y = _uiBox.y + 30 * Configuration.SPRITE_SCALE;
			_usernameInput.text = "";
			_usernameInput.multiline = false;
			_passwordInput = new TextField();
			Configuration.setupTextfield(_passwordInput, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			_passwordInput.textColor = 0x606060;
			_passwordInput.selectable = true;
			_passwordInput.height = 14 * Configuration.SPRITE_SCALE;
			_passwordInput.type = TextFieldType.INPUT;
			_passwordInput.width = 135 * Configuration.SPRITE_SCALE;
			_passwordInput.x = _usernameInput.x;
			_passwordInput.y = _passwordLabel.y;
			_passwordInput.multiline = false;
			_passwordInput.displayAsPassword = true;
			_passwordInput.text = "";
			_passwordVerifyInput = new TextField();
			Configuration.setupTextfield(_passwordVerifyInput, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			_passwordVerifyInput.textColor = 0x606060;
			_passwordVerifyInput.selectable = true;
			_passwordVerifyInput.height = 14 * Configuration.SPRITE_SCALE;
			_passwordVerifyInput.type = TextFieldType.INPUT;
			_passwordVerifyInput.width = 100 * Configuration.SPRITE_SCALE;
			_passwordVerifyInput.x = _usernameInput.x + 35 * Configuration.SPRITE_SCALE;
			_passwordVerifyInput.y = _passwordVerifyLabel.y;
			_passwordVerifyInput.multiline = false;
			_passwordVerifyInput.displayAsPassword = true;
			_passwordVerifyInput.text = "";
			
			_belowPasswordInput = new Sprite();
			_belowUsernameInput = new Sprite();
			_belowPasswordVerifyInput = new Sprite();
			_belowPasswordInput.graphics.beginFill(0xE1E1E1, 1);
			_belowPasswordInput.graphics.drawRoundRect(0, 0, _passwordInput.width + 4 * Configuration.SPRITE_SCALE, _passwordInput.height + 4 * Configuration.SPRITE_SCALE, 3 * Configuration.SPRITE_SCALE);
			_belowPasswordInput.graphics.endFill();
			_belowPasswordVerifyInput.graphics.beginFill(0xE1E1E1, 1);
			_belowPasswordVerifyInput.graphics.drawRoundRect(0, 0, _passwordVerifyInput.width + 4 * Configuration.SPRITE_SCALE, _passwordVerifyInput.height + 4 * Configuration.SPRITE_SCALE, 3 * Configuration.SPRITE_SCALE);
			_belowPasswordVerifyInput.graphics.endFill();
			_belowUsernameInput.graphics.beginFill(0xE1E1E1, 1);
			_belowUsernameInput.graphics.drawRoundRect(0, 0, _usernameInput.width + 4 * Configuration.SPRITE_SCALE, _usernameInput.height + 4 * Configuration.SPRITE_SCALE, 3 * Configuration.SPRITE_SCALE);
			_belowUsernameInput.graphics.endFill();
			
			_belowPasswordInput.x = _belowUsernameInput.x = _usernameInput.x - 2 * Configuration.SPRITE_SCALE;
			_belowPasswordVerifyInput.x = _passwordVerifyInput.x - 2 * Configuration.SPRITE_SCALE;
			_belowPasswordInput.y = _passwordInput.y - 1.5 * Configuration.SPRITE_SCALE;
			_belowUsernameInput.y = _usernameInput.y - 1.5 * Configuration.SPRITE_SCALE;
			_belowPasswordVerifyInput.y = _passwordVerifyInput.y - 1.5 * Configuration.SPRITE_SCALE;
			
			this.addChild(_belowUsernameInput);
			this.addChild(_belowPasswordInput);
			this.addChild(_belowPasswordVerifyInput);
			this.addChild(_usernameInput);
			this.addChild(_passwordInput);
			this.addChild(_passwordVerifyInput);
			
			_feedback = new TextField();
			Configuration.setupTextfield(_feedback, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			_feedback.textColor = 0x606060;
			_feedback.width = 100 * Configuration.SPRITE_SCALE;
			_feedback.height = 14 * Configuration.SPRITE_SCALE;
			_feedback.x = _uiBox.x + 8 * Configuration.SPRITE_SCALE;
			_feedback.y = _uiBox.y + _uiBox.height - _feedback.height - 6 * Configuration.SPRITE_SCALE;
			;
			_feedback.text = "";
			this.addChild(_feedback);
			
			_loginButton = new UITextBox("Create Account", 96, 24, 6, 4, 4, 4);
			this.addChild(_loginButton);
			_loginButton.x = _uiBox.x + _uiBox.width - _loginButton.width;
			_loginButton.y = _uiBox.y + _uiBox.height - _loginButton.height;
			_loginButton.buttonMode = true;
			_loginButton.addEventListener(MouseEvent.CLICK, login);
			
			Configuration.STAGE.focus = _usernameInput;
		}
		
		private function cancel(e:MouseEvent):void
		{
			removeEventListeners();
			
			Configuration.FADE_OUT_AND_IN(finishCancel);
		}
		
		private function finishCancel():void
		{
			destroy();
			Configuration.createMenu(MenuType.MAIN);
		}
		
		private function login(e:MouseEvent):void
		{
			if (_usernameInput.text == "")
			{
				_feedback.text = "Missing username.";
				return;
			}
			else if (_passwordInput.text == "")
			{
				_feedback.text = "Missing password.";
				return;
			} else if (_passwordInput.text != _passwordVerifyInput.text)
			{
				_feedback.text = "Password mismatch.";
				return;
			} else
			{
				switch(_usernameInput.text)
				{
					case "POKéDEX":
					case "POKéMON":
					case "BAG":
					case "POKéNAV":
					case "SAVE":
					case "OPTION":
					case "EXIT":
						_feedback.text = "Invalid username.";
						return;
						break;
				}
			}
			
			removeEventListeners();
			
			_feedback.text = "Creating account...";
			
			Configuration.ACTIVE_TRAINER.setName(_usernameInput.text);
			AccountManager.createAccount(_usernameInput.text, _passwordInput.text, Configuration.ACTIVE_TRAINER, createCallback);
			
			_belowPasswordInput.visible = _belowUsernameInput.visible = _belowPasswordVerifyInput.visible = false;
			_usernameInput.selectable = _passwordInput.selectable = _passwordVerifyInput.selectable = false;
		}
		
		private function createCallback(status:String):void
		{
			trace(status);
			var reset:Boolean = false;
			if (status == AccountStatus.CREATION_CREDENTIAL_MISSING)
			{
				_feedback.text = "Missing credential(s).";
				reset = true;
			} else
			if (status == AccountStatus.CREATION_FAILED)
			{
				_feedback.text = "Creation failed.";
				reset = true;
			} else
			if (status == AccountStatus.IO_ERROR)
			{
				_feedback.text = "Network error.";
				reset = true;
			} else
			if (status == AccountStatus.CREATION_NAME_TAKEN)
			{
				_feedback.text = "Username taken.";
				reset = true;
			} else
			if (status == AccountStatus.CREATION_SUCCESSFUL)
			{
				_feedback.text = "Creation successful!";
				Configuration.USERNAME = _usernameInput.text;
				Configuration.PASSWORD = _passwordInput.text;
				Configuration.FADE_OUT_AND_IN(finishAccountCreated);
			}
			
			
			
			if (reset)
			{
				_loginButton.addEventListener(MouseEvent.CLICK, login);
				_belowPasswordInput.visible = _belowUsernameInput.visible = _belowPasswordVerifyInput.visible = true;
				_usernameInput.selectable = _passwordInput.selectable = _passwordVerifyInput.selectable = true;
			}
		}
		
		private function finishAccountCreated():void
		{
			if (_successCallback != null) _successCallback();
			destroy();
		}
		
		private function removeEventListeners():void 
		{
			_loginButton.removeEventListener(MouseEvent.CLICK, login);
		}
		
		public function destroy():void
		{
			this.removeChild(_uiBox);
			_uiBox.destroy();
			_uiBox = null;
			
			this.removeChild(_title);
			this.removeChild(_usernameLabel);
			this.removeChild(_passwordLabel);
			this.removeChild(_passwordVerifyLabel);
			
			this.removeChild(_usernameInput);
			this.removeChild(_passwordInput);
			this.removeChild(_passwordVerifyInput);
			
			this.removeChild(_feedback);
			
			this.removeChild(_loginButton);
			_loginButton.destroy();
			_loginButton = null;
			
			this.graphics.clear();
			
			this.removeChild(_belowPasswordInput);
			this.removeChild(_belowPasswordVerifyInput);
			this.removeChild(_belowUsernameInput);
			_belowUsernameInput = _belowPasswordVerifyInput = _belowPasswordInput = null;
			
			_title = _usernameInput = _feedback = _usernameLabel = _passwordInput = _passwordLabel = _passwordVerifyInput = _passwordVerifyLabel = null;
		}
	
	}

}