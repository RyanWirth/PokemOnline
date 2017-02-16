package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.ui.MessageCenter;
	import com.cloakentertainment.pokemonline.ui.Message;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.cloakentertainment.pokemonline.GameManager;
	import com.cloakentertainment.pokemonline.world.map.MapType;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UICreateAccountMenu extends Sprite implements UIElement
	{	
		private var _topBar:UICreateAccountMenuTopBar;
		private var _ground:UICreateAccountMenuGround;
		private var _birch:UICreateAccountMenuBirch;
		
		private var _textBar:UICreateAccountTextBar;
		
		public function UICreateAccountMenu() 
		{
			construct();
		}
		
		public function construct():void
		{
			SoundManager.playMusicTrack(104);
			
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, Configuration.VIEWPORT.width, Configuration.VIEWPORT.height);
			this.graphics.endFill();
			
			_topBar = new UICreateAccountMenuTopBar();
			this.addChild(_topBar);
			
			_ground = new UICreateAccountMenuGround();
			_ground.x = 56 * Configuration.SPRITE_SCALE;
			_ground.y = 72 * Configuration.SPRITE_SCALE;
			this.addChild(_ground);
			
			_birch = new UICreateAccountMenuBirch();
			_birch.x = 57 * Configuration.SPRITE_SCALE;
			_birch.y = 6 * Configuration.SPRITE_SCALE;
			this.addChild(_birch);
			
			_topBar.alpha = 0;
			_ground.alpha = 0;
			_birch.alpha = 0;
			
			TweenLite.to(_topBar, 1, { alpha:1 } );
			TweenLite.delayedCall(5, tweenInGround);
		}
		
		private function tweenInGround():void
		{
			TweenLite.to(_ground, 2, { alpha:1 } );
			TweenLite.to(_birch, 2, { alpha:1, onComplete:createInitialMessages } );
		}
		
		private function createInitialMessages():void
		{
			_textBar = new UICreateAccountTextBar();
			_textBar.x = 1 * Configuration.SPRITE_SCALE;
			_textBar.y = Configuration.VIEWPORT.height - _textBar.height - 3 * Configuration.SPRITE_SCALE;
			this.addChild(_textBar);
			
			MessageCenter.addMessage(Message.createMessage("Hi! Sorry to keep you waiting!", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("Welcome to the world of POKéMON!", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("My name is BIRCH.", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("But everyone calls me the POKéMON PROFESSOR.", true, 0, sendOutPokemon, 23));
			MessageCenter.addMessage(Message.createMessage('This is what we call a "POKéMON."', true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("This world is widely inhabited by creatures known as POKéMON.", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("We humans live alongside POKéMON, at times as friendly playmates, and at times as cooperative workmates.", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("And sometimes, we band together and battle others like us.", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("But despite our closeness, we don't know everything about POKéMON.", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("In fact, there are many, many secrets surrounding POKéMON.", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("To unravel POKéMON mysteries, I've been undertaking research.\nThat's what I do.", true, 0, slideOutBirch, 23));
			MessageCenter.addMessage(Message.createMessage("And you are?", false, 2000, null, 23));
			MessageCenter.addMessage(Message.createMessage("Are you a boy?\nOr are you a girl?", false, 0, addGenderRegisteredKeys, 23, true));
		}
		
		private function sendOutPokemon():void
		{
			_birch.animate();
		}
		
		private function slideOutBirch():void
		{
			TweenLite.to(_ground, 1, { x:_ground.x + Configuration.VIEWPORT.width, alpha:0 } );
			TweenLite.to(_birch, 1, { x:_birch.x + Configuration.VIEWPORT.width, alpha:0, onComplete:slideInPlayer } );
		}
		
		private var hero_male:UITrainerSprite = new UITrainerSprite(TrainerType.HERO_MALE);
		private var hero_female:UITrainerSprite = new UITrainerSprite(TrainerType.HERO_FEMALE);
		private var genderQuestion:UIQuestionTextBox;
		private function slideInPlayer():void
		{
			_ground.x = 116 * Configuration.SPRITE_SCALE;
			_ground.y = 72 * Configuration.SPRITE_SCALE;
			TweenLite.to(_ground, 1, { alpha:1 } );
			
			hero_female.y = hero_male.y = 64 * Configuration.SPRITE_SCALE;
			hero_male.x = 178 * Configuration.SPRITE_SCALE;
			hero_female.x = Configuration.VIEWPORT.width + hero_female.width;
			
			this.addChild(hero_male);
			this.addChild(hero_female);
			
			hero_male.alpha = 0;
			TweenLite.to(hero_male, 1, { alpha:1 } );
		}
		
		private function askGenderQuestion():void
		{
			var options:Vector.<String> = new Vector.<String>();
			options.push("BOY", "GIRL");
			genderQuestion = new UIQuestionTextBox(options, 64, 48, 14, 4, 7, 4, genderQuestionAnswer);
			genderQuestion.x = 16 * Configuration.SPRITE_SCALE;
			genderQuestion.y = 32 * Configuration.SPRITE_SCALE;
			this.addChild(genderQuestion);
			
			//KeyboardManager.disableAllInputGroupsExcept(InputGroups.QUESTION_TEXT_BOX);
		}
		
		private function addGenderRegisteredKeys():void
		{
			askGenderQuestion();
			
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.QUESTION_TEXT_BOX);
			
			KeyboardManager.registerKey(Configuration.UP_KEY, tweenGender, InputGroups.CREATE_ACCOUNT_MENU);
			KeyboardManager.registerKey(Configuration.DOWN_KEY, tweenGender, InputGroups.CREATE_ACCOUNT_MENU);
		}
		
		private function tweenGender():void
		{
			TweenLite.killTweensOf(hero_female);
			TweenLite.killTweensOf(hero_male);
			
			var curGender:int = genderQuestion.CURRENT_LINE;
			
			TweenLite.to(hero_female, 0.25, { x:(curGender == 2 ? 178 * Configuration.SPRITE_SCALE : Configuration.VIEWPORT.width + hero_female.width), alpha:(curGender == 2 ? 1 : 0) } );
			TweenLite.to(hero_male, 0.25, { x:(curGender == 1 ? 178 * Configuration.SPRITE_SCALE : Configuration.VIEWPORT.width + hero_female.width), alpha:(curGender == 1 ? 1 : 0) } );
		}
		
		private function genderQuestionAnswer(answer:String):void
		{
			var curGender:int = answer == "BOY" ? 1 : 2;
			this.removeChild(genderQuestion);
			genderQuestion.destroy();
			genderQuestion = null;
			
			KeyboardManager.unregisterKey(Configuration.UP_KEY, tweenGender);
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, tweenGender);
			
			if (curGender == 1)
			{
				this.removeChild(hero_female);
				hero_female.destroy();
				hero_female = null;
				Configuration.ACTIVE_TRAINER.setType(TrainerType.HERO_MALE);
			} else
			{
				this.removeChild(hero_male);
				hero_male.destroy();
				hero_male = null;
				Configuration.ACTIVE_TRAINER.setType(TrainerType.HERO_FEMALE);
			}
			Configuration.ACTIVE_TRAINER.setUID(GUID.create());
			Configuration.ACTIVE_TRAINER.giveMoney(3000);
			Configuration.ACTIVE_TRAINER.updateLocation( -1, -1, MapType.OVERWORLD);
			if(MessageCenter.WAITING_ON_FINISH_MESSAGE) MessageCenter.finishMessage();
			MessageCenter.addMessage(Message.createMessage("All right.\nWhat's your name?", true, 0, askForName, 23));
		}
		
		private function askForName():void
		{
			Configuration.FADE_OUT_AND_IN(finishAskForName);
		}
		
		private function finishAskForName():void
		{
			Configuration.createMenu(MenuType.CREATE_ACCOUNT_NAME, 1, accountCreated);
		}
		
		private function accountCreated():void
		{
			// We can now continue!
			if (hero_female)
			{
				this.removeChild(hero_female);
				hero_female.destroy();
				hero_female = null;
			}
			if (hero_male)
			{
				this.removeChild(hero_male);
				hero_male.destroy();
				hero_male = null;
			}
			
			_ground.x = 56 * Configuration.SPRITE_SCALE;
			_ground.alpha = 0;
			_birch.x = 57 * Configuration.SPRITE_SCALE;
			_birch.alpha = 0;
			
			TweenLite.to(_ground, 2, { alpha:1 } );
			TweenLite.to(_birch, 2, { alpha:1, onComplete:continueAfterAccountGeneration } );
			
		}
		
		private function continueAfterAccountGeneration():void
		{
			MessageCenter.addMessage(Message.createMessage("Ah, okay!", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("You're %PLAYER% who's moving to my hometown of LITTLEROOT.\nI get it now!", true, 0, fadeInPlayer, 23));
			
		}
		
		private function fadeInPlayer():void
		{
			TweenLite.to(_ground, 1, { alpha:0 } );
			TweenLite.to(_birch, 1, { alpha:0, onComplete:finishFadeInPlayer } );
		}
		
		private var player:UITrainerSprite;
		private function finishFadeInPlayer():void
		{
			this.removeChild(_birch);
			_birch.destroy();
			_birch = null;
			
			player = new UITrainerSprite(Configuration.ACTIVE_TRAINER.TYPE);
			player.x = 120 * Configuration.SPRITE_SCALE;
			player.y = 60 * Configuration.SPRITE_SCALE;
			this.addChild(player);
			player.alpha = 0;
			
			TweenLite.to(_ground, 1, { alpha:1 } );
			TweenLite.to(player, 1, { alpha:1, onComplete:completeAccountCreation } );
		}
		
		private function completeAccountCreation():void
		{
			MessageCenter.addMessage(Message.createMessage("All right, are you ready?", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("Your very own adventure is about to unfold.", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("Take courage, and leap into the world of POKéMON where dreams, adventure, and friendships await!", true, 0, null, 23));
			MessageCenter.addMessage(Message.createMessage("Well, I'll be expecting you later. Come see me in my POKéMON LAB.", true, 0, finallyFinishCreation, 23));
		}
		
		private function finallyFinishCreation():void
		{
			Configuration.FADE_OUT_AND_IN(tempFinishCreation);
		}
		
		private function tempFinishCreation():void
		{
			destroy();
			
			// This is where we create the Overworld
			GameManager.enterOverworld();
		}
		
		public function destroy():void
		{
			this.removeChild(_ground);
			this.removeChild(player);
			_ground.destroy();
			player.destroy();
			player = null;
			_ground = null;
			this.removeChild(_topBar);
			_topBar.destroy();
			_topBar = null;
			this.removeChild(_textBar);
			_textBar.destroy();
			_textBar = null;
			
			this.graphics.clear();
		}
		
	}

}