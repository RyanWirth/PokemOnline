package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexSearchMenuButton extends Sprite implements UIElement
	{
		public static const BUTTON_FORMAT:TextFormat = new TextFormat("PokemonFont", 12 * Configuration.SPRITE_SCALE, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
		public static const BUTTON_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x203020, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		public static const BUTTON_SELECTED_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x387000, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);

		private var _deselectedState:Bitmap;
		private var _selectedState:Bitmap;
		private var _label:String;
		
		private var textField:TextField;
		
		public function UIPokedexSearchMenuButton(deselectedState:Bitmap, selectedState:Bitmap, label:String) 
		{
			_deselectedState = deselectedState;
			_selectedState = selectedState;
			_label = label;
			
			construct();
		}
		
		public function select():void
		{
			textField.filters = [BUTTON_SELECTED_FILTER];
			_deselectedState.visible = false;
			_selectedState.visible = true;
		}
		
		public function deselect():void
		{
			textField.filters = [BUTTON_FILTER];
			_deselectedState.visible = true;
			_selectedState.visible = false;
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
			textField.width = _deselectedState.width;
			textField.text = _label;
			
			this.addChild(textField);
		}
		
		public function destroy():void
		{
			_deselectedState = null;
			_selectedState = null;
			
			this.removeChild(textField);
			textField = null;
		}
		
	}

}