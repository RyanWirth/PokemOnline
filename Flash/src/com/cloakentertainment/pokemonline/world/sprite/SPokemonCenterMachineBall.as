package com.cloakentertainment.pokemonline.world.sprite 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author ...
	 */
	public class SPokemonCenterMachineBall extends MovieClip
	{
		[Embed(source="assets/SPokemonCenterMachineBall.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="assets/SPokemonCenterMachineBall.png")]
		public static const AtlasTexture:Class;
		
		public static const tex:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(tex, xml);
		
		public function SPokemonCenterMachineBall() 
		{
			super(atlas.getTextures("tile"), 8);
			
			this.loop = true;
			this.stop();
			this.smoothing = TextureSmoothing.NONE;
		}
		
	}

}