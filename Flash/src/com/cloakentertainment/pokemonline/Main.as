package com.cloakentertainment.pokemonline
{
	import flash.display.Sprite;
	import com.cloakentertainment.pokemonline.multiplayer.AccountManager;
	import flash.display.StageQuality;
	import flash.events.Event;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.trainer.Trainer;
	import com.cloakentertainment.pokemonline.trainer.TrainerBattle;
	import com.cloakentertainment.pokemonline.multiplayer.AccountStatus;
	import com.cloakentertainment.pokemonline.trainer.TrainerBadge;
	import com.cloakentertainment.pokemonline.stats.PokemonFactory;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class Main extends Sprite
	{
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//stage.quality = StageQuality.LOW;
			
			var configuration:Configuration = new Configuration(stage);
			
			GameManager.enterOverworld();
			
			return;
			
			//stage.addEventListener(MouseEvent.CLICK, clickOn);
			
			// entry point
			
			//AccountManager.retrieveAccount("PROWNE", "297029002", accountRetrieved);
			
			/*var playersPokemon:Pokemon = PokemonFactory.createPokemon("", 100);
			   var tempPokemon:Pokemon = PokemonFactory.createPokemon("", 100);
			   var replacementPokemon:Pokemon = PokemonFactory.createPokemon("", 100);
			   //var enemysPokemon:Pokemon = PokemonFactory.createPokemon("", 100);
			
			   playersPokemon.giveXP(playersPokemon.REQUIRED_XP - 200);
			   playersPokemon.setOTName("RYE");
			   playersPokemon.setTrainer(player);
			   //playersPokemon.setHeldItem("Sitrus Berry");
			   //playersPokemon.setNonVolatileStatusCondition(PokemonStatusConditions.FAINT);
			   playersPokemon.activate();
			
			   tempPokemon.setOTName("RYE");
			   tempPokemon.setTrainer(player);
			
			   replacementPokemon.setOTName("RYE");
			   replacementPokemon.setTrainer(player);
			
			   currentParty.push(playersPokemon, replacementPokemon, tempPokemon);
			   player.updateParty(currentParty);
			
			   //var pokemon:UIPokemonSprite = new UIPokemonSprite(261, false);
			   //pokemon.animateStatChange(PokemonStat.ATK, true);
			   //this.addChild(pokemon);
			
			   //var pokemon:UIPokemonBackSprite = new UIPokemonBackSprite(261, false);
			   //pokemon.graphics.beginFill(0x000000, 0.25);
			   //pokemon.graphics.drawRect(0, 0, 64 * Configuration.SPRITE_SCALE, 64 * Configuration.SPRITE_SCALE);
			   //pokemon.graphics.endFill();
			   //this.addChild(pokemon);
			   //Configuration.createMenu(MenuType.IN_GAME_MENU);
			
			   //	MessageCenter.addMessage(Message.createMessage("Well, hello there.", false, Configuration.MESSAGE_DELAY));
			   //	MessageCenter.addMessage(Message.createMessage("Do you quarrel, sir? Lorem ipsum trolo wolo I don't know what I'm saying but I'm just going to keep typing to fill up this textbox and see if the multiline crap actually works.", false, Configuration.MESSAGE_DELAY));
			   //	MessageCenter.addMessage(Message.createQuestion("Do you understand?", questionCallback, "Yes", "No", "I didn't ask for this"));
			   //return;
			
			   allyTrainers.push(player);
			
			   trace(playersPokemon);
			   trace(replacementPokemon);
			   trace(tempPokemon);
			
			   allyPokemon.push(playersPokemon, replacementPokemon, tempPokemon);
			
			   enemy.loadBattle(1);
			   enemyTrainers.push(enemy);
			
			   enemyPokemon.push(enemy.getPokemon(0), enemy.getPokemon(1), enemy.getPokemon(2), enemy.getPokemon(3), enemy.getPokemon(4), enemy.getPokemon(5));
			
			   //battle = new Battle(BattleType.TRAINER, allyPokemon, enemyPokemon, allyTrainers, enemyTrainers);
			   //battle.main = this;
			
			   //AccountManager.authenticate("PROWNE", "297029002", saveAccount);
			   AccountManager.createAccount("PROWNE", "297029002", player, null);
			   AccountManager.registerPokemon(playersPokemon);
			   AccountManager.registerPokemon(replacementPokemon);
			   AccountManager.registerPokemon(tempPokemon);*/
			//Configuration.createMenu(MenuType.LOGIN);
		
			//applyMoveMoves();
		/*for (var i:int = 0; i < 8; i++)
		   {
		   //battle.transmitAction(BattleAction.generateMove(allyPokemon[0], PokemonMoves.getMoveIDByName(allyPokemon[0].getRandomMove())));
		   battle.transmitAction(BattleAction.generateMove(allyPokemon[0], 1));
		   //battle.transmitAction(BattleAction.generateMove(enemyPokemon[0], 68));
		   battle.transmitAction(BattleAction.generateMove(enemyPokemon[0], PokemonMoves.getMoveIDByName(enemyPokemon[0].getRandomMove())));
		   }*/
		}
		
		private function accountRetrieved():void
		{
			trace("Account retrieved.");
			trace(Configuration.ACTIVE_TRAINER.ENCODE_INTO_STRING());
			trace(Configuration.ACTIVE_TRAINER.getPokemon(0));
			trace(Configuration.ACTIVE_TRAINER.getPokemon(1));
			trace(Configuration.ACTIVE_TRAINER.getPokemon(2));
		}
		
		private function saveAccount(statusCode:String):void
		{
			if (statusCode != AccountStatus.AUTHENTICATION_FAILED) AccountManager.saveAccount("PROWNE", "297029002", Configuration.ACTIVE_TRAINER, null);
			else trace("Failed.");
		}
	
	}

}