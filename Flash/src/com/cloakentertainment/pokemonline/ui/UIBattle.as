package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.battle.Battle;
	import com.cloakentertainment.pokemonline.battle.BattleAction;
	import com.cloakentertainment.pokemonline.battle.BattleType;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.stats.PokemonFactory;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonMoves;
	import com.cloakentertainment.pokemonline.stats.PokemonStat;
	import com.cloakentertainment.pokemonline.world.entity.EntityManager;
	import com.greensock.easing.Bounce;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.greensock.easing.Linear;
	import com.greensock.loading.core.DisplayObjectLoader;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBattle extends Sprite
	{
		public static const TRAINER_TWEEN_TIME:Number = 1.5; // Initial slide in of Trainer sprites and Pokemon sprites (if wild)
		public static const TRAINER_BAR_TWEEN_TIME:Number = 0.5;
		public static const TRAINER_BAR_POKEBALL_TWEEN_TIME:Number = 0.2;
		
		public var battle:Battle;
		
		private var enemyIcon:Sprite;
		private var allyIcon:Sprite;
		
		// For use in double battles.
		private var enemyIcon2:UIPokemonAnimatedSprite;
		private var allyIcon2:UIPokemonBackSprite;
		
		private var textBar:UIBattleTextBar;
		private var playerAction:UIBattlePlayerAction;
		
		private var background:UIBattleLocation;
		private var enemyLocation:UIBattleEnemyLocation;
		private var allyLocation:UIBattleAllyLocation;
		
		private var allyTrainerBar:UIBattleTrainerBar;
		private var enemyTrainerBar:UIBattleTrainerBar;
		
		private var enemyPokemonSlot:UIBattlePokemonSlot;
		private var allyPokemonSlot:UIBattlePokemonSlot;
		private var enemyPokemonSlot2:UIBattlePokemonSlot;
		private var allyPokemonSlot2:UIBattlePokemonSlot;
		
		/*
		 * This UIBattle class is the visual representation of a battle that takes place. All commands for updating/modifying the UI come from the Battle class.
		 */
		public function UIBattle(_battle:Battle)
		{
			battle = _battle;
			
			createIcons();
		}
		
		private function createIcons():void
		{
			background = new UIBattleLocation(battle.LOCATION);
			enemyLocation = new UIBattleEnemyLocation(battle.LOCATION);
			allyLocation = new UIBattleAllyLocation(battle.LOCATION);
			
			MemoryTracker.track(background, "Background");
			MemoryTracker.track(enemyLocation, "EnemyLocation");
			MemoryTracker.track(allyLocation, "AllyLocation");
			
			allyLocation.y = background.height - allyLocation.height;
			enemyLocation.y = 48 * Configuration.SPRITE_SCALE;
			allyLocation.x = Configuration.VIEWPORT.width;
			enemyLocation.x = -enemyLocation.width;
			
			textBar = new UIBattleTextBar();
			textBar.y = Configuration.VIEWPORT.height - textBar.height;
			this.addChild(textBar);
			
			MemoryTracker.track(textBar, "TextBar");
			
			this.addChild(background);
			this.addChild(enemyLocation);
			this.addChild(allyLocation);
			
			TweenLite.to(allyLocation, TRAINER_TWEEN_TIME, {x: 0, onComplete: createTrainerBars});
			TweenLite.to(enemyLocation, TRAINER_TWEEN_TIME, {x: Configuration.VIEWPORT.width - enemyLocation.width});
			
			if (battle.TYPE == BattleType.WILD)
			{
				enemyIcon = new UIPokemonAnimatedSprite(battle.enemyPokemon[0].base.ID, battle.enemyPokemon[0].SHINY, battle.enemyPokemon[0].FORM, false, false);
				enemyIcon.x = enemyLocation.x + enemyLocation.width / 2;
				enemyIcon.y = enemyLocation.y - (64 * Configuration.SPRITE_SCALE) / 8 + 4 * Configuration.SPRITE_SCALE;
				MemoryTracker.track(enemyIcon, "EnemyIconWild");
			}
			else
			{
				enemyIcon = new UITrainerSprite(battle.enemyTrainers[0].TYPE);
				enemyIcon.x = enemyLocation.x + enemyLocation.width / 2;
				enemyIcon.y = enemyLocation.y - enemyIcon.height / 8;
				MemoryTracker.track(enemyIcon, "EnemyIconTrainer");
			}
			
			displayAllyTrainer(true);
			
			TweenLite.to(enemyIcon, TRAINER_TWEEN_TIME, {x: Configuration.VIEWPORT.width - enemyLocation.width / 2});
			
			this.addChild(enemyIcon);
			
			fixLayers();
		}
		
		public function get WALLY():Boolean
		{
			if (battle.allyTrainers[0].TYPE == TrainerType.WALLY) return true;
			else return false;
		}
		
		private function displayAllyTrainer(tweenInFirst:Boolean = false):void
		{
			trace("Displaying trainer", allyIcon);
			if (allyIcon && allyIcon is UIPokemonBackSprite)
			{
				this.removeChild(allyIcon);
				(allyIcon as UIPokemonBackSprite).destroy();
				allyIcon = null;
			}
			else if (allyIcon && allyIcon is UITrainerBackSprite)
			{
				this.removeChild(allyIcon);
				(allyIcon as UITrainerBackSprite).destroy();
				allyIcon = null;
			}
			
			allyIcon = new UITrainerBackSprite(battle.allyTrainers[0].TYPE);
			MemoryTracker.track(allyIcon, "AllyIcon");
			if (tweenInFirst) allyIcon.x = allyLocation.x + (allyLocation.width - allyIcon.width) / 2;
			else allyIcon.x = -allyIcon.width;
			allyIcon.y = background.height - allyIcon.height;
			
			this.addChild(allyIcon);
			
			TweenLite.to(allyIcon, TRAINER_TWEEN_TIME, {x: (allyLocation.width - allyIcon.width) / 2});
		}
		
		public function destroy():void
		{
			if (callback != null) callback(_moveToPokemonCenter);
			callback = null;
			
			if (allyIcon && allyIcon is UIPokemonBackSprite)
			{
				this.removeChild(allyIcon);
				(allyIcon as UIPokemonBackSprite).destroy();
				allyIcon = null;
			}
			else if (allyIcon && allyIcon is UITrainerBackSprite)
			{
				this.removeChild(allyIcon);
				(allyIcon as UITrainerBackSprite).destroy();
				allyIcon = null;
			}
			
			if (enemyIcon)
			{
				this.removeChild(enemyIcon);
				if (enemyIcon is UIPokemonAnimatedSprite)
					(enemyIcon as UIPokemonAnimatedSprite).destroy();
				else if (enemyIcon is UITrainerSprite)
					(enemyIcon as UITrainerSprite).destroy();
				enemyIcon = null;
			}
			
			if (allyIcon2)
			{
				this.removeChild(allyIcon2);
				allyIcon2.destroy();
				allyIcon2 = null;
			}
			
			if (enemyIcon2)
			{
				this.removeChild(enemyIcon2);
				enemyIcon2.destroy();
				enemyIcon2 = null;
			}
			
			this.removeChild(textBar);
			
			this.removeChild(background);
			this.removeChild(enemyLocation);
			this.removeChild(allyLocation);
			
			textBar.destroy();
			enemyLocation.destroy();
			allyLocation.destroy();
			background.destroy();
			
			textBar = null;
			enemyLocation = null;
			allyLocation = null;
			background = null;
			
			if (allyPokemonSlot)
			{
				this.removeChild(allyPokemonSlot);
				allyPokemonSlot.destroy();
				allyPokemonSlot = null;
			}
			
			if (enemyPokemonSlot)
			{
				this.removeChild(enemyPokemonSlot);
				enemyPokemonSlot.destroy();
				enemyPokemonSlot = null;
			}
			
			if (allyPokemonSlot2)
			{
				this.removeChild(allyPokemonSlot2);
				allyPokemonSlot2.destroy();
				allyPokemonSlot2 = null;
			}
			
			if (enemyPokemonSlot2)
			{
				this.removeChild(enemyPokemonSlot2);
				enemyPokemonSlot2.destroy();
				enemyPokemonSlot2 = null;
			}
			
			if (playerAction)
			{
				this.removeChild(playerAction);
				playerAction.destroy();
				playerAction = null;
			}
			
			tempHPBarCallback = null;
			tempXPBarCallback = null;
			replacementFinishedCallback = null;
			battle = null;
			replacementReplacingPokemon = null;
			
			if (levelUpStatsWindow)
			{
				this.removeChild(levelUpStatsWindow);
				levelUpStatsWindow.destroy();
				levelUpStatsWindow = null;
			}
			
			if (allyPokemonLevelUpBar)
			{
				this.removeChild(allyPokemonLevelUpBar);
				allyPokemonLevelUpBar.destroy();
				allyPokemonLevelUpBar = null;
			}
			
			_questionReplacingPokemon = null;
			pokemonSwitchCallback = null;
			
			if (_pokeballIcon)
			{
				this.removeChild(_pokeballIcon);
				_pokeballIcon.destroy();
				_pokeballIcon = null;
			}
			
			if (enemyTrainerBar)
			{
				this.removeChild(enemyTrainerBar);
				enemyTrainerBar.destroy();
				enemyTrainerBar = null;
			}
			
			if (allyTrainerBar)
			{
				this.removeChild(allyTrainerBar);
				allyTrainerBar.destroy();
				allyTrainerBar = null;
			}
			
			if (allyPokemonSlot)
			{
				this.removeChild(allyPokemonSlot);
				allyPokemonSlot.destroy();
				allyPokemonSlot = null;
			}
			
			_questionCallback = null;
			
			removeChildren();
			
			MemoryTracker.gcAndCheck();
		}
		
		public function displayEnemyTrainer():void
		{
			if (enemyIcon)
			{
				this.removeChild(enemyIcon);
				if (enemyIcon is UIPokemonAnimatedSprite)
					(enemyIcon as UIPokemonAnimatedSprite).destroy();
				else if (enemyIcon is UITrainerSprite)
					(enemyIcon as UITrainerSprite).destroy();
				enemyIcon = null;
			}
			if (enemyIcon2)
			{
				this.removeChild(enemyIcon2);
				enemyIcon2.destroy();
				enemyIcon2 = null;
			}
			
			trace("Displaying EnemyTrainer");
			enemyIcon = new UITrainerSprite(battle.enemyTrainers[0].TYPE);
			enemyIcon.x = Configuration.VIEWPORT.width + enemyIcon.width;
			enemyIcon.y = enemyLocation.y - enemyIcon.height / 8;
			this.addChild(enemyIcon);
			fixLayers();
			TweenLite.to(enemyIcon, TRAINER_TWEEN_TIME, {x: Configuration.VIEWPORT.width - enemyIcon.width / 2});
			MemoryTracker.track(enemyIcon, "EnemyTrainerIcon");
		}
		
		public function fixLayers():void
		{
			if (allyIcon)
				this.setChildIndex(allyIcon, this.numChildren - 1);
			if (allyIcon2)
				this.setChildIndex(allyIcon2, this.numChildren - 1);
			if (allyPokemonSlot)
				this.setChildIndex(allyPokemonSlot, this.numChildren - 1);
			if (allyPokemonSlot2)
				this.setChildIndex(allyPokemonSlot2, this.numChildren - 1);
			
			this.setChildIndex(textBar, this.numChildren - 1);
			
			if (playerAction)
				this.setChildIndex(playerAction, this.numChildren - 1);
		}
		
		private function createTrainerBars():void
		{
			if (battle.TYPE == BattleType.WILD)
			{
				animateWildPokemon();
				return; // Don't add the playerTrainerBar, we don't need to see how many Pokemon we have.
			}
			
			createTrainerBar(false);
			createTrainerBar(true, true);
			
			fixLayers();
		}
		
		public function createTrainerBar(enemy:Boolean = true, introduceTrainersBool:Boolean = false):void
		{
			if (enemy)
			{
				
				enemyTrainerBar = new UIBattleTrainerBar(battle.enemyPokemon, true);
				enemyTrainerBar.x = -enemyTrainerBar.width;
				enemyTrainerBar.y = 40 * Configuration.SPRITE_SCALE;
				this.addChild(enemyTrainerBar);
				MemoryTracker.track(enemyTrainerBar, "EnemyTrainerBar");
				TweenLite.to(enemyTrainerBar, TRAINER_BAR_TWEEN_TIME, {x: 0, onComplete: (introduceTrainersBool ? introduceTrainers : null)});
			}
			else
			{
				
				allyTrainerBar = new UIBattleTrainerBar(battle.allyPokemon, false);
				allyTrainerBar.x = Configuration.VIEWPORT.width;
				allyTrainerBar.y = 95 * Configuration.SPRITE_SCALE;
				this.addChild(allyTrainerBar);
				MemoryTracker.track(allyTrainerBar, "AllyTrainerBar");
				TweenLite.to(allyTrainerBar, TRAINER_BAR_TWEEN_TIME, {x: 136 * Configuration.SPRITE_SCALE});
			}
			
			fixLayers();
		}
		
		private function introduceTrainers():void
		{
			MessageCenter.addMessage(Message.createMessage(battle.enemyTrainers[0].NAME + " would like to battle!", WALLY ? false : true, 2000, finishIntroducingTrainers, 22));
		}
		
		private function finishIntroducingTrainers():void
		{
			TweenLite.to(enemyIcon, 1.0, {x: Configuration.VIEWPORT.width + enemyLocation.width / 2, onComplete: sendOutEnemyPokemon});
			MessageCenter.addMessage(Message.createMessage(battle.enemyTrainers[0].NAME + " sent out\n" + battle.enemyPokemon[0].NAME + (battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER && battle.enemyPokemon[1] ? " and " + battle.enemyPokemon[1].NAME : "") + "!", false, 2000, sendOutPlayerPokemon, 22));
		}
		
		public function showTextBar():void
		{
			textBar.show();
		}
		
		public function hideTextBar():void
		{
			textBar.hide();
		}
		
		public function selectTarget(num:int):Pokemon
		{
			if (battle.enemyPokemon[num] == null || battle.enemyPokemon[num].ACTIVE == false) return selectTarget(num == 0 ? 1 : 0);
			else
			{
				// Reset the icons' visibility
				trace("Selecting target " + num, battle.enemyPokemon[num], battle.enemyPokemon[num].ACTIVE, battle.enemyPokemon[num].ACTIVATED);
				enemyIcon.visible = true;
				enemyIcon2.visible = true;
				
				if (num == 0)
				{
					startFlash(enemyIcon);
				} else
				{
					startFlash(enemyIcon2);
				}
				return battle.enemyPokemon[num];
			}
		}
		
		private function startFlash(icon:DisplayObject):void
		{
			TweenLite.killDelayedCallsTo(startFlash);
			
			icon.visible = !icon.visible;
			TweenLite.delayedCall(0.25, startFlash, [icon]);
		}
		
		public function stopFlash():void
		{
			TweenLite.killDelayedCallsTo(startFlash);
			enemyIcon.visible = true;
			if (enemyIcon2) enemyIcon2.visible = true;
		}
		
		private var levelUpStatsWindow:UIBattlePokemonLevelUpStats;
		private var allyPokemonLevelUpBar:UIBattlePokemonLevelUpBar;
		
		public function displayLevelUpStats(callback:Function, pokemon:Pokemon, oldHP:int, oldATK:int, oldDEF:int, oldSPATK:int, oldSPDEF:int, oldSPEED:int, newHP:int, newATK:int, newDEF:int, newSPATK:int, newSPDEF:int, newSPEED:int):void
		{
			textBar.displayText(pokemon.NAME + " grew to\nLV. " + pokemon.LEVEL + "!");
			levelUpStatsWindow = new UIBattlePokemonLevelUpStats(oldHP, oldATK, oldDEF, oldSPATK, oldSPDEF, oldSPEED, newHP, newATK, newDEF, newSPATK, newSPDEF, newSPEED);
			this.addChild(levelUpStatsWindow);
			levelUpStatsWindow.x = 146 * Configuration.SPRITE_SCALE;
			levelUpStatsWindow.y = 58 * Configuration.SPRITE_SCALE;
			MemoryTracker.track(levelUpStatsWindow, "LevelUpStatsWindow");
			if (allyPokemonLevelUpBar)
			{
				this.removeChild(allyPokemonLevelUpBar);
				allyPokemonLevelUpBar.destroy();
				allyPokemonLevelUpBar = null;
			}
			
			if (allyPokemonSlot.POKEMON == pokemon)
			{
				allyPokemonSlot.updateHPText();
				allyPokemonSlot.updateHPBar(null, newHP);
			}
			else
			{
				allyPokemonLevelUpBar = new UIBattlePokemonLevelUpBar(pokemon.base.ID, pokemon.GENDER, pokemon.NAME, pokemon.LEVEL);
				allyPokemonLevelUpBar.y = 2 * Configuration.SPRITE_SCALE;
				allyPokemonLevelUpBar.x = Configuration.VIEWPORT.width;
				this.addChild(allyPokemonLevelUpBar);
				MemoryTracker.track(allyPokemonLevelUpBar, "AllyPokemonLevelUpBar");
				TweenLite.to(allyPokemonLevelUpBar, 0.5, {x: Configuration.VIEWPORT.width - 96 * Configuration.SPRITE_SCALE, ease: Linear.easeNone});
			}
			
			TweenLite.delayedCall(4, levelUpStatsWindow.switchToOverallStats);
			TweenLite.delayedCall(8, finishDisplayingLevelUpStats, [callback]);
		}
		
		private function finishDisplayingLevelUpStats(callback:Function):void
		{
			textBar.displayText("");
			this.removeChild(levelUpStatsWindow);
			levelUpStatsWindow.destroy();
			levelUpStatsWindow = null;
			
			if (allyPokemonLevelUpBar)
				TweenLite.to(allyPokemonLevelUpBar, 0.5, {x: Configuration.VIEWPORT.width, onComplete: removeLevelUpBar, ease: Linear.easeNone});
			
			callback();
		}
		
		private function removeLevelUpBar():void
		{
			this.removeChild(allyPokemonLevelUpBar);
			allyPokemonLevelUpBar.destroy();
			allyPokemonLevelUpBar = null;
		}
		
		private function sendOutEnemyPokemon():void
		{
			if (enemyTrainerBar)
			{
				this.removeChild(enemyTrainerBar);
				enemyTrainerBar.destroy();
				enemyTrainerBar = null;
			}
			if (enemyPokemonSlot)
			{
				this.removeChild(enemyPokemonSlot);
				enemyPokemonSlot.destroy();
				enemyPokemonSlot = null;
			}
			
			slideInEnemyPokemonSlot();
			
			this.removeChild(enemyIcon);
			if (enemyIcon is UITrainerSprite)
			{
				(enemyIcon as UITrainerSprite).destroy();
			}
			else if (enemyIcon is UIPokemonAnimatedSprite)
			{
				(enemyIcon as UIPokemonAnimatedSprite).destroy();
			}
			enemyIcon = null;
			
			enemyIcon = new UIPokemonAnimatedSprite(battle.enemyPokemon[0].base.ID, battle.enemyPokemon[0].SHINY, battle.enemyPokemon[0].FORM, true, false);
			enemyIcon.x = enemyLocation.x + enemyLocation.width / 2;
			enemyIcon.y = enemyLocation.y - (64 * Configuration.SPRITE_SCALE) / 8 + 8 * Configuration.SPRITE_SCALE;
			this.addChild(enemyIcon);
			Configuration.ACTIVE_TRAINER.seePokemon(battle.enemyPokemon[0].base.name);
			
			if (pokemonSwitchCallback != null)
				TweenLite.delayedCall(3, pokemonSwitchCallback);
			
			SoundManager.playPokemonCry(battle.enemyPokemon[0].base.ID);
			
			if (battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
			{
				if (enemyIcon2)
				{
					this.removeChild(enemyIcon2);
					enemyIcon2.destroy();
					enemyIcon2 = null;
				}
				
				if (battle.enemyPokemon[1])
				{
					enemyIcon2 = new UIPokemonAnimatedSprite(battle.enemyPokemon[1].base.ID, battle.enemyPokemon[1].SHINY, battle.enemyPokemon[1].FORM, true, false);
					enemyIcon2.x = enemyLocation.x + enemyLocation.width / 2;
					enemyIcon2.y = enemyLocation.y - (64 * Configuration.SPRITE_SCALE) / 8 + 8 * Configuration.SPRITE_SCALE;
					this.addChild(enemyIcon2);
					Configuration.ACTIVE_TRAINER.seePokemon(battle.enemyPokemon[1].base.name);
					
					enemyIcon2.x += enemyIcon2.width / 3;
					enemyIcon.x -= enemyIcon.width / 3;
					
					SoundManager.playPokemonCry(battle.enemyPokemon[1].base.ID);
				}
			}
			
			fixLayers();
		}
		
		private function slideInEnemyPokemonSlot():void
		{
			createPokemonSlot(true);
			var oldX:int = enemyPokemonSlot.x;
			enemyPokemonSlot.x = -enemyPokemonSlot.width;
			TweenLite.to(enemyPokemonSlot, 0.25, {x: oldX});
		}
		
		public function askQuestion(questionText:String, questionType:String, callback:Function, optionalText:String, ... answers):void
		{
			_questionType = questionType;
			_questionCallback = callback;
			_questionOptionalText = optionalText;
			
			if (questionType.substr(0, 9) == "learnmove")
			{
				/// Figure out who is learning the move!
				var pokemon:Pokemon;
				var data:Array = questionType.split("||");
				var encodedString:String = data[1];
				for (var i:int = 0; i < battle.allyPokemon.length; i++)
				{
					if (battle.allyPokemon[i].toString() == encodedString)
						pokemon = battle.allyPokemon[i];
				}
				_questionReplacingPokemon = pokemon;
			}
			
			if (questionType == "nickname") _questionReplacingPokemon = battle.enemyPokemon[0];
			else if (questionType == "changepokemon")
				createTrainerBar(true);
			
			if (questionType == "forgetmove")
			{
				MessageCenter.addMessage(Message.createMessage(questionText, false, 2000, askForForgetMove, 22));
			}
			else
			{
				MessageCenter.addMessage(Message.createQuestionFromArray(questionText, answerQuestion, answers, 22));
			}
		}
		
		public function bringInNextPokemon(callback:Function):void
		{
			_questionCallback = callback;
			_questionType = "changepokemon";
			createTrainerBar(true);
			TweenLite.delayedCall(0.75, answerQuestion, ["No"]);
		}
		
		private function askForForgetMove():void
		{
			Configuration.createMenu(MenuType.POKEMON, 1, receiveForgetMoveAnswer, false, _questionOptionalText, _questionReplacingPokemon);
		}
		
		private function receiveForgetMoveAnswer(moveInt:int):void
		{
			battle.learnMove(_questionOptionalText, _questionReplacingPokemon, moveInt != 0 ? true : false, moveInt);
			_questionCallback();
			_questionCallback = null;
			_questionReplacingPokemon = null;
			_questionOptionalText = "";
			_questionType = "";
		}
		
		private var _questionType:String;
		private var _questionCallback:Function;
		private var _questionOptionalText:String;
		private var _questionReplacingPokemon:Pokemon;
		
		private function answerQuestion(answer:String):void
		{
			if (_questionType == "changepokemon")
			{
				if (answer == "No")
				{
					_questionCallback();
					_questionCallback = null;
					battle.replaceTrainerPokemon();
				}
				else if (answer == "Yes")
				{
					KeyboardManager.disableAllInputGroupsExcept(InputGroups.POKEMON);
					_questionReplacingPokemon = battle.allyPokemon[0];
					Configuration.FADE_OUT_AND_IN(createPokemonMenuForQuestion);
				}
			}
			else if (_questionType.substr(0, 9) == "learnmove")
			{
				if (answer == "No")
				{
					verifyAnswerToLearningMoveIsNo();
				}
				else if (answer == "Yes")
				{
					// Now ask for the move to be forgotten.
					battle.learnMove(_questionOptionalText, _questionReplacingPokemon, true, 0);
					_questionCallback();
				}
			}
			else if (_questionType == "nickname")
			{
				if (answer == "No")
				{
					_questionCallback();
					_questionCallback = null;
				}
				else if (answer == "Yes")
				{
					// Open the nickname menu.
					openNicknameMenu();
				}
			}
		
		}
		
		private function openNicknameMenu():void
		{
			Configuration.FADE_OUT_AND_IN(Configuration.createMenu, false, -1, [MenuType.NICKNAME, 1, finishNicknameMenu]);
		}
		
		private function finishNicknameMenu():void
		{
			_questionCallback();
			_questionCallback = null;
		}
		
		private function receiveAnswerToVerifyAnswerToLearningMoveIsNo(answer:String):void
		{
			if (answer == "Yes")
			{
				battle.learnMove(_questionOptionalText, _questionReplacingPokemon, false, 0);
			}
			else if (answer == "No")
			{
				battle.addLearnMoveMessage(_questionReplacingPokemon, _questionOptionalText);
			}
			_questionCallback();
			_questionCallback = null;
			_questionReplacingPokemon = null;
		}
		
		private function verifyAnswerToLearningMoveIsNo():void
		{
			MessageCenter.addMessage(Message.createQuestion("Stop learning\n" + _questionOptionalText.toUpperCase() + "?", receiveAnswerToVerifyAnswerToLearningMoveIsNo, "Yes", "No"));
		}
		
		private function createPokemonMenuForQuestion():void
		{
			Configuration.createMenu(MenuType.POKEMON, 1, finishSelectingReplacementPokemonForQuestion, true);
		}
		
		private function finishSelectingReplacementPokemonForQuestion(newPokemon:Pokemon):void
		{
			KeyboardManager.enableAllInputGroupsExcept(InputGroups.POKEMON);
			
			TweenLite.delayedCall(0.5, finalizeSelectingReplacementPokemonForQuestion, [newPokemon], false);
		}
		
		private function animateWildPokemon():void
		{
			if (enemyIcon is UIPokemonAnimatedSprite)
			{
				(enemyIcon as UIPokemonAnimatedSprite).animate();
				SoundManager.playPokemonCry((enemyIcon as UIPokemonAnimatedSprite).ID);
			}
			
			slideInEnemyPokemonSlot();
			
			MessageCenter.addMessage(Message.createMessage("Wild " + battle.enemyPokemon[0].NAME + " appeared!", true, 0, sendOutPlayerPokemon, 22));
			
			if (battle.allyTrainers[0].TYPE == TrainerType.WALLY)
			{
				KeyboardManager.disableInputGroup(InputGroups.MESSAGE_CENTER);
				TweenLite.delayedCall(2, MessageCenter.finishMessage);
			}
		}
		
		private function sendOutPlayerPokemon():void
		{
			if (allyPokemonSlot)
			{
				this.removeChild(allyPokemonSlot);
				allyPokemonSlot.destroy();
				allyPokemonSlot = null;
			}
			if ((pokemonSwitchedIn && !pokemonSwitchInvoluntary) || !pokemonSwitchedIn)
			{
				if (battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER && battle.allyPokemon[1] && battle.allyPokemon[1].ACTIVATED)
				{
					MessageCenter.addMessage(Message.createMessage("Go! " + battle.allyPokemon[0].NAME + " and\n" + battle.allyPokemon[1].NAME + "!", false, 1000, animatePlayerPokemon, 22, true));
				}
				else MessageCenter.addMessage(Message.createMessage("Go! " + battle.allyPokemon[0].NAME + "!", false, 1000, animatePlayerPokemon, 22, true));
			}
			if (allyIcon is UITrainerBackSprite)
			{
				(allyIcon as UITrainerBackSprite).animate();
				TweenLite.to(allyIcon, 2, {x: -allyIcon.width});
			}
			
			if (allyTrainerBar)
				allyTrainerBar.slideOut();
		}
		
		private var pokemonSwitchedIn:Boolean = false;
		private var pokemonSwitchCallback:Function = null;
		private var pokemonSwitchInvoluntary:Boolean = false;
		
		public function switchPokemon(pokemonEntering:String, isPlayer:String, involuntary:Boolean = false, callback:Function = null):void
		{
			pokemonSwitchCallback = callback;
			if (isPlayer == "true")
			{
				Configuration.BATTLE_FIGHT_OPTION = 1;
				pokemonSwitchedIn = true;
				pokemonSwitchInvoluntary = involuntary;
				TweenLite.delayedCall(0.5, sendOutPlayerPokemon);
			}
			else
			{
				sendOutEnemyPokemon();
			}
		}
		
		private function animatePlayerPokemon():void
		{
			createPokemonSlot(false);
			var oldX:int = allyPokemonSlot.x;
			allyPokemonSlot.x = Configuration.VIEWPORT.width;
			TweenLite.to(allyPokemonSlot, 0.25, {x: oldX});
			
			this.removeChild(allyIcon);
			allyIcon = null;
			
			allyIcon = new UIPokemonBackSprite(battle.allyPokemon[0].base.ID, battle.allyPokemon[0].SHINY, battle.allyPokemon[0].FORM);
			allyIcon.y = Configuration.VIEWPORT.height - allyIcon.height - 48 * Configuration.SPRITE_SCALE;
			allyIcon.x = 40 * Configuration.SPRITE_SCALE;
			this.addChild(allyIcon);
			(allyIcon as UIPokemonBackSprite).shake(10);
			
			SoundManager.playPokemonCry(battle.allyPokemon[0].base.ID);
			
			if (battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
			{
				if (battle.allyPokemon[1] && battle.allyPokemon[1].ACTIVATED)
				{
					allyIcon2 = new UIPokemonBackSprite(battle.allyPokemon[1].base.ID, battle.allyPokemon[1].SHINY, battle.allyPokemon[1].FORM);
					allyIcon2.y = Configuration.VIEWPORT.height - allyIcon2.height - 48 * Configuration.SPRITE_SCALE;
					allyIcon2.x = 40 * Configuration.SPRITE_SCALE;
					this.addChild(allyIcon2);
					allyIcon2.shake(10);
					
					allyIcon2.x += allyIcon2.width / 3;
					
					TweenLite.delayedCall(0.25, this.addChild, [allyIcon2]);
					TweenLite.delayedCall(0.25, SoundManager.playPokemonCry, [battle.allyPokemon[1].base.ID]);
				}
				
				allyIcon.x -= allyIcon.width / 3;
			}
			
			if (!pokemonSwitchedIn)
				TweenLite.delayedCall(1, askPlayerForAction, null, false);
			
			if (pokemonSwitchCallback != null)
				TweenLite.delayedCall(1.5, pokemonSwitchCallback);
			
			fixLayers();
		}
		
		private var _wallyIn:Boolean = false;
		private var _secondPokemonAskAction:Boolean = false;
		
		public function askPlayerForAction(secondPokemon:Boolean = false):void
		{
			if (MessageCenter.WAITING_ON_FINISH_MESSAGE)
				MessageCenter.finishMessage();
			
				_secondPokemonAskAction = secondPokemon;
				
			var pokemon:Pokemon = !secondPokemon ? battle.allyPokemon[0] : battle.allyPokemon[1];
			
			var pokemonName:String = pokemon.NAME;
			
			// Deal with WALLY running his automated battle.
			if (battle.allyTrainers[0].TYPE == TrainerType.WALLY && battle.allyPokemon[0].TURNS_ACTIVE >= 1)
			{
				// Recall
				if (!_wallyIn)
				{
					_wallyIn = true;
					trace("WALLY IN!");
					MessageCenter.addMessage(Message.createMessage("ZIGZAGOON! That's enough, come back!", false, 2000, displayAllyTrainer, 22));
					MessageCenter.addMessage(Message.createMessage("You throw a ball now, right?\nI... I'll do my best!", false, 2000, askPlayerForAction, 22));
					return;
				}
				else
				{
					pokemonName = "WALLY";
				}
			}
			
			pokemonSwitchedIn = false;
			
			if (playerAction)
			{
				this.removeChild(playerAction);
				playerAction.destroy();
				playerAction = null;
			}
			
			trace("CREATED PLAYER ACTION");
			playerAction = new UIBattlePlayerAction(pokemon, this, battle.allyTrainers[0].TYPE == TrainerType.WALLY ? true : false, _wallyIn, secondPokemon);
			this.addChild(playerAction);
			
			textBar.displayText("What will\n" + pokemonName + " do?");
			
			if (enemyTrainerBar)
			{
				this.removeChild(enemyTrainerBar);
				enemyTrainerBar.destroy();
				enemyTrainerBar = null;
			}
			if (allyTrainerBar)
			{
				this.removeChild(allyTrainerBar);
				allyTrainerBar.destroy();
				allyTrainerBar = null;
			}
			
			fixLayers();
		}
		
		public function receivePlayerAction(ba:BattleAction):void
		{
			textBar.hideText();
			stopFlash();
			
			if (ba != null)
				battle.transmitAction(ba);
			
			this.removeChild(playerAction);
			playerAction.destroy();
			playerAction = null;
			
			// If we're battling a wild pokemon, generate a random move for it to perform.
			if (battle.TYPE == BattleType.WILD || battle.TYPE == BattleType.TRAINER || battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
			{
				if (_secondPokemonAskAction)
				{
					// The enemy trainer is in a double battle, but their second pokemon isn't available!
					if (!battle.enemyPokemon[1] || !battle.enemyPokemon[1].ACTIVATED) return;
				}
				var enemyPokemon:Pokemon = _secondPokemonAskAction ? battle.enemyPokemon[1] : battle.enemyPokemon[0];
				var targetPokemon:Pokemon = battle.allyPokemon[0];
				if (battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
				{
					// Choose a random target because we're in a double battle
					var rand:int = Math.floor(Math.random() * 2) + 1;
					targetPokemon = battle.allyPokemon[rand - 1];
					// If the randomly selected pokemon isn't in the battle anymore, choose the other one.
					if (targetPokemon == null || targetPokemon.ACTIVATED == false) targetPokemon = battle.allyPokemon[(rand - 1 == 0 ? 1 : 0)];
				}
				
				if (battle.tutorialBattle && battle.allyPokemon[0].CURRENT_HP <= 8) battle.transmitAction(BattleAction.generateMove(battle.enemyPokemon[0], null, PokemonMoves.getMoveIDByName("Growl")));
				else if (battle.TYPE != BattleType.WILD && battle.enemyTrainers[0].getTotalNumberOfItems() > 0)
				{ // The enemy trainer has an item!
					
					var enemyCurrentHP:int = enemyPokemon.CURRENT_HP;
					var enemyTotalHP:int = enemyPokemon.getStat(PokemonStat.HP);
					trace("ITEM:", enemyCurrentHP, enemyTotalHP, battle.enemyTrainers[0].hasItem("Full Restore"));
					if (battle.enemyTrainers[0].hasItem("Full Restore") && enemyCurrentHP <= enemyTotalHP * 0.25)
					{
						// If the trainer has a Full Restore and his current pokemon has less than 10% of its HP, use it.
						trace("Using Full Restore");
						battle.enemyTrainers[0].consumeItem("Full Restore");
						battle.transmitAction(BattleAction.generateItem(enemyPokemon, null, "Full Restore"));
						return;
					}
				}
				battle.transmitAction(BattleAction.generateMove(enemyPokemon, targetPokemon, PokemonMoves.getMoveIDByName(enemyPokemon.getRandomMove())));
			} 
			
			if (battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER && !_secondPokemonAskAction)
			{
				askPlayerForAction(true);
			}
		}
		
		public function displayMessage(message:String, finishCallback:Function, waitForDismiss:Boolean = false):void
		{
			if (MessageCenter.WAITING_ON_FINISH_MESSAGE)
			{
				MessageCenter.finishMessage();
			}
			
			MessageCenter.addMessage(Message.createMessage(message, battle.TYPE == BattleType.ONLINE_TRAINER ? false : (battle.allyTrainers[0].TYPE == TrainerType.WALLY ? false : true), 2000, finishCallback, 22, waitForDismiss));
		
		}
		
		public function displayStatChange(encodedString:String, statName:String, change:int):void
		{
			// determine who the encodedString belongs to
			if (battle.enemyPokemon[0].toString() == encodedString)
			{
				(enemyIcon as UIPokemonAnimatedSprite).animateStatChange(PokemonStat.convertLocalizedTextToConstant(statName), change > 0 ? true : false);
			}
			else if (battle.allyPokemon[0].toString() == encodedString)
			{
				(allyIcon as UIPokemonBackSprite).animateStatChange(PokemonStat.convertLocalizedTextToConstant(statName), change > 0 ? true : false);
			} else if (battle.allyPokemon[1] && battle.allyPokemon[1].toString() == encodedString)
			{
				allyIcon2.animateStatChange(PokemonStat.convertLocalizedTextToConstant(statName), change > 0 ? true : false);
			} else if (battle.enemyPokemon[1] && battle.enemyPokemon[1].toString() == encodedString)
			{
				enemyIcon2.animateStatChange(PokemonStat.convertLocalizedTextToConstant(statName), change > 0 ? true : false);
			}
		}
		
		public function openPokedexMenu(pokemonName:String, callback:Function):void
		{
			Configuration.FADE_OUT_AND_IN(finishOpenPokedexMenu, false, -1, [pokemonName, callback]);
		}
		
		private function finishOpenPokedexMenu(pokemonName:String, callback:Function):void
		{
			Configuration.POKEDEX_INFO_ID = PokemonFactory.getPokemonIDFromName(pokemonName);
			Configuration.createMenu(MenuType.POKEDEX_INFO, 1, callback);
		}
		
		private var _pokeballIcon:UIPokeballIcon;
		
		public function throwPokeball(pokeball:String):void
		{
			//enemyIcon.visible = false;
			_pokeballIcon = new UIPokeballIcon(pokeball);
			_pokeballIcon.x = enemyLocation.x + enemyLocation.width / 2;
			_pokeballIcon.y = -_pokeballIcon.height;
			this.addChild(_pokeballIcon);
			MemoryTracker.track(_pokeballIcon, "PokeballIcon");
			
			TweenLite.to(_pokeballIcon, 0.25, {y: enemyIcon.y, ease: Bounce.easeOut});
			TweenLite.delayedCall(0.15, hideEnemyIcon);
		}
		
		public function blockPokeball(pokeball:String):void
		{
			_pokeballIcon = new UIPokeballIcon(pokeball);
			_pokeballIcon.x = enemyLocation.x + enemyLocation.width / 2;
			_pokeballIcon.y = -_pokeballIcon.height;
			this.addChild(_pokeballIcon);
			MemoryTracker.track(_pokeballIcon, "PokeballIcon");
			
			TweenLite.to(_pokeballIcon, 0.25, {y: enemyIcon.y, ease: Bounce.easeOut});
			TweenLite.delayedCall(0.25, TweenLite.to, [_pokeballIcon, 0.25, {y: -_pokeballIcon.height, onComplete: destroyPokeball}]);
		}
		
		private function destroyPokeball():void
		{
			if (_pokeballIcon)
			{
				this.removeChild(_pokeballIcon);
				_pokeballIcon.destroy();
				_pokeballIcon = null;
			}
		}
		
		private var _pokeballThrown:String;
		
		public function get POKEBALL_THROWN():String
		{
			return _pokeballThrown;
		}
		
		public function hidePokeball():void
		{
			TweenLite.to(_pokeballIcon, 0.25, {alpha: 0});
		}
		
		private function hideEnemyIcon():void
		{
			enemyIcon.visible = false;
		}
		
		public function shakePokeball():void
		{
			SoundManager.playEnterKeySoundEffect();
			
			TweenLite.to(_pokeballIcon, 0.25, {rotation: 360});
		}
		
		public function failPokeball():void
		{
			enemyIcon.visible = true;
			
			this.removeChild(_pokeballIcon);
			_pokeballIcon.destroy();
			_pokeballIcon = null;
		}
		
		public function updateHPBars(callback:Function = null, damageType:int = 0):void
		{
			tempHPBarCallback = callback;
			var called:Boolean = false;
			if (enemyPokemonSlot && enemyPokemonSlot.POKEMON_HEALTH != enemyPokemonSlot.DISPLAYED_HEALTH)
			{
				called = true;
				enemyPokemonSlot.updateHPBar(hpBarCallback);
				(enemyIcon as UIPokemonAnimatedSprite).flicker(10);
				(enemyIcon as UIPokemonAnimatedSprite).shake(10);
			}
			if (allyPokemonSlot && allyPokemonSlot.POKEMON_HEALTH != allyPokemonSlot.DISPLAYED_HEALTH)
			{
				allyPokemonSlot.updateHPBar((called == false ? hpBarCallback : null));
				(allyIcon as UIPokemonBackSprite).flicker(10);
				(allyIcon as UIPokemonBackSprite).shake(10);
				
				called = true;
			}
			if (allyPokemonSlot2 && allyPokemonSlot2.POKEMON_HEALTH != allyPokemonSlot2.DISPLAYED_HEALTH)
			{
				allyPokemonSlot2.updateHPBar((called == false ? hpBarCallback : null));
				allyIcon2.flicker(10);
				allyIcon2.shake(10);
				
				called = true;
			}
			if (enemyPokemonSlot2 && enemyPokemonSlot2.POKEMON_HEALTH != enemyPokemonSlot2.DISPLAYED_HEALTH)
			{
				enemyPokemonSlot2.updateHPBar((called == false ? hpBarCallback : null));
				enemyIcon2.flicker(10);
				enemyIcon2.shake(10);
				
				called = true;
			}
			
			if (!called && tempHPBarCallback != null)
				hpBarCallback();
		}
		private var tempHPBarCallback:Function;
		private var tempXPBarCallback:Function;
		
		public function updateXPBars(callback:Function = null):void
		{
			if (battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
			{
				// In a double battle, there are no XP bars
				callback();
			} else allyPokemonSlot.updateXPBar(callback);
		}
		
		private function hpBarCallback():void
		{
			if (allyPokemonSlot.isHPBarRed)
				SoundManager.playLowHealthWarning();
			else
				SoundManager.stopLowHealthWarning();
			
			if (MessageCenter.WAITING_ON_FINISH_MESSAGE)
				MessageCenter.finishMessage();
			if (tempHPBarCallback != null)
				tempHPBarCallback();
		}
		
		public function displayPokemonFaint(encodedString:String):void
		{
			SoundManager.stopLowHealthWarning();
			
			SoundManager.playSoundEffect(SoundEffect.POKEMON_FAINT);
			
			var pokemon2Fainted:Boolean = false;
			var pokemon:Pokemon;
			
			if (battle.enemyPokemon[0].toString() == encodedString || (battle.enemyPokemon.length > 1 && battle.enemyPokemon[1] && battle.enemyPokemon[1].toString() == encodedString))
			{
				// Animate this Pokemon fainting
				pokemon2Fainted = battle.enemyPokemon[0].toString() == encodedString ? false : true;
				pokemon = !pokemon2Fainted ? battle.enemyPokemon[0] : battle.enemyPokemon[1];
				
				SoundManager.playPokemonCry(pokemon.base.ID);
				if (!pokemon2Fainted) 
				{
					(enemyIcon as UIPokemonAnimatedSprite).faint();
					this.removeChild(enemyPokemonSlot);
					enemyPokemonSlot.destroy();
					enemyPokemonSlot = null;
				}
				else 
				{
					enemyIcon2.faint();
					this.removeChild(enemyPokemonSlot2);
					enemyPokemonSlot2.destroy();
					enemyPokemonSlot2 = null;
				}
				
				
				if (battle.TYPE == BattleType.WILD)
				{
					// There is only one wild pokemon and it has now fainted, so play the victory music track
					SoundManager.playMusicTrack(110);
				}
				else if (battle.TYPE == BattleType.TRAINER || battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
				{
					var fainted:int = 0;
					for (var i:int = 0; i < battle.enemyPokemon.length; i++)
					{
						if (battle.enemyPokemon[i].CURRENT_HP == 0) fainted++;
					}
					
					if (fainted == battle.enemyPokemon.length)
					{
						var trackToPlay:int = 118;
						switch (battle.enemyTrainers[0].TYPE)
						{
						case TrainerType.TEAM_MAGMA_GRUNT_MALE: 
						case TrainerType.TEAM_MAGMA_GRUNT_FEMALE: 
						case TrainerType.TEAM_AQUA_GRUNT_MALE: 
						case TrainerType.TEAM_AQUA_GRUNT_FEMALE: 
						case TrainerType.MAGMA_ADMIN_FEMALE: 
						case TrainerType.MAGMA_ADMIN_MALE: 
						case TrainerType.AQUA_ADMIN_FEMALE: 
						case TrainerType.AQUA_ADMIN_MALE: 
						case TrainerType.AQUA_LEADER_MALE: 
						case TrainerType.MAGMA_LEADER_MALE: 
							trackToPlay = 126;
							break;
						}
						SoundManager.playMusicTrack(trackToPlay);
					}
				}
			}
			else if (battle.allyPokemon[0].toString() == encodedString || (battle.allyPokemon[1] && battle.allyPokemon[1].toString() == encodedString))
			{
				pokemon2Fainted = battle.allyPokemon[0].toString() == encodedString ? false : true;
				pokemon = !pokemon2Fainted ? battle.allyPokemon[0] : battle.allyPokemon[1];
				
				SoundManager.playPokemonCry(pokemon.base.ID);
				if (!pokemon2Fainted)
				{
					(allyIcon as UIPokemonBackSprite).faint();
					this.removeChild(allyPokemonSlot);
					allyPokemonSlot.destroy();
					allyPokemonSlot = null;
				} else
				{
					allyIcon2.faint();
					this.removeChild(allyPokemonSlot2);
					allyPokemonSlot2.destroy();
					allyPokemonSlot2 = null;
				}
			}
			
			fixLayers();
			
			updateStatusConditions();
		}
		
		public function updateStatusConditions():void
		{
			if (allyPokemonSlot)
				allyPokemonSlot.updateStatusCondition();
			if (enemyPokemonSlot)
				enemyPokemonSlot.updateStatusCondition();
		}
		
		private var replacementFinishedCallback:Function;
		private var replacementReplacingPokemon:Pokemon;
		
		public function askForReplacementPokemon(_replacing:Pokemon, _finishedCallback:Function):void
		{
			replacementFinishedCallback = _finishedCallback;
			replacementReplacingPokemon = _replacing;
			Configuration.FADE_OUT_AND_IN(finishCreatingReplacementMenu);
		}
		
		private function finishCreatingReplacementMenu():void
		{
			Configuration.createMenu(MenuType.POKEMON, 1, replacementSelected);
		}
		
		private function replacementSelected(_replacement:Pokemon):void
		{
			replacementFinishedCallback(replacementReplacingPokemon, _replacement);
			
			replacementFinishedCallback = null;
			replacementReplacingPokemon = null;
		}
		
		private function createPokemonSlot(enemy:Boolean = true):void
		{
			if (enemy)
			{
				enemyPokemonSlot = new UIBattlePokemonSlot(battle.enemyPokemon[0], true, false);
				enemyPokemonSlot.x = 13 * Configuration.SPRITE_SCALE;
				enemyPokemonSlot.y = 16 * Configuration.SPRITE_SCALE;
				this.addChild(enemyPokemonSlot);
				
				if (battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
				{
					trace(battle.enemyPokemon[1], battle.enemyPokemon[1].ACTIVATED);
					if (battle.enemyPokemon[1] && battle.enemyPokemon[1].ACTIVATED)
					{
						enemyPokemonSlot2 = new UIBattlePokemonSlot(battle.enemyPokemon[1], true, false);
						enemyPokemonSlot2.x = 13 * Configuration.SPRITE_SCALE;
						enemyPokemonSlot2.y = 5 * Configuration.SPRITE_SCALE;
						this.addChild(enemyPokemonSlot2);
					}
					
					enemyPokemonSlot.x = 1 * Configuration.SPRITE_SCALE;
					enemyPokemonSlot.y = 30 * Configuration.SPRITE_SCALE;
				}
			}
			else
			{
				var isDouble:Boolean = (battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER ? true : false);
				allyPokemonSlot = new UIBattlePokemonSlot(battle.allyPokemon[0], false, !isDouble);
				allyPokemonSlot.x = 128 * Configuration.SPRITE_SCALE;
				allyPokemonSlot.y = 74 * Configuration.SPRITE_SCALE;
				this.addChild(allyPokemonSlot);
				
				if (battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
				{
					if (battle.allyPokemon[1] && battle.allyPokemon[1].ACTIVATED)
					{
						allyPokemonSlot2 = new UIBattlePokemonSlot(battle.allyPokemon[1], false, false);
						allyPokemonSlot2.x = 140 * Configuration.SPRITE_SCALE;
						allyPokemonSlot2.y = 87 * Configuration.SPRITE_SCALE;
						this.addChild(allyPokemonSlot2);
					}
					
					allyPokemonSlot.x = 128 * Configuration.SPRITE_SCALE;
					allyPokemonSlot.y = 62 * Configuration.SPRITE_SCALE;
				}
			}
		}
		
		private var callback:Function;
		private var _moveToPokemonCenter:Boolean;
		
		public function finishBattle(_callback:Function = null, moveToPokemonCenter:Boolean = false):void
		{
			callback = _callback;
			_moveToPokemonCenter = moveToPokemonCenter;
			Configuration.FADE_OUT_AND_IN(destroy);
			Configuration.ACTIVE_TRAINER.exitBattle();
			
			if (moveToPokemonCenter)
			{
				TweenLite.delayedCall(1, EntityManager.stepOnDoor, ["OVERWORLD", Configuration.ACTIVE_TRAINER.LAST_PC_XTILE, Configuration.ACTIVE_TRAINER.LAST_PC_YTILE, "down", true], true);
				Configuration.ACTIVE_TRAINER.restAllPokemon();
			}
		}
		
		private function finalizeSelectingReplacementPokemonForQuestion(newPokemon:Pokemon):void
		{
			if (newPokemon == null)
			{
				_questionCallback();
			}
			else
			{
				_questionReplacingPokemon.deactivate();
				newPokemon.activate();
				battle.comeBackPokemon(_questionReplacingPokemon);
				battle.replacementSelected(_questionReplacingPokemon, newPokemon, true);
			}
			
			_questionCallback = null;
			_questionReplacingPokemon = null;
		}
	
	}

}