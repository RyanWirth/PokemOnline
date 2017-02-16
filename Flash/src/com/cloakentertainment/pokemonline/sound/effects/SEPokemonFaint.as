package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEPokemonFaint extends SoundEffect
	{
		[Embed(source="assets/SEPokemonFaint.mp3")]
        private static const embeddedSound:Class;
		
		public function SEPokemonFaint() 
		{
			super(embeddedSound);
		}
		
	}

}