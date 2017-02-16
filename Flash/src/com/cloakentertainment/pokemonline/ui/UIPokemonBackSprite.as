package com.cloakentertainment.pokemonline.ui 
{
	import com.greensock.TweenNano;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonBackSprite extends Sprite implements UIElement
	{
		private var pokemonSprite:UIPokemonBackSpriteTemplate;
		private var _pokemonID:int;
		private var _shiny:Boolean;
		private var _extraData:int;
		
		public function UIPokemonBackSprite(pokemonID:int, shiny:Boolean = false, extraData:int = 0) 
		{
			_pokemonID = pokemonID;
			_shiny = shiny;
			_extraData = extraData;
			
			construct();
		}
		
		public function construct():void
		{
			pokemonSprite = createPokemonVisualization();
			
			this.addChild(pokemonSprite);
		}
		
		private function createPokemonVisualization():UIPokemonBackSpriteTemplate
		{
			if (_shiny)
			{
				if (_pokemonID == 201) return new UIPokemonBackSpriteShinyUnown(_extraData);
				else return new UIPokemonBackSpriteShiny(_pokemonID);
			} else 
			{
				if (_pokemonID == 201) return new UIPokemonBackSpriteUnown(_extraData);
				else return new UIPokemonBackSpriteNonShiny(_pokemonID);
			}
		}
		
		private var statEffect:UIStatEffect;
		private var statEffectMask:UIPokemonBackSpriteTemplate;
		public function animateStatChange(statType:String, animateGoingUp:Boolean = true):void
		{
			statEffect = new UIStatEffect(statType, animateGoingUp, 1.25, removeAnimatedStatChange);
			statEffectMask = createPokemonVisualization();
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
		
		public function destroy():void
		{
			this.removeChild(pokemonSprite);
			pokemonSprite.destroy();
			pokemonSprite = null;
		}
		
		public function flicker(initialIterations:int = 5):void
		{
			if (initialIterations > 0) flicker_iterations_left = initialIterations;
			else flicker_iterations_left--;
			
			if (flicker_iterations_left > 0) TweenNano.delayedCall(5, flicker_animate, null, true);
			else show();
		}
		
		private function show():void
		{
			pokemonSprite.visible = true;
		}
		
		private function hide():void
		{
			pokemonSprite.visible = false;
		}
		
		private var flicker_iterations_left:int = 0;
		private function flicker_animate():void
		{
			if (pokemonSprite.visible) hide();
			else show();
			
			flicker(0);
		}
		
		private var shake_iterations_left:int = 0;
		public function shake(initialIterations:int = 5):void
		{
			if (initialIterations > 0) shake_iterations_left = initialIterations;
			else shake_iterations_left--;
			
			if (shake_iterations_left > 0) TweenNano.delayedCall(2, shake_animate, null, true);
			else reset_position();
		}
		
		private function reset_position():void
		{
			pokemonSprite.y = 0;
		}
		
		private function shake_down():void
		{
			pokemonSprite.y = 2 * Configuration.SPRITE_SCALE;
		}
		
		private function shake_animate():void
		{
			if (pokemonSprite.y == 0) shake_down();
			else reset_position();
			
			shake(0);
		}
		
		public function faint():void
		{
			TweenNano.to(pokemonSprite, 0.25, { y:pokemonSprite.height, onComplete:finishFaint, alpha:0 } );
		}
		
		private function finishFaint():void
		{
			hide();
		}
		
	}

}