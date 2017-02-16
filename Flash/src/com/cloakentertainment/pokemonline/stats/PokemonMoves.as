package com.cloakentertainment.pokemonline.stats
{
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonMoves
	{
		[Embed(source='/com/cloakentertainment/pokemonline/data/pokemon_moves.json',mimeType='application/octet-stream')]
		private static const moves:Class;
		private static const _moves:Object = JSON.parse(new moves());
		
		public function PokemonMoves()
		{
			for (var i:int = 0; i < _moves.Moves.length; i++)
			{
				if (_moves.Moves[i].Category == "Physical" || _moves.Moves[i].Category == "Special")
				{
					if (_moves.Moves[i].Power == 0)
						trace("MOVE " + (i + 1) + " has Power of 0!");
				}
			}
		}
		
		public static function getMoveNameByID(ID:int):String
		{
			if (ID == 0)
				return "Unknown";
			return getMoveByID(ID).Name;
		}
		
		public static function getMoveByID(ID:int):Object
		{
			if (ID == 0)
				ID = 999;
			for (var i:uint = 0; i < _moves.Moves.length; i++)
			{
				if (_moves.Moves[i].ID == ID)
					return _moves.Moves[i];
			}
			
			throw(new Error('Move ' + ID + ' not found!'));
			return null;
		}
		
		public static function getMoveByName(name:String):Object
		{
			for (var i:uint = 0; i < _moves.Moves.length; i++)
			{
				if (_moves.Moves[i].Name == name)
					return _moves.Moves[i];
			}
			
			throw(new Error('Move "' + name + '" not found!'));
			return null;
		}
		
		public static function getMoveIDByName(name:String):int
		{
			return getMoveByName(name).ID;
		}
		
		public static function getMovePriorityByID(ID:int):int
		{
			return getMoveByID(ID).Priority;
		}
		
		public static function getMoveTypeByID(ID:int):String
		{
			return String(getMoveByID(ID).Type).toLowerCase();
		}
		
		public static function getMoveCategoryByID(ID:int):String
		{
			return getMoveByID(ID).Category;
		}
		
		public static function getMoveContestByID(ID:int):String
		{
			return getMoveByID(ID).Contest;
		}
		
		public static function getMoveAppealByID(ID:int):String
		{
			return getMoveByID(ID).Appeal;
		}
		
		public static function getMoveJamByID(ID:int):String
		{
			return getMoveByID(ID).Jam;
		}
		
		public static function getMovePPByID(ID:int):int
		{
			return getMoveByID(ID).PP;
		}
		
		public static function getMoveMaxPPByID(ID:int):int
		{
			return getMoveByID(ID).MaxPP;
		}
		
		public static function getMovePowerByID(ID:int):int
		{
			return getMoveByID(ID).Power;
		}
		
		public static function getMoveAccuracyByID(ID:int):Number
		{
			return Number(getMoveByID(ID).Accuracy);
		}
		
		public static function getMoveContactByID(ID:int):Boolean
		{
			return getMoveByID(ID).Contact;
		}
		
		public static function getMoveProtectByID(ID:int):Boolean
		{
			return getMoveByID(ID).Protect;
		}
		
		public static function getMoveMagicCoatByID(ID:int):Boolean
		{
			return getMoveByID(ID).MagicCoat;
		}
		
		public static function getMoveSnatchByID(ID:int):Boolean
		{
			return getMoveByID(ID).Snatch;
		}
		
		public static function getMoveMirrorMoveByID(ID:int):Boolean
		{
			return getMoveByID(ID).MirrorMove;
		}
		
		public static function getMoveKingsRockByID(ID:int):Boolean
		{
			return getMoveByID(ID).KingsRock;
		}
		
		public static function getMoveDescriptionByID(ID:int):String
		{
			var description:String = getMoveByID(ID).Description;
			description = description.replace("Attack", "ATTACK").replace("Defense", "DEFENSE").replace("Sp. Def", "SP. DEF").replace("Sp. Atk", "SP. ATK").replace("Speed", "SPEED");
			return description;
		}
	
	}

}