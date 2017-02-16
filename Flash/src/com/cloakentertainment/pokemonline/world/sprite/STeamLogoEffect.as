package com.cloakentertainment.pokemonline.world.sprite 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import com.greensock.TweenLite;
	import starling.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class STeamLogoEffect extends MovieClip
	{
		[Embed(source="assets/STeamLogoEffect.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="assets/STeamLogoEffect.png")]
		public static const AtlasTexture:Class;
		
		public static const tex:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(tex, xml);
		
		
		public function STeamLogoEffect(team:String = "aqua") 
		{
			super(atlas.getTextures(team), 8);
			
			this.stop();
			this.smoothing = TextureSmoothing.NONE;
			this.alpha = 0;
			
			TweenLite.to(this, 1, { alpha:1 } );
		}
		
	}

}