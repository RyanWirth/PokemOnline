package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEEnterKeyBing extends SoundEffect
	{
		[Embed(source="assets/SEEnterKeyBing.mp3")]
        private static const embeddedSound:Class;
		
		public function SEEnterKeyBing() 
		{
			super(embeddedSound);
		}
		
	}

}