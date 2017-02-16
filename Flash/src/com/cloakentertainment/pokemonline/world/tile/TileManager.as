package com.cloakentertainment.pokemonline.world.tile
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TileManager
	{
		[Embed(source = "assets/tileset.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		private static var bmd:BitmapData;
		private static var bmdwidth:int;
		private static var INITIALIZED:Boolean = false;
		
		private static var sourcerect:Rectangle;
		private static var destinationpoint:Point;
		
		public function TileManager()
		{
			if (INITIALIZED) return;
			INITIALIZED = true;
			bmd = scaleBitmapData(spriteImage.bitmapData, Configuration.SPRITE_SCALE);
			bmdwidth = bmd.width;
			sourcerect = new Rectangle(0, 0, 16 * Configuration.SPRITE_SCALE, 16 * Configuration.SPRITE_SCALE);
			destinationpoint = new Point();
		}
		
		private static var xPos:int = 0;
		private static var yPos:int = 0;
		
		public static function retrieveTile(tileindex:int, destination:BitmapData, destinationX:int, destinationY:int):BitmapData
		{
			if (!INITIALIZED) throw(new Error("TileManager is not initialized."));
			
			//trace("Retrieving " + tileindex + " and placing at " + destinationX + "," + destinationY);
			
			xPos = ((tileindex - 1) * 17 + 1) * Configuration.SPRITE_SCALE;
			yPos = 1 * Configuration.SPRITE_SCALE;
			while (xPos >= bmdwidth)
			{
				xPos -= bmdwidth;
				yPos += 17 * Configuration.SPRITE_SCALE;
			}
			
			sourcerect.x = xPos;
			sourcerect.y = yPos;
			
			destinationpoint.x = destinationX;
			destinationpoint.y = destinationY;
			
			destination.copyPixels(bmd, sourcerect, new Point(destinationX, destinationY), null, null, true);
			return destination;
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
	
	}

}