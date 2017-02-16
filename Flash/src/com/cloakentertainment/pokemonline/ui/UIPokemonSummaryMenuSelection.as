package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonSummaryMenuSelection extends UISprite
	{
		[Embed(source="assets/UIPokemonSummaryMenuSelection.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _background:Bitmap;
		
		public function UIPokemonSummaryMenuSelection() 
		{
			super(spriteImage);
			
			construct();
		}
		
		private var process:int;
		private var selected:Boolean = false;
		override public function construct():void
		{
			deselect();
			animate();
		}
		
		private function animate():void
		{
			if (_background)
			{
				_background.visible = !_background.visible;
				
				if (_background.visible) setTimeout(animate, 800);
				else setTimeout(animate, 200);
			}
		}
		
		public function select():void
		{
			if (_background)
			{
				this.removeChild(_background);
			}
			
			selected = true;
			
			_background = getSprite(0, 16, 156, 16);
			this.addChild(_background);
		}
		
		public function deselect():void
		{
			if (_background)
			{
				this.removeChild(_background);
			}
			
			selected = false;
			
			_background = getSprite(0, 0, 156, 16);
			this.addChild(_background);
		}
		
		public function get SELECTED():Boolean
		{
			return selected;
		}
		
		override public function destroy():void
		{
			this.removeChild(_background);
			_background = null;
		}
		
	}

}