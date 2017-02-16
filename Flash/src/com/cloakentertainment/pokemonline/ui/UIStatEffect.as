package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.stats.PokemonStat;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIStatEffect extends UISprite
	{
		[Embed(source="assets/UIStatEffect.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _statType:String;
		private var _animateGoingUp:Boolean;
		private var _duration:Number;
		private var finishCallback:Function;
		
		private var FADE_DURATION:Number = 0.25;
		
		private var sprites:Vector.<Bitmap>;
		
		public function UIStatEffect(statType:String, animateGoingUp:Boolean = true, duration:Number = 1.0, _finishCallback:Function = null) 
		{
			super(spriteImage);
			
			_statType = statType;
			_animateGoingUp = animateGoingUp;
			_duration = duration;
			finishCallback = _finishCallback;
			
			construct();
		}
		
		override public function construct():void
		{
			sprites = new Vector.<Bitmap>();
			var i:uint;
			var numSprites:int = 24;
			switch(_statType)
			{
				case PokemonStat.ACCURACY:
					for (i = 0; i < numSprites; i++) sprites.push(getSprite(192, 0, 32, 32));
					break;
				case PokemonStat.ATK:
					for (i = 0; i < numSprites; i++) sprites.push(getSprite(32, 0, 32, 32));
					break;
				case PokemonStat.DEF:
					for (i = 0; i < numSprites; i++) sprites.push(getSprite(64, 0, 32, 32));
					break;
				case PokemonStat.EVASION:
					for (i = 0; i < numSprites; i++) sprites.push(getSprite(224, 0, 32, 32));
					break;
				case PokemonStat.HP:
					// We can't animate an HP increase.
					throw(new Error("Stat cannot be animated: " + _statType + "!"));
					break;
				case PokemonStat.NONE:
					for (i = 0; i < numSprites; i++) sprites.push(getSprite(0, 0, 32, 32));
					// Mixed
					break;
				case PokemonStat.SPATK:
					for (i = 0; i < numSprites; i++) sprites.push(getSprite(128, 0, 32, 32));
					break;
				case PokemonStat.SPDEF:
					for (i = 0; i < numSprites; i++) sprites.push(getSprite(160, 0, 32, 32));
					break;
				case PokemonStat.SPEED:
					for (i = 0; i < numSprites; i++) sprites.push(getSprite(96, 0, 32, 32));
					break;
			}
			
			for (i = 0; i < numSprites; i++)
			{
				sprites[i].x = sprites[i].width * i;
				while (sprites[i].x >= sprites[i].width * 2)
				{
					sprites[i].x -= sprites[i].width * 2;
					sprites[i].y += sprites[i].height;
				}
				
				this.addChild(sprites[i]);
			}
			
			this.alpha = 0;
			TweenLite.to(this, FADE_DURATION, { alpha:0.5, onComplete:fadeIn } );
			
			if (!_animateGoingUp)
			{
				this.y = -0.5 * this.height;
			}
			
			TweenLite.to(this, _duration, { y: -0.4 * this.height * (_animateGoingUp ? 1 : 0), onComplete:finishCallback, ease:Linear.easeNone } );
		}
		
		private function fadeIn():void
		{
			TweenLite.to(this, _duration - FADE_DURATION * 2, { alpha:0.5, onComplete:fadeOut } );
		}
		
		private function fadeOut():void
		{
			TweenLite.to(this, FADE_DURATION, { alpha:0 } );
		}
		
		override public function destroy():void
		{
			for (var i:int = 0; i < sprites.length; i++)
			{
				this.removeChild(sprites[i]);
				sprites[i] = null;
			}
			sprites.splice(0, sprites.length);
			sprites = null;
		}
		
	}

}