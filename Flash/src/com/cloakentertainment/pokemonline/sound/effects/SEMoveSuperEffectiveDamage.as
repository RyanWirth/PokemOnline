package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEMoveSuperEffectiveDamage extends SoundEffect
	{
		[Embed(source="assets/SEMoveSuperEffectiveDamage.mp3")]
        private static const embeddedSound:Class;
		
		public function SEMoveSuperEffectiveDamage() 
		{
			super(embeddedSound);
		}
		
	}

}