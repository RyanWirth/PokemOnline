package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEPokemonLowHealthWarning extends SoundEffect
	{
		[Embed(source="assets/SEPokemonLowHealthWarning.mp3")]
        private static const embeddedSound:Class;
		
		public function SEPokemonLowHealthWarning() 
		{
			super(embeddedSound);
		}
		
	}

}