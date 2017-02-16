package com.cloakentertainment.pokemonline.ui 
{
	import mx.utils.StringUtil;
	import com.cloakentertainment.pokemonline.stats.PokemonType;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexMenuSearchOptions 
	{
		public static const DONT_SPECIFY:String = "DONT_SPECIFY";
		public static const NAME_ABC:String = "ABC";
		public static const NAME_DEF:String = "DEF";
		public static const NAME_GHI:String = "GHI";
		public static const NAME_JKL:String = "JKL";
		public static const NAME_MNO:String = "MNO";
		public static const NAME_PQR:String = "PQR";
		public static const NAME_STU:String = "STU";
		public static const NAME_WVX:String = "WVX";
		public static const NAME_YZ:String = "YZ";
		
		public static const COLOR_RED:String = "RED";
		public static const COLOR_BLUE:String = "BLUE";
		public static const COLOR_YELLOW:String = "YELLOW";
		public static const COLOR_GREEN:String = "GREEN";
		public static const COLOR_BLACK:String = "BLACK";
		public static const COLOR_BROWN:String = "BROWN";
		public static const COLOR_PURPLE:String = "PURPLE";
		public static const COLOR_GRAY:String = "GRAY";
		public static const COLOR_WHITE:String = "WHITE";
		public static const COLOR_PINK:String = "PINK";
		
		public static const ORDER_NUMERICAL:String = "ORDER_NUMERICAL";
		public static const ORDER_ATOZ:String = "ORDER_ATOZ";
		public static const ORDER_HEAVIEST:String = "ORDER_HEAVIEST";
		public static const ORDER_LIGHTEST:String = "ORDER_LIGHTEST";
		public static const ORDER_TALLEST:String = "ORDER_TALLEST";
		public static const ORDER_SMALLEST:String = "ORDER_SMALLEST";
		
		private var _name:String;
		private var _color:String;
		private var _type1:String;
		private var _type2:String;
		private var _order:String;
		private var _onlyOwned:Boolean = false;
		private var _onlySeen:Boolean = false;
		
		public function UIPokedexMenuSearchOptions(name:String, color:String, type1:String, type2:String, order:String, onlySeen:Boolean = true, onlyOwned:Boolean = false) 
		{
			_name = StringUtil.trim(name);
			_color = StringUtil.trim(color);
			_type1 = StringUtil.trim(type1);
			_type2 = StringUtil.trim(type2);
			_type1 = normalizeType(_type1);
			_type2 = normalizeType(_type2);
			_order = StringUtil.trim(order);
			_onlyOwned = onlyOwned;
			_onlySeen = onlySeen;
		}
		
		private function normalizeType(type:String):String
		{
			switch(type)
			{
				case "NORMAL":
					return PokemonType.NORMAL;
					break;
				case "FIGHT":
					return PokemonType.FIGHTING;
					break;
				case "FLYING":
					return PokemonType.FLYING;
					break;
				case "POISON":
					return PokemonType.POISON;
					break;
				case "GROUND":
					return PokemonType.GROUND;
					break;
				case "ROCK":
					return PokemonType.ROCK;
					break;
				case "BUG":
					return PokemonType.BUG;
					break;
				case "GHOST":
					return PokemonType.GHOST;
					break;
				case "STEEL":
					return PokemonType.STEEL;
					break;
				case "FIRE":
					return PokemonType.FIRE;
					break;
				case "WATER":
					return PokemonType.WATER;
					break;
				case "GRASS":
					return PokemonType.GRASS;
					break;
				case "ELECTR":
					return PokemonType.ELECTRIC;
					break;
				case "PSYCHC":
					return PokemonType.PSYCHIC
					break;
				case "ICE":
					return PokemonType.ICE;
					break;
				case "DRAGON":
					return PokemonType.DRAGON;
					break;
				case "DARK":
					return PokemonType.DARK;
					break;
				default:
					return type;
					break;
			}
		}
		
		public function get ONLY_OWNED():Boolean { return _onlyOwned; }
		public function get ONLY_SEEN():Boolean { return _onlySeen; }
		public function get NAME():String { return _name; }
		public function get COLOR():String { return _color; }
		public function get TYPE1():String { return _type1; }
		public function get TYPE2():String { return _type2; }
		public function get ORDER():String { return _order; }
		
	}

}