package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteGen1Shiny extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_shiny_gen1.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteGen1Shiny(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex);
		}
		
	}

}