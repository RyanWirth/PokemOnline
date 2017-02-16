package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.greensock.TweenNano;
	import com.worlize.gif.GIFPlayer;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonAnimatedSprite extends Sprite implements UIElement
	{
		private var _pokemonID:int;
		private var _shiny:Boolean;
		private var _extraData:int;
		private var _autoplay:Boolean;
		
		private var placeholderSprite:UIPokemonSprite;
		
		private var player:GIFPlayer;
		private var initialY:int = 0;
		private var flicker_iterations_left:int = 0;
		private var shake_iterations_left:int = 0;
		private var _center:Boolean;
		
		public function UIPokemonAnimatedSprite(pokemonID:int, shiny:Boolean = false, extraData:int = 0, autoplay:Boolean = true, center:Boolean = true)
		{
			_pokemonID = pokemonID;
			_shiny = shiny;
			_extraData = extraData;
			_autoplay = autoplay;
			_center = center;
			
			construct();
		}
		
		public function construct():void
		{
			var url:String = Configuration.WEB_ASSETS_URL + "pokemon/hotlink-ok/battle_animations/" + (_shiny ? "shiny" : "normal") + "/" + _pokemonID + ".gif";
			var request:URLRequest = new URLRequest(url);
			
			placeholderSprite = new UIPokemonSprite(_pokemonID, _shiny, _extraData);
			placeholderSprite.x = placeholderSprite.y = initialY = placeholderSprite.width * -0.5;
			this.addChild(placeholderSprite);
			
			player = new GIFPlayer(_autoplay, finishLoadingGIF);
			player.load(request);
			player.setLoopCount(1);
			player.scaleX = player.scaleY = Configuration.SPRITE_SCALE;
			
			this.addChild(player);
		}
		
		public function animate():void
		{
			if (!_finishedLoading) return;
			
			player.visible = true;
			placeholderSprite.visible = false;
			
			player.play();
		}
		
		public function flicker(initialIterations:int = 5):void
		{
			if (initialIterations > 0)
				flicker_iterations_left = initialIterations;
			else
				flicker_iterations_left--;
			
			if (flicker_iterations_left > 0)
				TweenNano.delayedCall(5, flicker_animate, null, true);
			else
				show();
		}
		
		private function show():void
		{
			player.visible = false;
			placeholderSprite.visible = true;
		}
		
		private function hide():void
		{
			player.visible = false;
			placeholderSprite.visible = false;
		}
		
		private function flicker_animate():void
		{
			if (placeholderSprite.visible)
				hide();
			else
				show();
			
			flicker(0);
		}
		
		public function shake(initialIterations:int = 5):void
		{
			if (initialIterations > 0)
				shake_iterations_left = initialIterations;
			else
				shake_iterations_left--;
			
			if (shake_iterations_left > 0)
				TweenNano.delayedCall(2, shake_animate, null, true);
			else
				reset_position();
		}
		
		private function reset_position():void
		{
			placeholderSprite.y = initialY;
			player.y = 0;
		}
		
		private function shake_down():void
		{
			placeholderSprite.y += 2 * Configuration.SPRITE_SCALE;
			player.y += 2 * Configuration.SPRITE_SCALE;
		}
		
		private function shake_animate():void
		{
			if (placeholderSprite.y == initialY)
				shake_down();
			else
				reset_position();
			
			shake(0);
		}
		
		public function faint():void
		{
			TweenNano.to(placeholderSprite, 0.25, {y: initialY + placeholderSprite.height, onComplete: finishFaint, alpha: 0});
			TweenNano.to(player, 0.25, {y: player.y + placeholderSprite.height, alpha: 0});
		}
		
		private function finishFaint():void
		{
			hide();
		}
		
		public function animateStatChange(statType:String, goingUp:Boolean):void
		{
			player.visible = false;
			placeholderSprite.visible = true;
			
			placeholderSprite.animateStatChange(statType, goingUp);
		}
		
		public function get ID():int
		{
			return _pokemonID;
		}
		
		private var _finishedLoading:Boolean = false;
		private function finishLoadingGIF(w:int, h:int):void
		{
			placeholderSprite.visible = false;
			_finishedLoading = true;
			
			player.x = w * -0.5 * Configuration.SPRITE_SCALE;
			player.y = h * -0.5 * Configuration.SPRITE_SCALE;
			
			//if (!_center) player.y = (64 - h) * Configuration.SPRITE_SCALE;
		}
		
		public function destroy():void
		{
			this.removeChild(player);
			player.dispose();
			player = null;
			
			if (placeholderSprite)
			{
				this.removeChild(placeholderSprite);
				placeholderSprite.destroy();
				placeholderSprite = null;
			}
		}
	
	}

}