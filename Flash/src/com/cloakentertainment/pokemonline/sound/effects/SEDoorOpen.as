package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEDoorOpen extends SoundEffect
	{
		[Embed(source="assets/SEDoorOpen.mp3")]
        private static const embeddedSound:Class;
		
		public function SEDoorOpen() 
		{
			super(embeddedSound);
		}
		
	}

}