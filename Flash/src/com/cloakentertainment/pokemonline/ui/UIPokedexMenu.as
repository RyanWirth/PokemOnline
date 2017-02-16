package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.stats.PokemonFactory;
	import com.cloakentertainment.pokemonline.ui.UIPokedexMenuPokemonText;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexMenu extends UISprite implements UIElement
	{
		[Embed(source="assets/UIPokedexMenu.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public static const NUMERICAL:String = "NUMERICAL";
		public static const ALPHABETICAL:String = "ALPHABETICAL";
		public static const HEAVIEST:String = "HEAVIEST";
		public static const LIGHTEST:String = "LIGHTEST";
		public static const TALLEST:String = "TALLEST";
		public static const SMALLEST:String = "SMALLEST";
		
		private var backgroundSprite:Bitmap;
		private var yellowBackground:Bitmap;
		private var whiteBackground:Bitmap;
		private var scrollPointerSprite:Bitmap;
		private var pokemonSpriteContainer:Sprite;
		private var upArrow:UIPokedexMenuArrow;
		private var downArrow:UIPokedexMenuArrow;
		private var seenText:TextField;
		private var ownedText:TextField;
		
		private var SORT_TYPE:String = Configuration.POKEDEX_CURRENT_SORT_TYPE;
		private var SHOW_ALL:Boolean = Configuration.POKEDEX_SHOW_ALL;
		private var SHOW_OWNED:Boolean = false;
		private var pokemon:Vector.<Array>;
		private var pokemonTextVec:Vector.<UIPokedexMenuPokemonText>;
		private var pokemonSpriteVec:Vector.<UIPokemonSprite>;
		
		private var pointer:int = 0;
		
		private var _searchOptions:UIPokedexMenuSearchOptions;
		
		public function UIPokedexMenu(searchOptions:UIPokedexMenuSearchOptions = null)
		{
			super(spriteImage);
			
			_searchOptions = searchOptions;
			
			if (_searchOptions == null)
			{
				if (Configuration.POKEDEX_CURRENT_SORT_TYPE == SMALLEST || Configuration.POKEDEX_CURRENT_SORT_TYPE == TALLEST || Configuration.POKEDEX_CURRENT_SORT_TYPE == LIGHTEST || Configuration.POKEDEX_CURRENT_SORT_TYPE == HEAVIEST)
				{
					SHOW_ALL = false;
					SHOW_OWNED = true;
				}
				else if (Configuration.POKEDEX_CURRENT_SORT_TYPE == ALPHABETICAL)
				{
					SHOW_ALL = false;
					SHOW_OWNED = false;
				}
			}
			else
			{
				if (_searchOptions.ORDER == SMALLEST || _searchOptions.ORDER == TALLEST || _searchOptions.ORDER == LIGHTEST || _searchOptions.ORDER == HEAVIEST)
				{
					SHOW_ALL = false;
					SHOW_OWNED = true;
				}
				else if (_searchOptions.ORDER == ALPHABETICAL)
				{
					SHOW_ALL = false;
					SHOW_OWNED = false;
				}
			}
			
			construct();
		}
		
		override public function construct():void
		{
			populatePokemonVector();
			
			pokemonTextVec = new Vector.<UIPokedexMenuPokemonText>();
			pokemonSpriteVec = new Vector.<UIPokemonSprite>();
			
			yellowBackground = getSprite(240, 16, 104, 134);
			yellowBackground.y = 13 * Configuration.SPRITE_SCALE;
			yellowBackground.x = 133 * Configuration.SPRITE_SCALE;
			this.addChild(yellowBackground);
			
			whiteBackground = getSprite(0, 160, 64, 112);
			whiteBackground.y = 24 * Configuration.SPRITE_SCALE;
			whiteBackground.x = 64 * Configuration.SPRITE_SCALE;
			this.addChild(whiteBackground);
			
			scrollPointerSprite = getSprite(240, 0, 6, 8);
			this.addChild(scrollPointerSprite);
			scrollPointerSprite.x = 228 * Configuration.SPRITE_SCALE;
			
			pokemonSpriteContainer = new Sprite();
			this.addChild(pokemonSpriteContainer);
			
			// foreground cover (background)
			if (_searchOptions == null)
				backgroundSprite = getSprite(0, 0, 240, 160);
			else
				backgroundSprite = getSprite(344, 0, 240, 160); // Search option background is slightly yellowed
			this.addChild(backgroundSprite);
			
			upArrow = new UIPokedexMenuArrow(true);
			downArrow = new UIPokedexMenuArrow(false);
			upArrow.x = downArrow.x = 184 * Configuration.SPRITE_SCALE - upArrow.width / 2;
			upArrow.y = 4 * Configuration.SPRITE_SCALE;
			downArrow.y = 148 * Configuration.SPRITE_SCALE;
			upArrow.startAnimating();
			downArrow.startAnimating();
			this.addChild(upArrow);
			this.addChild(downArrow);
			
			// create seen/owned text
			if (_searchOptions == null)
			{
				seenText = new TextField();
				ownedText = new TextField();
				seenText.embedFonts = ownedText.embedFonts = true;
				seenText.defaultTextFormat = ownedText.defaultTextFormat = Configuration.TEXT_FORMAT_WHITE_LARGE;
				seenText.filters = ownedText.filters = [Configuration.TEXT_FILTER_WHITE_LARGE];
				seenText.width = ownedText.width = 50 * Configuration.SPRITE_SCALE;
				seenText.height = ownedText.height = 16 * Configuration.SPRITE_SCALE;
				seenText.y = 36 * Configuration.SPRITE_SCALE;
				ownedText.y = 68 * Configuration.SPRITE_SCALE;
				seenText.text = Configuration.ACTIVE_TRAINER != null ? Configuration.ACTIVE_TRAINER.numberOfSeenPokemon().toString() : "0";
				ownedText.text = Configuration.ACTIVE_TRAINER != null ? Configuration.ACTIVE_TRAINER.numberOfOwnedPokemon().toString() : "0";
				ownedText.x = 44 * Configuration.SPRITE_SCALE - ownedText.textWidth;
				seenText.x = 44 * Configuration.SPRITE_SCALE - seenText.textWidth;
				this.addChild(seenText);
				this.addChild(ownedText);
			}
			
			scrollTo(Configuration.POKEDEX_CURRENT_ID);
			
			registerScrollKeys();
			registerStartMenuKeys();
			
			if (Configuration.STAGE.contains(this) == false)
				Configuration.STAGE.addChild(this);
		}
		
		private function registerStartMenuKeys(register:Boolean = true):void
		{
			if (register)
			{
				KeyboardManager.registerKey(Configuration.START_KEY, startMenu, InputGroups.POKEDEX, true);
				KeyboardManager.registerKey(Configuration.CANCEL_KEY, cancelOption, InputGroups.POKEDEX, true);
				KeyboardManager.registerKey(Configuration.SELECT_KEY, selectOption, InputGroups.POKEDEX, true);
				KeyboardManager.registerKey(Configuration.ENTER_KEY, enterKey, InputGroups.POKEDEX, true);
			}
			else
			{
				KeyboardManager.unregisterKey(Configuration.START_KEY, startMenu);
				KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, cancelOption);
				KeyboardManager.unregisterKey(Configuration.SELECT_KEY, selectOption);
				KeyboardManager.unregisterKey(Configuration.ENTER_KEY, enterKey);
			}
		}
		
		private function enterKey():void
		{
			if (questionBox) return;
			if (pokemon.length == 0) return;
			if (Configuration.ACTIVE_TRAINER != null && Configuration.ACTIVE_TRAINER.seenPokemon(pokemon[pointer - 1][1]) == false) return;
			registerStartMenuKeys(false);
			registerScrollKeys(false);
			Configuration.FADE_OUT_AND_IN(finishEnterKey);
			Configuration.POKEDEX_INFO_ID = pokemon[pointer - 1][0];
			
			var pokemonSprite:UIPokemonSprite;
			for (var i:int = 0; i < pokemonSpriteVec.length; i++)
			{
				if (pokemonSpriteVec[i].position == 0) 
				{
					pokemonSprite = pokemonSpriteVec[i];
					pokemonSpriteVec.splice(i, 1);
					break;
				}
			}
			Configuration.tweenPokemonSpriteForPokedex(pokemonSprite);
		}
		
		private function finishEnterKey():void
		{
			destroy();
			Configuration.createMenu(MenuType.POKEDEX_INFO);
		}
		
		private function selectOption():void
		{
			// open the pokedex search menu
			Configuration.FADE_OUT_AND_IN(finishSelectOption);
		}
		
		private function finishSelectOption():void
		{
			destroy();
			Configuration.createMenu(MenuType.POKEDEX_SEARCH);
		}
		
		private function registerScrollKeys(register:Boolean = true):void
		{
			if (register)
			{
				KeyboardManager.registerKey(Configuration.DOWN_KEY, scrollDown, InputGroups.POKEDEX, false);
				KeyboardManager.registerKey(Configuration.UP_KEY, scrollUp, InputGroups.POKEDEX, false);
			}
			else
			{
				KeyboardManager.unregisterKey(Configuration.DOWN_KEY, scrollDown);
				KeyboardManager.unregisterKey(Configuration.UP_KEY, scrollUp);
			}
		}
		
		private function cancelOption():void
		{
			if (questionBox)
			{
				// Kill the question box
				closeStartMenu();
				return;
			}
			
			if (_searchOptions != null)
			{
				// Return to Pokedex
				backToPokedex();
				return;
			}
			// Close the Pokedex
			closePokedex();
		}
		
		private var questionBox:UIQuestionTextBox;
		
		private function startMenu():void
		{
			if (questionBox)
			{
				closeStartMenu();
				return;
			}
			registerScrollKeys(false);
			var startMenuOptions:Vector.<String> = new Vector.<String>();
			startMenuOptions.push("BACK TO LIST", "LIST TOP", "LIST BOTTOM", "CLOSE POKéDEX");
			var qBoxHeight:int = 72;
			if (_searchOptions != null)
			{
				qBoxHeight = 88;
				startMenuOptions.splice(3, 0, "BACK TO POKéDEX");
			}
			
			questionBox = new UIQuestionTextBox(startMenuOptions, 104, qBoxHeight, 12, 0, 5, 0, startMenuAnswer, 21, 1);
			questionBox.x = Configuration.VIEWPORT.width - questionBox.width - Configuration.SPRITE_SCALE;
			questionBox.y = Configuration.VIEWPORT.height;
			TweenLite.to(questionBox, 0.1, {y: Configuration.VIEWPORT.height - questionBox.height - Configuration.SPRITE_SCALE});
			this.addChild(questionBox);
		}
		
		private function closeStartMenu():void
		{
			registerStartMenuKeys(false);
			TweenLite.to(questionBox, 0.1, {y: Configuration.VIEWPORT.height, onComplete: finishCloseStartMenu});
		}
		
		private function finishCloseStartMenu():void
		{
			this.removeChild(questionBox);
			questionBox.destroy();
			questionBox = null;
			registerScrollKeys();
			registerStartMenuKeys();
		}
		
		private function closePokedex():void
		{
			registerStartMenuKeys(false);
			registerScrollKeys(false);
			Configuration.FADE_OUT_AND_IN(finishClosePokedex);
		}
		
		private function finishClosePokedex():void
		{
			destroy();
			Configuration.createMenu(MenuType.IN_GAME_MENU);
		}
		
		private function backToPokedex():void
		{
			registerStartMenuKeys(false);
			registerScrollKeys(false);
			Configuration.FADE_OUT_AND_IN(finishBackToPokedex);
		}
		
		private function finishBackToPokedex():void
		{
			destroy();
			Configuration.POKEDEX_CURRENT_SEARCH_OPTIONS = null;
			Configuration.POKEDEX_SHOW_ALL = true;
			Configuration.POKEDEX_CURRENT_ID = 1;
			Configuration.createMenu(MenuType.POKEDEX);
		}
		
		private function startMenuAnswer(answer:String):void
		{
			if (answer == "BACK TO LIST")
			{
				closeStartMenu();
			}
			else if (answer == "CLOSE POKéDEX")
			{
				closePokedex();
			}
			else if (answer == "LIST TOP")
			{
				Configuration.POKEDEX_CURRENT_ID = 1;
				destroy();
				if (_searchOptions != null)
					Configuration.createMenu(MenuType.POKEDEX_SEARCH_COMPLETE);
				else
					Configuration.createMenu(MenuType.POKEDEX);
			}
			else if (answer == "LIST BOTTOM")
			{
				Configuration.POKEDEX_CURRENT_ID = pokemon.length;
				destroy();
				if (_searchOptions != null)
					Configuration.createMenu(MenuType.POKEDEX_SEARCH_COMPLETE);
				else
					Configuration.createMenu(MenuType.POKEDEX);
			}
			else if (answer == "BACK TO POKéDEX")
			{
				backToPokedex();
			}
		}
		
		private var doneScrolling:Boolean = true;
		
		private function scrollDown():void
		{
			if (pointer >= pokemon.length || !doneScrolling)
				return;
			
			pointer += 1;
			doneScrolling = false;
			upArrow.visible = true;
			
			Configuration.POKEDEX_CURRENT_ID = pointer;
			
			// add the next pokemon down below
			if (pointer + 4 <= pokemon.length)
				createPokemonText(pointer + 4, pointer - 1);
			
			for (var i:int = 0; i < pokemonTextVec.length; i++)
			{
				// Scroll everything up
				var newY:int = pokemonTextVec[i].y - 16 * Configuration.SPRITE_SCALE;
				
				if (newY < 5 * Configuration.SPRITE_SCALE)
				{
					// Remove this from the vec!
					pokemonTextVec[i].destroy();
					pokemonTextVec[i] = null;
					pokemonTextVec.splice(i, 1);
					i--;
					continue;
				}
				
				if (i == 0)
					TweenLite.to(pokemonTextVec[i], 0.1, {y: newY, onComplete: finishScrolling});
				else
					TweenLite.to(pokemonTextVec[i], 0.1, {y: newY});
			}
			
			var pokemonID:int = pointer < pokemon.length ? PokemonFactory.getBase(pokemon[pointer][0] - 1).regionalPokedexNumbers[0] : -1;
			if (pokemonID != -1)
			{
				downArrow.visible = true;
				createPokemonSprite(2, pokemonID);
			}
			else
				downArrow.visible = false;
			for (i = 0; i < pokemonSpriteVec.length; i++)
			{
				if (pokemonSpriteVec[i].position == 2)
				{
					newY = pokemonSpriteVec[i].y - 32 * Configuration.SPRITE_SCALE;
					TweenLite.to(pokemonSpriteVec[i], 0.1, {y: newY});
				}
				else if (pokemonSpriteVec[i].position == 1)
				{
					newY = pokemonSpriteVec[i].y - 64 * Configuration.SPRITE_SCALE;
					TweenLite.to(pokemonSpriteVec[i], 0.1, {y: newY, height: 64 * Configuration.SPRITE_SCALE});
				}
				else if (pokemonSpriteVec[i].position == 0)
				{
					newY = pokemonSpriteVec[i].y - 32 * Configuration.SPRITE_SCALE;
					TweenLite.to(pokemonSpriteVec[i], 0.1, {y: newY, height: 32 * Configuration.SPRITE_SCALE, onComplete: finishSpriteScrollDown});
				}
				else if (pokemonSpriteVec[i].position == -1)
				{
					newY = pokemonSpriteVec[i].y - 32 * Configuration.SPRITE_SCALE;
					TweenLite.to(pokemonSpriteVec[i], 0.1, {y: newY});
				}
			}
			
			scrollPointerSprite.y = 14 * Configuration.SPRITE_SCALE + ((pointer - 1) / (pokemon.length - 1)) * 124 * Configuration.SPRITE_SCALE;
		}
		
		private function finishScrolling():void
		{
			doneScrolling = true;
		}
		
		private function scrollUp():void
		{
			if (pointer <= 1 || !doneScrolling)
				return;
			
			pointer -= 1;
			doneScrolling = false;
			downArrow.visible = true;
			
			Configuration.POKEDEX_CURRENT_ID = pointer;
			
			// add the next pokemon down below
			if (pointer - 4 > 0)
				createPokemonText(pointer - 4, pointer + 1);
			
			var i:int;
			var newY:int;
			for (i = 0; i < pokemonTextVec.length; i++)
			{
				// Scroll everything down
				newY = pokemonTextVec[i].y + 16 * Configuration.SPRITE_SCALE;
				
				if (newY > 155 * Configuration.SPRITE_SCALE)
				{
					// Remove this from the vec!
					pokemonTextVec[i].destroy();
					pokemonTextVec[i] = null;
					pokemonTextVec.splice(i, 1);
					i--;
					continue;
				}
				
				if (i == 0)
					TweenLite.to(pokemonTextVec[i], 0.1, {y: newY, onComplete: finishScrolling});
				else
					TweenLite.to(pokemonTextVec[i], 0.1, {y: newY});
			}
			
			// Make the sprite in position -1 -> 0, 0 -> 1, 1 removed
			var pokemonID:int = pointer - 2 >= 0 ? PokemonFactory.getBase(pokemon[pointer - 2][0] - 1).regionalPokedexNumbers[0] : -1;
			if (pokemonID != -1)
			{
				upArrow.visible = true;
				createPokemonSprite(-2, pokemonID);
			}
			else
				upArrow.visible = false;
			for (i = 0; i < pokemonSpriteVec.length; i++)
			{
				if (pokemonSpriteVec[i].position == -2)
				{
					newY = pokemonSpriteVec[i].y + 32 * Configuration.SPRITE_SCALE;
					TweenLite.to(pokemonSpriteVec[i], 0.1, {y: newY});
				}
				else if (pokemonSpriteVec[i].position == -1)
				{
					newY = pokemonSpriteVec[i].y + 32 * Configuration.SPRITE_SCALE;
					TweenLite.to(pokemonSpriteVec[i], 0.1, {y: newY, height: 64 * Configuration.SPRITE_SCALE});
				}
				else if (pokemonSpriteVec[i].position == 0)
				{
					newY = pokemonSpriteVec[i].y + 64 * Configuration.SPRITE_SCALE;
					TweenLite.to(pokemonSpriteVec[i], 0.1, {y: newY, height: 32 * Configuration.SPRITE_SCALE, onComplete: finishSpriteScrollUp});
				}
				else if (pokemonSpriteVec[i].position == 1)
				{
					newY = pokemonSpriteVec[i].y + 32 * Configuration.SPRITE_SCALE;
					TweenLite.to(pokemonSpriteVec[i], 0.1, {y: newY});
				}
			}
			
			scrollPointerSprite.y = 14 * Configuration.SPRITE_SCALE + ((pointer - 1) / (pokemon.length - 1)) * 124 * Configuration.SPRITE_SCALE;
		}
		
		private function finishSpriteScrollUp():void
		{
			var i:int;
			for (i = 0; i < pokemonSpriteVec.length; i++)
			{
				if (pokemonSpriteVec[i].position == 1)
				{
					pokemonSpriteContainer.removeChild(pokemonSpriteVec[i]);
					pokemonSpriteVec[i].destroy();
					pokemonSpriteVec[i] = null;
					pokemonSpriteVec.splice(i, 1);
				}
			}
			for (i = 0; i < pokemonSpriteVec.length; i++)
			{
				pokemonSpriteVec[i].position++;
			}
		}
		
		private function finishSpriteScrollDown():void
		{
			var i:int;
			for (i = 0; i < pokemonSpriteVec.length; i++)
			{
				if (pokemonSpriteVec[i].position == -1)
				{
					pokemonSpriteContainer.removeChild(pokemonSpriteVec[i]);
					pokemonSpriteVec[i].destroy();
					pokemonSpriteVec[i] = null;
					pokemonSpriteVec.splice(i, 1);
				}
			}
			for (i = 0; i < pokemonSpriteVec.length; i++)
			{
				pokemonSpriteVec[i].position--;
			}
		}
		
		private function populatePokemonVector():void
		{
			pokemon = new Vector.<Array>();
			var tempArray:Array = PokemonFactory.pokemon;
			//trace(tempArray);
			
			if (_searchOptions)
			{
				switch (_searchOptions.ORDER)
				{
					case UIPokedexMenuSearchOptions.ORDER_ATOZ: 
						SORT_TYPE = ALPHABETICAL;
						break;
					case UIPokedexMenuSearchOptions.ORDER_HEAVIEST: 
						SORT_TYPE = HEAVIEST;
						break;
					case UIPokedexMenuSearchOptions.ORDER_LIGHTEST: 
						SORT_TYPE = LIGHTEST;
						break;
					case UIPokedexMenuSearchOptions.ORDER_NUMERICAL: 
						SORT_TYPE = NUMERICAL;
						break;
					case UIPokedexMenuSearchOptions.ORDER_SMALLEST: 
						SORT_TYPE = SMALLEST;
						break;
					case UIPokedexMenuSearchOptions.ORDER_TALLEST: 
						SORT_TYPE = TALLEST;
						break;
				}
				if (_searchOptions.ONLY_SEEN)
					SHOW_ALL = false;
				if (_searchOptions.ONLY_OWNED)
					SHOW_OWNED = true;
				
			}
			
			tempArray.sort(sortPokemon);
			var j:uint;
			for (var i:uint = 0; i < tempArray.length; i++)
			{
				if (SHOW_ALL == false && Configuration.ACTIVE_TRAINER != null && Configuration.ACTIVE_TRAINER.seenPokemon(tempArray[i][1]) == false)
					continue;
				if (SHOW_OWNED == true && Configuration.ACTIVE_TRAINER != null && Configuration.ACTIVE_TRAINER.ownedPokemon(tempArray[i][1]) == false)
					continue;
				var pokemonName:String = tempArray[i][1];
				if (_searchOptions)
				{
					if (_searchOptions.NAME != UIPokedexMenuSearchOptions.DONT_SPECIFY)
					{
						var lettersAllowed:Array;
						switch (_searchOptions.NAME)
						{
							case UIPokedexMenuSearchOptions.NAME_ABC: 
								lettersAllowed = ["A", "B", "C"];
								break;
							case UIPokedexMenuSearchOptions.NAME_DEF: 
								lettersAllowed = ["D", "E", "F"];
								break;
							case UIPokedexMenuSearchOptions.NAME_GHI: 
								lettersAllowed = ["G", "H", "I"];
								break;
							case UIPokedexMenuSearchOptions.NAME_JKL: 
								lettersAllowed = ["J", "K", "L"];
								break;
							case UIPokedexMenuSearchOptions.NAME_MNO: 
								lettersAllowed = ["M", "N", "O"];
								break;
							case UIPokedexMenuSearchOptions.NAME_PQR: 
								lettersAllowed = ["P", "Q", "R"];
								break;
							case UIPokedexMenuSearchOptions.NAME_STU: 
								lettersAllowed = ["S", "T", "U"];
								break;
							case UIPokedexMenuSearchOptions.NAME_WVX: 
								lettersAllowed = ["W", "V", "X"];
								break;
							case UIPokedexMenuSearchOptions.NAME_YZ: 
								lettersAllowed = ["Y", "Z"];
								break;
						}
						var firstLetter:String = pokemonName.substr(0, 1);
						var letterAllowed:Boolean = false;
						for (j = 0; j < lettersAllowed.length; j++)
						{
							if (lettersAllowed[j] == firstLetter)
								letterAllowed = true;
						}
						if (!letterAllowed)
							continue; // Skip to the next Pokémon, this one isn't allowed.
					}
					if (_searchOptions.COLOR != UIPokedexMenuSearchOptions.DONT_SPECIFY)
					{
						var pokemonColor:String = PokemonFactory.getBase(PokemonFactory.getPokemonIDFromName(pokemonName) - 1).pokedexColor.toLowerCase();
						if (pokemonColor != _searchOptions.COLOR.toLowerCase())
							continue;
					}
					if (_searchOptions.TYPE1 != UIPokedexMenuSearchOptions.DONT_SPECIFY || _searchOptions.TYPE2 != UIPokedexMenuSearchOptions.DONT_SPECIFY)
					{
						var types:Array = new Array();
						if (_searchOptions.TYPE1 != UIPokedexMenuSearchOptions.DONT_SPECIFY)
							types.push(_searchOptions.TYPE1);
						if (_searchOptions.TYPE2 != UIPokedexMenuSearchOptions.DONT_SPECIFY)
							types.push(_searchOptions.TYPE2);
						var typesSatisfied:int = 0;
						for (j = 0; j < types.length; j++)
						{
							if (PokemonFactory.getBase(PokemonFactory.getPokemonIDFromName(pokemonName) - 1).isType(types[j]))
								typesSatisfied++;
						}
						if (typesSatisfied < types.length)
							continue; // Doesn't satisfy all of the required types, skip this Pokémon
					}
				}
				pokemon.push(tempArray[i]);
			}
			tempArray = null;
		}
		
		public function scrollTo(pokemonNum:int):void
		{
			pointer = pokemonNum;
			var i:int;
			var pokemonID:int;
			var pokemonText:UIPokedexMenuPokemonText;
			for (i = pokemonNum - 1; i >= pokemonNum - 4; i--)
			{
				if (i < 1)
					continue;
				createPokemonText(i, pokemonNum);
			}
			for (i = pokemonNum; i <= pokemonNum + 4; i++)
			{
				if (i > pokemon.length)
					continue;
				createPokemonText(i, pokemonNum);
			}
			
			if (pokemon.length == 0)
				return;
			
			var pokID:int = PokemonFactory.getBase(pokemon[pokemonNum - 1][0] - 1).regionalPokedexNumbers[0];
			var pokIDsub1:int = pokemonNum - 2 >= 0 ? PokemonFactory.getBase(pokemon[pokemonNum - 2][0] - 1).regionalPokedexNumbers[0] : -1;
			var pokIDsub2:int = pokemonNum < pokemon.length ? PokemonFactory.getBase(pokemon[pokemonNum][0] - 1).regionalPokedexNumbers[0] : -1;
			if (pokIDsub1 != -1)
			{
				upArrow.visible = true;
				createPokemonSprite(-1, pokIDsub1);
			}
			else
				upArrow.visible = false;
			createPokemonSprite(0, pokID);
			if (pokIDsub2 != -1)
			{
				downArrow.visible = true;
				createPokemonSprite(1, pokIDsub2);
			}
			else
				downArrow.visible = false;
			
			scrollPointerSprite.y = 14 * Configuration.SPRITE_SCALE + ((pointer - 1) / (pokemon.length - 1)) * 124 * Configuration.SPRITE_SCALE;
			this.setChildIndex(scrollPointerSprite, this.numChildren - 1);
		}
		
		private function createPokemonSprite(position:int, pokemonID:int):void
		{
			pokemonID = PokemonFactory.getPokemonIDFromHoennID(pokemonID); // Convert its Hoenn ID into a National ID
			if (pokemonID < 1 || pokemonID > 386)
				return;
			var pokemonName:String = PokemonFactory.getBase(pokemonID - 1).name;
			if (Configuration.ACTIVE_TRAINER != null && Configuration.ACTIVE_TRAINER.seenPokemon(pokemonName) == false)
				pokemonID = -1;
			var sprite:UIPokemonSprite = new UIPokemonSprite(pokemonID, false, 1);
			sprite.x = 64 * Configuration.SPRITE_SCALE;
			sprite.y = 48 * Configuration.SPRITE_SCALE;
			
			if (position <= -1)
			{
				sprite.height = 32 * Configuration.SPRITE_SCALE;
				sprite.y -= 32 * Configuration.SPRITE_SCALE;
				
				var diff:int = Math.abs(position) - 1;
				sprite.y -= diff * 32 * Configuration.SPRITE_SCALE;
			}
			else if (position >= 1)
			{
				sprite.height = 32 * Configuration.SPRITE_SCALE;
				sprite.y += 64 * Configuration.SPRITE_SCALE + (position - 1) * 32 * Configuration.SPRITE_SCALE;
			}
			
			sprite.position = position;
			
			pokemonSpriteVec.push(sprite);
			pokemonSpriteContainer.addChild(sprite);
		}
		
		private function createPokemonText(i:int, pokemonNum:int):void
		{
			var pokemonID:int = PokemonFactory.getBase(pokemon[i - 1][0] - 1).regionalPokedexNumbers[0];
			var pokemonName:String = PokemonFactory.getBase(pokemon[i - 1][0] - 1).name;
			var POKEMON_KNOWN:Boolean = Configuration.ACTIVE_TRAINER != null ? Configuration.ACTIVE_TRAINER.seenPokemon(pokemonName) : true;
			var pokemonText:UIPokedexMenuPokemonText = new UIPokedexMenuPokemonText(pokemonID, pokemon[i - 1][1], POKEMON_KNOWN);
			pokemonText.x = 140 * Configuration.SPRITE_SCALE + 2 * Configuration.SPRITE_SCALE;
			pokemonText.y = 72 * Configuration.SPRITE_SCALE + (i - pokemonNum) * 16 * Configuration.SPRITE_SCALE + Configuration.SPRITE_SCALE / 3;
			if (Configuration.ACTIVE_TRAINER != null && Configuration.ACTIVE_TRAINER.ownedPokemon(pokemonName))
			{
				pokemonText.addPokeball();
			}
			pokemonSpriteContainer.addChild(pokemonText);
			
			pokemonTextVec.push(pokemonText);
		}
		
		override public function destroy():void
		{
			this.removeChild(whiteBackground);
			this.removeChild(yellowBackground);
			this.removeChild(backgroundSprite);
			this.removeChild(scrollPointerSprite);
			this.removeChild(pokemonSpriteContainer);
			this.removeChild(upArrow);
			this.removeChild(downArrow);
			if (_searchOptions == null)
			{
				this.removeChild(seenText);
				this.removeChild(ownedText);
				seenText = null;
				ownedText = null;
			}
			upArrow.destroy();
			downArrow.destroy();
			whiteBackground.bitmapData.dispose();
			yellowBackground.bitmapData.dispose();
			backgroundSprite.bitmapData.dispose();
			scrollPointerSprite.bitmapData.dispose();
			if (questionBox)
			{
				this.removeChild(questionBox);
				questionBox.destroy();
			}
			questionBox = null;
			whiteBackground = null;
			yellowBackground = null;
			backgroundSprite = null;
			scrollPointerSprite = null;
			pokemon = null;
			upArrow = null;
			downArrow = null;
			
			var i:int;
			for (i = 0; i < pokemonTextVec.length; i++)
			{
				pokemonSpriteContainer.removeChild(pokemonTextVec[i]);
				pokemonTextVec[i].destroy();
				pokemonTextVec[i] = null;
			}
			for (i = 0; i < pokemonSpriteVec.length; i++)
			{
				pokemonSpriteContainer.removeChild(pokemonSpriteVec[i]);
				pokemonSpriteVec[i].destroy();
				pokemonSpriteVec[i] = null;
			}
			pokemonSpriteVec.splice(0, pokemonSpriteVec.length);
			pokemonTextVec.splice(0, pokemonTextVec.length);
			pokemonSpriteVec = null;
			pokemonTextVec = null;
			
			registerScrollKeys(false);
			registerStartMenuKeys(false);
			
			if (Configuration.STAGE.contains(this))
				Configuration.STAGE.removeChild(this);
		}
		
		private function sortPokemon(pok1:Array, pok2:Array):int
		{
			if (_searchOptions && _searchOptions.ORDER != UIPokedexMenuSearchOptions.DONT_SPECIFY)
				SORT_TYPE = _searchOptions.ORDER;
			if (SORT_TYPE == NUMERICAL)
			{
				var pok1RegID:int = PokemonFactory.getBase(pok1[0] - 1).regionalPokedexNumbers[0];
				var pok2RegID:int = PokemonFactory.getBase(pok2[0] - 1).regionalPokedexNumbers[0];
				if (pok1RegID > pok2RegID)
					return 1;
				else if (pok1RegID < pok2RegID)
					return -1;
				else
					return 0;
			}
			else if (SORT_TYPE == ALPHABETICAL)
			{
				if (pok1[1] < pok2[1])
					return -1;
				else if (pok1[1] > pok2[1])
					return 1;
				else
					return 0;
			}
			else if (SORT_TYPE == HEAVIEST || SORT_TYPE == LIGHTEST)
			{
				// Look up their weights
				var pok1Weight:Number = PokemonFactory.getBase(pok1[0] - 1).WEIGHT_IN_POUNDS;
				var pok2Weight:Number = PokemonFactory.getBase(pok2[0] - 1).WEIGHT_IN_POUNDS;
				if (SORT_TYPE == HEAVIEST)
				{
					if (pok1Weight > pok2Weight)
						return -1;
					else if (pok1Weight < pok2Weight)
						return 1;
					else
						return 0;
				}
				else
				{
					if (pok1Weight < pok2Weight)
						return -1;
					else if (pok1Weight > pok2Weight)
						return 1;
					else
						return 0;
				}
			}
			else if (SORT_TYPE == TALLEST || SORT_TYPE == SMALLEST)
			{
				var pok1Height:Number = PokemonFactory.getBase(pok1[0] - 1).HEIGHT_IN_METERS;
				var pok2Height:Number = PokemonFactory.getBase(pok2[0] - 1).HEIGHT_IN_METERS;
				if (SORT_TYPE == TALLEST)
				{
					if (pok1Height > pok2Height)
						return -1;
					else if (pok1Height < pok2Height)
						return 1;
					else
						return 0;
				}
				else
				{
					if (pok1Height < pok2Height)
						return -1;
					else if (pok1Height > pok2Height)
						return 1;
					else
						return 0;
				}
			}
			
			return 0;
		}
	
	}

}