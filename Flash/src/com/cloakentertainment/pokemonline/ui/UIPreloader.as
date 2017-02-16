package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author ...
	 */
	public class UIPreloader extends Sprite
	{
		[Embed(source = "assets/PokemonText.ttf", fontFamily = 'pokemonEmbed', fontWeight = 'normal', fontStyle = 'normal', fontName = "PokemonFont", mimeType = "application/x-font", advancedAntiAliasing = 'false', embedAsCFF = 'false')]
		public static const PokemonTextFont:Class;
		
		private var textfield:TextField;
		public static const tf:TextFormat = new TextFormat("PokemonFont", 16 * 3, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
		public function UIPreloader() 
		{
			Font.registerFont(PokemonTextFont);
			
			this.graphics.beginFill(0x282828);
			this.graphics.drawRect(0, 0, 960, 480);
			this.graphics.endFill();
			
			textfield = new TextField();
			textfield.width = 960;
			textfield.height = 16 * 3;
			textfield.text = "0%";
			textfield.embedFonts = true;
			textfield.textColor = 0xFFFFFF;
			textfield.y = 480 / 2 - textfield.height / 2;
			textfield.selectable = false;
			textfield.defaultTextFormat = tf;
			this.addChild(textfield);
		}
		
		public function updateStatus(text:String):void
		{
			textfield.text = text;
		}
		
		public function destroy():void
		{
			this.removeChild(textfield);
			textfield = null;
			
			this.graphics.clear();
		}
		
	}

}