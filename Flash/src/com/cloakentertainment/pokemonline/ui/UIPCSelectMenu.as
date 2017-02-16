package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPCSelectMenu extends Sprite implements UIElement
	{
		private var uiQuestionTextBox:UIQuestionTextBox;
		private var _callback:Function;
		private var menuOptions:Vector.<String>;
		
		public function UIPCSelectMenu(callback:Function = null):void
		{
			_callback = callback;
			construct();
			
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressCancel, InputGroups.PC_SELECT_MENU, true);
		}
		
		public function construct():void
		{
			accessingPlayerPC = false;
			MessageCenter.addMessage(Message.createMessage("Which PC should be accessed?", false, 0, finishShowing, 23, true));
			Configuration.ACTIVE_TRAINER.deactivateClock();
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.QUESTION_TEXT_BOX);
			KeyboardManager.enableInputGroup(InputGroups.PC_SELECT_MENU);
		}
		
		public function selectOption(answer:String):void
		{
			/// Note: We're using the CURRENT_LINE property instead of the callback's string because the active trainer's name could be "SOMEONE"
			if (uiQuestionTextBox.CURRENT_LINE == 1)
			{
				// Open "SOMEONE's PC"
			}
			else if (uiQuestionTextBox.CURRENT_LINE == 2)
			{
				// Open our PC
				destroyQuestionTextBox();
				SoundManager.playSoundEffect(SoundEffect.PC_LOG_ON);
				MessageCenter.finishMessage();
				MessageCenter.addMessage(Message.createMessage("Accessed %PLAYER%'s PC.", true, 0, accessPlayerPC, 23));
			}
			else
			{
				// Log off
				pressCancel();
			}
		}
		
		private var accessingPlayerPC:Boolean = false;
		private function accessPlayerPC():void
		{
			accessingPlayerPC = true;
			MessageCenter.addMessage(Message.createMessage("What would you like to do?", false, 0, finishAccessingPlayerPC, 23, true));
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.QUESTION_TEXT_BOX);
			KeyboardManager.enableInputGroup(InputGroups.PC_SELECT_MENU);
		}
		
		private function finishAccessingPlayerPC():void
		{
			menuOptions = new Vector.<String>();
			menuOptions.push("ITEM STORAGE", "MAILBOX", "TURN OFF");
			
			uiQuestionTextBox = new UIQuestionTextBox(menuOptions, UIQuestionTextBox.AUTO_SCALE, 16 * menuOptions.length + 16, 12, 6, 8, 6, selectPlayerPCOption);
			uiQuestionTextBox.x = 0;
			uiQuestionTextBox.y = 0;
			this.addChild(uiQuestionTextBox);
			
			KeyboardManager.enableInputGroup(InputGroups.PC_SELECT_MENU);
		}
		
		private function selectPlayerPCOption(answer:String):void
		{
			if (answer == "ITEM STORAGE")
			{
				
			} else
			if (answer == "MAILBOX")
			{
				
			} else
			if (answer == "TURN OFF")
			{
				if (MessageCenter.WAITING_ON_FINISH_MESSAGE)
				{
					MessageCenter.finishMessage();
					destroyQuestionTextBox();
					construct();
				}
				return;
			}
		}
		
		public function destroy():void
		{
			Configuration.ACTIVE_TRAINER.activateClock();
			
			destroyQuestionTextBox();
			
			_callback = null;
			menuOptions = null;
			
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, pressCancel);
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
		
		private function finishShowing():void
		{
			menuOptions = new Vector.<String>();
			menuOptions.push("SOMEONE'S PC", Configuration.ACTIVE_TRAINER.NAME + "'s PC", "LOG OFF");
			
			uiQuestionTextBox = new UIQuestionTextBox(menuOptions, UIQuestionTextBox.AUTO_SCALE, 16 * menuOptions.length + 16, 12, 6, 8, 6, selectOption);
			uiQuestionTextBox.x = 0;
			uiQuestionTextBox.y = 0;
			this.addChild(uiQuestionTextBox);
			
			KeyboardManager.enableInputGroup(InputGroups.PC_SELECT_MENU);
		}
		
		private function pressCancel():void
		{
			if (MessageCenter.WAITING_ON_FINISH_MESSAGE == false) return;
			if (accessingPlayerPC)
			{
				MessageCenter.finishMessage();
				SoundManager.playEnterKeySoundEffect();
				destroyQuestionTextBox();
				construct();
				return;
			}
			MessageCenter.finishMessage();
			SoundManager.playSoundEffect(SoundEffect.PC_TURN_OFF);
			if (_callback != null) _callback();
			_callback = null;
			destroy();
		}
		
		private function destroyQuestionTextBox():void 
		{
			this.removeChild(uiQuestionTextBox);
			uiQuestionTextBox.destroy();
			uiQuestionTextBox = null;
		}
	
	}

}