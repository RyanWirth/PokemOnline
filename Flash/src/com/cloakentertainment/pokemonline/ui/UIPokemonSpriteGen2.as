package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteGen2 extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_gen2.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteGen2(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex);
		}
		
	}

}