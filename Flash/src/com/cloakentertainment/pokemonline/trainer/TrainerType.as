package com.cloakentertainment.pokemonline.trainer 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class TrainerType 
	{
		public static const AQUA_ADMIN_FEMALE:String = "AQUA_ADMIN_FEMALE";
		public static const AQUA_ADMIN_MALE:String = "AQUA_ADMIN_MALE";
		public static const AQUA_LEADER_MALE:String = "AQUA_LEADER_MALE";
		public static const ARENA_TYCOON_FEMALE:String = "ARENA_TYCOON_FEMALE";
		public static const AROMA_LADY_FEMALE:String = "AROMA_LADY_FEMALE";
		public static const BATTLE_GIRL_FEMALE:String = "BATTLE_GIRL_FEMALE";
		public static const BUG_MANIAC_MALE:String = "BUG_MANIAC_MALE";
		public static const COLLECTOR_MALE:String = "COLLECTOR_MALE";
		public static const DOME_ACE_MALE:String = "DOME_ACE_MALE";
		public static const DRAGON_TAMER_MALE:String = "DRAGON_TAMER_MALE";
		public static const EXPERT_FEMALE:String = "EXPERT_FEMALE";
		public static const EXPERT_MALE:String = "EXPERT_MALE";
		public static const FACTORY_HEAD_MALE:String = "FACTORY_HEAD_MALE";
		public static const HERO_FEMALE:String = "HERO_FEMALE";
		public static const HERO_MALE:String = "HERO_MALE";
		public static const HEX_MANIAC_FEMALE:String = "HEX_MANIAC_FEMALE";
		public static const INTERVIEWERS:String = "INTERVIEWERS";
		public static const KINDLER_MALE:String = "KINDLER_MALE";
		public static const LADY_FEMALE:String = "LADY_FEMALE";
		public static const MAGMA_ADMIN_FEMALE:String = "MAGMA_ADMIN_FEMALE";
		public static const MAGMA_ADMIN_MALE:String = "MAGMA_ADMIN_MALE";
		public static const MAGMA_LEADER_MALE:String = "MAGMA_LEADER_MALE";
		public static const NINJA_BOY_MALE:String = "NINJA_BOY_MALE";
		public static const OLD_COUPLE:String = "OLD_COUPLE";
		public static const PALACE_MAVEN_MALE:String = "PALACE_MAVEN_MALE";
		public static const PARASOL_LADY_FEMALE:String = "PARASOL_LADY_FEMALE";
		public static const PIKE_QUEEN_FEMALE:String = "PIKE_QUEEN_FEMALE";
		public static const POKEMON_BREEDER_FEMALE:String = "POKEMON_BREEDER_FEMALE";
		public static const POKEMON_BREEDER_MALE:String = "POKEMON_BREEDER_MALE";
		public static const POKEMON_RANGER_FEMALE:String = "POKEMON_RANGER_FEMALE";
		public static const POKEMON_RANGER_MALE:String = "POKEMON_RANGER_MALE";
		public static const PYRAMID_KING_MALE:String = "PYRAMID_KING_MALE";
		public static const RICH_BOY_MALE:String = "RICH_BOY_MALE";
		public static const RUIN_MANIAC_MALE:String = "RUIN_MANIAC_MALE";
		public static const SALON_MAVEN_FEMALE:String = "SALON_MAVEN_FEMALE";
		public static const SIS_AND_BRO:String = "SIS_AND_BRO";
		public static const TEAM_AQUA_GRUNT_FEMALE:String = "TEAM_AQUA_GRUNT_FEMALE";
		public static const TEAM_AQUA_GRUNT_MALE:String = "TEAM_AQUA_GRUNT_MALE";
		public static const TEAM_MAGMA_GRUNT_FEMALE:String = "TEAM_MAGMA_GRUNT_FEMALE";
		public static const TEAM_MAGMA_GRUNT_MALE:String = "TEAM_MAGMA_GRUNT_MALE";
		public static const TEAMMATES:String = "TEAMMATES";
		public static const TRIATHLETE_BIKE_FEMALE:String = "TRIATHLETE_BIKE_FEMALE";
		public static const TRIATHLETE_BIKE_MALE:String = "TRIATHLETE_BIKE_MALE";
		public static const TRIATHLETE_RUN_FEMALE:String = "TRIATHLETE_RUN_FEMALE";
		public static const TRIATHLETE_RUN_MALE:String = "TRIATHLETE_RUN_MALE";
		public static const TRIATHLETE_SWIM_FEMALE:String = "TRIATHLETE_SWIM_FEMALE";
		public static const TRIATHLETE_SWIM_MALE:String = "TRIATHLETE_SWIM_MALE";
		public static const TUBER_FEMALE:String = "TUBER_FEMALE";
		public static const TUBER_MALE:String = "TUBER_MALE";
		public static const WINSTRATE_VICKI_FEMALE:String = "WINSTRATE_VICKI_FEMALE";
		public static const WINSTRATE_VICTOR_MALE:String = "WINSTRATE_VICTOR_MALE";
		public static const WINSTRATE_VICTORIA_FEMALE:String = "WINSTRATE_VICTORIA_FEMALE";
		public static const WINSTRATE_VITO_MALE:String = "WINSTRATE_VITO_MALE";
		public static const WINSTRATE_VIVI_FEMALE:String = "WINSTRATE_VIVI_FEMALE";
		public static const YOUNG_COUPLE:String = "YOUNG_COUPLE";
		public static const CHAMPION_WALLACE:String = "CHAMPION_WALLACE";
		public static const YOUNGSTER_MALE:String = "YOUNGSTER_MALE";
		public static const BUG_CATCHER_MALE:String = "BUG_CATCHER_MALE";
		public static const LASS_FEMALE:String = "LASS_FEMALE";
		public static const WALLY:String = "WALLY";
		public static const FISHERMAN_MALE:String = "FISHERMAN_MALE";
		public static const TWINS_FEMALE:String = "TWINS_FEMALE";
		
		public static const NONE:String = "NONE"; // No trainer type associated with this Entity
		
		public function TrainerType() 
		{
			
		}
		
		public static function isMale(type:String):Boolean
		{
			switch(type)
			{
				case AQUA_ADMIN_MALE:
				case AQUA_LEADER_MALE:
				case BUG_MANIAC_MALE:
				case COLLECTOR_MALE:
				case DOME_ACE_MALE:
				case DRAGON_TAMER_MALE:
				case EXPERT_MALE:
				case FACTORY_HEAD_MALE:
				case HERO_MALE:
				case KINDLER_MALE:
				case MAGMA_ADMIN_MALE:
				case MAGMA_LEADER_MALE:
				case NINJA_BOY_MALE:
				case PALACE_MAVEN_MALE:
				case POKEMON_BREEDER_MALE:
				case POKEMON_RANGER_MALE:
				case PYRAMID_KING_MALE:
				case RICH_BOY_MALE:
				case RUIN_MANIAC_MALE:
				case TEAM_AQUA_GRUNT_MALE:
				case TEAM_MAGMA_GRUNT_MALE:
				case TRIATHLETE_BIKE_MALE:
				case TRIATHLETE_RUN_MALE:
				case TRIATHLETE_SWIM_MALE:
				case TUBER_MALE:
				case WINSTRATE_VICTOR_MALE:
				case WINSTRATE_VITO_MALE:
				case YOUNGSTER_MALE:
				case BUG_CATCHER_MALE:
				case WALLY:
				case FISHERMAN_MALE:
					
				return true;
				break;
			default:
				return false;
				break;
			}
		}
		
		public static function isFemale(type:String):Boolean
		{
			switch(type)
			{
				case AQUA_ADMIN_FEMALE:
				case ARENA_TYCOON_FEMALE:
				case AROMA_LADY_FEMALE:
				case BATTLE_GIRL_FEMALE:
				case EXPERT_FEMALE:
				case HERO_FEMALE:
				case HEX_MANIAC_FEMALE:
				case LADY_FEMALE:
				case MAGMA_ADMIN_FEMALE:
				case PARASOL_LADY_FEMALE:
				case PIKE_QUEEN_FEMALE:
				case POKEMON_BREEDER_FEMALE:
				case POKEMON_RANGER_FEMALE:
				case SALON_MAVEN_FEMALE:
				case TEAM_AQUA_GRUNT_FEMALE:
				case TEAM_MAGMA_GRUNT_FEMALE:
				case TRIATHLETE_BIKE_FEMALE:
				case TRIATHLETE_RUN_FEMALE:
				case TRIATHLETE_SWIM_FEMALE:
				case TUBER_FEMALE:
				case WINSTRATE_VICKI_FEMALE:
				case WINSTRATE_VICTORIA_FEMALE:
				case WINSTRATE_VIVI_FEMALE:
				case LASS_FEMALE:
					case TWINS_FEMALE:
					return true;
					break;
				default:
					return false;
					break;
			}
		}
		
		public static function getTrainerSpriteIndex(type:String):int
		{
			switch(type)
			{
				case AQUA_ADMIN_FEMALE:
					return 0;
					break;
				case AQUA_ADMIN_MALE:
					return 1;
					break;
				case AQUA_LEADER_MALE:
					return 2;
					break;
				case ARENA_TYCOON_FEMALE:
					return 3;
					break;
				case AROMA_LADY_FEMALE:
					return 4;
					break;
				case BATTLE_GIRL_FEMALE:
					return 5;
					break;
				case BUG_MANIAC_MALE:
					return 6;
					break;
				case COLLECTOR_MALE:
					return 7;
					break;
				case DOME_ACE_MALE:
					return 8;
					break;
				case DRAGON_TAMER_MALE:
					return 9;
					break;
				case EXPERT_FEMALE:
					return 10;
					break;
				case EXPERT_MALE:
					return 11;
					break;
				case FACTORY_HEAD_MALE:
					return 12;
					break;
				case HERO_FEMALE:
					return 13;
					break;
				case HERO_MALE:
					return 14;
					break;
				case HEX_MANIAC_FEMALE:
					return 15;
					break;
				case INTERVIEWERS:
					return 16;
					break;
				case KINDLER_MALE:
					return 17;
					break;
				case LADY_FEMALE:
					return 18;
					break;
				case MAGMA_ADMIN_FEMALE:
					return 19;
					break;
				case MAGMA_ADMIN_MALE:
					return 20;
					break;
				case MAGMA_LEADER_MALE:
					return 21;
					break;
				case NINJA_BOY_MALE:
					return 22;
					break;
				case OLD_COUPLE:
					return 23;
					break;
				case PALACE_MAVEN_MALE:
					return 24;
					break;
				case PARASOL_LADY_FEMALE:
					return 25;
					break;
				case PIKE_QUEEN_FEMALE:
					return 26;
					break;
				case POKEMON_BREEDER_FEMALE:
					return 27;
					break;
				case POKEMON_BREEDER_MALE:
					return 28;
					break;
				case POKEMON_RANGER_FEMALE:
					return 29;
					break;
				case POKEMON_RANGER_MALE:
					return 30;
					break;
				case PYRAMID_KING_MALE:
					return 31;
					break;
				case RICH_BOY_MALE:
					return 32;
					break;
				case RUIN_MANIAC_MALE:
					return 33;
					break;
				case SALON_MAVEN_FEMALE:
					return 34;
					break;
				case SIS_AND_BRO:
					return 35;
					break;
				case TEAMMATES:
					return 36;
					break;
				case TEAM_AQUA_GRUNT_FEMALE:
					return 37;
					break;
				case TEAM_AQUA_GRUNT_MALE:
					return 38;
					break;
				case TEAM_MAGMA_GRUNT_FEMALE:
					return 39;
					break;
				case TEAM_MAGMA_GRUNT_MALE:
					return 40;
					break;
				case TRIATHLETE_BIKE_FEMALE:
					return 41;
					break;
				case TRIATHLETE_BIKE_MALE:
					return 42;
					break;
				case TRIATHLETE_RUN_FEMALE:
					return 43;
					break;
				case TRIATHLETE_RUN_MALE:
					return 44;
					break;
				case TRIATHLETE_SWIM_FEMALE:
					return 45;
					break;
				case TRIATHLETE_SWIM_MALE:
					return 46;
					break;
				case TUBER_FEMALE:
					return 47;
					break;
				case TUBER_MALE:
					return 48;
					break;
				case WINSTRATE_VICKI_FEMALE:
					return 49;
					break;
				case WINSTRATE_VICTOR_MALE:
					return 50;
					break;
				case WINSTRATE_VICTORIA_FEMALE:
					return 51;
					break;
				case WINSTRATE_VITO_MALE:
					return 52;
					break;
				case WINSTRATE_VIVI_FEMALE:
				case LASS_FEMALE:
					return 53;
					break;
				case YOUNG_COUPLE:
					return 54;
					break;
				case CHAMPION_WALLACE:
					return 55;
					break;
				case YOUNGSTER_MALE:
					return 56;
					break;
				case BUG_CATCHER_MALE:
					return 57;
					break;
				case WALLY:
					return 58;
					break;
				case FISHERMAN_MALE:
					return 59;
					break;
				case TWINS_FEMALE:
					return 60;
					break;
				default:
					throw(new Error("Unknown Trainer type " + type + "!"));
					return 0;
					break;
			}
		}
		
	}

}