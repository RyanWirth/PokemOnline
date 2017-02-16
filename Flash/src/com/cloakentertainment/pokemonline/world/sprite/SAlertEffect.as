package com.cloakentertainment.pokemonline.world.sprite 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class SAlertEffect extends MovieClip
	{
		[Embed(source="assets/SAlertEffect.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="assets/SAlertEffect.png")]
		public static const AtlasTexture:Class;
		
		public static const tex:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(tex, xml);
		
		
		public function SAlertEffect() 
		{
			super(atlas.getTextures("sprite"), 8);
			
			this.stop();
			this.smoothing = TextureSmoothing.NONE;
		}
		
	}

}