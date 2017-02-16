package com.cloakentertainment.pokemonline.ui 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Bitmap;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonAnimatedTinySprite extends UISprite
	{
		[Embed(source="../data/pokemon_icons.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _frame1:Bitmap;
		private var _frame2:Bitmap;
		private var _pokemonID:int;
		
		public function UIPokemonAnimatedTinySprite(pokemonID:int) 
		{
			super(spriteImage);
			
			_pokemonID = pokemonID;
			
			construct();
		}
		
		override public function construct():void
		{	
			var xCoord:int = (_pokemonID - 1) * 64;
			var yCoord:int = 0;
			while (xCoord >= spriteImage.width)
			{
				xCoord -= spriteImage.width;
				yCoord += 32;
			}
			
			_frame1 = getSprite(xCoord, yCoord, 32, 32);
			_frame2 = getSprite(xCoord + 32, yCoord, 32, 32);
			
			this.addChild(_frame1);
			this.addChild(_frame2);
			_frame2.visible = false;
			
			toggle();
		}
		
		public function stopAnimating():void
		{
			if(toggletimeout != -1) clearTimeout(toggletimeout);
		}
		
		public function startAnimating():void
		{
			toggle();
		}
		
		private var toggletimeout:int = -1;
		private function toggle():void
		{
			if (!_frame1 || !_frame2) return;
			
			if (_frame2.visible)
			{
				_frame2.visible = false;
				_frame1.visible = true;
			} else
			{
				_frame2.visible = true;
				_frame1.visible = false;
			}
			toggletimeout = setTimeout(toggle, 125);
		}
		
		override public function destroy():void
		{
			this.removeChild(_frame1);
			this.removeChild(_frame2);
			
			_frame1 = null;
			_frame2 = null;
		}
		
	}

}