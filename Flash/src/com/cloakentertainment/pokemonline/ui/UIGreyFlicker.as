package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIGreyFlicker extends Sprite
	{
		private var _iterations:int;
		private var _callback:Function;
		private var _fadeDuration:Number;
		
		public function UIGreyFlicker(callback:Function, iterations:int = 8, fadeDuration:Number = 0.1)
		{
			_callback = callback;
			_iterations = iterations;
			_fadeDuration = fadeDuration;
			
			this.graphics.beginFill( 0x666666);
			this.graphics.drawRect(Configuration.VIEWPORT.x, Configuration.VIEWPORT.y, Configuration.VIEWPORT.width, Configuration.VIEWPORT.height);
			this.graphics.endFill();
			this.alpha = 0;
			
			fadeIn();
		}
		
		private function fadeIn():void
		{
			if (_iterations <= 0)
			{
				complete();
				return;
			}
			
			_iterations--;
			
			TweenLite.to(this, _fadeDuration, { alpha:0.8, onComplete:fadeOut } );
		}
		
		private function fadeOut():void
		{
			TweenLite.to(this, _fadeDuration, { alpha:0, onComplete:fadeIn } );
		}
		
		private function complete():void
		{
			this.graphics.clear();
			
			if (_callback != null) _callback();
			_callback = null;
		}
		
		public function destroy():void
		{
			this.graphics.clear();
			_callback = null;
			
		}
	
	}

}