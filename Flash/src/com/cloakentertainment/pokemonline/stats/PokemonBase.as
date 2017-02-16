package com.cloakentertainment.pokemonline.stats
{
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonBase
	{
		public var ID:int = 0;
		public var name:String = "";
		public var type:Array = [];
		public var catchRate:int = 0;
		public var genderRatio:Number = 0;
		public var abilities:Array = [];
		public var pokedexType:String;
		public var eggGroups:Array = [];
		public var hatchTime:Array = [];
		public var height:Array = [];
		public var weight:Array = [];
		public var regionalPokedexNumbers:Array = [];
		public var baseExperienceYield:int = 0;
		public var levellingRate:String = PokemonLevelRate.SLOW;
		public var HPEVYield:int = 0;
		public var ATKEVYield:int = 0;
		public var DEFEVYield:int = 0;
		public var SPATKEVYield:int = 0;
		public var SPDEFEVYield:int = 0;
		public var SPEEDEVYield:int = 0;
		public var bodyStyle:int = 1;
		public var footprintStyle:int = 1;
		public var pokedexColor:String = PokedexColor.BLACK;
		public var baseFriendship:int = 0;
		public var evolutions:Vector.<PokemonEvolution> = new Vector.<PokemonEvolution>();
		public var pokedexEntry:String = "";
		public var heldItems:Array = [];
		public var HPBaseStat:int = 0;
		public var ATKBaseStat:int = 0;
		public var DEFBaseStat:int = 0;
		public var SPATKBaseStat:int = 0;
		public var SPDEFBaseStat:int = 0;
		public var SPEEDBaseStat:int = 0;
		public var learnSet:Array = [];
		
		public function PokemonBase()
		{
		
		}
		
		public function movesFromLearnSetAtLevel(level:int):Vector.<String>
		{
			var moves:Vector.<String> = new Vector.<String>();
			for (var i:int = 0; i < learnSet.length; i++)
			{
				var move:Object = learnSet[i];
				if (move["level"] != null && move.level == level)
				{
					moves.push(move.move);
				}
			}
			
			return moves;
		}
		
		public function get WEIGHT_IN_POUNDS():Number
		{
			var weightData:Array = String(weight[0]).split(" ");
			return Number(weightData[0]);
		}
		
		public function get HEIGHT_IN_METERS():Number
		{
			var heightData:Array = String(height[1]).split(" ");
			return Number(heightData[0]);
		}
		
		public function isType(type1:String):Boolean
		{
			if (type[0] == type1)
				return true;
			if (type[1] != null && type[1] == type1)
				return true;
			return false;
		}
		
		public function doesMoveHaveStab(name:String):Boolean
		{
			for (var i:int = 0; i < learnSet.length; i++)
			{
				if (learnSet[i].move == name)
				{
					if (learnSet[i].stab != null && learnSet[i].stab == 1)
						return true;
				}
			}
			return false;
		}
	
	}

}