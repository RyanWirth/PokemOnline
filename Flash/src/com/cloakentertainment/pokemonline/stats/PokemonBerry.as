package com.cloakentertainment.pokemonline.stats 
{
	/**
	 * ...
	 * @author Test
	 */
	public class PokemonBerry 
	{
		
		public function PokemonBerry() 
		{
			
		}
		
		public static function getMinimumYield(berryName:String):int
		{
			switch(berryName)
			{
				case "Belue":
				case "Durin":
				case "Watmel":
				case "Pamtre":
				case "Spelon":
				case "Lum":
					return 1;
					break;
				case "Nomel":
				case "Rabuta":
				case "Magost":
				case "Cornn":
				case "Tamato":
				case "Grepa":
				case "Hondew":
				case "Qualot":
				case "Kelpsy":
				case "Pomeg":
				case "Iapapa":
				case "Aguav":
				case "Mago":
				case "Wiki":
				case "Figy":
				case "Sitrus":
				case "Persim":
				case "Oran":
				case "Leppa":
				case "Aspear":
				case "Rawst":
				case "Pecha":
				case "Chesto":
				case "Cheri":
					return 2;
					break;
				case "Pinap":
				case "Wepear":
				case "Nanab":
				case "Bluk":
				case "Razz":
					return 3;
					break;
			}
			
			return 1;
		}
		
		public static function getMaximumYield(berryName:String):int
		{
			switch(berryName)
			{
				case "Belue":
				case "Durin":
				case "Watmel":
				case "Pamtre":
				case "Spelon":
				case "Lum":
					return 2;
					break;
				case "Nomel":
				case "Rabuta":
				case "Magost":
				case "Cornn":
				case "Tamato":
					return 4;
					break;
				case "Grepa":
				case "Hondew":
				case "Qualot":
				case "Kelpsy":
				case "Pomeg":
				case "Pinap":
				case "Wepear":
				case "Nanab":
				case "Bluk":
				case "Razz":
					return 6;
					break;
				case "Iapapa":
				case "Aguav":
				case "Mago":
				case "Wiki":
				case "Figy":
				case "Sitrus":
				case "Persim":
				case "Oran":
				case "Leppa":
				case "Aspear":
				case "Rawst":
				case "Pecha":
				case "Chesto":
				case "Cheri":
					return 3;
					break;
			}
			
			return 2;
		}
		
		public static function getFullGrowthTime(berryName:String):int
		{
			switch(berryName)
			{
				case "Belue":
				case "Durin":
				case "Watmel":
				case "Pamtre":
				case "Spelon":
					return 72 * 60 * 60;
					break;
				case "Nomel":
				case "Rabuta":
				case "Magost":
				case "Cornn":
				case "Tamato":
				case "Iapapa":
				case "Aguav":
				case "Mago":
				case "Wiki":
				case "Figy":
				case "Sitrus":
					return 24 * 60 * 60;
					break;
				case "Grepa":
				case "Hondew":
				case "Qualot":
				case "Kelpsy":
				case "Pomeg":
				case "Persim":
				case "Oran":
				case "Aspear":
				case "Rawst":
				case "Pecha":
				case "Chesto":
				case "Cheri":
					return 12 * 60 * 60;
					break;
				case "Leppa":
					return 16 * 60 * 60;
					break;
				case "Pinap":
				case "Wepear":
				case "Nanab":
				case "Bluk":
				case "Razz":
					return 4 * 60 * 60;
					break;
				case "Lum":
					return 48 * 60 * 60;
					break;
			}
			
			return 24 * 60 * 60;
		}
		
	}

}