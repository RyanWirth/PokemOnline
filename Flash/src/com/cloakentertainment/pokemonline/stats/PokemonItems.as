package com.cloakentertainment.pokemonline.stats
{
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonItems
	{
		[Embed(source='/com/cloakentertainment/pokemonline/data/pokemon_items.json',mimeType='application/octet-stream')]
		private static const items:Class;
		private static const _items:Object = JSON.parse(new items());
		
		public static const TYPE_ITEMS:String = "TYPE_ITEMS";
		public static const TYPE_POKEBALLS:String = "TYPE_POKEBALLS";
		public static const TYPE_TMs_and_HMs:String = "TYPE_TMs_AND_HMs";
		public static const TYPE_BERRIES:String = "TYPE_BERRIES";
		public static const TYPE_KEY_ITEMS:String = "TYPE_KEY_ITEMS";
		
		public function PokemonItems()
		{
		
		}
		
		public static function getItemPocketByName(item:String):String
		{
			if (isItemOfType(item, TYPE_ITEMS)) return "ITEMS";
			else if (isItemOfType(item, TYPE_POKEBALLS)) return "POKéBALLS";
			else if (isItemOfType(item, TYPE_TMs_and_HMs)) return "TMs & HMs";
			else if (isItemOfType(item, TYPE_BERRIES)) return "BERRIES";
			else if (isItemOfType(item, TYPE_KEY_ITEMS)) return "KEY ITEMS";
			else return "UNKNOWN";
		}
		
		public static function isItemOfType(item:String, type:String = TYPE_ITEMS):Boolean
		{
			var actual_type:String = getItemTypeByName(item);
			switch (type)
			{
				case TYPE_ITEMS: 
					if (actual_type == "Medicine")
						return true;
					if (actual_type == "Items")
						return true;
					if (actual_type == "BattleItems")
						return true;
					
					break;
				case TYPE_POKEBALLS: 
					if (actual_type == "PokéBalls")
						return true;
					break;
				case TYPE_TMs_and_HMs: 
					if (actual_type == "TMs&HMs")
						return true;
					break;
				case TYPE_BERRIES: 
					if (actual_type == "Berry")
						return true;
					break;
				case TYPE_KEY_ITEMS: 
					if (actual_type == "KeyItems")
						return true;
					break;
			}
			switch (actual_type) // Check for known item types
			{
				case "Medicine": 
				case "Items": 
				case "BattleItems": 
				case "PokéBalls": 
				case "TMs&HMs": 
				case "Berry": 
				case "KeyItems":
					
					break;
				default: 
					trace("WARNING: Unknown Item type " + actual_type);
					break;
			}
			
			return false;
		}
		
		public static function useItemOnPokemon(pokemon:Pokemon, itemName:String, moveID:int = 0):String
		{
			var effect:String = getItemEffectByName(itemName);
			var effects:Array = effect.split(';');
			var status:String = PokemonItemStatus.CANNOT_USE;
			for (var i:int = 0; i < effects.length; i++)
			{
				var effectData:Array = String(effects[i]).split(' ');
				if (effectData[0] == "USE")
				{
					status = interpretItemUse(effectData[1], effectData, pokemon, moveID);
				}
			}
			
			return status;
		}
		
		public static function retrieveItemUsesForInBattle(itemName:String):Vector.<String>
		{
			var uses:Vector.<String> = new Vector.<String>();
			var effect:String = getItemEffectByName(itemName);
			var effects:Array = effect.split(";");
			var canUse:Boolean = false;
			for (var i:int = 0; i < effects.length; i++)
			{
				var effectData:Array = String(effects[i]).split(' ');
				if (effectData[0] == "USE")
				{
					canUse = true;
				}
			}
			
			if (canUse) uses.push("USE");
			else uses.push("");
			return uses;
		}
		
		public static function interpretItemUse(keyword:String, data:Array, pokemon:Pokemon, moveID:int = 0):String
		{
			if (keyword == "ATKEVs" || keyword == "HPEVs" || keyword == "DEFEVs" || keyword == "SPATKEVs" || keyword == "SPDEFEVs" || keyword == "SPEEDEVs")
			{
				// Change the Pokemon's EVs
				var stat:String = keyword == "ATKEVs" ? PokemonStat.ATK : (keyword == "HPEVs" ? PokemonStat.HP : (keyword == "DEFEVs" ? PokemonStat.DEF : (keyword == "SPATKEVs" ? PokemonStat.SPATK : (keyword == "SPDEFEVs" ? PokemonStat.SPDEF : (keyword == "SPEEDEVs" ? PokemonStat.SPEED : "")))));
				if (stat != "")
				{
					if (pokemon.modifyEVs(stat, int(data[2])) == false)
					{
						switch (stat)
						{
							case PokemonStat.HP: 
								return PokemonItemStatus.POKEMON_HP_STAT_MAXED;
								break;
							case PokemonStat.ATK: 
								return PokemonItemStatus.POKEMON_ATK_STAT_MAXED;
								break;
							case PokemonStat.DEF: 
								return PokemonItemStatus.POKEMON_DEF_STAT_MAXED;
								break;
							case PokemonStat.SPATK: 
								return PokemonItemStatus.POKEMON_SPATK_STAT_MAXED;
								break;
							case PokemonStat.SPDEF: 
								return PokemonItemStatus.POKEMON_SPDEF_STAT_MAXED;
								break;
							case PokemonStat.SPEED: 
								return PokemonItemStatus.POKEMON_SPEED_STAT_MAXED;
								break;
						}
					}
					else
					{
						switch (stat)
						{
							case PokemonStat.HP: 
								return PokemonItemStatus.POKEMON_HP_STAT_INCREASED;
								break;
							case PokemonStat.ATK: 
								return PokemonItemStatus.POKEMON_ATK_STAT_INCREASED;
								break;
							case PokemonStat.DEF: 
								return PokemonItemStatus.POKEMON_DEF_STAT_INCREASED;
								break;
							case PokemonStat.SPATK: 
								return PokemonItemStatus.POKEMON_SPATK_STAT_INCREASED;
								break;
							case PokemonStat.SPDEF: 
								return PokemonItemStatus.POKEMON_SPDEF_STAT_INCREASED;
								break;
							case PokemonStat.SPEED: 
								return PokemonItemStatus.POKEMON_SPEED_STAT_INCREASED;
								break;
						}
					}
				}
				else
					return PokemonItemStatus.FAILED;
			}
			else if (keyword == "RARECANDY")
			{
				if (pokemon.LEVEL < 100)
					pokemon.giveXP(pokemon.REQUIRED_XP);
				else
					return PokemonItemStatus.POKEMON_LEVEL_TOO_HIGH;
				return PokemonItemStatus.SUCCESSFUL;
			}
			else if (keyword == "CURE")
			{
				var ailment:PokemonStatusCondition;
				if (data[2] == "POISON")
					ailment = PokemonStatusConditions.POISON;
			}
			else if (keyword == "NONE")
			{
				return PokemonItemStatus.FAILED;
			}
			else if (keyword == "CURE")
			{
				switch (data[2])
				{
					case "POISON": 
						if (pokemon.getNonVolatileStatusCondition() == PokemonStatusConditions.POISON)
						{
							pokemon.setNonVolatileStatusCondition(null);
							return PokemonItemStatus.SUCCESSFUL;
						}
						else
							return PokemonItemStatus.FAILED;
						break;
					case "SLEEP": 
						if (pokemon.getNonVolatileStatusCondition() == PokemonStatusConditions.SLEEP)
						{
							pokemon.setNonVolatileStatusCondition(null);
							return PokemonItemStatus.SUCCESSFUL;
						}
						else
							return PokemonItemStatus.FAILED;
						break;
					case "BURN": 
						if (pokemon.getNonVolatileStatusCondition() == PokemonStatusConditions.BURN)
						{
							pokemon.setNonVolatileStatusCondition(null);
							return PokemonItemStatus.SUCCESSFUL;
						}
						else
							return PokemonItemStatus.FAILED;
						break;
					case "PARALYSIS": 
						if (pokemon.getNonVolatileStatusCondition() == PokemonStatusConditions.PARALYSIS)
						{
							pokemon.setNonVolatileStatusCondition(null);
							return PokemonItemStatus.SUCCESSFUL;
						}
						else
							return PokemonItemStatus.FAILED;
						break;
					case "FREEZE": 
						if (pokemon.getNonVolatileStatusCondition() == PokemonStatusConditions.FREEZE)
						{
							pokemon.setNonVolatileStatusCondition(null);
							return PokemonItemStatus.SUCCESSFUL;
						}
						else
							return PokemonItemStatus.FAILED;
						break;
					case "CONFUSION": 
						if (pokemon.isStatusConditionActive(PokemonStatusConditions.CONFUSION))
						{
							pokemon.removeVolatileStatusCondition(PokemonStatusConditions.CONFUSION);
							return PokemonItemStatus.SUCCESSFUL;
						}
						else
							return PokemonItemStatus.FAILED;
						break;
					case "INFATUATION": 
						if (pokemon.isStatusConditionActive(PokemonStatusConditions.INFATUATION))
						{
							pokemon.removeVolatileStatusCondition(PokemonStatusConditions.INFATUATION);
							return PokemonItemStatus.SUCCESSFUL;
						}
						else
							return PokemonItemStatus.FAILED;
						break;
				}
			}
			else if (keyword == "CRITHITRATIO")
			{
				if (pokemon.ACTIVE)
				{
					trace("CRITHITRATIO: " + data[2]);
					
				}
				else
					return PokemonItemStatus.FAILED;
			}
			
			trace("WARNING: Unknown Keyword " + keyword + " when using item!");
			
			return PokemonItemStatus.FAILED;
		}
		
		public static function getItemByName(name:String):Object
		{
			for (var i:int = 0; i < _items.Items.length; i++)
			{
				if (_items.Items[i].Name == name)
					return _items.Items[i];
			}
			
			throw(new Error('Unknown Item "' + name + '"!'));
			return null;
		}
		
		public static function getItemPriceByName(name:String):int
		{
			return getItemByName(name).Price;
		}
		
		public static function getItemSellPriceByName(name:String):int
		{
			return getItemByName(name).Sell;
		}
		
		public static function getBerryIDByName(name:String):int
		{
			return getItemByName(name).ID;
		}
		
		public static function getItemTypeByName(name:String):String
		{
			return getItemByName(name).Type;
		}
		
		public static function getItemEffectByName(name:String):String
		{
			return getItemByName(name).Effect;
		}
		
		public static function getItemDescriptionByName(name:String):String
		{
			return String(getItemByName(name).Description).replace("Pokémon", "POKéMON");
		}
		
		public static function getItemSpriteNameByName(name:String):String
		{
			return getItemByName(name).SpriteName;
		}
		
		public static function getBerryTagDescriptionByName(name:String):String
		{
			return getItemByName(name).TagDescription;
		}
		
		public static function getBerrySizesByName(name:String):Array
		{
			return getItemByName(name).Size;
		}
		
		public static function getBerryFirmnessByName(name:String):String
		{
			return getItemByName(name).Firmness;
		}
		
		public static function getBerryFlavourByName(name:String):String
		{
			return getItemByName(name).Flavour;
		}
		
		public static function getItemsByType(type:String):Vector.<Object>
		{
			var T:Vector.<Object> = new Vector.<Object>();
			for (var i:int = 0; i < _items.Items.length; i++)
			{
				if (_items.Items[i].Type == type)
					T.push(_items.Items[i]);
			}
			return T;
		}
	
	}

}