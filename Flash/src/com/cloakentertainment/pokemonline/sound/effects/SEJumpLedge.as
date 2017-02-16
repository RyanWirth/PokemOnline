package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEJumpLedge extends SoundEffect
	{
		[Embed(source="assets/SEJumpLedge.mp3")]
        private static const embeddedSound:Class;
		
		public function SEJumpLedge() 
		{
			super(embeddedSound);
		}
		
	}

}