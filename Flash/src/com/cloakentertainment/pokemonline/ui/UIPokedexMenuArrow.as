package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexMenuArrow extends UISprite
	{
		[Embed(source="assets/UIPokedexMenuArrow.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _arrow:Bitmap;
		private var _up:Boolean = true;
		
		public function UIPokedexMenuArrow(up:Boolean = true) 
		{
			super(spriteImage);
			
			_up = up;
			
			construct();
		}
		
		override public function construct():void
		{
			if (_up) _arrow = getSprite(0, 0, 14, 8);
			else _arrow = getSprite(0, 8, 14, 8);
			this.addChild(_arrow);
		}
		
		private var _origY:int;
		public function startAnimating():void
		{
			_origY = this.y;
			var newY:int = _origY + (_up ? -20 : 20);
			TweenLite.to(this, 0.25, { y:newY, onComplete:returnY, ease:Linear.easeInOut } );
		}
		
		private function returnY():void
		{
			TweenLite.to(this, 0.25, { y:_origY, onComplete:startAnimating, ease:Linear.easeInOut } );
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