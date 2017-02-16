package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIFadeOut extends Sprite
	{
		private var _midwayCallback:Function;
		private var _midwayCallbackParams:Array;
		
		public function UIFadeOut(midwayCallback:Function, white:Boolean = false, durationOverride:int = -1, midwayCallbackParams:Array = null)
		{
			_midwayCallback = midwayCallback;
			_midwayCallbackParams = midwayCallbackParams;
			
			this.graphics.beginFill(white ? 0xFFFFFF : 0x000000);
			this.graphics.drawRect(Configuration.VIEWPORT.x, Configuration.VIEWPORT.y, Configuration.VIEWPORT.width, Configuration.VIEWPORT.height);
			this.graphics.endFill();
			this.alpha = 0;
			
			TweenLite.to(this, durationOverride == -1 ? Configuration.FADE_DURATION / 2 : durationOverride, {alpha: 1, onComplete: midway});
		}
		
		private function midway():void
		{
			if (Configuration.uiFadeOut)
				Configuration.STAGE.setChildIndex(Configuration.uiFadeOut, Configuration.STAGE.numChildren - 1);
			if (_midwayCallback != null)
			{
				if (_midwayCallbackParams != null) TweenLite.delayedCall(1, _midwayCallback, _midwayCallbackParams, true);
				else _midwayCallback();
			}
			TweenLite.to(this, Configuration.FADE_DURATION / 2, {alpha: 0, onComplete: complete});
		}
		
		private function complete():void
		{
			this.graphics.clear();
			
			_midwayCallback = null;
			_midwayCallbackParams = null;
			Configuration.STAGE.removeChild(this);
			Configuration.uiFadeOut = null;
		}
	
	}

}