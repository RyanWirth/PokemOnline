package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteSpindaShiny extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_shiny_spinda.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteSpindaShiny(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex, false);
		}
		
	}

}