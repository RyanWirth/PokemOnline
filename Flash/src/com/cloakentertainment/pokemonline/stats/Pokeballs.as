package com.cloakentertainment.pokemonline.stats 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class Pokeballs 
	{
		public static const DIVE_BALL:String = "Dive Ball";
		public static const GREAT_BALL:String = "Great Ball";
		public static const LUXURY_BALL:String = "Luxury Ball";
		public static const MASTERBALL_BALL:String = "Master Ball";
		public static const NEST_BALL:String = "Nest Ball";
		public static const NET_BALL:String = "Net Ball";
		public static const POKEBALL_BALL:String = "Poké Ball";
		public static const PREMIUM_BALL:String = "Premium Ball";
		public static const REPEAT_BALL:String = "Repeat Ball";
		public static const SAFARI_BALL:String = "Safari Ball";
		public static const TIMER_BALL:String = "Timer Ball";
		public static const ULTRA_BALL:String = "Ultra Ball";
		
		public function Pokeballs() 
		{
			
		}
		
		public static function getIconIDFromName(name:String):int
		{
			switch(name)
			{
				default:
					throw(new Error("Unknown Pokeball name " + name));
					break;
				case REPEAT_BALL:
					return 1;
					break;
				case NEST_BALL:
					return 2;
					break;
				case POKEBALL_BALL:
					return 3;
					break;
				case GREAT_BALL:
					return 4;
					break;
				case SAFARI_BALL:
					return 5;
					break;
				case ULTRA_BALL:
					return 6;
					break;
				case MASTERBALL_BALL:
					return 7;
					break;
				case NET_BALL:
					return 8;
					break;
				case DIVE_BALL:
					return 9;
					break;
				case TIMER_BALL:
					return 10;
					break;
				case LUXURY_BALL:
					return 11;
					break;
				case PREMIUM_BALL:
					return 12;
					break;
			}
		}
		
	}

}