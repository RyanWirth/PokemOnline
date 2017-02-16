package com.cloakentertainment.pokemonline.stats
{
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonEffectiveness
	{
		public static const NORMAL:Number = 1.0;
		public static const HALF:Number = 0.5;
		public static const QUARTER:Number = 0.25;
		public static const DOUBLE:Number = 2.0;
		public static const QUADRUPLE:Number = 4.0;
		public static const ZERO:Number = 0.0;
		
		public function PokemonEffectiveness()
		{
		
		}
		
		public static function getTypeEffectiveness(attackType:String, defendingPokemon:Pokemon):Number
		{
			if (defendingPokemon.base.type.length == 1) return getEffectiveness(attackType, defendingPokemon.base.type[0]);
			else return getEffectiveness(attackType, defendingPokemon.base.type[0], defendingPokemon.base.type[1]);
		}
		
		public static function getTypesThatResist(attackType:String):Vector.<String>
		{
			var types:Vector.<String> = new Vector.<String>();
			if (getEffectiveness(attackType, PokemonType.NORMAL) < 1) types.push(PokemonType.NORMAL);
			if (getEffectiveness(attackType, PokemonType.BUG) < 1) types.push(PokemonType.BUG);
			if (getEffectiveness(attackType, PokemonType.DARK) < 1) types.push(PokemonType.DARK);
			if (getEffectiveness(attackType, PokemonType.DRAGON) < 1) types.push(PokemonType.DRAGON);
			if (getEffectiveness(attackType, PokemonType.ELECTRIC) < 1) types.push(PokemonType.ELECTRIC);
			if (getEffectiveness(attackType, PokemonType.FIGHTING) < 1) types.push(PokemonType.FIGHTING);
			if (getEffectiveness(attackType, PokemonType.FIRE) < 1) types.push(PokemonType.FIRE);
			if (getEffectiveness(attackType, PokemonType.FLYING) < 1) types.push(PokemonType.FLYING);
			if (getEffectiveness(attackType, PokemonType.GHOST) < 1) types.push(PokemonType.GHOST);
			if (getEffectiveness(attackType, PokemonType.GRASS) < 1) types.push(PokemonType.GRASS);
			if (getEffectiveness(attackType, PokemonType.GROUND) < 1) types.push(PokemonType.GROUND);
			if (getEffectiveness(attackType, PokemonType.ICE) < 1) types.push(PokemonType.ICE);
			if (getEffectiveness(attackType, PokemonType.PSYCHIC) < 1) types.push(PokemonType.PSYCHIC);
			if (getEffectiveness(attackType, PokemonType.POISON) < 1) types.push(PokemonType.POISON);
			if (getEffectiveness(attackType, PokemonType.ROCK) < 1) types.push(PokemonType.ROCK);
			if (getEffectiveness(attackType, PokemonType.STEEL) < 1) types.push(PokemonType.STEEL);
			if (getEffectiveness(attackType, PokemonType.WATER) < 1) types.push(PokemonType.WATER);
			return types;
		}
		
		public static function getEffectiveness(attackType:String, defenseType1:String, defenseType2:String = PokemonType.NONE):Number
		{
			switch (defenseType1)
			{
				case PokemonType.NORMAL: 
					return normalEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.FIRE:
					return fireEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.WATER:
					return waterEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.ELECTRIC:
					return electricEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.FIGHTING:
					return fightingEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.FLYING:
					return flyingEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.GHOST:
					return ghostEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.GRASS:
					return grassEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.GROUND:
					return groundEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.ICE:
					return iceEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.POISON:
					return poisonEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.PSYCHIC:
					return psychicEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.ROCK:
					return rockEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.STEEL:
					return steelEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.BUG:
					return bugEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.DRAGON:
					return dragonEffectiveness(attackType, defenseType2);
					break;
				case PokemonType.DARK:
					return darkEffectiveness(attackType, defenseType2);
					break;
			}
			throw(new Error('Unknown type "' + defenseType1 + '"!'));
			return NORMAL;
		}
		
		public static function normalEffectiveness(attackType:String, defenseType2:String):Number
		{
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function fireEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return QUADRUPLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.WATER)
						return QUADRUPLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
			}
			return NORMAL;
		}
		
		public static function waterEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.WATER)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return QUADRUPLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUADRUPLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.WATER)
						return QUARTER;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
			}
			return NORMAL;
		}
		
		public static function electricEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return QUARTER;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return QUARTER;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return QUARTER;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return QUARTER;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
			}
			return NORMAL;
		}
		
		public static function grassEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.WATER)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return QUARTER;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return QUADRUPLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return HALF;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return QUADRUPLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return QUARTER;
					if (attackType == PokemonType.FLYING)
						return QUADRUPLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.WATER)
						return QUARTER;
					if (attackType == PokemonType.ELECTRIC)
						return QUARTER;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return QUADRUPLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function iceEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return QUADRUPLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function fightingEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return QUADRUPLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return QUADRUPLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUARTER;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return QUADRUPLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return QUARTER;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return QUARTER;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function poisonEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return QUADRUPLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function groundEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return QUADRUPLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return HALF;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUARTER;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return QUADRUPLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return QUADRUPLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUARTER;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function flyingEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return QUADRUPLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function psychicEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return QUADRUPLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return QUADRUPLE;
					if (attackType == PokemonType.DARK)
						return QUADRUPLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return QUADRUPLE;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function bugEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return QUARTER;
					if (attackType == PokemonType.FLYING)
						return QUADRUPLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return QUADRUPLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUADRUPLE;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function rockEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.WATER)
						return QUADRUPLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUADRUPLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return QUARTER;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return QUADRUPLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return QUADRUPLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return QUADRUPLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return QUARTER;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return QUARTER;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function ghostEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return QUADRUPLE;
					if (attackType == PokemonType.DARK)
						return QUADRUPLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function dragonEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.WATER)
						return QUARTER;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return QUARTER;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.WATER)
						return QUARTER;
					if (attackType == PokemonType.ELECTRIC)
						return QUARTER;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return QUADRUPLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUARTER;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function darkEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return QUADRUPLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return QUARTER;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return QUADRUPLE;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return HALF;
					if (attackType == PokemonType.FLYING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.ROCK)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return DOUBLE;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.FIRE)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return DOUBLE;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.BUG)
						return DOUBLE;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return DOUBLE;
					if (attackType == PokemonType.DARK)
						return HALF;
					break;
				case PokemonType.STEEL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
		
		public static function steelEffectiveness(attackType:String, defenseType2:String):Number
		{
			
			switch (defenseType2)
			{
				case PokemonType.NONE: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.NORMAL: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return ZERO;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.FIRE: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
				case PokemonType.WATER: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
				case PokemonType.ELECTRIC: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return QUARTER;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return QUARTER;
					break;
				case PokemonType.GRASS: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ICE: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					break;
				case PokemonType.FIGHTING: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return QUARTER;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.POISON: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.GROUND: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return ZERO;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return QUARTER;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.FLYING: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.ELECTRIC)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return ZERO;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.PSYCHIC: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.BUG: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return QUADRUPLE;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.ROCK: 
					if (attackType == PokemonType.NORMAL)
						return QUARTER;
					if (attackType == PokemonType.WATER)
						return DOUBLE;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return QUADRUPLE;
					if (attackType == PokemonType.FLYING)
						return QUARTER;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					break;
				case PokemonType.GHOST: 
					if (attackType == PokemonType.NORMAL)
						return ZERO;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return ZERO;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return QUARTER;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return DOUBLE;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.DARK)
						return DOUBLE;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.DRAGON: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.WATER)
						return HALF;
					if (attackType == PokemonType.ELECTRIC)
						return HALF;
					if (attackType == PokemonType.GRASS)
						return QUARTER;
					if (attackType == PokemonType.FIGHTING)
						return DOUBLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return HALF;
					if (attackType == PokemonType.BUG)
						return HALF;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
				case PokemonType.DARK: 
					if (attackType == PokemonType.NORMAL)
						return HALF;
					if (attackType == PokemonType.FIRE)
						return DOUBLE;
					if (attackType == PokemonType.GRASS)
						return HALF;
					if (attackType == PokemonType.ICE)
						return HALF;
					if (attackType == PokemonType.FIGHTING)
						return QUADRUPLE;
					if (attackType == PokemonType.POISON)
						return ZERO;
					if (attackType == PokemonType.GROUND)
						return DOUBLE;
					if (attackType == PokemonType.FLYING)
						return HALF;
					if (attackType == PokemonType.PSYCHIC)
						return ZERO;
					if (attackType == PokemonType.ROCK)
						return HALF;
					if (attackType == PokemonType.GHOST)
						return HALF;
					if (attackType == PokemonType.DRAGON)
						return HALF;
					if (attackType == PokemonType.DARK)
						return HALF;
					if (attackType == PokemonType.STEEL)
						return HALF;
					break;
			}
			return NORMAL;
		}
	
	}

}