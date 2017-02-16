package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemartBuyMenuItem extends Sprite implements UIElement
	{
		public static var TEXT_FORMAT:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0x606060, null, null, null, null, null, null, null, null, null, 5);
		public static var TEXT_FORMAT_RIGHT:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0x606060, null, null, null, null, null, TextFormatAlign.RIGHT, null, null, null, 5);
		
		private var _nameTF:TextField;
		private var _costTF:TextField;
		
		private var _name:String;
		private var _cost:String;
		
		public function UIPokemartBuyMenuItem(name:String, cost:String) 
		{
			_name = name;
			_cost = cost;
			
			TEXT_FORMAT.letterSpacing = TEXT_FORMAT_RIGHT.letterSpacing = -0.5 * Configuration.SPRITE_SCALE;
			
			construct();
		}
		
		public function construct():void
		{
			_nameTF = new TextField();
			Configuration.setupTextfield(_nameTF, TEXT_FORMAT, Configuration.TEXT_FILTER);
			_nameTF.width = 112 * Configuration.SPRITE_SCALE;
			_nameTF.height = 16 * Configuration.SPRITE_SCALE;
			_nameTF.text = _name.replace("É", "é");
			this.addChild(_nameTF);
			
			_costTF = new TextField();
			Configuration.setupTextfield(_costTF, TEXT_FORMAT_RIGHT, Configuration.TEXT_FILTER);
			_costTF.width = 112 * Configuration.SPRITE_SCALE;
			_costTF.height = 16 * Configuration.SPRITE_SCALE;
			_costTF.text = _cost != "" ? Configuration.CURRENCY_SYMBOL + _cost : "";
			this.addChild(_costTF);
		}
		
		public function destroy():void
		{
			this.removeChild(_nameTF);
			this.removeChild(_costTF);
			
			_nameTF = _costTF = null;
		}
		
	}

}