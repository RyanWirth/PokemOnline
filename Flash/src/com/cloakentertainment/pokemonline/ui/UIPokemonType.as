package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import com.cloakentertainment.pokemonline.stats.PokemonType;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonType extends UISprite
	{
		[Embed(source="assets/UIPokemonType.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _typeSprite:Bitmap;
		private var _type:String;
		
		public function UIPokemonType(type:String) 
		{
			super(spriteImage);
			
			_type = type;
			
			construct();
		}
		
		public function changeType(newType:String):void
		{
			destroy();
			_type = newType;
			construct();
		}
		
		override public function construct():void
		{
			var rectangle:Rectangle; // 32x14
			switch(_type)
			{
				case PokemonType.BUG:
					rectangle = new Rectangle(32 * 2, 14 * 1, 32, 14);
					break;
				case PokemonType.DARK:
					rectangle = new Rectangle(32 * 1, 14 * 4, 32, 14);
					break;
				case PokemonType.DRAGON:
					rectangle = new Rectangle(32 * 0, 14 * 4, 32, 14);
					break;
				case PokemonType.ELECTRIC:
					rectangle = new Rectangle(32 * 1, 14 * 3, 32, 14);
					break;
				case PokemonType.FIGHTING:
					rectangle = new Rectangle(32 * 1, 14 * 0, 32, 14);
					break;
				case PokemonType.FIRE:
					rectangle = new Rectangle(32 * 2, 14 * 2, 32, 14);
					break;
				case PokemonType.FLYING:
					rectangle = new Rectangle(32 * 2, 14 * 0, 32, 14);
					break;
				case PokemonType.GHOST:
					rectangle = new Rectangle(32 * 3, 14 * 1, 32, 14);
					break;
				case PokemonType.GRASS:
					rectangle = new Rectangle(32 * 0, 14 * 3, 32, 14);
					break;
				case PokemonType.GROUND:
					rectangle = new Rectangle(32 * 0, 14 * 1, 32, 14);
					break;
				case PokemonType.ICE:
					rectangle = new Rectangle(32 * 3, 14 * 3, 32, 14);
					break;
				case PokemonType.NORMAL:
					rectangle = new Rectangle(32 * 0, 14 * 0, 32, 14);
					break;
				case PokemonType.POISON:
					rectangle = new Rectangle(32 * 3, 14 * 0, 32, 14);
					break;
				case PokemonType.PSYCHIC:
					rectangle = new Rectangle(32 * 2, 14 * 3, 32, 14);
					break;
				case PokemonType.ROCK:
					rectangle = new Rectangle(32 * 1, 14 * 1, 32, 14);
					break;
				case PokemonType.STEEL:
					rectangle = new Rectangle(32 * 0, 14 * 2, 32, 14);
					break;
				case PokemonType.UNKNOWN:
					rectangle = new Rectangle(32 * 1, 14 * 2, 32, 14);
					break;
				case PokemonType.WATER:
					rectangle = new Rectangle(32 * 3, 14 * 2, 32, 14);
					break;
				default:
					throw(new Error("Unknown PokemonType " + _type));
					break;
			}
			
			_typeSprite = getSprite(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
			this.addChild(_typeSprite);
			
			rectangle = null;
		}
		
		override public function destroy():void
		{
			this.removeChild(_typeSprite);
			_typeSprite.bitmapData.dispose();
			_typeSprite = null;
		}
		
	}

}