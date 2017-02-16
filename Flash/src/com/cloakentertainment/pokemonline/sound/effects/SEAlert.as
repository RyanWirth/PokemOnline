package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEAlert extends SoundEffect
	{
		[Embed(source="assets/SEAlert.mp3")]
        private static const embeddedSound:Class;
		
		public function SEAlert() 
		{
			super(embeddedSound);
		}
		
	}

}