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
	public class EWinstrateVitoMale extends Entity
	{
		[Embed(source = "assets/EDragonTamerMale.xml", mimeType = "application/octet-stream")]
		public static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/EDragonTamerMale.png")]
		public static const AtlasTexture:Class;
		
		public static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function EWinstrateVitoMale()
		{
			super(atlas, TrainerType.WINSTRATE_VITO_MALE);
		}
	
	}

}