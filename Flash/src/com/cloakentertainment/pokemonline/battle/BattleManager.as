package com.cloakentertainment.pokemonline.battle 
{
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.Configuration
	import com.cloakentertainment.pokemonline.trainer.Trainer;
	import com.cloakentertainment.pokemonline.trainer.TrainerBadge;
	import com.cloakentertainment.pokemonline.ui.UIGreyFlicker;
	import com.cloakentertainment.pokemonline.world.PlayerManager;
	import com.cloakentertainment.pokemonline.world.region.RegionManager;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.world.map.ChunkManager;
	import com.cloakentertainment.pokemonline.world.entity.EntityManager;
	import com.cloakentertainment.pokemonline.stats.PokemonFactory;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.cloakentertainment.pokemonline.world.sprite.STeamLogoEffect;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import com.greensock.TweenLite;
	import io.arkeus.tiled.TiledObject;
	/**
	 * ...
	 * @author ...
	 */
	public class BattleManager 
	{
		private static var _battle:Battle;
		
		private static var _battleType:String;
		private static var _allyPokemonVector:Vector.<Pokemon>;
		private static var _enemyPokemonVector:Vector.<Pokemon>;
		private static var _allyTrainerVector:Vector.<Trainer>;
		private static var _enemyTrainerVector:Vector.<Trainer>;
		private static var _battleSpecialTile:String;
		private static var _battleWeatherEffect:String;
		
		private static var _uiGreyFlicker:UIGreyFlicker;
		private static var _tutorialBattle:Boolean;
		private static var _finishBattleCallback:Function;
		private static var _finishBattleCallbackParams:Array;
		private static var _sTeamLogoEffect:STeamLogoEffect;
		
		public function BattleManager() 
		{
			
		}
		
		public static function isBattleOccuring():Boolean
		{
			if (_uiGreyFlicker) return true;
			else return _battle == null ? false : true;
		}
		
		public static function startWallyTutorialBattle(finishCallback:Function, finishCallbackParams:Array):void
		{
			var wildPokemon:Pokemon = PokemonFactory.createPokemon("Ralts", 5, "Route 102");
			var enemyPokemon:Vector.<Pokemon> = new Vector.<Pokemon>();
			enemyPokemon.push(wildPokemon);
			
			var allyPokemonVector:Vector.<Pokemon> = new Vector.<Pokemon>();
			var ourPokemon:Pokemon = PokemonFactory.createPokemon("Zigzagoon", 7, "Petalburg Gym");
			var trainer:Trainer = new Trainer("WALLY", TrainerType.WALLY, "", 0, 0, 0, 0, "OVERWORLD", null, null, null, null, null, null, null);
			ourPokemon.setTrainer(trainer);
			ourPokemon.setOTName(trainer.NAME);
			allyPokemonVector.push(ourPokemon);
			trainer.updateParty(allyPokemonVector);
			
			var trainerVector:Vector.<Trainer> = new Vector.<Trainer>();
			trainerVector.push(trainer);
			
			SoundManager.playMusicTrack(109, 0, false, true);
			
			_finishBattleCallback = finishCallback;
			_finishBattleCallbackParams = finishCallbackParams;
			_battleType = BattleType.WILD;
			_allyPokemonVector = allyPokemonVector;
			_enemyPokemonVector = enemyPokemon;
			_allyTrainerVector = trainerVector;
			_enemyTrainerVector = null;
			_battleSpecialTile = BattleSpecialTile.PLAIN;
			_battleWeatherEffect = BattleWeatherEffect.CLEAR_SKIES;
			
			_uiGreyFlicker = new UIGreyFlicker(removeGreyFlicker, 6, 0.1666666);
			Configuration.STAGE.addChild(_uiGreyFlicker);
			
			TweenLite.delayedCall(2, ChunkManager.animateIntoBattle);
			TweenLite.delayedCall(2.5, Configuration.FADE_OUT_AND_IN, [createBattle, false], false);
		}
		
		public static function startMinorTrainerBattle(subcommandData:Array, finishCallback:Function, finishCallbackParams:Array, battleSpecialTile:String = BattleSpecialTile.PLAIN, battleWeatherEffect:String = BattleWeatherEffect.CLEAR_SKIES, battleType:String = BattleType.TRAINER):void
		{
			if (_battle) return;
			
			var data:String = "startbattle::" + subcommandData[1] + "::" + subcommandData[4] + "::" + subcommandData[3] + "::";
			var pokemonArray:Array = String(subcommandData[5]).split("-");
			for (var i:int = 0; i < pokemonArray.length; i++)
			{
				data += pokemonArray[i] + ",auto,,auto,auto,auto,auto" + (i == pokemonArray.length - 1 ? "" : "::");
			}
			var trainerItems:Array;
			if (subcommandData.length > 6)
			{
				trainerItems = String(subcommandData[6]).split(",");
			}
			startTrainerBattle(subcommandData[2], data.split("::"), finishCallback, finishCallbackParams, battleSpecialTile, battleWeatherEffect, trainerItems, battleType);
		}
		
		public static function startTrainerBattle(trainerType:String, battleData:Array, finishCallback:Function, finishCallbackParams:Array, battleSpecialTile:String = BattleSpecialTile.PLAIN, battleWeatherEffect:String = BattleWeatherEffect.CLEAR_SKIES, trainerItems:Array = null, battleType:String = BattleType.TRAINER):void
		{
			if (_battle) return;
			_finishBattleCallbackParams = finishCallbackParams;
			_finishBattleCallback = finishCallback;
			
			var enemyPokemon:Vector.<Pokemon> = new Vector.<Pokemon>();
			
			var enemyVector:Vector.<Trainer> = new Vector.<Trainer>();
			var badges:Vector.<String> = new Vector.<String>();
			badges.push(TrainerBadge.BALANCE, TrainerBadge.DYNAMO, TrainerBadge.FEATHER, TrainerBadge.HEAT, TrainerBadge.KNUCKLE, TrainerBadge.MIND, TrainerBadge.RAIN, TrainerBadge.STONE);
			enemyVector.push(new Trainer(battleData[1], trainerType, "", 0, int(battleData[2]), -1, -1, "OVERWORLD", null, null, badges, null, null, enemyPokemon));
			enemyVector[0].prepareTrainerBattle(battleData[3]);
			
			for (var i:int = 4; i < battleData.length; i++)
			{
				if (battleData[i] == null || battleData[i] == "") continue;
				var pokemon:Pokemon = PokemonFactory.createPokemonFromData(battleData[i]);
				pokemon.setTrainer(enemyVector[0]);
				pokemon.setOTName(enemyVector[0].NAME);
				enemyPokemon.push(pokemon);
			}
			
			if (trainerItems)
			{
				for (var j:int = 0; j < trainerItems.length; j++)
				{
					enemyVector[0].giveItem(trainerItems[j]);
				}
			}
			
			var trainerVector:Vector.<Trainer> = new Vector.<Trainer>();
			trainerVector.push(Configuration.ACTIVE_TRAINER);
			
			Configuration.ACTIVE_TRAINER.enterBattle();
			var allyPokemonVector:Vector.<Pokemon> = Configuration.ACTIVE_TRAINER.getTemporaryParty();
			
			_battleType = battleType;
			_allyPokemonVector = allyPokemonVector;
			_enemyPokemonVector = enemyPokemon;
			_allyTrainerVector = trainerVector;
			_enemyTrainerVector = enemyVector;
			_battleSpecialTile = battleSpecialTile;
			_battleWeatherEffect = battleWeatherEffect;
			
			_uiGreyFlicker = new UIGreyFlicker(removeGreyFlicker, 6, 0.1666666);
			Configuration.STAGE.addChild(_uiGreyFlicker);
			
			switch(trainerType)
			{
				case TrainerType.AQUA_ADMIN_FEMALE:
				case TrainerType.AQUA_ADMIN_MALE:
				case TrainerType.AQUA_LEADER_MALE:
				case TrainerType.TEAM_AQUA_GRUNT_FEMALE:
				case TrainerType.TEAM_AQUA_GRUNT_MALE:
					_sTeamLogoEffect = new STeamLogoEffect("aqua");
					break;
				case TrainerType.MAGMA_ADMIN_FEMALE:
				case TrainerType.MAGMA_ADMIN_MALE:
				case TrainerType.MAGMA_LEADER_MALE:
				case TrainerType.TEAM_MAGMA_GRUNT_FEMALE:
				case TrainerType.TEAM_MAGMA_GRUNT_MALE:
					_sTeamLogoEffect = new STeamLogoEffect("magma");
					break;
			}
			if (_sTeamLogoEffect)
			{
				WorldManager.RENDERER.addChild(_sTeamLogoEffect);
			}
			
			TweenLite.delayedCall(2, ChunkManager.animateIntoBattle);
			TweenLite.delayedCall(2.5, Configuration.FADE_OUT_AND_IN, [createBattle, false], false);
		}
		
		public static function startWildBattle(wildPokemon:Pokemon, battleSpecialTile:String = BattleSpecialTile.PLAIN, battleWeatherEffect:String = BattleWeatherEffect.CLEAR_SKIES, afterStartingCallback:Function = null, tutorialBattle:Boolean = false, afterWinningCallback:Function = null):void
		{
			if (_battle) return;
			_tutorialBattle = tutorialBattle;
			_finishBattleCallback = afterWinningCallback;
			
			var wildPokemonVector:Vector.<Pokemon> = new Vector.<Pokemon>();
			wildPokemonVector.push(wildPokemon);
			
			var trainerVector:Vector.<Trainer> = new Vector.<Trainer>();
			trainerVector.push(Configuration.ACTIVE_TRAINER);
			
			Configuration.ACTIVE_TRAINER.enterBattle();
			var allyPokemonVector:Vector.<Pokemon> = Configuration.ACTIVE_TRAINER.getTemporaryParty();
			
			SoundManager.playMusicTrack(109, 0, false, true);
			
			_battleType = BattleType.WILD;
			_allyPokemonVector = allyPokemonVector;
			_enemyPokemonVector = wildPokemonVector;
			_allyTrainerVector = trainerVector;
			_enemyTrainerVector = null;
			_battleSpecialTile = battleSpecialTile;
			_battleWeatherEffect = battleWeatherEffect;
			
			_uiGreyFlicker = new UIGreyFlicker(removeGreyFlicker, 6, 0.166666);
			Configuration.STAGE.addChild(_uiGreyFlicker);
			
			if (afterStartingCallback != null) TweenLite.delayedCall(3, afterStartingCallback);
			TweenLite.delayedCall(2, ChunkManager.animateIntoBattle);
			TweenLite.delayedCall(2.5, Configuration.FADE_OUT_AND_IN, [createBattle, false], false);
		}
		
		private static function removeGreyFlicker():void
		{
			Configuration.STAGE.removeChild(_uiGreyFlicker);
			_uiGreyFlicker.destroy();
			_uiGreyFlicker = null;
		}
		
		private static function createBattle():void
		{
			if (_sTeamLogoEffect)
			{
				WorldManager.RENDERER.removeChild(_sTeamLogoEffect, true);
				_sTeamLogoEffect = null;
			}
			
			_battle = new Battle(_battleType, _allyPokemonVector, _enemyPokemonVector, _allyTrainerVector, _enemyTrainerVector, _battleSpecialTile, _battleWeatherEffect, finishBattle, _tutorialBattle);
			_tutorialBattle = false;
			MemoryTracker.track(_battle, "BATTLE");
			Configuration.fixFPSCounter();
		}
		
		private static function finishBattle(moveToPokemonCenter:Boolean = false):void
		{
			_battle.destroy();
			_battle = null;
			MemoryTracker.gcAndCheck();
			
			if(PlayerManager.PLAYER) PlayerManager.PLAYER.setMobility(true);
			RegionManager.playNewMusic();
			Configuration.ACTIVE_TRAINER.exitBattle();
			
			_allyPokemonVector = null;
			_enemyPokemonVector = null;
			_allyTrainerVector = null;
			_enemyTrainerVector = null;
			
			if (_finishBattleCallback != null && !moveToPokemonCenter) 
			{
				if (_finishBattleCallbackParams) TweenLite.delayedCall(0, _finishBattleCallback, _finishBattleCallbackParams);
				else _finishBattleCallback();
			}
			
			if (moveToPokemonCenter && _battleType == BattleType.TRAINER)
			{
				var e:TiledObject = _finishBattleCallbackParams[0] as TiledObject;
				e.commands = null;
			}
			
			_finishBattleCallbackParams = null;
			_finishBattleCallback = null;
		}
		
	}

}