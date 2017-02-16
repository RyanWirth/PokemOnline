package com.cloakentertainment.pokemonline.world.sprite
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.greensock.TweenLite;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SSandEffect extends MovieClip
	{
		[Embed(source = "assets/SSandEffect.xml", mimeType = "application/octet-stream")]
		public static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/SSandEffect.png")]
		public static const AtlasTexture:Class;
		
		public static const tex:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(tex, xml);
		
		public function SSandEffect()
		{
			super(atlas.getTextures("tile"), 6);
			this.stop();
			
			TweenLite.delayedCall(1, startFade);
		}
		
		private function startFade():void
		{
			TweenLite.to(this, 1, {alpha: 0, onComplete: removeFromParent, onCompleteParams: [true]});
		}
	
	}

}