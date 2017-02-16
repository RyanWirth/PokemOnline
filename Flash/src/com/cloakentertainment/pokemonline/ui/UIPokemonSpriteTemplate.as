package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteTemplate extends UISprite implements UIElement
	{
		private var _spriteIndex:int;
		private var _sprite1:Bitmap;
		private var _sprite2:Bitmap;
		private var _addPadding:Boolean;
		public var TOGGLED:Boolean = false;
		public function UIPokemonSpriteTemplate(spriteImage:Bitmap, spriteIndex:int, addPadding:Boolean = true) 
		{
			super(spriteImage);
			
			_addPadding = addPadding;
			_spriteIndex = spriteIndex;
			construct();
		}
		
		override public function construct():void
		{
			// Gutter of 5px, sprites are 64x64
			var xCoord:int = (_spriteIndex - 1) * 138; // 64 * 2 + 5 * 2
			var yCoord:int = 0;
			var padding:int = _addPadding ? 5 : 0;
			while (xCoord + 5 >= _spriteImage.width)
			{
				yCoord += 64 + padding;
				xCoord -= _spriteImage.width - padding;
			}
			
			_sprite1 = getSprite(xCoord + padding, yCoord + padding, 64, 64);
			_sprite2 = getSprite(xCoord + padding + 64 + padding, yCoord + padding, 64, 64);
			
			this.addChild(_sprite1);
			this.addChild(_sprite2);
			_sprite2.visible = false;
		}
		
		public function toggle():void
		{
			// Toggles between sprite1 and sprite2
			if (_sprite1.visible)
			{
				_sprite1.visible = false;
				_sprite2.visible = true;
				TOGGLED = true;
			} else
			{
				_sprite1.visible = true;
				_sprite2.visible = false;
				TOGGLED = false;
			}
		}
		
		override public function destroy():void
		{
			this.removeChild(_sprite1);
			this.removeChild(_sprite2);
			_sprite1.bitmapData.dispose();
			_sprite2.bitmapData.dispose();
			_sprite1 = null;
			_sprite2 = null;
		}
		
	}

}