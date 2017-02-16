package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonBackSpriteTemplate extends UISprite implements UIElement
	{
		private var _spriteIndex:int;
		private var _sprite1:Bitmap;
		public function UIPokemonBackSpriteTemplate(spriteImage:Bitmap, spriteIndex:int) 
		{
			super(spriteImage);
			
			_spriteIndex = spriteIndex;
			construct();
		}
		
		override public function construct():void
		{
			// Gutter of 5px, sprites are 64x64
			var xCoord:int = (_spriteIndex-1) * 64;
			var yCoord:int = 0;
			while (xCoord >= _spriteImage.width)
			{
				xCoord -= _spriteImage.width;
				yCoord += 64;
			}
			
			_sprite1 = getSprite(xCoord, yCoord, 64, 64);
			
			this.addChild(_sprite1);
		}
		
		override public function destroy():void
		{
			this.removeChild(_sprite1);
			_sprite1.bitmapData.dispose();
			_sprite1 = null;
		}
		
	}

}