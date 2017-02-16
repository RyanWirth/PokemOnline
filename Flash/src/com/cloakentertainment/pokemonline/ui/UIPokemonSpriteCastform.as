package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSpriteCastform extends UIPokemonSpriteTemplate
	{
		[Embed(source="../data/pokemon_castform.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public function UIPokemonSpriteCastform(spriteIndex:int) 
		{
			super(spriteImage, spriteIndex, false);
		}
		
	}

}