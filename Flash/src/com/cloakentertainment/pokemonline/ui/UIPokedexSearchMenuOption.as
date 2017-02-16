package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexSearchMenuOption extends Sprite implements UIElement
	{
		public static const BUTTON_FORMAT:TextFormat = new TextFormat("PokemonFont", 14 * Configuration.SPRITE_SCALE, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
		public static const BUTTON_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x000000, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		public static const BUTTON_SELECTED_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x802020, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		
		private var _deselectedState:Bitmap;
		private var _selectedState:Bitmap;
		private var _label:String;
		private var _value:String;
		
		private var textField:TextField;
		private var valueTextField:TextField;
		
		public function UIPokedexSearchMenuOption(deselectedState:Bitmap, selectedState:Bitmap, label:String, value:String) 
		{
			_deselectedState = deselectedState;
			_selectedState = selectedState;
			_label = label;
			_value = value;
			
			construct();
		}
		
		public function changeValue(newValue:String):void
		{
			_value = newValue;
			valueTextField.text = newValue;
		}
		
		public function get VALUE():String
		{
			return _value;
		}
		
		public function select():void
		{
			_selectedState.visible = true;
			_deselectedState.visible = false;
		}
		
		public function deselect():void
		{
			_selectedState.visible = false;
			_deselectedState.visible = true;
		}
		
		public function construct():void
		{
			this.addChild(_deselectedState);
			this.addChild(_selectedState);
			_selectedState.visible = false;
			
			textField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = BUTTON_FORMAT;
			textField.filters = [BUTTON_FILTER];
			textField.selectable = false;
			textField.width = 32 * Configuration.SPRITE_SCALE;
			textField.text = _label;
			
			valueTextField = new TextField();
			valueTextField.embedFonts = true;
			valueTextField.defaultTextFormat = Configuration.TEXT_FORMAT_POKEDEX;
			valueTextField.filters = [Configuration.TEXT_FILTER_POKEDEX];
			valueTextField.selectable = false;
			valueTextField.width = 88 * Configuration.SPRITE_SCALE;
			valueTextField.text = _value;
			valueTextField.x = 42 * Configuration.SPRITE_SCALE;
			
			this.addChild(valueTextField);
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
			this.removeChild(_selectedState);
			
			_deselectedState = null;
			_selectedState = null;
			
			this.removeChild(textField);
			this.removeChild(valueTextField);
			valueTextField = null;
			textField = null;
		}
		
	}

}