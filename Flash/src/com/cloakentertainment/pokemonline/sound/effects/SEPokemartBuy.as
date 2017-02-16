package com.cloakentertainment.pokemonline.sound.effects 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SEPokemartBuy extends SoundEffect
	{
		[Embed(source="assets/SEPokemartBuy.mp3")]
        private static const embeddedSound:Class;
		
		public function SEPokemartBuy() 
		{
			super(embeddedSound);
		}
		
	}

}