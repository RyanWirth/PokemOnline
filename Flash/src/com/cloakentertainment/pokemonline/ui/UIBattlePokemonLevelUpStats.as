package com.cloakentertainment.pokemonline.ui 
{
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import com.cloakentertainment.pokemonline.stats.PokemonStat;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBattlePokemonLevelUpStats extends Sprite
	{
		public static const TEXT_FORMAT:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0x484848, null, null, null, null, null, null, null, null, null, 5);
		public static const TEXT_FORMAT_RIGHT:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0x484848, null, null, null, null, null, TextFormatAlign.RIGHT, null, null, null, 5);
		
		private var _textFields:Vector.<TextField>;
		private var _pokemon:Pokemon;
		private var _uiBox:UIBox;
		
		private var _oldHP:int;
		private var _oldATK:int;
		private var _oldDEF:int;
		private var _oldSPATK:int;
		private var _oldSPDEF:int;
		private var _oldSPEED:int;
		private var _newHP:int;
		private var _newATK:int;
		private var _newDEF:int;
		private var _newSPATK:int;
		private var _newSPDEF:int;
		private var _newSPEED:int;
		
		public function UIBattlePokemonLevelUpStats(oldHP:int, oldATK:int, oldDEF:int, oldSPATK:int, oldSPDEF:int, oldSPEED:int, newHP:int, newATK:int, newDEF:int, newSPATK:int, newSPDEF:int, newSPEED:int) 
		{
			_oldHP = oldHP;
			_oldATK = oldATK;
			_oldDEF = oldDEF;
			_oldSPATK = oldSPATK;
			_oldSPDEF = oldSPDEF;
			_oldSPEED = oldSPEED;
			_newHP = newHP;
			_newATK = newATK;
			_newDEF = newDEF;
			_newSPATK = newSPATK;
			_newSPDEF = newSPDEF;
			_newSPEED = newSPEED;
			
			construct();
		}
		
		public function construct():void
		{
			_textFields = new Vector.<TextField>();
			
			_uiBox = new UIBox(92, 100);
			this.addChild(_uiBox);
			
			createTextField("MAX. HP", _newHP - _oldHP, 1);
			createTextField("ATTACK", _newATK - _oldATK, 2);
			createTextField("DEFENSE", _newDEF - _oldDEF, 3);
			createTextField("SP. ATK", _newSPATK - _oldSPATK, 4);
			createTextField("SP. DEF", _newSPDEF - _oldSPDEF, 5);
			createTextField("SPEED", _newSPEED - _oldSPEED, 6);
		}
		
		private function createTextField(label:String, initialValue:int, verticalOrder:int):void
		{
			var textField:TextField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = TEXT_FORMAT;
			//textField.textColor = 0xFFFFFF;
			textField.selectable = false;
			textField.x = 5 * Configuration.SPRITE_SCALE;
			textField.y = 6 * Configuration.SPRITE_SCALE + (verticalOrder - 1) * 15 * Configuration.SPRITE_SCALE;
			textField.filters = [Configuration.TEXT_FILTER];
			textField.text = label;
			textField.wordWrap = true;
			textField.width = 82 * Configuration.SPRITE_SCALE;
			textField.height = 16 * Configuration.SPRITE_SCALE;
			this.addChild(textField);
			
			var textField2:TextField = new TextField();
			textField2.embedFonts = true;
			textField2.defaultTextFormat = TEXT_FORMAT_RIGHT;
			//textField.textColor = 0xFFFFFF;
			textField2.selectable = false;
			textField2.x = 5 * Configuration.SPRITE_SCALE;
			textField2.y = 6 * Configuration.SPRITE_SCALE + (verticalOrder - 1) * 15 * Configuration.SPRITE_SCALE;
			textField2.filters = [Configuration.TEXT_FILTER];
			textField2.text = "+" + (initialValue < 100 ? " " : "") + (initialValue < 10 ? "  " : "") + initialValue;
			textField2.wordWrap = true;
			textField2.width = 82 * Configuration.SPRITE_SCALE;
			textField2.height = 16 * Configuration.SPRITE_SCALE;
			this.addChild(textField2);
			
			_textFields.push(textField, textField2);
		}
		
		public function switchToOverallStats():void
		{
			_textFields[1].text = _newHP.toString();
			_textFields[3].text = _newATK.toString();
			_textFields[5].text = _newDEF.toString();
			_textFields[7].text = _newSPATK.toString();
			_textFields[9].text = _newSPDEF.toString();
			_textFields[11].text = _newSPEED.toString();
		}
		
		public function destroy():void
		{
			for (var i:int = 0; i < _textFields.length; i++)
			{
				this.removeChild(_textFields[i]);
				_textFields[i] = null;
			}
			
			_textFields.splice(0, _textFields.length);
			_textFields = null;
			
			this.removeChild(_uiBox);
			_uiBox.destroy();
			_uiBox = null;
			
			_pokemon = null;
		}
		
	}

}