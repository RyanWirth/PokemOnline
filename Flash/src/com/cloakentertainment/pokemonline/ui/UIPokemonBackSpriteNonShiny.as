package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonBackSpriteNonShiny extends UIPokemonBackSpriteTemplate
	{
		[Embed(source="../data/pokemon_backs.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonBackSpriteNonShiny(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex);
		}
		
	}

}