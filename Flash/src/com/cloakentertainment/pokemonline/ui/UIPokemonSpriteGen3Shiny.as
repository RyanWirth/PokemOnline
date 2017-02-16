package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteGen3Shiny extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_shiny_gen3.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteGen3Shiny(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex);
		}
		
	}

}