package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonBackSpriteShinyUnown extends UIPokemonBackSpriteTemplate
	{
		[Embed(source="../data/pokemon_shiny_unown_backs.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonBackSpriteShinyUnown(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex);
		}
		
	}

}