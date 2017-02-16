package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSprite extends Sprite implements UIElement
	{
		private var pokemon:UIPokemonSpriteTemplate;
		private var _pokemonID:int;
		private var _shiny:Boolean;
		private var _extraData:int;
		
		public var position:int = 0;
		
		public function UIPokemonSprite(pokemonID:int, shiny:Boolean = false, extraData:int = 0) 
		{
			_pokemonID = pokemonID;
			_shiny = shiny;
			_extraData = extraData;
			
			construct();
		}
		
		public function construct():void
		{
			pokemon = createPokemonVisualization();
			
			this.addChild(pokemon);
		}
		
		private function createPokemonVisualization():UIPokemonSpriteTemplate
		{
			if (_pokemonID == -1)
			{
				// Unknown
				return new UIPokemonSpriteUnknown();
			} else
			if (_pokemonID == 201)
			{
				if (_shiny) return new UIPokemonSpriteUnownShiny(_extraData);
				else return new UIPokemonSpriteUnown(_extraData);
			} else
			if (_pokemonID == 327)
			{
				// Spinda
				if (_shiny) return new UIPokemonSpriteSpindaShiny(1);
				else return new UIPokemonSpriteSpinda(1);
			} else
			if (_pokemonID == 351)
			{
				// Castform
				if (_shiny) return new UIPokemonSpriteCastformShiny(_extraData);
				else return new UIPokemonSpriteCastform(_extraData);
			} else
			if (_pokemonID <= 151)
			{
				// Use Gen1
				if (_shiny) return new UIPokemonSpriteGen1Shiny(_pokemonID);
				else return new UIPokemonSpriteGen1(_pokemonID);
			} else
			if (_pokemonID <= 251)
			{
				// Use Gen2
				if (_shiny) return new UIPokemonSpriteGen2Shiny(_pokemonID - (_pokemonID <= 201 ? 151 : 152));
				else return new UIPokemonSpriteGen2(_pokemonID - (_pokemonID <= 201 ? 151 : 152));
			} else
			if (_pokemonID <= 386)
			{
				// Use Gen3
				if (_shiny) return new UIPokemonSpriteGen3Shiny(_pokemonID - (_pokemonID <= 327 ? 251 : (_pokemonID <= 351 ? 252 : 253)));
				else return new UIPokemonSpriteGen3(_pokemonID - (_pokemonID <= 327 ? 251 : (_pokemonID <= 351 ? 252 : 253)));
			} else throw(new Error("Unknown Pokemon ID " + _pokemonID));
		}
		
		public function destroy():void
		{
			this.removeChild(pokemon);
			pokemon.destroy();
			pokemon = null;
		}
		
		private var statEffect:UIStatEffect;
		private var statEffectMask:UIPokemonSpriteTemplate;
		public function animateStatChange(statType:String, animateGoingUp:Boolean = true):void
		{
			statEffect = new UIStatEffect(statType, animateGoingUp, 1.25, removeAnimatedStatChange);
			statEffectMask = createPokemonVisualization();
			if (pokemon.TOGGLED) statEffectMask.toggle(); // Make sure we show the same sprite as the currently visible one!
			statEffect.cacheAsBitmap = true;
			statEffectMask.cacheAsBitmap = true;
			statEffect.mask = statEffectMask;
			this.addChild(statEffectMask);
			this.addChild(statEffect);
		}
		
		private function removeAnimatedStatChange():void
		{
			if (!statEffect) return;
			
			this.removeChild(statEffect);
			this.removeChild(statEffectMask);
			statEffectMask.destroy();
			statEffect.destroy();
			statEffect = null;
			statEffectMask = null;
		}
		
		public function toggle():void
		{
			pokemon.toggle();
		}
		
		public function get ID():int
		{
			return _pokemonID;
		}
		
	}

}