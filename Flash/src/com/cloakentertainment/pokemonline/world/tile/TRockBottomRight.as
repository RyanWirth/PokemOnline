package com.cloakentertainment.pokemonline.world.tile 
{
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import com.cloakentertainment.pokemonline.world.map.ChunkManager;
	import com.cloakentertainment.pokemonline.Configuration;
	/**
	 * ...
	 * @author ...
	 */
	public class TRockBottomRight extends Tile
	{
		[Embed(source="assets/TRockBottomRight.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="assets/TRockBottomRight.png")]
		public static const AtlasTexture:Class;
		
		public static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(texture, xml);

		public function TRockBottomRight(xTile:int, yTile:int) 
		{
			// create atlas
			super(xTile, yTile, Tile.WATER, atlas.getTextures("tile"), 5);
		}
		
	}

}