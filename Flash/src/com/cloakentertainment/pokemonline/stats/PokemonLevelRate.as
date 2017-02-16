package com.cloakentertainment.pokemonline.stats 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonLevelRate 
	{
		public static const ERRATIC:String = "erratic";
		public static const FAST:String = "fast";
		public static const MEDIUMFAST:String = "mediumfast";
		public static const MEDIUMSLOW:String = "mediumslow";
		public static const SLOW:String = "slow";
		public static const FLUCTUATING:String = "fluctuating";
		
		public function PokemonLevelRate() 
		{
			
		}
		
		public static function calculateXP(levelRate:String, level:int):int
		{
			var n:int = level;
			if (levelRate == PokemonLevelRate.ERRATIC)
			{
				if (level <= 50) return (Math.pow(n, 3) * (100 - n)) / 50;
				else if (level <= 68) return (Math.pow(n, 3) * (150 - n)) / 100;
				else if (level <= 98) return (Math.pow(n, 3) * ((1911 - 10 * n) / 3)) / 500;
				else return (Math.pow(n, 3) * (160 - n)) / 100;
			} else
			if (levelRate == PokemonLevelRate.FAST)
			{
				return (4 * Math.pow(n, 3)) / 5;
			} else
			if (levelRate == PokemonLevelRate.MEDIUMFAST)
			{
				return Math.pow(n, 3);
			} else
			if (levelRate == PokemonLevelRate.MEDIUMSLOW)
			{
				return (6 / 5) * Math.pow(n, 3) - 15 * Math.pow(n, 2) + 100 * n - 140;
			} else
			if (levelRate == PokemonLevelRate.SLOW)
			{
				return (5 * Math.pow(n, 3)) / 4;
			} else
			if (levelRate == PokemonLevelRate.FLUCTUATING)
			{
				if (level <= 15) return Math.pow(n, 3) * ((((n + 1) / 3) + 24) / 50);
				else if (level <= 36) return Math.pow(n, 3) * ((n + 14) / 50);
				else return Math.pow(n, 3) * (((n / 2) + 32) / 50);
			}
			
			throw(new Error('Unknown Level Rate "' + levelRate + '"'));
			return 0;
		}
		
	}

}