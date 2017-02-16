package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteGen1 extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_gen1.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteGen1(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex);
		}
		
	}

}