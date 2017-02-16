package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIQuestionTextBox extends Sprite implements UIElement
	{
		public static const AUTO_SCALE:int = -1;
		
		private var uiBox:UIBox;
		private var textField:TextField;
		
		private var _paddingLeft:int;
		private var _paddingRight:int;
		private var _paddingTop:int;
		private var _paddingBottom:int;
		
		private var _lines:Vector.<String>;
		private var _width:int;
		private var _height:int;
		
		private var _callback:Function;
		private var _uiTypeOverride:int;
		private var _textTypeOverride:int;
		
		public function UIQuestionTextBox(lines:Vector.<String>, width:int, height:int, paddingLeft:int = 0, paddingRight:int = 0, paddingTop:int = 0, paddingBottom:int = 0, callback:Function = null, uiTypeOverride:int = -1, textTypeOverride:int = -1):void
		{
			_paddingLeft = paddingLeft;
			_paddingRight = paddingRight;
			_paddingTop = paddingTop;
			_paddingBottom = paddingBottom;
			_lines = lines;
			_width = width;
			_height = height;
			_callback = callback;
			_uiTypeOverride = uiTypeOverride;
			_textTypeOverride = textTypeOverride;
			
			construct();
		}
		
		public function get TEXT_FIELD():TextField
		{
			return textField;
		}
		
		public function get PADDING_RIGHT():int
		{
			return _paddingRight;
		}
		
		public function get PADDING_BOTTOM():int
		{
			return _paddingBottom;
		}
		
		public function get PADDING_TOP():int
		{
			return _paddingTop;
		}
		
		public function get PADDING_LEFT():int
		{
			return _paddingLeft;
		}
		
		private static var _blackArrow:UISprite;
		
		public function construct():void
		{
			var autoScaleWidth:Boolean = false;
			var autoScaleHeight:Boolean = false;
			if (_width == -1)
			{
				_width = 500; // Something incredibly wide
				autoScaleWidth = true;
			}
			if (_height == -1)
			{
				_height = 500;
				autoScaleHeight = true;
			}
			
			textField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = Configuration.TEXT_FORMAT;
			if (_textTypeOverride == 1) textField.defaultTextFormat = Configuration.TEXT_FORMAT_WHITE;
			//textField.textColor = 0xFFFFFF;
			textField.selectable = false;
			textField.x = _paddingLeft * Configuration.SPRITE_SCALE;
			textField.y = _paddingTop * Configuration.SPRITE_SCALE;
			textField.width = _width * Configuration.SPRITE_SCALE - _paddingLeft * Configuration.SPRITE_SCALE - _paddingRight * Configuration.SPRITE_SCALE;
			textField.height = _height * Configuration.SPRITE_SCALE - _paddingTop * Configuration.SPRITE_SCALE - _paddingBottom * Configuration.SPRITE_SCALE;
			
			if (autoScaleWidth)
				_width = -1; // Reset the width back to zero so the largest value can be calculated from the lines of text
			if (autoScaleHeight)
				_height = -1;
			
			var _text:String = "";
			for (var i:int = 0; i < _lines.length; i++)
			{
				_text += _lines[i] + (i < _lines.length - 1 ? "\n" : "");
				
				if (autoScaleWidth)
				{
					textField.text = _lines[i];
					if (textField.textWidth / Configuration.SPRITE_SCALE >= _width)
						_width = textField.textWidth / Configuration.SPRITE_SCALE;
				}
				
			}
			
			if (autoScaleWidth)
				_width += _paddingLeft + _paddingRight + 5; // Add on the left/right padding
			
			textField.width = _width * Configuration.SPRITE_SCALE - _paddingLeft * Configuration.SPRITE_SCALE - _paddingRight * Configuration.SPRITE_SCALE;
			textField.height = _height * Configuration.SPRITE_SCALE - _paddingTop * Configuration.SPRITE_SCALE - _paddingBottom * Configuration.SPRITE_SCALE;
			
			textField.filters = [(_textTypeOverride == 1 ? Configuration.TEXT_FILTER_WHITE : Configuration.TEXT_FILTER)];
			textField.multiline = true;
			textField.text = _text;
			
			if (autoScaleHeight)
			{
				textField.height = textField.textHeight + Configuration.SPRITE_SCALE * 2;
				_height = textField.height / Configuration.SPRITE_SCALE + _paddingTop * Configuration.SPRITE_SCALE + _paddingBottom * Configuration.SPRITE_SCALE;
			}
			
			if (_textTypeOverride == 1) 
			{
				_blackArrow = new UIPokedexMenuSideArrow();
			}
			else _blackArrow = new UIBlackArrow();
			_blackArrow.x = textField.x - _blackArrow.width;
			selectLine(1, false);
			
			uiBox = new UIBox(_width, _height, _uiTypeOverride);
			this.addChild(uiBox);
			this.addChild(textField);
			this.addChild(_blackArrow);
			
			selectedOption = _lines[0];
			
			registerKeys();
		}
		
		public function registerKeys():void
		{
			KeyboardManager.registerKey(Configuration.DOWN_KEY, scrollDown, InputGroups.QUESTION_TEXT_BOX, true);
			KeyboardManager.registerKey(Configuration.UP_KEY, scrollUp, InputGroups.QUESTION_TEXT_BOX, true);
			KeyboardManager.registerKey(Configuration.ENTER_KEY, selectOption, InputGroups.QUESTION_TEXT_BOX, true);
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.QUESTION_TEXT_BOX);
		}
		
		public function unregisterKeys():void
		{
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, scrollDown);
			KeyboardManager.unregisterKey(Configuration.UP_KEY, scrollUp);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, selectOption);
			KeyboardManager.enableAllInputGroupsExcept(InputGroups.QUESTION_TEXT_BOX);
		}
		
		private var selectedOption:String = "";
		private var currentLine:int = 1;
		
		public function selectLine(lineNum:int, playSound:Boolean = true):void
		{
			if (playSound) SoundManager.playEnterKeySoundEffect();
			
			currentLine = lineNum;
			
			var metrics:TextLineMetrics = textField.getLineMetrics(0);
			var lineHeight:int = metrics.ascent + metrics.descent + metrics.leading;
			_blackArrow.y = textField.y + lineHeight * (lineNum - 1) + 3.5 * Configuration.SPRITE_SCALE - (_blackArrow.height - (metrics.ascent - metrics.descent)) / 2;
		}
		
		private function selectOption():void
		{
			SoundManager.playEnterKeySoundEffect();
			
			unregisterKeys();
			
			_callback(_lines[currentLine - 1]);
		}
		
		public function get CURRENT_LINE():int
		{
			return currentLine;
		}
		
		private function scrollDown():void
		{
			if (currentLine + 1 > _lines.length)
				selectLine(1);
			else
				selectLine(currentLine + 1);
		}
		
		private function scrollUp():void
		{
			if (currentLine - 1 <= 0)
				selectLine(_lines.length);
			else
				selectLine(currentLine - 1);
		}
		
		public function destroy():void
		{
			unregisterKeys();
			
			this.removeChild(uiBox);
			uiBox.destroy();
			uiBox = null;
			
			this.removeChild(_blackArrow);
			_blackArrow.destroy();
			_blackArrow = null;
			_callback = null;
			
			this.removeChild(textField);
			textField = null;
		
		}
	
	}

}