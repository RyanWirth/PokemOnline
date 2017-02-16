package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.greensock.easing.Sine;
	import com.cloakentertainment.pokemonline.battle.BattleManager;
	import flash.display.Sprite;
	import com.cloakentertainment.pokemonline.stats.PokemonFactory;
	import com.cloakentertainment.pokemonline.battle.BattleSpecialTile;
	import com.cloakentertainment.pokemonline.multiplayer.AccountManager;
	import com.cloakentertainment.pokemonline.battle.BattleWeatherEffect;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSelectMenu extends UISprite
	{
		[Embed(source = "assets/UIPokemonSelectMenu.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _background:Bitmap;
		private var _bag:Bitmap;
		private var _message:UITextBox;
		private var _hand:Bitmap;
		
		private var _textdesc:Bitmap;
		private var _texttitle:Bitmap;
		private var _greybox:Sprite;
		
		private var _circle:UIPokemonSelectMenuCircle;
		private var _pokemon:UIPokemonSprite;
		private var _questionBox:UIQuestionTextBox;
		
		private var _ball1:UIPokemonSelectMenuPokeball;
		private var _ball2:UIPokemonSelectMenuPokeball;
		private var _ball3:UIPokemonSelectMenuPokeball;
		
		private var _selectedPokeball:int = 1;
		private var _callback:Function;
		private var _destroyCallback:Function;
		
		public function UIPokemonSelectMenu(callback:Function = null, destroyCallback:Function = null)
		{
			super(spriteImage);
			
			_callback = callback;
			_destroyCallback = destroyCallback;
			
			construct();
		}
		
		override public function construct():void
		{
			_background = getSprite(0, 0, 240, 160);
			this.addChild(_background);
			
			_bag = getSprite(0, 161, 110, 64);
			_bag.x = 65 * Configuration.SPRITE_SCALE;
			_bag.y = 8 * Configuration.SPRITE_SCALE;
			this.addChild(_bag);
			
			_message = new UITextBox("", 208, 48, 8, 8, 6, 8, -1);
			_message.x = 16 * Configuration.SPRITE_SCALE;
			_message.y = 112 * Configuration.SPRITE_SCALE;
			this.addChild(_message);
			birchNeedsHelp();
			
			_ball1 = new UIPokemonSelectMenuPokeball();
			_ball1.x = 50 * Configuration.SPRITE_SCALE;
			_ball1.y = 54 * Configuration.SPRITE_SCALE;
			this.addChild(_ball1);
			_ball2 = new UIPokemonSelectMenuPokeball(false);
			_ball2.x = 110 * Configuration.SPRITE_SCALE;
			_ball2.y = 78 * Configuration.SPRITE_SCALE;
			this.addChild(_ball2);
			_ball3 = new UIPokemonSelectMenuPokeball(false);
			_ball3.x = 170 * Configuration.SPRITE_SCALE;
			_ball3.y = 54 * Configuration.SPRITE_SCALE;
			this.addChild(_ball3);
			
			_hand = getSprite(180, 161, 25, 27);
			this.addChild(_hand);
			
			_greybox = new Sprite();
			_greybox.graphics.beginFill(0x000000, 0.5);
			_greybox.graphics.drawRect(0, 0, 50, 50);
			_greybox.graphics.endFill();
			this.addChild(_greybox);
			
			selectPokeball(1);
			
			KeyboardManager.registerKey(Configuration.LEFT_KEY, pressLeft, InputGroups.POKEMON_SELECT_MENU, true);
			KeyboardManager.registerKey(Configuration.RIGHT_KEY, pressRight, InputGroups.POKEMON_SELECT_MENU, true);
			KeyboardManager.registerKey(Configuration.ENTER_KEY, pressEnter, InputGroups.POKEMON_SELECT_MENU, true);
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressCancel, InputGroups.POKEMON_SELECT_MENU, true);
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.POKEMON_SELECT_MENU);
		}
		
		private function birchNeedsHelp():void
		{
			if (!_message) return;
			
			_message.TEXT_FIELD.text = "PROF. BIRCH is in trouble!\nRelease a POKéMON and rescue him!";
		}
		
		private function doYouChooseThisPokemon():void
		{
			_message.TEXT_FIELD.text = "Do you choose this POKéMON?";
		}
		
		private function pressLeft():void
		{
			if (_questionBox != null) return;
			
			if (_selectedPokeball > 1) selectPokeball(_selectedPokeball - 1);
		}
		
		private function pressRight():void
		{
			if (_questionBox != null) return;
			
			if (_selectedPokeball < 3) selectPokeball(_selectedPokeball + 1);
		}
		
		private function pressEnter():void
		{
			if (_circle != null) return;
			
			_circle = new UIPokemonSelectMenuCircle();
			_circle.width = _circle.height = 4 * Configuration.SPRITE_SCALE;
			this.addChild(_circle);
			
			var pokID:int = 1;
			switch (_selectedPokeball)
			{
			case 1: 
				pokID = 252;
				_circle.x = _ball1.x;
				_circle.y = _ball1.y;
				break;
			case 2: 
				pokID = 255;
				_circle.x = _ball2.x;
				_circle.y = _ball2.y;
				break;
			case 3: 
				pokID = 258;
				_circle.x = _ball3.x;
				_circle.y = _ball3.y;
				break;
			}
			
			_hand.visible = _textdesc.visible = _texttitle.visible = _greybox.visible = false;
			
			_pokemon = new UIPokemonSprite(pokID, false);
			var origWidth:int = _pokemon.width;
			var origHeight:int = _pokemon.height;
			_pokemon.width = _pokemon.height = 2 * Configuration.SPRITE_SCALE;
			_pokemon.x = _circle.x + _circle.width / 2 - _pokemon.width / 2;
			_pokemon.y = _circle.y + _circle.height / 2 - _pokemon.height / 2;
			this.addChild(_pokemon);
			
			TweenLite.to(_circle, 0.75, {x: 80 * Configuration.SPRITE_SCALE, y: 24 * Configuration.SPRITE_SCALE, width: 81 * Configuration.SPRITE_SCALE, height: 81 * Configuration.SPRITE_SCALE, onComplete: askQuestion});
			TweenLite.to(_pokemon, 0.75, {x: 80 * Configuration.SPRITE_SCALE + 81 * 0.5 * Configuration.SPRITE_SCALE - origWidth / 2, y: 24 * Configuration.SPRITE_SCALE + 81 * 0.5 * Configuration.SPRITE_SCALE - origHeight / 2, width: origWidth, height: origHeight});
		}
		
		private function askQuestion():void
		{
			doYouChooseThisPokemon();
			var options:Vector.<String> = new <String>["YES", "NO"];
			_questionBox = new UIQuestionTextBox(options, 56, 48, 14, 8, 7, 8, getAnswer);
			_questionBox.x = 184 * Configuration.SPRITE_SCALE;
			_questionBox.y = 64 * Configuration.SPRITE_SCALE;
			this.addChild(_questionBox);
			
			SoundManager.playPokemonCry(_pokemon.ID);
			
			KeyboardManager.enableInputGroup(InputGroups.POKEMON_SELECT_MENU);
			KeyboardManager.disableInputGroup(InputGroups.OVERWORLD);
		}
		
		private function getAnswer(ans:String):void
		{
			if (ans == "NO")
			{
				pressCancel(false);
			}
			else
			{
				// Add the Pokemon to the user's party
				var pokemonName:String = (_selectedPokeball == 3 ? "Mudkip" : (_selectedPokeball == 2 ? "Torchic" : "Treecko"));
				var pokemon:Pokemon = PokemonFactory.createPokemon(pokemonName, 5, "Route 101");
				
				if (pokemonName == "Treecko") pokemon.setAbility("Overgrow");
				else if (pokemonName == "Torchic")
					pokemon.setAbility("Blaze");
				else if (pokemonName == "Mudkip") pokemon.setAbility("Torrent");
				
				pokemon.setOTName(Configuration.ACTIVE_TRAINER.NAME);
				pokemon.setTrainer(Configuration.ACTIVE_TRAINER);
				
				Configuration.ACTIVE_TRAINER.addPokemonToParty(pokemon);
				var wildPokemon:Pokemon = PokemonFactory.createPokemon("Zigzagoon", 2, "Route 101");
				BattleManager.startWildBattle(wildPokemon, BattleSpecialTile.LONG_GRASS, BattleWeatherEffect.CLEAR_SKIES, destroy, true, _callback);
				unregisterKeys();
			}
		}
		
		private function pressCancel(sound:Boolean = true):void
		{
			destroyPokemon();
			destroyQuestion();
			
			if (sound) SoundManager.playEnterKeySoundEffect();
			
			selectPokeball(_selectedPokeball);
			KeyboardManager.enableInputGroup(InputGroups.POKEMON_SELECT_MENU);
			KeyboardManager.disableInputGroup(InputGroups.OVERWORLD);
		}
		
		private function destroyQuestion():void
		{
			if (_questionBox)
			{
				this.removeChild(_questionBox);
				_questionBox.destroy();
				_questionBox = null;
			}
		}
		
		private function destroyPokemon():void
		{
			if (_circle)
			{
				TweenLite.killTweensOf(_circle);
				this.removeChild(_circle);
				_circle.destroy();
				_circle = null;
			}
			
			if (_pokemon)
			{
				TweenLite.killTweensOf(_pokemon);
				this.removeChild(_pokemon);
				_pokemon.destroy();
				_pokemon = null;
			}
			
			birchNeedsHelp();
		}
		
		private function selectPokeball(pokeballNum:int):void
		{
			_selectedPokeball = pokeballNum;
			TweenLite.killTweensOf(_hand);
			
			destroyText();
			
			_greybox.visible = _hand.visible = true;
			
			if (_selectedPokeball == 1)
			{
				_ball1.startAnimation();
				_ball2.stopAnimation();
				_ball3.stopAnimation();
				_hand.x = _ball1.x;
				_hand.y = _ball1.y - _hand.height;
				_greybox.width = 108 * Configuration.SPRITE_SCALE;
				_greybox.height = 32 * Configuration.SPRITE_SCALE;
				_greybox.x = 0;
				_greybox.y = 72 * Configuration.SPRITE_SCALE;
				_textdesc = getSprite(108, 227, 86, 10);
				_texttitle = getSprite(130, 243, 42, 10);
				_textdesc.x = 9 * Configuration.SPRITE_SCALE;
				_textdesc.y = 76 * Configuration.SPRITE_SCALE;
				_texttitle.x = 31 * Configuration.SPRITE_SCALE;
				_texttitle.y = 92 * Configuration.SPRITE_SCALE;
				this.addChild(_textdesc);
				this.addChild(_texttitle);
			}
			else if (_selectedPokeball == 2)
			{
				_ball1.stopAnimation();
				_ball2.startAnimation();
				_ball3.stopAnimation();
				_hand.x = _ball2.x;
				_hand.y = _ball2.y - _hand.height;
				_greybox.width = 112 * Configuration.SPRITE_SCALE;
				_greybox.height = 32 * Configuration.SPRITE_SCALE;
				_greybox.x = 124 * Configuration.SPRITE_SCALE;
				_greybox.y = 80 * Configuration.SPRITE_SCALE;
				_textdesc = getSprite(112, 183, 62, 10);
				_texttitle = getSprite(177, 199, 42, 10);
				_textdesc.x = 149 * Configuration.SPRITE_SCALE;
				_textdesc.y = 84 * Configuration.SPRITE_SCALE;
				_texttitle.x = 159 * Configuration.SPRITE_SCALE;
				_texttitle.y = 100 * Configuration.SPRITE_SCALE;
				this.addChild(_textdesc);
				this.addChild(_texttitle);
			}
			else if (_selectedPokeball == 3)
			{
				_ball1.stopAnimation();
				_ball2.stopAnimation();
				_ball3.startAnimation();
				_hand.x = _ball3.x;
				_hand.y = _ball3.y - _hand.height;
				_greybox.width = 112 * Configuration.SPRITE_SCALE;
				_greybox.height = 32 * Configuration.SPRITE_SCALE;
				_greybox.x = 60 * Configuration.SPRITE_SCALE;
				_greybox.y = 32 * Configuration.SPRITE_SCALE;
				_textdesc = getSprite(160, 213, 75, 10);
				_texttitle = getSprite(204, 226, 36, 10);
				_textdesc.x = 78 * Configuration.SPRITE_SCALE;
				_textdesc.y = 36 * Configuration.SPRITE_SCALE;
				_texttitle.x = 98 * Configuration.SPRITE_SCALE;
				_texttitle.y = 52 * Configuration.SPRITE_SCALE;
				this.addChild(_textdesc);
				this.addChild(_texttitle);
			}
			
			tweenUp();
		}
		
		private function tweenUp():void
		{
			TweenLite.to(_hand, 0.65, {y: _hand.y - _hand.height * 0.75, onComplete: tweenDown, ease: Sine.easeIn});
		}
		
		private function tweenDown():void
		{
			TweenLite.to(_hand, 0.65, {y: _hand.y + _hand.height * 0.75, onComplete: tweenUp, ease: Sine.easeOut});
		}
		
		private function destroyText():void
		{
			if (_textdesc)
			{
				this.removeChild(_textdesc);
				_textdesc.bitmapData.dispose();
				_textdesc = null;
			}
			if (_texttitle)
			{
				this.removeChild(_texttitle);
				_texttitle.bitmapData.dispose();
				_texttitle = null;
			}
		}
		
		private function unregisterKeys():void 
		{
			KeyboardManager.unregisterKey(Configuration.RIGHT_KEY, pressRight);
			KeyboardManager.unregisterKey(Configuration.LEFT_KEY, pressLeft);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, pressEnter);
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, pressCancel);
		}
		
		override public function destroy():void
		{
			TweenLite.killTweensOf(_hand);
			unregisterKeys();
			
			this.removeChild(_background);
			_background.bitmapData.dispose();
			_background = null;
			
			this.removeChild(_bag);
			_bag.bitmapData.dispose();
			_bag = null;
			
			this.removeChild(_message);
			_message.destroy();
			_message = null;
			
			this.removeChild(_ball1);
			this.removeChild(_ball2);
			this.removeChild(_ball3);
			_ball1.destroy();
			_ball2.destroy();
			_ball3.destroy();
			_ball1 = _ball2 = _ball3 = null;
			
			this.removeChild(_hand);
			_hand.bitmapData.dispose();
			_hand = null;
			
			destroyText();
			
			this.removeChild(_greybox);
			_greybox.graphics.clear();
			_greybox = null;
			
			destroyPokemon();
			destroyQuestion();
			
			KeyboardManager.disableInputGroup(InputGroups.OVERWORLD);
			
			if (_destroyCallback != null) _destroyCallback();
			_destroyCallback = null;
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
	
	}

}