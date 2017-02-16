package com.cloakentertainment.pokemonline.world.tile 
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.greensock.TweenLite;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author ...
	 */
	public class Tile extends MovieClip
	{
		/** Constants for the "tile type" identifier. **/
		public static const WATER:String = "WATER";
		public static const DOOR:String = "DOOR";
		public static const FLOWER:String = "FLOWER";
		public static const GRASS:String = "GRASS";
		public static const PC:String = "PC";
		public static const TELEVISION:String = "TELEVISION";
		public static const LIGHT_WATER:String = "LIGHT_WATER";
		
		private var _xTile:int;
		private var _yTile:int;
		private var _type:String;
		
		public function Tile(xTile:int, yTile:int, type:String, _textures:Vector.<Texture>, _fps:int) 
		{
			_xTile = xTile;
			_yTile = yTile;
			_type = type;
			
			super(_textures, _fps);
			
			this.loop = true;
			this.smoothing = TextureSmoothing.NONE;
		}
		
		private var _playingAndThenReversing:Boolean = false; // Keeps track of when the tile is opening/closing (i.e. playing forwards then backwards)
		private var _finishedPlayingNowReversing:Boolean = false;
		/** Plays the all the frames in the tile, waits, then reverses them and plays it backwards. */
		public function playThenReverse():void
		{
			if (_playingAndThenReversing) return;
			if (_finishedPlayingNowReversing)
			{
				// The door is being animated to close, stop that from happening!
				this.removeEventListener(Event.COMPLETE, finishReversing);
				this.reverseFrames();
				_finishedPlayingNowReversing = false;
			}
			if (this is TBlueDoor || this is TDoubleBlueDoor) SoundManager.playSoundEffect(SoundEffect.DOOR_SLIDE_OPEN);
			else SoundManager.playSoundEffect(SoundEffect.DOOR_OPEN);
			_playingAndThenReversing = true;
			play();
			this.addEventListener(Event.COMPLETE, finishPlaying);
		}
		
		public function flickerOn():void
		{
			TweenLite.killDelayedCallsTo(setFrame);
			TweenLite.delayedCall(5, setFrame, [1], true);
			TweenLite.delayedCall(10, setFrame, [0], true);
			TweenLite.delayedCall(15, setFrame, [1], true);
			TweenLite.delayedCall(20, setFrame, [0], true);
			TweenLite.delayedCall(25, setFrame, [1], true);
			TweenLite.delayedCall(30, setFrame, [0], true);
			TweenLite.delayedCall(35, setFrame, [1], true);
		}
		
		public function setFrame(frameNum:int):void
		{
			this.currentFrame = frameNum;
		}
		
		private function finishPlaying(e:Event):void
		{
			// At this point, the door is completely open***
			TweenLite.delayedCall(0.5, reverseThenPlay);
		}
		
		private function reverseThenPlay():void
		{
			_playingAndThenReversing = false;
			_finishedPlayingNowReversing = true;
			this.removeEventListener(Event.COMPLETE, finishPlaying);
			this.reverseFrames();
			this.addEventListener(Event.COMPLETE, finishReversing);
		}
		
		private function finishReversing(e:Event):void
		{
			_finishedPlayingNowReversing = false;
			this.removeEventListener(Event.COMPLETE, finishReversing);
			this.reverseFrames();
			stop();
		}
		
		/** Placeholder for special tiles. */
		public function playEffect():void {}
		
		public function get TYPE():String
		{
			return _type;
		}
		
		public function get X_TILE():int
		{
			return _xTile;
		}
		
		public function get Y_TILE():int
		{
			return _yTile;
		}
		
		public function destroy():void
		{
			this.removeEventListener(Event.COMPLETE, finishPlaying);
			this.removeEventListener(Event.COMPLETE, finishReversing);
			
			this.dispose();
		}
		
	}

}