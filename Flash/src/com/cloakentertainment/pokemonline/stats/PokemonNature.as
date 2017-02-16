package com.cloakentertainment.pokemonline.stats 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonNature 
	{
		public static const HARDY:String = "hardy";
		public static const LONELY:String = "lonely";
		public static const BRAVE:String = "brave";
		public static const ADAMANT:String = "adamant";
		public static const NAUGHTY:String = "naughty";
		public static const BOLD:String = "bold";
		public static const DOCILE:String = "docile";
		public static const RELAXED:String = "relaxed";
		public static const IMPISH:String = "impish";
		public static const LAX:String = "lax";
		public static const TIMID:String = "timid";
		public static const HASTY:String = "hasty";
		public static const SERIOUS:String = "serious";
		public static const JOLLY:String = "jolly";
		public static const NAIVE:String = "naive";
		public static const MODEST:String = "modest";
		public static const MILD:String = "mild";
		public static const QUIET:String = "quiet";
		public static const BASHFUL:String = "bashful";
		public static const RASH:String = "rash";
		public static const CALM:String = "calm";
		public static const GENTLE:String = "gentle";
		public static const SASSY:String = "sassy";
		public static const CAREFUL:String = "careful";
		public static const QUIRKY:String = "quirky";
		
		public function PokemonNature() 
		{
			
		}
		
		public static function getIncreasedStat(nature:String):String
		{
			if (nature == HARDY) return PokemonStat.NONE;
			if (nature == LONELY) return PokemonStat.ATK;
			if (nature == BRAVE) return PokemonStat.ATK;
			if (nature == ADAMANT) return PokemonStat.ATK;
			if (nature == NAUGHTY) return PokemonStat.ATK;
			if (nature == BOLD) return PokemonStat.DEF;
			if (nature == DOCILE) return PokemonStat.NONE;
			if (nature == RELAXED) return PokemonStat.DEF;
			if (nature == IMPISH) return PokemonStat.DEF;
			if (nature == LAX) return PokemonStat.DEF;
			if (nature == TIMID) return PokemonStat.SPEED;
			if (nature == HASTY) return PokemonStat.SPEED;
			if (nature == SERIOUS) return PokemonStat.NONE;
			if (nature == JOLLY) return PokemonStat.SPEED;
			if (nature == NAIVE) return PokemonStat.SPEED;
			if (nature == MODEST) return PokemonStat.SPATK;
			if (nature == MILD) return PokemonStat.SPATK;
			if (nature == QUIET) return PokemonStat.SPATK;
			if (nature == BASHFUL) return PokemonStat.NONE;
			if (nature == RASH) return PokemonStat.SPATK;
			if (nature == CALM) return PokemonStat.SPDEF;
			if (nature == GENTLE) return PokemonStat.SPDEF;
			if (nature == SASSY) return PokemonStat.SPDEF;
			if (nature == CAREFUL) return PokemonStat.SPDEF;
			if (nature == QUIRKY) return PokemonStat.NONE;
			
			return PokemonStat.NONE;
		}
		
		public static function getDecreasedStat(nature:String):String
		{
			if (nature == HARDY) return PokemonStat.NONE;
			if (nature == LONELY) return PokemonStat.DEF;
			if (nature == BRAVE) return PokemonStat.SPEED;
			if (nature == ADAMANT) return PokemonStat.SPATK;
			if (nature == NAUGHTY) return PokemonStat.SPDEF;
			if (nature == BOLD) return PokemonStat.ATK;
			if (nature == DOCILE) return PokemonStat.NONE;
			if (nature == RELAXED) return PokemonStat.SPEED;
			if (nature == IMPISH) return PokemonStat.SPATK;
			if (nature == LAX) return PokemonStat.SPDEF;
			if (nature == TIMID) return PokemonStat.ATK;
			if (nature == HASTY) return PokemonStat.DEF;
			if (nature == SERIOUS) return PokemonStat.NONE;
			if (nature == JOLLY) return PokemonStat.SPATK;
			if (nature == NAIVE) return PokemonStat.SPDEF;
			if (nature == MODEST) return PokemonStat.ATK;
			if (nature == MILD) return PokemonStat.DEF;
			if (nature == QUIET) return PokemonStat.SPEED;
			if (nature == BASHFUL) return PokemonStat.NONE;
			if (nature == RASH) return PokemonStat.SPDEF;
			if (nature == CALM) return PokemonStat.ATK;
			if (nature == GENTLE) return PokemonStat.DEF;
			if (nature == SASSY) return PokemonStat.SPEED;
			if (nature == CAREFUL) return PokemonStat.SPATK;
			if (nature == QUIRKY) return PokemonStat.NONE;
			
			return PokemonStat.NONE;
		}
		
		public static function getLikedFlavour(nature:String):String
		{
			if (nature == HARDY) return PokemonFlavour.NONE;
			if (nature == LONELY) return PokemonFlavour.SPICY;
			if (nature == BRAVE) return PokemonFlavour.SPICY;
			if (nature == ADAMANT) return PokemonFlavour.SPICY;
			if (nature == NAUGHTY) return PokemonFlavour.SPICY;
			if (nature == BOLD) return PokemonFlavour.SOUR;
			if (nature == DOCILE) return PokemonFlavour.NONE;
			if (nature == RELAXED) return PokemonFlavour.SOUR;
			if (nature == IMPISH) return PokemonFlavour.SOUR;
			if (nature == LAX) return PokemonFlavour.SOUR;
			if (nature == TIMID) return PokemonFlavour.SWEET;
			if (nature == HASTY) return PokemonFlavour.SWEET;
			if (nature == SERIOUS) return PokemonFlavour.NONE;
			if (nature == JOLLY) return PokemonFlavour.SWEET;
			if (nature == NAIVE) return PokemonFlavour.SWEET;
			if (nature == MODEST) return PokemonFlavour.DRY;
			if (nature == MILD) return PokemonFlavour.DRY;
			if (nature == QUIET) return PokemonFlavour.DRY;
			if (nature == BASHFUL) return PokemonFlavour.NONE;
			if (nature == RASH) return PokemonFlavour.DRY;
			if (nature == CALM) return PokemonFlavour.BITTER;
			if (nature == GENTLE) return PokemonFlavour.BITTER;
			if (nature == SASSY) return PokemonFlavour.BITTER;
			if (nature == CAREFUL) return PokemonFlavour.BITTER;
			if (nature == QUIRKY) return PokemonFlavour.NONE;
			
			return PokemonFlavour.NONE;
		}
		
		public static function getDislikedFlavour(nature:String):String
		{
			if (nature == HARDY) return PokemonFlavour.NONE;
			if (nature == LONELY) return PokemonFlavour.SOUR;
			if (nature == BRAVE) return PokemonFlavour.SWEET;
			if (nature == ADAMANT) return PokemonFlavour.DRY;
			if (nature == NAUGHTY) return PokemonFlavour.BITTER;
			if (nature == BOLD) return PokemonFlavour.SPICY;
			if (nature == DOCILE) return PokemonFlavour.NONE;
			if (nature == RELAXED) return PokemonFlavour.SWEET;
			if (nature == IMPISH) return PokemonFlavour.DRY;
			if (nature == LAX) return PokemonFlavour.BITTER;
			if (nature == TIMID) return PokemonFlavour.SPICY;
			if (nature == HASTY) return PokemonFlavour.SOUR;
			if (nature == SERIOUS) return PokemonFlavour.NONE;
			if (nature == JOLLY) return PokemonFlavour.DRY;
			if (nature == NAIVE) return PokemonFlavour.BITTER;
			if (nature == MODEST) return PokemonFlavour.SPICY;
			if (nature == MILD) return PokemonFlavour.SOUR;
			if (nature == QUIET) return PokemonFlavour.SWEET;
			if (nature == BASHFUL) return PokemonFlavour.NONE;
			if (nature == RASH) return PokemonFlavour.BITTER;
			if (nature == CALM) return PokemonFlavour.SPICY;
			if (nature == GENTLE) return PokemonFlavour.SOUR;
			if (nature == SASSY) return PokemonFlavour.SWEET;
			if (nature == CAREFUL) return PokemonFlavour.DRY;
			if (nature == QUIRKY) return PokemonFlavour.NONE;
			
			return PokemonFlavour.NONE;
		}
		
		public static function getRandomNature():String
		{
			var random:int = Math.floor(Math.random() * 25) + 1;
			switch(random)
			{
				case 1:
					return PokemonNature.ADAMANT;
					break;
				case 2:
					return PokemonNature.BASHFUL;
					break;
				case 3:
					return PokemonNature.BOLD;
					break;
				case 4:
					return PokemonNature.BRAVE;
					break;
				case 5:
					return PokemonNature.CALM;
					break;
				case 6:
					return PokemonNature.CAREFUL;
					break;
				case 7:
					return PokemonNature.DOCILE;
					break;
				case 8:
					return PokemonNature.GENTLE;
					break;
				case 9:
					return PokemonNature.HARDY;
					break;
				case 10:
					return PokemonNature.HASTY;
					break;
				case 11:
					return PokemonNature.IMPISH;
					break;
				case 12:
					return PokemonNature.JOLLY;
					break;
				case 13:
					return PokemonNature.LAX;
					break;
				case 14:
					return PokemonNature.LONELY;
					break;
				case 15:
					return PokemonNature.MILD;
					break;
				case 16:
					return PokemonNature.MODEST;
					break;
				case 17:
					return PokemonNature.NAIVE;
					break;
				case 18:
					return PokemonNature.NAUGHTY;
					break;
				case 19:
					return PokemonNature.QUIET;
					break;
				case 20:
					return PokemonNature.QUIRKY;
					break;
				case 21:
					return PokemonNature.RASH;
					break;
				case 22:
					return PokemonNature.RELAXED;
					break;
				case 23:
					return PokemonNature.SASSY;
					break;
				case 24:
					return PokemonNature.SERIOUS;
					break;
				case 25:
					return PokemonNature.TIMID;
					break;
				default:
					return PokemonNature.DOCILE;
					break;
				
			}
		}
		
	}

}