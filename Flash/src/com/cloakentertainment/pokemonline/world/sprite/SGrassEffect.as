package com.cloakentertainment.pokemonline.world.sprite 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.TextureAtlas;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import starling.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class SGrassEffect extends MovieClip
	{
		[Embed(source="assets/SGrassEffect.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="assets/SGrassEffect.png")]
		public static const AtlasTexture:Class;
		
		public static const tex:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(tex, xml);
		
		public function SGrassEffect() 
		{
			
			super(atlas.getTextures("tile"), 6);
			
			this.smoothing = TextureSmoothing.NONE;
			
			this.addEventListener(Event.COMPLETE, finishPlaying);
		}
		
		private function finishPlaying(e:Event):void
		{
			WorldManager.JUGGLER.remove(this);
			this.removeEventListener(Event.COMPLETE, finishPlaying);
			removeFromParent(true);
		}
		
	}

}