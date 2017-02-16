package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UITrainerSprite extends UISprite
	{
		[Embed(source="../data/pokemon_trainers.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _trainer:Bitmap;
		private var _type:String;
		
		public function UITrainerSprite(type:String) 
		{
			super(spriteImage);
			
			_type = type;
			
			construct();
		}
		
		override public function construct():void
		{
			var spriteIndex:int = TrainerType.getTrainerSpriteIndex(_type);
			var xCoord:int = spriteIndex * 64;
			var yCoord:int = 0;
			while (xCoord >= spriteImage.width)
			{
				xCoord -= spriteImage.width;
				yCoord += 64;
			}
			
			_trainer = getSprite(xCoord, yCoord, 64, 64);
			
			_trainer.x = -0.5 * _trainer.width;
			_trainer.y = -0.5 * _trainer.height;
			
			this.addChild(_trainer);
		}
		
		override public function destroy():void
		{
			this.removeChild(_trainer);
			_trainer = null;
		}
		
	}

}