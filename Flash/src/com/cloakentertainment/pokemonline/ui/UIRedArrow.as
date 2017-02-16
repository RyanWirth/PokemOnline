package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	import com.cloakentertainment.pokemonline.Configuration;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIRedArrow extends UISprite
	{
		[Embed(source="assets/UIRedArrow.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _arrow:Bitmap;
		
		public function UIRedArrow() 
		{
			super(spriteImage);
			
			construct();
		}
		
		override public function construct():void
		{
			_arrow = getSprite(0, 0, spriteImage.width, spriteImage.height);
			this.addChild(_arrow);
			
			slideDown();
		}
		
		override public function destroy():void
		{
			TweenLite.killTweensOf(_arrow);
			
			this.removeChild(_arrow);
			_arrow.bitmapData.dispose();
			_arrow = null;
		}
		
		private function slideDown():void 
		{
			TweenLite.to(_arrow, 0.5, { y:1 * Configuration.SPRITE_SCALE, onComplete:slideUp } );
		}
		
		private function slideUp():void
		{
			TweenLite.to(_arrow, 0.5, { y:0 * Configuration.SPRITE_SCALE, onComplete:slideDown } );
		}
		
	}

}