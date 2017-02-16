package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEInGameMenuOpen extends SoundEffect
	{
		[Embed(source="assets/SEInGameMenuOpen.mp3")]
        private static const embeddedSound:Class;
		
		public function SEInGameMenuOpen() 
		{
			super(embeddedSound);
		}
		
	}

}