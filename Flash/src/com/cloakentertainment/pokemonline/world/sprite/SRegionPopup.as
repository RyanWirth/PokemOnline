package com.cloakentertainment.pokemonline.world.sprite 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.events.Event;
	import com.cloakentertainment.pokemonline.world.region.RegionType;
	/**
	 * ...
	 * @author ...
	 */
	public class SRegionPopup extends Sprite
	{
		[Embed(source="assets/SRegionPopup.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		 
		// Embed the Atlas Texture:
		[Embed(source="assets/SRegionPopup.png")]
		public static const AtlasTexture:Class;
		
		public static const tex:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1 / Configuration.SPRITE_SCALE);
		public static const xml:XML = XML(new AtlasXml());
		public static const atlas:TextureAtlas = new TextureAtlas(tex, xml);
		
		private var _labelText:String;
		private var _label:TextField;
		private var _background:Image;
		
		public function SRegionPopup(regionType:String, labelText:String) 
		{
			_labelText = labelText;
			
			if (regionType == null || regionType == "") regionType = "route_wood";
			_background = new Image(atlas.getTexture(regionType));
			_background.smoothing = TextureSmoothing.NONE;
			this.addChild(_background);
			
			_label = new TextField(this.width, this.height, _labelText.toUpperCase(), Configuration.TEXT_FORMAT.font, 14 * Configuration.SPRITE_SCALE, 0xFFFFFF);
			_label.nativeFilters = [Configuration.TEXT_FILTER_WHITE_LARGE];
			this.addChild(_label);
		}
		
		public function destroy():void
		{
			this.removeChild(_label);
			this.removeChild(_background);
			
			_label.dispose();
			_label = null;
			
			_background.dispose();
			_background = null;
		}
		
	}

}