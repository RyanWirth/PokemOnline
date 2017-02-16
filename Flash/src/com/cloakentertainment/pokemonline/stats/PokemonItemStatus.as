package com.cloakentertainment.pokemonline.stats 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonItemStatus 
	{
		public static const CANNOT_USE:String = "CANNOT_USE";
		public static const SUCCESSFUL:String = "SUCCESSFUL";
		public static const FAILED:String = "FAILED";
		
		public static const POKEMON_HP_STAT_INCREASED:String = "POKEMON_HP_STAT_INCREASED";
		public static const POKEMON_ATK_STAT_INCREASED:String = "POKEMON_ATK_STAT_INCREASED";
		public static const POKEMON_DEF_STAT_INCREASED:String = "POKEMON_DEF_STAT_INCREASED";
		public static const POKEMON_SPATK_STAT_INCREASED:String = "POKEMON_SPATK_STAT_INCREASED";
		public static const POKEMON_SPDEF_STAT_INCREASED:String = "POKEMON_SPDEF_STAT_INCREASED";
		public static const POKEMON_SPEED_STAT_INCREASED:String = "POKEMON_SPEED_STAT_INCREASED";
		public static const POKEMON_HP_STAT_MAXED:String = "POKEMON_HP_STAT_MAXED";
		public static const POKEMON_ATK_STAT_MAXED:String = "POKEMON_ATK_STAT_MAXED";
		public static const POKEMON_DEF_STAT_MAXED:String = "POKEMON_DEF_STAT_MAXED";
		public static const POKEMON_SPATK_STAT_MAXED:String = "POKEMON_SPATK_STAT_MAXED";
		public static const POKEMON_SPDEF_STAT_MAXED:String = "POKEMON_SPDEF_STAT_MAXED";
		public static const POKEMON_SPEED_STAT_MAXED:String = "POKEMON_SPEED_STAT_MAXED";
		
		public static const POKEMON_LEVEL_TOO_HIGH:String = "POKEMON_LEVEL_TOO_HIGH";
		
		public function PokemonItemStatus() 
		{
			
		}
		
		public static function convertStatusToText(status:String, pokemon:Pokemon = null):String
		{
			var prefix:String = pokemon != null ? pokemon.NAME + "'s " : "";
			switch(status)
			{
				case SUCCESSFUL:
					return "Used successfully.";
					break;
				case FAILED:
					return "Use failed!";
					break;
				case POKEMON_HP_STAT_INCREASED:
					return prefix + "HP stat increased!";
					break;
				case POKEMON_ATK_STAT_INCREASED:
					return prefix + "Attack stat increased!";
					break;
				case POKEMON_DEF_STAT_INCREASED:
					return prefix + "Defense stat increased!";
					break;
				case POKEMON_SPATK_STAT_INCREASED:
					return prefix + "Sp.Atk. stat increased!";
					break;
				case POKEMON_SPDEF_STAT_INCREASED:
					return prefix + "Sp.Def. stat increased!";
					break;
				case POKEMON_SPEED_STAT_INCREASED:
					return prefix + "Speed stat increased!";
					break;
				case POKEMON_HP_STAT_MAXED:
					return prefix + "HP stat cannot go any higher!";
					break;
				case POKEMON_ATK_STAT_MAXED:
					return prefix + "Attack stat cannot go any higher!";
					break;
				case POKEMON_DEF_STAT_MAXED:
					return prefix + "Defense stat cannot go any higher!";
					break;
				case POKEMON_SPATK_STAT_MAXED:
					return prefix + "Sp.Atk. stat cannot go any higher!";
					break;
				case POKEMON_SPDEF_STAT_MAXED:
					return prefix + "Sp.Def. stat cannot go any higher!";
					break;
				case POKEMON_SPEED_STAT_MAXED:
					return prefix + "Speed stat cannot go any higher!";
					break;
				case POKEMON_LEVEL_TOO_HIGH:
					return prefix + "level is too high!";
					break;
				default:
					case CANNOT_USE:
					return "You cannot use that right now!";
					break;
			}
		}
		
	}

}