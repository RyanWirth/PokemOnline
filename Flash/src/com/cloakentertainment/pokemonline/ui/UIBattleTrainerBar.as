package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonStatusConditions;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBattleTrainerBar extends UISprite
	{
		[Embed(source="assets/UIBattleTrainerBar.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _arrow:Bitmap;
		private var _pokemon:Vector.<Pokemon>;
		private var left:Boolean;
		
		private var pokeballs:Vector.<Bitmap>;
		
		public function UIBattleTrainerBar(pokemon:Vector.<Pokemon>, _left:Boolean = true)
		{
			super(spriteImage);
			
			left = _left;
			_pokemon = pokemon;
			
			construct();
		}
		
		override public function construct():void
		{
			if (left)
				_arrow = getSprite(105, 7, 104, 4);
			else
				_arrow = getSprite(0, 7, 104, 4);
			this.addChild(_arrow);
			
			pokeballs = new Vector.<Bitmap>();
			for (var i:int = 0; i < 6; i++)
			{
				var pokeball:Bitmap;
				if (_pokemon != null && i >= _pokemon.length)
					pokeball = getSprite(7, 0, 7, 7);
				else if (_pokemon != null && (_pokemon[i].getNonVolatileStatusCondition() == PokemonStatusConditions.FAINT || _pokemon[i].CURRENT_HP == 0))
					pokeball = getSprite(14, 0, 7, 7); // Support for fainted pokeball icons in the future
				else
					pokeball = getSprite(0, 0, 7, 7);
				
				pokeball.y = -pokeball.height - Configuration.SPRITE_SCALE;
				if (left)
				{
					// Start on the right side
					pokeball.x = _arrow.width - 28 * Configuration.SPRITE_SCALE;
					pokeball.x -= i * 10 * Configuration.SPRITE_SCALE;
				}
				else
				{
					pokeball.x = 28 * Configuration.SPRITE_SCALE;
					pokeball.x += i * 10 * Configuration.SPRITE_SCALE;
				}
				
				var tempX:int = pokeball.x;
				if (left)
					pokeball.x -= _arrow.width;
				else
					pokeball.x += _arrow.width;
				
				TweenLite.delayedCall(i * 0.1, tweenPokeball, [pokeball, tempX]);
				
				this.addChild(pokeball);
				pokeballs.push(pokeball);
			}
			
			_pokemon = null;
		}
		
		private function tweenPokeball(pokeball:Bitmap, newX:int):void
		{
			TweenLite.to(pokeball, UIBattle.TRAINER_BAR_POKEBALL_TWEEN_TIME, {x: newX});
		}
		
		public function slideOut():void
		{
			if (pokeballs == null)
				return;
			
			for (var i:int = 0; i < pokeballs.length; i++)
			{
				tweenPokeball(pokeballs[i], !left ? Configuration.VIEWPORT.width + pokeballs[i].x : pokeballs[i].x - Configuration.VIEWPORT.width);
			}
			
			TweenLite.to(_arrow, UIBattle.TRAINER_BAR_POKEBALL_TWEEN_TIME, {alpha: 0, onComplete: destroy});
		}
		
		override public function destroy():void
		{
			if (_arrow)
			{
				this.removeChild(_arrow);
				_arrow.bitmapData.dispose();
				_arrow = null;
			}
			
			if (pokeballs)
			{
				for (var i:int = 0; i < pokeballs.length; i++)
				{
					this.removeChild(pokeballs[i]);
					pokeballs[i].bitmapData.dispose();
					pokeballs[i] = null;
				}
				pokeballs = null;
			}
		}
	
	}

}