package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.stats.PokemonBase;
	import com.cloakentertainment.pokemonline.stats.PokemonFactory;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexInfoMenu extends UISprite implements UIElement
	{
		[Embed(source="assets/UIPokedexInfoMenu.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;

		public static const TEXT_FORMAT_ALIGN_RIGHT:TextFormat = new TextFormat("PokemonFont", 14 * Configuration.SPRITE_SCALE, 0x000000, null, null, null, null, null, TextFormatAlign.RIGHT, null, null, null, 5);
		private var _background:Bitmap;
		private var _backgroundText:Bitmap;
		private var _pokemonID:int;
		private var _sprite:UIPokemonSprite;
		
		private var descriptionText:TextField;
		private var nameText:TextField;
		private var heightLabelText:TextField;
		private var heightValueText:TextField;
		private var weightLabelText:TextField;
		private var weightValueText:TextField;
		private var pokemonTypeText:TextField;
		private var footprint:UIPokemonFootprint;
		
		private var _banner:Bitmap;
		
		private var _closeCallback:Function;
		
		public function UIPokedexInfoMenu(pokemonID:int, sprite:UIPokemonSprite, closeCallback:Function = null)
		{
			super(spriteImage);
			
			_pokemonID = pokemonID;
			_sprite = sprite;
			_closeCallback = closeCallback;
			
			construct();
		}
		
		override public function construct():void
		{
			var base:PokemonBase = PokemonFactory.getBase(_pokemonID - 1);
			var owned:Boolean = Configuration.ACTIVE_TRAINER != null ? Configuration.ACTIVE_TRAINER.ownedPokemon(base.name) : true;
			
			_background = getSprite(0, Configuration.POKEDEX_CURRENT_SEARCH_OPTIONS == null ? 0 : 160, 240, 93);
			this.addChild(_background);
			_backgroundText = getSprite(0, owned ? 93 : 253, 240, 67);
			_backgroundText.y = 93 * Configuration.SPRITE_SCALE;
			this.addChild(_backgroundText);
			
			footprint = new UIPokemonFootprint(_pokemonID);
			footprint.x = 200 * Configuration.SPRITE_SCALE;
			footprint.y = 64 * Configuration.SPRITE_SCALE;
			this.addChild(footprint);
			
			if (_closeCallback != null)
			{
				drawBannerFrame(1);
			}
			
			descriptionText = new TextField();
			setupTextfield(descriptionText, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER_POKEDEX);
			descriptionText.width = 218 * Configuration.SPRITE_SCALE;
			descriptionText.height = 64 * Configuration.SPRITE_SCALE;
			descriptionText.x = 14 * Configuration.SPRITE_SCALE;
			descriptionText.y = 96 * Configuration.SPRITE_SCALE;
			descriptionText.text = owned ? base.pokedexEntry.replace(base.name, base.name.toUpperCase()) : "";
			
			nameText = new TextField();
			setupTextfield(nameText, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER_POKEDEX);
			nameText.width = 120 * Configuration.SPRITE_SCALE;
			nameText.x = 90 * Configuration.SPRITE_SCALE;
			nameText.y = 28 * Configuration.SPRITE_SCALE;
			var pokemonNumber:String = (base.regionalPokedexNumbers[0] < 100 ? "0" : "") + (base.regionalPokedexNumbers[0] < 10 ? "0" : "") + base.regionalPokedexNumbers[0];
			nameText.text = "№" + pokemonNumber + " " + String(base.name).toUpperCase();
			
			heightLabelText = new TextField();
			setupTextfield(heightLabelText, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER_POKEDEX);
			heightLabelText.width = 52 * Configuration.SPRITE_SCALE;
			heightLabelText.x = 96 * Configuration.SPRITE_SCALE;
			heightLabelText.y = 58 * Configuration.SPRITE_SCALE;
			heightLabelText.text = "HT";
			
			weightLabelText = new TextField();
			setupTextfield(weightLabelText, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER_POKEDEX);
			weightLabelText.width = 52 * Configuration.SPRITE_SCALE;
			weightLabelText.x = 96 * Configuration.SPRITE_SCALE;
			weightLabelText.y = 74 * Configuration.SPRITE_SCALE;
			weightLabelText.text = "WT";
			
			weightValueText = new TextField();
			setupTextfield(weightValueText, TEXT_FORMAT_ALIGN_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
			weightValueText.width = 52 * Configuration.SPRITE_SCALE;
			weightValueText.x = 132 * Configuration.SPRITE_SCALE;
			weightValueText.y = 74 * Configuration.SPRITE_SCALE;
			weightValueText.text = owned ? String(base.weight[0]) + "." : "????.? lbs.";
			
			heightValueText = new TextField();
			setupTextfield(heightValueText, TEXT_FORMAT_ALIGN_RIGHT, Configuration.TEXT_FILTER_POKEDEX);
			heightValueText.width = 52 * Configuration.SPRITE_SCALE;
			heightValueText.x = 132 * Configuration.SPRITE_SCALE;
			heightValueText.y = 58 * Configuration.SPRITE_SCALE;
			heightValueText.text = owned ? String(base.height[0]) : "??'??\"";
			
			pokemonTypeText = new TextField();
			setupTextfield(pokemonTypeText, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER_POKEDEX);
			pokemonTypeText.x = 90 * Configuration.SPRITE_SCALE;
			pokemonTypeText.y = 42 * Configuration.SPRITE_SCALE;
			pokemonTypeText.width = nameText.width;
			pokemonTypeText.text = owned ? base.pokedexType.toUpperCase().replace("É", "é") : "????? POKéMON";
			
			if (_sprite == null)
			{
				_sprite = new UIPokemonSprite(_pokemonID, false);
				_sprite.x = 20 * Configuration.SPRITE_SCALE;
				_sprite.y = 24 * Configuration.SPRITE_SCALE;
				this.addChild(_sprite);
			}
			
			this.addChild(pokemonTypeText);
			this.addChild(descriptionText);
			this.addChild(nameText);
			this.addChild(heightLabelText);
			this.addChild(weightLabelText);
			this.addChild(weightValueText);
			this.addChild(heightValueText);
			
			if (_closeCallback != null) KeyboardManager.registerKey(Configuration.ENTER_KEY, cancelButton, InputGroups.POKEDEX_INFO, true);
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, cancelButton, InputGroups.POKEDEX_INFO, true);
		}
		
		private function drawBannerFrame(num:int):void
		{
			destroyBannerFrame();
			
			_banner = getSprite(240, 56 + (num == 1 ? 0 : 16), 240, 16);
			_banner.y = 1 * Configuration.SPRITE_SCALE;
			this.addChild(_banner);
			
			TweenLite.delayedCall(1, drawBannerFrame, [num == 1 ? 2 : 1]);
		}
		
		private function cancelButton():void
		{
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, cancelButton);
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, cancelButton);
			Configuration.FADE_OUT_AND_IN(finishCancelButton);
		}
		
		private function finishCancelButton():void
		{
			if (_closeCallback == null && Configuration.POKEDEX_CURRENT_SEARCH_OPTIONS) Configuration.createMenu(MenuType.POKEDEX_SEARCH_COMPLETE, Configuration.POKEDEX_CURRENT_ID);
			else if(_closeCallback == null) Configuration.createMenu(MenuType.POKEDEX);
			destroy();
		}
		
		private function setupTextfield(textField:TextField, format:TextFormat, filter:DropShadowFilter):void
		{
			textField.embedFonts = true;
			textField.defaultTextFormat = format;
			textField.filters = [filter];
			textField.selectable = false;
			textField.wordWrap = true;
			textField.multiline = true;
		}
		
		private function destroyBannerFrame():void 
		{
			if (_banner)
			{
				this.removeChild(_banner);
				_banner.bitmapData.dispose();
				_banner = null;
			}
			
			TweenLite.killDelayedCallsTo(drawBannerFrame);
		}
		
		override public function destroy():void
		{
			if (_closeCallback != null) _closeCallback();
			_closeCallback = null;
			
			destroyBannerFrame();
			
			this.removeChild(_background);
			this.removeChild(_backgroundText);
			this.removeChild(weightLabelText);
			this.removeChild(heightLabelText);
			this.removeChild(descriptionText);
			this.removeChild(nameText);
			this.removeChild(heightValueText);
			this.removeChild(weightValueText);
			this.removeChild(pokemonTypeText);
			this.removeChild(footprint);
			
			footprint.destroy();
			footprint = null;
			_backgroundText = null;
			
			if (this.contains(_sprite))
			{
				this.removeChild(_sprite);
			} else Configuration.STAGE.removeChild(_sprite);
			Configuration._tweeningSprite = null;
			_sprite.destroy();
			_sprite = null;
			
			_background = null;
			descriptionText = null;
			nameText = null;
			weightValueText = null;
			weightLabelText = null;
			heightValueText = null;
			heightLabelText = null;
			pokemonTypeText = null;
		}
	
	}

}