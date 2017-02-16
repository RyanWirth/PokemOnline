package com.cloakentertainment.pokemonline
{
	import com.cloakentertainment.pokemonline.ui.UIPreloader;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.display.LoaderInfo;
	
	public class Preloader extends MovieClip
	{
		
		public var loadingSprite:UIPreloader;
		
		public function Preloader()
		{
			addEventListener(Event.ENTER_FRAME, progress);
			// show loader
			loadingSprite = new UIPreloader();
			loadingSprite.updateStatus("0%");
			this.addChild(loadingSprite);
		}
		
		private function progress(e:Event):void
		{
			// update loader
			var percentage:Number = stage.loaderInfo.bytesLoaded / stage.loaderInfo.bytesTotal;
			var perc:int = Math.floor(percentage * 100);
			if (currentFrame >= totalFrames || perc == 100)
			{
				removeEventListener(Event.ENTER_FRAME, progress);
				this.removeChild(loadingSprite);
				loadingSprite.destroy();
				loadingSprite = null;
				startup();
				return;
			}
			loadingSprite.updateStatus(perc + "%");
		}
		
		private function startup():void
		{
			// hide loader
			stop();
			// instanciate Main class
			var mainClass:Class = getDefinitionByName("com.cloakentertainment.pokemonline.Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
	
	}

}