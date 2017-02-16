package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteCastformShiny extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_shiny_castform.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteCastformShiny(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex, false);
		}
		
	}

}