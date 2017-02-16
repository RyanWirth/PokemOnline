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
	public class EMotherFemale extends Entity
	{
		[Embed(source = "assets/EMotherFemale.xml", mimeType = "application/octet-stream")]
		public static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/EMotherFemale.png")]
		public static const AtlasTexture:Class;
		
		public static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function EMotherFemale()
		{
			super(atlas, TrainerType.NONE);
		}
	
	}

}