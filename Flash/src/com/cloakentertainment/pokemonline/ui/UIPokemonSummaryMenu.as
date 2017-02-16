package com.cloakentertainment.pokemonline.ui
{
	import adobe.utils.CustomActions;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonFactory;
	import com.cloakentertainment.pokemonline.stats.PokemonAbilities;
	import com.cloakentertainment.pokemonline.ui.UIPokedexMenuPokemonText;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.stats.PokemonGender;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSummaryMenu extends UISprite implements UIElement
	{
		[Embed(source="assets/UIPokemonSummaryMenu.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var pokemon:Pokemon;
		private var _finishedSummaryCallback:Function;
		
		private var _windowicon:Bitmap;
		private var _topbar:Bitmap;
		private var _sidewindow:Bitmap;
		private var windows:Vector.<UIPokemonSummaryMenuWindow> = new Vector.<UIPokemonSummaryMenuWindow>();
		private var animatedPokemonSprite:UIPokemonAnimatedSprite;
		private var pokeballIcon:UIPokeballIcon;
		private var gender:Bitmap;
		
		private var numberText:TextField;
		private var nameText:TextField;
		private var speciesText:TextField;
		private var levelText:TextField;
		private var windowTitle:TextField;
		
		private var currentWindow:int = 1;
		
		private var _learningMove:String;
		private var _learningPokemon:Pokemon;
		
		public function UIPokemonSummaryMenu(_pokemon:Pokemon, finishedSummaryCallback:Function, learningMove:String = "", learningPokemon:Pokemon = null)
		{
			super(spriteImage);
			
			pokemon = _pokemon;
			_learningMove = learningMove;
			_finishedSummaryCallback = finishedSummaryCallback;
			_learningPokemon = learningPokemon;
			
			construct();
		}
		
		override public function construct():void
		{
			_topbar = getSprite(0, 0, 240, 21);
			this.addChild(_topbar);
			_sidewindow = getSprite(0, 21, 80, 139);
			_sidewindow.y = 21 * Configuration.SPRITE_SCALE;
			this.addChild(_sidewindow);
			
			animatedPokemonSprite = new UIPokemonAnimatedSprite(pokemon.base.ID, pokemon.SHINY, pokemon.FORM);
			animatedPokemonSprite.scaleX *= -1; // Flip in X direction
			animatedPokemonSprite.x = (8 + 32) * Configuration.SPRITE_SCALE;
			animatedPokemonSprite.y = (32 + 32) * Configuration.SPRITE_SCALE;
			this.addChild(animatedPokemonSprite);
			
			pokeballIcon = new UIPokeballIcon(pokemon.POKEBALL_TYPE);
			pokeballIcon.x = 10 * Configuration.SPRITE_SCALE + pokeballIcon.width / 2;
			pokeballIcon.y = 130 * Configuration.SPRITE_SCALE + pokeballIcon.height / 2;
			this.addChild(pokeballIcon);
			
			if (pokemon.GENDER == PokemonGender.MALE || pokemon.GENDER == PokemonGender.FEMALE)
			{
				gender = getSprite(663 + (pokemon.GENDER == PokemonGender.FEMALE ? 6 : 0), 0, 6, 11);
				gender.x = 65 * Configuration.SPRITE_SCALE;
				gender.y = 131 * Configuration.SPRITE_SCALE;
				this.addChild(gender);
			}
			
			numberText = new TextField();
			nameText = new TextField();
			speciesText = new TextField();
			levelText = new TextField();
			windowTitle = new TextField();
			Configuration.setupTextfield(windowTitle, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
			Configuration.setupTextfield(numberText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
			Configuration.setupTextfield(nameText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
			Configuration.setupTextfield(speciesText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
			Configuration.setupTextfield(levelText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
			
			windowTitle.x = 1 * Configuration.SPRITE_SCALE;
			windowTitle.y = 1 * Configuration.SPRITE_SCALE;
			windowTitle.width = 90 * Configuration.SPRITE_SCALE;
			
			numberText.x = 8 * Configuration.SPRITE_SCALE;
			numberText.y = 18 * Configuration.SPRITE_SCALE;
			numberText.text = "No" + (pokemon.base.regionalPokedexNumbers[0] < 100 ? "0" : "") + (pokemon.base.regionalPokedexNumbers[0] < 10 ? "0" : "") + pokemon.base.regionalPokedexNumbers[0];
			
			nameText.x = 8 * Configuration.SPRITE_SCALE;
			nameText.y = 98 * Configuration.SPRITE_SCALE;
			nameText.width = 64 * Configuration.SPRITE_SCALE;
			nameText.text = pokemon.NAME;
			
			speciesText.x = 8 * Configuration.SPRITE_SCALE;
			speciesText.y = 114 * Configuration.SPRITE_SCALE;
			speciesText.width = 64 * Configuration.SPRITE_SCALE;
			speciesText.text = "/" + pokemon.base.name.toUpperCase();
			
			levelText.x = 32 * Configuration.SPRITE_SCALE;
			levelText.y = 130 * Configuration.SPRITE_SCALE;
			levelText.text = "Lv" + pokemon.LEVEL;
			
			this.addChild(numberText);
			this.addChild(nameText);
			this.addChild(speciesText);
			this.addChild(levelText);
			this.addChild(windowTitle);
			
			// Play the pokemon's cry
			if(_learningMove == "") SoundManager.playPokemonCry(pokemon.base.ID);
			
			
			if (_learningMove != "") drawWindow(3, false);
			else drawWindow(1, false);
			
			registerKeys();
		}
		
		private var _action:Bitmap;
		public function drawAction(actionNum:int):void
		{
			if (_action)
			{
				this.removeChild(_action);
				_action = null;
			}
			
			if (_learningMove != "") return;
			
			if (actionNum == 1)
			{
				_action = getSprite(480, 160, 52, 15);
			} else
			if (actionNum == 2)
			{
				_action = getSprite(480, 160 + 15, 52, 15);
			} else
			if(actionNum == 3)
			{
				_action = getSprite(480, 160 + 2 * 15, 52, 15);
			} else
			{
				return;
			}
			
			_action.x = 240 * Configuration.SPRITE_SCALE - _action.width;
			_action.y = 0;
			this.addChild(_action);
		}
		
		private function registerKeys():void
		{
			KeyboardManager.registerKey(Configuration.LEFT_KEY, pressLeft, InputGroups.POKEMON_SUMMARY, true);
			KeyboardManager.registerKey(Configuration.RIGHT_KEY, pressRight, InputGroups.POKEMON_SUMMARY, true);
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressCancel, InputGroups.POKEMON_SUMMARY, true);
			KeyboardManager.registerKey(Configuration.ENTER_KEY, pressEnter, InputGroups.POKEMON_SUMMARY, true);
		}
		
		private function pressEnter():void
		{
			if (windows.length == 1)
			{
				// close
				pressCancel();
			}
		}
		
		private function pressCancel():void
		{
			if (_learningMove != "") return;
			
			SoundManager.playEnterKeySoundEffect();
			
			unregisterKeys();
			
			Configuration.FADE_OUT_AND_IN(finishExitingSummary);
		}
		
		public function receiveAnswerForTraining(moveInt:int):void
		{
			_finishedSummaryCallback(moveInt);
			destroyWindow(windows[0], false);
			destroy();
		}
		
		private function finishExitingSummary():void
		{
			_finishedSummaryCallback();
			destroy();
		}
		
		private function unregisterKeys():void
		{
			KeyboardManager.unregisterKey(Configuration.LEFT_KEY, pressLeft);
			KeyboardManager.unregisterKey(Configuration.RIGHT_KEY, pressRight);
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, pressCancel);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, pressEnter);
		}
		
		private function pressLeft():void
		{
			if (_learningMove != "") return;
			if (currentWindow > 1) drawWindow(currentWindow - 1);
		}
		
		private function pressRight():void
		{
			if (_learningMove != "") return;
			if (currentWindow < 4) drawWindow(currentWindow + 1);
		}
		
		private function drawWindow(windowNumber:int, playSound:Boolean = true):void
		{
			if (_creatingWindow) return;
			
			if (playSound) SoundManager.playEnterKeySoundEffect();
			
			currentWindow = windowNumber;
			
			if (_windowicon)
			{
				this.removeChild(_windowicon);
				_windowicon = null;
			}
			
			switch(currentWindow)
			{
				case 1:
					_windowicon = getSprite(240, 0, 64, 16);
					break;
				case 2:
					_windowicon = getSprite(304, 0, 64, 16);
					break;
				case 3:
					_windowicon = getSprite(368, 0, 64, 16);
					break;
				case 4:
					_windowicon = getSprite(368 + 64, 0, 64, 16);
					break;
			}
			
			_windowicon.x = 88 * Configuration.SPRITE_SCALE;
			this.addChild(_windowicon);
			
			switch(currentWindow)
			{
				case 1:
					drawWindow1();
					break;
				case 2:
					drawWindow2();
					break;
				case 3:
					drawWindow3();
					break;
				case 4:
					drawWindow4();
					break;
			}
		}
		
		private function createWindow(background:Bitmap, tweenIn:Boolean = true, windowType:int = 0, openedBackground:Bitmap = null):void
		{
			var window:UIPokemonSummaryMenuWindow = new UIPokemonSummaryMenuWindow(pokemon, background, windowType, openedBackground, this, _learningMove);
			window.x = tweenIn ? Configuration.VIEWPORT.width : 80 * Configuration.SPRITE_SCALE;
			window.y = 21 * Configuration.SPRITE_SCALE;
			windows.push(window);
			this.addChild(window);
			if (tweenIn) _creatingWindow = true;
			if(tweenIn) TweenLite.to(window, 0.25, { x:80 * Configuration.SPRITE_SCALE, onComplete:finishCreatingWindow } );
		}
		
		private var _creatingWindow:Boolean = false;
		private function finishCreatingWindow():void
		{
			_creatingWindow = false;
		}
		
		private function tweenOutALlWindowsStartingAt(index:int, creatingWindow:Boolean = false):void
		{
			// tween out all the other windows
			if(creatingWindow) _creatingWindow = true
			for (var i:int = index; i < windows.length; i++)
			{
				TweenLite.to(windows[i], 0.25, { x:Configuration.VIEWPORT.width, onComplete:destroyWindow, onCompleteParams:[windows[i], creatingWindow] } );
			}
		}
		
		private function destroyWindow(window:UIPokemonSummaryMenuWindow, creatingWindow:Boolean = false):void
		{
			if (creatingWindow) _creatingWindow = false;
			for (var i:int = 0; i < windows.length; i++)
			{
				if (windows[i] == window) windows.splice(i, 1);
			}
			window.destroy();
			window = null;
		}
		
		private function drawWindow1():void
		{
			if (windows.length > 0)
			{
				tweenOutALlWindowsStartingAt(1, windows.length == 0 ? false : true);
			}
			
			windowTitle.text = "POKéMON INFO";
			drawAction(1);
			
			if(windows.length == 0) createWindow(getSprite(80, 21, 160, 139), false, 1);
		}
		
		private function drawWindow2():void
		{
			if (windows.length > 1)
			{
				tweenOutALlWindowsStartingAt(2, windows.length == 1 ? false : true);
			}
			
			windowTitle.text = "POKéMON SKILLS";
			drawAction(4);
			
			if(windows.length == 1) createWindow(getSprite(80 + 160 * 1, 21, 160, 139), true, 2);
		}
		
		private function drawWindow3():void
		{
			if (windows.length > 2 && _learningMove == "")
			{
				tweenOutALlWindowsStartingAt(3, windows.length == 2 ? false : true);
			}
			
			windowTitle.text = "BATTLE MOVES";
			drawAction(2);
			
			if(windows.length == 2 || _learningMove != "") createWindow(getSprite(80 + 160 * 2, 21, 160, 139), _learningMove == "" ? true : false, 3, getSprite(0, 160, 240, 139));
		}
		
		private function drawWindow4():void
		{
			windowTitle.text = "CONTEST MOVES";
			drawAction(2);
			if(windows.length == 3) createWindow(getSprite(80 + 160 * 3, 21, 160, 139), true, 4);
		}
		
		override public function destroy():void
		{
			_learningPokemon = null;
			
			unregisterKeys();
			
			while (windows.length > 0)
			{
				destroyWindow(windows[0]);
			}
			windows = null;
			
			this.removeChild(_topbar);
			this.removeChild(_windowicon);
			this.removeChild(_sidewindow);
			this.removeChild(animatedPokemonSprite);
			this.removeChild(pokeballIcon);
			if (_action)
			{
				this.removeChild(_action);
				_action = null;
			}
			if (gender)
			{
				this.removeChild(gender);
				gender = null;
			}
			
			pokeballIcon.destroy();
			pokeballIcon = null;
			
			this.removeChild(numberText);
			this.removeChild(levelText);
			this.removeChild(nameText);
			this.removeChild(speciesText);
			this.removeChild(windowTitle);
			
			numberText = levelText = nameText = windowTitle = speciesText = null;
			
			animatedPokemonSprite.destroy();
			
			_topbar = null;
			_windowicon = null;
			_sidewindow = null;
			pokemon = null;
			_finishedSummaryCallback = null;
			animatedPokemonSprite = null;
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
	
	}

}