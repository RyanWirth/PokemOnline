package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteUnownShiny extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_shiny_unown.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteUnownShiny(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex, false);
		}
		
	}

}