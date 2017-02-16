package com.cloakentertainment.pokemonline.stats 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public final class PokemonStatusCondition 
	{
		private var _name:String;
		private var _volatilitystatus:String;
		
		public function PokemonStatusCondition(name:String, volatilitystatus:String) 
		{
			_name = name;
			_volatilitystatus = volatilitystatus;
		}
		
		public function get NAME():String
		{
			return _name;
		}
		
		public function get TYPE():String
		{
			return _volatilitystatus;
		}
		
	}

}