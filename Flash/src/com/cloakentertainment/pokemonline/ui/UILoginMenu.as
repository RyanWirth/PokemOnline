package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.cloakentertainment.pokemonline.multiplayer.AccountManager;
	import com.cloakentertainment.pokemonline.multiplayer.AccountStatus;
	import com.cloakentertainment.pokemonline.GameManager;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import flash.text.TextFieldType;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UILoginMenu extends Sprite implements UIElement
	{
		private var _title:TextField;
		private var _usernameLabel:TextField;
		private var _passwordLabel:TextField;
		private var _usernameInput:TextField;
		private var _passwordInput:TextField;
		private var _uiBox:UIBox;
		private var _loginButton:UITextBox;
		private var _belowUsernameInput:Sprite;
		private var _belowPasswordInput:Sprite;
		private var _feedback:TextField;
		private var _cancelButton:UITextBox;
		
		public function UILoginMenu():void
		{
			construct();
		}
		
		public function construct():void
		{
			this.graphics.beginFill(0x8890f8, 1);
			this.graphics.drawRect(0, 0, Configuration.VIEWPORT.width, Configuration.VIEWPORT.height);
			this.graphics.endFill();
			
			_uiBox = new UIBox(200, 100);
			_uiBox.x = Configuration.VIEWPORT.width / 2 - _uiBox.width / 2;
			_uiBox.y = Configuration.VIEWPORT.height / 2 - _uiBox.height / 2;
			this.addChild(_uiBox);
			
			_title = new TextField();
			Configuration.setupTextfield(_title, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
			_title.width = 140 * Configuration.SPRITE_SCALE;
			_title.x = _uiBox.x + 8 * Configuration.SPRITE_SCALE;
			_title.y = _uiBox.y + 5 * Configuration.SPRITE_SCALE;
			_title.text = "PokémOnline: Log In";
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
			
			_usernameInput = new TextField();
			Configuration.setupTextfield(_usernameInput, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			_usernameInput.textColor = 0x606060;
			_usernameInput.selectable = true;
			_usernameInput.type = TextFieldType.INPUT;
			_usernameInput.height = 14 * Configuration.SPRITE_SCALE;
			_usernameInput.width = 135 * Configuration.SPRITE_SCALE;
			_usernameInput.x = _uiBox.x + 56 * Configuration.SPRITE_SCALE;
			_usernameInput.y = _uiBox.y + 30 * Configuration.SPRITE_SCALE;
			_usernameInput.text = "";
			_usernameInput.restrict = "A-Za-z0-9";
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
			
			_belowPasswordInput = new Sprite();
			_belowUsernameInput = new Sprite();
			_belowPasswordInput.graphics.beginFill(0xE1E1E1, 1);
			_belowPasswordInput.graphics.drawRoundRect(0, 0, _passwordInput.width + 4 * Configuration.SPRITE_SCALE, _passwordInput.height + 4 * Configuration.SPRITE_SCALE, 3 * Configuration.SPRITE_SCALE);
			_belowPasswordInput.graphics.endFill();
			_belowUsernameInput.graphics.beginFill(0xE1E1E1, 1);
			_belowUsernameInput.graphics.drawRoundRect(0, 0, _usernameInput.width + 4 * Configuration.SPRITE_SCALE, _usernameInput.height + 4 * Configuration.SPRITE_SCALE, 3 * Configuration.SPRITE_SCALE);
			_belowUsernameInput.graphics.endFill();
			
			_belowPasswordInput.x = _belowUsernameInput.x = _usernameInput.x - 2 * Configuration.SPRITE_SCALE;
			_belowPasswordInput.y = _passwordInput.y - 1.5 * Configuration.SPRITE_SCALE;
			_belowUsernameInput.y = _usernameInput.y - 1.5 * Configuration.SPRITE_SCALE;
			
			this.addChild(_belowUsernameInput);
			this.addChild(_belowPasswordInput);
			this.addChild(_usernameInput);
			this.addChild(_passwordInput);
			
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
			
			_loginButton = new UITextBox("Log In", 46, 24, 6, 4, 4, 4);
			this.addChild(_loginButton);
			_loginButton.x = _uiBox.x + _uiBox.width - _loginButton.width;
			_loginButton.y = _uiBox.y + _uiBox.height - _loginButton.height;
			_loginButton.buttonMode = true;
			_loginButton.addEventListener(MouseEvent.CLICK, login);
			
			_cancelButton = new UITextBox("Cancel", 46, 24, 6, 4, 4, 4);
			this.addChild(_cancelButton);
			_cancelButton.x = _uiBox.x;
			_cancelButton.y = _uiBox.y + _uiBox.height - _loginButton.height;
			_cancelButton.buttonMode = true;
			_cancelButton.addEventListener(MouseEvent.CLICK, cancel);
			
			_feedback.x += _cancelButton.width;
			
			KeyboardManager.registerKey(13, pressEnter, InputGroups.LOGIN_MENU, true);
			
			Configuration.STAGE.focus = _usernameInput;
			
			
			
			// AUTOMATIC LOGIN
			_usernameInput.text = "PROWNE";
			_passwordInput.text = "297029002";
			//pressEnter();
		}
		
		private function pressEnter():void
		{
			if (_belowPasswordInput.visible == false) return;
			
			login(null);
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
			}
			
			removeEventListeners();
			
			_feedback.text = "Logging in...";
			
			AccountManager.retrieveAccount(_usernameInput.text, _passwordInput.text, loginCallback);
			
			_belowPasswordInput.visible = _belowUsernameInput.visible = false;
			_usernameInput.selectable = _passwordInput.selectable = false;
		}
		
		private function loginCallback(status:String):void
		{
			trace(status);
			var reset:Boolean = false;
			if (status == AccountStatus.AUTHENTICATION_FAILED)
			{
				_feedback.text = "Invalid credential(s).";
				reset = true;
			} else
			if (status == AccountStatus.RETRIEVE_ACCOUNT_SUCCESSFUL)
			{
				_feedback.text = "Logged in!";
				Configuration.USERNAME = _usernameInput.text;
				Configuration.PASSWORD = _passwordInput.text;
				Configuration.FADE_OUT_AND_IN(finishLogin);
			} else
			if (status == AccountStatus.IO_ERROR)
			{
				_feedback.text = "Network error.";
				reset = true;
			}
			
			
			
			if (reset)
			{
				_loginButton.addEventListener(MouseEvent.CLICK, login);
				_cancelButton.addEventListener(MouseEvent.CLICK, cancel);
				_belowPasswordInput.visible = _belowUsernameInput.visible = true;
				_usernameInput.selectable = _passwordInput.selectable = true;
			}
		}
		
		private function finishLogin():void
		{
			destroy();
			
			GameManager.enterOverworld();
		}
		
		private function removeEventListeners():void 
		{
			_loginButton.removeEventListener(MouseEvent.CLICK, login);
			_cancelButton.removeEventListener(MouseEvent.CLICK, cancel);
		}
		
		public function destroy():void
		{
			this.graphics.clear();
			
			this.removeChild(_uiBox);
			_uiBox.destroy();
			_uiBox = null;
			
			this.removeChild(_title);
			this.removeChild(_usernameLabel);
			this.removeChild(_passwordLabel);
			
			this.removeChild(_loginButton);
			_loginButton.destroy();
			_loginButton = null;
			
			this.removeChild(_cancelButton);
			_cancelButton.destroy();
			_cancelButton = null;
			
			this.removeChild(_feedback);
			this.removeChild(_usernameInput);
			this.removeChild(_passwordInput);
			
			this.removeChild(_belowPasswordInput);
			this.removeChild(_belowUsernameInput);
			_belowUsernameInput = _belowPasswordInput = null;
			
			_title = _usernameInput = _usernameLabel = _feedback = _passwordInput = _passwordLabel = null;
			
			KeyboardManager.unregisterKey(13, pressEnter);
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
	
	}

}