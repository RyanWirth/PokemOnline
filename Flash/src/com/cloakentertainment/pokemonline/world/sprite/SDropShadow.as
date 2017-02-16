package com.cloakentertainment.pokemonline.world.sprite 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.TextureAtlas;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class SDropShadow extends MovieClip
	{
		[Embed(source="assets/SDropShadow.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="assets/SDropShadow.png")]
		public static const AtlasTexture:Class;
		
		public static const tex:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(tex, xml);
		
		private var _callback:Function;
		
		public function SDropShadow(callback:Function = null) 
		{
			_callback = callback;
			
			super(atlas.getTextures("tile"), 8);
			
			this.stop();
			this.smoothing = TextureSmoothing.NONE;
			
			this.addEventListener(Event.COMPLETE, finishPlaying);
		}
		
		private function finishPlaying(e:Event):void
		{
			this.removeEventListener(Event.COMPLETE, finishPlaying);
			
			if (_callback != null) _callback();
			_callback = null;
		}
		
	}

}