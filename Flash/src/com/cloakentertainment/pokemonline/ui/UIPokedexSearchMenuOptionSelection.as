package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.text.TextLineMetrics;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexSearchMenuOptionSelection extends UISprite
	{
		public static const BUTTON_FORMAT:TextFormat = new TextFormat("PokemonFont", 14 * Configuration.SPRITE_SCALE, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
		public static const BUTTON_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x000000, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		public static const BUTTON_SELECTED_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x802020, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		
		[Embed(source="assets/UIPokedexSearchMenuOptionSelection.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _background:Bitmap;
		private var _options:Vector.<String>;
		private var _initialSelection:String;
		private var _blackArrow:UIBlackArrow;
		private var textField:TextField;
		private var textFieldMask:Sprite;
		private var lineHeight:int;
		
		private var downArrow:UIPokedexMenuArrow;
		private var upArrow:UIPokedexMenuArrow;
		
		private var pointer:int;
		
		public function UIPokedexSearchMenuOptionSelection(options:Vector.<String>, initialSelection:String) 
		{
			super(spriteImage);
			
			_options = options;
			_initialSelection = initialSelection;
			
			construct();
		}
		
		public function get POINTER():int
		{
			return pointer;
		}
		
		override public function construct():void
		{
			_background = getSprite(0, 0, spriteImage.width, spriteImage.height);
			this.addChild(_background);
			
			upArrow = new UIPokedexMenuArrow(true);
			downArrow = new UIPokedexMenuArrow(false);
			upArrow.x = downArrow.x = _background.width / 2 - upArrow.width / 2;
			upArrow.y = upArrow.height / -2;
			downArrow.y = _background.height - downArrow.height / 2;
			this.addChild(upArrow);
			this.addChild(downArrow);
			upArrow.startAnimating();
			downArrow.startAnimating();
			
			textFieldMask = new Sprite();
			textFieldMask.graphics.beginFill(0x000000);
			textFieldMask.graphics.drawRect(0, 5, _background.width, _background.height - 10);
			textFieldMask.graphics.endFill();
			this.addChild(textFieldMask);
			textField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = Configuration.TEXT_FORMAT_POKEDEX;
			textField.selectable = false;
			textField.multiline = true;
			textField.x = 12 * Configuration.SPRITE_SCALE;
			textField.y = 2 * Configuration.SPRITE_SCALE;
			textField.filters = [Configuration.TEXT_FILTER_POKEDEX];
			textField.mask = textFieldMask;
			
			var string:String = "";
			var initialOption:int = 1;
			var initialSelectionString:String = stringValue(_initialSelection);
			for (var i:int = 0; i < _options.length; i++)
			{
				string += _options[i] + "\n";
				if (stringValue(_options[i]) + "13" == initialSelectionString) 
				{
					initialOption = i + 1;
				}
			}
			textField.text = string;
			textField.height = textField.textHeight + 25; // 25 pixels for a safe buffer.
			textField.width = _background.width;
			this.addChild(textField);
			
			var metrics:TextLineMetrics = textField.getLineMetrics(0);
			lineHeight = metrics.ascent + metrics.descent + metrics.leading;
			
			_blackArrow = new UIBlackArrow();
			_blackArrow.x = 5 * Configuration.SPRITE_SCALE;
			_blackArrow.y = 5 * Configuration.SPRITE_SCALE;
			
			this.addChild(_blackArrow);
			
			selectOption(initialOption);
		}
		
		private function stringValue(string:String):String
		{
			var returnString:String = "";
			for (var i:int = 0; i < string.length; i++)
			{
				returnString += string.charCodeAt(i);
			}
			
			return returnString;
		}
		
		private function selectOption(optionNum:int):void
		{
			pointer = optionNum;
			
			// set _blackArrow's y value here.
			// maximum of 7 options shown at once
			if (pointer > 7)
			{
				// scroll down
				// or rather, scroll the textfield up
				var diff:int = pointer - 7;
				textField.y = 2 * Configuration.SPRITE_SCALE - (lineHeight+0.75) * diff;
				_blackArrow.y = 5 * Configuration.SPRITE_SCALE + 6 * (lineHeight+0.75);
			} else
			{
				textField.y = 2 * Configuration.SPRITE_SCALE;
				_blackArrow.y = 5 * Configuration.SPRITE_SCALE + (pointer-1) * (lineHeight+0.75);
			}
			
			if (textField.y == 2 * Configuration.SPRITE_SCALE)
			{
				upArrow.visible = false;
				if (textField.textHeight > _background.height)
				{
					downArrow.visible = true;
				} else downArrow.visible = false;
			} else
			if (pointer == _options.length)
			{
				upArrow.visible = true;
				downArrow.visible = false;
			} else
			{
				upArrow.visible = true;
				downArrow.visible = true;
			}
			
			if (textField.textHeight < _background.height)
			{
				textField.y += 6 * Configuration.SPRITE_SCALE;
				_blackArrow.y += 6 * Configuration.SPRITE_SCALE;
			}
			
		}
		
		public function get VALUE():String
		{
			return textField.getLineText(pointer - 1);
		}
		
		public function scrollDown():void
		{
			if (pointer + 1 > _options.length) return;
			selectOption(pointer + 1);
		}
		
		public function scrollUp():void
		{
			if (pointer - 1 <= 0) return;
			selectOption(pointer - 1);
		}
		
		override public function destroy():void
		{
			this.removeChild(_background);
			_background = null;
			_options = null;
			
			this.removeChild(upArrow);
			this.removeChild(downArrow);
			upArrow.destroy();
			downArrow.destroy();
			upArrow = null;
			downArrow = null;
			
			this.removeChild(textFieldMask);
			textFieldMask.graphics.clear();
			textFieldMask = null;
			
			this.removeChild(_blackArrow);
			_blackArrow.destroy();
			_blackArrow = null;
			
			this.removeChild(textField);
			textField = null;
		}
		
	}

}