package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.Configuration;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSummaryMenuXPBar extends UISprite
	{
		[Embed(source="assets/UIPokemonSummaryMenuXPBar.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var __width:int;
		
		public function UIPokemonSummaryMenuXPBar(_width:int) 
		{
			super(spriteImage);
			
			__width = _width;
			
			construct();
		}
		
		override public function construct():void
		{
			this.graphics.beginBitmapFill(spriteImage.bitmapData);
			this.graphics.drawRect(0, 0, __width * Configuration.SPRITE_SCALE, 3 * Configuration.SPRITE_SCALE);
			this.graphics.endFill();
		}
		
		override public function destroy():void
		{
			this.graphics.clear();
		}
		
	}

}