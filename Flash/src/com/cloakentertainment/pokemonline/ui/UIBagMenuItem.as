package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBagMenuItem extends Sprite implements UIElement
	{
		public static const TEXT_FORMAT_POKEDEX_RIGHT:TextFormat = new TextFormat("PokemonFont", 14 * Configuration.SPRITE_SCALE, 0x000000, null, null, null, null, null, TextFormatAlign.RIGHT, null, null, null, 5);
	
		private var textfield:TextField;
		private var count_textfield:TextField;
		
		private var _label:String;
		private var _real_name:String;
		private var _number:int;
		
		public function UIBagMenuItem(label:String = "DEFAULT ITEM", number:int = 1, realname:String = "") 
		{
			_real_name = realname;
			_label = label;
			_number = number;
			
			construct();
		}
		
		public function construct():void
		{
			textfield = new TextField();
			Configuration.setupTextfield(textfield, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			textfield.width = 114 * Configuration.SPRITE_SCALE;
			textfield.height = 16 * Configuration.SPRITE_SCALE;
			textfield.text = _label;
			this.addChild(textfield);
			
			count_textfield = new TextField();
			Configuration.setupTextfield(count_textfield, TEXT_FORMAT_POKEDEX_RIGHT, Configuration.TEXT_FILTER);
			count_textfield.width = textfield.width;
			count_textfield.height = textfield.height;
			count_textfield.text = "x" + (_number < 10 ? " " : "") + _number;
			this.addChild(count_textfield);
			
			if (_number == 0) count_textfield.visible = false;
		}
		
		public function get ITEM_COUNT():int
		{
			return _number;
		}
		
		public function get ITEM_NAME():String
		{
			return _label;
		}
		
		public function get ITEM_REAL_NAME():String
		{
			return _real_name;
		}
		
		public function destroy():void
		{
			this.removeChild(textfield);
			this.removeChild(count_textfield);
			
			textfield = count_textfield = null;
		}
		
	}

}