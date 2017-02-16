package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEPCTurnOff extends SoundEffect
	{
		[Embed(source="assets/SEPCTurnOff.mp3")]
        private static const embeddedSound:Class;
		
		public function SEPCTurnOff() 
		{
			super(embeddedSound);
		}
		
	}

}