package com.cloakentertainment.pokemonline.trainer 
{
		public function TrainerFactory() 
		{
			
		}
		
		public static function createTrainer(trainerName:String, trainerType:String, trainerBattles:TrainerBattle...):Trainer
		{
			var battles:Vector.<TrainerBattle> = new Vector.<TrainerBattle>();
			for (var i:int = 0; i < trainerBattles.length; i++)
			{
				battles.push(trainerBattles[i]);
			}
			
			var trainer:Trainer = new Trainer(trainerName, trainerType, GUID.create(), 0, 0, 0, 0, "", null, null, null, null, null, null, battles);
		}
		
		public static function createTrainerBattle(winnings:int, pokemonNames:Array, pokemonLevels:Array):TrainerBattle
		{
			return new TrainerBattle(winnings, pokemonNames, pokemonLevels);
		}
		
	}

}