package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.ui.MessageCenter;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonMenu extends UISprite implements UIElement
	{
		[Embed(source="assets/UIPokemonMenu.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _background:Bitmap;
		private var slots:Vector.<UIPokemonMenuSlot> = new Vector.<UIPokemonMenuSlot>();
		private var textBox:UITextBox;
		private var dowhat:UITextBox;
		private var questionBox:UIQuestionTextBox;
		
		private var replacingPokemonCallback:Function;
		private var allowCancellationOnCallback:Boolean;
		
		private var _trainingMove:String;
		private var _trainingPokemon:Pokemon;
		
		public function UIPokemonMenu(_replacingPokemonCallback:Function = null, _allowCancellationOnCallback:Boolean = false, trainingMove:String = "", trainingPokemon:Pokemon = null)
		{
			super(spriteImage);
			
			replacingPokemonCallback = _replacingPokemonCallback;
			allowCancellationOnCallback = _allowCancellationOnCallback;
			_trainingMove = trainingMove;
			_trainingPokemon = trainingPokemon;
			
			if (_trainingMove != "")
			{
				createSummaryMenu();
				return;
			}
			
			construct();
		}
		
		override public function construct():void
		{
			_background = getSprite(0, 0, 240, 160);
			this.addChild(_background);
			
			var slotL:UIPokemonMenuSlot = new UIPokemonMenuSlot(Configuration.ACTIVE_TRAINER.getPokemon(0), true);
			slotL.x = 10 * Configuration.SPRITE_SCALE;
			slotL.y = 26 * Configuration.SPRITE_SCALE;
			slots.push(slotL);
			this.addChild(slotL);
			
			for (var i:int = 1; i < 6; i++)
			{
				var slot:UIPokemonMenuSlot = new UIPokemonMenuSlot(Configuration.ACTIVE_TRAINER.getPokemon(i), false);
				slot.x = 96 * Configuration.SPRITE_SCALE;
				slot.y = 10 * Configuration.SPRITE_SCALE + 24 * (i - 1) * Configuration.SPRITE_SCALE;
				slots.push(slot);
				this.addChild(slot);
			}
			
			var slotC:UIPokemonMenuSlot = new UIPokemonMenuSlot(null, false, false, true);
			slotC.x = 186 * Configuration.SPRITE_SCALE;
			slotC.y = 136 * Configuration.SPRITE_SCALE;
			slots.push(slotC);
			this.addChild(slotC);
			
			select(0, 1, false);
			
			textBox = new UITextBox("Choose a POKéMON.", 184, 32, 8, 4, 8, 0);
			textBox.x = Configuration.SPRITE_SCALE;
			textBox.y = 127 * Configuration.SPRITE_SCALE;
			this.addChild(textBox);
			
			if (Configuration.STAGE.contains(this) == false)
				Configuration.STAGE.addChild(this);
			
			registerKeys();
		}
		
		private function midwaySwitch(slot:UIPokemonMenuSlot):void
		{
			// now reconstruct these two slots
			var indexForSlot:int = 0;
			var indexForSwitchingSlot:int = 0;
			var i:int;
			for (i = 0; i < slots.length; i++)
			{
				if (slots[i] == switchingSlot)
					indexForSlot = i;
				if (slots[i] == slot)
					indexForSwitchingSlot = i;
			}
			
			// Now we have the slot indexes to put these into, let's reconstruct them and tween them back in
			if (Configuration.ACTIVE_TRAINER)
				Configuration.ACTIVE_TRAINER.switchPokemon(indexForSlot, indexForSwitchingSlot);
			
			var newSlot1:UIPokemonMenuSlot = new UIPokemonMenuSlot(slot.POKEMON, switchingSlot.LARGE);
			var newSlot2:UIPokemonMenuSlot = new UIPokemonMenuSlot(switchingSlot.POKEMON, slot.LARGE);
			
			var newSlot1Y:int = switchingSlot.y;
			var newSlot2Y:int = slot.y;
			
			this.removeChild(slot);
			this.removeChild(switchingSlot);
			slot.destroy();
			switchingSlot.destroy();
			slot = null;
			switchingSlot = null;
			switching = false;
			
			newSlot1.y = newSlot1Y;
			newSlot2.y = newSlot2Y;
			
			if (newSlot1.LARGE)
				newSlot1.x = -newSlot1.width;
			else
				newSlot1.x = Configuration.VIEWPORT.width + 25;
			
			if (newSlot2.LARGE)
				newSlot2.x = -newSlot2.width;
			else
				newSlot2.x = Configuration.VIEWPORT.width + 25;
			
			slots[indexForSlot] = newSlot1;
			slots[indexForSwitchingSlot] = newSlot2;
			
			if (newSlot1.LARGE)
				TweenLite.to(newSlot1, 0.25, {x: 10 * Configuration.SPRITE_SCALE});
			else
				TweenLite.to(newSlot1, 0.25, {x: 96 * Configuration.SPRITE_SCALE});
			if (newSlot2.LARGE)
				TweenLite.to(newSlot2, 0.25, {x: 10 * Configuration.SPRITE_SCALE, onComplete: finishSwitching});
			else
				TweenLite.to(newSlot2, 0.25, {x: 96 * Configuration.SPRITE_SCALE, onComplete: finishSwitching});
			
			this.addChild(newSlot1);
			this.addChild(newSlot2);
		}
		
		private function finishSwitching():void
		{
			registerKeys();
			select(currentlySelected);
		}
		
		private function selectSlot(playSound:Boolean = true):void
		{
			if (currentlySelected == 6)
			{
				cancelButton();
				return;
			}
			
			var slot:UIPokemonMenuSlot = slots[currentlySelected];
			
			if (switching)
			{
				if (slot.POKEMON_NULL)
					return;
				
				// Move the switching pokemon here!
				if (switchingSlot.LARGE)
					TweenLite.to(switchingSlot, 0.25, {x: -switchingSlot.width});
				else
					TweenLite.to(switchingSlot, 0.25, {x: Configuration.VIEWPORT.width + 25});
				if (slot.LARGE)
					TweenLite.to(slot, 0.25, {x: -slot.width, onComplete: midwaySwitch, onCompleteParams: [slot]});
				else
					TweenLite.to(slot, 0.25, {x: Configuration.VIEWPORT.width + 25, onComplete: midwaySwitch, onCompleteParams: [slot]});
				unregisterKeys();
				return;
			}
			
			if (playSound)
				SoundManager.playEnterKeySoundEffect();
			
			
			// open the question box
			var options:Vector.<String> = new Vector.<String>();
			if (replacingPokemonCallback != null)
			{
				options.push(allowCancellationOnCallback ? "SHIFT" : "SEND OUT", "SUMMARY", "CANCEL");
			}
			else
				options.push("SUMMARY", "SWITCH", "ITEM", "CANCEL");
			questionBox = new UIQuestionTextBox(options, 94, -1, 15, 0, 10, -3, selectSlotOption);
			questionBox.x = 145 * Configuration.SPRITE_SCALE;
			questionBox.y = Configuration.VIEWPORT.height - questionBox.height - 1 * Configuration.SPRITE_SCALE;
			this.addChild(questionBox);
			
			dowhat = new UITextBox("Do what with this PKMN?", 142, 32, 8, 4, 8, 0);
			dowhat.x = Configuration.SPRITE_SCALE;
			dowhat.y = 127 * Configuration.SPRITE_SCALE;
			this.addChild(dowhat);
			
			textBox.visible = false;
			
			unregisterKeys(false);
		}
		
		private function returnToPokemonMenuFromSummary():void
		{
			this.removeChild(summaryMenu);
			summaryMenu = null;
			removeQuestionBox();
			if(_trainingMove == "") selectSlot(false);
			
			KeyboardManager.enableInputGroup(InputGroups.POKEMON);
		}
		
		private function createSummaryMenu():void
		{
			Configuration.FADE_OUT_AND_IN(finishCreatingSummaryMenu);
		}
		
		private function finishCreatingSummaryMenu():void
		{
			summaryMenu = new UIPokemonSummaryMenu(_trainingPokemon != null ? _trainingPokemon : slots[currentlySelected].POKEMON, _trainingMove == "" ? returnToPokemonMenuFromSummary : receiveAnswerForTrainingMove, _trainingMove, _trainingPokemon);
			this.addChild(summaryMenu);
		}
		
		private function receiveAnswerForTrainingMove(moveInt:int):void
		{
			returnToPokemonMenuFromSummary();
			
			replacingPokemonCallback(moveInt);
			destroy();
		}
		
		private var callbackCalled:Boolean = false;
		
		private function finishSendingOutPokemon():void
		{
			Configuration.ACTIVE_TRAINER.switchPokemon(0, currentlySelected);
			replacingPokemonCallback(Configuration.ACTIVE_TRAINER.getPokemon(0));
			callbackCalled = true;
			finishCancelButton();
		}
		
		private var switching:Boolean = false;
		private var switchingSlot:UIPokemonMenuSlot;
		private var summaryMenu:UIPokemonSummaryMenu;
		
		private function selectSlotOption(answer:String):void
		{
			if (answer == "SEND OUT" || answer == "SHIFT")
			{
				if (slots[currentlySelected].POKEMON.CURRENT_HP <= 0)
				{
					unregisterKeys(true);
					MessageCenter.addMessage(Message.createMessage(slots[currentlySelected].POKEMON.NAME + " has no energy\nleft to battle!", true, 0, registerKeys));
					KeyboardManager.disableAllInputGroupsExcept(InputGroups.MESSAGE_CENTER);
					removeQuestionBox();
					return;
				}
				if (slots[currentlySelected].POKEMON.ACTIVE)
				{
					unregisterKeys(true);
					MessageCenter.addMessage(Message.createMessage(slots[currentlySelected].POKEMON.NAME + " is already\nin battle!", true, 0, registerKeys));
					KeyboardManager.disableAllInputGroupsExcept(InputGroups.MESSAGE_CENTER);
					removeQuestionBox();
					return;
				}
				
				unregisterKeys(true);
				removeQuestionBox();
				Configuration.FADE_OUT_AND_IN(finishSendingOutPokemon);
			}
			else if (answer == "SUMMARY")
			{
				// Open summary
				KeyboardManager.disableInputGroup(InputGroups.POKEMON);
				
				createSummaryMenu();
			}
			else if (answer == "SWITCH")
			{
				// choose this pokemon
				switching = true;
				slots[currentlySelected].choose();
				switchingSlot = slots[currentlySelected];
				textBox.visible = true;
				textBox.TEXT_FIELD.text = "Move to where?";
				removeQuestionBox();
				TweenLite.to(this, 0.1, {onComplete: registerKeys, onCompleteParams: [false]});
			}
			else if (answer == "ITEM")
			{
				removeQuestionBox();
				//TweenLite.to(this, 0.05, { onComplete:askItemQuestion } );
				askItemQuestion();
			}
			else if (answer == "CANCEL")
			{
				cancelButton();
			}
		}
		
		private var itemQuestionBox:UIQuestionTextBox;
		private var itemDowhat:UITextBox;
		
		private function askItemQuestion():void
		{
			var options:Vector.<String> = new Vector.<String>();
			options.push("GIVE", "TAKE", "CANCEL");
			itemQuestionBox = new UIQuestionTextBox(options, 64, 64, 15, 0, 8, 0, selectItemQuestion);
			itemQuestionBox.x = 176 * Configuration.SPRITE_SCALE;
			itemQuestionBox.y = Configuration.VIEWPORT.height - itemQuestionBox.height - 1 * Configuration.SPRITE_SCALE;
			this.addChild(itemQuestionBox);
			
			itemDowhat = new UITextBox("Do what with an item?", 174, 32, 8, 4, 8, 0);
			itemDowhat.x = 1 * Configuration.SPRITE_SCALE;
			itemDowhat.y = 127 * Configuration.SPRITE_SCALE;
			this.addChild(itemDowhat);
			
			textBox.visible = false;
			
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.QUESTION_TEXT_BOX);
		}
		
		private function selectItemQuestion(answer:String):void
		{
			if (answer == "CANCEL")
			{
				removeItemQuestionBox();
				selectSlot(false);
				return;
			}
			else if (answer == "TAKE")
			{
				if (slots[currentlySelected].POKEMON.HELDITEM == "")
				{
					// There is no item to take!
					removeItemQuestionBox();
					MessageCenter.addMessage(Message.createMessage(slots[currentlySelected].POKEMON.NAME + " isn't holding\nanything.", true, 0, finishSelectingItem));
					KeyboardManager.disableAllInputGroupsExcept(InputGroups.MESSAGE_CENTER);
				}
				else
				{
					trace("We have an item to take!");
				}
			}
		}
		
		private function finishSelectingItem():void
		{
			TweenLite.to(this, 0.1, {onComplete: registerKeys, onCompleteParams: [false]});
			return;
		}
		
		private function cancelButton():void
		{
			SoundManager.playEnterKeySoundEffect();
			
			// If pokemon menu open... return;
			if (switching)
			{
				for (var i:int = 0; i < slots.length; i++)
				{
					slots[i].unchoose();
				}
				switching = false;
				switchingSlot = null;
				textBox.TEXT_FIELD.text = "Choose a POKéMON.";
				return;
			}
			if (questionBox)
			{
				removeQuestionBox();
				TweenLite.to(this, 0.1, {onComplete: registerKeys, onCompleteParams: [false]});
				return;
			}
			if (itemQuestionBox)
			{
				removeItemQuestionBox();
				selectSlot(false);
				return;
			}
			
			if (replacingPokemonCallback != null && allowCancellationOnCallback == false)
				return;
			
			unregisterKeys();
			Configuration.FADE_OUT_AND_IN(finishCancelButton);
		}
		
		private function finishCancelButton():void
		{
			destroy();
			if (replacingPokemonCallback == null)
				Configuration.createMenu(MenuType.IN_GAME_MENU);
			else
			{
				if (replacingPokemonCallback != null && !callbackCalled)
					replacingPokemonCallback(null);
				replacingPokemonCallback = null;
				KeyboardManager.enableInputGroup(InputGroups.BATTLE);
			}
		}
		
		private function pressLeft():void
		{
			switch (currentlySelected)
			{
				case 1: 
				case 2: 
				case 3: 
				case 4: 
				case 5: 
					select(0); // We're on the right side (the small slots), move to the left (large slot)
					break;
			}
		}
		
		private function pressRight():void
		{
			if (currentlySelected == 0)
			{
				select(lastOnSmallSide);
			}
		}
		
		private function pressUp():void
		{
			if (currentlySelected == 0)
				select(slots.length - 1, -1);
			else
			{
				select(currentlySelected - 1, -1);
			}
		}
		
		private function pressDown():void
		{
			if (currentlySelected == slots.length - 1)
				select(0);
			else
			{
				select(currentlySelected + 1);
			}
		}
		
		private var currentlySelected:int;
		private var lastOnSmallSide:int = 1;
		
		private function select(slotNum:int, moving:int = 1, playSound:Boolean = true):void
		{
			if (playSound)
				SoundManager.playEnterKeySoundEffect();
			
			for (var i:int = 0; i < slots.length; i++)
			{
				slots[i].deselect();
			}
			
			// Determine the next closest non-null slot
			if (slots[slotNum].POKEMON_NULL)
			{
				if (moving == 1)
				{
					while (slots[slotNum].POKEMON_NULL)
					{
						slotNum++;
						if (slotNum >= slots.length)
							slotNum = 0;
					}
				}
				else if (moving == -1)
				{
					while (slots[slotNum].POKEMON_NULL)
					{
						slotNum--;
						if (slotNum < 0)
							slotNum = slots.length - 1;
					}
				}
			}
			
			switch (slotNum)
			{
				case 1: 
				case 2: 
				case 3: 
				case 4: 
				case 5: 
					lastOnSmallSide = slotNum;
					break;
			}
			currentlySelected = slotNum;
			slots[slotNum].select();
		}
		
		private function registerKeys(registerCancel:Boolean = true):void
		{
			KeyboardManager.registerKey(Configuration.LEFT_KEY, pressLeft, InputGroups.POKEMON, true);
			KeyboardManager.registerKey(Configuration.RIGHT_KEY, pressRight, InputGroups.POKEMON, true);
			KeyboardManager.registerKey(Configuration.DOWN_KEY, pressDown, InputGroups.POKEMON, true);
			KeyboardManager.registerKey(Configuration.UP_KEY, pressUp, InputGroups.POKEMON, true);
			TweenLite.delayedCall(10, KeyboardManager.registerKey, [Configuration.ENTER_KEY, selectSlot, InputGroups.POKEMON, true], true);
			if (registerCancel)
				KeyboardManager.registerKey(Configuration.CANCEL_KEY, cancelButton, InputGroups.POKEMON, true);
			
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.POKEMON);
			KeyboardManager.enableInputGroup(InputGroups.QUESTION_TEXT_BOX);
		}
		
		private function unregisterKeys(unregisterCancel:Boolean = true):void
		{
			KeyboardManager.unregisterKey(Configuration.LEFT_KEY, pressLeft);
			KeyboardManager.unregisterKey(Configuration.RIGHT_KEY, pressRight);
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, pressDown);
			KeyboardManager.unregisterKey(Configuration.UP_KEY, pressUp);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, selectSlot);
			if (unregisterCancel)
				KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, cancelButton);
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.POKEMON);
			KeyboardManager.enableInputGroup(InputGroups.QUESTION_TEXT_BOX);
		}
		
		private function removeQuestionBox():void
		{
			if (questionBox)
			{
				this.removeChild(questionBox);
				questionBox.destroy();
				questionBox = null;
			}
			if (dowhat)
			{
				this.removeChild(dowhat);
				dowhat.destroy();
				dowhat = null;
			}
			
			if (textBox)
				textBox.visible = true;
		}
		
		private function removeItemQuestionBox():void
		{
			this.removeChild(itemQuestionBox);
			itemQuestionBox.destroy();
			itemQuestionBox = null;
			
			this.removeChild(itemDowhat);
			itemDowhat.destroy();
			itemDowhat = null;
			
			textBox.visible = true;
		}
		
		override public function destroy():void
		{
			if (_trainingMove != "") 
			{
				replacingPokemonCallback = null;
				allowCancellationOnCallback = false;
				_trainingMove = "";
				_trainingPokemon = null;
				
				Configuration.STAGE.removeChild(this);
				
				return;
			}
			
			this.removeChild(_background);
			
			for (var i:int = 0; i < slots.length; i++)
			{
				this.removeChild(slots[i]);
				slots[i].destroy();
				slots[i] = null;
			}
			slots = null;
			
			this.removeChild(textBox);
			textBox.destroy();
			textBox = null;
			
			if (dowhat)
			{
				this.removeChild(dowhat);
				dowhat.destroy();
				dowhat = null;
			}
			
			_background = null;
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
	
	}

}