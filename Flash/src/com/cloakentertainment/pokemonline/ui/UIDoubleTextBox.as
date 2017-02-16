package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.ui.UIBattleTextBar;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIDoubleTextBox extends Sprite implements UIElement
	{
		public static const TEXT_FORMAT_RIGHT:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0x606060, null, null, null, null, null, TextFormatAlign.RIGHT, null, null, null, 5);
		
		public var uiBox:UIBox;
		private var textField1:TextField;
		private var textField2:TextField;
		
		private var _paddingLeft:Number;
		private var _paddingRight:Number;
		private var _paddingTop:Number;
		private var _paddingBottom:Number;
		private var _uiOverride:int;
		
		private var _text1:String;
		private var _text2:String;
		private var _width:int;
		private var _height:int;
		
		public function UIDoubleTextBox(text1:String, text2:String, width:int, height:int, paddingLeft:Number = 0, paddingRight:Number = 0, paddingTop:Number = 0, paddingBottom:Number = 0, uiOverride:int = -1):void
		{
			_paddingLeft = paddingLeft;
			_paddingRight = paddingRight;
			_paddingTop = paddingTop;
			_paddingBottom = paddingBottom;
			_text1 = text1;
			_text2 = text2;
			_width = width;
			_height = height;
			_uiOverride = uiOverride;
			
			construct();
		}
		
		public function get TEXT_FIELD1():TextField
		{
			return textField1;
		}
		
		public function get TEXT_FIELD2():TextField
		{
			return textField2;
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
		
		public function construct():void
		{
			uiBox = new UIBox(_width, _height, _uiOverride);
			this.addChild(uiBox);
			
			textField1 = new TextField();
			textField1.embedFonts = true;
			textField1.defaultTextFormat = _uiOverride != 22 ? Configuration.TEXT_FORMAT : UIBattleTextBar.TEXT_FORMAT;
			//textField.textColor = 0xFFFFFF;
			textField1.selectable = false;
			textField1.x = _paddingLeft * Configuration.SPRITE_SCALE + (_uiOverride == 22 || _uiOverride == 23 ? 1 * Configuration.SPRITE_SCALE : 0);
			textField1.y = _paddingTop * Configuration.SPRITE_SCALE - (_uiOverride == 22 ? 8 * Configuration.SPRITE_SCALE : 0);
			textField1.filters = [(_uiOverride != 22 ? Configuration.TEXT_FILTER : UIBattleTextBar.TEXT_FILTER)];
			textField1.text = _text1;
			textField1.wordWrap = true;
			textField1.mouseEnabled = false;
			textField1.multiline = true;
			textField1.width = _width * Configuration.SPRITE_SCALE - _paddingLeft * Configuration.SPRITE_SCALE - _paddingRight * Configuration.SPRITE_SCALE;
			textField1.height = _height * Configuration.SPRITE_SCALE - _paddingTop * Configuration.SPRITE_SCALE - _paddingBottom * Configuration.SPRITE_SCALE + 5 * Configuration.SPRITE_SCALE;
			this.addChild(textField1);
			
			textField2 = new TextField();
			textField2.embedFonts = true;
			textField2.defaultTextFormat = _uiOverride != 22 ? TEXT_FORMAT_RIGHT : UIBattleTextBar.TEXT_FORMAT;
			//textField.textColor = 0xFFFFFF;
			textField2.selectable = false;
			textField2.x = _paddingLeft * Configuration.SPRITE_SCALE + (_uiOverride == 22 || _uiOverride == 23 ? 1 * Configuration.SPRITE_SCALE : 0);
			textField2.y = _paddingTop * Configuration.SPRITE_SCALE - (_uiOverride == 22 ? 8 * Configuration.SPRITE_SCALE : 0);
			textField2.filters = [(_uiOverride != 22 ? Configuration.TEXT_FILTER : UIBattleTextBar.TEXT_FILTER)];
			textField2.text = _text2;
			textField2.wordWrap = true;
			textField2.mouseEnabled = false;
			textField2.multiline = true;
			textField2.width = _width * Configuration.SPRITE_SCALE - _paddingLeft * Configuration.SPRITE_SCALE - _paddingRight * Configuration.SPRITE_SCALE;
			textField2.height = _height * Configuration.SPRITE_SCALE - _paddingTop * Configuration.SPRITE_SCALE - _paddingBottom * Configuration.SPRITE_SCALE + 5 * Configuration.SPRITE_SCALE;
			this.addChild(textField2);
		}
		
		public function changeText1(text:String):void
		{
			_text1 = text;
			textField1.htmlText = _text1;
		}
		
		public function changeText2(text:String):void
		{
			_text2 = text;
			textField2.htmlText = _text2;
		}
		
		public function destroy():void
		{
			this.removeChild(uiBox);
			uiBox.destroy();
			uiBox = null;
			
			this.removeChild(textField1);
			this.removeChild(textField2);
			textField1 = textField2 = null;
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