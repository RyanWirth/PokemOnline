package com.cloakentertainment.pokemonline.world.sprite 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import com.greensock.TweenLite;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class SPokemonCenterMachine extends Sprite
	{
		private var _balls:Vector.<SPokemonCenterMachineBall>;
		private var _callback:Function;
		private var _screen:SPokemonCenterScreen;
		
		public function SPokemonCenterMachine(callback:Function = null ) 
		{
			_callback = callback;
			construct();
		}
		
		public function construct():void
		{
			_balls = new Vector.<SPokemonCenterMachineBall>();
			
			addBall();
		}
		
		private function addBall():void
		{
			if (_balls.length < Configuration.ACTIVE_TRAINER.getPartySize())
			{
				var ball:SPokemonCenterMachineBall = new SPokemonCenterMachineBall();
				ball.x = (_balls.length + 1) % 2 == 0 ? 6 * Configuration.SPRITE_SCALE : 0;
				ball.x += 10 * Configuration.SPRITE_SCALE;
				ball.y = Math.floor(_balls.length / 2) * 4 * Configuration.SPRITE_SCALE;
				ball.y += 9 * Configuration.SPRITE_SCALE;
				this.addChild(ball);
				_balls.push(ball);
				
				TweenLite.delayedCall(0.5, addBall);
			} else
			{
				// We've added all the balls!
				for (var i:int = 0; i < _balls.length; i++)
				{
					WorldManager.JUGGLER.add(_balls[i]);
					_balls[i].play();
				}
			
				SoundManager.playMusicTrack(114, 1, true, true);
				
				_screen = new SPokemonCenterScreen();
				_screen.x = 36 * Configuration.SPRITE_SCALE;
				_screen.y = -5 * Configuration.SPRITE_SCALE;
				this.addChild(_screen);
				WorldManager.JUGGLER.add(_screen);
				_screen.play();
				
				TweenLite.delayedCall(2, finishAnimation);
			}
		}
		
		private function finishAnimation():void
		{
			for (var i:int = 0; i < _balls.length; i++) _balls[i].stop();
			_screen.stop();
			WorldManager.JUGGLER.remove(_screen);
			
			if (_callback != null) _callback();
			_callback = null;
			
		}
		
		public function destroy():void
		{
			for (var i:int = 0; i < _balls.length; i++)
			{
				WorldManager.JUGGLER.remove(_balls[i]);
				this.removeChild(_balls[i]);
				_balls[i].dispose();
				_balls[i] = null;
			}
			
			_balls = null;
			
			this.removeChild(_screen);
			_screen.dispose();
			_screen = null;
			
			_callback = null;
		}
		
	}

}