package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.stats.PokemonGender;
	import flash.text.TextField;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBattlePokemonLevelUpBar extends UISprite
	{
		[Embed(source="assets/UIBattlePokemonLevelUpBar.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		public static const TEXT_FORMAT:TextFormat = new TextFormat("PokemonFont", 12 * Configuration.SPRITE_SCALE, 0xf8f8f8, null, null, null, null, null, null, null, null, null, 5);
		public static const TEXT_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x685870, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);

		
		private var _pokemonID:int = 1;
		private var _pokemonGender:String = PokemonGender.NONE;
		private var _pokemonName:String = "";
		private var _pokemonLevel:int = 2;
		
		private var _background:Bitmap;
		private var _nameTF:TextField;
		private var _levelTF:TextField;
		private var _pokemonIcon:UIPokemonAnimatedTinySprite;
		private var _gender:Bitmap;
		
		public function UIBattlePokemonLevelUpBar(pokemonID:int, pokemonGender:String, pokemonName:String, pokemonLevel:int) 
		{
			super(spriteImage);
			
			_pokemonGender = pokemonGender;
			_pokemonID = pokemonID;
			_pokemonName = pokemonName;
			_pokemonLevel = pokemonLevel;
			
			construct();
		}
		
		override public function construct():void
		{
			_background = getSprite(0, 0, 96, 24);
			this.addChild(_background);
			
			_nameTF = new TextField();
			_nameTF.embedFonts = true;
			_nameTF.defaultTextFormat = TEXT_FORMAT;
			//textField.textColor = 0xFFFFFF;
			_nameTF.selectable = false;
			_nameTF.x = 32 * Configuration.SPRITE_SCALE;
			_nameTF.y = 1 * Configuration.SPRITE_SCALE;
			_nameTF.filters = [TEXT_FILTER];
			_nameTF.text = _pokemonName;
			_nameTF.wordWrap = true;
			_nameTF.width = 60 * Configuration.SPRITE_SCALE;
			_nameTF.height = 12 * Configuration.SPRITE_SCALE;
			this.addChild(_nameTF);
			
			_levelTF = new TextField();
			_levelTF.embedFonts = true;
			_levelTF.defaultTextFormat = TEXT_FORMAT;
			//textField.textColor = 0xFFFFFF;
			_levelTF.selectable = false;
			_levelTF.x = 32 * Configuration.SPRITE_SCALE;
			_levelTF.y = 11 * Configuration.SPRITE_SCALE;
			_levelTF.filters = [TEXT_FILTER];
			_levelTF.text = "Lv" + _pokemonLevel;
			_levelTF.wordWrap = true;
			_levelTF.width = 60 * Configuration.SPRITE_SCALE;
			_levelTF.height = 12 * Configuration.SPRITE_SCALE;
			this.addChild(_levelTF);
			
			_pokemonIcon = new UIPokemonAnimatedTinySprite(_pokemonID);
			_pokemonIcon.stopAnimating();
			_pokemonIcon.y = -6 * Configuration.SPRITE_SCALE;
			this.addChild(_pokemonIcon);
			
			_gender = getSprite(_pokemonGender == PokemonGender.MALE ? 0 : (_pokemonGender == PokemonGender.FEMALE ? 5 : 10), 24, 5, 8);
			_gender.x = 60 * Configuration.SPRITE_SCALE;
			_gender.y = 14 * Configuration.SPRITE_SCALE;
			this.addChild(_gender);
		}
		
		override public function destroy():void
		{
			this.removeChild(_background);
			_background.bitmapData.dispose();
			_background = null;
			
			this.removeChild(_nameTF);
			this.removeChild(_levelTF);
			_nameTF = _levelTF = null;
			
			this.removeChild(_pokemonIcon);
			_pokemonIcon.destroy();
			_pokemonIcon = null;
			
			this.removeChild(_gender);
			_gender.bitmapData.dispose();
			_gender = null;
		}
		
	}

}