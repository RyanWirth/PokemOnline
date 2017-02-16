package com.cloakentertainment.pokemonline.world.sprite
{
	import com.cloakentertainment.pokemonline.Configuration;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SDarkEffect extends Sprite
	{
		private var _image:Image;
		
		public function SDarkEffect(data:String)
		{
			var dataArr:Array = data.split("::");
			var color:uint = uint(dataArr[0]);
			var alpha:Number = Number(dataArr[1]);
			_image = new Image(Texture.fromColor(Configuration.VIEWPORT.width, Configuration.VIEWPORT.height, color));
			_image.alpha = alpha;
			this.addChild(_image);
		}
		
		public function destroy():void
		{
			this.removeChild(_image);
			_image.dispose();
			_image = null;
			dispose();
		}
	}

}