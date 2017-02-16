package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEMoveIneffectiveDamage extends SoundEffect
	{
		[Embed(source="assets/SEMoveIneffectiveDamage.mp3")]
        private static const embeddedSound:Class;
		
		public function SEMoveIneffectiveDamage() 
		{
			super(embeddedSound);
		}
		
	}

}