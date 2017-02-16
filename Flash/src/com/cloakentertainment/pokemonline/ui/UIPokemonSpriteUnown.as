package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteUnown extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_unown.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteUnown(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex, false);
		}
		
	}

}