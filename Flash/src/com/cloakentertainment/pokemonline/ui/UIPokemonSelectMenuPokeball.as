package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	import com.cloakentertainment.pokemonline.Configuration;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSelectMenuPokeball extends UISprite
	{
		[Embed(source="assets/UIPokemonSelectMenuPokeball.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _sprite:Bitmap;
		
		private var _frame:int = 1;
		
		public function UIPokemonSelectMenuPokeball(startAnimating:Boolean = true) 
		{
			super(spriteImage);
			
			_frame = 1;
			construct();
			
			if(startAnimating) startAnimation();
		}
		
		override public function construct():void
		{
			removeSprite();
			
			switch(_frame)
			{
				case 1:
					_sprite = getSprite(24, 0, 22, 20);
					break;
				case 2:
					_sprite = getSprite(0, 0, 23, 20);
					_sprite.x = -1 * Configuration.SPRITE_SCALE;
					break;
				case 3:
					_sprite = getSprite(47, 0, 21, 20);
					_sprite.x = 1 * Configuration.SPRITE_SCALE;
					break;
			}
			
			this.addChild(_sprite);
		}
		
		private function createFrame(frameNum:int):void
		{
			_frame = frameNum;
			construct();
		}
		
		public function startAnimation():void
		{
			stopAnimation();
			
			TweenLite.delayedCall(8, createFrame, [2], true);
			TweenLite.delayedCall(16, createFrame, [1], true);
			TweenLite.delayedCall(24, createFrame, [3], true);
			TweenLite.delayedCall(32, createFrame, [1], true);
			TweenLite.delayedCall(40, createFrame, [2], true);
			TweenLite.delayedCall(44, createFrame, [1], true);
			TweenLite.delayedCall(48, createFrame, [3], true);
			TweenLite.delayedCall(52, createFrame, [1], true);
			TweenLite.delayedCall(56, createFrame, [2], true);
			TweenLite.delayedCall(60, createFrame, [1], true);
			
			TweenLite.delayedCall(2, startAnimation);
		}
		
		override public function destroy():void
		{
			stopAnimation();
			removeSprite();
		}
		
		private function removeSprite():void 
		{
			if (_sprite)
			{
				this.removeChild(_sprite);
				_sprite.bitmapData.dispose();
			}
			_sprite = null;
		}
		
		public function stopAnimation():void 
		{
			TweenLite.killDelayedCallsTo(createFrame);
			TweenLite.killDelayedCallsTo(startAnimation);
		}
		
	}

}