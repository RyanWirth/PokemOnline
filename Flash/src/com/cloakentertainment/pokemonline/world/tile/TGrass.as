package com.cloakentertainment.pokemonline.world.tile 
{
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import com.cloakentertainment.pokemonline.world.map.ChunkManager;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author ...
	 */
	public class TGrass extends Tile
	{
		[Embed(source="assets/TGrass.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="assets/TGrass.png")]
		public static const AtlasTexture:Class;
		
		public static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(texture, xml);

		public function TGrass(xTile:int, yTile:int) 
		{
			// create atlas
			super(xTile, yTile, Tile.GRASS, atlas.getTextures("tile"), 6);
		}
		
		override public function playEffect():void
		{
			TweenLite.killDelayedCallsTo(resetFrame);
			
			this.currentFrame = 1;
			TweenLite.delayedCall(20, resetFrame, null, true);
		}
		
		private function resetFrame():void
		{
			this.currentFrame = 0;
		}
		
	}

}