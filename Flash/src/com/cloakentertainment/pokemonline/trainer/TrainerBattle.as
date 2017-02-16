package com.cloakentertainment.pokemonline.trainer 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class TrainerBattle 
	{
		
		private var _winnings:int;
		private var _pokemonNames:Array;
		private var _pokemonLevels:Array;
		private var _losingTextQuote:String;
		
		public function TrainerBattle(winnings:int, pokemonNames:Array, pokemonLevels:Array, losingTextQuote:String = "Oh no! I lost?!") 
		{
			_winnings = winnings;
			_pokemonNames = pokemonNames;
			_pokemonLevels = pokemonLevels;
			_losingTextQuote = losingTextQuote;
			
			if (_pokemonLevels.length != _pokemonNames.length) throw(new Error("Element count mismatch on TrainerBattle."));
		}
		
		public function destroy():void
		{
			_pokemonNames = null;
			_pokemonLevels = null;
		}
		
		public function get WINNINGS():int
		{
			return _winnings;
		}
		
		public function get POKEMON_NAMES():Array
		{
			return _pokemonNames;
		}
		
		public function get POKEMON_LEVELS():Array
		{
			return _pokemonLevels;
		}
		
		public function get LOSING_TEXT_QUOTE():String
		{
			return _losingTextQuote;
		}
		
	}

}