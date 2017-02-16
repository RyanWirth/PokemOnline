package com.cloakentertainment.pokemonline.stats 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonAbilities 
	{
		[Embed(source='/com/cloakentertainment/pokemonline/data/pokemon_abilities.json',mimeType='application/octet-stream')]
		private static const abilities:Class;
		private static const _abilities:Object = JSON.parse(new abilities());
		
		public function PokemonAbilities() 
		{
			
		}
		
		public static function getAbilityByID(ID:int):Object
		{
			for (var i:int = 0; i < _abilities.Abilities.length; i++)
			{
				if (_abilities.Abilities[i].ID == ID) return _abilities.Abilities[i];
			}
			
			throw(new Error('Unknown Ability ' + ID + '!'));
			return null;
		}
		
		public static function getAbilityByName(name:String):Object
		{
			for (var i:int = 0; i < _abilities.Abilities.length; i++)
			{
				if (_abilities.Abilities[i].Name == name) return _abilities.Abilities[i];
			}
			
			throw(new Error('Unknown Ability "' + name + '"!'));
			return null;
		}
		
		public static function getAbilityNameByID(ID:int):String
		{
			return getAbilityByID(ID).Name;
		}
		
		public static function getAbilityIDByName(name:String):int
		{
			return getAbilityByName(name).ID;
		}
		
		public static function getAbilityDescriptionByName(name:String):String
		{
			return getAbilityByName(name).Description;
		}
		
		public static function getAbilityDescriptionByID(ID:int):String
		{
			return getAbilityByID(ID).Description;
		}
		
	}

}