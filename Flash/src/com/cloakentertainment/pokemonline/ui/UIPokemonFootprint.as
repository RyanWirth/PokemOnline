package com.cloakentertainment.pokemonline.ui 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonFootprint extends UISprite
	{
		[Embed(source="../data/pokemon_footprints.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _footprint:Bitmap;
		private var _pokemonID:int;
		
		public function UIPokemonFootprint(pokemonID:int) 
		{
			super(spriteImage);
			
			_pokemonID = pokemonID;
			
			construct();
		}
		
		override public function construct():void
		{	
			var xCoord:int = (_pokemonID - 1) * 16;
			var yCoord:int = 0;
			while (xCoord >= spriteImage.width)
			{
				xCoord -= spriteImage.width;
				yCoord += 16;
			}
			
			_footprint = getSprite(xCoord, yCoord, 16, 16);
			
			this.addChild(_footprint);
		}
		
		override public function destroy():void
		{
			this.removeChild(_footprint);
			_footprint = null;
		}
		
	}

}