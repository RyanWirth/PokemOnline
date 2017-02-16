package com.cloakentertainment.pokemonline.stats
{
	import com.cloakentertainment.pokemonline.battle.Battle;
	import com.cloakentertainment.pokemonline.battle.BattleAction;
	import com.cloakentertainment.pokemonline.battle.BattleActionResult;
	import com.cloakentertainment.pokemonline.battle.BattleEffect;
	import com.cloakentertainment.pokemonline.battle.BattleWeatherEffect;
	import com.cloakentertainment.pokemonline.trainer.TrainerBadge;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonStat
	{
		public static const HP:String = "hp";
		public static const ATK:String = "atk";
		public static const DEF:String = "def";
		public static const SPATK:String = "spatk";
		public static const SPDEF:String = "spdef";
		public static const SPEED:String = "speed";
		public static const EVASION:String = "evasion";
		public static const ACCURACY:String = "accuracy";
		
		public static const NONE:String = "none";
		
		public function PokemonStat()
		{
		
		}
		
		public static function convertLocalizedTextToConstant(statText:String):String
		{
			statText = statText.toLowerCase();
			if (statText == "speed") return SPEED;
			else if (statText == "attack") return ATK;
			else if (statText == "defense") return DEF;
			else if (statText == "sp. atk.") return SPATK;
			else if (statText == "sp. def.") return SPDEF;
			else if (statText == "evasion") return EVASION;
			else if (statText == "accuracy") return ACCURACY;
			else return NONE;
		}
		
		public static function calculateStat(statType:String, baseStat:int, ivStat:int, evStat:int, level:int, nature:String):int
		{
			if (statType == PokemonStat.HP)
			{
				return ((ivStat + (2 * baseStat) + evStat / 4 + 100) * level) / 100 + 10;
			}
			
			var natureMultiplier:Number = PokemonNature.getIncreasedStat(nature) == statType ? 1.1 : 1.0;
			natureMultiplier = PokemonNature.getDecreasedStat(nature) == statType ? 0.9 : natureMultiplier;
			
			return (((ivStat + (2 * baseStat) + evStat / 4) * level) / 100 + 5) * natureMultiplier;
		}
		
		public static function getStatStageMultiplier(stage:int):Number
		{
			if (stage <= -6)
				return 2 / 8;
			if (stage == -5)
				return 2 / 7;
			if (stage == -4)
				return 2 / 6;
			if (stage == -3)
				return 2 / 5;
			if (stage == -2)
				return 2 / 4;
			if (stage == -1)
				return 2 / 3;
			if (stage == 0)
				return 2 / 2;
			if (stage == 1)
				return 3 / 2;
			if (stage == 2)
				return 4 / 2;
			if (stage == 3)
				return 5 / 2;
			if (stage == 4)
				return 6 / 2;
			if (stage == 5)
				return 7 / 2;
			if (stage >= 6)
				return 8 / 2;
			return 1;
		}
		
		public static function calculateDamage(attacker:Pokemon, victim:Pokemon, moveID:int, action:BattleAction, battle:Battle, overridePower:int = 0):Vector.<BattleActionResult>
		{
			var results:Vector.<BattleActionResult> = new Vector.<BattleActionResult>();
			var result:BattleActionResult = new BattleActionResult();
			result.TYPE = BattleActionResult.MOVE_NORMAL_USE;
			result.USER = attacker;
			result.VICTIM = victim;
			result.CUTE_CHARM = action.ASTONISH;
			result.MOVE_ID = moveID;
			results.push(result);
			
			var power:int = PokemonMoves.getMovePowerByID(moveID);
			if (overridePower != 0) power = overridePower;
			var moveType:String = PokemonMoves.getMoveTypeByID(moveID);
			var MOVE_NAME:String = PokemonMoves.getMoveNameByID(moveID);
			var i:uint = 0;
			var j:uint = 0;
			var presentEffect:Boolean = false;
			var attackerAnAlly:Boolean = false;
			for (i = 0; i < battle.allyPokemon.length; i++)
			{
				if (battle.allyPokemon[i] == attacker)
					attackerAnAlly = true;
			}
			var victimAnAlly:Boolean = false;
			for (i = 0; i < battle.allyPokemon.length; i++)
			{
				if (battle.allyPokemon[i] == victim)
					victimAnAlly = true;
			}
			
			if (MOVE_NAME == "Beat Up")
			{
				moveType = ""; // Beat up type is typeless
			} else
			if (MOVE_NAME == "Super Fang")
			{
				result.DAMAGE = 0.5 * victim.CURRENT_HP;
				if (result.DAMAGE <= 1)
					result.DAMAGE = 1;
				if (victim.isType(PokemonType.GHOST) && attacker.isBattleEffectActive(BattleEffect.ODOR_SLEUTH) == false)
				{
					result.DAMAGE = 0;
					result.TYPE = BattleActionResult.MOVE_NO_EFFECT;
				}
				return results;
			}
			else if (MOVE_NAME == "Return")
			{
				power = attacker.FRIENDSHIP / 2.5;
				if (power <= 0)
					power = 1;
			}
			else if (MOVE_NAME == "Spit Up")
			{
				if (attacker.isBattleEffectActive(BattleEffect.ONE_STOCKPILE))
					power = 100;
				else if (attacker.isBattleEffectActive(BattleEffect.TWO_STOCKPILE))
					power = 200;
				else if (attacker.isBattleEffectActive(BattleEffect.THREE_STOCKPILE))
					power = 300;
			}
			else if (MOVE_NAME == "Frustration")
			{
				power = (255 - attacker.FRIENDSHIP) / 2.5;
				if (power <= 0)
					power = 1;
			}
			else if (MOVE_NAME == "Present")
			{
				// use astonish's random number
				if (action.ASTONISH >= 60)
					power = 40;
				else if (action.ASTONISH >= 30)
					power = 80;
				else if (action.ASTONISH >= 20)
					power = 120;
				else
					presentEffect = true;
			}
			else if (MOVE_NAME == "Fury Cutter")
			{
				if (attacker.LAST_MOVE_USED == moveID)
					power *= Math.pow(2, attacker.N_DAMAGE_NUMBER > 5 ? 5 : attacker.N_DAMAGE_NUMBER);
			}
			else if (MOVE_NAME == "Water Spout" || MOVE_NAME == "Eruption")
			{
				power = 150 * (attacker.CURRENT_HP / attacker.getStat(PokemonStat.HP));
			}
			else if (MOVE_NAME == "Pursuit")
			{
				if (attackerAnAlly)
				{
					for (i = 0; i < battle.enemyPokemon.length; i++)
					{
						// look for this enemy pokemon on the actionqueue
						for (j = 0; j < battle.actionQueue.length; j++)
						{
							if (battle.actionQueue[j].TYPE == BattleAction.SWITCH && battle.actionQueue[j].OWNER == battle.enemyPokemon[i])
							{
								// Pursuit is taking place before an enemy can switch out, up its base power to 80
								power = 80;
							}
						}
					}
				}
				else
				{
					for (i = 0; i < battle.allyPokemon.length; i++)
					{
						// look for this enemy pokemon on the actionqueue
						for (j = 0; j < battle.actionQueue.length; j++)
						{
							if (battle.actionQueue[j].TYPE == BattleAction.SWITCH && battle.actionQueue[j].OWNER == battle.allyPokemon[i])
							{
								// Pursuit is taking place before an enemy can switch out, up its base power to 80
								power = 80;
							}
						}
					}
				}
			}
			else if (MOVE_NAME == "Weather Ball")
			{
				if (battle.WEATHER != BattleWeatherEffect.CLEAR_SKIES)
					power = 100;
				if (battle.WEATHER == BattleWeatherEffect.INTENSE_SUNLIGHT)
					moveType = PokemonType.FIRE;
				if (battle.WEATHER == BattleWeatherEffect.RAIN)
					moveType = PokemonType.WATER;
				if (battle.WEATHER == BattleWeatherEffect.HAIL)
					moveType = PokemonType.ICE;
				if (battle.WEATHER == BattleWeatherEffect.SANDSTORM)
					moveType = PokemonType.ROCK;
			}
			else if (MOVE_NAME == "Revenge")
			{
				if (attacker.isBattleEffectActive(BattleEffect.TOOK_DAMAGE_SAME_TURN))
				{
					power = 120;
				}
			}
			else if (MOVE_NAME == "SmellingSalt")
			{
				if (victim.getNonVolatileStatusCondition() == PokemonStatusConditions.PARALYSIS)
				{
					power = 120;
				}
			}
			else if (MOVE_NAME == "Stomp")
			{
				if (victim.isBattleEffectActive(BattleEffect.MINIMIZE))
					power = 130;
			}
			else if (MOVE_NAME == "Facade")
			{
				switch (attacker.getNonVolatileStatusCondition())
				{
					case PokemonStatusConditions.BURN: 
					case PokemonStatusConditions.POISON: 
					case PokemonStatusConditions.BADLYPOISONED: 
					case PokemonStatusConditions.PARALYSIS: 
						power = 140;
						break;
				}
			}
			else if (MOVE_NAME == "Hidden Power")
			{
				var hiddenPowerType:int = ((leastSignificantBit(attacker.getIV(PokemonStat.HP)) + 2 * leastSignificantBit(attacker.getIV(PokemonStat.ATK)) + 4 * leastSignificantBit(attacker.getIV(PokemonStat.DEF)) + 8 * leastSignificantBit(attacker.getIV(PokemonStat.SPEED)) + 16 * leastSignificantBit(attacker.getIV(PokemonStat.SPATK)) + 32 * leastSignificantBit(attacker.getIV(PokemonStat.SPDEF))) * 15) / 63;
				moveType = PokemonUtilities.getHiddenPowerType(hiddenPowerType);
				
				power = ((secondLeastSignificantBit(attacker.getIV(PokemonStat.HP)) + 2 * secondLeastSignificantBit(attacker.getIV(PokemonStat.ATK)) + 4 * secondLeastSignificantBit(attacker.getIV(PokemonStat.DEF)) + 8 * secondLeastSignificantBit(attacker.getIV(PokemonStat.SPEED)) + 16 * secondLeastSignificantBit(attacker.getIV(PokemonStat.SPATK)) + 32 * secondLeastSignificantBit(attacker.getIV(PokemonStat.SPDEF))) * 40) / 63 + 30;
			}
			else if (MOVE_NAME == "Rollout" || MOVE_NAME == "Ice Ball" || MOVE_NAME == "Rollout")
			{
				if (attacker.LAST_MOVE_USED == moveID)
				{
					if (attacker.RAGE_COUNTER > 5 && MOVE_NAME == "Rollout") attacker.changeRageCounter(0);
					power *= Math.pow(2, attacker.RAGE_COUNTER);
				}
				if (attacker.isBattleEffectActive(BattleEffect.DEFENSE_CURL))
					power *= 2;
			}
			else if (MOVE_NAME == "Reversal" || MOVE_NAME == "Flail")
			{
				var healthPercent:Number = attacker.CURRENT_HP / attacker.getStat(PokemonStat.HP);
				if (healthPercent >= 0.71)
					power = 20;
				else if (healthPercent >= 0.36)
					power = 40;
				else if (healthPercent >= 0.21)
					power = 80;
				else if (healthPercent >= 0.11)
					power = 100;
				else if (healthPercent >= 0.05)
					power = 150;
				else
					power = 200;
			}
			else if (MOVE_NAME == "Magnitude")
			{
				if (action.MAGNITUDE == 4)
					power = 10;
				else if (action.MAGNITUDE == 5)
					power = 30;
				else if (action.MAGNITUDE == 6)
					power = 50;
				else if (action.MAGNITUDE == 7)
					power = 70;
				else if (action.MAGNITUDE == 8)
					power = 90;
				else if (action.MAGNITUDE == 9)
					power = 110;
				else if (action.MAGNITUDE == 10)
					power = 150;
			}
			else if (MOVE_NAME == "Fissure" || MOVE_NAME == "Guillotine" || MOVE_NAME == "Horn Drill" || MOVE_NAME == "Sheer Cold")
			{
				result.DAMAGE = victim.CURRENT_HP;
				return results;
			}
			else if (MOVE_NAME == "Endeavor")
			{
				result.DAMAGE = victim.CURRENT_HP - action.OWNER.CURRENT_HP;
				return results;
			}
			else if (MOVE_NAME == "Mirror Coat")
			{
				if (victim.isType(PokemonType.DARK))
				{
					result.DAMAGE = 0;
					result.TYPE = BattleActionResult.MOVE_NO_EFFECT;
				}
				else
				{
					if (attacker.LAST_TAKEN_DAMAGE > 0 && PokemonMoves.getMoveCategoryByID(attacker.LAST_HIT_BY_MOVE) == "Special")
					{
						result.DAMAGE = 2 * attacker.LAST_TAKEN_DAMAGE;
					}
					else
					{
						result.DAMAGE = 0;
						result.TYPE = BattleActionResult.MOVE_FAILURE;
					}
				}
				return results;
			}
			else if (MOVE_NAME == "Dragon Rage")
			{
				var type:Number = PokemonEffectiveness.getTypeEffectiveness(PokemonType.DRAGON, victim);
				if (type == PokemonEffectiveness.ZERO)
				{
					result.DAMAGE = 0;
					result.TYPE = BattleActionResult.MOVE_NO_EFFECT;
					return results;
				}
				result.DAMAGE = 40;
				return results;
			}
			else if (MOVE_NAME == "Psywave")
			{
				var x:int = action.ASTONISH <= 50 ? 0 : 1;
				if (victim.isType(PokemonType.DARK))
				{
					result.DAMAGE = 0;
					result.TYPE = BattleActionResult.MOVE_NO_EFFECT;
					return results;
				}
				else
				{
					result.DAMAGE = (x + 0.5) * attacker.LEVEL;
					if (result.DAMAGE < 1)
						result.DAMAGE = 1;
					return results;
				}
			}
			else if (MOVE_NAME == "Low Kick")
			{
				var weight:Number = victim.base.WEIGHT_IN_POUNDS;
				if (weight <= 21.8)
					power = 20;
				else if (weight <= 54.9)
					power = 40;
				else if (weight <= 110.0)
					power = 60;
				else if (weight <= 220.2)
					power = 80;
				else if (weight <= 440.7)
					power = 100;
				else
					power = 120;
			}
			else if (MOVE_NAME == "Night Shade")
			{
				result.DAMAGE = attacker.LEVEL;
				return results;
			}
			
			if (attacker.ABILITY == "Normalize")
			{
				if (MOVE_NAME != "Hidden Power" && MOVE_NAME != "Weather Ball" && MOVE_NAME != "Natural Gift" && MOVE_NAME != "Judgment" && MOVE_NAME != "Techno Blast")
				{
					moveType = PokemonType.NORMAL;
				}
			}
			
			if (victim.areBattleEffectsActive(BattleEffect.BOUNCE)) power *= 2;
			
			// Perform Damage Calculation
			var ATTACK_STAT:int = attacker.getStat(PokemonStat.ATK);
			var SPECIAL_ATTACK_STAT:int = attacker.getStat(PokemonStat.SPATK);
			var SPECIAL_DEFENSE_STAT:int = victim.getStat(PokemonStat.SPDEF);
			var DEFENSE_STAT:int = victim.getStat(PokemonStat.DEF);
			if (attacker.ABILITY == "Pure Power" || attacker.ABILITY == "Huge Power")
				ATTACK_STAT *= 2;
			if (!attacker.isWild && attacker.TRAINER.hasBadge(TrainerBadge.STONE))
				ATTACK_STAT *= 1.1;
			if (!victim.isWild && victim.TRAINER.hasBadge(TrainerBadge.BALANCE))
				DEFENSE_STAT *= 1.1;
			if (!attacker.isWild && attacker.TRAINER.hasBadge(TrainerBadge.MIND))
				SPECIAL_ATTACK_STAT *= 1.1;
			if (!victim.isWild && victim.TRAINER.hasBadge(TrainerBadge.MIND))
				SPECIAL_DEFENSE_STAT *= 1.1;
			if (attacker.HELDITEM == "Silk Scarf" && moveType == PokemonType.NORMAL)
				ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Black Belt" && moveType == PokemonType.FIGHTING)
				ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Sharp Beak" && moveType == PokemonType.FLYING)
				ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Poison Barb" && moveType == PokemonType.POISON)
				ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Soft Sand" && moveType == PokemonType.GROUND)
				ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Hard Stone" && moveType == PokemonType.ROCK)
				ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Silverpowder" && moveType == PokemonType.BUG)
				ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Spell Tag" && moveType == PokemonType.GHOST)
				ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Metal Coat" && moveType == PokemonType.STEEL)
				ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Charcoal" && moveType == PokemonType.FIRE)
				SPECIAL_ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Mystic Water" && moveType == PokemonType.WATER)
				SPECIAL_ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Miracle Seed" && moveType == PokemonType.GRASS)
				SPECIAL_ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Magnet" && moveType == PokemonType.ELECTRIC)
				SPECIAL_ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "TwistedSpoon" && moveType == PokemonType.PSYCHIC)
				SPECIAL_ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "NeverMeltIce" && moveType == PokemonType.ICE)
				SPECIAL_ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Dragon Fang" && moveType == PokemonType.DRAGON)
				SPECIAL_ATTACK_STAT *= 1.1;
			if (attacker.HELDITEM == "Blackglasses" && moveType == PokemonType.DARK)
				SPECIAL_ATTACK_STAT *= 1.1;
			
			if (attacker.HELDITEM == "Sea Incense" && moveType == PokemonType.WATER)
				SPECIAL_ATTACK_STAT *= 1.05;
			if (attacker.HELDITEM == "Choice Band")
				ATTACK_STAT *= 1.5;
			if (attacker.base.name == "Latios" || attacker.base.name == "Latias")
			{
				if (attacker.HELDITEM == "Soul Dew")
					SPECIAL_ATTACK_STAT *= 1.5;
			}
			if (victim.base.name == "Latios" || victim.base.name == "Latias")
			{
				if (victim.HELDITEM == "Soul Dew")
					SPECIAL_DEFENSE_STAT *= 1.5;
			}
			if (attacker.base.name == "Clamperl" && attacker.HELDITEM == "Deepseatooth")
				SPECIAL_ATTACK_STAT *= 2;
			if (victim.base.name == "Clamperl" && victim.HELDITEM == "Deepseascale")
				SPECIAL_DEFENSE_STAT *= 2;
			if (attacker.base.name == "Pikachu" && attacker.HELDITEM == "Light Ball")
				SPECIAL_ATTACK_STAT *= 2;
			if (victim.base.name == "Ditto" && victim.HELDITEM == "Metal Powder")
				DEFENSE_STAT *= 2;
			if (attacker.base.name == "Cubone" || attacker.base.name == "Marowak")
			{
				if (attacker.HELDITEM == "Thick Club")
					ATTACK_STAT *= 2;
			}
			if (victim.ABILITY == "Thick Fat")
			{
				if (moveType == PokemonType.FIRE || moveType == PokemonType.ICE)
					SPECIAL_ATTACK_STAT *= 0.5;
			}
			if (attacker.ABILITY == "Hustle")
				ATTACK_STAT *= 1.5;
			if (attacker.ABILITY == "Plus")
			{
				for (i = 0; i < battle.allyPokemon.length; i++)
				{
					if (battle.allyPokemon[i].ABILITY == "Minus")
						SPECIAL_ATTACK_STAT *= 1.5;
				}
				for (i = 0; i < battle.enemyPokemon.length; i++)
				{
					if (battle.enemyPokemon[i].ABILITY == "Minus")
						SPECIAL_ATTACK_STAT *= 1.5;
				}
			}
			if (attacker.ABILITY == "Minus")
			{
				for (i = 0; i < battle.allyPokemon.length; i++)
				{
					if (battle.allyPokemon[i].ABILITY == "Plus")
						SPECIAL_ATTACK_STAT *= 1.5;
				}
				for (i = 0; i < battle.enemyPokemon.length; i++)
				{
					if (battle.enemyPokemon[i].ABILITY == "Plus")
						SPECIAL_ATTACK_STAT *= 1.5;
				}
			}
			if (attacker.ABILITY == "Guts" && attacker.getNonVolatileStatusCondition() != null)
				ATTACK_STAT *= 1.5;
			if (victim.ABILITY == "Marvel Scale" && victim.getNonVolatileStatusCondition() != null)
				DEFENSE_STAT *= 1.5;
			if (moveType == PokemonType.ELECTRIC && battle.isTeamBattleEffectActive(attacker, BattleEffect.MUD_SPORT))
				power *= 0.5;
			if (moveType == PokemonType.FIRE && battle.isTeamBattleEffectActive(attacker, BattleEffect.WATER_SPORT))
				power *= 0.5;
			if (attacker.ABILITY == "Overgrow" && moveType == PokemonType.GRASS && attacker.CURRENT_HP / attacker.getStat(PokemonStat.HP) <= 0.3)
				power *= 1.5;
			if (attacker.ABILITY == "Blaze" && moveType == PokemonType.FIRE && attacker.CURRENT_HP / attacker.getStat(PokemonStat.HP) <= 0.3)
				power *= 1.5;
			if (attacker.ABILITY == "Torrent" && moveType == PokemonType.WATER && attacker.CURRENT_HP / attacker.getStat(PokemonStat.HP) <= 0.3)
				power *= 1.5;
			if (attacker.ABILITY == "Swarm" && moveType == PokemonType.BUG && attacker.CURRENT_HP / attacker.getStat(PokemonStat.HP) <= 0.3)
				power *= 1.5;
			if (MOVE_NAME == "Self-Destruct" || MOVE_NAME == "Explosion")
				DEFENSE_STAT *= 0.5;
			if (MOVE_NAME == "Surf" && PokemonMoves.getMoveNameByID(victim.GOING_TO_USE_MOVE) == "Dive") power *= 2;
			
			
			var CRITICAL_HIT:Boolean = false;
			var C:int = 0;
			if (attacker.isBattleEffectActive(BattleEffect.FOCUS_ENERGY_STATUS))
				C += 2;
			if (attacker.isBattleEffectActive(BattleEffect.LANSAT_BERRY))
				C += 2;
			if (attacker.isBattleEffectActive(BattleEffect.DIRE_HIT))
				C += 1;
			switch (MOVE_NAME)
			{
				case "Aeroblast": 
				case "Air Cutter": 
				case "Blaze Kick": 
				case "Crabhammer": 
				case "Cross Chop": 
				case "Karate Chop": 
				case "Leaf Blade": 
				case "Poison Tail": 
				case "Razor Leaf": 
				case "Razor Wind": 
				case "Sky Attack": 
				case "Slash": 
					C += 2;
					break;
			}
			if (attacker.HELDITEM == "Razor Claw" || attacker.HELDITEM == "Scope Lens")
				C += 1;
			if (attacker.base.name == "Farfetch'd" && attacker.HELDITEM == "Stick")
				C += 2;
			if (attacker.base.name == "Chansey" && attacker.HELDITEM == "Lucky Punch")
				C += 2;
			if (C == 0)
				C = 6;
			else if (C == 1)
				C = 13;
			else if (C == 2)
				C = 25;
			else if (C == 3)
				C = 33;
			else if (C >= 4)
				C = 50;
			if (action.CRITICAL_HIT <= C)
				CRITICAL_HIT = true;
			
			var atkStage:int = attacker.getStatStage(PokemonStat.ATK);
			var spatkStage:int = attacker.getStatStage(PokemonStat.SPATK);
			var defStage:int = victim.getStatStage(PokemonStat.DEF);
			var spdefStage:int = victim.getStatStage(PokemonStat.SPDEF);
			if (CRITICAL_HIT)
			{
				if (defStage > 0)
					defStage = 0;
				if (spdefStage > 0)
					spdefStage = 0;
				if (atkStage < 0)
					atkStage = 0;
				if (spatkStage < 0)
					spatkStage = 0;
			}
			
			if (MOVE_NAME == "Rage") atkStage += attacker.RAGE_COUNTER;
			
			ATTACK_STAT *= PokemonStat.getStatStageMultiplier(atkStage);
			SPECIAL_ATTACK_STAT *= PokemonStat.getStatStageMultiplier(spatkStage);
			DEFENSE_STAT *= PokemonStat.getStatStageMultiplier(defStage);
			SPECIAL_DEFENSE_STAT *= PokemonStat.getStatStageMultiplier(spdefStage);
			
			switch (moveType)
			{
				case PokemonType.FIRE: 
				case PokemonType.WATER: 
				case PokemonType.ELECTRIC: 
				case PokemonType.GRASS: 
				case PokemonType.ICE: 
				case PokemonType.PSYCHIC: 
				case PokemonType.DRAGON: 
				case PokemonType.DARK: 
					ATTACK_STAT = SPECIAL_ATTACK_STAT;
					DEFENSE_STAT = SPECIAL_DEFENSE_STAT;
					break;
			}
			
			var DAMAGE:int = int(int(int(2 * attacker.LEVEL / 5 + 2) * ATTACK_STAT * power / DEFENSE_STAT) / 50);
			
			if (attacker.getNonVolatileStatusCondition() == PokemonStatusConditions.BURN && attacker.ABILITY != "Guts")
				DAMAGE *= 0.5;
			if (PokemonMoves.getMoveCategoryByID(moveID) == "Special" && battle.areTeamBattleEffectsActive(victim, BattleEffect.LIGHT_SCREEN1, BattleEffect.LIGHT_SCREEN2, BattleEffect.LIGHT_SCREEN3, BattleEffect.LIGHT_SCREEN4, BattleEffect.LIGHT_SCREEN5) && CRITICAL_HIT == false)
			{
				DAMAGE *= 0.5;
			}
			if (PokemonMoves.getMoveCategoryByID(moveID) == "Physical" && battle.areTeamBattleEffectsActive(victim, BattleEffect.REFLECT1, BattleEffect.REFLECT2, BattleEffect.REFLECT3, BattleEffect.REFLECT4, BattleEffect.REFLECT5) && CRITICAL_HIT == false)
			{
				DAMAGE *= 0.5;
			}
			if (victimAnAlly && battle.allyPokemon.length > 1)
			{
				switch (MOVE_NAME)
				{
					case "Heal Block": 
					case "Imprison": 
					case "Spikes": 
					case "Stealth Rock": 
					case "Sticky Web": 
					case "Toxic Spikes": 
						DAMAGE /= battle.allyPokemon.length;
						break;
				}
			}
			else if (victimAnAlly == false && battle.enemyPokemon.length > 1)
			{
				switch (MOVE_NAME)
				{
					case "Heal Block": 
					case "Imprison": 
					case "Spikes": 
					case "Stealth Rock": 
					case "Sticky Web": 
					case "Toxic Spikes": 
						DAMAGE /= battle.enemyPokemon.length;
						break;
				}
			}
			if (battle.doesAPokemonHaveAbility("Cloud Nine") == false && battle.doesAPokemonHaveAbility("Air Lock") == false)
			{
				if (battle.WEATHER == BattleWeatherEffect.INTENSE_SUNLIGHT)
				{
					if (moveType == PokemonType.FIRE)
						DAMAGE *= 1.5;
					else if (moveType == PokemonType.WATER)
						DAMAGE *= 0.5;
				}
				else if (battle.WEATHER == BattleWeatherEffect.RAIN)
				{
					if (moveType == PokemonType.WATER)
						DAMAGE *= 1.5;
					else if (moveType == PokemonType.FIRE)
						DAMAGE *= 0.5;
				}
			}
			var yettoattack:Boolean = false;
			if (attacker.isBattleEffectActive("Flash Fire") && moveType == PokemonType.FIRE)
				DAMAGE *= 1.5;
			if (DAMAGE <= 0)
				DAMAGE = 1;
			DAMAGE += 2;
			if (CRITICAL_HIT)
				DAMAGE *= 2;
			if (MOVE_NAME == "Bite" || MOVE_NAME == "Astonish" || MOVE_NAME == "Needle Arm" || MOVE_NAME == "Stomp" || MOVE_NAME == "Rolling Kick" || MOVE_NAME == "Headbutt")
			{
				if (action.ASTONISH <= 30)
				{
					// check if the victim has yet to attack
					for (i = 0; i < battle.actionQueue.length; i++)
					{
						if (battle.actionQueue[i].OWNER == victim)
							yettoattack = true;
					}
					if (yettoattack)
						results.push(BattleActionResult.generateStatusResult(victim, BattleActionResult.STATUS_FLINCH));
				}
			} else
			if (MOVE_NAME == "Body Slam")
			{
				if (action.ASTONISH <= 10)
				{
					// check if the victim has yet to attack
					for (i = 0; i < battle.actionQueue.length; i++)
					{
						if (battle.actionQueue[i].OWNER == victim)
							yettoattack = true;
					}
					if (yettoattack)
						results.push(BattleActionResult.generateStatusResult(victim, BattleActionResult.STATUS_PARALYSIS));
				}
			}
			else if (MOVE_NAME == "Extrasensory")
			{
				if (action.ASTONISH <= 10)
				{
					results.push(BattleActionResult.generateStatusResult(victim, BattleActionResult.STATUS_FLINCH));
				}
			}
			if (attacker.isBattleEffectActive(BattleEffect.CHARGE) && moveType == PokemonType.ELECTRIC)
				DAMAGE *= 2;
			else if (attacker.isBattleEffectActive(BattleEffect.CHARGE)) attacker.deactivateBattleEffect(BattleEffect.CHARGE);
			if (attacker.isBattleEffectActive(BattleEffect.HELPING_HAND))
				DAMAGE *= 1.5;
			if (attacker.base.doesMoveHaveStab(MOVE_NAME) && MOVE_NAME != "Struggle")
				DAMAGE *= 1.5;
			var typeEffectiveness:Number = PokemonEffectiveness.getTypeEffectiveness(moveType, victim);
			
			if (presentEffect)
			{
				result.DAMAGE = ( -1 / 4) * result.VICTIM.CURRENT_HP;
				if (result.VICTIM.CURRENT_HP == result.VICTIM.getStat(PokemonStat.HP))
				{
					// pokemon is at full health, we can't heal it!
					result.TYPE = BattleActionResult.MOVE_FAILURE;
					result.DAMAGE = 0;
					return results;
				}
				result.TYPE = BattleActionResult.MOVE_HEALED_ENEMY;
				return results;
			}
			
			if (CRITICAL_HIT)
				result.CRITICAL_HIT = true;
			
			switch (typeEffectiveness)
			{
				case PokemonEffectiveness.HALF: 
				case PokemonEffectiveness.QUARTER: 
					result.TYPE = BattleActionResult.MOVE_NOT_VERY_EFFECTIVE;
					break;
				case PokemonEffectiveness.QUADRUPLE: 
				case PokemonEffectiveness.DOUBLE: 
					result.TYPE = BattleActionResult.MOVE_SUPER_EFFECTIVE;
					break;
				case PokemonEffectiveness.ZERO: 
					result.TYPE = BattleActionResult.MOVE_NO_EFFECT;
					break;
			}
			
			if (attacker.isBattleEffectActive(BattleEffect.ODOR_SLEUTH) && (moveType == PokemonType.NORMAL || moveType == PokemonType.FIGHTING) && victim.isType(PokemonType.GHOST))
			{
				result.TYPE = BattleActionResult.MOVE_NORMAL_USE;
				typeEffectiveness = 1;
			}
			if (MOVE_NAME == "Struggle" || MOVE_NAME == "Beat Up") result.TYPE = BattleActionResult.MOVE_NORMAL_USE;
			
			if (MOVE_NAME == "Dig") trace("DAMAGE: " + DAMAGE + ", " + typeEffectiveness);
			if (MOVE_NAME != "Struggle" && MOVE_NAME != "Beat Up")
				DAMAGE *= typeEffectiveness;
			if(MOVE_NAME != "Beat Up") DAMAGE *= (action.DAMAGE_VARIANCE / 100);
			if (DAMAGE < 0)
				DAMAGE = 1;
			
			result.DAMAGE = DAMAGE;
			return results;
		}
		
		private static function leastSignificantBit(x:int):int
		{
			if (isNumberEven(x))
				return 0;
			else
				return 1;
		}
		
		private static function secondLeastSignificantBit(x:int):int
		{
			var r:int = x % 4;
			if (r == 2 || r == 3)
				return 1;
			else
				return 0;
		}
		
		private static function isNumberEven(x:int):Boolean
		{
			if (x % 2 == 0)
				return true;
			else
				return false;
		}
	
	}

}