package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonBackSpriteUnown extends UIPokemonBackSpriteTemplate
	{
		[Embed(source="../data/pokemon_unown_backs.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonBackSpriteUnown(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex);
		}
		
	}

}