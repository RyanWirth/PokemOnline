package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteGen2Shiny extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_shiny_gen2.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteGen2Shiny(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex);
		}
		
	}

}