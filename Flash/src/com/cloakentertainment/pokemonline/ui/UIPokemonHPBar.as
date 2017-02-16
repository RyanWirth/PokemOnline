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
	public class UIPokemonHPBar extends Sprite implements UIElement
	{
		private var green:Sprite;
		private var yellow:Sprite;
		private var red:Sprite;
		
		private var displayedHealth:Number;
		private var totalHealth:Number;
		private var _barheight:int;
		
		public function UIPokemonHPBar(currentHP:int, totalHP:int, barheight:int = 2) 
		{
			displayedHealth = currentHP;
			totalHealth = totalHP;
			_barheight = barheight;
			construct();
		}
		
		public function get DISPLAYED_HEALTH():Number
		{
			return displayedHealth;
		}
		
		public function updateHealth(newCurrentHP:int, callback:Function = null, changeMaxHealth:int = 0):Number
		{
			if (changeMaxHealth != 0) totalHealth = changeMaxHealth;
			var newWidth:Number = (newCurrentHP / totalHealth) * 48 * Configuration.SPRITE_SCALE;
			var duration:Number = Math.abs(newWidth - green.width) * 0.025;
			displayedHealth = newCurrentHP;
			TweenLite.to(green, duration, { width:newWidth, onUpdate:checkBarColor, ease:Linear.easeNone } );
			TweenLite.to(yellow, duration, { width:newWidth, ease:Linear.easeNone } );
			TweenLite.to(red, duration, { width:newWidth, ease:Linear.easeNone } );
			
			TweenLite.delayedCall(duration < 1.5 ? 1.5 : duration, callback, null, false);
			
			return duration;
		}
		
		private function checkBarColor():void
		{
			if (green.width > 0.5 * 48 * Configuration.SPRITE_SCALE)
			{
				// Make green
				green.visible = true;
				yellow.visible = red.visible = false;
			} else
			if (green.width > 0.1 * 48 * Configuration.SPRITE_SCALE)
			{
				// Make yellow
				green.visible = red.visible = false;
				yellow.visible = true;
			} else
			{
				// Make red
				yellow.visible = green.visible = false;
				red.visible = true;
			}
		}
		
		public function get IS_RED():Boolean
		{
			if (width == 0) return false; // A slight fix for when a pokemon is one shotted
			return red.visible;
		}
		
		private function setBarWidths():void
		{
			var width:Number = (displayedHealth / totalHealth) * 48 * Configuration.SPRITE_SCALE;
			green.width = yellow.width = red.width = width;
		}
		
		public function construct():void
		{
			green = new Sprite();
			green.graphics.beginFill(0x58d080, 1);
			green.graphics.drawRect(0, 0, 48 * Configuration.SPRITE_SCALE, 1 * Configuration.SPRITE_SCALE);
			green.graphics.endFill();
			green.graphics.beginFill(0x70f8a8, 1);
			green.graphics.drawRect(0, 1 * Configuration.SPRITE_SCALE, 48 * Configuration.SPRITE_SCALE, _barheight * Configuration.SPRITE_SCALE);
			green.graphics.endFill();
			
			
			yellow = new Sprite();
			yellow.graphics.beginFill(0xc8a808, 1);
			yellow.graphics.drawRect(0, 0, 48 * Configuration.SPRITE_SCALE, 1 * Configuration.SPRITE_SCALE);
			yellow.graphics.endFill();
			yellow.graphics.beginFill(0xf8e038, 1);
			yellow.graphics.drawRect(0, 1 * Configuration.SPRITE_SCALE, 48 * Configuration.SPRITE_SCALE, _barheight * Configuration.SPRITE_SCALE);
			yellow.graphics.endFill();
			
			
			red = new Sprite();
			red.graphics.beginFill(0xa84048, 1);
			red.graphics.drawRect(0, 0, 48 * Configuration.SPRITE_SCALE, 1 * Configuration.SPRITE_SCALE);
			red.graphics.endFill();
			red.graphics.beginFill(0xf85838, 1);
			red.graphics.drawRect(0, 1 * Configuration.SPRITE_SCALE, 48 * Configuration.SPRITE_SCALE, _barheight * Configuration.SPRITE_SCALE);
			red.graphics.endFill();
			
			this.addChild(red);
			this.addChild(yellow);
			this.addChild(green);
			
			setBarWidths();
			checkBarColor();
		}
		
		public function destroy():void
		{
			TweenLite.killTweensOf(green);
			TweenLite.killTweensOf(yellow);
			TweenLite.killTweensOf(red);
			
			this.removeChild(red);
			this.removeChild(yellow);
			this.removeChild(green);
			green.graphics.clear();
			yellow.graphics.clear();
			red.graphics.clear();
			
			red = yellow = green = null;
		}
		
	}

}