package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Sprite;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.text.TextField;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexMenuPokemonText extends Sprite implements UIElement
	{
		
		private var _pokemonID:int;
		private var _pokemonName:String;
		private var _visible:Boolean;
		
		private var textField:TextField;
		private var pokeball:UIPokedexMenuPokeball
		
		public function UIPokedexMenuPokemonText(pokemonID:int, pokemonName:String, visible:Boolean = true) 
		{
			_pokemonID = pokemonID;
			_pokemonName = pokemonName;
			_visible = visible;
			
			construct();
		}
		
		public function addPokeball():void
		{
			pokeball = new UIPokedexMenuPokeball();
			pokeball.x = -pokeball.width;
			pokeball.y = (textField.textHeight - pokeball.height) / 2 + Configuration.SPRITE_SCALE / 2;
			this.addChild(pokeball);
		}
		
		public function construct():void
		{
			textField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = Configuration.TEXT_FORMAT_POKEDEX;
			textField.width = 88 * Configuration.SPRITE_SCALE;
			textField.height = 16 * Configuration.SPRITE_SCALE;
			textField.selectable = false;
			textField.filters = [Configuration.TEXT_FILTER_POKEDEX];
			var pokemonNum:String = (_pokemonID < 100 ? "0" : "") + (_pokemonID < 10 ? "0" : "") + _pokemonID;
			var name:String = _visible ? _pokemonName.toUpperCase() : "----------";
			textField.text = "No" + pokemonNum + " " + name;
			
			this.addChild(textField);
		}
		
		public function destroy():void
		{
			this.removeChild(textField);
			textField = null;
			
			if (pokeball)
			{
				pokeball.destroy();
				this.removeChild(pokeball);
				pokeball = null;
			}
		}
		
	}

}