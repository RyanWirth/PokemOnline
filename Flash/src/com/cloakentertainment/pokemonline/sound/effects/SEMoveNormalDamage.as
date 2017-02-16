package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEMoveNormalDamage extends SoundEffect
	{
		[Embed(source="assets/SEMoveNormalDamage.mp3")]
        private static const embeddedSound:Class;
		
		public function SEMoveNormalDamage() 
		{
			super(embeddedSound);
		}
		
	}

}