package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIItemSprite extends UISprite
	{
		[Embed(source="../data/pokemon_items_sprites.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		[Embed(source='../data/pokemon_items_sprites.json',mimeType='application/octet-stream')]
		private static const items:Class;
		private static const _items:Object = JSON.parse(new items());
		
		private var _spriteName:String;
		private var _sprite:Bitmap;
		
		public function UIItemSprite(itemSpriteName:String)
		{
			super(spriteImage);
			
			_spriteName = itemSpriteName;
			
			construct();
		}
		
		override public function construct():void
		{
			// look up the item x and y coordinates in the json sheet
			var obj:Object = _items.frames[_spriteName];
			if (obj == null)
				throw(new Error("Sprite " + _spriteName + " not found in the Items spritesheet!"));
			var xCoord:int = obj.frame.x;
			var yCoord:int = obj.frame.y;
			var spriteWidth:int = obj.frame.w;
			var spriteHeight:int = obj.frame.h;
			
			_sprite = getSprite(xCoord, yCoord, spriteWidth, spriteHeight);
			_sprite.x = -0.5 * spriteWidth * Configuration.SPRITE_SCALE;
			_sprite.y = -0.5 * spriteHeight * Configuration.SPRITE_SCALE;
			this.addChild(_sprite);
		}
		
		override public function destroy():void
		{
			this.removeChild(_sprite);
			_sprite = null;
		}
	
	}

}