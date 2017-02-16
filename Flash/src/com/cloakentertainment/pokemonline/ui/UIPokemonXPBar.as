package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Sprite;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonXPBar extends Sprite implements UIElement
	{
		private var blue:Sprite;
		
		private var displayedXP:Number;
		private var totalXP:Number;
		private var _barheight:int;
		
		public function UIPokemonXPBar(currentXP:int, _totalXP:int, barheight:int = 2) 
		{
			displayedXP = currentXP;
			totalXP = _totalXP;
			_barheight = barheight;
			construct();
		}
		
		public function get DISPLAYED_XP():Number
		{
			return displayedXP;
		}
		
		public function get TOTAL_XP():Number
		{
			return totalXP;
		}
		
		public function updateXP(newCurrentXP:int, callback:Function = null):Number
		{
			trace("Updating XP: " + newCurrentXP + ", " + totalXP);
			var newWidth:Number = (newCurrentXP / totalXP) * 64 * Configuration.SPRITE_SCALE;
			var duration:Number = Math.abs(newWidth - blue.width) * 0.025;
			displayedXP = newCurrentXP;
			TweenLite.to(blue, duration, { width:newWidth, ease:Linear.easeNone } );
			
			if (duration < 1.5) duration = 1.5;
			
			TweenLite.delayedCall(duration, callback);
			
			return duration;
		}
		
		private function setBarWidths():void
		{
			var width:Number = (displayedXP / totalXP) * 64 * Configuration.SPRITE_SCALE;
			blue.width = width;
		}
		
		public function construct():void
		{
			blue = new Sprite();
			blue.graphics.beginFill(0x40c8f8, 1);
			blue.graphics.drawRect(0, 0, 64 * Configuration.SPRITE_SCALE, _barheight * Configuration.SPRITE_SCALE);
			blue.graphics.endFill();
			
			this.addChild(blue);
			
			setBarWidths();
		}
		
		public function destroy():void
		{
			TweenLite.killTweensOf(blue);
			
			this.removeChild(blue);
			blue.graphics.clear();
			blue = null;
		}
		
	}

}