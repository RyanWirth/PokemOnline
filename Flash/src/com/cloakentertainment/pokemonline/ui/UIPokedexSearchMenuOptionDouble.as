package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexSearchMenuOptionDouble extends Sprite implements UIElement
	{
		public static const BUTTON_FORMAT:TextFormat = new TextFormat("PokemonFont", 14 * Configuration.SPRITE_SCALE, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
		public static const BUTTON_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x000000, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		public static const BUTTON_SELECTED_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x802020, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		
		private var _deselectedState:Bitmap;
		private var _selectedState1:Bitmap;
		private var _selectedState2:Bitmap;
		private var _label:String;
		private var _value1:String;
		private var _value2:String;
		
		private var textField:TextField;
		private var value1TextField:TextField;
		private var value2TextField:TextField;
		
		public function UIPokedexSearchMenuOptionDouble(deselectedState:Bitmap, selectedState1:Bitmap, selectedState2:Bitmap, label:String, value1:String, value2:String)
		{
			_deselectedState = deselectedState;
			_selectedState1 = selectedState1;
			_selectedState2 = selectedState2;
			_label = label;
			_value1 = value1;
			_value2 = value2;
			
			construct();
		}
		
		public function select(value:int = 1):void
		{
			_selectedState1.visible = value == 1 ? true : false;
			_selectedState2.visible = value == 2 ? true : false;
			_deselectedState.visible = false;
		}
		
		public function deselect():void
		{
			_selectedState1.visible = _selectedState2.visible = false;
			_deselectedState.visible = true;
		}
		
		public function get selection():int
		{
			if (_selectedState1.visible) return 1;
			else if (_selectedState2.visible) return 2;
			else return 0;
		}
		
		public function changeValue(newValue:String):void
		{
			if (selection == 1)
			{
				_value1 = newValue;
				value1TextField.text = newValue;
			} else
			if (selection == 2)
			{
				_value2 = newValue;
				value2TextField.text = newValue;
			}
		}
		
		public function get VALUE1():String
		{
			return _value1;
		}
		
		public function get VALUE2():String
		{
			return _value2;
		}
		
		public function construct():void
		{
			this.addChild(_deselectedState);
			this.addChild(_selectedState1);
			this.addChild(_selectedState2);
			_selectedState1.visible = _selectedState2.visible = false;
			
			textField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = BUTTON_FORMAT;
			textField.filters = [BUTTON_FILTER];
			textField.selectable = false;
			textField.width = 32 * Configuration.SPRITE_SCALE;
			textField.text = _label;
			
			value1TextField = new TextField();
			value1TextField.embedFonts = true;
			value1TextField.defaultTextFormat = Configuration.TEXT_FORMAT_POKEDEX;
			value1TextField.filters = [Configuration.TEXT_FILTER_POKEDEX];
			value1TextField.selectable = false;
			value1TextField.width = 40 * Configuration.SPRITE_SCALE;
			value1TextField.text = _value1;
			value1TextField.x = 42 * Configuration.SPRITE_SCALE;
			
			value2TextField = new TextField();
			value2TextField.embedFonts = true;
			value2TextField.defaultTextFormat = Configuration.TEXT_FORMAT_POKEDEX;
			value2TextField.filters = [Configuration.TEXT_FILTER_POKEDEX];
			value2TextField.selectable = false;
			value2TextField.width = 40 * Configuration.SPRITE_SCALE;
			value2TextField.text = _value2;
			value2TextField.x = 90 * Configuration.SPRITE_SCALE;
			
			this.addChild(value1TextField);
			this.addChild(value2TextField);
			this.addChild(textField);
		}
		
		public function darken(turnOnTint:Boolean = true):void
		{
			if (turnOnTint)
			{
				setTint(this, 0x000000, 0.3);
			}
			else
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
		
		public function destroy():void
		{
			this.removeChild(_deselectedState);
			this.removeChild(_selectedState1);
			this.removeChild(_selectedState2);
			
			_deselectedState = null;
			_selectedState1 = null;
			_selectedState2 = null;
			
			this.removeChild(textField);
			this.removeChild(value1TextField);
			this.removeChild(value2TextField);
			value1TextField = value2TextField = null;
			textField = null;
		}
	
	}

}