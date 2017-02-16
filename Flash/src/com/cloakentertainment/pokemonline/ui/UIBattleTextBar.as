package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import flash.text.TextField;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBattleTextBar extends UISprite
	{
		[Embed(source="assets/UIBattleTextBar.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;	
		
		public static const TEXT_FORMAT:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0xf8f8f8, null, null, null, null, null, null, null, null, null, 5);
		public static const TEXT_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x685870, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);

		
		private var _arrow:Bitmap;
		private var textField:TextField;
		
		public function UIBattleTextBar() 
		{
			super(spriteImage);
			
			construct();
		}
		
		public function hide():void
		{
			textField.visible = false;
		}
		
		public function show():void
		{
			textField.visible = true;
		}
		
		override public function construct():void
		{
			_arrow = getSprite(0, 0, spriteImage.width, spriteImage.height);
			this.addChild(_arrow);
		}
		
		public function displayText(text:String):void
		{
			if (!textField)
			{
				textField = new TextField();
				textField.embedFonts = true;
				textField.defaultTextFormat = TEXT_FORMAT;
				//textField.textColor = 0xFFFFFF;
				textField.selectable = false;
				textField.x = 9 * Configuration.SPRITE_SCALE;
				textField.y = 6 * Configuration.SPRITE_SCALE;
				textField.filters = [TEXT_FILTER];
				textField.wordWrap = true;
				textField.width = 112 * Configuration.SPRITE_SCALE;
				textField.height = 38 * Configuration.SPRITE_SCALE;
				this.addChild(textField);
			}
			
			textField.text = text;
		}
		
		public function hideText():void
		{
			if (textField)
			{
				this.removeChild(textField);
				textField = null;
			}
		}
		
		override public function destroy():void
		{
			hideText();
			
			this.removeChild(_arrow);
			_arrow.bitmapData.dispose();
			_arrow = null;
		}
		
	}

}