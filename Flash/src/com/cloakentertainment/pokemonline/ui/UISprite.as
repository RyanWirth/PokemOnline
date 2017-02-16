package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UISprite extends Sprite implements UIElement
	{
		protected var _spriteImage:Bitmap;
		
		public function UISprite(spriteImage:Bitmap)
		{
			_spriteImage = spriteImage;
		}
		
		public function getSprite(x:int, y:int, width:int, height:int):Bitmap
		{
			if (!_spriteImage)
				throw(new Error("SpriteImage is null, cannot getSprite."));
			var bitmapData:BitmapData = new BitmapData(width, height, true, 0x000000);
			bitmapData.copyPixels(_spriteImage.bitmapData, new Rectangle(x, y, width, height), new Point(0, 0), null, null, true);
			var bitmap:Bitmap = new Bitmap(scaleBitmapData(bitmapData, Configuration.SPRITE_SCALE), "auto", false);
			return bitmap;
		}
		
		private static function scaleBitmapData(bitmapData:BitmapData, scale:Number):BitmapData
		{
			scale = Math.abs(scale);
			var width:int = (bitmapData.width * scale) || 1;
			var height:int = (bitmapData.height * scale) || 1;
			var transparent:Boolean = bitmapData.transparent;
			var result:BitmapData = new BitmapData(width, height, transparent, 0x000000);
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			result.draw(bitmapData, matrix);
			return result;
		}
		
		public function destroy():void
		{
			_spriteImage.bitmapData.dispose();
			_spriteImage = null;
		}
		
		public function construct():void
		{
			
		}
	
	}

}