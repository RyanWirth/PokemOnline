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
	public class UIPokemartMenu extends Sprite implements UIElement
	{
		private var uiQuestionTextBox:UIQuestionTextBox;
		private var _callback:Function;
		private var menuOptions:Vector.<String>;
		private var _items:String;
		private var _secondTimeInMenu:Boolean;
		
		public function UIPokemartMenu(callback:Function = null, items:String = "", secondTimeInMenu:Boolean = false):void
		{
			_callback = callback;
			_items = items;
			_secondTimeInMenu = secondTimeInMenu;
			construct();
			
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressCancel, InputGroups.POKEMART_MENU, true);
		}
		
		public function construct():void
		{
			MessageCenter.addMessage(Message.createMessage(_secondTimeInMenu == false ? "How may I serve you?" : "Is there anything else I can help you with?", false, 0, finishShowing, 23, true));
			Configuration.ACTIVE_TRAINER.deactivateClock();
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.QUESTION_TEXT_BOX);
			KeyboardManager.enableInputGroup(InputGroups.PC_SELECT_MENU);
		}
		
		public function selectOption(answer:String):void
		{
			if (answer == "BUY")
			{
				// Open buy menu
				Configuration.FADE_OUT_AND_IN(goToBuyMenu);
			} else
			if (answer == "SELL")
			{
				// Open sell menu
				Configuration.FADE_OUT_AND_IN(goToSellMenu);
			} else
			if (answer == "QUIT")
			{
				pressCancel();
			}
		}
		
		private function goToBuyMenu():void
		{
			Configuration.createMenu(MenuType.POKEMART_BUY, 1, _callback, false, _items);
			_callback = null;
			destroy();
		}
		
		private function goToSellMenu():void
		{
			Configuration.createMenu(MenuType.POKEMART_SELL, 1, _callback, false, _items);
			_callback = null;
			destroy();
		}
		
		public function destroy():void
		{
			Configuration.ACTIVE_TRAINER.activateClock();
			
			destroyQuestionTextBox();
			
			_callback = null;
			menuOptions = null;
			
			if(MessageCenter.WAITING_ON_FINISH_MESSAGE) MessageCenter.finishMessage();
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, pressCancel);
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
		
		private function finishShowing():void
		{
			menuOptions = new Vector.<String>();
			menuOptions.push("BUY", "SELL", "QUIT");
			
			uiQuestionTextBox = new UIQuestionTextBox(menuOptions, UIQuestionTextBox.AUTO_SCALE, 16 * menuOptions.length + 16, 12, 6, 8, 6, selectOption);
			uiQuestionTextBox.x = 0;
			uiQuestionTextBox.y = 0;
			this.addChild(uiQuestionTextBox);
			
			KeyboardManager.enableInputGroup(InputGroups.POKEMART_MENU);
		}
		
		private function pressCancel():void
		{
			if (MessageCenter.WAITING_ON_FINISH_MESSAGE == false) return;
			
			if(MessageCenter.WAITING_ON_FINISH_MESSAGE) MessageCenter.finishMessage();
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