package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIIntroMenuBackground extends UISprite
	{
		[Embed(source="assets/UIIntroMenuBackground.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _bg:Bitmap;
		private var _fade:Bitmap;
		
		public function UIIntroMenuBackground() 
		{
			super(spriteImage);
			
			construct();
		}
		
		override public function construct():void
		{
			_bg = getSprite(0, 0, 240, 160);
			this.addChild(_bg);
			
			_fade = getSprite(0, 160, 240, 160);
			this.addChild(_fade);
			
			fadeOut();
		}
		
		public function fadeOut():void
		{
			TweenLite.to(_fade, 1.5, { alpha:0, onComplete:fadeIn } );
		}
		
		public function fadeIn():void
		{
			TweenLite.to(_fade, 1.5, { alpha:1, onComplete:fadeOut } );
		}
		
		override public function destroy():void
		{
			this.removeChild(_bg);
			this.removeChild(_fade);
			
			TweenLite.killTweensOf(_fade);
			
			_bg.bitmapData.dispose();
			_fade.bitmapData.dispose();
			_bg = _fade = null;
		}
		
	}

}