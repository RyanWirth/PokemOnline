package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexMenuSideArrow extends UISprite
	{
		[Embed(source="assets/UIPokedexMenuSideArrow.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _arrow:Bitmap;
		
		public function UIPokedexMenuSideArrow() 
		{
			super(spriteImage);
			
			construct();
		}
		
		
		
		override public function construct():void
		{
			_arrow = getSprite(0, 0, spriteImage.width, spriteImage.height);
			this.addChild(_arrow);
			origX = 5;
			startTween();
		}
		
		private var origX:int;
		private function startTween():void
		{
			var newX:int = origX - 10;
			TweenLite.to(this, 0.25, { x:newX, onComplete:finishTween } );
		}
		
		private function finishTween():void
		{
			TweenLite.to(this, 0.25, { x:origX, onComplete:startTween } );
		}
		
		override public function destroy():void
		{
			TweenLite.killTweensOf(this);
			this.removeChild(_arrow);
			_arrow.bitmapData.dispose();
			_arrow = null;
		}
		
	}

}