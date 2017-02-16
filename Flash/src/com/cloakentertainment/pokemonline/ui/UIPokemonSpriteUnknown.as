package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteUnknown extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_unknown.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteUnknown() 
		{
			super(spriteImage, 1, false);
		}
		
	}

}