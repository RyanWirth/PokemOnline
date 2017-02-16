package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.ui.UIBattleTextBar;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UITextBox extends Sprite implements UIElement
	{
		public var uiBox:UIBox;
		private var textField:TextField;
		
		private var _paddingLeft:Number;
		private var _paddingRight:Number;
		private var _paddingTop:Number;
		private var _paddingBottom:Number;
		private var _uiOverride:int;
		
		private var _text:String;
		private var _width:int;
		private var _height:int;
		
		public function UITextBox(text:String, width:int, height:int, paddingLeft:Number = 0, paddingRight:Number = 0, paddingTop:Number = 0, paddingBottom:Number = 0, uiOverride:int = -1):void
		{
			_paddingLeft = paddingLeft;
			_paddingRight = paddingRight;
			_paddingTop = paddingTop;
			_paddingBottom = paddingBottom;
			_text = text;
			_width = width;
			_height = height;
			_uiOverride = uiOverride;
			
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
		
		public function get UI_OVERRIDE():int
		{
			return _uiOverride;
		}
		
		public function splitText():Vector.<Array>
		{
			var i:int;
			var strings:Vector.<Array> = new Vector.<Array>();
			var lines:Vector.<Array> = new Vector.<Array>();
			var array:Array;
			for (i = 0; i < textField.numLines; i++)
			{
				array = new Array();
				array[0] = textField.text.substr(textField.getLineOffset(i), textField.getLineLength(i));
				array[1] = textField.getLineOffset(i);
				lines.push(array);
			}
			for (i = 1; i < lines.length; i++)
			{
				array = new Array();
				array[0] = String(lines[i - 1][0]).replace(/[\u000d\u000a\u0008]+/g, "") + "\n" + String(lines[i][0]).replace(/[\u000d\u000a\u0008]+/g, "");
				array[1] = lines[i - 1][0].length;
				strings.push(array);
			}
			//trace("Split strings: " + strings);
			return strings;
		}
		
		public function construct():void
		{
			uiBox = new UIBox(_width, _height, _uiOverride);
			this.addChild(uiBox);
			
			textField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = _uiOverride != 22 ? Configuration.TEXT_FORMAT : UIBattleTextBar.TEXT_FORMAT;
			//textField.textColor = 0xFFFFFF;
			textField.selectable = false;
			textField.x = _paddingLeft * Configuration.SPRITE_SCALE + (_uiOverride == 22 || _uiOverride == 23 ? 1 * Configuration.SPRITE_SCALE : 0);
			textField.y = _paddingTop * Configuration.SPRITE_SCALE - (_uiOverride == 22 ? 8 * Configuration.SPRITE_SCALE : 0);
			textField.filters = [(_uiOverride != 22 ? Configuration.TEXT_FILTER : UIBattleTextBar.TEXT_FILTER)];
			textField.text = _text;
			textField.wordWrap = true;
			textField.mouseEnabled = false;
			textField.multiline = true;
			textField.width = _width * Configuration.SPRITE_SCALE - _paddingLeft * Configuration.SPRITE_SCALE - _paddingRight * Configuration.SPRITE_SCALE;
			textField.height = _height * Configuration.SPRITE_SCALE - _paddingTop * Configuration.SPRITE_SCALE - _paddingBottom * Configuration.SPRITE_SCALE + 5 * Configuration.SPRITE_SCALE;
			this.addChild(textField);
		}
		
		public function changeText(text:String):void
		{
			_text = text;
			textField.htmlText = _text;
		}
		
		public function destroy():void
		{
			this.removeChild(uiBox);
			uiBox.destroy();
			uiBox = null;
			
			this.removeChild(textField);
			textField = null;
		}
		
		private var _oldColorTransform:ColorTransform;
		
		public function dim():void
		{
			setTint(this, 0x000000, 0.5);
		}
		
		public function undim():void
		{
			setTint(this, 0x000000, 0);
		}
		
		private function setTint(displayObject:DisplayObject, tintColor:uint, tintMultiplier:Number):void
		{
			var colTransform:ColorTransform = new ColorTransform();
			colTransform.redMultiplier = colTransform.greenMultiplier = colTransform.blueMultiplier = 1 - tintMultiplier;
			colTransform.redOffset = Math.round(((tintColor & 0xFF0000) >> 16) * tintMultiplier);
			colTransform.greenOffset = Math.round(((tintColor & 0x00FF00) >> 8) * tintMultiplier);
			colTransform.blueOffset = Math.round(((tintColor & 0x0000FF)) * tintMultiplier);
			displayObject.transform.colorTransform = colTransform;
		}
	
	}

}