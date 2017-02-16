package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.greensock.TweenLite;
	import com.cloakentertainment.pokemonline.Configuration;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UITrainerBackSprite extends UISprite
	{
		[Embed(source="assets/UITrainerBackSprite.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _trainer:Bitmap;
		private var _type:String;
		
		private var frame:int = 1;
		private var animating:Boolean = false;
		
		public function UITrainerBackSprite(type:String) 
		{
			super(spriteImage);
			
			_type = type;
			if (_type != TrainerType.HERO_FEMALE && _type != TrainerType.HERO_MALE && _type != TrainerType.WALLY) throw(new Error("Unknown TrainerType '" + type + "'."));
			
			construct();
		}
		
		override public function construct():void
		{
			destroy();
			
			if (frame > 4) return;
			
			switch(frame)
			{
				case 1:
					if (_type == TrainerType.HERO_MALE) _trainer = getSprite(0, 0, 50, 52);
					else if(_type == TrainerType.HERO_FEMALE) _trainer = getSprite(0, 52, 50, 48);
					else if (_type == TrainerType.WALLY) _trainer = getSprite(0, 100, 50, 52);
					break;
				case 2:
					if (_type == TrainerType.HERO_MALE) _trainer = getSprite(50, 0, 65, 52);
					else if(_type == TrainerType.HERO_FEMALE) _trainer = getSprite(50, 52, 65, 48);
					else if (_type == TrainerType.WALLY) _trainer = getSprite(0, 100, 50, 52);
					break;
				case 3:
					if (_type == TrainerType.HERO_MALE) _trainer = getSprite(115, 0, 47, 52);
					else if(_type == TrainerType.HERO_FEMALE) _trainer = getSprite(115, 52, 47, 48);
					else if (_type == TrainerType.WALLY) _trainer = getSprite(0, 100, 50, 52);
					break;
				case 4:
					if (_type == TrainerType.HERO_MALE) _trainer = getSprite(197, 0, 29, 52);
					else if (_type == TrainerType.HERO_FEMALE) _trainer = getSprite(197, 52, 29, 48);
					else if (_type == TrainerType.WALLY) _trainer = getSprite(0, 100, 50, 52);
					break;
			}
			
			_trainer.y = 52 * Configuration.SPRITE_SCALE - _trainer.height;
			
			this.addChild(_trainer);
			
			if (animating) TweenLite.delayedCall(0.2, animate );
		}
		
		public function animate():void
		{
			animating = true;
			
			frame++;
			
			construct();
		}
		
		override public function destroy():void
		{
			if (_trainer)
			{
				this.removeChild(_trainer);
				_trainer.bitmapData.dispose();
				_trainer = null;
			}
		}
		
	}

}