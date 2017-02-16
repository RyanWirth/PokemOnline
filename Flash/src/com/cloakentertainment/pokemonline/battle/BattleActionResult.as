package com.cloakentertainment.pokemonline.battle
{
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonMoves;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class BattleActionResult
	{
		public static const MOVE_FAILURE:String = "MOVE_FAILED";
		public static const MOVE_NO_EFFECT:String = "MOVE_NO_EFFECT";
		public static const MOVE_NOT_VERY_EFFECTIVE:String = "MOVE_NOT_VERY_EFFECTIVE";
		public static const MOVE_SUPER_EFFECTIVE:String = "MOVE_SUPER_EFFECTIVE";
		public static const MOVE_NORMAL_USE:String = "MOVE_NORMAL_USE";
		public static const MOVE_MISSED:String = "MOVE_MISSED";
		public static const MOVE_HURT_ITSELF_IN_CONFUSION:String = "MOVE_HURT_ITSELF_IN_CONFUSION";
		public static const MOVE_HEALED_ENEMY:String = "MOVE_HEALED_ENEMY";
		public static const MOVE_FLEW_UP_HIGH:String = "MOVE_FLEW_UP_HIGH";
		public static const MOVE_DUG_DOWN_DEEP:String = "MOVE_DUG_DOWN_DEEP";
		public static const MOVE_DOVE_DOWN_DEEP:String = "MOVE_DOVE_DOWN_DEEP";
		public static const MOVE_RECOIL:String = "MOVE_CRASH_DAMAGE";
		public static const MOVE_WHIRLWIND:String = "MOVE_WHIRLWIND";
		public static const MOVE_TAKING_IN_SUNLIGHT:String = "MOVE_TAKING_IN_SUNLIGHT";
		public static const MOVE_STOLE_ITEM:String = "MOVE_STOLE_ITEM";
		public static const MOVE_SUCCESSFUL:String = "MOVE_SUCCESSFUL";
		public static const MOVE_BOUNCED:String = "MOVE_BOUNCED";
		public static const MOVE_CLOAKED_IN_HARSH_LIGHT:String = "MOVE_CLOAKED_IN_HARSH_LIGHT";
		public static const MOVE_LOWERED_HEAD:String = "MOVE_LOWERED_HEAD";
		public static const MOVE_NOTHING_HAPPENED:String = "MOVE_NOTHING_HAPPENED";
		public static const MOVE_SNATCHED:String = "MOVE_SNATCHED";
		public static const MOVE_PERISH_SONG:String = "MOVE_PERISH_SONG";
		public static const MOVE_PERISH_SONG_INIT:String = "MOVE_PERISH_SONG_INIT";
		public static const MOVE_TRADE_ITEM:String = "MOVE_TRADE_ITEM";
		
		public static const WEATHER_BEGAN_TO_HAIL:String = "WEATHER_BEGAN_TO_HAIL";
		public static const WEATHER_BEGAN_TO_SHINE:String = "WEATHER_BEGAN_TO_SHINE";
		public static const WEATHER_BEGAN_TO_RAIN:String = "WEATHER_BEGAN_TO_RAIN";
		public static const WEATHER_BEGAN_SANDSTORM:String = "WEATHER_BEGAN_SANDSTORM";
		public static const WEATHER_STOPPED:String = "WEATHER_STOPPED";
		public static const WEATHER_HAILING:String = "WEATHER_HAILING";
		public static const WEATHER_SANDSTORM:String = "WEATHER_SANDSTORM";
		
		public static const POKEMON_IGNORED_ORDERS_WHILE_ASLEEP:String = "POKEMON_IGNORED_ORDERS_WHILE_ASLEEP";
		public static const POKEMON_IGNORED_ORDERS:String = "POKEMON_IGNORED_ORDERS";
		public static const POKEMON_BEGAN_TO_NAP:String = "POKEMON_BEGAN_TO_NAP";
		public static const POKEMON_WONT_OBEY:String = "POKEMON_WONT_OBEY";
		public static const POKEMON_TURNED_AWAY:String = "POKEMON_TURNED_AWAY";
		public static const POKEMON_LOAFING_AROUND:String = "POKEMON_LOAFING_AROUND";
		public static const POKEMON_PRETENDED_NOT_TO_NOTICE:String = "POKEMON_PRETENDED_NOT_TO_NOTICE";
		public static const POKEMON_CANNOT_ATTACK:String = "POKEMON_CANNOT_ATTACK";
		public static const POKEMON_SEEDED:String = "POKEMON_SEEDED";
		public static const POKEMON_PARALYZED:String = "POKEMON_PARALYZED";
		public static const POKEMON_INFATUATED:String = "POKEMON_INFATUATED";
		public static const POKEMON_SLEEPING:String = "POKEMON_SLEEPING";
		public static const POKEMON_RECHARGING:String = "POKEMON_RECHARGING";
		public static const POKEMON_ABSORB_HEALTH:String = "POKEMON_ABSORB_HEALTH";
		public static const POKEMON_CONFUSED:String = "POKEMON_CONFUSED";
		public static const POKEMON_HELD_ITEM_LOST:String = "POKEMON_HELD_ITEM_LOST";
		public static const POKEMON_FOCUS_ENERGY:String = "POKEMON_FOCUS_ENERGY";
		public static const POKEMON_LOST_FOCUS:String = "POKEMON_LOST_FOCUS";
		public static const POKEMON_BLOWN_AWAY:String = "POKEMON_BLOWN_AWAY";
		public static const POKEMON_DRAGGED_OUT:String = "POKEMON_DRAGGED_OUT";
		public static const POKEMON_FLED:String = "POKEMON_FLED";
		public static const POKEMON_TRANSFORMED:String = "POKEMON_TRANSFORMED";
		public static const POKEMON_MADE_A_WISH:String = "POKEMON_MADE_A_WISH";
		
		public static const STAT_ATK:String = "STAT_ATK";
		public static const STAT_DEF:String = "STAT_DEF";
		public static const STAT_SPATK:String = "STAT_SPATK";
		public static const STAT_SPDEF:String = "STAT_SPDEF";
		public static const STAT_SPEED:String = "STAT_SPEED";
		public static const STAT_EVASION:String = "STAT_EVASION";
		public static const STAT_ACCURACY:String = "STAT_ACCURACY";
		
		public static const STAT_STAGES_RESET:String = "STAT_STAGES_RESET";
		
		public static const STATUS_WATERSPORT:String = "STATUS_WATERSPORT";
		public static const STATUS_MUDSPORT:String = "STATUS_MUDSPORT";
		public static const STATUS_SLEEP:String = "STATUS_SLEEP";
		public static const STATUS_BURN:String = "STATUS_BURN";
		public static const STATUS_FREEZE:String = "STATUS_FREEZE";
		public static const STATUS_PARALYSIS:String = "STATUS_PARALYSIS";
		public static const STATUS_CONFUSION:String = "STATUS_CONFUSION";
		public static const STATUS_FAINT:String = "STATUS_FAINT";
		public static const STATUS_FLINCH:String = "STATUS_FLINCH";
		public static const STATUS_INFATUATION:String = "STATUS_INFATUATION";
		public static const STATUS_POISON:String = "STATUS_POISON";
		public static const STATUS_PARTIAL_TRAP:String = "STATUS_PARTIAL_TRAP";
		public static const STATUS_CURE_PARALYSIS:String = "STATUS_CURE_PARALYSIS";
		public static const STATUS_CURE_BURN:String = "STATUS_CURE_BURN";
		public static const STATUS_CURE_POISON:String = "STATUS_CURE_POISON";
		public static const STATUS_CURE_FREEZE:String = "STATUS_CURE_FREEZE";
		public static const STATUS_CURE_SLEEP:String = "STATUS_CURE_SLEEP";
		public static const STATUS_TYPE_CHANGED:String = "STATUS_TYPE_CHANGED";
		
		public static const SWITCH:String = "SWITCH";
		public static const SWITCHED_OUT:String = "SWITCHED_OUT";
		public static const FINISH_BATTLE:String = "FINISH_BATTLE";
		public static const DESCRIBE_WEATHER:String = "DESCRIBE_WEATHER";
		public static const LIGHT_SCREEN_DESTROYED:String = "LIGHT_SCREEN_DESTROYED";
		public static const REFLECT_DESTROYED:String = "REFLECT_DESTROYED";
		
		public static const DISABLE_MOVE1:String = "DISABLE_MOVE1";
		public static const DISABLE_MOVE2:String = "DISABLE_MOVE2";
		public static const DISABLE_MOVE3:String = "DISABLE_MOVE3";
		public static const DISABLE_MOVE4:String = "DISABLE_MOVE4";
		
		public static const STATUS_MOVE:String = "STATUS_MOVE";
		public static const STATUS_LEECH_SEED:String = "STATUS_LEECH_SEED";
		public static const STATUS_TOXIC:String = "STATUS_TOXIC";
		
		public static const ABILITY_DID_DAMAGE:String = "ABILITY_DID_DAMAGE";
		public static const CANT_RUN_FROM_TRAINER_BATTLE:String = "CANT_RUN_FROM_TRAINER_BATTLE";
		public static const GOT_AWAY_SAFELY:String = "GOT_AWAY_SAFELY";
		public static const CANT_ESCAPE:String = "CANT_ESCAPE";
		
		public static const ITEM_POKEBALL:String = "ITEM_POKEBALL";
		public static const ITEM_HEAL:String = "ITEM_HEAL";
		
		public var DAMAGE:int = 0;
		public var TYPE:String = "";
		public var MOVE_ID:int = 0;
		public var VICTIM:Pokemon = null;
		public var USER:Pokemon = null;
		public var CRITICAL_HIT:Boolean = false;
		public var ITEM_NAME:String = "";
		public var EXTRA_DATA:Number = 0;
		public var CUTE_CHARM:int = 0;
		
		public function BattleActionResult()
		{
		
		}
		
		public static function generateItemResult(itemName:String, battleActionResultType:String, extraData:Number, accuracy:int, user:Pokemon, target:Pokemon):BattleActionResult
		{
			var result:BattleActionResult = new BattleActionResult();
			result.ITEM_NAME = itemName;
			result.TYPE = battleActionResultType;
			result.EXTRA_DATA = extraData;
			result.CUTE_CHARM = accuracy;
			result.USER = user;
			result.VICTIM = target;
			
			return result;
		}
		
		public static function generateMoveResult(moveID:int, astonish:int, damage:int, user:Pokemon, victim:Pokemon, effect:String):BattleActionResult
		{
			var result:BattleActionResult = new BattleActionResult();
			result.DAMAGE = damage;
			result.TYPE = effect;
			result.MOVE_ID = moveID;
			result.VICTIM = victim;
			result.USER = user;
			result.CUTE_CHARM = astonish;
			return result;
		}
		
		public static function generateFailureResult(moveID:int, user:Pokemon, reason:String):BattleActionResult
		{
			var result:BattleActionResult = new BattleActionResult();
			result.TYPE = reason;
			result.MOVE_ID = moveID;
			result.USER = user;
			return result;
		}
		
		public static function generateStatusResult(user:Pokemon, statusEffect:String, dmg:int = 0, cuteCharm:int = 0):BattleActionResult
		{
			var result:BattleActionResult = new BattleActionResult();
			result.TYPE = statusEffect;
			result.USER = user;
			result.CUTE_CHARM = cuteCharm;
			if (dmg != 0)
				result.DAMAGE = dmg;
			return result;
		}
		
		public function toString():String
		{
			switch (TYPE)
			{
				case BattleActionResult.MOVE_FAILURE: 
					return USER.NAME + "'s move failed.";
					break;
				case BattleActionResult.MOVE_HEALED_ENEMY: 
					return USER.NAME + "'s move healed " + VICTIM.NAME;
					break;
				case BattleActionResult.MOVE_HURT_ITSELF_IN_CONFUSION: 
					return USER.NAME + " hurt itself in confusion!";
					break;
				case BattleActionResult.MOVE_MISSED: 
					return USER.NAME + "'s move missed.";
					break;
				case BattleActionResult.MOVE_NO_EFFECT: 
					return USER.NAME + "'s move had no effect.";
					break;
				case BattleActionResult.MOVE_NORMAL_USE: 
					return USER.NAME + "'s move did " + DAMAGE + " damage against " + VICTIM.NAME;
					break;
				case BattleActionResult.MOVE_NOT_VERY_EFFECTIVE: 
					return USER.NAME + "'s move was not very effective, did " + DAMAGE + " damage against " + VICTIM.NAME;
					break;
				case BattleActionResult.MOVE_SUCCESSFUL: 
					return USER.NAME + " used " + PokemonMoves.getMoveNameByID(MOVE_ID);
					break;
				case BattleActionResult.MOVE_SUPER_EFFECTIVE: 
					return USER.NAME + "'s move was super effective, did " + DAMAGE + " damage against " + VICTIM.NAME;
					break;
				case BattleActionResult.POKEMON_BEGAN_TO_NAP: 
					return USER.NAME + " began to nap.";
					break;
				case BattleActionResult.POKEMON_IGNORED_ORDERS: 
					return USER.NAME + " ignored orders.";
					break;
				case BattleActionResult.POKEMON_IGNORED_ORDERS_WHILE_ASLEEP: 
					return USER.NAME + " ignored orders while asleep.";
					break;
				case BattleActionResult.POKEMON_LOAFING_AROUND: 
					return USER.NAME + " is loafing around.";
					break;
				case BattleActionResult.POKEMON_PRETENDED_NOT_TO_NOTICE: 
					return USER.NAME + " pretended not to notice.";
					break;
				case BattleActionResult.POKEMON_TURNED_AWAY: 
					return USER.NAME + " turned away.";
					break;
				case BattleActionResult.POKEMON_WONT_OBEY: 
					return USER.NAME + " won't obey.";
					break;
				case BattleActionResult.STATUS_BURN: 
					return USER.NAME + " got a burn.";
					break;
				case BattleActionResult.STATUS_CONFUSION: 
					return USER.NAME + " is confused.";
					break;
				case BattleActionResult.STATUS_FAINT: 
					return USER.NAME + " fainted.";
					break;
				case BattleActionResult.STATUS_FLINCH: 
					return USER.NAME + " flinched.";
					break;
				case BattleActionResult.STATUS_FREEZE: 
					return USER.NAME + " froze.";
					break;
				case BattleActionResult.STATUS_MOVE: 
					return USER.NAME + " used a status move.";
					break;
				case BattleActionResult.STATUS_PARALYSIS: 
					return USER.NAME + " is now paralyzed.";
					break;
				case BattleActionResult.STATUS_SLEEP: 
					return USER.NAME + " is now sleeping.";
					break;
				default: 
					return "Unknown type " + TYPE;
			}
		}
	
	}

}