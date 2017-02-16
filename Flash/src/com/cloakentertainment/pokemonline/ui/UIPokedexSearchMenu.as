package com.cloakentertainment.pokemonline.ui
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import flash.display.MovieClip;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import mx.utils.StringUtil;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexSearchMenu extends UISprite implements UIElement
	{
		[Embed(source="assets/UIPokedexSearchMenu.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var background:Bitmap;
		private var searchButton:UIPokedexSearchMenuButton;
		private var switchButton:UIPokedexSearchMenuButton;
		private var cancelButton:UIPokedexSearchMenuButton;
		private var nameOption:UIPokedexSearchMenuOption;
		private var colorOption:UIPokedexSearchMenuOption;
		private var orderOption:UIPokedexSearchMenuOption;
		private var typeOption:UIPokedexSearchMenuOptionDouble;
		private var okButton:UIPokedexSearchMenuOKButton;
		
		private var outputLog:TextField;
		
		public function UIPokedexSearchMenu():void
		{
			super(spriteImage);
			
			construct();
		}
		
		override public function construct():void
		{
			background = getSprite(0, 0, 240, 160);
			
			this.addChild(background);
			
			searchButton = new UIPokedexSearchMenuButton(getSprite(240, 43, 32, 13), getSprite(240, 30, 32, 13), "SEARCH");
			switchButton = new UIPokedexSearchMenuButton(getSprite(240, 43, 32, 13), getSprite(240, 30, 32, 13), "SHIFT");
			cancelButton = new UIPokedexSearchMenuButton(getSprite(240, 43, 32, 13), getSprite(240, 30, 32, 13), "CANCEL");
			
			searchButton.y = switchButton.y = cancelButton.y = 1 * Configuration.SPRITE_SCALE;
			searchButton.x = 4 * Configuration.SPRITE_SCALE;
			switchButton.x = 52 * Configuration.SPRITE_SCALE;
			cancelButton.x = 100 * Configuration.SPRITE_SCALE;
			
			nameOption = new UIPokedexSearchMenuOption(getSprite(274, 0, 130, 15), getSprite(274, 30, 130, 15), "NAME", "DON'T SPECIFY.");
			colorOption = new UIPokedexSearchMenuOption(getSprite(274, 0, 130, 15), getSprite(274, 30, 130, 15), "COLOR", "DON'T SPECIFY.");
			var initialMode:String = "NUMERICAL MODE";
			switch(Configuration.POKEDEX_CURRENT_SORT_TYPE)
			{
				case UIPokedexMenu.ALPHABETICAL:
					initialMode = "A TO Z MODE";
					break;
				case UIPokedexMenu.HEAVIEST:
					initialMode = "HEAVIEST MODE";
					break;
				case UIPokedexMenu.LIGHTEST:
					initialMode = "LIGHTEST MODE";
					break;
				case UIPokedexMenu.TALLEST:
					initialMode = "TALLEST MODE";
					break;
				case UIPokedexMenu.SMALLEST:
					initialMode = "SMALLEST MODE";
					break;
			}
			orderOption = new UIPokedexSearchMenuOption(getSprite(274, 0, 130, 15), getSprite(274, 30, 130, 15), "ORDER", initialMode);
			typeOption = new UIPokedexSearchMenuOptionDouble(getSprite(274, 15, 130, 15), getSprite(274, 45, 130, 15), getSprite(274, 60, 130, 15), "TYPE", "NONE", "NONE");
			
			nameOption.x = colorOption.x = orderOption.x = typeOption.x = 3 * Configuration.SPRITE_SCALE;
			nameOption.y = 16 * Configuration.SPRITE_SCALE;
			colorOption.y = 32 * Configuration.SPRITE_SCALE;
			orderOption.y = 64 * Configuration.SPRITE_SCALE;
			typeOption.y = 48 * Configuration.SPRITE_SCALE;
			
			okButton = new UIPokedexSearchMenuOKButton(getSprite(240, 0, 34, 15), getSprite(240, 15, 34, 15));
			okButton.x = nameOption.x;
			okButton.y = 80 * Configuration.SPRITE_SCALE;
			
			this.addChild(okButton);
			this.addChild(searchButton);
			this.addChild(switchButton);
			this.addChild(cancelButton);
			this.addChild(nameOption);
			this.addChild(colorOption);
			this.addChild(orderOption);
			this.addChild(typeOption);
			
			outputLog = new TextField();
			outputLog.embedFonts = true;
			outputLog.defaultTextFormat = Configuration.TEXT_FORMAT_POKEDEX;
			outputLog.filters = [Configuration.TEXT_FILTER_POKEDEX];
			outputLog.selectable = false;
			outputLog.text = "";
			outputLog.width = 240 * Configuration.SPRITE_SCALE;
			outputLog.height = 40 * Configuration.SPRITE_SCALE;
			outputLog.x = 8 * Configuration.SPRITE_SCALE;
			outputLog.y = 120 * Configuration.SPRITE_SCALE;
			this.addChild(outputLog);
			
			selectButton(1);
			
			registerKeys();
		}
		
		private function registerKeys(register:Boolean = true):void
		{
			if (register)
			{
				KeyboardManager.registerKey(Configuration.LEFT_KEY, lateralSwitchLeft, InputGroups.POKEDEX_SEARCH, true);
				KeyboardManager.registerKey(Configuration.RIGHT_KEY, lateralSwitchRight, InputGroups.POKEDEX_SEARCH, true);
				KeyboardManager.registerKey(Configuration.ENTER_KEY, selectButtonCallback, InputGroups.POKEDEX_SEARCH, true);
				KeyboardManager.registerKey(Configuration.CANCEL_KEY, closeSearchMenu, InputGroups.POKEDEX_SEARCH, true);
				KeyboardManager.registerKey(Configuration.UP_KEY, verticalSwitchUp, InputGroups.POKEDEX_SEARCH, true);
				KeyboardManager.registerKey(Configuration.DOWN_KEY, verticalSwitchDown, InputGroups.POKEDEX_SEARCH, true);
			}
			else
			{
				KeyboardManager.unregisterKey(Configuration.LEFT_KEY, lateralSwitchLeft);
				KeyboardManager.unregisterKey(Configuration.RIGHT_KEY, lateralSwitchRight);
				KeyboardManager.unregisterKey(Configuration.ENTER_KEY, selectButtonCallback);
				KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, closeSearchMenu);
				KeyboardManager.unregisterKey(Configuration.UP_KEY, verticalSwitchUp);
				KeyboardManager.unregisterKey(Configuration.DOWN_KEY, verticalSwitchDown);
			}
		}
		private var currentOption:int;
		
		private function verticalSwitchUp():void
		{
			if (browsingOptions == false)
				return;
			if (browsingOptionSelections)
			{
				searchMenuOptionSelection.scrollUp();
				if (currentOption == 4)
				{
					// Show in the output log the description for these
					describeCurrentOrderOption();
				}
				return;
			}
			if (currentButton == 1)
			{
				if (currentOption <= 1)
					return;
				selectOption(currentOption - 1);
			}
			else
			{
				if (currentOption <= 4)
					return;
				selectOption(currentOption - 1);
			}
		}
		
		private function describeCurrentOrderOption():void
		{
			switch(searchMenuOptionSelection.POINTER)
			{
				case 1:
					outputLog.text = "POKéMON are listed according to their number.";
					break;
				case 2:
					outputLog.text = "Spotted and owned POKéMON are listed\nalphabetically.";
					break;
				case 3:
					outputLog.text = "Owned POKéMON are listed from the\nheaviest to the lightest.";
					break;
				case 4:
					outputLog.text = "Owned POKéMON are listed from the\nlightest to the heaviest.";
					break;
				case 5:
					outputLog.text = "Owned POKéMON are listed from the\ntallest to the smallest.";
					break;
				case 6:
					outputLog.text = "Owned POKéMON are listed from the\nsmallest to the tallest.";
					break;
			}
		}
		
		private function verticalSwitchDown():void
		{
			if (browsingOptions == false)
				return;
			if (browsingOptionSelections)
			{
				searchMenuOptionSelection.scrollDown();
				if (currentOption == 4)
				{
					// Show in the output log the description for these
					describeCurrentOrderOption();
				}
				return;
			}
			if (currentButton == 1)
			{
				if (currentOption >= 5)
					return;
				selectOption(currentOption + 1);
			}
			else
			{
				if (currentOption >= 5)
					return;
				selectOption(currentOption + 1);
			}
		}
		
		private function executeQuery():void
		{
			var order:String = "";
			switch(StringUtil.trim(orderOption.VALUE))
			{
				case "NUMERICAL MODE":
					order = UIPokedexMenu.NUMERICAL;
					break;
				case "A TO Z MODE":
					order = UIPokedexMenu.ALPHABETICAL;
					break;
				case "HEAVIEST MODE":
					order = UIPokedexMenu.HEAVIEST;
					break;
				case "LIGHTEST MODE":
					order = UIPokedexMenu.LIGHTEST;
					break;
				case "TALLEST MODE":
					order = UIPokedexMenu.TALLEST;
					break;
				case "SMALLEST MODE":
					order = UIPokedexMenu.SMALLEST;
					break;
			}
			var name:String = StringUtil.trim(nameOption.VALUE) == "DON'T SPECIFY." ? UIPokedexMenuSearchOptions.DONT_SPECIFY : StringUtil.trim(nameOption.VALUE);
			var color:String = StringUtil.trim(colorOption.VALUE) == "DON'T SPECIFY." ? UIPokedexMenuSearchOptions.DONT_SPECIFY : StringUtil.trim(colorOption.VALUE);
			var type1:String = StringUtil.trim(typeOption.VALUE1);
			var type2:String = StringUtil.trim(typeOption.VALUE2);
			var onlyOwned:Boolean = type1 == "NONE" && type2 == "NONE" ? false : true;
			if (type1 == "NONE") type1 = UIPokedexMenuSearchOptions.DONT_SPECIFY;
			if (type2 == "NONE") type2 = UIPokedexMenuSearchOptions.DONT_SPECIFY;
			var onlySeen:Boolean = true;
			if (currentButton == 1)
			{
				var options:UIPokedexMenuSearchOptions = new UIPokedexMenuSearchOptions(name, color, type1, type2, order, onlySeen, onlyOwned);
				Configuration.POKEDEX_CURRENT_ID = 1;
				Configuration.POKEDEX_CURRENT_SEARCH_OPTIONS = options;
				registerKeys(false);
				Configuration.FADE_OUT_AND_IN(finishExecuteSearch);
			} else
			if (currentButton == 2)
			{
				// Shift!
				Configuration.POKEDEX_CURRENT_ID = 1;
				Configuration.POKEDEX_CURRENT_SORT_TYPE = order;
				registerKeys(false);
				Configuration.FADE_OUT_AND_IN(finishExecuteShift);
			}
		}
		
		private function finishExecuteSearch():void
		{
			destroy();
			Configuration.createMenu(MenuType.POKEDEX_SEARCH_COMPLETE);
		}
		
		private function finishExecuteShift():void
		{
			destroy();
			Configuration.createMenu(MenuType.POKEDEX);
		}
		
		private function selectOption(option:int):void
		{
			currentOption = option;
			nameOption.deselect();
			typeOption.deselect();
			colorOption.deselect();
			orderOption.deselect();
			okButton.deselect();
			switch (option)
			{
				case 1: 
					nameOption.select();
					outputLog.text = "List by the first letter in the name.\nSpotted POKéMON only.";
					break;
				case 2: 
					colorOption.select();
					outputLog.text = "List by body color.\nSpotted POKéMON only.";
					break;
				case 3: 
					typeOption.select();
					outputLog.text = "List by type.\nOwned POKéMON only.";
					break;
				case 4: 
					orderOption.select();
					outputLog.text = "Select the POKéDEX listing mode.";
					break;
				case 5: 
					okButton.select();
					outputLog.text = "Execute search/switch.";
					break;
			}
		}
		
		private var browsingOptions:Boolean = false;
		private var browsingOptionSelections:Boolean = false;
		private var searchMenuOptionSelection:UIPokedexSearchMenuOptionSelection;
		private function selectButtonCallback():void
		{
			if (browsingOptions)
			{
				// select an option
				if (!browsingOptionSelections)
				{
					if (currentOption == 5)
					{
						// Execute!
						executeQuery();
						return;
					}
					// create the window
					browsingOptionSelections = true;
					var options:Vector.<String> = new Vector.<String>();
					var initialSelection:String = "DON'T SPECIFY.";
					switch(currentOption)
					{
						case 1:
							options.push("DON'T SPECIFY.", "ABC", "DEF", "GHI", "JKL", "MNO", "PQR", "STU", "VWX", "YZ");
							initialSelection = nameOption.VALUE;
							break;
						case 2:
							options.push("DON'T SPECIFY.", "RED", "BLUE", "YELLOW", "GREEN", "BLACK", "BROWN", "PURPLE", "GRAY", "WHITE", "PINK");
							initialSelection = colorOption.VALUE;
							break;
						case 3:
							options.push("NONE", "NORMAL", "FIGHT", "FLYING", "POISON", "GROUND", "ROCK", "BUG", "GHOST", "STEEL", "FIRE", "WATER", "GRASS", "ELECTR", "PSYCHC", "ICE", "DRAGON", "DARK");
							if (typeOption.selection == 1) initialSelection = typeOption.VALUE1;
							else if (typeOption.selection == 2) initialSelection = typeOption.VALUE2;
							break;
						case 4:
							options.push("NUMERICAL MODE", "A TO Z MODE", "HEAVIEST MODE", "LIGHTEST MODE", "TALLEST MODE", "SMALLEST MODE");
							initialSelection = orderOption.VALUE;
							break;
					}
					searchMenuOptionSelection = new UIPokedexSearchMenuOptionSelection(options, initialSelection);
					searchMenuOptionSelection.x = 140 * Configuration.SPRITE_SCALE;
					searchMenuOptionSelection.y = 4 * Configuration.SPRITE_SCALE;
					this.addChild(searchMenuOptionSelection);
					
					if (currentOption == 4) describeCurrentOrderOption();
				} else
				{
					// select the value
					var newValue:String = searchMenuOptionSelection.VALUE;
					switch(currentOption)
					{
						case 1:
							nameOption.changeValue(newValue);
							break;
						case 2:
							colorOption.changeValue(newValue);
							break;
						case 3:
							typeOption.changeValue(newValue);
							break;
						case 4:
							orderOption.changeValue(newValue);
							break;
					}
					stopBrowsingOptionSelections();
				}
				
				return;
			}
			
			switch (currentButton)
			{
				case 1: 
					browsingOptions = true;
					selectOption(1);
					break;
				case 2: 
					browsingOptions = true;
					selectOption(4);
					break;
				case 3: 
					closeSearchMenu();
					break;
			}
		}
		
		private function stopBrowsingOptions():void
		{
			browsingOptions = false;
			nameOption.deselect();
			typeOption.deselect();
			colorOption.deselect();
			orderOption.deselect();
			selectButton(currentButton);
		}
		
		private function stopBrowsingOptionSelections():void
		{
			this.removeChild(searchMenuOptionSelection);
			searchMenuOptionSelection.destroy();
			searchMenuOptionSelection = null;
			browsingOptionSelections = false;
			browsingOptions = true;
			selectOption(currentOption);
		}
		
		private function closeSearchMenu():void
		{
			if (browsingOptionSelections)
			{
				stopBrowsingOptionSelections();
				return;
			}
			if (browsingOptions)
			{
				stopBrowsingOptions();
				return;
			}
			registerKeys(false);
			Configuration.FADE_OUT_AND_IN(finishCloseSearchMenu);
		}
		
		private function finishCloseSearchMenu():void
		{
			destroy();
			Configuration.createMenu(MenuType.POKEDEX);
		}
		
		private var currentButton:int;
		
		private function lateralSwitchLeft():void
		{
			if (browsingOptionSelections) return;
			if (browsingOptions)
			{
				if (currentOption == 3 && typeOption.selection == 2) typeOption.select(1);
				return;
			}
			// Move left in the buttons!
			if (currentButton <= 1)
				return;
			selectButton(currentButton - 1);
		}
		
		private function lateralSwitchRight():void
		{
			if (browsingOptionSelections) return;
			if (browsingOptions)
			{
				if (currentOption == 3 && typeOption.selection == 1) typeOption.select(2);
				return;
			}
			if (currentButton >= 3)
				return;
			selectButton(currentButton + 1);
		}
		
		private function selectButton(buttonNum:int):void
		{
			currentButton = buttonNum;
			typeOption.darken(false);
			nameOption.darken(false);
			colorOption.darken(false);
			orderOption.darken(false);
			okButton.darken(false);
			searchButton.deselect();
			switchButton.deselect();
			cancelButton.deselect();
			okButton.deselect();
			switch (buttonNum)
			{
				case 1: 
					// Do nothing, everything is lit up
					searchButton.select();
					outputLog.text = "Search for POKéMON based on\nselected parameters.";
					break;
				case 2: 
					// Darken everything except the ORDER and OK buttons
					switchButton.select();
					typeOption.darken();
					nameOption.darken();
					colorOption.darken();
					outputLog.text = "Switch POKéDEX listings.";
					break;
				case 3: 
					// Darken everything
					cancelButton.select();
					typeOption.darken();
					nameOption.darken();
					colorOption.darken();
					orderOption.darken();
					okButton.darken();
					outputLog.text = "Return to the POKéDEX.";
					break;
			}
		}
		
		override public function destroy():void
		{
			this.removeChild(background);
			this.removeChild(searchButton);
			this.removeChild(switchButton);
			this.removeChild(cancelButton);
			this.removeChild(nameOption);
			this.removeChild(colorOption);
			this.removeChild(orderOption);
			this.removeChild(typeOption);
			this.removeChild(outputLog);
			this.removeChild(okButton);
			
			okButton.destroy();
			searchButton.destroy();
			switchButton.destroy();
			cancelButton.destroy();
			nameOption.destroy();
			colorOption.destroy();
			orderOption.destroy();
			typeOption.destroy();
			
			background = null;
			outputLog = null;
			searchButton = switchButton = cancelButton = null;
			nameOption = colorOption = orderOption = null;
			typeOption = null;
			okButton = null;
			
			registerKeys(false);
			
			if (Configuration.STAGE.contains(this))
				Configuration.STAGE.removeChild(this);
		}
	
	}

}