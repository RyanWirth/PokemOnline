package com.cloakentertainment.pokemonline.world.sprite
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.Color;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.HexColorsPlugin;
	TweenPlugin.activate([HexColorsPlugin]);
	
	/**
	 * ...
	 * @author ...
	 */
	public class SDayNightCycle extends Sprite
	{
		
		private var _currentTime:int;
		private var _currentDayState:int = -1;
		
		private var _image:Image;
		
		public static const MIDNIGHT:int = 0;
		public static const MORNING_START:int = 50;
		public static const MORNING_END:int = 100;
		public static const NOON:int = 300;
		public static const EVENING_START:int = 500;
		public static const EVENING_END:int = 550;
		private static const END_OF_DAY:int = 600;
		
		public function SDayNightCycle(time:int = 0)
		{
			startCycle(time);
		}
		
		public function startCycle(time:int = 0):void
		{
			_currentTime = time;
			_currentDayState = getDayState(_currentTime);
			if (_image) return; // If the filter has already been created, simply update the time. The state will change on the next tick of updateTime.
			
			_image = new Image(Texture.fromColor(Configuration.VIEWPORT.width, Configuration.VIEWPORT.height));
			_image.alpha = 0;
			this.addChild(_image);
			
			// Set the properties of the image to their initial values
			var state:Object = getStateProperties(_currentDayState);
			_image.color = state.hexColors.color;
			_image.alpha = state.alpha;
			
			TweenLite.delayedCall(1, updateTime);
		}
		
		public function destroy():void
		{
			stopCycle();
		}
		
		public function stopCycle():void
		{
			TweenLite.killDelayedCallsTo(updateTime);
			
			if (_image)
			{
				this.removeChild(_image);
				_image.dispose();
				_image = null;
			}
		}
		
		private function updateTime():void
		{
			_currentTime++;
			if (_currentTime >= END_OF_DAY) _currentTime = 0;
			var newDayState:int = getDayState(_currentTime);
			if (_currentDayState != newDayState)
			{
				// We're entering a new time period - update!
				_currentDayState = newDayState;
				
				//trace("Fading to day state " + _currentDayState);
				fadeToDayState(_currentDayState);
			}
			
			TweenLite.delayedCall(1, updateTime);
		}
		
		public function fadeToDayState(dayState:int):void
		{
			//trace("Switching to DayState: " + dayState);
			TweenLite.killTweensOf(SDayNightCycle);
			var state:Object = getStateProperties(dayState);
			TweenLite.to(_image, 50, state  );
		}
		
		public static function getStateProperties(dayState:int):Object
		{
			switch(dayState)
			{
				case MIDNIGHT:
				case EVENING_END:
					return { alpha:0.5, hexColors: { color:Color.BLACK }, ease:Linear.easeNone};
					break;
				case EVENING_START:
				case MORNING_START:
					return { alpha:0.25, hexColors: { color:Color.YELLOW }, ease:Linear.easeNone};
					break;
				case NOON:
				case MORNING_END:
					default:
					return { alpha:0, hexColors: { color:Color.BLACK }, ease:Linear.easeNone};
					break;
			}
		}
		
		public static function getDayState(time:int):int
		{
			if (time < MORNING_START) return MIDNIGHT;
			else if (time < MORNING_END) return MORNING_START;
			else if (time < NOON) return MORNING_END;
			else if (time < EVENING_START) return NOON;
			else if (time < EVENING_END) return EVENING_START;
			else if (time < END_OF_DAY) return EVENING_END;
			else return END_OF_DAY;
		}
	
	}

}