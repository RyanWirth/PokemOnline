package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteSpinda extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_spinda.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteSpinda(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex, false);
		}
		
	}

}