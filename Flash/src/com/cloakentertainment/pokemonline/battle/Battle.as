package com.cloakentertainment.pokemonline.battle
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonBase;
	import com.cloakentertainment.pokemonline.stats.PokemonEffectiveness;
	import com.cloakentertainment.pokemonline.stats.PokemonItems;
	import com.cloakentertainment.pokemonline.stats.PokemonMoves;
	import com.cloakentertainment.pokemonline.stats.PokemonStat;
	import com.cloakentertainment.pokemonline.stats.PokemonStatusConditions;
	import com.cloakentertainment.pokemonline.stats.PokemonType;
	import com.cloakentertainment.pokemonline.trainer.Trainer;
	import com.cloakentertainment.pokemonline.trainer.TrainerBadge;
	import com.cloakentertainment.pokemonline.ui.UIBattle;
	import com.cloakentertainment.pokemonline.world.region.RegionManager;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class Battle
	{
		public var lastDamageDone:int = 0;
		public var lastDamageDoneByType:String = "";
		
		public var actionQueue:Vector.<BattleAction> = new Vector.<BattleAction>();
		public var allyPokemon:Vector.<Pokemon>;
		public var enemyPokemon:Vector.<Pokemon>;
		
		public var allyMoneyPot:int = 0;
		public var enemyMoneyPot:int = 0;
		
		public var allyTrainers:Vector.<Trainer>;
		public var enemyTrainers:Vector.<Trainer>;
		
		public var allyMoveEffects:Vector.<String> = new Vector.<String>();
		public var enemyMoveEffects:Vector.<String> = new Vector.<String>();
		
		public var WEATHER:String = BattleWeatherEffect.CLEAR_SKIES;
		public var WEATHER_DURATION:int = 0;
		public var TYPE:String = BattleType.WILD;
		public var LOCATION:String = BattleSpecialTile.PLAIN;
		
		public var battleCompleteCallback:Function;
		public var tutorialBattle:Boolean;
		
		public var UI_BATTLE:UIBattle;
		
		public function Battle(_battleType:String, _allyPokemon:Vector.<Pokemon>, _enemyPokemon:Vector.<Pokemon>, _allyTrainers:Vector.<Trainer>, _enemyTrainers:Vector.<Trainer>, _location:String = BattleSpecialTile.PLAIN, _weather:String = BattleWeatherEffect.CLEAR_SKIES, _battleCompleteCallback:Function = null, _tutorialBattle:Boolean = false)
		{
			if (_battleType != BattleType.ONLINE_TRAINER && _battleType != BattleType.WILD && _battleType != BattleType.TRAINER && _battleType != BattleType.DOUBLE_TRAINERxDOUBLE_TRAINER && _battleType != BattleType.DOUBLE_TRAINERxTRAINER)
			{
				throw(new Error('Unknown Battle Type "' + _battleType + '"!'));
			}
			LOCATION = _location;
			WEATHER = _weather;
			TYPE = _battleType;
			allyPokemon = _allyPokemon;
			enemyPokemon = _enemyPokemon;
			allyTrainers = _allyTrainers;
			enemyTrainers = _enemyTrainers;
			battleCompleteCallback = _battleCompleteCallback;
			tutorialBattle = _tutorialBattle;
			
			allyTrainers[0].enterBattle();
			if (enemyTrainers != null && enemyTrainers.length > 0)
				enemyTrainers[0].enterBattle();
			else if (enemyTrainers == null) enemyTrainers = new Vector.<Trainer>();
			
			// Make sure the first pokemon isn't fainted!
			getNextAvailablePokemon(true, 0, null);
			
			// Activate the first Pokémon in each array - they will be fighting first.
			allyPokemon[0].activate();
			enemyPokemon[0].activate();
			
			if (TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
			{
				// This is a double battle, activate the two next pokemon!
				var nextAllyPokemon:Pokemon = getNextAvailablePokemon(true, 1);
				if (nextAllyPokemon) nextAllyPokemon.activate();
				
				var nextEnemyPokemon:Pokemon = getNextAvailablePokemon(false, 1);
				if (nextEnemyPokemon) nextEnemyPokemon.activate();
			}
			
			UI_BATTLE = new UIBattle(this);
			Configuration.STAGE.addChild(UI_BATTLE);
			Configuration.fixFPSCounter();
		}
		
		public function getNextAvailablePokemon(ally:Boolean, startingIndex:int = 0, cantChoose:Pokemon = null):Pokemon
		{
			var index:int = startingIndex;
			var oldPokemon:Pokemon;
			while (true)
			{
				if (ally)
				{
					if (allyPokemon[index] && allyPokemon[index].CURRENT_HP > 0) 
					{
						if (index != startingIndex)
						{
							oldPokemon = allyPokemon[startingIndex];
							allyPokemon[startingIndex] = allyPokemon[index];
							allyPokemon[index] = oldPokemon;
							index = startingIndex;
						}
						return allyPokemon[index];
					}
					else
					if (index >= 6) return null;
					else
					{
						index++;
					}
				} else
				if (!ally)
				{
					if (enemyPokemon[index] && enemyPokemon[index].CURRENT_HP > 0)
					{
						if (index != startingIndex)
						{
							oldPokemon = enemyPokemon[startingIndex];
							enemyPokemon[startingIndex] = enemyPokemon[index];
							enemyPokemon[index] = oldPokemon;
							index = startingIndex;
						}
						return enemyPokemon[index];
					}
					else
					if (index >= 6) return null;
					else
					{
						index++;
					}
				}
			}
			
			return null;
		}
		
		public function getNumberOfActivePokemon(pokemon:Pokemon):int
		{
			var active:int = 0;
			var i:uint = 0;
			if (isPokemonAnAlly(pokemon))
			{
				for (i = 0; i < allyPokemon.length; i++)
				{
					if (allyPokemon[i].ACTIVE)
						active++;
				}
			}
			else
			{
				for (i = 0; i < enemyPokemon.length; i++)
				{
					if (enemyPokemon[i].ACTIVE)
						active++;
				}
			}
			return active;
		}
		
		public function getNumberOfActionsToBeSubmitted():int
		{
			var actions:int = getNumberOfActivePokemon(allyPokemon[0]) + getNumberOfActivePokemon(enemyPokemon[0]) - actionQueue.length;
			
			return actions;
		}
		
		public function doesPokemonNeedToSubmitAction(pokemon:Pokemon):Boolean
		{
			for (var i:uint = 0; i < actionQueue.length; i++)
			{
				if (actionQueue[i].OWNER == pokemon)
					return false;
			}
			
			return true;
		}
		
		public function submitAction(battleAction:BattleAction):void
		{
			for (var i:uint = 0; i < actionQueue.length; i++)
			{
				if (actionQueue[i].OWNER == battleAction.OWNER)
					return; // This Pokemon has already submitted an action!
			}
			
			if (actionQueue.length < getNumberOfActivePokemon(allyPokemon[0]) + getNumberOfActivePokemon(enemyPokemon[0]))
				actionQueue.push(battleAction);
			else
				return;
			
			if (battleAction.TYPE == BattleAction.MOVE)
			{
				battleAction.OWNER.changeGoingToUseMove(battleAction.MOVEID);
			}
			
			battleAction.OWNER.activate();
			
			if (getNumberOfActionsToBeSubmitted() == 0)
				processTurn(); // We have an action for each Pokémon, start processing!
		}
		
		/*
		 * Starts to process the action queue in the specified turn order
		 * */
		private function processTurn():void
		{
			if (!canBeginTurn)
				return;
			canBeginTurn = false;
			/*
			 * Priority:
			 * +8: Charging of Focus Punch
			 * +7: Pursuit, if an enemy pokemon is switching
			 * +6: Switching out, using items, escaping
			 * +5: Helping Hand
			 * +4: Magic Coat, Snatch
			 * +3: Detect, Endure, Follow Me, Protect
			 * +2: None
			 * +1: Extreme Speed, Fake Out, Mach Punch, Quick Attack
			 *  0: All other moves, fleeing
			 * -1: Vital Throw
			 * -2: None
			 * -3: Focus Punch
			 * -4: None
			 * -5: Counter, Mirror Coat, Roar, Whirlwind
			 * */
			
			// Sort by Move priority
			actionQueue.sort(sortActionsQuick);
			actionQueue.sort(sortActions);
			
			// Put in Focus Punch's charging turn, if applicable
			var focusPunches:Vector.<BattleAction> = new Vector.<BattleAction>();
			addStruggleMessage = new Vector.<String>();
			var i:uint = 0;
			for (i = 0; i < actionQueue.length; i++)
			{
				if (actionQueue[i].TYPE == BattleAction.MOVE && PokemonMoves.getMoveNameByID(actionQueue[i].MOVEID) == "Focus Punch")
				{
					var battleAction2:BattleAction = BattleAction.recreateMove(actionQueue[i].OWNER, actionQueue[i].TARGET, actionQueue[i].MOVEID, actionQueue[i].QUICKCLAW, actionQueue[i].ACCURACY, actionQueue[i].getObedience(1), actionQueue[i].getObedience(2), actionQueue[i].getObedience(3), actionQueue[i].IGNORE_MOVE, actionQueue[i].MAGNITUDE, actionQueue[i].METRONOME, actionQueue[i].CRITICAL_HIT, actionQueue[i].ASTONISH, actionQueue[i].DAMAGE_VARIANCE);
					focusPunches.push(battleAction2);
				}
				else if (actionQueue[i].TYPE == BattleAction.MOVE && PokemonMoves.getMoveNameByID(actionQueue[i].MOVEID) == "Struggle")
				{
					addStruggleMessage.push(actionQueue[i].OWNER.NAME);
				}
			}
			for (i = 0; i < focusPunches.length; i++)
			{
				actionQueue.splice(0, 0, focusPunches[i]);
			}
			
			trace("TURN: Beginning turn. **************************************************************");
			endOfTurnEffectsPerformed = false;
			nextTurn();
		}
		private var canBeginTurn:Boolean = true;
		private var addStruggleMessage:Vector.<String>;
		private var endOfTurnEffectsPerformed:Boolean = false;
		
		private function finishTurn():void
		{
			if (canBeginTurn)
				return;
			
			if (actionQueue.length != 0)
			{
				actionQueue.splice(0, 1);
				nextTurn();
				return;
			}
			
			clearQueue();
			
			if (endOfTurnEffectsPerformed == false)
			{
				endOfTurnEffectsPerformed = true;
				performEndOfTurnEffects();
				return;
			}
			
			clearQueue();
			
			// check for team move effects
			removeTeamBattleEffect(BattleEffect.MIST1);
			replaceTeamBattleEffect(BattleEffect.MIST2, BattleEffect.MIST1);
			replaceTeamBattleEffect(BattleEffect.MIST3, BattleEffect.MIST2);
			replaceTeamBattleEffect(BattleEffect.MIST4, BattleEffect.MIST3);
			replaceTeamBattleEffect(BattleEffect.MIST5, BattleEffect.MIST4);
			removeTeamBattleEffect(BattleEffect.LIGHT_SCREEN1);
			replaceTeamBattleEffect(BattleEffect.LIGHT_SCREEN2, BattleEffect.LIGHT_SCREEN1);
			replaceTeamBattleEffect(BattleEffect.LIGHT_SCREEN3, BattleEffect.LIGHT_SCREEN2);
			replaceTeamBattleEffect(BattleEffect.LIGHT_SCREEN4, BattleEffect.LIGHT_SCREEN3);
			replaceTeamBattleEffect(BattleEffect.LIGHT_SCREEN5, BattleEffect.LIGHT_SCREEN4);
			removeTeamBattleEffect(BattleEffect.REFLECT1);
			replaceTeamBattleEffect(BattleEffect.REFLECT2, BattleEffect.REFLECT1);
			replaceTeamBattleEffect(BattleEffect.REFLECT3, BattleEffect.REFLECT2);
			replaceTeamBattleEffect(BattleEffect.REFLECT4, BattleEffect.REFLECT3);
			replaceTeamBattleEffect(BattleEffect.REFLECT5, BattleEffect.REFLECT4);
			removeTeamBattleEffect(BattleEffect.SAFEGUARD1);
			replaceTeamBattleEffect(BattleEffect.SAFEGUARD2, BattleEffect.SAFEGUARD1);
			replaceTeamBattleEffect(BattleEffect.SAFEGUARD3, BattleEffect.SAFEGUARD2);
			replaceTeamBattleEffect(BattleEffect.SAFEGUARD4, BattleEffect.SAFEGUARD3);
			replaceTeamBattleEffect(BattleEffect.SAFEGUARD5, BattleEffect.SAFEGUARD4);
			
			var i:uint = 0;
			var repeatLastMoves:Vector.<Pokemon> = new Vector.<Pokemon>();
			for (i = 0; i < allyPokemon.length; i++)
			{
				if (allyPokemon[i].ACTIVE == false)
					continue;
				allyPokemon[i].changeGoingToUseMove(0);
				if (allyPokemon[i].areBattleEffectsActive(BattleEffect.RECHARGING, BattleEffect.REPEAT_ATTACK6, BattleEffect.REPEAT_ATTACK5, BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK3, BattleEffect.REPEAT_ATTACK2, BattleEffect.FLY, BattleEffect.SKULL_BASH, BattleEffect.SKY_ATTACK, BattleEffect.DIG, BattleEffect.SOLARBEAM, BattleEffect.BOUNCE, BattleEffect.DIVE))
				{
					// Repeat the last move!
					trace("Repeating ally move.");
					repeatLastMoves.push(allyPokemon[i]);
				}
				allyPokemon[i].deactivateBattleEffect(BattleEffect.ENDURE);
				allyPokemon[i].deactivateBattleEffect(BattleEffect.PROTECT);
				allyPokemon[i].deactivateBattleEffect(BattleEffect.DETECT);
				allyPokemon[i].deactivateBattleEffect(BattleEffect.YAWN1);
				allyPokemon[i].deactivateBattleEffect(BattleEffect.DESTINY_BOND);
				allyPokemon[i].replaceBattleEffect(BattleEffect.YAWN2, BattleEffect.YAWN1);
				allyPokemon[i].deactivateBattleEffect(BattleEffect.TOOK_DAMAGE_SAME_TURN);
				if (allyPokemon[i].isBattleEffectActive(BattleEffect.REPEAT_ATTACK1))
				{
					allyPokemon[i].deactivateBattleEffect(BattleEffect.REPEAT_ATTACK1);
					allyPokemon[i].deactivateBattleEffect(BattleEffect.ENCORE);
				}
				allyPokemon[i].SNATCHED = null;
				allyPokemon[i].deactivateBattleEffect(BattleEffect.WISH1);
				allyPokemon[i].deactivateBattleEffect(BattleEffect.TAUNT1);
				allyPokemon[i].replaceBattleEffect(BattleEffect.TAUNT2, BattleEffect.TAUNT1);
				allyPokemon[i].replaceBattleEffect(BattleEffect.WISH2, BattleEffect.WISH1);
				allyPokemon[i].replaceBattleEffect(BattleEffect.PERISH_SONG2, BattleEffect.PERISH_SONG1);
				allyPokemon[i].replaceBattleEffect(BattleEffect.PERISH_SONG3, BattleEffect.PERISH_SONG2);
				allyPokemon[i].replaceBattleEffect(BattleEffect.REPEAT_ATTACK2, BattleEffect.REPEAT_ATTACK1);
				allyPokemon[i].replaceBattleEffect(BattleEffect.REPEAT_ATTACK3, BattleEffect.REPEAT_ATTACK2);
				allyPokemon[i].replaceBattleEffect(BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK3);
				allyPokemon[i].replaceBattleEffect(BattleEffect.REPEAT_ATTACK5, BattleEffect.REPEAT_ATTACK4);
				allyPokemon[i].replaceBattleEffect(BattleEffect.REPEAT_ATTACK6, BattleEffect.REPEAT_ATTACK5);
				allyPokemon[i].deactivateBattleEffect(BattleEffect.CANNOT_ATTACK1);
				allyPokemon[i].replaceBattleEffect(BattleEffect.CANNOT_ATTACK2, BattleEffect.CANNOT_ATTACK1);
				allyPokemon[i].replaceBattleEffect(BattleEffect.CANNOT_ATTACK3, BattleEffect.CANNOT_ATTACK2);
				allyPokemon[i].replaceBattleEffect(BattleEffect.CANNOT_ATTACK4, BattleEffect.CANNOT_ATTACK3);
				allyPokemon[i].replaceBattleEffect(BattleEffect.CANNOT_ATTACK5, BattleEffect.CANNOT_ATTACK4);
				
				allyPokemon[i].increaseTurnsActive();
			}
			for (i = 0; i < enemyPokemon.length; i++)
			{
				if (enemyPokemon[i].ACTIVE == false)
					continue;
				enemyPokemon[i].changeGoingToUseMove(0);
				if (TYPE != BattleType.ONLINE_TRAINER && enemyPokemon[i].areBattleEffectsActive(BattleEffect.SKY_ATTACK, BattleEffect.RECHARGING, BattleEffect.REPEAT_ATTACK5, BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK3, BattleEffect.SKULL_BASH, BattleEffect.REPEAT_ATTACK2, BattleEffect.FLY, BattleEffect.DIVE, BattleEffect.DIG, BattleEffect.SOLARBEAM, BattleEffect.BOUNCE))
				{
					// Repeat the last move!
					repeatLastMoves.push(enemyPokemon[i]);
				}
				enemyPokemon[i].deactivateBattleEffect(BattleEffect.ENDURE);
				enemyPokemon[i].deactivateBattleEffect(BattleEffect.PROTECT);
				enemyPokemon[i].deactivateBattleEffect(BattleEffect.DETECT);
				enemyPokemon[i].deactivateBattleEffect(BattleEffect.YAWN1);
				enemyPokemon[i].deactivateBattleEffect(BattleEffect.DESTINY_BOND);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.YAWN2, BattleEffect.YAWN1);
				enemyPokemon[i].deactivateBattleEffect(BattleEffect.TOOK_DAMAGE_SAME_TURN);
				if (enemyPokemon[i].isBattleEffectActive(BattleEffect.REPEAT_ATTACK1))
				{
					enemyPokemon[i].deactivateBattleEffect(BattleEffect.REPEAT_ATTACK1);
					enemyPokemon[i].deactivateBattleEffect(BattleEffect.ENCORE);
				}
				enemyPokemon[i].SNATCHED = null;
				enemyPokemon[i].deactivateBattleEffect(BattleEffect.WISH1);
				enemyPokemon[i].deactivateBattleEffect(BattleEffect.TAUNT1);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.TAUNT2, BattleEffect.TAUNT1);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.WISH2, BattleEffect.WISH1);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.PERISH_SONG2, BattleEffect.PERISH_SONG1);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.PERISH_SONG3, BattleEffect.PERISH_SONG2);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.REPEAT_ATTACK2, BattleEffect.REPEAT_ATTACK1);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.REPEAT_ATTACK3, BattleEffect.REPEAT_ATTACK2);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK3);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.REPEAT_ATTACK5, BattleEffect.REPEAT_ATTACK4);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.REPEAT_ATTACK6, BattleEffect.REPEAT_ATTACK5);
				enemyPokemon[i].deactivateBattleEffect(BattleEffect.CANNOT_ATTACK1);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.CANNOT_ATTACK2, BattleEffect.CANNOT_ATTACK1);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.CANNOT_ATTACK3, BattleEffect.CANNOT_ATTACK2);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.CANNOT_ATTACK4, BattleEffect.CANNOT_ATTACK3);
				enemyPokemon[i].replaceBattleEffect(BattleEffect.CANNOT_ATTACK5, BattleEffect.CANNOT_ATTACK4);
				
				enemyPokemon[i].increaseTurnsActive();
			}
			
			trace("TURN: Turn finished. ***************************************************************");
			
			canBeginTurn = true;
			for (i = 0; i < repeatLastMoves.length; i++)
			{
				repeatLastMove(repeatLastMoves[i]);
			}
			
			UI_BATTLE.askPlayerForAction();
			//main.applyMoveMoves();
		}
		
		public function transmitAction(battleAction:BattleAction):void
		{
			// Send action to other players!
			submitAction(battleAction);
		}
		
		private function repeatLastMove(pokemon:Pokemon):void
		{
			if (pokemon.isBattleEffectActive(BattleEffect.ENCORE))
			{
				var moveToUse:String = PokemonMoves.getMoveNameByID(pokemon.LAST_MOVE_USED);
				var stopEffects:Boolean = false;
				if (pokemon.getMove(1) == moveToUse)
				{
					if (pokemon.getMovePP(1) == 0)
						stopEffects = true;
					else
						pokemon.reducePP(pokemon.LAST_MOVE_USED);
				}
				else if (pokemon.getMove(2) == moveToUse)
				{
					if (pokemon.getMovePP(2) == 0)
						stopEffects = true;
					else
						pokemon.reducePP(pokemon.LAST_MOVE_USED);
				}
				else if (pokemon.getMove(3) == moveToUse)
				{
					if (pokemon.getMovePP(3) == 0)
						stopEffects = true;
					else
						pokemon.reducePP(pokemon.LAST_MOVE_USED);
				}
				else if (pokemon.getMove(4) == moveToUse)
				{
					if (pokemon.getMovePP(4) == 0)
						stopEffects = true;
					else
						pokemon.reducePP(pokemon.LAST_MOVE_USED);
				}
				if (stopEffects)
					return;
			}
			var action:BattleAction = BattleAction.generateMove(pokemon, null, pokemon.LAST_MOVE_USED);
			transmitAction(action);
		}
		
		private function performEndOfTurnEffects():void
		{
			messages = new Vector.<String>();
			turnResults = new Vector.<BattleActionResult>();
			var i:uint = 0;
			for (i = 0; i < allyPokemon.length; i++)
			{
				if (allyPokemon[i].ACTIVE)
					checkPokemonForEndOfTurnEffects(allyPokemon[i]);
			}
			for (i = 0; i < enemyPokemon.length; i++)
			{
				if (enemyPokemon[i].ACTIVE)
					checkPokemonForEndOfTurnEffects(enemyPokemon[i]);
			}
			
			if (WEATHER_DURATION <= 0 && WEATHER != BattleWeatherEffect.CLEAR_SKIES)
			{
				// Stop being weathery
				injectBattleActionResult(BattleActionResult.generateStatusResult(allyPokemon[0], BattleActionResult.WEATHER_STOPPED, 0));
			}
			else if (WEATHER != BattleWeatherEffect.CLEAR_SKIES)
			{
				WEATHER_DURATION--;
				injectBattleActionResult(BattleActionResult.generateStatusResult(allyPokemon[0], BattleActionResult.DESCRIBE_WEATHER, 0, 0));
			}
			
			if (actionQueue.length != 0)
				nextTurn();
			else
				nextInterpretation();
		}
		
		private function checkPokemonForEndOfTurnEffects(pokemon:Pokemon):void
		{
			if (pokemon.isBattleEffectActive(BattleEffect.YAWN1) && pokemon.getNonVolatileStatusCondition() == null)
			{
				injectBattleActionResult(BattleActionResult.generateMoveResult(PokemonMoves.getMoveIDByName("Yawn"), 20, 0, pokemon, pokemon, BattleActionResult.STATUS_SLEEP)); // induce sleep
				
			}
			if (WEATHER == BattleWeatherEffect.HAIL)
			{
				injectBattleActionResult(BattleActionResult.generateMoveResult(999, 20, 0.0625 * pokemon.getStat(PokemonStat.HP), pokemon, pokemon, BattleActionResult.WEATHER_HAILING));
			}
			if (WEATHER == BattleWeatherEffect.SANDSTORM)
			{
				injectBattleActionResult(BattleActionResult.generateMoveResult(999, 20, 0.0625 * pokemon.getStat(PokemonStat.HP), pokemon, pokemon, BattleActionResult.WEATHER_SANDSTORM));
			}
			if (pokemon.isBattleEffectActive(BattleEffect.WISH1))
			{
				injectBattleActionResult(BattleActionResult.generateMoveResult(PokemonMoves.getMoveIDByName("Wish"), 20, -0.5 * pokemon.getStat(PokemonStat.HP), pokemon, pokemon, BattleActionResult.MOVE_NORMAL_USE));
			}
			if (pokemon.isBattleEffectActive(BattleEffect.PERISH_SONG1))
			{
				// we perish!
				injectBattleActionResult(BattleActionResult.generateMoveResult(PokemonMoves.getMoveIDByName("Perish Song"), 20, pokemon.CURRENT_HP, pokemon, pokemon, BattleActionResult.MOVE_PERISH_SONG));
				return;
			}
			else if (pokemon.areBattleEffectsActive(BattleEffect.PERISH_SONG3, BattleEffect.PERISH_SONG2))
			{
				injectBattleActionResult(BattleActionResult.generateMoveResult(PokemonMoves.getMoveIDByName("Perish Song"), 20, 0, pokemon, pokemon, BattleActionResult.MOVE_PERISH_SONG));
			}
			if (pokemon.isBattleEffectActive(BattleEffect.LEECH_SEED))
			{
				dealRecurrentDamage(pokemon, BattleActionResult.MOVE_NORMAL_USE, "Leech Seed");
				
			}
			if (pokemon.isBattleEffectActive(BattleEffect.INGRAIN))
			{
				injectBattleActionResult(BattleActionResult.generateMoveResult(PokemonMoves.getMoveIDByName("Ingrain"), 20, (-1 / 16) * pokemon.getStat(PokemonStat.HP), pokemon, pokemon, BattleActionResult.MOVE_NORMAL_USE));
			}
			if (pokemon.isBattleEffectActive(BattleEffect.NIGHTMARE))
			{
				if (pokemon.getNonVolatileStatusCondition() != PokemonStatusConditions.SLEEP)
				{
					pokemon.deactivateBattleEffect(BattleEffect.NIGHTMARE);
				}
				else
				{
					dealRecurrentDamage(pokemon, BattleActionResult.MOVE_NORMAL_USE, "Nightmare", false);
				}
			}
			if (pokemon.isBattleEffectActive(BattleEffect.CURSE))
			{
				dealRecurrentDamage(pokemon, BattleActionResult.MOVE_NORMAL_USE, "Curse", false);
			}
			if (pokemon.isBattleEffectActive(BattleEffect.TOXIC))
			{
				dealRecurrentDamage(pokemon, BattleActionResult.MOVE_NORMAL_USE, "Toxic", false);
			}
			if (pokemon.getNonVolatileStatusCondition() == PokemonStatusConditions.POISON)
			{
				dealRecurrentDamage(pokemon, BattleActionResult.STATUS_POISON, "Confusion", false);
			}
			else if (pokemon.getNonVolatileStatusCondition() == PokemonStatusConditions.BURN)
			{
				dealRecurrentDamage(pokemon, BattleActionResult.STATUS_BURN, "Confusion", false);
			}
		}
		
		private function swapActionTargets(oldTarget:Pokemon, newTarget:Pokemon):void
		{
			trace("Swapping", oldTarget.NAME, newTarget ? newTarget.NAME : null);
			for (var i:int = 0; i < actionQueue.length; i++)
			{
				if (actionQueue[i].TARGET == oldTarget)
				{
					trace("Found", actionQueue[i].OWNER, actionQueue[i].TYPE, actionQueue[i].TARGET);
					if (newTarget == null)
					{
						actionQueue.splice(i, 1);
						i--;
					} else
					{
						actionQueue[i].setTarget(newTarget);
					}
				}
			}
		}
		
		private var _replacementCallback:Function; // should accept one pokemon
		private var _replacing:Pokemon;
		
		private function selectReplacementPokemon(pokemon:Pokemon, finishedCallback:Function):void
		{
			_replacementCallback = finishedCallback;
			_replacing = pokemon;
			var i:int;
			// check if this pokemon is "ours"
			if (isPokemonAnAlly(pokemon))
			{
				// It's ours...
				//_replacementCallback(_replacing, main.getReplacementPokemon());
				
				// sure we still have pokemon left to replace with
				var canReplace:Boolean = false;
				for (i = 0; i < allyPokemon.length; i++)
				{
					if (allyPokemon[i].CURRENT_HP > 0)
						canReplace = true;
				}
				
				if (!canReplace)
					_replacementCallback(_replacing, null);
				else
					UI_BATTLE.askForReplacementPokemon(_replacing, _replacementCallback);
			}
			else
			{
				// Give the active pokemon experience!
				for (i = 0; i < allyPokemon.length; i++)
				{
					if (allyPokemon[i].ACTIVATED && allyPokemon[i].FOUGHT_LAST_POKEMON && allyPokemon[i].getNonVolatileStatusCondition() != PokemonStatusConditions.FAINT)
						givePokemonExperience(allyPokemon[i], _replacing);
				}
				
				var nextPokemon:Pokemon;
				if (TYPE == BattleType.WILD)
				{
					// There aren't any replacement in a wild pokemon battle, it's over!
					messages.push("BATTLEWON: You won!");
				}
				else if (TYPE == BattleType.ONLINE_TRAINER)
				{
					// We'll wait until they select a pokemon.
					messages.push("MESSAGE://Waiting for " + _replacing.TRAINER.NAME + " to select a Pokémon.");
				}
				else if (TYPE == BattleType.TRAINER)
				{
					for (i = 0; i < enemyPokemon.length; i++)
					{
						if (enemyPokemon[i].CURRENT_HP > 0)
						{
							nextPokemon = enemyPokemon[i];
							break;
						}
					}
					
					// set all ally pokemon to be nonparticipants
					for (i = 0; i < allyPokemon.length; i++)
					{
						allyPokemon[i].setNonParticipant();
					}
					
					if (nextPokemon == null)
					{
						// We won!
						messages.push("MESSAGE://" + Configuration.ACTIVE_TRAINER.NAME + " defeated\n" + _replacing.TRAINER.NAME + "!");
						messages.push("SHOWENEMYTRAINER");
						messages.push("MESSAGE://" + _replacing.TRAINER.LOSING_TEXT_QUOTE);
						messages.push("MESSAGE://" + Configuration.ACTIVE_TRAINER.NAME + " got " + Configuration.CURRENCY_SYMBOL + _replacing.TRAINER.WINNINGS + " for winning!");
						messages.push("BATTLEWON: You won!");
						Configuration.ACTIVE_TRAINER.giveMoney(_replacing.TRAINER.WINNINGS);
					}
					else
					{
						replaceTrainerCalled = false;
						if (allyPokemon.length > 1)
						{
							messages.push("MESSAGE://" + _replacing.TRAINER.NAME + " is about to use\n" + nextPokemon.NAME + ".");
							messages.push("QUESTION://Will " + allyTrainers[0].NAME + " change POKéMON?//changepokemon//null//Yes//No");
							trainerReplacingCallback = _replacementCallback;
							trainerReplacingPokemon = _replacing;
							trainerReplacingPokemonNew = nextPokemon;
						}
						else
						{
							messages.push("BRINGINNEXTPOKEMON");
							trainerReplacingCallback = _replacementCallback;
							trainerReplacingPokemon = _replacing;
							trainerReplacingPokemonNew = nextPokemon;
						}
					}
				} else if (TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
				{
					var allOutOfHP:Boolean = true;
					for (i = 0; i < enemyPokemon.length; i++)
					{
						if (enemyPokemon[i].CURRENT_HP > 0 && !enemyPokemon[i].ACTIVATED)
						{
							nextPokemon = enemyPokemon[i];
							break;
						} else
						if (enemyPokemon[i].CURRENT_HP > 0) allOutOfHP = false;
					}
					
					
					// set all ally pokemon to be nonparticipants
					for (i = 0; i < allyPokemon.length; i++)
					{
						allyPokemon[i].setNonParticipant();
					}
					
					if (nextPokemon == null && allOutOfHP)
					{
						// We won!
						messages.push("MESSAGE://" + Configuration.ACTIVE_TRAINER.NAME + " defeated\n" + _replacing.TRAINER.NAME + "!");
						messages.push("SHOWENEMYTRAINER");
						messages.push("MESSAGE://" + _replacing.TRAINER.LOSING_TEXT_QUOTE);
						messages.push("MESSAGE://" + Configuration.ACTIVE_TRAINER.NAME + " got " + Configuration.CURRENCY_SYMBOL + _replacing.TRAINER.WINNINGS + " for winning!");
						messages.push("BATTLEWON: You won!");
						Configuration.ACTIVE_TRAINER.giveMoney(_replacing.TRAINER.WINNINGS);
					} else if (nextPokemon == null)
					{
						// They don't have a pokemon to replace the last fainted one, but they still have a pokemon to battle with.
						replaceTrainerCalled = false;
						trainerReplacingCallback = _replacementCallback;
						trainerReplacingPokemon = _replacing;
						trainerReplacingPokemonNew = null;
						replaceTrainerPokemon();
					}
					else
					{
						replaceTrainerCalled = false;
						swapActionTargets(_replacing, nextPokemon);
						if (allyPokemon.length > 1)
						{
							messages.push("MESSAGE://" + _replacing.TRAINER.NAME + " is about to use\n" + nextPokemon.NAME + ".");
							messages.push("QUESTION://Will " + allyTrainers[0].NAME + " change POKéMON?//changepokemon//null//Yes//No");
							trainerReplacingCallback = _replacementCallback;
							trainerReplacingPokemon = _replacing;
							trainerReplacingPokemonNew = nextPokemon;
						}
						else
						{
							messages.push("BRINGINNEXTPOKEMON");
							trainerReplacingCallback = _replacementCallback;
							trainerReplacingPokemon = _replacing;
							trainerReplacingPokemonNew = nextPokemon;
						}
					}
				}
				else
				{
					throw(new Error('Cannot select a replacement for this battle type: ' + TYPE));
				}
				
				nextMessage();
			}
		}
		
		private var trainerReplacingCallback:Function = null;
		private var trainerReplacingPokemon:Pokemon = null;
		private var trainerReplacingPokemonNew:Pokemon = null;
		private var replaceTrainerCalled:Boolean = false;
		
		public function replaceTrainerPokemon():void
		{
			if (checkForPokemonWaitingMoveAssignment())
			{
				nextMessage();
				return;
			}
			if (replaceTrainerCalled)
				return;
			replaceTrainerCalled = true;
			if (trainerReplacingPokemonNew)
			{
				messages.push("MESSAGE://" + trainerReplacingPokemon.TRAINER.NAME + " sent out\n" + trainerReplacingPokemonNew.NAME + "!//true");
			}
			trainerReplacingCallback(trainerReplacingPokemon, trainerReplacingPokemonNew);
			trainerReplacingPokemon = trainerReplacingPokemonNew = null;
			trainerReplacingCallback = null;
		}
		
		private function checkForPokemonWaitingMoveAssignment(pokemonToCheck:Pokemon = null):Boolean
		{
			var newMoves:Boolean = false;
			// check for pokemon needing to learn new moves
			for (var i:int = 0; i < allyPokemon.length; i++)
			{
				if (checkPokemonForNewMoves(allyPokemon[i])) newMoves = true;
			}
			
			return newMoves;
		}
		
		private function checkPokemonForNewMoves(pokemonToCheck:Pokemon):Boolean
		{
			var newMoves:Boolean = false;
			if (pokemonToCheck.learnableMoves != null && pokemonToCheck.learnableMoves.length > 0)
			{
				trace("NEW MOVES: " + pokemonToCheck.learnableMoves.length);
				newMoves = true;
				for (var j:int = 0; j < pokemonToCheck.learnableMoves.length; j++)
				{
					trace("ADDED: " + pokemonToCheck.learnableMoves[j]);
					addLearnMoveMessage(pokemonToCheck, pokemonToCheck.learnableMoves[j]);
				}
			}
			pokemonToCheck.learnableMoves = null;
			
			return newMoves;
		}
		
		public function addLearnMoveMessage(pokemon:Pokemon, moveName:String):void
		{
			messages.splice(0, 0, "LEARNMOVE://" + pokemon.toString() + "//" + moveName);
		}
		
		private function givePokemonExperience(pokemon:Pokemon, faintedPokemon:Pokemon):void
		{
			// give the pokemon EVs
			var base:PokemonBase = faintedPokemon.transformed == null ? faintedPokemon.base : faintedPokemon.transformed.base;
			pokemon.giveEVs(base.HPEVYield, base.ATKEVYield, base.DEFEVYield, base.SPATKEVYield, base.SPDEFEVYield, base.SPEEDEVYield);
			
			var a:Number = TYPE == BattleType.WILD ? 1 : 1.5;
			var b:Number = base.baseExperienceYield;
			var e:Number = pokemon.HELDITEM == "Lucky Egg" ? 1.5 : 1;
			var f:Number = 1;
			var L:int = faintedPokemon.LEVEL;
			var p:int = 1;
			var activatedPokemon:int = 0;
			var expShare:int = 0;
			for (var i:int = 0; i < allyPokemon.length; i++)
			{
				if (allyPokemon[i].HELDITEM == "Exp. Share")
					expShare++;
				if (allyPokemon[i].ACTIVATED && allyPokemon[i].FOUGHT_LAST_POKEMON && allyPokemon[i].getNonVolatileStatusCondition() != PokemonStatusConditions.FAINT)
					activatedPokemon++;
			}
			var s:Number = 1;
			if (expShare == 0)
			{
				s = activatedPokemon;
			}
			else
			{
				if (pokemon.HELDITEM != "Exp. Share")
					s = 2 * activatedPokemon;
				else
					s = 2 * expShare;
			}
			var t:Number = pokemon.OTNAME == pokemon.TRAINER.NAME ? 1 : 1.5;
			var v:int = 1;
			var EXP:int = (a * t * b * e * L * p * f * v) / (7 * s);
			messages.push("MESSAGE://" + pokemon.NAME + " gained " + EXP + " EXP!");
			if(TYPE != BattleType.DOUBLE_TRAINERxTRAINER) messages.push("UPDATEUIXPBARS");
			if (pokemon.giveXP(EXP))
			{
				messages.push("MESSAGE://" + pokemon.NAME + " grew to\nLV. " + pokemon.LEVEL + "!");
				messages.push("LEVELUP://" + pokemon.toString());
				pokemon.levelledUpThisBattle();
			}
		}
		
		public function replacementSelected(oldPokemon:Pokemon, newPokemon:Pokemon, interpret:Boolean = true):void
		{
			if (newPokemon)
				trace("Replacing " + oldPokemon.NAME + " with " + newPokemon.NAME);
			_replacing = null;
			_replacementCallback = null;
			
			oldPokemon.clearBattleModifiers();
			if (newPokemon == null && oldPokemon.isWild)
			{
				INTERPRETATION_HALTED = true;
				messages.push("BATTLEWON: You won!");
				nextMessage();
				return;
			}
			else if (newPokemon == null && isPokemonAnAlly(oldPokemon) && TYPE != BattleType.DOUBLE_TRAINERxTRAINER)
			{
				// The trainer of this pokemon is out of usable pokemon.
				messages.push("MESSAGE://" + oldPokemon.TRAINER.NAME + " is out of usable POKéMON!");
				messages.push("MESSAGE://" + oldPokemon.TRAINER.NAME + " whited out!");
				if (isPokemonAnAlly(oldPokemon))
				{
					// We just whited out.
					messages.push("WHITEOUT: Game over.");
				}
				else
				{
					// We just won!
					messages.push("BATTLEWON: You won!");
				}
				
				nextMessage();
				return;
			} else if (newPokemon == null && isPokemonAnAlly(oldPokemon) && TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
			{
				throw(new Error("Check to see if we're out of pokemon."));
			} else if (newPokemon == null && !isPokemonAnAlly(oldPokemon) && TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
			{
				// A double battle where the enemy trainer can't replace the lost pokemon
				oldPokemon.deactivate();
				INTERPRETATION_HALTED = false;
				//nextMessage();
				return;
			}
			
			if (oldPokemon.USED_WATERSPORT)
			{
				deactivateTeamBattleEffect(isPokemonAnAlly(oldPokemon) ? allyPokemon[0] : enemyPokemon[0], BattleEffect.WATER_SPORT);
				deactivateTeamBattleEffect(isPokemonAnAlly(oldPokemon) ? enemyPokemon[0] : allyPokemon[0], BattleEffect.WATER_SPORT);
			}
			else if (oldPokemon.USED_MUDSPORT)
			{
				deactivateTeamBattleEffect(isPokemonAnAlly(oldPokemon) ? allyPokemon[0] : enemyPokemon[0], BattleEffect.MUD_SPORT);
				deactivateTeamBattleEffect(isPokemonAnAlly(oldPokemon) ? enemyPokemon[0] : allyPokemon[0], BattleEffect.MUD_SPORT);
			}
			
			for (i = 0; i < allyPokemon.length; i++)
			{
				if (allyPokemon[i].IMPRISONED_BY == oldPokemon)
				{
					allyPokemon[i].IMPRISONED_BY = null;
					allyPokemon[i].activateMoves();
				}
			}
			for (i = 0; i < enemyPokemon.length; i++)
			{
				if (enemyPokemon[i].IMPRISONED_BY == oldPokemon)
				{
					enemyPokemon[i].IMPRISONED_BY = null;
					enemyPokemon[i].activateMoves();
				}
			}
			
			messages.push("SWITCH://" + newPokemon.toString() + "//" + (isPokemonAnAlly(oldPokemon) || isPokemonAnAlly(newPokemon)));
			oldPokemon.deactivate();
			newPokemon.activate();
			var i:int;
			var oldIndex:int = 0;
			var newIndex:int = 0;
			for (i = 0; i < allyPokemon.length; i++)
			{
				if (allyPokemon[i] == oldPokemon)
					oldIndex = i;
				else if (allyPokemon[i] == newPokemon)
					newIndex = i;
			}
			for (i = 0; i < enemyPokemon.length; i++)
			{
				if (enemyPokemon[i] == oldPokemon)
					oldIndex = i;
				else if (enemyPokemon[i] == newPokemon)
					newIndex = i;
			}
			if (isPokemonAnAlly(newPokemon) || isPokemonAnAlly(oldPokemon))
			{
				allyPokemon[oldIndex] = newPokemon;
				allyPokemon[newIndex] = oldPokemon;
			}
			else
			{
				enemyPokemon[oldIndex] = newPokemon;
				enemyPokemon[newIndex] = oldPokemon;
			}
			INTERPRETATION_HALTED = false;
			if (interpret)
				nextMessage();
		}
		
		private function checkForEntryHazards(newPokemon:Pokemon):void
		{
			if (isTeamBattleEffectActive(newPokemon, BattleEffect.ONE_SPIKE) || isTeamBattleEffectActive(newPokemon, BattleEffect.TWO_SPIKE) || isTeamBattleEffectActive(newPokemon, BattleEffect.THREE_SPIKE))
			{
				if (newPokemon.isType(PokemonType.FLYING) || newPokemon.ABILITY == "Levitate")
				{
					messages.push("MESSAGE://" + wildFoe(newPokemon) + newPokemon.NAME + " avoided the SPIKES!");
				}
				else
				{
					var dmg:Number = 0;
					if (isTeamBattleEffectActive(newPokemon, BattleEffect.ONE_SPIKE))
						dmg = 1 / 8;
					else if (isTeamBattleEffectActive(newPokemon, BattleEffect.TWO_SPIKE))
						dmg = 1 / 6;
					else if (isTeamBattleEffectActive(newPokemon, BattleEffect.THREE_SPIKE))
						dmg = 1 / 4;
					injectBattleActionResult(BattleActionResult.generateMoveResult(PokemonMoves.getMoveIDByName("Spikes"), 20, -dmg * newPokemon.getStat(PokemonStat.HP), newPokemon, newPokemon, BattleActionResult.MOVE_SUCCESSFUL));
				}
			}
		}
		
		private function finishBattle(moveToPokemonCenter:Boolean = false):void
		{
			for (var i:int = 0; i < allyPokemon.length; i++)
			{
				allyPokemon[i].clearBattleModifiers();
				
				trace(allyPokemon[i]);
			}
			
			trace("************************* BATTLE FINISHED *******************************");
			
			Configuration.BATTLE_FIGHT_OPTION = 1;
			Configuration.BATTLE_FIGHT_OPTION2 = 1;
			UI_BATTLE.finishBattle(battleCompleteCallback, moveToPokemonCenter);
			battleCompleteCallback = null;
		}
		
		public function destroy():void
		{
			Configuration.STAGE.removeChild(UI_BATTLE);
			
			var i:int = 0;
			for (i = 0; i < allyPokemon.length; i++) allyPokemon[i].deactivate();
			for (i = 0; i < enemyPokemon.length; i++) enemyPokemon[i].deactivate();
			
			allyTrainers = null;
			UI_BATTLE = null;
			allyPokemon = null;
			enemyPokemon = null;
			actionQueue = null;
			enemyMoveEffects = null;
			enemyTrainers = null;
			turnResults = null;
			_replacementCallback = null;
			messages = null;
			trainerReplacingCallback = null;
			trainerReplacingPokemon = null;
			trainerReplacingPokemonNew = null;
			_replacing = null;
			lastUsedMoveBy = null;
			addStruggleMessage = null;
		}
		
		private function dealRecurrentDamage(pokemon:Pokemon, battleActionResult:String, moveName:String, giveEnemyHealth:Boolean = true):void
		{
			var factor:Number = 1 / 8;
			if (moveName == "Nightmare" || moveName == "Curse")
				factor = 1 / 4;
			var damage:int = factor * pokemon.getStat(PokemonStat.HP);
			var enemy:Pokemon;
			var negativedamage:int = -damage;
			if (pokemon.CURRENT_HP < 16)
				damage = 1;
			if (isPokemonAnAlly(pokemon))
				enemy = enemyPokemon[0];
			else
				enemy = allyPokemon[0];
			
			damage *= pokemon.N_DAMAGE_NUMBER;
			
			if (pokemon.ABILITY == "Liquid Ooze")
				negativedamage = -damage;
			injectBattleActionResult(BattleActionResult.generateMoveResult(PokemonMoves.getMoveIDByName(moveName), 0, damage, pokemon, pokemon, battleActionResult));
			if (giveEnemyHealth)
				injectBattleActionResult(BattleActionResult.generateMoveResult(PokemonMoves.getMoveIDByName(moveName), 0, negativedamage, enemy, enemy, battleActionResult));
			
			if (moveName == "Toxic" || moveName == "Poison Fang")
				pokemon.incrementNDamageNumber();
		}
		
		private var turnResults:Vector.<BattleActionResult>;
		private var messages:Vector.<String>;
		private var curIndex:int = 0;
		
		private function nextTurn():void
		{
			//trace("Next Pokémon's turn...");
			turnResults = executeAction();
			messages = new Vector.<String>();
			
			for (var i:int = 0; i < addStruggleMessage.length; i++)
			{
				messages.push("MESSAGE://" + addStruggleMessage[i] + " has no\nmoves left!");
			}
			addStruggleMessage.splice(0, addStruggleMessage.length);
			
			nextInterpretation();
		}
		
		private var INTERPRETATION_HALTED:Boolean = false;
		
		private function nextInterpretation():void
		{
			if (INTERPRETATION_HALTED)
				return;
			
			if (turnResults.length > 0)
			{
				//trace("Interpreting battle action result " + turnResults[0]);
				var ERROR_CODE:String = interpretBattleActionResult(turnResults[0]);
				if (ERROR_CODE != BattleStatus.NORMAL)
				{
					// something halted it, let's stop.
					INTERPRETATION_HALTED = true;
				}
				turnResults.splice(0, 1);
				// messages should now be populated
				nextMessage();
			}
			else
			{
				finishTurn();
			}
		}
		
		public function comeBackPokemon(pokemon:Pokemon):void
		{
			messages.push("MESSAGE://" + pokemon.NAME + "! That's enough!\nCome back!");
		}
		
		private var timeelapsed:int = 0;
		
		private function waitForDismissCallback():void
		{
			if (getTimer() - timeelapsed < 2000)
			{
				if (trainerReplacingCallback != null)
					setTimeout(replaceTrainerPokemon, 2000 - (getTimer() - timeelapsed));
				else
					setTimeout(nextMessage, 2000 - (getTimer() - timeelapsed));
			}
			else
			{
				if (trainerReplacingCallback != null)
					replaceTrainerPokemon();
				else
					nextMessage();
			}
		}
		
		private function nextMessage():void
		{
			if (!messages)
			{
				throw(new Error('Messages is null!'));
			}
			if (messages.length == 0)
			{
				// We're done with all the messages for now, let's move on to the next interpretation
				nextInterpretation();
				return;
			}
			else
			{
				var data:Array;
				var encodedString:String;
				var pokemon:Pokemon;
				var i:int;
				var message:String = messages[0];
				messages.splice(0, 1);
				trace(message);
				if (message.substr(0, 7) == "MESSAGE")
				{
					data = message.substr(8, int.MAX_VALUE).split("//");
					var waitForDismiss:Boolean = data.length > 2 ? Boolean(data[2]) : false;
					if (waitForDismiss)
						timeelapsed = getTimer();
					UI_BATTLE.displayMessage(data[1], waitForDismiss ? waitForDismissCallback : nextMessage, waitForDismiss);
					return;
				} else if (message.substr(0, 12) == "CATCHPOKEMON")
				{
					setTimeout(nextMessage, 1000);
					SoundManager.playMusicTrack(110, 0);
					SoundManager.delayPlayMusicTrack(153, 1, true, true, 0.5);
					UI_BATTLE.hidePokeball();
					// Add the Pokémon to the player's party
					var pokemonCaught:Pokemon = enemyPokemon[0];
					if (!Configuration.ACTIVE_TRAINER.ownedPokemon(pokemonCaught.base.name))
					{
						messages.push("MESSAGE://" + pokemonCaught.NAME + "'s data was\nadded to the POKéDEX.");
						messages.push("OPENPOKEDEXDATA//" + pokemonCaught.base.name);
					}
					messages.push("QUESTION://Give a nickname to the captured " + pokemonCaught.NAME + "?//nickname//null//Yes//No");
					if (Configuration.ACTIVE_TRAINER.getPartySize() == 6)
					{
						// Transfer the the PC.
						messages.push("MESSAGE://" + pokemonCaught.NAME + " was transferred to SOMEONE's PC");
					} else
					{
						pokemonCaught.setOTName(Configuration.ACTIVE_TRAINER.NAME);
						pokemonCaught.setMetAt(pokemonCaught.LEVEL, RegionManager.CURRENT_REGION.properties.properties.name);
						pokemonCaught.setTrainer(Configuration.ACTIVE_TRAINER);
						pokemonCaught.setPokeballType(UI_BATTLE.POKEBALL_THROWN);
						Configuration.ACTIVE_TRAINER.catchPokemon(pokemonCaught);
					}
					messages.push("BATTLEWON: Pokemon caught.");
					return;
				} else if (message.substr(0, 13) == "THROWPOKEBALL")
				{
					data = message.split("//");
					UI_BATTLE.throwPokeball(data[1]);
				} else if (message.substr(0, 13) == "SHAKEPOKEBALL")
				{
					UI_BATTLE.shakePokeball();
					setTimeout(nextMessage, 1000);
					return;
				} else if (message.substr(0, 13) == "BLOCKPOKEBALL")
				{
					data = message.split("//");
					UI_BATTLE.blockPokeball(data[1]);
				} else if (message.substr(0, 9) == "CATCHFAIL")
				{
					UI_BATTLE.failPokeball();
				} else if (message.substr(0, 15) == "OPENPOKEDEXDATA")
				{
					data = message.split("//");
					UI_BATTLE.openPokedexMenu(data[1], nextMessage);
					return;
				}
				else if (message.substr(0, 7) == "LEVELUP")
				{
					data = message.split("//");
					trace("WARNING: In online matches, possible loss in synchronicity in levelling up/stat propagation.");
					for (i = 0; i < allyPokemon.length; i++)
					{
						if (allyPokemon[i].toString() == data[1])
							pokemon = allyPokemon[i];
					}
					
					var oldHP:int = pokemon.getStat(PokemonStat.HP);
					var oldATK:int = pokemon.getStat(PokemonStat.ATK);
					var oldDEF:int = pokemon.getStat(PokemonStat.DEF);
					var oldSPATK:int = pokemon.getStat(PokemonStat.SPATK);
					var oldSPDEF:int = pokemon.getStat(PokemonStat.SPDEF);
					var oldSPEED:int = pokemon.getStat(PokemonStat.SPEED);
					pokemon.finishLevellingUp();
					UI_BATTLE.displayLevelUpStats(waitForDismissCallback, pokemon, oldHP, oldATK, oldDEF, oldSPATK, oldSPDEF, oldSPEED, pokemon.getStat(PokemonStat.HP), pokemon.getStat(PokemonStat.ATK), pokemon.getStat(PokemonStat.DEF), pokemon.getStat(PokemonStat.SPATK), pokemon.getStat(PokemonStat.SPDEF), pokemon.getStat(PokemonStat.SPEED));
					checkPokemonForNewMoves(pokemon);
					return;
				}
				else if (message.substr(0, 9) == "LEARNMOVE")
				{
					data = message.split("//");
					
					trace("TRYING TO LEARN MOVE " + data[2]);
					
					for (i = 0; i < allyPokemon.length; i++)
					{
						if (allyPokemon[i].toString() == data[1])
							pokemon = allyPokemon[i];
					}
					
					var moveName:String = data[2];
					if (pokemon.teachMove(moveName))
					{
						messages.splice(0, 0, "MESSAGE://" + pokemon.NAME + " learned " + moveName.toUpperCase() + "!");
					}
					else
					{
						messages.splice(0, 0, "MESSAGE://" + pokemon.NAME + " is trying to\nlearn " + moveName.toUpperCase() + "!");
						messages.splice(1, 0, "MESSAGE://But, " + pokemon.NAME + " can't learn\nmore than four moves.");
						messages.splice(2, 0, "QUESTION://Delete a move to make\nroom for " + moveName.toUpperCase() + "?//learnmove||" + pokemon.toString() + "//" + moveName + "//Yes//No");
					}
					nextMessage();
					return;
				}
				else if (message.substr(0, 16) == "SHOWENEMYTRAINER")
				{
					UI_BATTLE.displayEnemyTrainer();
				}
				else if (message.substr(0, 8) == "QUESTION")
				{
					data = message.split("//");
					UI_BATTLE.askQuestion(data[1], data[2], waitForDismissCallback, data[3], data[4], data[5]);
					return;
				}
				else if (message.substr(0, 18) == "BRINGINNEXTPOKEMON")
				{
					UI_BATTLE.bringInNextPokemon(waitForDismissCallback);
					return;
				}
				else if (message.substr(0, 11) == "SOUNDEFFECT")
				{
					data = message.split("//");
					SoundManager.playSoundEffect(data[1]);
					nextMessage();
					return;
				}
				else if (message.substr(0, 14) == "UPDATEUIHPBARS")
				{
					UI_BATTLE.updateHPBars(nextMessage);
					return;
				}
				else if (message.substr(0, 14) == "UPDATEUIXPBARS")
				{
					UI_BATTLE.updateXPBars(nextMessage);
					return;
				}
				else if (message.substr(0, 22) == "UPDATESTATUSCONDITIONS")
				{
					UI_BATTLE.updateStatusConditions();
					nextMessage();
					return;
				}
				else if (message.substr(0, 4) == "STAT")
				{
					data = message.split("//");
					encodedString = data[1];
					var stat:String = data[2];
					var change:int = int(data[3]);
					UI_BATTLE.displayStatChange(encodedString, stat, change);
				}
				else if (message.substr(0, 6) == "SWITCH")
				{
					data = message.split("//");
					UI_BATTLE.switchPokemon(data[1], data[2], data.length > 3 ? Boolean(data[3]) : false, waitForDismissCallback);
					return;
				}
				else if (message.substr(0, 6) == "FAINT:")
				{
					// This is the actual animation shown in UI_BATTLE, not "FAINTED"
					data = message.split("//");
					encodedString = data[1];
					UI_BATTLE.displayPokemonFaint(encodedString);
				}
				else if (message.substr(0, 7) == "FAINTED")
				{
					selectReplacementPokemon(_replacing, replacementSelected);
					return;
				}
				else if (message.substr(0, 9) == "BATTLEWON" || message.substr(0, 8) == "WHITEOUT" || message.substr(0, 7) == "ESCAPED")
				{
					finishBattle(message.substr(0, 8) == "WHITEOUT" ? true : false);
					return;
				}
				else if (message.substr(0, 6) == "DAMAGE")
				{
					nextMessage();
					return;
				}
				setTimeout(nextMessage, 2000);
			}
		}
		
		private var damageSoundEffectType:int = 0;
		
		private function isPokemonAnAlly(pokemon:Pokemon):Boolean
		{
			for (var i:uint = 0; i < allyPokemon.length; i++)
			{
				if (allyPokemon[i] == pokemon)
					return true;
			}
			return false;
		}
		
		public function learnMove(moveName:String, pokemon:Pokemon, actuallyTeach:Boolean, replaceMoveIndex:int = 0):void
		{
			if (!actuallyTeach)
			{
				messages.splice(0, 0, "MESSAGE://" + pokemon.NAME + " did not learn " + moveName.toUpperCase() + ".");
			}
			else if (actuallyTeach && replaceMoveIndex != 0)
			{
				messages.splice(0, 0, "MESSAGE://1, 2 ...... Poof!");
				messages.splice(1, 0, "MESSAGE://" + pokemon.NAME + " forgot " + pokemon.getMove(replaceMoveIndex).toUpperCase() + "!");
				messages.splice(2, 0, "MESSAGE://And...");
				messages.splice(3, 0, "MESSAGE://" + pokemon.NAME + " learned " + moveName.toUpperCase() + "!");
				pokemon.teachMove(moveName, replaceMoveIndex);
			}
			else if (actuallyTeach && replaceMoveIndex == 0)
			{
				// Ask for the move to be forgotten.
				messages.splice(0, 0, "QUESTION://Which move should be forgotten?//forgetmove//" + moveName + "//null//null");
			}
		}
		
		private function injectBattleActionResult(result:BattleActionResult):void
		{
			if (!turnResults)
				return;
			
			if (result.DAMAGE < 0 && isTeamBattleEffectMISTActive(result.USER))
			{
				switch (result.TYPE)
				{
				case BattleActionResult.STAT_ATK: 
				case BattleActionResult.STAT_ACCURACY: 
				case BattleActionResult.STAT_DEF: 
				case BattleActionResult.STAT_EVASION: 
				case BattleActionResult.STAT_SPATK: 
				case BattleActionResult.STAT_SPDEF: 
				case BattleActionResult.STAT_SPEED: 
					result.DAMAGE = 0;
					result.TYPE = BattleActionResult.MOVE_FAILURE;
					break;
				}
			}
			
			//turnResults.splice(curIndex, 0, result);
			//if (result.TYPE == BattleActionResult.STATUS_FAINT) trace("Injected faint.");
			turnResults.push(result);
		}
		
		private var lastUsedMove:int = 0;
		private var lastUsedMoveBy:Pokemon = null;
		
		private function interpretBattleActionResult(result:BattleActionResult):String
		{
			var i:uint = 0;
			var damage:int = 0;
			
			var MOVE_NAME:String = result.MOVE_ID != 0 ? PokemonMoves.getMoveNameByID(result.MOVE_ID) : "None";
			
			if (result.USER != null && result.TYPE != BattleActionResult.STAT_DEF)
				result.USER.deactivateBattleEffect(BattleEffect.SKULL_BASH);
			if (result.TYPE == BattleActionResult.ITEM_POKEBALL)
			{
				messages.push("MESSAGE://" + allyTrainers[0].NAME + " used\n" + result.ITEM_NAME.toUpperCase().replace("É", "é") + "!//false");
				// perform the calculation
				var catchStatus:int = 1;
				if (result.VICTIM.getNonVolatileStatusCondition() == PokemonStatusConditions.FREEZE || result.VICTIM.getNonVolatileStatusCondition() == PokemonStatusConditions.SLEEP) catchStatus = 2;
				else if (result.VICTIM.getNonVolatileStatusCondition() == PokemonStatusConditions.PARALYSIS || result.VICTIM.getNonVolatileStatusCondition() == PokemonStatusConditions.POISON || result.VICTIM.getNonVolatileStatusCondition() == PokemonStatusConditions.BURN) catchStatus = 1.5;
				var catchA:int = (((3 * result.VICTIM.getStat(PokemonStat.HP) - 2 * result.VICTIM.CURRENT_HP) * result.VICTIM.base.catchRate * (result.EXTRA_DATA / 10)) / (3 * result.VICTIM.getStat(PokemonStat.HP))) * catchStatus;
				var catchB:int = 1048560 / Math.sqrt(Math.sqrt(16711680 / catchA));
				
				var shakeFail:Boolean = false;
				
				if (TYPE != BattleType.WILD)
				{
					// block the ball
					messages.push("BLOCKPOKEBALL//" + result.ITEM_NAME);
					messages.push("MESSAGE://The TRAINER blocked the ball!");
					messages.push("MESSAGE://Don't be a thief!");
					return BattleStatus.NORMAL;
				} else
				{
					messages.push("THROWPOKEBALL//" + result.ITEM_NAME);
				}
				
				trace("Catching!", catchA, catchB, result.VICTIM.getStat(PokemonStat.HP), result.VICTIM.CURRENT_HP, result.VICTIM.base.catchRate, result.EXTRA_DATA);
				
				if (catchA >= 255 || result.ITEM_NAME == "Master Ball" || UI_BATTLE.WALLY)
				{
					if (UI_BATTLE.WALLY) messages.push("SHAKEPOKEBALL", "SHAKEPOKEBALL", "SHAKEPOKEBALL");
					messages.push("CATCHPOKEMON");
					messages.push("MESSAGE://Gotcha!\n" + result.VICTIM.NAME + " was caught!");
					return BattleStatus.NORMAL;
				}
				
				for (var catchI:int = 0; catchI < 4; catchI++)
				{
					var catchShake:int = Math.floor(Math.random() * 65536);
					if (catchShake >= catchB)
					{
						shakeFail = true;
						break;
					}
					else
					{
						messages.push("SHAKEPOKEBALL");
					}
				}
				
				if (shakeFail)
				{
					messages.push("CATCHFAIL");
					messages.push("MESSAGE://Aww!\nIt appeared to be caught!");
				}
				else
				{
					messages.push("CATCHPOKEMON");
					messages.push("MESSAGE://Gotcha!\n" + result.VICTIM.NAME + " was caught!");
				}
				
				return BattleStatus.NORMAL;
			} else if (result.TYPE == BattleActionResult.ITEM_HEAL)
			{
				result.USER.setCurrentHP(result.USER.CURRENT_HP + result.EXTRA_DATA);
				if (result.USER.CURRENT_HP > result.USER.getStat(PokemonStat.HP))
					result.USER.setCurrentHP(result.USER.getStat(PokemonStat.HP));
				messages.push("MESSAGE://" + result.USER.TRAINER.NAME + " used " + result.ITEM_NAME.toUpperCase() + "!//true");
				messages.push("UPDATEUIHPBARS");
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s " + result.ITEM_NAME.toUpperCase() + " restored health!//false");
				return BattleStatus.NORMAL;
			}
			else if (result.TYPE == BattleActionResult.WEATHER_STOPPED)
			{
				WEATHER_DURATION = 0;
				WEATHER = BattleWeatherEffect.CLEAR_SKIES;
				messages.push("MESSAGE://The skies have cleared.//false");
				return BattleStatus.NORMAL;
			}
			else if (result.TYPE == BattleActionResult.DESCRIBE_WEATHER)
			{
				switch (WEATHER)
				{
				case BattleWeatherEffect.HAIL: 
					messages.push("MESSAGE://It is hailing.");
					break;
				case BattleWeatherEffect.INTENSE_SUNLIGHT: 
					messages.push("MESSAGE://The sun is strong.");
					break;
				case BattleWeatherEffect.RAIN: 
					messages.push("MESSAGE://It is raining.");
					break;
				case BattleWeatherEffect.SANDSTORM: 
					messages.push("MESSAGE://A sandstorm rages.");
					break;
				}
			}
			else if (result.TYPE == BattleActionResult.REFLECT_DESTROYED)
			{
				messages.push("MESSAGE://The barrier REFLECT was destroyed!");
			}
			else if (result.TYPE == BattleActionResult.LIGHT_SCREEN_DESTROYED)
			{
				messages.push("MESSAGE://The barrier LIGHT SCREEN was destroyed!");
			}
			if (result.TYPE == BattleActionResult.MOVE_SNATCHED)
			{
				result.VICTIM.SNATCHED = result.USER;
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " snatched " + wildFoe(result.VICTIM) + result.VICTIM.NAME + "'s move!//false");
			}
			if (result.USER && result.USER.SNATCHED != null && result.TYPE != BattleActionResult.MOVE_SUCCESSFUL)
			{
				//trace("Snatch used.");
				if (result.VICTIM == result.USER.SNATCHED)
					result.VICTIM = result.USER;
				result.USER = result.USER.SNATCHED;
				result.USER.SNATCHED = null;
			}
			if (lastUsedMoveBy && lastUsedMoveBy.SNATCHED != null && lastUsedMoveBy.SNATCHED == result.USER)
			{
				result.USER = lastUsedMoveBy;
				lastUsedMoveBy.SNATCHED = null;
			}
			if (result.VICTIM != null && result.VICTIM.isBattleEffectActive(BattleEffect.MAGIC_COAT) && result.TYPE != BattleActionResult.MOVE_SUCCESSFUL)
			{
				if (PokemonMoves.getMoveMagicCoatByID(result.MOVE_ID) && result.DAMAGE >= 0)
				{
					// The move is affected by magic coat and is targetting the holder of Magic Coat
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + "'s MAGIC COAT reflected the attack back at " + wildFoe(lastUsedMoveBy) + lastUsedMoveBy.NAME + "!");
					result.VICTIM = result.USER;
				}
			}
			if (result.USER.isBattleEffectActive(BattleEffect.MAGIC_COAT) && actionQueue.length != 0 && actionQueue[0].OWNER != result.USER && lastUsedMove != 0 && PokemonMoves.getMoveMagicCoatByID(lastUsedMove))
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s MAGIC COAT reflected the attack back at " + wildFoe(lastUsedMoveBy) + lastUsedMoveBy.NAME + "!");
				
				result.USER = lastUsedMoveBy;
			}
			if (result.VICTIM != null && result.VICTIM.isBattleEffectActive(BattleEffect.PROTECT) && result.TYPE != BattleActionResult.MOVE_SUCCESSFUL)
			{
				if (PokemonMoves.getMoveProtectByID(result.MOVE_ID) && result.DAMAGE >= 0)
				{
					var chanceOfSuccess:int = Math.floor((1 / result.VICTIM.USED_MOVE_LENGTH) * 100);
					if (result.CUTE_CHARM >= 100 - chanceOfSuccess)
					{
						// The move is affected by magic coat and is targetting the holder of Magic Coat
						messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " protected itself!");
						return BattleStatus.NORMAL;
					}
					else
					{
						result.VICTIM.changeUsedMoveLength(0);
						messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + "'s PROTECT failed!");
					}
				}
			}
			if (result.VICTIM != null && result.VICTIM.isBattleEffectActive(BattleEffect.DETECT) && result.TYPE != BattleActionResult.MOVE_SUCCESSFUL)
			{
				if (PokemonMoves.getMoveProtectByID(result.MOVE_ID) && result.DAMAGE >= 0)
				{
					var chanceOfSuccess2:int = Math.floor((1 / result.VICTIM.USED_MOVE_LENGTH) * 100);
					if (result.CUTE_CHARM >= 100 - chanceOfSuccess2)
					{
						// The move is affected by magic coat and is targetting the holder of Magic Coat
						messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " DETECTED " + wildFoe(result.USER) + result.USER.NAME + "'s move!");
						return BattleStatus.NORMAL;
					}
					else
					{
						result.VICTIM.changeUsedMoveLength(0);
						messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + "'s DETECTED failed!");
					}
				}
			}
			if (result.USER.isBattleEffectActive(BattleEffect.PROTECT) && actionQueue.length != 0 && actionQueue[0].OWNER != result.USER && lastUsedMove != 0 && PokemonMoves.getMoveProtectByID(lastUsedMove))
			{
				var chanceOfSuccess3:int = Math.floor((1 / result.USER.USED_MOVE_LENGTH) * 100);
				if (result.CUTE_CHARM >= 100 - chanceOfSuccess3)
				{
					// The move is affected by magic coat and is targetting the holder of Magic Coat
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " protected itself!");
					return BattleStatus.NORMAL;
				}
				else
				{
					result.USER.changeUsedMoveLength(0);
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s PROTECT failed!");
				}
				
			}
			if (result.USER.isBattleEffectActive(BattleEffect.DETECT) && actionQueue.length != 0 && actionQueue[0].OWNER != result.USER && lastUsedMove != 0 && PokemonMoves.getMoveProtectByID(lastUsedMove))
			{
				var chanceOfSuccess1:int = Math.floor((1 / result.USER.USED_MOVE_LENGTH) * 100);
				if (result.CUTE_CHARM >= 100 - chanceOfSuccess1)
				{
					// The move is affected by magic coat and is targetting the holder of Magic Coat
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s DETECT protected itself!");
					return BattleStatus.NORMAL;
				}
				else
				{
					result.USER.changeUsedMoveLength(0);
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s DETECT failed!");
				}
				
			}
			
			if (result.TYPE == BattleActionResult.SWITCHED_OUT)
			{
				comeBackPokemon(result.USER);
			}
			else if (result.TYPE == BattleActionResult.SWITCH)
			{
				// result.USER is the oldPokemon, result.VICTIM is the new pokemon
				//cancelUsersResults(result.USER);
				/*for (i = 0; i < actionQueue.length; i++)
				   {
				   if (actionQueue[i].OWNER == result.USER)
				   {
				   trace("Switching, spliced out actionQueue result");
				   actionQueue.splice(i, 1);
				   }
				   }*/
				replacementSelected(result.USER, result.VICTIM, false);
				return BattleStatus.NORMAL;
			}
			
			if (result.DAMAGE > 0 && result.VICTIM)
			{
				// Recurrent damage moves.
				if (result.USER.isBattleEffectActive(BattleEffect.BIDE))
				{
					result.USER.deactivateBattleEffect(BattleEffect.BIDE);
					result.USER.BIDE_COUNT = 0;
				}
				if (MOVE_NAME == "Spikes")
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " was hurt by SPIKES!");
				}
				if (result.TYPE == BattleActionResult.WEATHER_HAILING)
				{
					messages.push("MESSAGE://It is hailing.");
					if (result.VICTIM.isType(PokemonType.ICE))
						result.DAMAGE = 0;
				}
				if (result.TYPE == BattleActionResult.WEATHER_SANDSTORM)
				{
					messages.push("MESSAGE://A sandstorm rages.");
					if (result.VICTIM.isType(PokemonType.STEEL) || result.VICTIM.isType(PokemonType.ROCK) || result.VICTIM.isType(PokemonType.GROUND))
						result.DAMAGE = 0;
				}
				if (result.TYPE == BattleActionResult.MOVE_PERISH_SONG)
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " fainted due to PERISH SONG!");
				}
				if (MOVE_NAME == "Leech Seed")
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + "'s health was drained by LEECH SEED!");
				}
				else if (MOVE_NAME == "Nightmare")
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " is trapped in a NIGHTMARE!");
				}
				else if (MOVE_NAME == "Curse")
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " is cursed!");
				}
				else if (MOVE_NAME == "Toxic")
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " is badly poisoned!");
				}
				else if (result.TYPE == BattleActionResult.STATUS_POISON)
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " is hurt by poison!");
				}
				else if (result.TYPE == BattleActionResult.STATUS_BURN)
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " is hurt by its burn!//true");
				}
				else if (result.TYPE == BattleActionResult.MOVE_HURT_ITSELF_IN_CONFUSION)
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " hurt itself in its confusion!");
				}
				else if (MOVE_NAME == "Giga Drain")
				{
					injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, 0, -1 * 0.5 * result.DAMAGE, result.USER, result.USER, BattleActionResult.MOVE_NORMAL_USE));
				}
				else if (MOVE_NAME == "Acid")
				{
					if (result.CUTE_CHARM >= 90)
					{
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_DEF, -1, result.CUTE_CHARM));
					}
				}
				else if (MOVE_NAME == "Shadow Ball")
				{
					if (result.CUTE_CHARM >= 80)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_SPDEF, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Mist Ball")
				{
					if (result.CUTE_CHARM >= 50)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_SPATK, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Luster Purge")
				{
					if (result.CUTE_CHARM >= 50)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_SPDEF, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Icy Wind")
				{
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_SPEED, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Steel Wing")
				{
					if (result.CUTE_CHARM >= 90)
					{
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_DEF, 1, result.CUTE_CHARM));
					}
				}
				else if (MOVE_NAME == "Tri Attack")
				{
					if (result.CUTE_CHARM >= 80)
					{
						if (result.CUTE_CHARM > 94)
						{
							injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_PARALYSIS, 0, result.CUTE_CHARM));
						}
						else if (result.CUTE_CHARM > 87)
						{
							if (result.VICTIM.isType(PokemonType.FIRE) == false)
								injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_BURN, 0, result.CUTE_CHARM));
						}
						else
						{
							if (result.VICTIM.isType(PokemonType.ICE) == false)
								injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_FREEZE, 0, result.CUTE_CHARM));
						}
					}
				}
				else if (MOVE_NAME == "Secret Power")
				{
					if (result.CUTE_CHARM >= 70)
					{
						switch (LOCATION)
						{
						case BattleSpecialTile.BUILDING: 
						case BattleSpecialTile.PLAIN: 
							injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_PARALYSIS, 0, result.CUTE_CHARM));
							
							break;
						case BattleSpecialTile.SAND: 
							if (isTeamBattleEffectMISTActive(result.VICTIM) == false)
								injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_ACCURACY, -1, result.CUTE_CHARM));
							else
								injectBattleActionResult(BattleActionResult.generateFailureResult(result.MOVE_ID, result.USER, BattleActionResult.MOVE_FAILURE));
							break;
						case BattleSpecialTile.CAVE: 
							injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_FLINCH, 0, result.CUTE_CHARM));
							break;
						case BattleSpecialTile.ROCK: 
							injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, 0, result.VICTIM, result.VICTIM, BattleActionResult.STATUS_CONFUSION)); // induce confusion
							break;
						case BattleSpecialTile.TALL_GRASS: 
							injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_POISON, 0, result.CUTE_CHARM));
							break;
						case BattleSpecialTile.LONG_GRASS: 
							injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, 0, result.VICTIM, result.VICTIM, BattleActionResult.STATUS_SLEEP)); // induce sleep
							break;
						case BattleSpecialTile.POND_WATER: 
							if (isTeamBattleEffectMISTActive(result.VICTIM) == false)
								injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_SPEED, -1, result.CUTE_CHARM));
							else
								injectBattleActionResult(BattleActionResult.generateFailureResult(result.MOVE_ID, result.USER, BattleActionResult.MOVE_FAILURE));
							break;
						case BattleSpecialTile.SEA_WATER: 
							if (isTeamBattleEffectMISTActive(result.VICTIM) == false)
								injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_ATK, -1, result.CUTE_CHARM));
							else
								injectBattleActionResult(BattleActionResult.generateFailureResult(result.MOVE_ID, result.USER, BattleActionResult.MOVE_FAILURE));
							break;
						case BattleSpecialTile.SEAWEED: 
							if (isTeamBattleEffectMISTActive(result.VICTIM) == false)
								injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_DEF, -1, result.CUTE_CHARM));
							else
								injectBattleActionResult(BattleActionResult.generateFailureResult(result.MOVE_ID, result.USER, BattleActionResult.MOVE_FAILURE));
							break;
						}
					}
				}
				else if (MOVE_NAME == "Ember" || MOVE_NAME == "Flamethrower" || MOVE_NAME == "Blaze Kick" || MOVE_NAME == "Heat Wave" || MOVE_NAME == "Fire Blast")
				{
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_BURN, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Psycho Boost")
				{
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_SPATK, -2, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Ice Beam" || MOVE_NAME == "Blizzard" || MOVE_NAME == "Powder Snow")
				{
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_FREEZE, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Psybeam" || MOVE_NAME == "Confusion" || MOVE_NAME == "Signal Beam")
				{
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, 0, result.VICTIM, result.VICTIM, BattleActionResult.STATUS_CONFUSION)); // induce sleep
					
				}
				else if (MOVE_NAME == "Spit Up")
				{
					result.USER.deactivateBattleEffect(BattleEffect.ONE_STOCKPILE);
					result.USER.deactivateBattleEffect(BattleEffect.TWO_STOCKPILE);
					result.USER.deactivateBattleEffect(BattleEffect.THREE_STOCKPILE);
				}
				else if (MOVE_NAME == "Dizzy Punch" || MOVE_NAME == "Water Pulse")
				{
					if (result.CUTE_CHARM >= 80)
						injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, 0, result.VICTIM, result.VICTIM, BattleActionResult.STATUS_CONFUSION)); // induce sleep
					
				}
				else if (MOVE_NAME == "Overheat")
				{
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_SPATK, -2, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Hydro Cannon" || MOVE_NAME == "Blast Burn")
				{
					result.USER.activateBattleEffect(BattleEffect.RECHARGING);
				}
				else if (MOVE_NAME == "Mud Shot")
				{
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_SPEED, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Bubble")
				{
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_SPEED, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Frenzy Plant")
				{
					result.VICTIM.activateBattleEffect(BattleEffect.RECHARGING);
						//injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.POKEMON_RECHARGING));
				}
				else if (MOVE_NAME == "Silver Wind" || MOVE_NAME == "AncientPower")
				{
					if (result.CUTE_CHARM >= 90)
					{
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_ATK, 1, result.CUTE_CHARM));
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_DEF, 1, result.CUTE_CHARM));
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_SPATK, 1, result.CUTE_CHARM));
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_SPDEF, 1, result.CUTE_CHARM));
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_SPEED, 1, result.CUTE_CHARM));
					}
				}
				else if (MOVE_NAME == "Bubble Beam" || MOVE_NAME == "Rock Tomb" || MOVE_NAME == "Constrict")
				{
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_SPEED, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Aurora Beam")
				{
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_ATK, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Needle Arm" || MOVE_NAME == "Rock Slide" || MOVE_NAME == "Snore")
				{
					if (result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_FLINCH, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Waterfall" || MOVE_NAME == "Twister")
				{
					if (result.CUTE_CHARM >= 80)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_FLINCH, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Hyper Fang" || MOVE_NAME == "Bone Club" || MOVE_NAME == "Extrasensory")
				{
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_FLINCH, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Fake Out")
				{
					if (result.VICTIM.ABILITY != "Inner Focus" && result.VICTIM.ABILITY != "Shield Dust")
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_FLINCH, 0, result.CUTE_CHARM));
				}
				if (MOVE_NAME == "Meteor Mash")
				{
					if (result.CUTE_CHARM >= 80)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_ATK, 1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Metal Claw")
				{
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_ATK, 1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Muddy Water")
				{
					if (result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_ACCURACY, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Poison Tail")
				{
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_POISON, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Smog")
				{
					if (result.CUTE_CHARM >= 60)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_POISON, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Sludge" || MOVE_NAME == "Sludge Bomb")
				{
					if (result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_POISON, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Poison Fang")
				{
					if (result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_TOXIC, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Psychic")
				{
					if (result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_SPDEF, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Crunch")
				{
					if (result.CUTE_CHARM >= 80)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_SPDEF, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Crush Claw" || MOVE_NAME == "Rock Smash")
				{
					if (result.CUTE_CHARM >= 50)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_DEF, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Iron Tail")
				{
					if (result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_DEF, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Sacred Fire")
				{
					if (result.VICTIM.getNonVolatileStatusCondition() == PokemonStatusConditions.FREEZE)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_CURE_FREEZE, 0, result.CUTE_CHARM));
					if (result.CUTE_CHARM >= 50)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_BURN, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Flame Wheel")
				{
					if (result.VICTIM.getNonVolatileStatusCondition() == PokemonStatusConditions.FREEZE)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_CURE_FREEZE, 0, result.CUTE_CHARM));
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_BURN, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Dynamic Punch")
				{
					if (result.CUTE_CHARM >= 0)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_CONFUSION, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Volt Tackle" || MOVE_NAME == "ThunderShock" || MOVE_NAME == "Thunderbolt")
				{
					if (result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_PARALYSIS, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Zap Cannon")
				{
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_PARALYSIS, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Octazooka")
				{
					if (result.CUTE_CHARM >= 50)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_ACCURACY, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Mud-Slap")
				{
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STAT_ACCURACY, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Thunder" || MOVE_NAME == "Bounce" || MOVE_NAME == "Spark" || MOVE_NAME == "Lick" || MOVE_NAME == "Dragon Breath")
				{
					if (result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_PARALYSIS, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Hyper Beam")
				{
					result.USER.activateBattleEffect(BattleEffect.RECHARGING);
				}
				else if ((MOVE_NAME == "Absorb" || MOVE_NAME == "Leech Life") && result.TYPE != BattleActionResult.POKEMON_ABSORB_HEALTH)
				{
					damage = result.CUTE_CHARM / 200 * result.DAMAGE * -1;
					if (damage == 0)
						damage = -1;
					if (result.VICTIM.ABILITY == "Liquid Ooze")
						damage = -damage;
					injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, 0, damage, result.USER, result.USER, BattleActionResult.POKEMON_ABSORB_HEALTH));
				}
				else if (MOVE_NAME == "Mega Drain" && result.TYPE != BattleActionResult.POKEMON_ABSORB_HEALTH)
				{
					damage = 0.5 * result.DAMAGE * -1;
					if (damage == 0)
						damage = -1;
					if (result.VICTIM.ABILITY == "Liquid Ooze")
						damage = -damage;
					injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, damage, result.USER, result.USER, BattleActionResult.POKEMON_ABSORB_HEALTH));
				}
				if (MOVE_NAME == "Volt Tackle")
				{
					injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, result.DAMAGE * 0.33, result.USER, result.USER, BattleActionResult.MOVE_RECOIL));
				}
				else if (MOVE_NAME == "Covet" || MOVE_NAME == "Thief")
				{
					if (result.VICTIM.ABILITY != "Sticky Hold" && result.VICTIM.HELDITEM != "" && result.USER.HELDITEM == "")
						injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, 0, result.USER, result.VICTIM, BattleActionResult.MOVE_STOLE_ITEM));
				}
				else if (MOVE_NAME == "Knock Off")
				{
					if (result.VICTIM.HELDITEM != "")
					{
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.POKEMON_HELD_ITEM_LOST, 0, result.CUTE_CHARM));
					}
				}
				else if (MOVE_NAME == "Superpower")
				{
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_ATK, -1, result.CUTE_CHARM));
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_DEF, -1, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "SmellingSalt")
				{
					if (result.VICTIM.getNonVolatileStatusCondition() == PokemonStatusConditions.PARALYSIS)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_CURE_PARALYSIS, 0, result.CUTE_CHARM));
				}
				else if (MOVE_NAME == "Fury Cutter")
				{
					result.USER.incrementNDamageNumber();
				}
				else if (MOVE_NAME == "False Swipe")
				{
					if (result.VICTIM.CURRENT_HP - result.DAMAGE <= 0)
					{
						result.DAMAGE = result.VICTIM.CURRENT_HP - 1;
					}
				}
				else if (result.TYPE == BattleActionResult.MOVE_RECOIL)
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " hurt itself in recoil!");
				}
				else if (MOVE_NAME == "Clamp")
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " CLAMPED " + wildFoe(result.VICTIM) + result.VICTIM.NAME + "!");
				}
				else if (MOVE_NAME == "Beat Up")
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s Attack!");
				}
				
				if (result.VICTIM.isBattleEffectActive(BattleEffect.ENDURE))
				{
					var chanceOfSuccessRate:int = (1 / result.VICTIM.USED_MOVE_LENGTH) * 100;
					if (result.CUTE_CHARM >= chanceOfSuccessRate)
					{
						if (result.VICTIM.CURRENT_HP - result.DAMAGE <= 0)
						{
							result.DAMAGE = result.VICTIM.CURRENT_HP - 1;
							messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " ENDURED " + wildFoe(result.USER) + result.USER.NAME + "'s attack!");
						}
					}
				}
				
				if (result.VICTIM.isBattleEffectActive(BattleEffect.FOCUS_ENERGY))
				{
					// Lose focus!
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.POKEMON_LOST_FOCUS, 0, result.CUTE_CHARM));
				}
				if (result.USER.isBattleEffectActive(BattleEffect.FOCUS_ENERGY))
				{
					result.USER.deactivateBattleEffect(BattleEffect.FOCUS_ENERGY);
				}
				result.VICTIM.activateBattleEffect(BattleEffect.TOOK_DAMAGE_SAME_TURN);
				
				result.VICTIM.setCurrentHP(result.VICTIM.CURRENT_HP - result.DAMAGE); // Move did damage!
				if (result.VICTIM.CURRENT_HP < 0)
					result.VICTIM.setCurrentHP(0); // Normalize the victim's health
				
				lastDamageDone = result.DAMAGE;
				lastDamageDoneByType = PokemonMoves.getMoveTypeByID(result.MOVE_ID);
				result.VICTIM.changeLastHitBy(result.USER);
				result.VICTIM.changeLastHitByMove(result.MOVE_ID);
				result.VICTIM.changeLastTakenDamage(result.DAMAGE);
				messages.push("DAMAGE: " + result.USER.NAME + "'s move did " + result.DAMAGE + " damage against " + result.VICTIM.NAME + ". Their health is now " + result.VICTIM.CURRENT_HP + "/" + result.VICTIM.getStat(PokemonStat.HP));
				messages.push("SOUNDEFFECT://" + (result.TYPE == BattleActionResult.MOVE_NOT_VERY_EFFECTIVE ? SoundEffect.MOVE_INEFFECTIVE_DAMAGE : (result.TYPE == BattleActionResult.MOVE_SUPER_EFFECTIVE ? SoundEffect.MOVE_SUPEREFFECTIVE_DAMAGE : SoundEffect.MOVE_NORMAL_DAMAGE)));
				messages.push("UPDATEUIHPBARS");
				
				if (result.CRITICAL_HIT)
					messages.push("MESSAGE://" + "A critical hit!");
				
				var effective:String = "";
				if (result.TYPE == BattleActionResult.MOVE_NOT_VERY_EFFECTIVE)
				{
					messages.push("MESSAGE://" + "It's not very effective...");
				}
				else if (result.TYPE == BattleActionResult.MOVE_SUPER_EFFECTIVE)
				{
					messages.push("MESSAGE://" + "It's super effective!");
				}
				
				if (result.VICTIM.isBattleEffectActive(BattleEffect.BIDE))
					result.VICTIM.BIDE_COUNT += result.DAMAGE;
				if (result.VICTIM.CURRENT_HP <= 0)
				{
					// Pokemon fainted!
					//cancelUsersResults(result.VICTIM);
					//cancelVictimsResults(result.USER, result.VICTIM);
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_FAINT));
				}
				
				if (MOVE_NAME == "Rage" || MOVE_NAME == "Ice Ball" || MOVE_NAME == "Rollout")
					result.USER.changeRageCounter(result.USER.RAGE_COUNTER + 1);
				
				// Wrap
				if (MOVE_NAME == "Wrap" && result.USER.areBattleEffectsActive(BattleEffect.REPEAT_ATTACK5, BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK3, BattleEffect.REPEAT_ATTACK2) && result.USER.USED_MOVE_LENGTH == 1)
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " was WRAPPED by " + wildFoe(result.USER) + result.USER.NAME + "!");
				}
				else if (MOVE_NAME == "Wrap" && result.USER.areBattleEffectsActive(BattleEffect.REPEAT_ATTACK5, BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK3, BattleEffect.REPEAT_ATTACK2))
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " is hurt by WRAP!");
				}
				else if (MOVE_NAME == "Wrap")
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " was freed from WRAP!");
				}
				else if (MOVE_NAME == "Bind")
				{
					messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " was squeezed by " + wildFoe(result.USER) + result.USER.NAME + "'s BIND!");
				}
				else if (MOVE_NAME == "Thrash" || MOVE_NAME == "Petal Dance")
				{
					if (result.USER.areBattleEffectsActive(BattleEffect.REPEAT_ATTACK1, BattleEffect.REPEAT_ATTACK2, BattleEffect.REPEAT_ATTACK3) == false)
					{
						// make the user become confused
						injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, 0, result.VICTIM, result.VICTIM, BattleActionResult.STATUS_CONFUSION)); // induce sleep
						
					}
				}
				else if (MOVE_NAME == "Explosion" || MOVE_NAME == "Selfdestruct")
				{
					// make the user faint.
					injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, result.USER.CURRENT_HP, result.USER, result.USER, BattleActionResult.MOVE_NORMAL_USE));
					// cancel the target's queued actions
					for (i = 0; i < actionQueue.length; i++)
					{
						if (actionQueue[i].OWNER == result.VICTIM)
							actionQueue.splice(i, 1);
					}
				}
				else if (MOVE_NAME == "Poison Sting" && result.CUTE_CHARM >= 70)
				{
					injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_POISON, 0, result.CUTE_CHARM));
				}
				else if ((MOVE_NAME == "Fire Spin" || MOVE_NAME == "Sand Tomb" || MOVE_NAME == "Whirlpool") && result.USER.areBattleEffectsActive(BattleEffect.REPEAT_ATTACK1, BattleEffect.REPEAT_ATTACK2, BattleEffect.REPEAT_ATTACK3, BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK5) == false)
				{
					result.VICTIM.giveVolatileStatusCondition(PokemonStatusConditions.PARTIALLYTRAPPED);
					if (MOVE_NAME == "Fire Spin" || MOVE_NAME == "Whirlpool")
					{
						messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " was trapped in the vortex!");
					}
					else if (MOVE_NAME == "Sand Tomb")
						messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " was trapped by SAND TOMB!");
					
					if (result.CUTE_CHARM >= 63)
						result.USER.activateBattleEffect(BattleEffect.REPEAT_ATTACK2);
					else if (result.CUTE_CHARM >= 26)
						result.USER.activateBattleEffect(BattleEffect.REPEAT_ATTACK3);
					else if (result.CUTE_CHARM >= 14)
						result.USER.activateBattleEffect(BattleEffect.REPEAT_ATTACK4);
					else
						result.USER.activateBattleEffect(BattleEffect.REPEAT_ATTACK5);
					
				}
				else if ((MOVE_NAME == "Ice Ball" || MOVE_NAME == "Rollout") && result.USER.areBattleEffectsActive(BattleEffect.REPEAT_ATTACK1, BattleEffect.REPEAT_ATTACK2, BattleEffect.REPEAT_ATTACK3, BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK5) == false)
				{
					result.USER.activateBattleEffect(BattleEffect.REPEAT_ATTACK5);
				}
				
				if (PokemonMoves.getMoveContactByID(result.MOVE_ID))
				{
					// This move made contact!
					if (result.VICTIM.ABILITY == "Cute Charm" && result.VICTIM.GENDER != result.USER.GENDER && result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STATUS_INFATUATION, 0, result.CUTE_CHARM));
					if (result.VICTIM.ABILITY == "Effect Spore")
					{
						if (result.CUTE_CHARM >= 70)
						{
							if (result.CUTE_CHARM >= 90)
								injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STATUS_PARALYSIS, 0, result.CUTE_CHARM)); // induce paralysis
							else if (result.CUTE_CHARM >= 79)
								injectBattleActionResult(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, 0, result.VICTIM, result.VICTIM, BattleActionResult.STATUS_SLEEP)); // induce sleep
							else
								injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STATUS_POISON));
						}
					}
					if (result.VICTIM.ABILITY == "Flame Body" && result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STATUS_BURN, 0, result.CUTE_CHARM));
					if (result.VICTIM.ABILITY == "Poison Point" && result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STATUS_POISON, 0, result.CUTE_CHARM));
					if (result.VICTIM.ABILITY == "Rough Skin")
					{
						turnResults.push(BattleActionResult.generateMoveResult(999, result.CUTE_CHARM, result.USER.LAST_HIT_BY.getStat(PokemonStat.HP) * (1 / 16), result.VICTIM, result.USER, BattleActionResult.ABILITY_DID_DAMAGE));
					}
					if (MOVE_NAME == "Dream Eater" && result.VICTIM.getNonVolatileStatusCondition() == PokemonStatusConditions.SLEEP)
						turnResults.push(BattleActionResult.generateMoveResult(result.MOVE_ID, result.CUTE_CHARM, (result.CUTE_CHARM / 200 * result.DAMAGE * -1), result.USER, result.USER, BattleActionResult.POKEMON_ABSORB_HEALTH));
					if (result.VICTIM.ABILITY == "Static" && result.CUTE_CHARM >= 70)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STATUS_PARALYSIS, 0, result.CUTE_CHARM));
					if (MOVE_NAME == "Fire Punch" && result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_BURN, 0, result.CUTE_CHARM));
					if (MOVE_NAME == "Ice Punch" && result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_FREEZE, 0, result.CUTE_CHARM));
					if (MOVE_NAME == "ThunderPunch" && result.CUTE_CHARM >= 90)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_PARALYSIS, 0, result.CUTE_CHARM));
					if ((MOVE_NAME == "Clamp" || MOVE_NAME == "Bind" || MOVE_NAME == "Wrap") && result.USER.USED_MOVE_LENGTH == 1)
						injectBattleActionResult(BattleActionResult.generateStatusResult(result.VICTIM, BattleActionResult.STATUS_PARTIAL_TRAP, 0, result.CUTE_CHARM));
				}
			}
			else if (result.DAMAGE < 0 && result.VICTIM)
			{
				result.VICTIM.setCurrentHP(result.VICTIM.CURRENT_HP - result.DAMAGE);
				if (result.VICTIM.CURRENT_HP > result.VICTIM.getStat(PokemonStat.HP))
					result.VICTIM.setCurrentHP(result.VICTIM.getStat(PokemonStat.HP));
				if (MOVE_NAME == "Ingrain")
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " gained health from INGRAIN!");
				}
				if (MOVE_NAME == "Wish")
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s WISH regained health!");
				}
				if (MOVE_NAME == "Leech Seed")
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " gained health from LEECH SEED!");
				}
				if (MOVE_NAME == "Absorb" || MOVE_NAME == "Leech Life")
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " absorbed health!");
				}
				if (MOVE_NAME == "Present")
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " was healed by PRESENT!");
				}
				if (MOVE_NAME == "Recover" || MOVE_NAME == "Rest" || MOVE_NAME == "Slack Off" || MOVE_NAME == "Swallow" || MOVE_NAME == "Moonlight" || MOVE_NAME == "Synthesis" || MOVE_NAME == "Morning Sun")
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " recovered health!");
					if (MOVE_NAME == "Swallow")
					{
						result.USER.deactivateBattleEffect(BattleEffect.ONE_STOCKPILE);
						result.USER.deactivateBattleEffect(BattleEffect.TWO_STOCKPILE);
						result.USER.deactivateBattleEffect(BattleEffect.THREE_STOCKPILE);
					}
				}
				
				messages.push("DAMAGE: " + result.VICTIM.NAME + " gained " + (-result.DAMAGE) + " HP. Their health is now " + result.VICTIM.CURRENT_HP + "/" + result.VICTIM.getStat(PokemonStat.HP));
				messages.push("UPDATEUIHPBARS");
			}
			
			/// END OF DAMAGE ******************
			if (result.TYPE == BattleActionResult.WEATHER_BEGAN_TO_HAIL)
			{
				WEATHER = BattleWeatherEffect.HAIL;
				WEATHER_DURATION = 5;
				messages.push("MESSAGE://It began to hail.");
			}
			if (result.TYPE == BattleActionResult.WEATHER_BEGAN_TO_SHINE)
			{
				WEATHER = BattleWeatherEffect.INTENSE_SUNLIGHT;
				WEATHER_DURATION = 5;
				messages.push("MESSAGE://The sun grew strong.");
			}
			if (result.TYPE == BattleActionResult.WEATHER_BEGAN_TO_RAIN)
			{
				WEATHER = BattleWeatherEffect.RAIN;
				WEATHER_DURATION = 5;
				messages.push("MESSAGE://It began to rain.");
			}
			if (result.TYPE == BattleActionResult.POKEMON_TURNED_AWAY)
			{
				messages.push("MESSAGE://" + result.USER.NAME + " turned away!");
			}
			if (result.TYPE == BattleActionResult.POKEMON_BEGAN_TO_NAP)
			{
				messages.push("MESSAGE://" + result.USER.NAME + " began to nap!");
			}
			if (result.TYPE == BattleActionResult.POKEMON_WONT_OBEY)
			{
				messages.push("MESSAGE://" + result.USER.NAME + " won't obey!");
			}
			if (result.TYPE == BattleActionResult.POKEMON_IGNORED_ORDERS)
			{
				messages.push("MESSAGE://" + result.USER.NAME + " ignored orders!");
			}
			if (result.TYPE == BattleActionResult.POKEMON_IGNORED_ORDERS_WHILE_ASLEEP)
			{
				messages.push("MESSAGE://" + result.USER.NAME + " ignored orders while asleep!");
			}
			if (result.TYPE == BattleActionResult.WEATHER_BEGAN_SANDSTORM)
			{
				WEATHER = BattleWeatherEffect.SANDSTORM;
				WEATHER_DURATION = 5;
				messages.push("MESSAGE://A sandstorm began.");
			}
			if (result.TYPE == BattleActionResult.MOVE_PERISH_SONG_INIT && result.DAMAGE == 0)
			{
				messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " will PERISH in 3 turns!");
			}
			else if (result.TYPE == BattleActionResult.MOVE_PERISH_SONG && result.DAMAGE == 0)
			{
				var turns:int = result.VICTIM.isBattleEffectActive(BattleEffect.PERISH_SONG3) ? 2 : (result.VICTIM.isBattleEffectActive(BattleEffect.PERISH_SONG2) ? 1 : 0);
				messages.push("MESSAGE://" + wildFoe(result.VICTIM) + result.VICTIM.NAME + " will PERISH in " + turns + " turn" + (turns != 1 ? "s" : "") + "!");
			}
			else if (result.TYPE == BattleActionResult.STATUS_TYPE_CHANGED)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s type changed to " + result.USER.OVERRIDE_TYPE.toUpperCase() + "!");
			}
			else if (result.TYPE == BattleActionResult.MOVE_NOTHING_HAPPENED)
			{
				messages.push("MESSAGE://But nothing happened!");
			}
			else if (result.TYPE == BattleActionResult.POKEMON_MADE_A_WISH)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " made a wish!");
				result.USER.activateBattleEffect(BattleEffect.WISH2);
			}
			else if (result.TYPE == BattleActionResult.POKEMON_TRANSFORMED)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " transformed into " + wildFoe(result.VICTIM) + result.VICTIM.NAME + "!");
				result.USER.transformInto(result.VICTIM);
			}
			else if (MOVE_NAME == "Bide" && result.DAMAGE == 0)
			{
				result.USER.changeLastUsedMove(result.MOVE_ID);
				if (result.USER.areBattleEffectsActive(BattleEffect.CANNOT_ATTACK1, BattleEffect.REPEAT_ATTACK2, BattleEffect.REPEAT_ATTACK3) || result.USER.isBattleEffectActive(BattleEffect.BIDE) == false)
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " is biding its time!");
				
				if (result.USER.isBattleEffectActive(BattleEffect.BIDE) == false && result.USER.areBattleEffectsActive(BattleEffect.CANNOT_ATTACK1, BattleEffect.CANNOT_ATTACK2, BattleEffect.CANNOT_ATTACK3) == false)
				{
					if (result.CUTE_CHARM >= 50)
					{
						result.USER.activateBattleEffect(BattleEffect.CANNOT_ATTACK2);
						result.USER.activateBattleEffect(BattleEffect.REPEAT_ATTACK3);
					}
					else
					{
						result.USER.activateBattleEffect(BattleEffect.CANNOT_ATTACK3);
						result.USER.activateBattleEffect(BattleEffect.REPEAT_ATTACK4);
					}
					result.USER.activateBattleEffect(BattleEffect.BIDE);
				}
				
			}
			else if (result.TYPE == BattleActionResult.STATUS_WATERSPORT)
			{
				messages.push("MESSAGE://The power of FIRE-type moves fell!");
				result.USER.USED_WATERSPORT = true;
				activateTeamBattleEffect(allyPokemon[0], BattleEffect.WATER_SPORT);
				activateTeamBattleEffect(enemyPokemon[0], BattleEffect.WATER_SPORT);
			}
			else if (result.TYPE == BattleActionResult.STATUS_MUDSPORT)
			{
				messages.push("MESSAGE://The power of ELECTRIC-type moves fell!");
				result.USER.USED_MUDSPORT = true;
				activateTeamBattleEffect(allyPokemon[0], BattleEffect.MUD_SPORT);
				activateTeamBattleEffect(enemyPokemon[0], BattleEffect.MUD_SPORT);
			}
			else if (result.TYPE == BattleActionResult.POKEMON_BLOWN_AWAY)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " was blown away!");
			}
			else if (result.TYPE == BattleActionResult.POKEMON_FLED)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " fled the battle!");
			}
			else if (result.TYPE == BattleActionResult.CANT_ESCAPE)
			{
				messages.push("MESSAGE://Can't escape!");
			}
			else if (result.TYPE == BattleActionResult.CANT_RUN_FROM_TRAINER_BATTLE)
			{
				messages.push("MESSAGE://" + result.USER.TRAINER.NAME + " can't run from a TRAINER BATTLE!");
			}
			else if (result.TYPE == BattleActionResult.GOT_AWAY_SAFELY)
			{
				messages.push("MESSAGE://Got away safely!");
			}
			else if (result.TYPE == BattleActionResult.FINISH_BATTLE)
			{
				finishBattle();
				INTERPRETATION_HALTED = true;
				return BattleStatus.FINISHED;
			}
			else if (result.TYPE == BattleActionResult.POKEMON_DRAGGED_OUT)
			{
				var isAlly:Boolean = isPokemonAnAlly(result.USER);
				//messages.push("SWITCH://" + result.USER.toString() + "//" + isAlly +"//true");
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " was dragged out!");
			}
			else if (result.TYPE == BattleActionResult.POKEMON_HELD_ITEM_LOST)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s held item was knocked off!");
				result.USER.loseItem();
			}
			else if (result.TYPE == BattleActionResult.MOVE_STOLE_ITEM)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " stole " + wildFoe(result.VICTIM) + result.VICTIM.NAME + "'s held item!");
				result.USER.setBattleStolenItem(result.VICTIM.HELDITEM);
				result.VICTIM.loseItem();
			}
			else if (result.TYPE == BattleActionResult.MOVE_TRADE_ITEM)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " traded held items with " + wildFoe(result.VICTIM) + result.VICTIM.NAME + "!");
				var item:String = result.USER.HELDITEM;
				result.USER.setBattleStolenItem(result.VICTIM.HELDITEM);
				result.VICTIM.setBattleStolenItem(item);
			}
			else if (result.TYPE == BattleActionResult.POKEMON_CONFUSED)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " is confused!");
			}
			if (result.TYPE == BattleActionResult.POKEMON_RECHARGING)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " is recharging!");
			}
			else if (result.TYPE == BattleActionResult.MOVE_WHIRLWIND)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " whipped up a whirlwind!");
				result.USER.activateBattleEffect(BattleEffect.WHIRLWIND);
				result.USER.activateBattleEffect(BattleEffect.REPEAT_ATTACK2);
			}
			else if (result.TYPE == BattleActionResult.POKEMON_SLEEPING)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " is fast asleep!");
				result.USER.setSleepingNumber(result.USER.SLEEPING_NUMBER - 1);
			}
			else if (result.TYPE == BattleActionResult.STATUS_CURE_SLEEP && result.USER.getNonVolatileStatusCondition() == PokemonStatusConditions.SLEEP)
			{
				result.USER.setNonVolatileStatusCondition(null);
				messages.push("UPDATESTATUSCONDITIONS");
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " woke up!");
			}
			else if (result.TYPE == BattleActionResult.STATUS_LEECH_SEED)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " was seeded!");
				result.USER.activateBattleEffect(BattleEffect.LEECH_SEED);
			}
			else if (result.TYPE == BattleActionResult.STATUS_TOXIC)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " was badly poisoned!");
				result.USER.activateBattleEffect(BattleEffect.TOXIC);
			}
			else if (result.TYPE == BattleActionResult.POKEMON_FOCUS_ENERGY)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " is focusing energy!");
				result.USER.activateBattleEffect(BattleEffect.FOCUS_ENERGY);
			}
			else if (result.TYPE == BattleActionResult.POKEMON_LOST_FOCUS)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " lost focus!");
				result.USER.deactivateBattleEffect(BattleEffect.FOCUS_ENERGY);
				for (i = 0; i < actionQueue.length; i++)
				{
					if (actionQueue[i].OWNER == result.USER)
					{
						actionQueue.splice(i, 1);
					}
				}
			}
			else if (result.TYPE == BattleActionResult.MOVE_NO_EFFECT)
			{
				messages.push("MESSAGE://It doesn't affect " + wildFoe(result.VICTIM).toLowerCase() + result.VICTIM.NAME + ".");
			}
			else if (result.TYPE == BattleActionResult.MOVE_FLEW_UP_HIGH)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " flew up high!");
				result.USER.changeLastUsedMove(result.MOVE_ID);
				result.USER.activateBattleEffect(BattleEffect.FLY);
			}
			else if (result.TYPE == BattleActionResult.MOVE_LOWERED_HEAD)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " lowered its head!");
				result.USER.changeLastUsedMove(result.MOVE_ID);
				result.USER.activateBattleEffect(BattleEffect.SKULL_BASH);
				injectBattleActionResult(BattleActionResult.generateStatusResult(result.USER, BattleActionResult.STAT_DEF, 1, result.CUTE_CHARM));
			}
			else if (result.TYPE == BattleActionResult.MOVE_CLOAKED_IN_HARSH_LIGHT)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " became cloaked in a harsh light!");
				result.USER.changeLastUsedMove(result.MOVE_ID);
				result.USER.activateBattleEffect(BattleEffect.SKY_ATTACK);
			}
			else if (result.TYPE == BattleActionResult.MOVE_DOVE_DOWN_DEEP)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " dove down deep!");
				result.USER.changeLastUsedMove(result.MOVE_ID);
				result.USER.activateBattleEffect(BattleEffect.DIVE);
			}
			else if (result.TYPE == BattleActionResult.MOVE_BOUNCED)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " bounced up high!");
				result.USER.changeLastUsedMove(result.MOVE_ID);
				result.USER.activateBattleEffect(BattleEffect.BOUNCE);
			}
			else if (result.TYPE == BattleActionResult.MOVE_TAKING_IN_SUNLIGHT)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " is taking in sunlight!");
				result.USER.changeLastUsedMove(result.MOVE_ID);
				result.USER.activateBattleEffect(BattleEffect.SOLARBEAM);
			}
			else if (result.TYPE == BattleActionResult.MOVE_DUG_DOWN_DEEP)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " dug down deep!");
				result.USER.changeLastUsedMove(result.MOVE_ID);
				result.USER.activateBattleEffect(BattleEffect.DIG);
			}
			else if (result.TYPE == BattleActionResult.MOVE_FAILURE)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s move failed.");
			}
			else if (result.TYPE == BattleActionResult.MOVE_MISSED)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s move missed.");
				result.USER.changeRageCounter(0);
			}
			else if (result.TYPE == BattleActionResult.STATUS_FAINT)
			{
				if (result.USER.ABILITY == "Aftermath" && PokemonMoves.getMoveContactByID(result.USER.LAST_HIT_BY_MOVE) == true && doesAPokemonHaveAbility("Damp") == false)
				{
					// Do damage to the last Pokemon to hit the user, the move made contact
					injectBattleActionResult(BattleActionResult.generateMoveResult(999, result.CUTE_CHARM, result.USER.LAST_HIT_BY.getStat(PokemonStat.HP) * 0.25, result.USER, result.USER.LAST_HIT_BY, BattleActionResult.ABILITY_DID_DAMAGE));
				}
				result.USER.changeRageCounter(0);
				result.USER.setNonVolatileStatusCondition(PokemonStatusConditions.FAINT);
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " fainted!");
				messages.push("FAINT://" + result.USER.toString());
				
				if (result.USER.isBattleEffectActive(BattleEffect.GRUDGE))
				{
					if (result.USER.LAST_HIT_BY != result.USER)
					{
						messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s had a GRUDGE against " + wildFoe(result.USER.LAST_HIT_BY) + result.USER.LAST_HIT_BY.NAME + "!");
						result.USER.LAST_HIT_BY.removeAllPPFromLastMove();
					}
				}
				if (result.USER.isBattleEffectActive(BattleEffect.DESTINY_BOND))
				{
					if (result.USER.LAST_HIT_BY != result.USER)
					{
						messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s DESTINY was BONDED with " + wildFoe(result.USER.LAST_HIT_BY) + result.USER.LAST_HIT_BY.NAME + "!");
						injectBattleActionResult(BattleActionResult.generateMoveResult(999, result.CUTE_CHARM, result.USER.LAST_HIT_BY.CURRENT_HP, result.USER.LAST_HIT_BY, result.USER.LAST_HIT_BY, BattleActionResult.MOVE_NORMAL_USE));
					}
				}
				
				var shiftAwaiting:Boolean = false;
				
				for (i = 0; i < actionQueue.length; i++)
				{
					if (actionQueue[i].TYPE == BattleAction.SWITCH && actionQueue[i].OWNER.TRAINER == result.USER.TRAINER)
					{
						shiftAwaiting = true;
					}
					if (actionQueue[i].OWNER == result.USER)
					{
						actionQueue.splice(i, 1);
					}
				}
				if (!shiftAwaiting)
					messages.push("FAINTED: " + wildFoe(result.USER) + result.USER.NAME + " has fainted.");
				for (i = 0; i < turnResults.length; i++)
				{
					if (turnResults[i].VICTIM == result.USER)
					{
						turnResults.splice(i, 1);
					}
				}
				_replacing = result.USER;
				return BattleStatus.POKEMON_FAINTED;
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_BURN && result.USER.getNonVolatileStatusCondition() != PokemonStatusConditions.BURN)
			{
				if (areTeamBattleEffectsActive(result.USER, BattleEffect.SAFEGUARD1, BattleEffect.SAFEGUARD2, BattleEffect.SAFEGUARD3, BattleEffect.SAFEGUARD4, BattleEffect.SAFEGUARD5)) messages.push("MESSAGE://SAFEGUARD protected " + wildFoe(result.USER) + result.USER.NAME + " from becoming burned!");
				else if (result.USER.getNonVolatileStatusCondition() != PokemonStatusConditions.BURN)
				{
					result.USER.setNonVolatileStatusCondition(PokemonStatusConditions.BURN);
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " became burned.");
					messages.push("UPDATESTATUSCONDITIONS");
				}
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_CONFUSION && result.USER.isStatusConditionActive(PokemonStatusConditions.CONFUSION) == false)
			{
				if (areTeamBattleEffectsActive(result.USER, BattleEffect.SAFEGUARD1, BattleEffect.SAFEGUARD2, BattleEffect.SAFEGUARD3, BattleEffect.SAFEGUARD4, BattleEffect.SAFEGUARD5)) messages.push("MESSAGE://SAFEGUARD protected " + wildFoe(result.USER) + result.USER.NAME + " from becoming confused!");
				else
				{
					result.USER.giveVolatileStatusCondition(PokemonStatusConditions.CONFUSION);
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " became confused.");
					messages.push("UPDATESTATUSCONDITIONS");
					if (result.CUTE_CHARM >= 75)
						result.USER.setSleepingNumber(4);
					else if (result.CUTE_CHARM >= 50)
						result.USER.setSleepingNumber(3);
					else if (result.CUTE_CHARM >= 25)
						result.USER.setSleepingNumber(2);
					else
						result.USER.setSleepingNumber(1);
				}
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_FLINCH)
			{
				var canFlinch:Boolean = false;
				// remove this user's move from the battle action
				for (i = 0; i < actionQueue.length; i++)
				{
					if (actionQueue[i].OWNER == result.USER)
					{
						actionQueue.splice(i, 1);
						canFlinch = true;
					}
				}
				if (canFlinch)
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " flinched.");
					result.USER.changeRageCounter(0);
				}
				cancelUsersResults(result.USER);
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_FREEZE)
			{
				if (areTeamBattleEffectsActive(result.USER, BattleEffect.SAFEGUARD1, BattleEffect.SAFEGUARD2, BattleEffect.SAFEGUARD3, BattleEffect.SAFEGUARD4, BattleEffect.SAFEGUARD5)) messages.push("MESSAGE://SAFEGUARD protected " + wildFoe(result.USER) + result.USER.NAME + " from becoming frozen!");
				else if (result.USER.getNonVolatileStatusCondition() != PokemonStatusConditions.FREEZE)
				{
					result.USER.setNonVolatileStatusCondition(PokemonStatusConditions.FREEZE);
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " became frozen.");
					messages.push("UPDATESTATUSCONDITIONS");
				}
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_PARTIAL_TRAP)
			{
				result.USER.giveVolatileStatusCondition(PokemonStatusConditions.PARTIALLYTRAPPED);
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " became partially trapped.");
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_INFATUATION)
			{
				result.USER.giveVolatileStatusCondition(PokemonStatusConditions.INFATUATION);
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " became infatuated.");
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_PARALYSIS)
			{
				if (areTeamBattleEffectsActive(result.USER, BattleEffect.SAFEGUARD1, BattleEffect.SAFEGUARD2, BattleEffect.SAFEGUARD3, BattleEffect.SAFEGUARD4, BattleEffect.SAFEGUARD5)) messages.push("MESSAGE://SAFEGUARD protected " + wildFoe(result.USER) + result.USER.NAME + " from becoming paralyzed!");
				else if (result.USER.getNonVolatileStatusCondition() != PokemonStatusConditions.PARALYSIS)
				{
					result.USER.setNonVolatileStatusCondition(PokemonStatusConditions.PARALYSIS);
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " became paralyzed.");
					messages.push("UPDATESTATUSCONDITIONS");
				}
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_CURE_PARALYSIS)
			{
				result.USER.setNonVolatileStatusCondition(null);
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s paralysis was cured!");
				messages.push("UPDATESTATUSCONDITIONS");
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_CURE_FREEZE)
			{
				result.USER.setNonVolatileStatusCondition(null);
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " thawed!");
				messages.push("UPDATESTATUSCONDITIONS");
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_CURE_POISON)
			{
				result.USER.setNonVolatileStatusCondition(null);
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s poison was cured!");
				messages.push("UPDATESTATUSCONDITIONS");
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_CURE_BURN)
			{
				result.USER.setNonVolatileStatusCondition(null);
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s burn was cured!");
				messages.push("UPDATESTATUSCONDITIONS");
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_POISON && result.USER.getNonVolatileStatusCondition() != PokemonStatusConditions.POISON)
			{
				if (areTeamBattleEffectsActive(result.USER, BattleEffect.SAFEGUARD1, BattleEffect.SAFEGUARD2, BattleEffect.SAFEGUARD3, BattleEffect.SAFEGUARD4, BattleEffect.SAFEGUARD5)) messages.push("MESSAGE://SAFEGUARD protected " + wildFoe(result.USER) + result.USER.NAME + " from becoming poisoned!");
				else if (result.USER.getNonVolatileStatusCondition() != PokemonStatusConditions.POISON)
				{
					result.USER.setNonVolatileStatusCondition(PokemonStatusConditions.POISON);
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " became poisoned.");
					messages.push("UPDATESTATUSCONDITIONS");
				}
			}
			else if (result.USER.CURRENT_HP != 0 && result.TYPE == BattleActionResult.STATUS_SLEEP)
			{
				if (areTeamBattleEffectsActive(result.USER, BattleEffect.SAFEGUARD1, BattleEffect.SAFEGUARD2, BattleEffect.SAFEGUARD3, BattleEffect.SAFEGUARD4, BattleEffect.SAFEGUARD5)) messages.push("MESSAGE://SAFEGUARD protected " + wildFoe(result.USER) + result.USER.NAME + " from falling asleep!");
				else if (result.USER.getNonVolatileStatusCondition() != PokemonStatusConditions.SLEEP)
				{
					result.USER.setNonVolatileStatusCondition(PokemonStatusConditions.SLEEP);
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " fell asleep.");
					messages.push("UPDATESTATUSCONDITIONS");
					result.USER.changeRageCounter(0);
					if (result.CUTE_CHARM >= 84)
						result.USER.setSleepingNumber(6);
					else if (result.CUTE_CHARM >= 68)
						result.USER.setSleepingNumber(5);
					else if (result.CUTE_CHARM >= 52)
						result.USER.setSleepingNumber(4);
					else if (result.CUTE_CHARM >= 36)
						result.USER.setSleepingNumber(3);
					else if (result.CUTE_CHARM >= 20)
						result.USER.setSleepingNumber(2);
					else
						result.USER.setSleepingNumber(1);
				}
				// find other instances of this user in the list
				cancelUsersResults(result.USER);
			}
			else if (result.TYPE == BattleActionResult.STATUS_MOVE)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " used a Status move.");
			}
			if (result.TYPE == BattleActionResult.MOVE_SUCCESSFUL)
			{
				result.USER.changeLastUsedMove(result.MOVE_ID);
				lastUsedMove = result.MOVE_ID;
				lastUsedMoveBy = result.USER;
				
				if (result.USER.LAST_MOVE_USED == result.MOVE_ID && result.USER.USED_MOVE_LENGTH > 1 && result.USER.areBattleEffectsActive(BattleEffect.REPEAT_ATTACK1, BattleEffect.REPEAT_ATTACK2, BattleEffect.REPEAT_ATTACK3, BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK5))
				{
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s attack continues!");
				}
				result.USER.deactivateBattleEffect(BattleEffect.SOLARBEAM);
				result.USER.deactivateBattleEffect(BattleEffect.FLY);
				result.USER.deactivateBattleEffect(BattleEffect.DIG);
				result.USER.deactivateBattleEffect(BattleEffect.BOUNCE);
				result.USER.deactivateBattleEffect(BattleEffect.DIVE);
				result.USER.deactivateBattleEffect(BattleEffect.SKY_ATTACK);
				
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " used " + PokemonMoves.getMoveNameByID(result.MOVE_ID).toUpperCase() + "!//true");
			}
			else if (result.TYPE == BattleActionResult.ABILITY_DID_DAMAGE)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s Ability " + result.USER.ABILITY.toUpperCase() + " did damage!");
			}
			else if (result.TYPE == BattleActionResult.POKEMON_LOAFING_AROUND)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " is loafing around!");
			}
			else if (result.TYPE == BattleActionResult.POKEMON_CANNOT_ATTACK)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " cannot attack!");
			}
			else if (result.TYPE == BattleActionResult.POKEMON_PARALYZED)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " is paralyzed, it cannot move!");
			}
			else if (result.TYPE == BattleActionResult.POKEMON_INFATUATED)
			{
				messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + " is infatuated, it cannot attack!");
			}
			else if (result.TYPE == BattleActionResult.DISABLE_MOVE1 || result.TYPE == BattleActionResult.DISABLE_MOVE2 || result.TYPE == BattleActionResult.DISABLE_MOVE3 || result.TYPE == BattleActionResult.DISABLE_MOVE4)
			{
				var duration:int = 0;
				if (result.CUTE_CHARM >= 75)
					duration = 4;
				else if (result.CUTE_CHARM >= 50)
					duration = 5;
				else if (result.CUTE_CHARM >= 25)
					duration = 6;
				else
					duration = 7;
				switch (result.TYPE)
				{
				case BattleActionResult.DISABLE_MOVE1: 
					result.USER.disableMove(1, duration);
					break;
				case BattleActionResult.DISABLE_MOVE2: 
					result.USER.disableMove(2, duration);
					break;
				case BattleActionResult.DISABLE_MOVE3: 
					result.USER.disableMove(3, duration);
					break;
				case BattleActionResult.DISABLE_MOVE4: 
					result.USER.disableMove(4, duration);
					break;
				}
			}
			else if (result.TYPE == BattleActionResult.STAT_STAGES_RESET)
			{
				messages.push("MESSAGE://All stat stages were reset!");
			}
			else if (result.TYPE == BattleActionResult.STAT_EVASION || result.TYPE == BattleActionResult.STAT_ACCURACY || result.TYPE == BattleActionResult.STAT_ATK || result.TYPE == BattleActionResult.STAT_DEF || result.TYPE == BattleActionResult.STAT_SPATK || result.TYPE == BattleActionResult.STAT_SPDEF || result.TYPE == BattleActionResult.STAT_SPEED)
			{
				var statName:String = "";
				switch (result.TYPE)
				{
				case BattleActionResult.STAT_ATK: 
					if (result.DAMAGE == 12)
						result.USER.changeStatStage(PokemonStat.ATK, 12);
					else if (!result.USER.changeStatStage(PokemonStat.ATK, result.DAMAGE))
						result.DAMAGE = (result.DAMAGE > 0 ? 10 : -10);
					statName = "Attack";
					break;
				case BattleActionResult.STAT_DEF: 
					if (!result.USER.changeStatStage(PokemonStat.DEF, result.DAMAGE))
						result.DAMAGE = (result.DAMAGE > 0 ? 10 : -10);
					statName = "Defense";
					break;
				case BattleActionResult.STAT_SPATK: 
					if (!result.USER.changeStatStage(PokemonStat.SPATK, result.DAMAGE))
						result.DAMAGE = (result.DAMAGE > 0 ? 10 : -10);
					statName = "Sp. Atk.";
					break;
				case BattleActionResult.STAT_SPDEF: 
					if (!result.USER.changeStatStage(PokemonStat.SPDEF, result.DAMAGE))
						result.DAMAGE = (result.DAMAGE > 0 ? 10 : -10);
					statName = "Sp. Def.";
					break;
				case BattleActionResult.STAT_SPEED: 
					if (!result.USER.changeStatStage(PokemonStat.SPEED, result.DAMAGE))
						result.DAMAGE = (result.DAMAGE > 0 ? 10 : -10);
					statName = "Speed";
					break;
				case BattleActionResult.STAT_EVASION: 
					if (!result.USER.changeStatStage(PokemonStat.EVASION, result.DAMAGE))
						result.DAMAGE = (result.DAMAGE > 0 ? 10 : -10);
					statName = "Evasion";
					break;
				case BattleActionResult.STAT_ACCURACY: 
					if (!result.USER.changeStatStage(PokemonStat.ACCURACY, result.DAMAGE))
						result.DAMAGE = (result.DAMAGE > 0 ? 10 : -10);
					statName = "Accuracy";
					break;
				}
				switch (result.DAMAGE)
				{
				case 12: 
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s " + statName.toUpperCase() + " maxed out!");
					break;
				case 2: 
					messages.push("STAT://" + result.USER.toString() + "//" + statName + "//" + "2");
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s " + statName.toUpperCase() + " sharply rose!");
					break;
				case 1: 
					messages.push("STAT://" + result.USER.toString() + "//" + statName + "//" + "1");
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s " + statName.toUpperCase() + " rose!");
					break;
				case -1: 
					messages.push("STAT://" + result.USER.toString() + "//" + statName + "//" + "-1");
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s " + statName.toUpperCase() + " fell!");
					break;
				case -3: 
				case -4: 
				case -5: 
				case -6: 
				case -2: 
					messages.push("STAT://" + result.USER.toString() + "//" + statName + "//" + "-2");
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s " + statName.toUpperCase() + " harshly fell!");
					break;
				case -10: 
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s " + statName.toUpperCase() + " won't go lower!");
					break;
				case 10: 
					messages.push("MESSAGE://" + wildFoe(result.USER) + result.USER.NAME + "'s " + statName.toUpperCase() + " won't go higher!");
					break;
					
				}
			}
			
			return BattleStatus.NORMAL;
		}
		
		private function wildFoe(pokemon:Pokemon):String
		{
			if (pokemon.isWild)
				return "Wild ";
			else if (isPokemonAnAlly(pokemon) == false)
				return "Foe ";
			else
				return "";
		}
		
		public function isTeamBattleEffectActive(pokemon:Pokemon, battleEffect:String):Boolean
		{
			// find out if the pokemon is on the ally or enemy side
			var i:uint = 0;
			if (pokemon == null || isPokemonAnAlly(pokemon))
			{
				for (i = 0; i < allyMoveEffects.length; i++)
				{
					if (allyMoveEffects[i] == battleEffect)
						return true;
				}
			}
			if (pokemon == null || isPokemonAnAlly(pokemon) == false)
			{
				for (i = 0; i < enemyMoveEffects.length; i++)
				{
					if (enemyMoveEffects[i] == battleEffect)
						return true;
				}
			}
			return false;
		}
		
		private function removeTeamBattleEffect(effect:String):void
		{
			var i:uint = 0;
			for (i = 0; i < allyMoveEffects.length; i++)
			{
				if (allyMoveEffects[i] == effect)
				{
					allyMoveEffects.splice(i, 1);
				}
			}
			for (i = 0; i < enemyMoveEffects.length; i++)
			{
				if (enemyMoveEffects[i] == effect)
				{
					enemyMoveEffects.splice(i, 1);
				}
			}
		}
		
		private function replaceTeamBattleEffect(oldEffect:String, newEffect:String):void
		{
			var i:uint = 0;
			for (i = 0; i < allyMoveEffects.length; i++)
			{
				if (allyMoveEffects[i] == oldEffect)
				{
					allyMoveEffects[i] = newEffect;
				}
			}
			for (i = 0; i < enemyMoveEffects.length; i++)
			{
				if (enemyMoveEffects[i] == oldEffect)
				{
					enemyMoveEffects[i] = newEffect;
				}
			}
		}
		
		private function activateTeamBattleEffect(pokemon:Pokemon, battleEffect:String):void
		{
			if (isPokemonAnAlly(pokemon) && isTeamBattleEffectActive(pokemon, battleEffect) == false)
				allyMoveEffects.push(battleEffect);
			else if (isTeamBattleEffectActive(pokemon, battleEffect) == false)
				enemyMoveEffects.push(battleEffect);
		}
		
		private function deactivateTeamBattleEffect(pokemon:Pokemon, battleEffect:String):void
		{
			var i:int;
			if (isPokemonAnAlly(pokemon))
			{
				for (i = 0; i < allyMoveEffects.length; i++)
				{
					if (allyMoveEffects[i] == battleEffect)
						allyMoveEffects.splice(i, 1);
				}
			}
			else
			{
				for (i = 0; i < enemyMoveEffects.length; i++)
				{
					if (enemyMoveEffects[i] == battleEffect)
						enemyMoveEffects.splice(i, 1);
				}
			}
		}
		
		private function cancelUsersResults(pokemon:Pokemon):void
		{
			for (var i:uint = 0; i < turnResults.length; i++)
			{
				if (turnResults[i].USER == pokemon && turnResults[i].TYPE != BattleActionResult.STATUS_FAINT)
				{
					turnResults.splice(i, 1);
					i--;
				}
			}
		}
		
		private function cancelVictimsResults(user:Pokemon, victim:Pokemon):void
		{
			for (var i:uint = 0; i < turnResults.length; i++)
			{
				if (turnResults[i].USER == user && turnResults[i].VICTIM == victim && turnResults[i].DAMAGE != 0)
				{
					//	trace("Removing result of " + turnResults[i].USER.NAME + ", " + turnResults[i].TYPE);
					turnResults.splice(i, 1);
					i--;
				}
			}
		}
		
		private function interpretItem(action:BattleAction):Vector.<BattleActionResult>
		{
			var itemName:String = action.ITEM_NAME;
			var itemEffects:String = PokemonItems.getItemEffectByName(itemName);
			var effectsData:Array = itemEffects.split(";");
			var results:Vector.<BattleActionResult> = new Vector.<BattleActionResult>();
			for (var i:int = 0; i < effectsData.length; i++)
			{
				var effectData:Array = String(effectsData[i]).split(" ");
				if (effectData[0] == "USE")
				{
					switch (effectData[1])
					{
					case "POKEBALL": 
						var pokeballMultiplier:int = int(Number(String(effectData[2]).replace("x", "")) * 10);
						results.push(BattleActionResult.generateItemResult(action.ITEM_NAME, BattleActionResult.ITEM_POKEBALL, pokeballMultiplier, action.ACCURACY, action.OWNER, action.TARGET));
						break;
					case "CURE":
						if (effectData[2] == "POISON" && action.OWNER.getNonVolatileStatusCondition() == PokemonStatusConditions.POISON)
						{
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_CURE_POISON, 0, action.ACCURACY));
						} else
						if (effectData[2] == "PARALYSIS" && action.OWNER.getNonVolatileStatusCondition() == PokemonStatusConditions.PARALYSIS)
						{
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_CURE_PARALYSIS, 0, action.ACCURACY));
						} else
						if (effectData[2] == "SLEEP" && action.OWNER.getNonVolatileStatusCondition() == PokemonStatusConditions.SLEEP)
						{
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_CURE_SLEEP, 0, action.ACCURACY));
						} else
						if (effectData[2] == "BURN" && action.OWNER.getNonVolatileStatusCondition() == PokemonStatusConditions.BURN)
						{
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_CURE_BURN, 0, action.ACCURACY));
						} else
						if (effectData[2] == "CONFUSION" && action.OWNER.isStatusConditionActive(PokemonStatusConditions.CONFUSION))
						{
							action.OWNER.removeVolatileStatusCondition(PokemonStatusConditions.CONFUSION);
						} else
						if (effectData[2] == "FREEZE" && action.OWNER.getNonVolatileStatusCondition() == PokemonStatusConditions.FREEZE)
						{
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_CURE_FREEZE, 0, action.ACCURACY));
						}
						break;
					case "HEAL":
						if (effectData[2] == "ALL")
						{
							results.push(BattleActionResult.generateItemResult(action.ITEM_NAME, BattleActionResult.ITEM_HEAL, action.OWNER.getStat(PokemonStat.HP), action.ACCURACY, action.OWNER, null));
						}
						break;
					}
				}
			}
			
			return results;
		}
		
		/*
		 * Executes the next BattleAction in the actionQueue vector.
		 *
		 */
		private function executeAction(_action:BattleAction = null):Vector.<BattleActionResult>
		{
			var results:Vector.<BattleActionResult> = new Vector.<BattleActionResult>();
			var tempResults:Vector.<BattleActionResult>;
			
			if (actionQueue.length == 0)
				return results;
			
			if (_action != null)
				actionQueue.splice(0, 0, _action);
			
			var action:BattleAction = actionQueue[0];
			
			// ensure this action belongs to a currently active pokemon
			while (action.OWNER.ACTIVE == false)
			{
				actionQueue.splice(0, 1);
				if (actionQueue.length == 0)
					return results;
				action = actionQueue[0];
			}
			
			if (action.TYPE == BattleAction.ITEM)
			{
				results = interpretItem(action);
				return results;
			}
			else if (action.TYPE == BattleAction.SWITCH)
			{
				results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.SWITCHED_OUT, 0, 0));
				results.push(BattleActionResult.generateMoveResult(0, 0, 0, action.OWNER, action.TARGET, BattleActionResult.SWITCH));
				return results;
			}
			else if (action.TYPE == BattleAction.RUN)
			{
				if (TYPE == BattleType.WILD)
				{
					// Perform the calculation
					action.OWNER.ESCAPE_ATTEMPTS++;
					var opposingPokemon:Pokemon = isPokemonAnAlly(action.OWNER) ? enemyPokemon[0] : allyPokemon[0];
					var F:int = ((action.OWNER.getStat(PokemonStat.SPEED) * 128) / opposingPokemon.getStat(PokemonStat.SPEED) + 30 * action.OWNER.ESCAPE_ATTEMPTS) % 256;
					if (action.ACCURACY < F)
					{
						// Player escapes
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.GOT_AWAY_SAFELY, 0, 0));
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.FINISH_BATTLE, 0, 0));
					}
					else
					{
						results.push(BattleActionResult.generateFailureResult(0, action.OWNER, BattleActionResult.CANT_ESCAPE));
					}
				}
				else
				{
					results.push(BattleActionResult.generateFailureResult(0, action.OWNER, BattleActionResult.CANT_RUN_FROM_TRAINER_BATTLE));
					return results;
				}
			}
			else if (action.TYPE == BattleAction.MOVE)
			{
				var HITS:Boolean = false;
				var FAILED:Boolean = false;
				var TARGET:Pokemon = action.TARGET;
				
				if (TARGET == null)
				{
					if (isPokemonAnAlly(action.OWNER))
					{
						for (i = 0; i < enemyPokemon.length; i++)
						{
							if (enemyPokemon[i].ACTIVE)
							{
								TARGET = enemyPokemon[i];
								break;
							}
						}
					}
					else
					{
						for (i = 0; i < allyPokemon.length; i++)
						{
							if (allyPokemon[i].ACTIVE)
							{
								TARGET = allyPokemon[i];
								break;
							}
						}
					}
				}
				
				var MOVE_NAME:String = PokemonMoves.getMoveNameByID(action.MOVEID);
				var i:int = 0;
				var j:int = 0;
				
				// Reduce disable duration
				action.OWNER.reduceDisableCounter();
				if (action.OWNER.areBattleEffectsActive(BattleEffect.REPEAT_ATTACK1, BattleEffect.REPEAT_ATTACK2, BattleEffect.REPEAT_ATTACK3, BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK5) == false)
					action.OWNER.reducePP(action.MOVEID);
				
				// Sleep check
				if (action.OWNER.getNonVolatileStatusCondition() == PokemonStatusConditions.SLEEP && action.OWNER.SLEEPING_NUMBER > 0)
				{
					results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_SLEEPING));
					return results;
				}
				else if (action.OWNER.getNonVolatileStatusCondition() == PokemonStatusConditions.SLEEP)
				{
					results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_CURE_SLEEP, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
				}
				
				// Frozen check
				
				// Recharging move
				if (action.OWNER.isBattleEffectActive(BattleEffect.RECHARGING))
				{
					results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_RECHARGING));
					action.OWNER.deactivateBattleEffect(BattleEffect.RECHARGING);
					return results;
				}
				
				// Torment
				
				// Truancy
				var TRUANT:Boolean = false;
				if (action.OWNER.ABILITY == "Truant" && action.OWNER.isBattleEffectActive(BattleEffect.TRUANT))
				{
					TRUANT = true;
					action.OWNER.deactivateBattleEffect(BattleEffect.TRUANT);
				}
				
				if (TRUANT)
				{
					results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_LOAFING_AROUND));
					return results;
				}
				
				// Flinch
				
				// Disable check
				var DISABLED:Boolean = false;
				if (action.OWNER.areBattleEffectsActive(BattleEffect.CANNOT_ATTACK1, BattleEffect.CANNOT_ATTACK2, BattleEffect.CANNOT_ATTACK3, BattleEffect.CANNOT_ATTACK4, BattleEffect.CANNOT_ATTACK5))
				{
					DISABLED = true;
				}
				
				if (DISABLED && MOVE_NAME != "Bide")
				{
					results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_CANNOT_ATTACK));
					return results;
				}
				
				// Taunt check
				
				// Imprison check
				
				// Confusion check
				if (action.OWNER.isStatusConditionActive(PokemonStatusConditions.CONFUSION) && action.OWNER.SLEEPING_NUMBER > 0)
				{
					action.OWNER.setSleepingNumber(action.OWNER.SLEEPING_NUMBER - 1);
					results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_CONFUSED));
					if (action.CRITICAL_HIT >= 50)
					{
						
						tempResults = PokemonStat.calculateDamage(action.OWNER, action.OWNER, 999, action, this);
						action.setOVERRIDEMOVEID(999);
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, tempResults[0].DAMAGE, action.OWNER, action.OWNER, BattleActionResult.MOVE_HURT_ITSELF_IN_CONFUSION));
						return results;
					}
				}
				else if (action.OWNER.isStatusConditionActive(PokemonStatusConditions.CONFUSION))
				{
					action.OWNER.removeVolatileStatusCondition(PokemonStatusConditions.CONFUSION);
				}
				
				// Paralysis check
				if (action.OWNER.getNonVolatileStatusCondition() == PokemonStatusConditions.PARALYSIS)
				{
					if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 75)
					{
						results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_PARALYZED));
						return results;
					}
				}
				
				// Attract check
				if (action.OWNER.isStatusConditionActive(PokemonStatusConditions.INFATUATION))
				{
					if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 50)
					{
						results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_INFATUATED));
						return results;
					}
				}
				
				// If frozen and Flame Wheel or Sacred Fire was chosen, defrost
				
				// Obedience check
				var obedient:Boolean = false;
				var rageEffect:Boolean = true;
				if (!action.OWNER.isWild && action.OWNER.OTNAME == action.OWNER.TRAINER.NAME)
					obedient = true;
				else if (!action.OWNER.isWild)
				{
					var badgeLevel:int = 10;
					if (action.OWNER.TRAINER.hasBadge(TrainerBadge.KNUCKLE))
						badgeLevel = 30;
					if (action.OWNER.TRAINER.hasBadge(TrainerBadge.HEAT))
						badgeLevel = 50;
					if (action.OWNER.TRAINER.hasBadge(TrainerBadge.FEATHER))
						badgeLevel = 70;
					if (action.OWNER.TRAINER.hasBadge(TrainerBadge.RAIN))
						badgeLevel = 100;
					var A:int = (action.OWNER.LEVEL + badgeLevel) * action.getObedience(1) / 256;
					if (A < badgeLevel)
						obedient = true;
					else
					{
						rageEffect = false;
						if (PokemonMoves.getMoveNameByID(action.MOVEID) == "Snore" || PokemonMoves.getMoveNameByID(action.MOVEID) == "Sleep Talk")
						{
							if (action.OWNER.getNonVolatileStatusCondition() == PokemonStatusConditions.SLEEP)
							{
								results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_IGNORED_ORDERS_WHILE_ASLEEP));
								return results;
							}
						}
						
						var B:int = (action.OWNER.LEVEL + badgeLevel) * action.getObedience(2) / 256;
						if (B < badgeLevel)
						{
							action.setOVERRIDEMOVEID(action.IGNORE_MOVE);
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_IGNORED_ORDERS));
							obedient = true;
						}
						else
						{
							var C:int = action.OWNER.LEVEL - badgeLevel;
							var R:int = action.getObedience(3);
							if (R < C)
							{
								if (action.OWNER.ABILITY != "Vital Spirit" && action.OWNER.ABILITY != "Insomnia")
								{
									if (isTeamBattleEffectActive(null, BattleEffect.UPROAR) == false)
									{
										results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_BEGAN_TO_NAP));
										results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, action.OWNER, BattleActionResult.STATUS_SLEEP));
										return results;
									}
								}
							}
							else if (R - C < C)
							{
								results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_WONT_OBEY));
								tempResults = PokemonStat.calculateDamage(action.OWNER, action.OWNER, 999, action, this);
								action.setOVERRIDEMOVEID(999);
								results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, tempResults[0].DAMAGE, action.OWNER, action.OWNER, BattleActionResult.MOVE_HURT_ITSELF_IN_CONFUSION));
								return results;
							}
							else
							{
								results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.POKEMON_TURNED_AWAY));
								return results;
							}
						}
					}
				}
				
				// charging up moves
				if (MOVE_NAME == "Focus Punch" && action.OWNER.isBattleEffectActive(BattleEffect.FOCUS_ENERGY) == false)
				{
					// We need to focus!
					results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.POKEMON_FOCUS_ENERGY, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					return results;
				}
				
				// targeting
				if (isPokemonAnAlly(action.OWNER))
				{
					// select the target from the "enemy team"
					TARGET = action.TARGET;
				}
				else
				{
					TARGET = action.TARGET;
				}
				
				if (MOVE_NAME == "Disable" && PokemonMoves.getMoveNameByID(TARGET.GOING_TO_USE_MOVE) == "Rage")
					TARGET.changeRageCounter(TARGET.RAGE_COUNTER + 1);
				
				/// ACCURACY CHECK
				if (PokemonMoves.getMoveAccuracyByID(action.MOVEID) == 0 || PokemonMoves.getMoveCategoryByID(action.MOVEID) == "Status")
					HITS = true;
				else
				{
					var accuracy:int = PokemonMoves.getMoveAccuracyByID(action.MOVEID) * 100;
					if (MOVE_NAME == "Fissure" || MOVE_NAME == "Guillotine" || MOVE_NAME == "Horn Drill" || MOVE_NAME == "Sheer Cold")
					{
						if (TARGET.LEVEL > action.OWNER.LEVEL)
						{
							HITS = true;
							FAILED = true;
						}
						else
						{
							accuracy = (action.OWNER.LEVEL - TARGET.LEVEL) + 30;
							if (TARGET.ABILITY == "Sturdy")
							{
								HITS = true;
								FAILED = true;
							}
							if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH <= accuracy)
								HITS = true;
						}
					}
					else
					{
						// Move is not a One-Hit KO
						if (MOVE_NAME == "Thunder" && WEATHER == BattleWeatherEffect.INTENSE_SUNLIGHT)
							accuracy = 50;
						else if (MOVE_NAME == "Thunder" && WEATHER == BattleWeatherEffect.RAIN)
							accuracy = 100;
						if (PokemonMoves.getMoveCategoryByID(action.MOVEID) == "Status")
							accuracy = 50;
						var accuracyStatStage:int = action.OWNER.getStatStage(PokemonStat.ACCURACY);
						var evasionStatStage:int = TARGET.getStatStage(PokemonStat.EVASION);
						
						accuracyStatStage -= evasionStatStage;
						if (accuracyStatStage >= 6)
							accuracyStatStage = 6;
						else if (accuracyStatStage <= -6)
							accuracyStatStage = -6;
						accuracy *= PokemonStat.getStatStageMultiplier(accuracyStatStage);
						if (TARGET.HELDITEM == "Bright Powder")
							accuracy *= 0.9;
						if (TARGET.HELDITEM == "Lax Incense")
							accuracy *= 0.95;
						if (action.OWNER.HELDITEM == "Wide Lens")
							accuracy *= 1.1;
						if (action.OWNER.HELDITEM == "Zoom Lens")
						{
							// check for the target having already moved this turn
							var moved:Boolean = true;
							for (i = 0; i < actionQueue.length; i++)
							{
								if (actionQueue[i].OWNER == TARGET)
									moved = false;
							}
							if (moved)
								accuracy *= 1.2;
						}
						if (action.OWNER.ABILITY == "Compound Eyes")
							accuracy *= 1.3;
						if (TARGET.ABILITY == "Sand Veil" && WEATHER == BattleWeatherEffect.SANDSTORM)
							accuracy *= 4 / 5;
						if (action.OWNER.ABILITY == "Hustle" && PokemonMoves.getMoveCategoryByID(action.MOVEID) == "Physical")
							accuracy *= 0.8;
						accuracy = accuracy >= 100 ? 100 : accuracy;
						if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH < accuracy)
							HITS = true;
					}
					
					if (MOVE_NAME == "Counter")
					{
						if (lastDamageDoneByType != PokemonType.NORMAL && lastDamageDoneByType != PokemonType.FIGHTING)
							HITS = false;
					}
				}
				if (PokemonMoves.getMoveCategoryByID(action.MOVEID) != "Status" && TARGET.isBattleEffectActive(BattleEffect.FLY) && action.OWNER.isBattleEffectActive(BattleEffect.LOCK_ON) == false)
				{
					switch (MOVE_NAME)
					{
					case "Bide": 
					case "Swift": 
					case "Transform": 
					case "Gust": 
					case "Thunder": 
					case "Twister": 
					case "Whirlwind": 
					case "Sky Uppercut":
						
						break;
					default: 
						HITS = false;
						break;
					}
				}
				else if (PokemonMoves.getMoveCategoryByID(action.MOVEID) != "Status" && TARGET.isBattleEffectActive(BattleEffect.BOUNCE) && action.OWNER.isBattleEffectActive(BattleEffect.LOCK_ON) == false)
				{
					switch (MOVE_NAME)
					{
					case "Gust": 
					case "Thunder": 
					case "Twister": 
					case "Sky Uppercut":
						
						break;
					default: 
						HITS = false;
						break;
					}
				}
				else if (PokemonMoves.getMoveCategoryByID(action.MOVEID) != "Status" && TARGET.isBattleEffectActive(BattleEffect.DIVE) && action.OWNER.isBattleEffectActive(BattleEffect.LOCK_ON) == false)
				{
					switch (MOVE_NAME)
					{
					case "Surf": 
					case "Whirlpool":
						
						break;
					default: 
						HITS = false;
						break;
					}
				}
				else if (PokemonMoves.getMoveCategoryByID(action.MOVEID) != "Status" && TARGET.isBattleEffectActive(BattleEffect.DIG) && action.OWNER.isBattleEffectActive(BattleEffect.LOCK_ON) == false)
				{
					switch (MOVE_NAME)
					{
					case "Bide": 
					case "Swift": 
					case "Transform": 
					case "Earthquake": 
					case "Magnitude": 
					case "Fissure": 
						break;
					default: 
						HITS = false;
						break;
					}
				}
				
				if (action.OWNER.areBattleEffectsActive(BattleEffect.MIND_READER, BattleEffect.LOCK_ON))
				{
					action.OWNER.deactivateBattleEffect(BattleEffect.MIND_READER);
					action.OWNER.deactivateBattleEffect(BattleEffect.LOCK_ON);
					HITS = true;
				}
				
				// Semi-invulnerable turns!
				if (MOVE_NAME == "Fly" && action.OWNER.isBattleEffectActive(BattleEffect.FLY) == false)
				{
					// This is the semi-invulnerable turn of fly.
					results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.MOVE_FLEW_UP_HIGH));
					return results;
				}
				else if (MOVE_NAME == "Bide" && (action.OWNER.isBattleEffectActive(BattleEffect.BIDE) == false || action.OWNER.areBattleEffectsActive(BattleEffect.CANNOT_ATTACK1, BattleEffect.CANNOT_ATTACK2)))
				{
					results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.MOVE_NORMAL_USE));
					return results;
				}
				if (MOVE_NAME == "Skull Bash" && action.OWNER.isBattleEffectActive(BattleEffect.SKULL_BASH) == false)
				{
					// This is the semi-invulnerable turn of fly.
					results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.MOVE_LOWERED_HEAD));
					return results;
				}
				else if (MOVE_NAME == "Sky Attack" && action.OWNER.isBattleEffectActive(BattleEffect.SKY_ATTACK) == false)
				{
					// This is the semi-invulnerable turn of fly.
					results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.MOVE_CLOAKED_IN_HARSH_LIGHT));
					return results;
				}
				else if (MOVE_NAME == "Dig" && action.OWNER.isBattleEffectActive(BattleEffect.DIG) == false)
				{
					// This is the semi-invulnerable turn of fly.
					results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.MOVE_DUG_DOWN_DEEP));
					return results;
				}
				else if (MOVE_NAME == "Bounce" && action.OWNER.isBattleEffectActive(BattleEffect.BOUNCE) == false)
				{
					// This is the semi-invulnerable turn of fly.
					results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.MOVE_BOUNCED));
					return results;
				}
				else if (MOVE_NAME == "Dive" && action.OWNER.isBattleEffectActive(BattleEffect.DIVE) == false)
				{
					// This is the semi-invulnerable turn of fly.
					results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.MOVE_DOVE_DOWN_DEEP));
					return results;
				}
				else if (MOVE_NAME == "SolarBeam" && action.OWNER.isBattleEffectActive(BattleEffect.SOLARBEAM) == false && WEATHER != BattleWeatherEffect.INTENSE_SUNLIGHT)
				{
					// This is the semi-invulnerable turn of fly.
					results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.MOVE_TAKING_IN_SUNLIGHT));
					return results;
				}
				
				results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, null, BattleActionResult.MOVE_SUCCESSFUL));
				
				// Move changing moves
				if (MOVE_NAME == "Nature Power" && !FAILED)
				{
					switch (LOCATION)
					{
					case BattleSpecialTile.BUILDING: 
					case BattleSpecialTile.PLAIN: 
						MOVE_NAME = "Swift";
						break;
					case BattleSpecialTile.SAND: 
						MOVE_NAME = "Earthquake";
						break;
					case BattleSpecialTile.CAVE: 
						MOVE_NAME = "Shadow Ball";
						break;
					case BattleSpecialTile.ROCK: 
						MOVE_NAME = "Rock Slide";
						break;
					case BattleSpecialTile.TALL_GRASS: 
						MOVE_NAME = "Stun Spore";
						break;
					case BattleSpecialTile.LONG_GRASS: 
						MOVE_NAME = "Razor Leaf";
						break;
					case BattleSpecialTile.POND_WATER: 
						MOVE_NAME = "BubbleBeam";
						break;
					case BattleSpecialTile.SEA_WATER: 
						MOVE_NAME = "Surf";
						break;
					case BattleSpecialTile.SEAWEED: 
						MOVE_NAME = "Hydro Pump";
						break;
					default: 
						MOVE_NAME = "Hydro Pump";
						break;
					}
					action.setOVERRIDEMOVEID(PokemonMoves.getMoveIDByName(MOVE_NAME));
					results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, null, BattleActionResult.MOVE_SUCCESSFUL));
				}
				else if (MOVE_NAME == "Metronome" && !FAILED)
				{
					// use a random move.
					action.setOVERRIDEMOVEID(action.METRONOME);
					MOVE_NAME = PokemonMoves.getMoveNameByID(action.MOVEID);
					results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, null, BattleActionResult.MOVE_SUCCESSFUL));
				}
				else if (MOVE_NAME == "Assist")
				{
					var moveID:int = 0;
					var moveName:String = "";
					// select an ally
					var ally:Pokemon = allyPokemon.length > 1 ? allyPokemon[Math.floor(Math.random() * (allyPokemon.length - 1)) + 1] : allyPokemon[0];
					var attempt:int = 0;
					do
					{
						attempt++;
						moveName = ally.getRandomMove();
						moveID = PokemonMoves.getMoveIDByName(moveName);
					} while ((moveName == "Counter" || moveName == "Covet" || moveName == "Destiny Bond" || moveName == "Detect" || moveName == "Endure" || moveName == "Focus Punch" || moveName == "Follow Me" || moveName == "Helping Hand" || moveName == "Metronome" || moveName == "Mimic" || moveName == "Mirror Coat" || moveName == "Mirror Move" || moveName == "Protect" || moveName == "Sketch" || moveName == "Sleep Talk" || moveName == "Snatch" || moveName == "Struggle" || moveName == "Thief" || moveName == "Trick") && attempt < 10);
					if (attempt >= 10)
					{
						results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
					}
					else
					{
						trace("Overrode " + moveID);
						action.setOVERRIDEMOVEID(moveID);
						MOVE_NAME = PokemonMoves.getMoveNameByID(action.MOVEID);
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, null, BattleActionResult.MOVE_SUCCESSFUL));
					}
				}
				else if (MOVE_NAME == "Mirror Move")
				{
					if (TARGET.LAST_MOVE_USED != 0 && TARGET.LAST_MOVE_USED != action.MOVEID)
					{
						action.setOVERRIDEMOVEID(TARGET.LAST_MOVE_USED);
						MOVE_NAME = PokemonMoves.getMoveNameByID(action.MOVEID);
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, null, BattleActionResult.MOVE_SUCCESSFUL));
					}
					else
					{
						results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
					}
				}
				else if ((MOVE_NAME == "Thrash" || MOVE_NAME == "Petal Dance" || MOVE_NAME == "Outrage") && action.OWNER.areBattleEffectsActive(BattleEffect.REPEAT_ATTACK1, BattleEffect.REPEAT_ATTACK2, BattleEffect.REPEAT_ATTACK3) == false)
				{
					if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 50)
					{
						action.OWNER.activateBattleEffect(BattleEffect.REPEAT_ATTACK3);
					}
					else
					{
						action.OWNER.activateBattleEffect(BattleEffect.REPEAT_ATTACK2);
					}
				}
				else if (MOVE_NAME == "Razor Wind" && !FAILED && action.OWNER.isBattleEffectActive(BattleEffect.WHIRLWIND) == false)
				{
					results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.MOVE_WHIRLWIND, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					return results;
				}
				else if (MOVE_NAME == "Brick Break")
				{
					if (areTeamBattleEffectsActive(TARGET, BattleEffect.REFLECT1, BattleEffect.REFLECT2, BattleEffect.REFLECT3, BattleEffect.REFLECT4, BattleEffect.REFLECT5))
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.REFLECT_DESTROYED, 0, 0));
					}
					if (areTeamBattleEffectsActive(TARGET, BattleEffect.LIGHT_SCREEN1, BattleEffect.LIGHT_SCREEN2, BattleEffect.LIGHT_SCREEN3, BattleEffect.LIGHT_SCREEN4, BattleEffect.LIGHT_SCREEN5))
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.LIGHT_SCREEN_DESTROYED, 0, 0));
					}
					deactivateTeamBattleEffect(TARGET, BattleEffect.REFLECT1);
					deactivateTeamBattleEffect(TARGET, BattleEffect.REFLECT2);
					deactivateTeamBattleEffect(TARGET, BattleEffect.REFLECT3);
					deactivateTeamBattleEffect(TARGET, BattleEffect.REFLECT4);
					deactivateTeamBattleEffect(TARGET, BattleEffect.REFLECT5);
					deactivateTeamBattleEffect(TARGET, BattleEffect.LIGHT_SCREEN1);
					deactivateTeamBattleEffect(TARGET, BattleEffect.LIGHT_SCREEN2);
					deactivateTeamBattleEffect(TARGET, BattleEffect.LIGHT_SCREEN3);
					deactivateTeamBattleEffect(TARGET, BattleEffect.LIGHT_SCREEN4);
					deactivateTeamBattleEffect(TARGET, BattleEffect.LIGHT_SCREEN5);
				}
				else if (MOVE_NAME == "Hyper Voice")
				{
					if (TARGET.ABILITY == "Soundproof")
						FAILED = true;
				}
				else if (MOVE_NAME == "Spit Up" || MOVE_NAME == "Swallow")
				{
					if (action.OWNER.areBattleEffectsActive(BattleEffect.ONE_STOCKPILE, BattleEffect.TWO_STOCKPILE, BattleEffect.THREE_STOCKPILE) == false)
					{
						FAILED = true;
					}
				}
				else if (MOVE_NAME == "Snore")
				{
					if (action.OWNER.getNonVolatileStatusCondition() != PokemonStatusConditions.SLEEP)
						FAILED = true;
				}
				else if (MOVE_NAME == "Sleep Talk")
				{
					if (action.OWNER.getNonVolatileStatusCondition() != PokemonStatusConditions.SLEEP)
						FAILED = true;
					else
					{
						var moveToSleepTalk:String = "";
						var tries:int = 0;
						do
						{
							moveToSleepTalk = action.OWNER.getRandomMove();
							tries++;
						} while ((moveToSleepTalk == "Copycat" || moveToSleepTalk == "Bounce" || moveToSleepTalk == "Assist" || moveToSleepTalk == "Sleep Talk" || moveToSleepTalk == "Bide" || moveToSleepTalk == "Dig" || moveToSleepTalk == "Dive" || moveToSleepTalk == "Fly" || moveToSleepTalk == "Metronome" || moveToSleepTalk == "Mirror Move" || moveToSleepTalk == "Skull Bash" || moveToSleepTalk == "Sky Attack" || moveToSleepTalk == "Focus Punch" || moveToSleepTalk == "SolarBeam" || moveToSleepTalk == "Uproar" || moveToSleepTalk == "Razor Wind") && tries < 10);
						if (tries >= 10)
							FAILED = true;
						else
						{
							MOVE_NAME = moveToSleepTalk;
							action.setOVERRIDEMOVEID(PokemonMoves.getMoveIDByName(MOVE_NAME));
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, null, BattleActionResult.MOVE_SUCCESSFUL));
						}
					}
				}
				
				// failure check
				var DOES_DAMAGE:Boolean = true;
				if (MOVE_NAME == "Counter" && lastDamageDone == 0)
					FAILED = true;
				else if (MOVE_NAME == "Counter" && PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED) == "Metronome")
					FAILED = true;
				else if (MOVE_NAME == "Counter" && TARGET.GOING_TO_USE_MOVE == action.MOVEID)
					FAILED = true;
				else if (MOVE_NAME == "Endeavor" && action.OWNER.CURRENT_HP >= TARGET.CURRENT_HP)
					FAILED = true;
				else if ((MOVE_NAME == "Explosion" || MOVE_NAME == "Selfdestruct") && doesAPokemonHaveAbility("Damp"))
					FAILED = true;
				else if (MOVE_NAME == "Bide" && action.OWNER.BIDE_COUNT == 0)
					FAILED = true;
				
				if (PokemonMoves.getMoveCategoryByID(action.MOVEID) == "Status")
					DOES_DAMAGE = false;
				
				if (FAILED)
				{
					results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
				}
				else if (HITS && DOES_DAMAGE)
				{
					// Damage calculation
					var resultsVec:Vector.<BattleActionResult> = PokemonStat.calculateDamage(action.OWNER, TARGET, action.MOVEID, action, this);
					
					var numHits:int = 1;
					if (MOVE_NAME == "Triple Kick")
					{
						var subseqHits:Vector.<BattleActionResult> = new Vector.<BattleActionResult>();
						var subseqHits1:Vector.<BattleActionResult> = new Vector.<BattleActionResult>();
						if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 10)
							subseqHits = PokemonStat.calculateDamage(action.OWNER, TARGET, action.MOVEID, action, this, 20);
						if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 20)
							subseqHits1 = PokemonStat.calculateDamage(action.OWNER, TARGET, action.MOVEID, action, this, 30);
						for (i = 0; i < subseqHits.length; i++)
							resultsVec.push(subseqHits[i]);
						for (i = 0; i < subseqHits1.length; i++)
							resultsVec.push(subseqHits1[i]);
					}
					else if (MOVE_NAME == "Beat Up")
					{
						// go through all of the attacker's allies, adding on damage
						var tempBeatUpHits:Vector.<BattleActionResult>;
						if (isPokemonAnAlly(action.OWNER))
						{
							for (i = 0; i < allyPokemon.length; i++)
							{
								if (allyPokemon[i] != action.OWNER)
								{
									tempBeatUpHits = PokemonStat.calculateDamage(allyPokemon[i], TARGET, action.MOVEID, action, this);
									for (j = 0; j < tempBeatUpHits.length; j++)
									{
										resultsVec.push(tempBeatUpHits[j]);
									}
								}
							}
						}
						else
						{
							for (i = 0; i < enemyPokemon.length; i++)
							{
								if (enemyPokemon[i] != action.OWNER)
								{
									tempBeatUpHits = PokemonStat.calculateDamage(enemyPokemon[i], TARGET, action.MOVEID, action, this);
									for (j = 0; j < tempBeatUpHits.length; j++)
									{
										resultsVec.push(tempBeatUpHits[j]);
									}
								}
							}
						}
					}
					else if (MOVE_NAME == "Pay Day")
					{
						if (isPokemonAnAlly(action.OWNER))
						{
							allyMoneyPot += action.OWNER.LEVEL * 5;
						}
						else
						{
							enemyMoneyPot += action.OWNER.LEVEL * 5;
						}
					}
					else if ((MOVE_NAME == "Bind" || MOVE_NAME == "Wrap" || MOVE_NAME == "Clamp") && action.OWNER.areBattleEffectsActive(BattleEffect.REPEAT_ATTACK1, BattleEffect.REPEAT_ATTACK2, BattleEffect.REPEAT_ATTACK3, BattleEffect.REPEAT_ATTACK4, BattleEffect.REPEAT_ATTACK5))
					{
						resultsVec[0].DAMAGE = (1 / 16) * resultsVec[0].VICTIM.getStat(PokemonStat.HP);
					}
					else if (MOVE_NAME == "Bide")
					{
						resultsVec[0].DAMAGE = 2 * action.OWNER.BIDE_COUNT;
					}
					else if ((MOVE_NAME == "Bind" || MOVE_NAME == "Wrap" || MOVE_NAME == "Clamp") && action.OWNER.isBattleEffectActive(BattleEffect.REPEAT_ATTACK1) == false)
					{
						if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 63)
						{
							
							action.OWNER.activateBattleEffect(BattleEffect.REPEAT_ATTACK2);
								//TARGET.activateBattleEffect(BattleEffect.CANNOT_ATTACK2);
						}
						else if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 26)
						{
							
							action.OWNER.activateBattleEffect(BattleEffect.REPEAT_ATTACK3);
								//TARGET.activateBattleEffect(BattleEffect.CANNOT_ATTACK3);
						}
						else if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 13)
						{
							
							action.OWNER.activateBattleEffect(BattleEffect.REPEAT_ATTACK4);
								//TARGET.activateBattleEffect(BattleEffect.CANNOT_ATTACK4);
						}
						else
						{
							action.OWNER.activateBattleEffect(BattleEffect.REPEAT_ATTACK5);
								//TARGET.activateBattleEffect(BattleEffect.CANNOT_ATTACK5);
						}
					}
					else if (MOVE_NAME == "Take Down" || MOVE_NAME == "Double-Edge" || MOVE_NAME == "Submission")
					{
						resultsVec.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, resultsVec[0].DAMAGE * 0.25, action.OWNER, action.OWNER, BattleActionResult.MOVE_RECOIL));
					}
					else if (MOVE_NAME == "Struggle")
					{
						resultsVec.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, resultsVec[0].DAMAGE * 0.5, action.OWNER, action.OWNER, BattleActionResult.MOVE_RECOIL));
						
					}
					else if (MOVE_NAME == "Gust" || MOVE_NAME == "Thunder")
					{
						if (TARGET.areBattleEffectsActive(BattleEffect.FLY))
							resultsVec[0].DAMAGE *= 2;
					}
					else if (MOVE_NAME == "Mirror Coat")
					{
						if (TARGET.isType(PokemonType.GHOST) || action.OWNER.LAST_TAKEN_DAMAGE == 0 || PokemonMoves.getMoveCategoryByID(action.OWNER.LAST_HIT_BY_MOVE) != "Special")
						{
							resultsVec[0].DAMAGE = 0;
							resultsVec[0].TYPE = BattleActionResult.MOVE_FAILURE;
						}
						else
						{
							resultsVec[0].DAMAGE = 2 * action.OWNER.LAST_TAKEN_DAMAGE;
						}
					}
					else if (MOVE_NAME == "Whirlpool" || MOVE_NAME == "Surf")
					{
						if (TARGET.areBattleEffectsActive(BattleEffect.DIVE))
							resultsVec[0].DAMAGE *= 2;
					}
					else if (MOVE_NAME == "Sonic Boom")
					{
						if (TARGET..isType(PokemonType.GHOST))
						{
							resultsVec[0].DAMAGE = 0;
							resultsVec[0].TYPE = BattleActionResult.MOVE_NO_EFFECT;
						}
						else
						{
							resultsVec[0].TYPE = BattleActionResult.MOVE_NORMAL_USE;
							resultsVec[0].DAMAGE = 20;
						}
					}
					else if (MOVE_NAME == "Dream Eater")
					{
						if (TARGET.getNonVolatileStatusCondition() != PokemonStatusConditions.SLEEP)
						{
							resultsVec[0].TYPE = BattleActionResult.MOVE_FAILURE;
							resultsVec[0].DAMAGE = 0;
						}
					}
					else if (MOVE_NAME == "Future Sight")
					{
						
					}
					else if (MOVE_NAME == "Doom Desire")
					{
						
					}
					else if (MOVE_NAME == "Psywave")
					{
						if (resultsVec[0].DAMAGE != 0)
						{
							resultsVec[0].DAMAGE = (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH / 100 + 0.5) * action.OWNER.LEVEL;
							if (resultsVec[0].DAMAGE < 1)
								resultsVec[0].DAMAGE = 1;
						}
					}
					else if ((MOVE_NAME == "Earthquake" || MOVE_NAME == "Magnitude") && TARGET.isBattleEffectActive(BattleEffect.DIG))
						resultsVec[0].DAMAGE *= 2;
					else if (MOVE_NAME == "Seismic Toss")
						resultsVec[0].DAMAGE = action.OWNER.LEVEL;
					else if (MOVE_NAME == "Counter")
						resultsVec[0].DAMAGE = 2 * lastDamageDone;
					else if (MOVE_NAME == "Spike Cannon" || MOVE_NAME == "Barrage" || MOVE_NAME == "Fury Swipes" || MOVE_NAME == "Bone Rush" || MOVE_NAME == "Arm Thrust" || MOVE_NAME == "Bullet Seed" || MOVE_NAME == "Icicle Spear" || MOVE_NAME == "Pin Missile" || MOVE_NAME == "Fury Attack" || MOVE_NAME == "DoubleSlap" || MOVE_NAME == "Comet Punch" || MOVE_NAME == "Rock Blast")
					{
						trace("Deciding on number of hits " + action.ACCURACY, action.ASTONISH);
						if ((action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH) >= 63)
							numHits = 2;
						else if ((action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH) >= 26)
							numHits = 3;
						else if ((action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH) >= 13)
							numHits = 4;
						else
							numHits = 5;
					}
					else if (MOVE_NAME == "Bonemerang")
					{
						numHits = 2;
					}
					else if (MOVE_NAME == "Double Kick" || MOVE_NAME == "Twineedle")
					{
						numHits = 2;
					}
					else if (MOVE_NAME == "Razor Wind")
					{
						action.OWNER.deactivateBattleEffect(BattleEffect.WHIRLWIND);
					}
					else if (MOVE_NAME == "Brick Break")
					{
						
					}
					
					if (numHits != 1)
					{
						//trace("Hitting " + numHits);
						for (var h:uint = 1; h < numHits; h++)
						{
							var res:Vector.<BattleActionResult> = PokemonStat.calculateDamage(action.OWNER, TARGET, action.MOVEID, action, this, 0);
							res[0].CRITICAL_HIT = false;
							for (var k:int = 0; k < res.length; k++)
							{
								resultsVec.splice(1, 0, res[k]);
							}
						}
					}
					
					lastDamageDone = 0;
					lastDamageDoneByType = PokemonMoves.getMoveTypeByID(action.MOVEID);
					
					for (i = 0; i < resultsVec.length; i++)
					{
						if (resultsVec[i].DAMAGE != 0)
							lastDamageDone = resultsVec[i].DAMAGE;
						results.push(resultsVec[i]);
						resultsVec[i] = null;
					}
				}
				else if (HITS && !DOES_DAMAGE)
				{
					// this is a status move.
					//results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_MOVE));
					if (action.OWNER.areBattleEffectsActive(BattleEffect.TAUNT2, BattleEffect.TAUNT1))
					{
						results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
					}
					else if (MOVE_NAME == "Swallow")
					{
						var fractionRestored:Number = 0;
						if (action.OWNER.isBattleEffectActive(BattleEffect.ONE_STOCKPILE))
							fractionRestored = 0.25;
						else if (action.OWNER.isBattleEffectActive(BattleEffect.TWO_STOCKPILE))
							fractionRestored = 0.5;
						else if (action.OWNER.isBattleEffectActive(BattleEffect.THREE_STOCKPILE))
							fractionRestored = 1.0;
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ASTONISH, -fractionRestored * action.OWNER.getStat(PokemonStat.HP), action.OWNER, action.OWNER, BattleActionResult.MOVE_NORMAL_USE));
					}
					else if (MOVE_NAME == "Psych Up")
					{
						action.OWNER.changeStatStage(PokemonStat.ATK, TARGET.getStatStage(PokemonStat.ATK) - action.OWNER.getStatStage(PokemonStat.ATK));
						action.OWNER.changeStatStage(PokemonStat.DEF, TARGET.getStatStage(PokemonStat.DEF) - action.OWNER.getStatStage(PokemonStat.DEF));
						action.OWNER.changeStatStage(PokemonStat.SPATK, TARGET.getStatStage(PokemonStat.SPATK) - action.OWNER.getStatStage(PokemonStat.SPATK));
						action.OWNER.changeStatStage(PokemonStat.SPDEF, TARGET.getStatStage(PokemonStat.SPDEF) - action.OWNER.getStatStage(PokemonStat.SPDEF));
						action.OWNER.changeStatStage(PokemonStat.SPEED, TARGET.getStatStage(PokemonStat.SPEED) - action.OWNER.getStatStage(PokemonStat.SPEED));
						action.OWNER.changeStatStage(PokemonStat.ACCURACY, TARGET.getStatStage(PokemonStat.ACCURACY) - action.OWNER.getStatStage(PokemonStat.ACCURACY));
						action.OWNER.changeStatStage(PokemonStat.EVASION, TARGET.getStatStage(PokemonStat.EVASION) - action.OWNER.getStatStage(PokemonStat.EVASION));
					}
					else if (MOVE_NAME == "Safeguard")
					{
						if (areTeamBattleEffectsActive(action.OWNER, BattleEffect.SAFEGUARD1, BattleEffect.SAFEGUARD2, BattleEffect.SAFEGUARD3, BattleEffect.SAFEGUARD4, BattleEffect.SAFEGUARD5))
						{
							// Can't activate safeguard more than once!
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							activateTeamBattleEffect(action.OWNER, BattleEffect.SAFEGUARD5);
						}
					}
					else if (MOVE_NAME == "Stockpile")
					{
						if (action.OWNER.isBattleEffectActive(BattleEffect.THREE_STOCKPILE))
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						else if (action.OWNER.isBattleEffectActive(BattleEffect.TWO_STOCKPILE))
							action.OWNER.replaceBattleEffect(BattleEffect.TWO_STOCKPILE, BattleEffect.THREE_STOCKPILE);
						else if (action.OWNER.isBattleEffectActive(BattleEffect.ONE_STOCKPILE))
							action.OWNER.replaceBattleEffect(BattleEffect.ONE_STOCKPILE, BattleEffect.TWO_STOCKPILE);
						else
							action.OWNER.activateBattleEffect(BattleEffect.ONE_STOCKPILE);
					}
					else if (MOVE_NAME == "Mimic")
					{
						var lastMove:int = TARGET.LAST_MOVE_USED;
						if (action.OWNER.switchMoves(action.MOVEID, lastMove, 5) == false)
						{
							// Move failed to copy
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
					}
					else if (MOVE_NAME == "Belly Drum")
					{
						if (action.OWNER.CURRENT_HP <= action.OWNER.getStat(PokemonStat.HP) * 0.5 || action.OWNER.getStatStage(PokemonStat.ATK) == 6)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_ATK, 12, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0.5 * action.OWNER.getStat(PokemonStat.HP), action.OWNER, action.OWNER, BattleActionResult.MOVE_NORMAL_USE));
						}
					}
					else if (MOVE_NAME == "Wish")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.POKEMON_MADE_A_WISH));
					}
					else if (MOVE_NAME == "Nightmare")
					{
						if (TARGET.getNonVolatileStatusCondition() != PokemonStatusConditions.SLEEP)
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						else
						{
							TARGET.activateBattleEffect(BattleEffect.NIGHTMARE);
						}
					}
					else if (MOVE_NAME == "Perish Song")
					{
						for (i = 0; i < enemyPokemon.length; i++)
						{
							if (enemyPokemon[i].ACTIVE && enemyPokemon[i].ABILITY != "Soundproof")
							{
								enemyPokemon[i].activateBattleEffect(BattleEffect.PERISH_SONG3);
								results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ASTONISH, 0, action.OWNER, enemyPokemon[i], BattleActionResult.MOVE_PERISH_SONG_INIT));
							}
						}
						for (i = 0; i < allyPokemon.length; i++)
						{
							if (allyPokemon[i].ACTIVE && allyPokemon[i].ABILITY != "Soundpoof")
							{
								allyPokemon[i].activateBattleEffect(BattleEffect.PERISH_SONG3);
								results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ASTONISH, 0, action.OWNER, allyPokemon[i], BattleActionResult.MOVE_PERISH_SONG_INIT));
							}
						}
					}
					else if (MOVE_NAME == "Charge")
					{
						action.OWNER.activateBattleEffect(BattleEffect.CHARGE);
					}
					else if (MOVE_NAME == "Curse")
					{
						if (action.OWNER.isType(PokemonType.GHOST))
						{
							// Put a curse on the target
							TARGET.activateBattleEffect(BattleEffect.CURSE);
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0.5 * action.OWNER.getStat(PokemonStat.HP), action.OWNER, action.OWNER, BattleActionResult.MOVE_NORMAL_USE));
						}
						else
						{
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_SPEED, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_ATK, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_DEF, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						}
					}
					else if (MOVE_NAME == "Scary Face")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_SPEED, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Moonlight" || MOVE_NAME == "Synthesis" || MOVE_NAME == "Morning Sun")
					{
						var healthRestored:Number = 0;
						switch (WEATHER)
						{
						case BattleWeatherEffect.CLEAR_SKIES: 
							healthRestored = 0.5;
							break;
						case BattleWeatherEffect.INTENSE_SUNLIGHT: 
							healthRestored = 2 / 3;
							break;
						default: 
							healthRestored = 1 / 4;
							break;
						}
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY, -healthRestored * action.OWNER.getStat(PokemonStat.HP), action.OWNER, action.OWNER, BattleActionResult.MOVE_NORMAL_USE));
					}
					else if (MOVE_NAME == "Focus Energy")
					{
						if (action.OWNER.isBattleEffectActive(BattleEffect.FOCUS_ENERGY_STATUS))
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							action.OWNER.activateBattleEffect(BattleEffect.FOCUS_ENERGY_STATUS);
					}
					else if (MOVE_NAME == "Heal Bell")
					{
						if (isPokemonAnAlly(action.OWNER))
						{
							for (i = 0; i < allyPokemon.length; i++)
							{
								switch (allyPokemon[i].getNonVolatileStatusCondition())
								{
								case PokemonStatusConditions.SLEEP: 
									results.push(BattleActionResult.generateStatusResult(allyPokemon[i], BattleActionResult.STATUS_CURE_SLEEP));
									break;
								case PokemonStatusConditions.POISON: 
									results.push(BattleActionResult.generateStatusResult(allyPokemon[i], BattleActionResult.STATUS_CURE_POISON));
									break;
								case PokemonStatusConditions.FREEZE: 
									results.push(BattleActionResult.generateStatusResult(allyPokemon[i], BattleActionResult.STATUS_CURE_FREEZE));
									break;
								case PokemonStatusConditions.PARALYSIS: 
									results.push(BattleActionResult.generateStatusResult(allyPokemon[i], BattleActionResult.STATUS_CURE_PARALYSIS));
									break;
								case PokemonStatusConditions.BURN: 
									results.push(BattleActionResult.generateStatusResult(allyPokemon[i], BattleActionResult.STATUS_CURE_BURN));
									break;
								}
							}
						}
						else
						{
							
							for (i = 0; i < enemyPokemon.length; i++)
							{
								switch (enemyPokemon[i].getNonVolatileStatusCondition())
								{
								case PokemonStatusConditions.SLEEP: 
									results.push(BattleActionResult.generateStatusResult(enemyPokemon[i], BattleActionResult.STATUS_CURE_SLEEP));
									break;
								case PokemonStatusConditions.POISON: 
									results.push(BattleActionResult.generateStatusResult(enemyPokemon[i], BattleActionResult.STATUS_CURE_POISON));
									break;
								case PokemonStatusConditions.FREEZE: 
									results.push(BattleActionResult.generateStatusResult(enemyPokemon[i], BattleActionResult.STATUS_CURE_FREEZE));
									break;
								case PokemonStatusConditions.PARALYSIS: 
									results.push(BattleActionResult.generateStatusResult(enemyPokemon[i], BattleActionResult.STATUS_CURE_PARALYSIS));
									break;
								case PokemonStatusConditions.BURN: 
									results.push(BattleActionResult.generateStatusResult(enemyPokemon[i], BattleActionResult.STATUS_CURE_BURN));
									break;
								}
							}
						}
					}
					else if (MOVE_NAME == "Pain Split")
					{
						var health:Number = TARGET.CURRENT_HP + action.OWNER.CURRENT_HP;
						health /= 2;
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, TARGET.CURRENT_HP - health, TARGET, TARGET, BattleActionResult.MOVE_NORMAL_USE));
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, action.OWNER.CURRENT_HP - health, action.OWNER, action.OWNER, BattleActionResult.MOVE_NORMAL_USE));
					}
					else if (MOVE_NAME == "Spikes")
					{
						if (isPokemonAnAlly(action.OWNER))
						{
							if (isTeamBattleEffectActive(enemyPokemon[0], BattleEffect.THREE_SPIKE))
							{
								results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
							}
							else if (isTeamBattleEffectActive(enemyPokemon[0], BattleEffect.TWO_SPIKE))
							{
								deactivateTeamBattleEffect(enemyPokemon[0], BattleEffect.TWO_SPIKE);
								activateTeamBattleEffect(enemyPokemon[0], BattleEffect.THREE_SPIKE);
							}
							else if (isTeamBattleEffectActive(enemyPokemon[0], BattleEffect.ONE_SPIKE))
							{
								deactivateTeamBattleEffect(enemyPokemon[0], BattleEffect.ONE_SPIKE);
								activateTeamBattleEffect(enemyPokemon[0], BattleEffect.TWO_SPIKE);
							}
							else
							{
								activateTeamBattleEffect(enemyPokemon[0], BattleEffect.ONE_SPIKE);
							}
						}
						else
						{
							if (isTeamBattleEffectActive(allyPokemon[0], BattleEffect.THREE_SPIKE))
							{
								results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
							}
							else if (isTeamBattleEffectActive(allyPokemon[0], BattleEffect.TWO_SPIKE))
							{
								deactivateTeamBattleEffect(allyPokemon[0], BattleEffect.TWO_SPIKE);
								activateTeamBattleEffect(allyPokemon[0], BattleEffect.THREE_SPIKE);
							}
							else if (isTeamBattleEffectActive(allyPokemon[0], BattleEffect.ONE_SPIKE))
							{
								deactivateTeamBattleEffect(allyPokemon[0], BattleEffect.ONE_SPIKE);
								activateTeamBattleEffect(allyPokemon[0], BattleEffect.TWO_SPIKE);
							}
							else
							{
								activateTeamBattleEffect(allyPokemon[0], BattleEffect.ONE_SPIKE);
							}
						}
					}
					else if (MOVE_NAME == "Haze")
					{
						for (i = 0; i < allyPokemon.length; i++)
						{
							allyPokemon[i].resetStatStages();
						}
						for (i = 0; i < enemyPokemon.length; i++)
						{
							enemyPokemon[i].resetStatStages();
						}
						
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_STAGES_RESET, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Swords Dance")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_ATK, 2, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Iron Defense" || MOVE_NAME == "Acid Armor")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_DEF, 2, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Metal Sound" || MOVE_NAME == "Fake Tears")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_SPDEF, -2, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Kinesis" || MOVE_NAME == "Flash")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_ACCURACY, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Sweet Scent")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_EVASION, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Aromatherapy")
					{
						if (isPokemonAnAlly(action.OWNER))
						{
							for (i = 0; i < allyPokemon.length; i++)
							{
								switch (allyPokemon[i].getNonVolatileStatusCondition())
								{
								case PokemonStatusConditions.BURN: 
									results.push(BattleActionResult.generateStatusResult(allyPokemon[i], BattleActionResult.STATUS_CURE_BURN, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
									break;
								case PokemonStatusConditions.FREEZE: 
									results.push(BattleActionResult.generateStatusResult(allyPokemon[i], BattleActionResult.STATUS_CURE_FREEZE, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
									break;
								case PokemonStatusConditions.PARALYSIS: 
									results.push(BattleActionResult.generateStatusResult(allyPokemon[i], BattleActionResult.STATUS_CURE_PARALYSIS, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
									break;
								case PokemonStatusConditions.POISON: 
									results.push(BattleActionResult.generateStatusResult(allyPokemon[i], BattleActionResult.STATUS_CURE_POISON, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
									break;
								case PokemonStatusConditions.SLEEP: 
									results.push(BattleActionResult.generateStatusResult(allyPokemon[i], BattleActionResult.STATUS_CURE_SLEEP, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
									break;
								}
							}
						}
					}
					else if (MOVE_NAME == "Amnesia")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_SPDEF, 2, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Splash")
					{
						results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_NOTHING_HAPPENED));
					}
					else if (MOVE_NAME == "Screech")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_DEF, -2, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Double Team")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_EVASION, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Transform")
					{
						if (TARGET.transformed == null)
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.POKEMON_TRANSFORMED));
						else
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
					}
					else if (MOVE_NAME == "Grudge")
					{
						if (action.OWNER.isBattleEffectActive(BattleEffect.GRUDGE) == false)
							action.OWNER.activateBattleEffect(BattleEffect.GRUDGE);
						else
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
					}
					else if (MOVE_NAME == "Refresh")
					{
						switch (action.OWNER.getNonVolatileStatusCondition())
						{
						case PokemonStatusConditions.BURN: 
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_CURE_BURN, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
							break;
						case PokemonStatusConditions.POISON: 
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_CURE_POISON, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
							break;
						case PokemonStatusConditions.PARALYSIS: 
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_CURE_PARALYSIS, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
							break;
						default: 
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_NOTHING_HAPPENED));
							break;
						}
					}
					else if (MOVE_NAME == "Yawn")
					{
						if (TARGET.ABILITY == "Insomnia" || TARGET.ABILITY == "Vital Spirit" || TARGET.getNonVolatileStatusCondition() != null)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							TARGET.activateBattleEffect(BattleEffect.YAWN2);
					}
					else if (MOVE_NAME == "Skill Swap")
					{
						if (TARGET.ABILITY != "Wonder Guard" && action.OWNER.ABILITY != "Wonder Guard")
						{
							var ability:String = action.OWNER.ABILITY;
							action.OWNER.OVERRIDE_ABILITY = TARGET.ABILITY;
							TARGET.OVERRIDE_ABILITY = ability;
						}
						else
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
					}
					else if (MOVE_NAME == "Role Play")
					{
						if (TARGET.ABILITY == "Zen Mode" || TARGET.ABILITY == "Wonder Guard" || TARGET.ABILITY == "Multitype" || TARGET.ABILITY == "Imposter" || TARGET.ABILITY == "Illusion" || TARGET.ABILITY == "Stance Change")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							action.OWNER.OVERRIDE_ABILITY = TARGET.ABILITY;
						}
					}
					else if (MOVE_NAME == "Helping Hand")
					{
						results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
					}
					else if (MOVE_NAME == "Trick")
					{
						if (TARGET.ABILITY != "Sticky Hold" && action.OWNER.ABILITY != "Sticky Hold" && TARGET.HELDITEM == "" && action.OWNER.HELDITEM == "")
						{
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY, 0, action.OWNER, TARGET, BattleActionResult.MOVE_TRADE_ITEM));
						}
						else
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
					}
					else if (MOVE_NAME == "Taunt")
					{
						TARGET.activateBattleEffect(BattleEffect.TAUNT2);
					}
					else if (MOVE_NAME == "Follow Me")
					{
						for (i = 1; i < actionQueue.length; i++)
						{
							if (isPokemonAnAlly(actionQueue[i].OWNER) == false && isPokemonAnAlly(action.OWNER))
							{
								// actionQueue on enemy team, owner on ally team
								actionQueue[i].setTarget(action.OWNER);
							}
							else if (isPokemonAnAlly(actionQueue[i].OWNER) && isPokemonAnAlly(action.OWNER) == false)
							{
								// actionQueue on ally team, owner on enemy team
								actionQueue[i].setTarget(action.OWNER);
							}
						}
					}
					else if (MOVE_NAME == "Charm")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_ATK, -2, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY));
					}
					else if (MOVE_NAME == "Memento")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_ATK, -2, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY));
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_SPATK, -2, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY));
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY, action.OWNER.CURRENT_HP, action.OWNER, action.OWNER, BattleActionResult.MOVE_NORMAL_USE));
					}
					else if (MOVE_NAME == "Will-O-Wisp")
					{
						if (TARGET.isType(PokemonType.FIRE))
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else if (TARGET.getNonVolatileStatusCondition() != PokemonStatusConditions.BURN)
						{
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_BURN, 0, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY));
						}
					}
					else if (MOVE_NAME == "Flatter")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_SPATK, 1, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY));
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_CONFUSION, 0, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY));
					}
					else if (MOVE_NAME == "Torment")
					{
						TARGET.activateBattleEffect(BattleEffect.TORMENT);
					}
					else if (MOVE_NAME == "Swagger")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_ATK, 2, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY));
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_CONFUSION, 0, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY));
					}
					else if (MOVE_NAME == "Imprison")
					{
						action.OWNER.activateBattleEffect(BattleEffect.IMPRISON);
						if (isPokemonAnAlly(action.OWNER))
						{
							for (i = 0; i < enemyPokemon.length; i++)
							{
								var targ:Pokemon = enemyPokemon[i];
								for (j = 1; j <= 4; j++)
								{
									for (k = 1; k <= 4; k++)
									{
										if (targ.getMove(j) == action.OWNER.getMove(k))
										{
											targ.IMPRISONED_BY = action.OWNER;
											targ.disableMove(j, -1);
										}
									}
								}
							}
						}
					}
					else if (MOVE_NAME == "Hail")
					{
						if (WEATHER == BattleWeatherEffect.HAIL)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.WEATHER_BEGAN_TO_HAIL));
					}
					else if (MOVE_NAME == "Sunny Day")
					{
						if (WEATHER == BattleWeatherEffect.INTENSE_SUNLIGHT)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.WEATHER_BEGAN_TO_SHINE));
					}
					else if (MOVE_NAME == "Rain Dance")
					{
						if (WEATHER == BattleWeatherEffect.RAIN)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.WEATHER_BEGAN_TO_RAIN));
					}
					else if (MOVE_NAME == "Sandstorm")
					{
						if (WEATHER == BattleWeatherEffect.SANDSTORM)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.WEATHER_BEGAN_SANDSTORM));
					}
					else if (MOVE_NAME == "Dragon Dance")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_ATK, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_SPEED, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Recover" || MOVE_NAME == "Softboiled" || MOVE_NAME == "Milk Drink")
					{
						if (action.OWNER.CURRENT_HP != action.OWNER.getStat(PokemonStat.HP))
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, 0, -1 * (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH / 200 * action.OWNER.getStat(PokemonStat.HP)), action.OWNER, action.OWNER, BattleActionResult.MOVE_NORMAL_USE));
						else
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
					}
					else if (MOVE_NAME == "Mean Look")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_PARTIAL_TRAP, 0, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY));
					}
					else if (MOVE_NAME == "Slack Off")
					{
						if (action.OWNER.CURRENT_HP != action.OWNER.getStat(PokemonStat.HP))
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, 0, -1 * (0.5 * action.OWNER.getStat(PokemonStat.HP)), action.OWNER, action.OWNER, BattleActionResult.MOVE_NORMAL_USE));
						else
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
					}
					else if (MOVE_NAME == "Attract")
					{
						if (action.OWNER.GENDER != TARGET.GENDER)
						{
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_INFATUATION, 0, action.ASTONISH != 0 ? action.ASTONISH : action.ACCURACY));
						}
						else
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
					}
					else if (MOVE_NAME == "Cosmic Power")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_DEF, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_SPDEF, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Grass Whistle" || MOVE_NAME == "Lovely Kiss" || MOVE_NAME == "Spore")
					{
						if (TARGET.ABILITY == "Insomnia" || TARGET.ABILITY == "Vital Spirit")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.STATUS_SLEEP));
					}
					else if (MOVE_NAME == "Rest")
					{
						if (action.OWNER.ABILITY == "Insomnia" || action.OWNER.ABILITY == "Vital Spirit" || isTeamBattleEffectActive(null, BattleEffect.UPROAR) || action.OWNER.CURRENT_HP == action.OWNER.getStat(PokemonStat.HP))
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, 0, -1 * action.OWNER.getStat(PokemonStat.HP), action.OWNER, action.OWNER, BattleActionResult.MOVE_NORMAL_USE));
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, 20, 0, action.OWNER, TARGET, BattleActionResult.STATUS_SLEEP));
						}
					}
					else if (MOVE_NAME == "Glare")
					{
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.STATUS_PARALYSIS));
					}
					else if (MOVE_NAME == "Poison Gas")
					{
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, TARGET, BattleActionResult.STATUS_POISON));
					}
					else if (MOVE_NAME == "Tickle")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_ATK, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_DEF, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Tail Glow")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_SPATK, 2, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Camouflage")
					{
						var camouflageType:String = "";
						switch (LOCATION)
						{
						case BattleSpecialTile.BUILDING: 
						case BattleSpecialTile.PLAIN: 
							camouflageType = PokemonType.NORMAL;
							break;
						case BattleSpecialTile.SAND: 
							camouflageType = PokemonType.GROUND;
							break;
						case BattleSpecialTile.CAVE: 
						case BattleSpecialTile.ROCK: 
							camouflageType = PokemonType.ROCK;
							break;
						case BattleSpecialTile.TALL_GRASS: 
						case BattleSpecialTile.LONG_GRASS: 
							camouflageType = PokemonType.GRASS;
							break;
						case BattleSpecialTile.POND_WATER: 
						case BattleSpecialTile.SEA_WATER: 
						case BattleSpecialTile.SEAWEED: 
						case BattleSpecialTile.PUDDLE: 
							camouflageType = PokemonType.WATER;
							break;
						}
						if (camouflageType == "")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							action.OWNER.OVERRIDE_TYPE = camouflageType;
					}
					else if (MOVE_NAME == "Magic Coat")
					{
						action.OWNER.activateBattleEffect(BattleEffect.MAGIC_COAT);
					}
					else if (MOVE_NAME == "Snatch")
					{
						var actionSnatched:BattleAction;
						for (i = 0; i < actionQueue.length; i++)
						{
							if (actionQueue[i].TYPE == BattleAction.MOVE && actionQueue[i].OWNER != action.OWNER)
							{
								if (PokemonMoves.getMoveSnatchByID(actionQueue[i].MOVEID))
								{
									actionSnatched = actionQueue[i];
									break;
								}
							}
						}
						if (actionSnatched == null)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.OWNER, actionSnatched.OWNER, BattleActionResult.MOVE_SNATCHED));
						}
					}
					else if (MOVE_NAME == "Calm Mind")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_SPATK, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_SPDEF, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Conversion")
					{
						var type:String = PokemonMoves.getMoveTypeByID(PokemonMoves.getMoveIDByName(TARGET.getRandomMove()));
						action.OWNER.OVERRIDE_TYPE = type;
						//trace(action.OWNER.NAME + " is now a " + type + " type.");
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_TYPE_CHANGED, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Conversion 2")
					{
						var lastHitType:String = PokemonMoves.getMoveTypeByID(action.OWNER.LAST_HIT_BY_MOVE);
						var possibleTypes:Vector.<String> = PokemonEffectiveness.getTypesThatResist(lastHitType);
						for (i = 0; i < possibleTypes.length; i++)
						{
							if (action.OWNER.isType(possibleTypes[i]))
							{
								possibleTypes.splice(i, 1);
							}
						}
						if (possibleTypes.length == 0)
						{
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.MOVE_FAILURE, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						}
						else
						{
							action.OWNER.OVERRIDE_TYPE = possibleTypes[Math.floor(Math.random() * possibleTypes.length)];
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_TYPE_CHANGED, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						}
					}
					else if (MOVE_NAME == "Odor Sleuth" || MOVE_NAME == "Foresight")
					{
						action.OWNER.activateBattleEffect(BattleEffect.ODOR_SLEUTH);
						if (TARGET.getStatStage(PokemonStat.EVASION) > 0)
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_EVASION, -1 * TARGET.getStat(PokemonStat.EVASION), action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Destiny Bond")
					{
						action.OWNER.activateBattleEffect(BattleEffect.DESTINY_BOND);
					}
					else if (MOVE_NAME == "Bulk Up" || MOVE_NAME == "Sharpen")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_ATK, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Harden" || MOVE_NAME == "Withdraw")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_DEF, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Sketch")
					{
						if (PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED) == "Selfdestruct" || PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED) == "Explosion")
						{
							if (doesAPokemonHaveAbility("Damp"))
							{
								// Success
								action.OWNER.switchMoves(action.MOVEID, TARGET.LAST_MOVE_USED, 0, true);
							}
							else
							{
								results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
							}
						}
						else
						{
							if (TARGET.LAST_MOVE_USED == 0 || action.OWNER.getMove(1) == PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED) || action.OWNER.getMove(2) == PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED) || action.OWNER.getMove(3) == PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED) || action.OWNER.getMove(4) == PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED))
							{
								results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
							}
							else
								action.OWNER.switchMoves(action.MOVEID, TARGET.LAST_MOVE_USED, 0, true);
						}
					}
					else if (MOVE_NAME == "Spider Web")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_PARTIAL_TRAP, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Barrier")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_DEF, 2, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Defense Curl")
					{
						action.OWNER.activateBattleEffect(BattleEffect.DEFENSE_CURL);
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_DEF, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Mind Reader")
					{
						action.OWNER.activateBattleEffect(BattleEffect.MIND_READER);
					}
					else if (MOVE_NAME == "Ingrain")
					{
						action.OWNER.activateBattleEffect(BattleEffect.INGRAIN);
					}
					else if (MOVE_NAME == "Lock-On")
					{
						action.OWNER.activateBattleEffect(BattleEffect.LOCK_ON);
					}
					else if (MOVE_NAME == "Light Screen")
					{
						if (areTeamBattleEffectsActive(action.OWNER, BattleEffect.LIGHT_SCREEN1, BattleEffect.LIGHT_SCREEN2, BattleEffect.LIGHT_SCREEN3, BattleEffect.LIGHT_SCREEN4, BattleEffect.LIGHT_SCREEN5))
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							activateTeamBattleEffect(action.OWNER, BattleEffect.LIGHT_SCREEN5);
						}
					}
					else if (MOVE_NAME == "Reflect")
					{
						if (areTeamBattleEffectsActive(action.OWNER, BattleEffect.REFLECT1, BattleEffect.REFLECT2, BattleEffect.REFLECT3, BattleEffect.REFLECT4, BattleEffect.REFLECT5))
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							activateTeamBattleEffect(action.OWNER, BattleEffect.REFLECT5);
						}
					}
					else if (MOVE_NAME == "Protect")
					{
						if (actionQueue.length == 1)
						{
							// We're the last to go, fail!
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							action.OWNER.activateBattleEffect(BattleEffect.PROTECT);
						}
					}
					else if (MOVE_NAME == "Detect")
					{
						if (actionQueue.length == 1)
						{
							// We're the last to go, fail!
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							action.OWNER.activateBattleEffect(BattleEffect.DETECT);
						}
					}
					else if (MOVE_NAME == "Endure")
					{
						action.OWNER.activateBattleEffect(BattleEffect.ENDURE);
					}
					else if (MOVE_NAME == "SmokeScreen")
					{
						if (TARGET.ABILITY == "Keen Eye" || TARGET.ABILITY == "Clear Body" || TARGET.ABILITY == "White Smoke")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_ACCURACY, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Cotton Spore")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_ACCURACY, -2, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Spite")
					{
						if (TARGET.LAST_MOVE_USED == 0)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							var movesToReduce:int = 2;
							if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 75)
								movesToReduce = 5;
							else if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 50)
								movesToReduce = 4;
							else if (action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH >= 25)
								movesToReduce = 3;
							else
								movesToReduce = 2;
							for (i = 0; i < movesToReduce; i++)
							{
								TARGET.reducePP(TARGET.LAST_MOVE_USED);
							}
						}
					}
					else if (MOVE_NAME == "Minimize")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_EVASION, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						action.OWNER.activateBattleEffect(BattleEffect.MINIMIZE);
					}
					else if (MOVE_NAME == "Howl")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_ATK, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_DEF, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Block")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_PARTIAL_TRAP, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Water Sport")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_WATERSPORT, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Mud Sport")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STATUS_MUDSPORT, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Sand-Attack")
					{
						if (areTeamBattleEffectsActive(TARGET, BattleEffect.MIST1, BattleEffect.MIST2, BattleEffect.MIST3, BattleEffect.MIST4, BattleEffect.MIST5))
						{
							// Move failed.
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_ACCURACY, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Tail Whip" || MOVE_NAME == "Leer")
					{
						if (areTeamBattleEffectsActive(TARGET, BattleEffect.MIST1, BattleEffect.MIST2, BattleEffect.MIST3, BattleEffect.MIST4, BattleEffect.MIST5))
						{
							// Move failed.
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_DEF, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Growl")
					{
						if (TARGET.ABILITY == "Hyper Cutter" || TARGET.ABILITY == "Soundproof" || TARGET.ABILITY == "Clear Body" || TARGET.ABILITY == "White Smoke" || areTeamBattleEffectsActive(TARGET, BattleEffect.MIST1, BattleEffect.MIST2, BattleEffect.MIST3, BattleEffect.MIST4, BattleEffect.MIST5))
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_ATK, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						}
					}
					else if (MOVE_NAME == "Sing")
					{
						if (TARGET.ABILITY == "Insomnia" || TARGET.ABILITY == "Vital Spirit" || TARGET.ABILITY == "Soundproof")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, action.TARGET, TARGET, BattleActionResult.STATUS_SLEEP));
						}
					}
					else if (MOVE_NAME == "Supersonic")
					{
						if (TARGET.isStatusConditionActive(PokemonStatusConditions.CONFUSION) || TARGET.ABILITY == "Soundproof" || TARGET.ABILITY == "Own Tempo")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, TARGET, TARGET, BattleActionResult.STATUS_CONFUSION)); // induce confusion
						}
					}
					else if (MOVE_NAME == "Sweet Kiss")
					{
						if (TARGET.ABILITY == "Own Tempo")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, TARGET, TARGET, BattleActionResult.STATUS_CONFUSION)); // induce confusion
					}
					else if (MOVE_NAME == "Teeter Dance")
					{
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, TARGET, TARGET, BattleActionResult.STATUS_CONFUSION)); // induce confusion
					}
					else if (MOVE_NAME == "Confuse Ray")
					{
						if (TARGET.isStatusConditionActive(PokemonStatusConditions.CONFUSION) || TARGET.ABILITY == "Own Tempo")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, TARGET, TARGET, BattleActionResult.STATUS_CONFUSION)); // induce confusion
						}
					}
					else if (MOVE_NAME == "Disable")
					{
						if (TARGET.LAST_MOVE_USED == 0)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							// find which move slot their last used move is in
							var moveSlot:String = "";
							if (TARGET.getMovePP(1) > 0 && TARGET.getMove(1) == PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED))
								moveSlot = BattleActionResult.DISABLE_MOVE1;
							else if (TARGET.getMovePP(2) > 0 && TARGET.getMove(2) == PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED))
								moveSlot = BattleActionResult.DISABLE_MOVE2;
							else if (TARGET.getMovePP(3) > 0 && TARGET.getMove(3) == PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED))
								moveSlot = BattleActionResult.DISABLE_MOVE3;
							else if (TARGET.getMovePP(4) > 0 && TARGET.getMove(4) == PokemonMoves.getMoveNameByID(TARGET.LAST_MOVE_USED))
								moveSlot = BattleActionResult.DISABLE_MOVE4;
							if (moveSlot == "")
								results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
							else
								results.push(BattleActionResult.generateStatusResult(TARGET, moveSlot, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						}
					}
					else if (MOVE_NAME == "Encore")
					{
						if (TARGET.LAST_MOVE_USED == 0)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							TARGET.activateBattleEffect(BattleEffect.ENCORE);
							if (action.ACCURACY >= 80)
								TARGET.activateBattleEffect(BattleEffect.REPEAT_ATTACK6);
							else if (action.ACCURACY >= 60)
								TARGET.activateBattleEffect(BattleEffect.REPEAT_ATTACK5);
							else if (action.ACCURACY >= 40)
								TARGET.activateBattleEffect(BattleEffect.REPEAT_ATTACK4);
							else if (action.ACCURACY >= 20)
								TARGET.activateBattleEffect(BattleEffect.REPEAT_ATTACK3);
							else
								TARGET.activateBattleEffect(BattleEffect.REPEAT_ATTACK2);
						}
					}
					else if (MOVE_NAME == "Mist")
					{
						activateTeamBattleEffect(action.OWNER, BattleEffect.MIST5);
					}
					else if (MOVE_NAME == "Leech Seed")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_LEECH_SEED, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Toxic")
					{
						TARGET.resetNDamageNumber();
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_TOXIC, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Growth")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_SPATK, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "PoisonPowder")
					{
						if (TARGET.isType(PokemonType.POISON) || TARGET..isType(PokemonType.STEEL) || TARGET.ABILITY == "Immunity")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_POISON, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						}
					}
					else if (MOVE_NAME == "Stun Spore")
					{
						if (TARGET.ABILITY == "Limber")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_PARALYSIS, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						}
					}
					else if (MOVE_NAME == "Sleep Powder")
					{
						if (TARGET.ABILITY == "Insomnia" || TARGET.ABILITY == "Vital Spirit")
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, TARGET, TARGET, BattleActionResult.STATUS_SLEEP));
						}
					}
					else if (MOVE_NAME == "String Shot")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_SPEED, -1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Thunder Wave")
					{
						if (TARGET..isType(PokemonType.GROUND))
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STATUS_PARALYSIS, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						}
					}
					else if (MOVE_NAME == "Hypnosis")
					{
						if (TARGET.getNonVolatileStatusCondition() != null)
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, TARGET, TARGET, BattleActionResult.STATUS_SLEEP));
						}
					}
					else if (MOVE_NAME == "Meditate")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_ATK, 1, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Feather Dance")
					{
						results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.STAT_ATK, -2, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Agility")
					{
						results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.STAT_SPEED, 2, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
					}
					else if (MOVE_NAME == "Teleport")
					{
						if (TYPE != BattleType.WILD || (TYPE == BattleType.WILD && doesAnOpponentHaveAbility(action.OWNER, "Shadow Tag", "Arena Trap")) || (TYPE == BattleType.WILD && action.OWNER.HELDITEM != "Smoke Ball" && action.OWNER.isStatusConditionActive(PokemonStatusConditions.PARTIALLYTRAPPED)))
						{
							// move failed
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else
						{
							// flee the battle
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.POKEMON_FLED, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
							results.push(BattleActionResult.generateStatusResult(action.OWNER, BattleActionResult.FINISH_BATTLE, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						}
					}
					else if (MOVE_NAME == "Whirlwind" || MOVE_NAME == "Roar")
					{
						var status:String = MOVE_NAME == "Roar" ? BattleActionResult.POKEMON_FLED : BattleActionResult.POKEMON_BLOWN_AWAY;
						if ((MOVE_NAME == "Roar" && TARGET.ABILITY == "Soundproof") || TARGET.ABILITY == "Suction Cups" || TARGET.isBattleEffectActive(BattleEffect.INGRAIN))
						{
							results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_FAILURE));
						}
						else if (TYPE == BattleType.WILD && isPokemonAnAlly(action.OWNER))
						{
							// We blow the wild pokemon away!
							results.push(BattleActionResult.generateStatusResult(TARGET, status, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
							results.push(BattleActionResult.generateStatusResult(TARGET, BattleActionResult.SWITCH, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
						}
						else
						{
							results.push(BattleActionResult.generateStatusResult(TARGET, status, 0, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH));
							var replacementSelected:Pokemon;
							if (isPokemonAnAlly(TARGET))
							{
								for (i = 0; i < allyPokemon.length; i++)
								{
									if (allyPokemon[i].ACTIVE == false && allyPokemon[i].getNonVolatileStatusCondition() != PokemonStatusConditions.FAINT)
									{
										replacementSelected = allyPokemon[i];
									}
								}
							}
							else
							{
								for (i = 0; i < enemyPokemon.length; i++)
								{
									if (enemyPokemon[i].ACTIVE == false && enemyPokemon[i].getNonVolatileStatusCondition() != PokemonStatusConditions.FAINT)
									{
										replacementSelected = enemyPokemon[i];
									}
								}
							}
							// SWITCHMARKER
							results.push(BattleActionResult.generateMoveResult(0, 0, 0, replacementSelected, TARGET, BattleActionResult.POKEMON_DRAGGED_OUT));
							results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, 0, TARGET, replacementSelected, BattleActionResult.SWITCH));
						}
					}
				}
				else if (!HITS)
				{
					results.push(BattleActionResult.generateFailureResult(action.MOVEID, action.OWNER, BattleActionResult.MOVE_MISSED));
					if (MOVE_NAME == "Hi Jump Kick" || MOVE_NAME == "Jump Kick")
					{
						tempResults = PokemonStat.calculateDamage(action.OWNER, TARGET, action.MOVEID, action, this);
						var frac:Number = MOVE_NAME == "Hi Jump Kick" ? 0.5 : 0.0625;
						results.push(BattleActionResult.generateMoveResult(action.MOVEID, action.ACCURACY != 0 ? action.ACCURACY : action.ASTONISH, tempResults[0].DAMAGE * frac, action.OWNER, action.OWNER, BattleActionResult.MOVE_RECOIL));
					}
				}
				
				return results;
			}
			
			return results;
		}
		
		public function doesAPokemonHaveAbility(abilityName:String):Boolean
		{
			var i:uint = 0;
			for (i = 0; i < allyPokemon.length; i++)
			{
				if (allyPokemon[i].ACTIVE && allyPokemon[i].ABILITY == abilityName)
					return true;
			}
			for (i = 0; i < enemyPokemon.length; i++)
			{
				if (enemyPokemon[i].ACTIVE && enemyPokemon[i].ABILITY == abilityName)
					return true;
			}
			
			return false;
		}
		
		public function doesAnOpponentHaveAbility(pokemonRef:Pokemon, ... args):Boolean
		{
			var i:int;
			var j:int;
			if (isPokemonAnAlly(pokemonRef))
			{
				for (i = 0; i < enemyPokemon.length; i++)
				{
					for (j = 0; j < args.length; j++)
					{
						if (enemyPokemon[i].ABILITY == args[j])
							return true;
					}
				}
			}
			else
			{
				for (i = 0; i < allyPokemon.length; i++)
				{
					for (j = 0; j < args.length; j++)
					{
						if (allyPokemon[i].ABILITY == args[j])
							return true;
					}
				}
			}
			
			return false;
		}
		
		public function areTeamBattleEffectsActive(pokemon:Pokemon, ... args):Boolean
		{
			for (var i:int = 0; i < args.length; i++)
			{
				if (isTeamBattleEffectActive(pokemon, args[i]))
					return true;
			}
			
			return false;
		}
		
		public function isTeamBattleEffectMISTActive(pokemon:Pokemon):Boolean
		{
			return areTeamBattleEffectsActive(pokemon, BattleEffect.MIST1, BattleEffect.MIST2, BattleEffect.MIST3, BattleEffect.MIST4, BattleEffect.MIST5);
		}
		
		private function traceQueue():void
		{
			trace("Dumping ActionQueue (" + actionQueue.length + "):");
			for (var i:uint = 0; i < actionQueue.length; i++)
			{
				trace((i + 1) + ": " + actionQueue[i].TYPE + ", owned by " + actionQueue[i].OWNER.NAME + ", Move " + PokemonMoves.getMoveNameByID(actionQueue[i].MOVEID) + ", with Speed " + calculateSpeed(actionQueue[i].OWNER));
			}
			trace("Finished dump.");
		}
		
		public function clearQueue():void
		{
			actionQueue.splice(0, actionQueue.length);
		}
		
		private function sortActionsQuick(itemA:BattleAction, itemB:BattleAction):Number
		{
			var itemAPriority:int = getBattleActionPriority(itemA);
			var itemBPriority:int = getBattleActionPriority(itemB);
			if (itemAPriority > itemBPriority)
				return -1;
			else if (itemAPriority < itemBPriority)
				return 1;
			else
				return 0;
		}
		
		private function getBattleActionPriority(battleAction:BattleAction):int
		{
			var priority:int = 0;
			if (battleAction.TYPE == BattleAction.MOVE)
				priority = PokemonMoves.getMovePriorityByID(battleAction.MOVEID);
			else if (battleAction.TYPE == BattleAction.SWITCH || battleAction.TYPE == BattleAction.ITEM || battleAction.TYPE == BattleAction.RUN)
				priority = 6;
			else if (battleAction.TYPE == BattleAction.FLEE)
				priority = 0;
			return priority;
		}
		
		private function sortActions(itemA:BattleAction, itemB:BattleAction):Number
		{
			// -1 if A is before B
			// 1 if B is before A
			// 0 if same
			var itemAonAllyList:Boolean = isPokemonAnAlly(itemA.OWNER);
			var itemBonAllyList:Boolean = isPokemonAnAlly(itemB.OWNER);
			
			// Pursuit *************************
			if (itemA.TYPE == BattleAction.MOVE && itemA.MOVEID == PokemonMoves.getMoveIDByName("Pursuit"))
			{
				// itemA is using Pursuit, check if an enemy on the other team is using switch
				if (itemAonAllyList != itemBonAllyList)
				{
					// they are on opposite teams!
					if (itemB.TYPE == BattleAction.SWITCH)
						return -1;
					else
						return 0;
				}
			}
			if (itemB.TYPE == BattleAction.MOVE && itemB.MOVEID == PokemonMoves.getMoveIDByName("Pursuit"))
			{
				// itemB is using Pursuit, check if an enemy on the other team is using switch
				if (itemAonAllyList != itemBonAllyList)
				{
					// they are on opposite teams!
					if (itemA.TYPE == BattleAction.SWITCH)
						return 1;
					else
						return 0;
				}
			}
			
			if (itemA.TYPE == BattleAction.MOVE && itemB.TYPE == BattleAction.MOVE)
			{
				var priorityA:int = PokemonMoves.getMovePriorityByID(itemA.MOVEID);
				var priorityB:int = PokemonMoves.getMovePriorityByID(itemB.MOVEID);
				
				if (priorityA == priorityB)
				{
					// Both moves have the same priority
					if (itemA.QUICKCLAW && itemB.QUICKCLAW == false)
						return -1;
					else if (itemA.QUICKCLAW == false && itemB.QUICKCLAW)
						return 1;
					// either both have or both do not have quickclaw
					
					if (itemA.OWNER.ABILITY == "Stall" && itemB.OWNER.ABILITY != "Stall")
						return 1;
					else if (itemA.OWNER.ABILITY != "Stall" && itemB.OWNER.ABILITY == "Stall")
						return -1;
					// either both have or both do not have Stall
					
					//trace("Checking move by speed. " + itemA.OWNER.NAME + ": " + calculateSpeed(itemA.OWNER) + ", " + itemB.OWNER.NAME + ": " + calculateSpeed(itemB.OWNER));
					if (calculateSpeed(itemA.OWNER) > calculateSpeed(itemB.OWNER))
						return -1;
					else if (calculateSpeed(itemA.OWNER) < calculateSpeed(itemB.OWNER))
						return 1;
					
					// both have the same speed, go by Pokémon IDs
					if (itemA.OWNER.base.ID > itemB.OWNER.base.ID)
						return -1;
					else if (itemA.OWNER.base.ID < itemB.OWNER.base.ID)
						return 1;
					
					return 0;
				} else
				if (priorityA > priorityB) return -1;
				else return 1;
			}
			
			return 0;
		}
		
		private function calculateSpeed(owner:Pokemon):int
		{
			var speed:Number = owner.SPEED * PokemonStat.getStatStageMultiplier(owner.getStatStage(PokemonStat.SPEED));
			// Remember to put in Wattson's Dynamo badge (multiply by 1.1)
			
			if (owner.getNonVolatileStatusCondition() == PokemonStatusConditions.PARALYSIS && owner.ABILITY != "Quick Feet")
				speed *= 1 / 4;
			if (owner.HELDITEM == "Choice Scarf")
				speed *= 1.5;
			if (owner.HELDITEM == "Iron Ball" || owner.HELDITEM == "Macho Brace" || owner.HELDITEM == "Power Bracer" || owner.HELDITEM == "Power Belt" || owner.HELDITEM == "Power Lens" || owner.HELDITEM == "Power Band" || owner.HELDITEM == "Power Anklet" || owner.HELDITEM == "Power Weight")
				speed *= 1 / 2;
			
			var j:int = 0;
			if (isPokemonAnAlly(owner))
			{
				if (isTeamBattleEffectActive(owner, BattleEffect.TAILWIND))
					speed *= 2;
			}
			else
			{
				if (isTeamBattleEffectActive(owner, BattleEffect.TAILWIND))
					speed *= 2;
			}
			
			if (owner.base.name == "Ditto" && owner.HELDITEM == "Quick Powder")
				speed *= 2;
			if (owner.ABILITY == "Swift Swim" && WEATHER == BattleWeatherEffect.RAIN)
				speed *= 2;
			if (owner.ABILITY == "Chlorophyll" && WEATHER == BattleWeatherEffect.INTENSE_SUNLIGHT)
				speed *= 2;
			if (owner.ABILITY == "Sand Rush" && WEATHER == BattleWeatherEffect.SANDSTORM)
				speed *= 2;
			if (owner.ABILITY == "Unburden" && owner.LOST_ITEM)
				speed *= 2;
			if (owner.ABILITY == "Quick Feet" && owner.getNonVolatileStatusCondition() != null)
				speed *= 1.5;
			if (owner.ABILITY == "Slow Start" && owner.TURNS_ACTIVE <= 5)
				speed *= 1 / 2;
			
			return Math.round(speed);
		}
	}

}