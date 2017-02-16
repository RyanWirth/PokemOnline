package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.cloakentertainment.pokemonline.multiplayer.AccountManager;
	import com.cloakentertainment.pokemonline.multiplayer.AccountStatus;
	import com.cloakentertainment.pokemonline.GameManager;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.greensock.TweenLite;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import flash.text.TextFieldType;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UINicknameMenu extends Sprite implements UIElement
	{
		private var _title:TextField;
		private var _uiBox:UIBox;
		private var _nicknameLabel:TextField;
		private var _nicknameInput:TextField;
		private var _belowNicknameInput:Sprite;
		private var _confirmButton:UITextBox;
		private var _cancelButton:UITextBox;
		private var _sprite:UIPokemonAnimatedSprite;
		
		private var _finishedCallback:Function;
		
		public function UINicknameMenu(finishedCallback:Function = null):void
		{
			_finishedCallback = finishedCallback;
			construct();
		}
		
		public function construct():void
		{
			this.graphics.beginFill(0x8890f8, 1);
			this.graphics.drawRect(0, 0, Configuration.VIEWPORT.width, Configuration.VIEWPORT.height);
			this.graphics.endFill();
			
			_uiBox = new UIBox(200, 114);
			_uiBox.x = Configuration.VIEWPORT.width / 2 - _uiBox.width / 2;
			_uiBox.y = Configuration.VIEWPORT.height / 2 - _uiBox.height / 2;
			this.addChild(_uiBox);
			
			_title = new TextField();
			Configuration.setupTextfield(_title, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
			_title.width = 200 * Configuration.SPRITE_SCALE;
			_title.x = _uiBox.x + 8 * Configuration.SPRITE_SCALE;
			_title.y = _uiBox.y + 5 * Configuration.SPRITE_SCALE;
			_title.text = "PokémOnline: Name " + Configuration.ACTIVE_TRAINER.LAST_ADDED_POKEMON.NAME + "?";
			this.addChild(_title);
			
			_nicknameLabel = new TextField();
			Configuration.setupTextfield(_nicknameLabel, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			_nicknameLabel.textColor = 0x606060;
			_nicknameLabel.width = 140 * Configuration.SPRITE_SCALE;
			_nicknameLabel.x = _uiBox.x + 8 * Configuration.SPRITE_SCALE;
			_nicknameLabel.y = _uiBox.y + 26 * Configuration.SPRITE_SCALE;
			_nicknameLabel.text = "Nickname:";
			this.addChild(_nicknameLabel);
			_nicknameLabel.height = 14 * Configuration.SPRITE_SCALE;
			
			_nicknameInput = new TextField();
			Configuration.setupTextfield(_nicknameInput, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			_nicknameInput.textColor = 0x606060;
			_nicknameInput.selectable = true;
			_nicknameInput.type = TextFieldType.INPUT;
			_nicknameInput.maxChars = 12;
			_nicknameInput.height = 14 * Configuration.SPRITE_SCALE;
			_nicknameInput.width = 135 * Configuration.SPRITE_SCALE;
			_nicknameInput.x = _uiBox.x + 56 * Configuration.SPRITE_SCALE;
			_nicknameInput.y = _uiBox.y + 26 * Configuration.SPRITE_SCALE;
			_nicknameInput.text = "";
			_nicknameInput.restrict = "A-Za-z0-9";
			_nicknameInput.multiline = false;
			
			_belowNicknameInput = new Sprite();
			_belowNicknameInput.graphics.beginFill(0xE1E1E1, 1);
			_belowNicknameInput.graphics.drawRoundRect(0, 0, _nicknameInput.width + 4 * Configuration.SPRITE_SCALE, _nicknameInput.height + 4 * Configuration.SPRITE_SCALE, 3 * Configuration.SPRITE_SCALE);
			_belowNicknameInput.graphics.endFill();
			
			_belowNicknameInput.x = _nicknameInput.x - 2 * Configuration.SPRITE_SCALE;
			_belowNicknameInput.y = _nicknameInput.y - 1.5 * Configuration.SPRITE_SCALE;
			
			this.addChild(_belowNicknameInput);
			this.addChild(_nicknameInput);
			
			_confirmButton = new UITextBox("Confirm", 50, 24, 6, 4, 4, 4);
			this.addChild(_confirmButton);
			_confirmButton.x = _uiBox.x + _uiBox.width - _confirmButton.width;
			_confirmButton.y = _uiBox.y + _uiBox.height - _confirmButton.height;
			_confirmButton.buttonMode = true;
			_confirmButton.addEventListener(MouseEvent.CLICK, pressConfirm);
			
			_cancelButton = new UITextBox("Cancel", 46, 24, 6, 4, 4, 4);
			this.addChild(_cancelButton);
			_cancelButton.x = _uiBox.x;
			_cancelButton.y = _uiBox.y + _uiBox.height - _cancelButton.height;
			_cancelButton.buttonMode = true;
			_cancelButton.addEventListener(MouseEvent.CLICK, pressCancel);
			
			_sprite = new UIPokemonAnimatedSprite(Configuration.ACTIVE_TRAINER.LAST_ADDED_POKEMON.base.ID, Configuration.ACTIVE_TRAINER.LAST_ADDED_POKEMON.SHINY, Configuration.ACTIVE_TRAINER.LAST_ADDED_POKEMON.FORM, true, true);
			_sprite.x = _uiBox.x + _uiBox.width / 2;
			_sprite.y = _uiBox.y + _uiBox.height - _sprite.height / 2 - 6 * Configuration.SPRITE_SCALE;
			_sprite.mouseChildren = false;
			_sprite.mouseEnabled = false;
			this.addChild(_sprite);
			
			TweenLite.delayedCall(30, KeyboardManager.registerKey, [13, pressEnter, InputGroups.NICKNAME_MENU, true], true);
			
			Configuration.STAGE.focus = _nicknameInput;
		}
		
		private function pressConfirm(e:MouseEvent):void
		{
			_belowNicknameInput.visible = false;
			_nicknameInput.type = TextFieldType.DYNAMIC;
			Configuration.ACTIVE_TRAINER.LAST_ADDED_POKEMON.setName(_nicknameInput.text != "" ? _nicknameInput.text : Configuration.ACTIVE_TRAINER.LAST_ADDED_POKEMON.NAME);
			
			_confirmButton.removeEventListener(MouseEvent.CLICK, pressConfirm);
			_cancelButton.removeEventListener(MouseEvent.CLICK, pressCancel);
			KeyboardManager.unregisterKey(13, pressEnter);
			
			Configuration.FADE_OUT_AND_IN(destroyMenu);
			
			SoundManager.playEnterKeySoundEffect();
		}
		
		private function destroyMenu():void
		{
			destroy();
		}
		
		private function pressCancel(e:MouseEvent):void
		{
			_belowNicknameInput.visible = false;
			_nicknameInput.type = TextFieldType.DYNAMIC;
			Configuration.ACTIVE_TRAINER.LAST_ADDED_POKEMON.setName(Configuration.ACTIVE_TRAINER.LAST_ADDED_POKEMON.NAME);
			
			_confirmButton.removeEventListener(MouseEvent.CLICK, pressConfirm);
			_cancelButton.removeEventListener(MouseEvent.CLICK, pressCancel);
			KeyboardManager.unregisterKey(13, pressEnter);
			
			Configuration.FADE_OUT_AND_IN(destroyMenu);
			
			SoundManager.playEnterKeySoundEffect();
		}
		
		private function pressEnter():void
		{
			pressConfirm(null);
		}
		
		
		public function destroy():void
		{
			
			this.graphics.clear();
			
			this.removeChild(_uiBox);
			_uiBox.destroy();
			_uiBox = null;
			
			this.removeChild(_title);
			_title = null;
			
			this.removeChild(_cancelButton);
			this.removeChild(_confirmButton);
			this.removeChild(_nicknameInput);
			this.removeChild(_nicknameLabel);
			this.removeChild(_belowNicknameInput);
			
			_belowNicknameInput.graphics.clear();
			_belowNicknameInput = null;
			
			_cancelButton.destroy();
			_confirmButton.destroy();
			
			this.removeChild(_sprite);
			_sprite.destroy();
			_sprite = null;
			
			_cancelButton = _confirmButton = null;
			_nicknameLabel = _nicknameInput = null;
			
			if (_finishedCallback != null) _finishedCallback();
			_finishedCallback = null;
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
	
	}

}