package com.cloakentertainment.pokemonline.ui
{
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UILoadingSprite extends UISprite
	{
		public static const TEXT_FORMAT_WHITE_LARGE:TextFormat = new TextFormat("PokemonFont", 14 * Configuration.SPRITE_SCALE, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER, null, null, null, 5);
		public static const TEXT_FILTER_WHITE_LARGE:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x000000, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		
		[Embed(source = "assets/UILoadingSprite.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _frame:Bitmap;
		private var _feedback:TextField;
		private var _fullscreen:Boolean;
		
		public function UILoadingSprite(fullscreen:Boolean = false)
		{
			super(spriteImage);
			
			_fullscreen = fullscreen;
			
			construct();
		}
		
		public function updateStatus(status:String):void
		{
			if (_feedback) _feedback.text = status;
		}
		
		override public function construct():void
		{
			this.graphics.beginFill(0x282828);
			this.graphics.drawRect(0, 0, Configuration.VIEWPORT.width, Configuration.VIEWPORT.height);
			this.graphics.endFill();
			
			drawFrame(1);
			
			_feedback = new TextField();
			Configuration.setupTextfield(_feedback, TEXT_FORMAT_WHITE_LARGE, TEXT_FILTER_WHITE_LARGE);
			_feedback.width = Configuration.VIEWPORT.width;
			_feedback.height = 14 * Configuration.SPRITE_SCALE;
			_feedback.multiline = false;
			_feedback.wordWrap = false;
			_feedback.text = "Loading...";
			_feedback.y = _frame.y + _frame.height + 1 * Configuration.SPRITE_SCALE;
			this.addChild(_feedback);
		
		}
		
		private var curFrame:int;
		
		private function drawFrame(num:int):void
		{
			destroyFrame();
			
			curFrame = num;
			if (curFrame > _spriteImage.width / _spriteImage.height) curFrame = 1;
			
			var xPos:int = (curFrame - 1) * _spriteImage.height;
			_frame = getSprite(xPos, 0, _spriteImage.height, _spriteImage.height);
			_frame.x = Configuration.VIEWPORT.width / 2 - _frame.width / 2;
			_frame.y = Configuration.VIEWPORT.height / 2 - _frame.height / 2;
			this.addChild(_frame);
			
			TweenLite.delayedCall(5, drawFrame, [curFrame + 1], true);
		}
		
		private function destroyFrame():void
		{
			if (_frame)
			{
				this.removeChild(_frame);
				_frame.bitmapData.dispose();
				_frame = null;
			}
		}
		
		override public function destroy():void
		{
			TweenLite.killDelayedCallsTo(drawFrame);
			
			destroyFrame();
			
			this.removeChild(_feedback);
			_feedback = null;
		}
	
	}

}