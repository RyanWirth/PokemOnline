package com.cloakentertainment.pokemonline
{
	import com.cloakentertainment.pokemonline.battle.Battle;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.multiplayer.ChatModule;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonFactory;
	import com.cloakentertainment.pokemonline.trainer.Trainer;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.cloakentertainment.pokemonline.ui.*;
	import com.cloakentertainment.pokemonline.world.map.MapType;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class Configuration
	{
		public static const WEB_ASSETS_URL:String = "http://www.ryanwirth.ca/misc/pokemonline/";
		public static var VERSION:String = "";
		public static var VERSION_LABEL:String = "";
		
		public static const DEVELOPMENT_SERVER:Boolean = true;
		public static const MULTIPLAYER_GAME_ID:String = "pokemonline-edwf1uxikect1l4zi0qqzg";
		
		public static var USERNAME:String = "";
		public static var PASSWORD:String = "";
		
		public static var ACTIVE_TRAINER:Trainer;
		public static var MESSAGE_DELAY:int = 1500; // Measured in milliseconds
		public static var TEXT_SPEED:int = 30; // 200 is slow, 125 is medium, 50 is fast
		public static var FADE_DURATION:Number = 1.0; // In seconds, halved per fade in, then fade out
		public static var UI_TYPE:uint = 1;
		public static var MASTER_VOLUME:Number = 0.5;
		public static var MUSIC:Boolean = true;
		public static var MUSIC_VOLUME:Number = 0.75;
		public static var SOUND_EFFECTS:Boolean = true;
		public static var SOUND_EFFECTS_VOLUME:Number = 1.0;
		public static var DAY_NIGHT_CYCLE:Boolean = false;
		public static var STAGE:Stage;
		public static const SPRITE_SCALE:Number = 3.0;
		public static const VIEWPORT:Rectangle = new Rectangle(0, 0, 720, 480); // The game's natural resolution is 720x480
		public static const CURRENCY_SYMBOL:String = "₽";
		
		public static const TEXT_FORMAT:TextFormat = new TextFormat("PokemonFont", 16 * SPRITE_SCALE, 0x606060, null, null, null, null, null, null, null, null, null, 5);
		public static const TEXT_FILTER:DropShadowFilter = new DropShadowFilter(SPRITE_SCALE / 2, 45, 0xd0d0c8, 1, SPRITE_SCALE, SPRITE_SCALE, 255.0, 1, false, false, false);
		public static const TEXT_FORMAT_POKEDEX:TextFormat = new TextFormat("PokemonFont", 14 * SPRITE_SCALE, 0x000000, null, null, null, null, null, null, null, null, null, 5);
		public static const TEXT_FILTER_POKEDEX:DropShadowFilter = new DropShadowFilter(SPRITE_SCALE / 2, 45, 0xb8b8b8, 1, SPRITE_SCALE, SPRITE_SCALE, 255.0, 1, false, false, false);
		public static const TEXT_FORMAT_WHITE:TextFormat = new TextFormat("PokemonFont", 14 * SPRITE_SCALE, 0xFFFFFF, null, null, null, null, null, null, null, null, null, 10);
		public static const TEXT_FILTER_WHITE:DropShadowFilter = new DropShadowFilter(SPRITE_SCALE / 2, 45, 0x606070, 1, SPRITE_SCALE, SPRITE_SCALE, 255.0, 1, false, false, false);
		public static const TEXT_FORMAT_WHITE_LARGE:TextFormat = new TextFormat("PokemonFont", 16 * SPRITE_SCALE, 0xFFFFFF, null, null, null, null, null, null, null, null, null, 5);
		public static const TEXT_FILTER_WHITE_LARGE:DropShadowFilter = new DropShadowFilter(SPRITE_SCALE / 2, 45, 0x000000, 1, SPRITE_SCALE, SPRITE_SCALE, 255.0, 1, false, false, false);
		
		/*
		 * Menu constants:
		 * Used to provide continuity when closing and reopening menus
		 */
		public static var POKEDEX_CURRENT_ID:int = 1;
		public static var POKEDEX_CURRENT_SORT_TYPE:String = UIPokedexMenu.NUMERICAL;
		public static var POKEDEX_CURRENT_SEARCH_OPTIONS:UIPokedexMenuSearchOptions;
		public static var POKEDEX_SHOW_ALL:Boolean = true;
		public static var IN_GAME_MENU_CURRENT_OPTION:int = 1;
		public static var POKEDEX_INFO_ID:int;
		public static var BAG_STATE_VECTOR:Vector.<UIBagMenuState> = new Vector.<UIBagMenuState>();
		public static var BAG_CURRENTLY_SELECTED:int = 1;
		public static var BATTLE_FIGHT_OPTION:int = 1;
		public static var BATTLE_FIGHT_OPTION2:int = 1;
		public static var BATTLE_PRE_MUSIC_TRACK:int = 0;
		public static var MAIN_MENU_CURRENT_OPTION:int = 1;
		public static var MAIN_MENU_PLAYED_MESSAGES:Boolean = false;
		public static var MAIN_MENU_MOTDs:Vector.<String> = new Vector.<String>();
		
		/*
		 * Controls:
		 * Used to update the static vars in the Keys.as class
		 * */
		public static var UP_KEY:int = 38;
		public static var LEFT_KEY:int = 37;
		public static var RIGHT_KEY:int = 39;
		public static var DOWN_KEY:int = 40;
		public static var ENTER_KEY:int = 17;
		public static var START_KEY:int = 96;
		public static var SELECT_KEY:int = 110;
		public static var CANCEL_KEY:int = 16;
		
		public static var chatModule:ChatModule;
		private static var fpsCounter:FPSCounter;
		
		public function Configuration(_stage:Stage, _activeTrainer:Trainer = null)
		{
			STAGE = _stage;
			if (_activeTrainer)
				ACTIVE_TRAINER = _activeTrainer;
			else ACTIVE_TRAINER = new Trainer("Unknown", "", "", 0, 0, -1, -1, MapType.OVERWORLD, null, null, null, null, null, null);
			
			fpsCounter = new FPSCounter(0, 0, 0xFFFFFF);
			STAGE.addChild(fpsCounter);
			
			MemoryTracker.stage = STAGE;
			
			// set the version
			var versionTemp:String = CONFIG::timeStamp;
			var versionTempD:Array = versionTemp.split("/");
			VERSION = (CONFIG::debug == true ? "0" : "1") + "." + versionTempD[0] + "." + versionTempD[1] + "." + versionTempD[2] + CONFIG::buildtype;
			VERSION_LABEL = CONFIG::buildlabel;
			
			// Initialize the factory, including Pokémon bases.
			var factory:PokemonFactory = new PokemonFactory();
			
			// Initialize KeyboardManager
			var keyboardManager:KeyboardManager = new KeyboardManager();
			
			// Create the ChatModule that sits on the right of the screen
			chatModule = new ChatModule();
			STAGE.addChild(chatModule);
		}
		
		public static function fixFPSCounter():void
		{
			if (chatModule && STAGE.contains(chatModule))
			{
				STAGE.setChildIndex(chatModule, STAGE.numChildren - 1);
			}
			if (uiFadeOut && STAGE.contains(uiFadeOut))
			{
				STAGE.setChildIndex(uiFadeOut, STAGE.numChildren - 1);
				if (_tweeningSprite)
					STAGE.setChildIndex(_tweeningSprite, STAGE.numChildren - 1);
			}
			STAGE.setChildIndex(fpsCounter, STAGE.numChildren - 1);
		}
		
		public static function createMenu(menuType:String, overridePokedexCurrentID:int = 1, replacingPokemonCallback:Function = null, pokemonMenuAllowCancellationOnCallback:Boolean = false, pokemonTrainingMove:String = "", pokemonTrainingPokemon:Pokemon = null):void
		{
			var menu:Sprite;
			trace("Creating: " + menuType);
			switch (menuType)
			{
			case MenuType.IN_GAME_MENU: 
				_inGameMenuOpen = true;
				menu = new UIInGameMenu(closeInGameMenu);
				break;
			case MenuType.POKEDEX: 
				POKEDEX_CURRENT_SEARCH_OPTIONS = null;
				menu = new UIPokedexMenu();
				break;
			case MenuType.POKEDEX_SEARCH: 
				menu = new UIPokedexSearchMenu();
				break;
			case MenuType.POKEDEX_SEARCH_COMPLETE: 
				POKEDEX_CURRENT_ID = overridePokedexCurrentID;
				menu = new UIPokedexMenu(POKEDEX_CURRENT_SEARCH_OPTIONS);
				break;
			case MenuType.POKEDEX_INFO: 
				menu = new UIPokedexInfoMenu(POKEDEX_INFO_ID, _tweeningSprite, replacingPokemonCallback);
				break;
			case MenuType.POKEMON: 
				menu = new UIPokemonMenu(replacingPokemonCallback, pokemonMenuAllowCancellationOnCallback, pokemonTrainingMove, pokemonTrainingPokemon);
				break;
			case MenuType.TRAINER: 
				menu = new UITrainerMenu();
				break;
			case MenuType.BAG: 
				menu = new UIBagMenu(replacingPokemonCallback, pokemonTrainingMove);
				break;
			case MenuType.LOGIN: 
				menu = new UILoginMenu();
				break;
			case MenuType.INTRO: 
				menu = new UIIntroMenu();
				break;
			case MenuType.MAIN: 
				menu = new UIMainMenu();
				break;
			case MenuType.CREATE_ACCOUNT: 
				menu = new UICreateAccountMenu();
				break;
			case MenuType.CREATE_ACCOUNT_NAME: 
				menu = new UICreateAccountNameMenu(replacingPokemonCallback);
				break;
			case MenuType.POKEMON_SELECT:
				_inGameMenuOpen = true;
				menu = new UIPokemonSelectMenu(replacingPokemonCallback, closeInGameMenu);
				break;
			case MenuType.NICKNAME:
				menu = new UINicknameMenu(replacingPokemonCallback);
				break;
			case MenuType.PC_SELECT:
				menu = new UIPCSelectMenu(replacingPokemonCallback);
				break;
			case MenuType.MAP:
				menu = new UIMapMenu();
				break;
			case MenuType.POKEMART:
				menu = new UIPokemartMenu(replacingPokemonCallback, pokemonTrainingMove, pokemonMenuAllowCancellationOnCallback);
				break;
			case MenuType.POKEMART_BUY:
				menu = new UIPokemartBuyMenu(replacingPokemonCallback, pokemonTrainingMove);
				break;
			case MenuType.POKEMART_SELL:
				menu = new UIPokemartSellMenu(replacingPokemonCallback, pokemonTrainingMove);
				break;
			case MenuType.PROFILE:
				menu = new UIProfileMenu(replacingPokemonCallback, pokemonTrainingMove);
				break;
			}
			STAGE.addChild(menu);
			
			fixFPSCounter();
		}
		
		private static var _inGameMenuOpen:Boolean = false;
		private static function closeInGameMenu():void
		{
			_inGameMenuOpen = false;
		}
		
		public static function set MENU_OPEN(bool:Boolean):void
		{
			_inGameMenuOpen = bool;
		}
		
		public static function isInGameMenuOpen():Boolean { return _inGameMenuOpen; }
		
		public static var uiFadeOut:UIFadeOut;
		public static function FADE_OUT_AND_IN(midwayCallback:Function, white:Boolean = false, durationOverride:int = -1, midwayCallbackParams:Array = null):void
		{
			uiFadeOut = new UIFadeOut(midwayCallback, white, durationOverride, midwayCallbackParams);
			STAGE.addChild(uiFadeOut);
		}
		
		public static function changeTrainer(newActiveTrainer:Trainer):void
		{
			ACTIVE_TRAINER = newActiveTrainer;
		}
		
		public static var _tweeningSprite:UIPokemonSprite;
		
		public static function tweenPokemonSpriteForPokedex(sprite:UIPokemonSprite):void
		{
			_tweeningSprite = sprite;
			STAGE.addChild(sprite);
			TweenLite.to(sprite, Configuration.FADE_DURATION / 2 + 0.1, {x: 20 * Configuration.SPRITE_SCALE, y: 24 * Configuration.SPRITE_SCALE});
		}
		
		public static function setupTextfield(textField:TextField, format:TextFormat, filter:DropShadowFilter):void
		{
			textField.embedFonts = true;
			textField.defaultTextFormat = format;
			textField.filters = [filter];
			textField.selectable = false;
			textField.wordWrap = true;
			textField.multiline = true;
		}
		
		public static function replaceStringTags(string:String):String
		{
			/* Define tags:
			 * %TIME% = HH:MM (in 24-hour time)
			 * %VERSION% = Configuration.VERSION
			 * %VERSIONLABEL% = Configuration.VERSION_LABEL
			 * Pokémon/Pokemon/pokemon = POKéMON
			 * %PLAYER% = Configuration.ACTIVE_TRAINER.NAME
			 * %ENTER% = Key for the "ENTER" button
			 * %LEFT% = Key for the "LEFT" button.
			 * %RIGHT% = Key for the "RIGHT" button.
			 * %UP% = Key for the "UP" button.
			 * %DOWN% = Key for the "DOWN" button.
			 * %CANCEL% = Key for the "CANCEL" button.
			 * %START% = Key for the "START" button.
			 */
			var d:Date = new Date();
			var hours:int = d.hours;
			var am:Boolean = true;
			if (hours > 12)
			{
				hours -= 12;
				am = false;
			}
			var minutes:int = d.minutes;
			var timeString:String = (hours != 0 ? hours : 12) + ":" + (minutes < 10 ? "0" : "") + minutes + " " + (am ? "AM" : "PM");
			string = string.replace("%TIME%", timeString);
			string = string.replace("%VERSION%", VERSION);
			string = string.replace("%VERSIONLABEL%", VERSION_LABEL);
			string = string.replace("%PLAYER%", ACTIVE_TRAINER != null ? ACTIVE_TRAINER.NAME : "PLAYER");
			string = string.replace("Pokémon", "POKéMON");
			string = string.replace("Pokemon", "POKéMON");
			string = string.replace("pokemon", "POKéMON");
			//string = string.replace("pokémon", "POKéMON");
			string = string.replace("%ENTER%", convertKeycodeToString(ENTER_KEY).toUpperCase());
			string = string.replace("%LEFT%", convertKeycodeToString(LEFT_KEY).toUpperCase());
			string = string.replace("%RIGHT%", convertKeycodeToString(RIGHT_KEY).toUpperCase());
			string = string.replace("%UP%", convertKeycodeToString(UP_KEY).toUpperCase());
			string = string.replace("%DOWN%", convertKeycodeToString(DOWN_KEY).toUpperCase());
			string = string.replace("%CANCEL%", convertKeycodeToString(CANCEL_KEY).toUpperCase());
			string = string.replace("%START%", convertKeycodeToString(START_KEY).toUpperCase());
			string = string.replace("\n", '\u000a');
			string = string.replace("&darr", "↓");
			string = string.replace("&uarr", "↑");
			string = string.replace("&larr", "←");
			string = string.replace("&rarr", "→");
			string = string.replace("%RIVALNOUN%", ACTIVE_TRAINER.TYPE == TrainerType.HERO_FEMALE ? "son" : "daughter");
			string = string.replace("%RIVALNAME%", ACTIVE_TRAINER.TYPE == TrainerType.HERO_FEMALE ? "BRENDAN" : "MAY");
			string = string.replace("%POKEMON1NAME%", ACTIVE_TRAINER.getPokemon(0) != null ? ACTIVE_TRAINER.getPokemon(0).base.name : "Unknown Pokemon");
			string = string.replace("%POKEMON1TYPE%", ACTIVE_TRAINER.getPokemon(0) != null ? String(ACTIVE_TRAINER.getPokemon(0).base.type[0]).toUpperCase() : "UNKNOWN");
			
			string = string.replace("%state:profile1%", ACTIVE_TRAINER.getState("profile1"));
			
			d = null;
			
			return string;
		}
		
		private static var keyboardDict:Dictionary;
		
		public static function convertKeycodeToString(keyCode:int):String
		{
			if (!keyboardDict)
			{
				var keyDescription:XML = describeType(Keyboard);
				var keyNames:XMLList = keyDescription..constant.@name;
				
				keyboardDict = new Dictionary();
				
				var len:int = keyNames.length();
				for (var i:int = 0; i < len; i++)
				{
					keyboardDict[Keyboard[keyNames[i]]] = keyNames[i];
				}
			}
			
			return keyboardDict[keyCode];
		
		}
	
	}

}