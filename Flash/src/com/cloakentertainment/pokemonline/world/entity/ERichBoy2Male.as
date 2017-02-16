package com.cloakentertainment.pokemonline.world.entity
{
	import com.cloakentertainment.pokemonline.Configuration;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ERichBoy2Male extends Entity
	{
		[Embed(source = "assets/ERichBoy2Male.xml", mimeType = "application/octet-stream")]
		public static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/ERichBoy2Male.png")]
		public static const AtlasTexture:Class;
		
		public static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function ERichBoy2Male()
		{
			super(atlas, TrainerType.RICH_BOY_MALE);
		}
	
	}

}