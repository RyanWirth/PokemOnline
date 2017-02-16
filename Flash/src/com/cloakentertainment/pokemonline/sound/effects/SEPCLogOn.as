package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEPCLogOn extends SoundEffect
	{
		[Embed(source="assets/SEPCLogOn.mp3")]
        private static const embeddedSound:Class;
		
		public function SEPCLogOn() 
		{
			super(embeddedSound);
		}
		
	}

}