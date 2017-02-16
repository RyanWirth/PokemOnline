package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UICreateAccountMenuBirch extends UISprite
	{
		[Embed(source="assets/UICreateAccountMenuBirch.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _frame:Bitmap;
		private var _curFrame:int;
		
		public function UICreateAccountMenuBirch() 
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
			destroyFrame();
			
			_curFrame = frameNum;
			
			var xPos:int = (frameNum - 1) * 105;
			var yPos:int = 0;
			while (xPos >= _spriteImage.width)
			{
				xPos -= _spriteImage.width;
				yPos += 96;
			}
			
			_frame = getSprite(xPos, yPos, 105, 96);
			this.addChild(_frame);
		}
		
		public function animate():void
		{
			if (_curFrame > 29) return;
			
			drawFrame(_curFrame + 1);
			TweenLite.delayedCall(3, animate, null, true);
		}
		
		override public function destroy():void
		{
			destroyFrame();
		}
		
		private function destroyFrame():void 
		{
			if (!_frame) return;
			
			this.removeChild(_frame);
			_frame.bitmapData.dispose();
			_frame = null;
		}
		
	}

}