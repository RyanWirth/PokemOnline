package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonAbilities;
	import com.cloakentertainment.pokemonline.stats.PokemonMoves;
	import com.cloakentertainment.pokemonline.stats.PokemonStat;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSummaryMenuWindow extends Sprite implements UIElement
	{
		public static const TEXT_FORMAT_BLUE:TextFormat = new TextFormat("PokemonFont", 14 * Configuration.SPRITE_SCALE, 0x88f0f8, null, null, null, null, null, null, null, null, null, 10);
		public static const TEXT_FILTER_BLUE:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x18a0d0, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		public static const TEXT_FORMAT_POKEDEX_CENTERED:TextFormat = new TextFormat("PokemonFont", 14 * Configuration.SPRITE_SCALE, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER, null, null, null, 5);
		public static const TEXT_FORMAT_WHITE_CENTERED:TextFormat = new TextFormat("PokemonFont", 14 * Configuration.SPRITE_SCALE, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER, null, null, null, 10);
		public static const TEXT_FORMAT_POKEDEX_RIGHT:TextFormat = new TextFormat("PokemonFont", 14 * Configuration.SPRITE_SCALE, 0x000000, null, null, null, null, null, TextFormatAlign.RIGHT, null, null, null, 5);
		
		private var pokemon:Pokemon;
		private var _windowType:int;
		
		private var textFields:Vector.<TextField> = new Vector.<TextField>();
		private var pokemonTypes:Vector.<UIPokemonType> = new Vector.<UIPokemonType>();
		private var xpBar:UIPokemonSummaryMenuXPBar;
		
		private var _background:Bitmap;
		private var _openedBackground:Bitmap;
		
		private var _summaryMenu:UIPokemonSummaryMenu;
		private var _learningMove:String;
		
		public function UIPokemonSummaryMenuWindow(_pokemon:Pokemon, background:Bitmap, windowType:int, openedBackground:Bitmap = null, summaryMenu:UIPokemonSummaryMenu = null, learningMove:String = "")
		{
			pokemon = _pokemon;
			_windowType = windowType;
			_background = background;
			_openedBackground = openedBackground;
			_summaryMenu = summaryMenu;
			_learningMove = learningMove;
			
			construct();
		}
		
		public function construct():void
		{
			this.addChild(_background);
			
			if (_windowType == 1)
			{
				var otNameText:TextField = new TextField();
				Configuration.setupTextfield(otNameText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
				otNameText.x = 8 * Configuration.SPRITE_SCALE;
				otNameText.y = 12 * Configuration.SPRITE_SCALE;
				otNameText.width = 100 * Configuration.SPRITE_SCALE;
				otNameText.text = "OT/";
				var otNameTextVal:TextField = new TextField();
				Configuration.setupTextfield(otNameTextVal, TEXT_FORMAT_BLUE, TEXT_FILTER_BLUE);
				otNameTextVal.x = 26 * Configuration.SPRITE_SCALE;
				otNameTextVal.y = 12 * Configuration.SPRITE_SCALE;
				otNameTextVal.width = 100 * Configuration.SPRITE_SCALE;
				otNameTextVal.text = pokemon.OTNAME;
				this.addChild(otNameText);
				this.addChild(otNameTextVal);
				textFields.push(otNameText, otNameTextVal);
				
				var idText:TextField = new TextField();
				Configuration.setupTextfield(idText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
				idText.x = 100 * Configuration.SPRITE_SCALE;
				idText.y = 12 * Configuration.SPRITE_SCALE;
				idText.width = 58 * Configuration.SPRITE_SCALE;
				idText.text = "IDNo" + GUID.getConcatID(pokemon.UID);
				this.addChild(idText);
				textFields.push(idText);
				
				var typeText:TextField = new TextField();
				Configuration.setupTextfield(typeText, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
				typeText.x = 8 * Configuration.SPRITE_SCALE;
				typeText.y = 28 * Configuration.SPRITE_SCALE;
				typeText.width = 54 * Configuration.SPRITE_SCALE;
				typeText.text = "TYPE/";
				this.addChild(typeText);
				textFields.push(typeText);
				
				var abilityNameText:TextField = new TextField();
				Configuration.setupTextfield(abilityNameText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
				abilityNameText.x = 8 * Configuration.SPRITE_SCALE;
				abilityNameText.y = 52 * Configuration.SPRITE_SCALE;
				abilityNameText.width = 154 * Configuration.SPRITE_SCALE;
				abilityNameText.text = pokemon.ABILITY.toUpperCase();
				this.addChild(abilityNameText);
				textFields.push(abilityNameText);
				var abilityDescText:TextField = new TextField();
				Configuration.setupTextfield(abilityDescText, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
				abilityDescText.x = 8 * Configuration.SPRITE_SCALE;
				abilityDescText.y = 68 * Configuration.SPRITE_SCALE;
				abilityDescText.width = 154 * Configuration.SPRITE_SCALE;
				abilityDescText.text = PokemonAbilities.getAbilityDescriptionByName(pokemon.ABILITY);
				this.addChild(abilityDescText);
				textFields.push(abilityDescText);
				
				var trainerMemoText:TextField = new TextField();
				Configuration.setupTextfield(trainerMemoText, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
				trainerMemoText.x = 8 * Configuration.SPRITE_SCALE;
				trainerMemoText.y = 94 * Configuration.SPRITE_SCALE;
				trainerMemoText.width = 154 * Configuration.SPRITE_SCALE;
				trainerMemoText.height = 46 * Configuration.SPRITE_SCALE;
				trainerMemoText.htmlText = '<font color="#e00808">' + pokemon.NATURE.toUpperCase() + '</font> nature,\nmet at Lv<font color="#e00808">' + pokemon.MET_AT_LEVEL + '</font>,\n<font color="#e00808">' + pokemon.MET_AT_LOCATION.toUpperCase() + "</font>.";
				this.addChild(trainerMemoText);
				textFields.push(trainerMemoText);
				
				var pokemonType1:UIPokemonType = new UIPokemonType(pokemon.base.type[0]);
				pokemonType1.y = 28 * Configuration.SPRITE_SCALE;
				pokemonType1.x = 40 * Configuration.SPRITE_SCALE;
				this.addChild(pokemonType1);
				pokemonTypes.push(pokemonType1);
				
				if (pokemon.base.type.length > 1 && pokemon.base.type[1])
				{
					var pokemonType2:UIPokemonType = new UIPokemonType(pokemon.base.type[1]);
					pokemonType2.x = 80 * Configuration.SPRITE_SCALE;
					pokemonType2.y = 28 * Configuration.SPRITE_SCALE;
					this.addChild(pokemonType2);
					pokemonTypes.push(pokemonType2);
				}
				
			}
			else if (_windowType == 2)
			{
				var itemText:TextField = new TextField();
				Configuration.setupTextfield(itemText, TEXT_FORMAT_POKEDEX_CENTERED, Configuration.TEXT_FILTER);
				itemText.x = 8 * Configuration.SPRITE_SCALE;
				itemText.y = 12 * Configuration.SPRITE_SCALE;
				itemText.width = 66 * Configuration.SPRITE_SCALE;
				itemText.text = pokemon.HELDITEM == "" ? "NONE" : pokemon.HELDITEM.toUpperCase();
				this.addChild(itemText);
				textFields.push(itemText);
				var ribbonText:TextField = new TextField();
				Configuration.setupTextfield(ribbonText, TEXT_FORMAT_POKEDEX_CENTERED, Configuration.TEXT_FILTER);
				ribbonText.x = 88 * Configuration.SPRITE_SCALE;
				ribbonText.y = 12 * Configuration.SPRITE_SCALE;
				ribbonText.width = 66 * Configuration.SPRITE_SCALE;
				ribbonText.text = pokemon.RIBBON == "" ? "NONE" : pokemon.RIBBON.toUpperCase();
				this.addChild(ribbonText);
				textFields.push(ribbonText);
				
				var hpText:TextField = new TextField();
				Configuration.setupTextfield(hpText, TEXT_FORMAT_WHITE_CENTERED, Configuration.TEXT_FILTER_WHITE);
				hpText.x = 4 * Configuration.SPRITE_SCALE;
				hpText.y = 36 * Configuration.SPRITE_SCALE;
				hpText.width = 46 * Configuration.SPRITE_SCALE;
				hpText.text = "HP";
				this.addChild(hpText);
				textFields.push(hpText);
				var hpTextVal:TextField = new TextField();
				Configuration.setupTextfield(hpTextVal, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
				hpTextVal.x = 4 * Configuration.SPRITE_SCALE;
				hpTextVal.y = 36 * Configuration.SPRITE_SCALE;
				hpTextVal.width = 90 * Configuration.SPRITE_SCALE;
				hpTextVal.text = pokemon.CURRENT_HP + "/" + pokemon.getStat(PokemonStat.HP);
				this.addChild(hpTextVal);
				textFields.push(hpTextVal);
				
				var attackText:TextField = new TextField();
				Configuration.setupTextfield(attackText, TEXT_FORMAT_WHITE_CENTERED, Configuration.TEXT_FILTER_WHITE);
				attackText.x = 4 * Configuration.SPRITE_SCALE;
				attackText.y = 52 * Configuration.SPRITE_SCALE;
				attackText.width = 46 * Configuration.SPRITE_SCALE;
				attackText.text = "ATTACK";
				this.addChild(attackText);
				textFields.push(attackText);
				var attackTextVal:TextField = new TextField();
				Configuration.setupTextfield(attackTextVal, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
				attackTextVal.x = 4 * Configuration.SPRITE_SCALE;
				attackTextVal.y = 52 * Configuration.SPRITE_SCALE;
				attackTextVal.width = 90 * Configuration.SPRITE_SCALE;
				attackTextVal.text = pokemon.getStat(PokemonStat.ATK).toString();
				this.addChild(attackTextVal);
				textFields.push(attackTextVal);
				
				var defenseText:TextField = new TextField();
				Configuration.setupTextfield(defenseText, TEXT_FORMAT_WHITE_CENTERED, Configuration.TEXT_FILTER_WHITE);
				defenseText.x = 4 * Configuration.SPRITE_SCALE;
				defenseText.y = 66 * Configuration.SPRITE_SCALE;
				defenseText.width = 46 * Configuration.SPRITE_SCALE;
				defenseText.text = "DEFENSE";
				this.addChild(defenseText);
				textFields.push(defenseText);
				var defenseTextVal:TextField = new TextField();
				Configuration.setupTextfield(defenseTextVal, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
				defenseTextVal.x = 4 * Configuration.SPRITE_SCALE;
				defenseTextVal.y = 66 * Configuration.SPRITE_SCALE;
				defenseTextVal.width = 90 * Configuration.SPRITE_SCALE;
				defenseTextVal.text = pokemon.getStat(PokemonStat.DEF).toString();
				this.addChild(defenseTextVal);
				textFields.push(defenseTextVal);
				
				var spatkText:TextField = new TextField();
				Configuration.setupTextfield(spatkText, TEXT_FORMAT_WHITE_CENTERED, Configuration.TEXT_FILTER_WHITE);
				spatkText.x = 93 * Configuration.SPRITE_SCALE;
				spatkText.y = 36 * Configuration.SPRITE_SCALE;
				spatkText.width = 46 * Configuration.SPRITE_SCALE;
				spatkText.text = "SP. ATK";
				this.addChild(spatkText);
				textFields.push(spatkText);
				var spatkTextVal:TextField = new TextField();
				Configuration.setupTextfield(spatkTextVal, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
				spatkTextVal.x = 93 * Configuration.SPRITE_SCALE;
				spatkTextVal.y = 36 * Configuration.SPRITE_SCALE;
				spatkTextVal.width = 63 * Configuration.SPRITE_SCALE;
				spatkTextVal.text = pokemon.getStat(PokemonStat.SPATK).toString();
				this.addChild(spatkTextVal);
				textFields.push(spatkTextVal);
				
				var spdefText:TextField = new TextField();
				Configuration.setupTextfield(spdefText, TEXT_FORMAT_WHITE_CENTERED, Configuration.TEXT_FILTER_WHITE);
				spdefText.x = 93 * Configuration.SPRITE_SCALE;
				spdefText.y = 52 * Configuration.SPRITE_SCALE;
				spdefText.width = 46 * Configuration.SPRITE_SCALE;
				spdefText.text = "SP. DEF";
				this.addChild(spdefText);
				textFields.push(spdefText);
				var spdefTextVal:TextField = new TextField();
				Configuration.setupTextfield(spdefTextVal, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
				spdefTextVal.x = 93 * Configuration.SPRITE_SCALE;
				spdefTextVal.y = 52 * Configuration.SPRITE_SCALE;
				spdefTextVal.width = 63 * Configuration.SPRITE_SCALE;
				spdefTextVal.text = pokemon.getStat(PokemonStat.SPDEF).toString();
				this.addChild(spdefTextVal);
				textFields.push(spdefTextVal);
				
				var speedText:TextField = new TextField();
				Configuration.setupTextfield(speedText, TEXT_FORMAT_WHITE_CENTERED, Configuration.TEXT_FILTER_WHITE);
				speedText.x = 93 * Configuration.SPRITE_SCALE;
				speedText.y = 66 * Configuration.SPRITE_SCALE;
				speedText.width = 46 * Configuration.SPRITE_SCALE;
				speedText.text = "SPEED";
				this.addChild(speedText);
				textFields.push(speedText);
				var speedTextVal:TextField = new TextField();
				Configuration.setupTextfield(speedTextVal, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
				speedTextVal.x = 93 * Configuration.SPRITE_SCALE;
				speedTextVal.y = 66 * Configuration.SPRITE_SCALE;
				speedTextVal.width = 63 * Configuration.SPRITE_SCALE;
				speedTextVal.text = pokemon.getStat(PokemonStat.SPEED).toString();
				this.addChild(speedTextVal);
				textFields.push(speedTextVal);
				
				var expPointsText:TextField = new TextField();
				Configuration.setupTextfield(expPointsText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
				expPointsText.x = 6 * Configuration.SPRITE_SCALE;
				expPointsText.y = 92 * Configuration.SPRITE_SCALE;
				expPointsText.width = 84 * Configuration.SPRITE_SCALE;
				expPointsText.text = "EXP. POINTS";
				this.addChild(expPointsText);
				textFields.push(expPointsText);
				var expPointsTextVal:TextField = new TextField();
				Configuration.setupTextfield(expPointsTextVal, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
				expPointsTextVal.x = 86 * Configuration.SPRITE_SCALE;
				expPointsTextVal.y = 92 * Configuration.SPRITE_SCALE;
				expPointsTextVal.width = 70 * Configuration.SPRITE_SCALE;
				expPointsTextVal.text = pokemon.XP.toString();
				this.addChild(expPointsTextVal);
				textFields.push(expPointsTextVal);
				
				var nextLevelText:TextField = new TextField();
				Configuration.setupTextfield(nextLevelText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
				nextLevelText.x = 6 * Configuration.SPRITE_SCALE;
				nextLevelText.y = 108 * Configuration.SPRITE_SCALE;
				nextLevelText.width = 84 * Configuration.SPRITE_SCALE;
				nextLevelText.text = "NEXT LV.";
				this.addChild(nextLevelText);
				textFields.push(nextLevelText);
				var nextLevelTextVal:TextField = new TextField();
				Configuration.setupTextfield(nextLevelTextVal, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
				nextLevelTextVal.x = 86 * Configuration.SPRITE_SCALE;
				nextLevelTextVal.y = 108 * Configuration.SPRITE_SCALE;
				nextLevelTextVal.width = 70 * Configuration.SPRITE_SCALE;
				nextLevelTextVal.text = pokemon.REQUIRED_XP.toString();
				this.addChild(nextLevelTextVal);
				textFields.push(nextLevelTextVal);
				
				xpBar = new UIPokemonSummaryMenuXPBar(Math.floor(pokemon.LEVEL_UP_PERCENTAGE * 64));
				xpBar.x = 88 * Configuration.SPRITE_SCALE;
				xpBar.y = 125 * Configuration.SPRITE_SCALE;
				this.addChild(xpBar);
				
			}
			else if (_windowType == 3)
			{
				if (_learningMove == "")
					KeyboardManager.registerKey(Configuration.ENTER_KEY, openMoveMenu, InputGroups.POKEMON_SUMMARY_WINDOW, true);
				
				// create the move text
				drawWindow3();
				
				if (_learningMove != "")
					openMoveMenu();
			}
			else if (_windowType == 4)
			{
				// Contests are not enabled!
				var contestText:TextField = new TextField();
				Configuration.setupTextfield(contestText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
				contestText.x = 24 * Configuration.SPRITE_SCALE;
				contestText.y = 32 * Configuration.SPRITE_SCALE;
				contestText.width = 154 * Configuration.SPRITE_SCALE;
				contestText.text = "Contests are currently unavailable.";
				this.addChild(contestText);
				textFields.push(contestText);
			}
		}
		
		private function drawWindow3():void
		{
			for (var i:int = 1; i <= (_learningMove == "" ? 4 : 5); i++)
			{
				if ((_learningMove != "" && i == 5) || pokemon.getMove(i) != "")
				{
					var moveText:TextField = new TextField();
					Configuration.setupTextfield(moveText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
					moveText.x = 40 * Configuration.SPRITE_SCALE;
					moveText.y = 11 * Configuration.SPRITE_SCALE + (16 * (i - 1)) * Configuration.SPRITE_SCALE;
					moveText.width = 76 * Configuration.SPRITE_SCALE;
					moveText.htmlText = i != 5 ? pokemon.getMove(i).toUpperCase() : '<font color="#F08F9C">' + _learningMove.toUpperCase() + '</font>';
					this.addChild(moveText);
					textFields.push(moveText);
					var ppText:TextField = new TextField();
					Configuration.setupTextfield(ppText, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER_POKEDEX);
					ppText.x = 117 * Configuration.SPRITE_SCALE;
					ppText.y = 11 * Configuration.SPRITE_SCALE + (16 * (i - 1)) * Configuration.SPRITE_SCALE;
					ppText.width = 44 * Configuration.SPRITE_SCALE;
					var movePP:int = i != 5 ? pokemon.getMovePP(i) : PokemonMoves.getMovePPByID(PokemonMoves.getMoveIDByName(_learningMove));
					var movePPMax:int = i != 5 ? pokemon.getMovePPMax(i) : PokemonMoves.getMoveMaxPPByID(PokemonMoves.getMoveIDByName(_learningMove));
					ppText.text = "PP" + movePP + "/" + movePPMax;
					this.addChild(ppText);
					textFields.push(ppText);
					var pokType:UIPokemonType = new UIPokemonType(PokemonMoves.getMoveTypeByID(PokemonMoves.getMoveIDByName(i != 5 ? pokemon.getMove(i) : _learningMove)));
					pokType.x = 5 * Configuration.SPRITE_SCALE;
					pokType.y = ppText.y + 1 * Configuration.SPRITE_SCALE;
					this.addChild(pokType);
					pokemonTypes.push(pokType);
				}
			}
		}
		
		private var cancelText:TextField;
		
		private function moveSelectionUp(moveOverride:int = -1):void
		{
			if (moveOverride == -1)
				moveOverride = currentlySelectedMove - 1;
			if (moveOverride == 0)
				moveOverride = 5;
			selectMove(moveOverride, null, -1);
		}
		
		private function moveSelectionDown(moveOverride:int = -1):void
		{
			if (moveOverride == -1)
				moveOverride = currentlySelectedMove + 1;
			if (moveOverride == 6)
				moveOverride = 1;
			selectMove(moveOverride, null, 1);
		}
		
		private function swapBackgrounds(forOpenBackground:Boolean):void
		{
			if (forOpenBackground && this.contains(_background))
			{
				this.removeChild(_background);
				_openedBackground.x = 80 * -Configuration.SPRITE_SCALE;
				this.addChild(_openedBackground);
				this.setChildIndex(_openedBackground, 0);
			}
			else if (this.contains(_openedBackground) && forOpenBackground == false)
			{
				this.removeChild(_openedBackground);
				this.addChild(_background);
				this.setChildIndex(_background, 0);
			}
		}
		
		private function openMoveMenu():void
		{
			swapBackgrounds(true);
			
			_summaryMenu.drawAction(3);
			
			if (_learningMove == "")
			{
				cancelText = new TextField();
				Configuration.setupTextfield(cancelText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
				cancelText.x = 40 * Configuration.SPRITE_SCALE;
				cancelText.y = 11 * Configuration.SPRITE_SCALE + (16 * (5 - 1)) * Configuration.SPRITE_SCALE;
				cancelText.width = 76 * Configuration.SPRITE_SCALE;
				cancelText.text = "CANCEL";
				this.addChild(cancelText);
			}
			
			descriptionText = new TextField();
			Configuration.setupTextfield(descriptionText, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER_POKEDEX);
			descriptionText.x = 6 * Configuration.SPRITE_SCALE;
			descriptionText.y = 100 * Configuration.SPRITE_SCALE;
			descriptionText.width = 152 * Configuration.SPRITE_SCALE;
			descriptionText.text = "";
			this.addChild(descriptionText);
			
			powerText = new TextField();
			Configuration.setupTextfield(powerText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
			powerText.x = -74 * Configuration.SPRITE_SCALE;
			powerText.y = 100 * Configuration.SPRITE_SCALE;
			powerText.width = 54 * Configuration.SPRITE_SCALE;
			powerText.text = "POWER";
			this.addChild(powerText);
			powerTextVal = new TextField();
			Configuration.setupTextfield(powerTextVal, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
			powerTextVal.x = -22 * Configuration.SPRITE_SCALE;
			powerTextVal.y = 100 * Configuration.SPRITE_SCALE;
			powerTextVal.width = 20 * Configuration.SPRITE_SCALE;
			powerTextVal.text = "---";
			this.addChild(powerTextVal);
			
			accuracyText = new TextField();
			Configuration.setupTextfield(accuracyText, Configuration.TEXT_FORMAT_WHITE, Configuration.TEXT_FILTER_WHITE);
			accuracyText.x = -74 * Configuration.SPRITE_SCALE;
			accuracyText.y = 116 * Configuration.SPRITE_SCALE;
			accuracyText.width = 54 * Configuration.SPRITE_SCALE;
			accuracyText.text = "ACCURACY";
			this.addChild(accuracyText);
			accuracyTextVal = new TextField();
			Configuration.setupTextfield(accuracyTextVal, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
			accuracyTextVal.x = -22 * Configuration.SPRITE_SCALE;
			accuracyTextVal.y = 116 * Configuration.SPRITE_SCALE;
			accuracyTextVal.width = 20 * Configuration.SPRITE_SCALE;
			accuracyTextVal.text = "---";
			this.addChild(accuracyTextVal);
			
			selection = new UIPokemonSummaryMenuSelection();
			selection.x = 3 * Configuration.SPRITE_SCALE;
			selectMove(1, null, 0, false);
			this.addChild(selection);
			
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, openMoveMenu);
			KeyboardManager.disableInputGroup(InputGroups.POKEMON_SUMMARY);
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, closeMoveMenu, InputGroups.POKEMON_SUMMARY_WINDOW, true);
			KeyboardManager.registerKey(Configuration.UP_KEY, moveSelectionUp, InputGroups.POKEMON_SUMMARY_WINDOW, true);
			KeyboardManager.registerKey(Configuration.DOWN_KEY, moveSelectionDown, InputGroups.POKEMON_SUMMARY_WINDOW, true);
			setTimeout(enableMoveSelection, 100);
		}
		
		private function enableMoveSelection():void
		{
			KeyboardManager.registerKey(Configuration.ENTER_KEY, selectMoveEnter, InputGroups.POKEMON_SUMMARY_WINDOW, true);
		}
		
		private var highlightedSelectionInt:int;
		
		private function selectMoveEnter():void
		{
			if (currentlySelectedMove == 5 && _learningMove == "")
			{
				closeMoveMenu();
				return;
			}
			else if (currentlySelectedMove == 5)
				return;
			
			if (_learningMove != "" && !sentAnswerForTraining)
			{
				sentAnswerForTraining = true;
				closeMoveMenu(true);
				_summaryMenu.receiveAnswerForTraining(currentlySelectedMove);
				return;
			}
			
			if (highlightedSelection)
			{
				// swap them!
				pokemon.swapMoves(highlightedSelectionInt, currentlySelectedMove);
				removeTextAndTypes();
				drawWindow3();
				selectMove(currentlySelectedMove);
				this.removeChild(highlightedSelection);
				highlightedSelection.destroy();
				highlightedSelection = null;
				return;
			}
			// selects the currently selected move (confusing, right?)
			highlightedSelection = new UIPokemonSummaryMenuSelection();
			highlightedSelection.select();
			highlightedSelection.x = 3 * Configuration.SPRITE_SCALE;
			highlightedSelectionInt = currentlySelectedMove;
			this.addChild(highlightedSelection);
			this.setChildIndex(selection, this.numChildren - 1);
			selectMove(currentlySelectedMove, highlightedSelection);
		}
		
		private var currentlySelectedMove:int = 0;
		
		private function selectMove(moveInt:int, selectionUI:UIPokemonSummaryMenuSelection = null, direction:int = 0, playSound:Boolean = true):void
		{
			if ((moveInt != 5 && _learningMove == "" && pokemon.getMove(moveInt) == "") || (moveInt == 5 && _learningMove == "" && highlightedSelection))
			{
				if (direction == 1)
					moveSelectionDown(moveInt + 1);
				else if (direction == -1)
					moveSelectionUp(moveInt - 1);
				return;
			}
			
			SoundManager.playEnterKeySoundEffect();
			
			if (selectionUI == null)
				currentlySelectedMove = moveInt;
			if (selectionUI == null)
				selectionUI = selection;
			selectionUI.y = 11 * Configuration.SPRITE_SCALE + (moveInt - 1) * 16 * Configuration.SPRITE_SCALE;
			if (this.contains(selectionUI))
				this.setChildIndex(selectionUI, this.numChildren - 1);
			
			// Update the description
			var moveName:String = moveInt == 5 ? _learningMove : pokemon.getMove(moveInt);
			descriptionText.text = moveInt != 5 || _learningMove != "" ? PokemonMoves.getMoveDescriptionByID(PokemonMoves.getMoveIDByName(moveName)) : "";
			var movePower:int = moveInt != 5 || _learningMove != "" ? PokemonMoves.getMovePowerByID(PokemonMoves.getMoveIDByName(moveName)) : 0;
			powerTextVal.text = movePower != 0 ? movePower.toString() : "---";
			var moveAccuracy:int = moveInt != 5 || _learningMove != "" ? Math.round(PokemonMoves.getMoveAccuracyByID(PokemonMoves.getMoveIDByName(moveName)) * 100) : 0;
			accuracyTextVal.text = moveAccuracy != 0 ? moveAccuracy.toString() : "---";
			
			if (selectionUI.SELECTED)
				selectionUI.select();
			else
				selectionUI.deselect();
		}
		
		private function answerAboutCancellingLearning(answer:String):void
		{
			if (answer == "NO")
				return;
			else if (answer == "YES")
			{
				closeMoveMenu(true);
			}
		}
		
		private var selection:UIPokemonSummaryMenuSelection;
		private var highlightedSelection:UIPokemonSummaryMenuSelection;
		private var descriptionText:TextField;
		private var powerText:TextField;
		private var powerTextVal:TextField;
		private var accuracyText:TextField;
		private var accuracyTextVal:TextField;
		
		private function closeMoveMenu(overrideLearning:Boolean = false):void
		{
			if (_learningMove != "" && !overrideLearning)
			{
				// ask if we really want to stop learning this move
				MessageCenter.addMessage(Message.createQuestion("Stop trying to learn the move " + _learningMove.toUpperCase() + "?", answerAboutCancellingLearning, "YES", "NO"));
				return;
			}
			
			SoundManager.playEnterKeySoundEffect();
			
			if (highlightedSelection)
			{
				this.removeChild(highlightedSelection);
				highlightedSelection = null;
				return;
			}
			swapBackgrounds(false);
			
			_summaryMenu.drawAction(2);
			
			if (cancelText)
			{
				this.removeChild(cancelText);
				cancelText = null;
			}
			
			this.removeChild(descriptionText);
			descriptionText = null;
			this.removeChild(powerText);
			this.removeChild(powerTextVal);
			this.removeChild(accuracyText);
			this.removeChild(accuracyTextVal);
			powerText = powerTextVal = accuracyText = accuracyTextVal = null;
			
			this.removeChild(selection);
			selection.destroy();
			selection = null;
			
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, closeMoveMenu);
			if (_learningMove == "")
				KeyboardManager.registerKey(Configuration.ENTER_KEY, openMoveMenu, InputGroups.POKEMON_SUMMARY_WINDOW, true);
			KeyboardManager.unregisterKey(Configuration.UP_KEY, moveSelectionUp);
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, moveSelectionDown);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, selectMoveEnter);
			KeyboardManager.enableInputGroup(InputGroups.POKEMON_SUMMARY);
			
			if (_learningMove != "" && !sentAnswerForTraining)
			{
				sentAnswerForTraining = true;
				_summaryMenu.receiveAnswerForTraining(0);
			}
		}
		
		private var sentAnswerForTraining:Boolean = false;
		
		private function removeTextAndTypes():void
		{
			for (var i:int = 0; i < textFields.length; i++)
			{
				this.removeChild(textFields[i]);
				textFields[i] = null;
			}
			textFields.splice(0, textFields.length);
			for (i = 0; i < pokemonTypes.length; i++)
			{
				this.removeChild(pokemonTypes[i]);
				pokemonTypes[i].destroy();
				pokemonTypes[i] = null;
			}
			pokemonTypes.splice(0, pokemonTypes.length);
		}
		
		public function destroy():void
		{
			_learningMove = "";
			
			this.removeChild(_background);
			_background = null;
			
			_summaryMenu = null;
			
			if (_openedBackground)
			{
				if (this.contains(_openedBackground))
					this.removeChild(_openedBackground);
				_openedBackground = null;
			}
			
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, openMoveMenu);
			
			removeTextAndTypes();
			
			if (xpBar)
			{
				xpBar.destroy();
				this.removeChild(xpBar);
				xpBar = null;
			}
			
			pokemon = null;
		}
	
	}

}