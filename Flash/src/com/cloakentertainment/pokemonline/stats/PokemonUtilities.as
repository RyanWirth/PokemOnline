package com.cloakentertainment.pokemonline.stats
{
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonUtilities
	{
		
		public function PokemonUtilities()
		{
		
		}
		
		public static function getHiddenPowerType(hpNum:int):String
		{
			switch (hpNum)
			{
				case 0: 
					return PokemonType.FIGHTING;
					break;
				case 1: 
					return PokemonType.FLYING;
					break;
				case 2: 
					return PokemonType.POISON;
					break;
				case 3: 
					return PokemonType.GROUND;
					break;
				case 4: 
					return PokemonType.ROCK;
					break;
				case 5: 
					return PokemonType.BUG;
					break;
				case 6: 
					return PokemonType.GHOST;
					break;
				case 7: 
					return PokemonType.STEEL;
					break;
				case 8: 
					return PokemonType.FIRE;
					break;
				case 9: 
					return PokemonType.WATER;
					break;
				case 10: 
					return PokemonType.GRASS;
					break;
				case 11: 
					return PokemonType.ELECTRIC;
					break;
				case 12: 
					return PokemonType.PSYCHIC;
					break;
				case 13: 
					return PokemonType.ICE;
					break;
				case 14: 
					return PokemonType.DRAGON;
					break;
				case 15: 
					return PokemonType.DARK;
					break;
			
			}
			return PokemonType.NORMAL;
		}
	
	}

}