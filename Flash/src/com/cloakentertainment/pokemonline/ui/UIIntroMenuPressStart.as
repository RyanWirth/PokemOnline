package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIIntroMenuPressStart extends UISprite
	{
		[Embed(source="assets/UIIntroMenuPressStart.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _arrow:Bitmap;
		
		public function UIIntroMenuPressStart() 
		{
			super(spriteImage);
			
			construct();
		}
		
		override public function construct():void
		{
			_arrow = getSprite(0, 0, spriteImage.width, spriteImage.height);
			this.addChild(_arrow);
			
			toggle();
		}
		
		private function toggle():void
		{
			if (_arrow.visible) _arrow.visible = false;
			else _arrow.visible = true;
			
			TweenLite.delayedCall(0.5, toggle);
		}
		
		override public function destroy():void
		{
			TweenLite.killDelayedCallsTo(toggle);
			
			this.removeChild(_arrow);
			_arrow.bitmapData.dispose();
			_arrow = null;
		}
		
	}

}