package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBlackArrow extends UISprite
	{
		[Embed(source="assets/UIBlackArrow.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _arrow:Bitmap;
		
		public function UIBlackArrow() 
		{
			super(spriteImage);
			
			construct();
		}
		
		override public function construct():void
		{
			_arrow = getSprite(0, 0, spriteImage.width, spriteImage.height);
			this.addChild(_arrow);
		}
		
		override public function destroy():void
		{
			this.removeChild(_arrow);
			_arrow.bitmapData.dispose();
			_arrow = null;
		}
		
	}

}