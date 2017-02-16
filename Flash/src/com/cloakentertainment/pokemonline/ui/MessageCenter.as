package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.world.PlayerManager;
	import com.greensock.TweenLite;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class MessageCenter
	{
		private static var _messages:Vector.<Message> = new Vector.<Message>();
		private static var _displayingMessage:Boolean = false;
		
		private static var _textBar:UICreateAccountTextBar;
		
		public function MessageCenter()
		{
			throw(new Error("Do not instantiate."));
		}
		
		public static function cleanup():void
		{
			_messages = new Vector.<Message>();
			
			if (_textBar)
			{
				Configuration.STAGE.removeChild(_textBar);
				_textBar.destroy();
				_textBar = null;
			}
			
			destroyRedArrow();
			destroyUIQuestionTextBox();
			destroyUITextBox();
			
		}
		
		public static function addMessage(message:Message):void
		{
			_messages.push(message);
			if (!_displayingMessage)
				displayNextMessage();
		}
		
		private static function drawUIBox():void
		{
			destroyUITextBox();
			uiTextBox = new UITextBox("", 240, 48, 8, 8, 6, 8, _messages[0].UI_OVERRIDE);
			uiTextBox.y = Configuration.STAGE.stageHeight - uiTextBox.height;
			if (_messages[0].UI_OVERRIDE == 23) 
			{
				uiTextBox.y -= 8 * Configuration.SPRITE_SCALE;
				
				_textBar = new UICreateAccountTextBar();
				_textBar.x = 1 * Configuration.SPRITE_SCALE;
				_textBar.y = Configuration.VIEWPORT.height - _textBar.height - 3 * Configuration.SPRITE_SCALE;
				Configuration.STAGE.addChild(_textBar);
			} else
			{
				if (_textBar)
				{
					Configuration.STAGE.removeChild(_textBar);
					_textBar.destroy();
					_textBar = null;
				}
			}
			Configuration.STAGE.addChild(uiTextBox);
		}
		
		private static var uiTextBox:UITextBox;
		private static var uiQuestionTextBox:UIQuestionTextBox;
		
		private static function displayNextMessage():void
		{
			PlayerManager.startBeingBusy();
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.MESSAGE_CENTER);
			if (!_displayingMessage)
			{
				_displayingMessage = true;
				
				drawUIBox();
			}
			else
			{
				Configuration.STAGE.setChildIndex(uiTextBox, Configuration.STAGE.numChildren - 1);
				_pointer = 0;
				
				if (uiTextBox.UI_OVERRIDE != _messages[0].UI_OVERRIDE) drawUIBox();
			}
			
			uiTextBox.changeText(_messages[0].TEXT);
			var splitText:Vector.<Array> = uiTextBox.splitText();
			if (splitText.length > 1)
			{
				_messages[0].changeText = splitText[0][0];
				for (var i:int = splitText.length - 1; i > 0; i--)
				{
					var message:Message = new Message(_messages[0].TYPE, splitText[i][0], _messages[0].OPTIONS, _messages[0].SKIPPABLE, _messages[0].DELAY_AFTER, splitText[i][1], _messages[0].CALLBACK, _messages[0].UI_OVERRIDE, false, _messages[0].CALLBACK_PARAMS);
					_messages[0].nullCallback();
					_messages.splice(1, 0, message);
				}
			}
			
			uiTextBox.changeText(_messages[0].INITIAL_TEXT);
			_pointer = _messages[0].INITIAL_POINTER;
			
			updateText();
		}
		
		private static var _pointer:int = 0;
		private static var _redArrow:UIRedArrow;
		
		private static function updateText():void
		{
			//trace(_pointer, _messages[0].TEXT.length);
			if (_messages.length > 0 && _pointer >= _messages[0].TEXT.length)
			{
				// Stop!
				
				if (_messages[0].TYPE == MessageType.QUESTION)
				{
					// Create the question box for all the possible questions
					var width:int = 70;
					for (var i:int = 0; i < _messages[0].OPTIONS.length; i++)
					{
						// Calculate the longest answer in the Vector
						var oldText:String = uiTextBox.TEXT_FIELD.text;
						uiTextBox.TEXT_FIELD.text = _messages[0].OPTIONS[i];
						if (uiTextBox.TEXT_FIELD.textWidth / Configuration.SPRITE_SCALE + 26 > width)
							width = uiTextBox.TEXT_FIELD.textWidth / Configuration.SPRITE_SCALE + 26;
						uiTextBox.TEXT_FIELD.text = oldText;
					}
					uiQuestionTextBox = new UIQuestionTextBox(_messages[0].OPTIONS, width, _messages[0].OPTIONS.length * 16 + 14, 14, 8, 6, 8, questionCallbackReceived);
					uiQuestionTextBox.x = Configuration.VIEWPORT.width - uiQuestionTextBox.width;
					uiQuestionTextBox.y = Configuration.VIEWPORT.height - 48 * Configuration.SPRITE_SCALE - uiQuestionTextBox.height;
					Configuration.STAGE.addChild(uiQuestionTextBox);
				}
				else if (_messages[0].DO_NOT_DISMISS_AUTOMATICALLY)
				{
					// wait for finishMessage to be called
					waitingOnFinishMessage = true;
					if (_messages[0].CALLBACK != null && _messages[0].TYPE == MessageType.TEXT)
					{
						if (_messages[0].CALLBACK_PARAMS == null) _messages[0].CALLBACK();
						else
						{
							TweenLite.delayedCall(0, _messages[0].CALLBACK, _messages[0].CALLBACK_PARAMS);
						}
					}
					if (_messages.length > 0) _messages[0].nullCallback();
				}
				else if (_messages[0].SKIPPABLE == false)
				{
					if (_messages[0].DELAY_AFTER != 0)
					{
						setTimeout(finishMessage, _messages[0].DELAY_AFTER);
					}
					else
						finishMessage();
				}
				else
				{
					// It is skippable, wait until the ENTER key is called
					//KeyboardManager.registerKey(Configuration.ENTER_KEY, finishMessage, InputGroups.MESSAGE_CENTER, true);
					//KeyboardManager.disableAllInputGroupsExcept(InputGroups.MESSAGE_CENTER);
					_redArrow = new UIRedArrow();
					_redArrow.x = uiTextBox.x + uiTextBox.width - uiTextBox.PADDING_RIGHT - _redArrow.width * 2;
					_redArrow.y = uiTextBox.y + uiTextBox.height - uiTextBox.PADDING_BOTTOM - _redArrow.height * 2;
					Configuration.STAGE.addChild(_redArrow);
					//if (_messages.length == 1) _redArrow.visible = false;
					
					if (_messages[0].UI_OVERRIDE == 23)
					{
						_redArrow.x = Configuration.VIEWPORT.width - _redArrow.width - 12 * Configuration.SPRITE_SCALE;
						_redArrow.y = Configuration.VIEWPORT.height - _redArrow.height - 9 * Configuration.SPRITE_SCALE;
					}
					
					TweenLite.delayedCall(0.25, KeyboardManager.registerKey, [Configuration.ENTER_KEY, finishMessage, InputGroups.MESSAGE_CENTER, true]);
					TweenLite.delayedCall(0.26, KeyboardManager.disableAllInputGroupsExcept, [InputGroups.MESSAGE_CENTER]);
				}
				return;
			}
			else if (_messages.length == 0)
			{
				finishMessage();
			}
			
			_pointer++;
			var message:String = _messages[0].TEXT.substr(0, _pointer);
			uiTextBox.changeText(message);
			
			if (_messages[0].SKIPPABLE && KeyboardManager.isKeyPressed(Configuration.ENTER_KEY))
			{
				setTimeout(updateText, Configuration.TEXT_SPEED / 10);
			}
			else
				setTimeout(updateText, Configuration.TEXT_SPEED);
		}
		
		private static function waitForFinishMessage():void
		{
			if (_messages.length > 1)
			{
				// We're holding up the queue.
				finishMessage();
			}
		}
		
		private static var waitingOnFinishMessage:Boolean = false;
		
		public static function get WAITING_ON_FINISH_MESSAGE():Boolean
		{
			return waitingOnFinishMessage;
		}
		
		private static function questionCallbackReceived(arg:String):void
		{
			_messages[0].CALLBACK(arg);
			finishMessage();
		}
		
		static private function destroyUITextBox():void 
		{
			if (uiTextBox)
			{
				Configuration.STAGE.removeChild(uiTextBox);
				uiTextBox.destroy();
				uiTextBox = null;
			}
		}
		
		static private function destroyRedArrow():void 
		{
			if (_redArrow)
			{
				Configuration.STAGE.removeChild(_redArrow);
				_redArrow.destroy();
				_redArrow = null;
			}
		}
		
		static private function destroyUIQuestionTextBox():void 
		{
			if (uiQuestionTextBox)
			{
				Configuration.STAGE.removeChild(uiQuestionTextBox);
				uiQuestionTextBox.destroy();
				uiQuestionTextBox = null;
			}
		}
		
		public static function isMessageOpen():Boolean
		{
			if (uiTextBox != null) return true;
			else return false;
		}
		
		public static function finishMessage():void
		{
			waitingOnFinishMessage = false;
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, finishMessage); // Unregister the ENTER key listener
			
			if (_messages[0].SKIPPABLE)
				SoundManager.playEnterKeySoundEffect();
			
			destroyRedArrow();
			if (_messages[0].CALLBACK != null && _messages[0].TYPE == MessageType.TEXT)
			{
				if (_messages[0].CALLBACK_PARAMS == null) _messages[0].CALLBACK();
				else TweenLite.delayedCall(0, _messages[0].CALLBACK, _messages[0].CALLBACK_PARAMS);
			}
			_messages[0].nullCallback();
			_messages[0] = null;
			_messages.splice(0, 1);
			
			destroyUIQuestionTextBox();
			
			if (_messages.length != 0)
				displayNextMessage();
			else
			{
				// Remove the uiTextBox
				uiTextBox.destroy();
				Configuration.STAGE.removeChild(uiTextBox);
				uiTextBox = null
				
				if (_textBar)
				{
					Configuration.STAGE.removeChild(_textBar);
					_textBar.destroy();
					_textBar = null;
				}
				
				_displayingMessage = false;
				
				TweenLite.delayedCall(0.25, KeyboardManager.enableAllInputGroupsExcept, [InputGroups.MESSAGE_CENTER], false);
				PlayerManager.stopBeingBusy();
			}
		}
	
	}

}