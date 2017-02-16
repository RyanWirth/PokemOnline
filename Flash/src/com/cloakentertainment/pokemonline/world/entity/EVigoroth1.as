package com.cloakentertainment.pokemonline.world.entity
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EVigoroth1 extends Entity
	{
		[Embed(source = "assets/EVigoroth1.xml", mimeType = "application/octet-stream")]
		public static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/EVigoroth1.png")]
		public static const AtlasTexture:Class;
		
		public static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function EVigoroth1()
		{
			super(atlas, TrainerType.NONE);
		}
	
	}

}