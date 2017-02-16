package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.stats.Pokeballs;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokeballIcon extends UISprite
	{
		[Embed(source="assets/UIPokeballIcon.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _ball:Bitmap;
		private var _pokeballType:String;
		
		public function UIPokeballIcon(pokeballType:String) 
		{
			super(spriteImage);
			
			_pokeballType = pokeballType;
			
			construct();
		}
		
		override public function construct():void
		{
			drawFrame(1);
		}
		
		public function drawFrame(frameNum:int):void
		{
			var resourceID:int = Pokeballs.getIconIDFromName(_pokeballType) - 1;
			if (_ball)
			{
				this.removeChild(_ball);
				_ball = null;
			}
			
			var frameY:int = 0;
			var frameHeight:int = 12;
			
			if (frameNum == 2)
			{
				frameY = 12;
				frameHeight = 13;
			} else
			if (frameNum == 3)
			{
				frameY = 25;
				frameHeight = 16;
			}
			
			_ball = getSprite(resourceID * 12, frameY, 12, frameHeight);
			_ball.x = -_ball.width / 2;
			_ball.y = -_ball.height / 2;
			this.addChild(_ball);
		}
		
		override public function destroy():void
		{
			this.removeChild(_ball);
			_ball = null;
		}
		
	}

}