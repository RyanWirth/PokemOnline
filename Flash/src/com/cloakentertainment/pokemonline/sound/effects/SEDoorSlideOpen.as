package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEDoorSlideOpen extends SoundEffect
	{
		[Embed(source="assets/SEDoorSlideOpen.mp3")]
        private static const embeddedSound:Class;
		
		public function SEDoorSlideOpen() 
		{
			super(embeddedSound);
		}
		
	}

}