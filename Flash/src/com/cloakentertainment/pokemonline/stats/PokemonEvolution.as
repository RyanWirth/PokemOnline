package com.cloakentertainment.pokemonline.stats 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonEvolution 
	{
		public static const LEVEL_TYPE:String = "level";
		public static const ITEM_TYPE:String = "item";
		public static const FRIENDSHIP_TYPE:String = "friendship";
		public static const TRADE_TYPE:String = "trade";
		
		public var TYPE:String = PokemonEvolution.LEVEL_TYPE;
		public var INTO:String = "";
		public var WITH:String = "";
		public var AT:int = 0;
		
		public function PokemonEvolution(_type:String, _at:int, _into:String, _with:String = "") 
		{
			TYPE = _type;
			AT = _at;
			INTO = _into;
			WITH = _with;
		}
		
		public function toString():String
		{
			return "Evolution: " + TYPE + ", " + AT + ", " + INTO + ", " + WITH;
		}
		
	}

}