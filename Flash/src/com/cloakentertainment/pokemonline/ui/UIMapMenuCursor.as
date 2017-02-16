package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIMapMenuCursor extends UISprite
	{
		[Embed(source="assets/UIMapMenuCursor.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _arrow:Bitmap;
		
		public function UIMapMenuCursor() 
		{
			super(spriteImage);
			
			construct();
		}
		
		override public function construct():void
		{
			drawFrame(1);
		}
		
		public function drawFrame(frameNum:int):void
		{
			destroy();
			
			_arrow = getSprite((frameNum - 1) * spriteImage.height, 0, spriteImage.height, spriteImage.height);
			this.addChild(_arrow);
			_arrow.x = _arrow.width * -0.5;
			_arrow.y = _arrow.height * -0.5;
			
			TweenLite.delayedCall(0.5, drawFrame, [frameNum == 1 ? 2 : 1]);
		}
		
		override public function destroy():void
		{
			TweenLite.killDelayedCallsTo(drawFrame);
			
			if (_arrow)
			{
				this.removeChild(_arrow);
				_arrow.bitmapData.dispose();
			}
			_arrow = null;
		}
		
	}

}