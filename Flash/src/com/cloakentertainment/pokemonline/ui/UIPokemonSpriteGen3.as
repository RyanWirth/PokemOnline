package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteGen3 extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_gen3.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteGen3(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex);
		}
		
	}

}