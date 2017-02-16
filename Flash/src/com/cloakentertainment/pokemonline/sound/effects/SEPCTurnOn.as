package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEPCTurnOn extends SoundEffect
	{
		[Embed(source="assets/SEPCTurnOn.mp3")]
        private static const embeddedSound:Class;
		
		public function SEPCTurnOn() 
		{
			super(embeddedSound);
		}
		
	}

}