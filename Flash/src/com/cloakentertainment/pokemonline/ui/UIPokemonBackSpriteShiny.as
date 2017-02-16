package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonBackSpriteShiny extends UIPokemonBackSpriteTemplate
	{
		[Embed(source="../data/pokemon_shiny_backs.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonBackSpriteShiny(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex);
		}
		
	}

}