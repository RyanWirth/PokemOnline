package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBox extends UISprite 
	{
		[Embed(source="assets/UIBox.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public var background:Sprite;
		
		private var _width:int;
		private var _height:int;
		private var _uiTypeOverride:int;
		
		public function UIBox(width:int, height:int, uiTypeOverride:int = -1):void 
		{
			super(spriteImage);
			
			_width = width;
			_height = height;
			_uiTypeOverride = uiTypeOverride;
			
			construct();
		}
		
		override public function destroy():void
		{
			if (background)
			{
			this.removeChild(background);
			background.graphics.clear();
			background = null;
			}
		}
		
		override public function construct():void
		{
			// Construct UIBox
			background = new Sprite();
			
			if (_uiTypeOverride == 22 || _uiTypeOverride == 23)
			{
				this.addChild(background);
				return;
			}
			
			// Calculate the starting coordinates for this UI Type
			var startX:int = ((_uiTypeOverride != -1 ? _uiTypeOverride : Configuration.UI_TYPE) - 1) * 24;
			var startY:int = 0;
			while (startX >= spriteImage.width)
			{
				startX -= spriteImage.width;
				startY += 24;
			}
			
			var cornerTopLeft:Bitmap = getSprite(startX, startY, 8, 8);
			var cornerTopRight:Bitmap = getSprite(startX + 16, startY, 8, 8);
			var cornerBotLeft:Bitmap = getSprite(startX, startY + 16, 8, 8);
			var cornerBotRight:Bitmap = getSprite(startX + 16, startY + 16, 8, 8);
			var midTop:Bitmap = getSprite(startX + 8, startY, 8, 8);
			var midLeft:Bitmap = getSprite(startX, startY + 8, 8, 8);
			var midBot:Bitmap = getSprite(startX + 8, startY + 16, 8, 8);
			var midRight:Bitmap = getSprite(startX + 16, startY + 8, 8, 8);
			var mid:Bitmap = getSprite(startX + 8, startY + 8, 8, 8);
			
			var matrix:Matrix = new Matrix();
			
			background.graphics.beginBitmapFill(mid.bitmapData);
			background.graphics.drawRect(4 * Configuration.SPRITE_SCALE, 4 * Configuration.SPRITE_SCALE,_width * Configuration.SPRITE_SCALE - 8 * Configuration.SPRITE_SCALE,_height * Configuration.SPRITE_SCALE - 8 * Configuration.SPRITE_SCALE);
			background.graphics.endFill();
			
			background.graphics.beginBitmapFill(cornerTopLeft.bitmapData, matrix, false);
			background.graphics.drawRect(0, 0, 8 * Configuration.SPRITE_SCALE, 8 * Configuration.SPRITE_SCALE);
			background.graphics.endFill();
			
			matrix.translate(_width * Configuration.SPRITE_SCALE - 8 * Configuration.SPRITE_SCALE, 0);
			background.graphics.beginBitmapFill(cornerTopRight.bitmapData, matrix, false);
			background.graphics.drawRect(_width * Configuration.SPRITE_SCALE - cornerTopRight.width, 0, 8 * Configuration.SPRITE_SCALE, 8 * Configuration.SPRITE_SCALE);
			background.graphics.endFill();
			
			matrix.translate(0, _height * Configuration.SPRITE_SCALE - 8 * Configuration.SPRITE_SCALE);
			background.graphics.beginBitmapFill(cornerBotRight.bitmapData, matrix, false);
			background.graphics.drawRect(_width * Configuration.SPRITE_SCALE - cornerBotRight.width,_height * Configuration.SPRITE_SCALE - cornerBotRight.height, 8 * Configuration.SPRITE_SCALE, 8 * Configuration.SPRITE_SCALE);
			background.graphics.endFill();
			
			matrix.translate( -1 * matrix.tx, 0);
			background.graphics.beginBitmapFill(cornerBotLeft.bitmapData, matrix, false);
			background.graphics.drawRect(0, _height * Configuration.SPRITE_SCALE - cornerBotLeft.height, 8 * Configuration.SPRITE_SCALE, 8 * Configuration.SPRITE_SCALE);
			background.graphics.endFill();
			
			background.graphics.beginBitmapFill(midTop.bitmapData);
			background.graphics.drawRect(8 * Configuration.SPRITE_SCALE, 0, _width * Configuration.SPRITE_SCALE - 16 * Configuration.SPRITE_SCALE, 8 * Configuration.SPRITE_SCALE);
			background.graphics.endFill();
			
			background.graphics.beginBitmapFill(midLeft.bitmapData);
			background.graphics.drawRect(0, 8 * Configuration.SPRITE_SCALE, 8 * Configuration.SPRITE_SCALE,_height * Configuration.SPRITE_SCALE - 16 * Configuration.SPRITE_SCALE);
			background.graphics.endFill();
			
			background.graphics.beginBitmapFill(midBot.bitmapData, matrix);
			background.graphics.drawRect(8 * Configuration.SPRITE_SCALE, _height * Configuration.SPRITE_SCALE - 8 * Configuration.SPRITE_SCALE, _width * Configuration.SPRITE_SCALE - 16 * Configuration.SPRITE_SCALE, 8 * Configuration.SPRITE_SCALE);
			background.graphics.endFill();
			
			matrix.translate(_width * Configuration.SPRITE_SCALE - 8 * Configuration.SPRITE_SCALE, -1 * matrix.ty);
			background.graphics.beginBitmapFill(midRight.bitmapData, matrix);
			background.graphics.drawRect(_width * Configuration.SPRITE_SCALE - 8 * Configuration.SPRITE_SCALE, 8 * Configuration.SPRITE_SCALE, 8 * Configuration.SPRITE_SCALE,_height * Configuration.SPRITE_SCALE - 16 * Configuration.SPRITE_SCALE);
			background.graphics.endFill();
			
			
			cornerTopLeft = cornerTopRight = cornerBotLeft = cornerBotRight = midTop = midLeft = midRight = midBot = mid = null; // Null the references to the above bitmaps, let them be Garbage Collected.
			
			background.cacheAsBitmap = true;
			this.addChild(background);
		}
		
	}

}