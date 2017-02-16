package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonGender;
	import com.cloakentertainment.pokemonline.stats.PokemonStat;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBattlePokemonSlot extends UISprite implements UIElement
	{
		[Embed(source="assets/UIBattlePokemonSlot.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		public static const TEXT_FORMAT_POKEDEX:TextFormat = new TextFormat("PokemonFont", 12 * Configuration.SPRITE_SCALE, 0x404040, null, null, null, null, null, null, null, null, null, 5);
		public static const TEXT_FORMAT_POKEDEX_RIGHT:TextFormat = new TextFormat("PokemonFont", 12 * Configuration.SPRITE_SCALE, 0x404040, null, null, null, null, null, TextFormatAlign.RIGHT, null, null, null, 5);
		public static const TEXT_FILTER_POKEDEX:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0xd8d0b0, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		
		private var _background:Bitmap;
		private var _pokeball:Bitmap;
		
		private var left:Boolean;
		private var large:Boolean;
		private var pokemon:Pokemon;
		
		private var pokemonNameText:TextField;
		private var pokemonLevelText:TextField;
		private var statusCondition:UIPokemonStatusCondition;
		private var gender:Bitmap;
		private var hpText:TextField;
		private var hpBar:UIPokemonHPBar;
		private var xpBar:UIPokemonXPBar;
		private var helditem:Bitmap;
		
		public var displayedHP:Number = 0;
		public var displayedLevel:int = 0;
		
		public function UIBattlePokemonSlot(_pokemon:Pokemon, _left:Boolean, _large:Boolean = false)
		{
			super(spriteImage);
			
			pokemon = _pokemon;
			left = _left;
			large = _large;
			
			construct();
		}
		
		public function get DISPLAYED_HEALTH():Number
		{
			return hpBar.DISPLAYED_HEALTH;
		}
		
		public function get POKEMON_HEALTH():Number
		{
			return pokemon.CURRENT_HP;
		}
		
		public function updateHPBar(callback:Function = null, changeMaxHealth:int = 0):void
		{
			if (DISPLAYED_HEALTH != POKEMON_HEALTH)
			{
				if (callback == null) callback = finishUpdatingHPBar;
				var duration:Number = hpBar.updateHealth(POKEMON_HEALTH, callback, changeMaxHealth);
				
				TweenLite.to(this, duration, {displayedHP: POKEMON_HEALTH, onUpdate: updateHPText, ease: Linear.easeNone});
			}
		}
		
		private function finishUpdatingHPBar():void
		{
			
		}
		
		public function get isHPBarRed():Boolean
		{
			if (hpBar == null) return false;
			else return hpBar.IS_RED;
		}
		
		public function updateXPBar(callback:Function = null):void
		{
			if (!xpBar) return;
			
			if (pokemon.LEVEL != displayedLevel)
			{
				// We levelled up!
				tempCallback = callback;
				xpBar.updateXP(xpBar.TOTAL_XP, finishUpdatingLevelUp);
			} else xpBar.updateXP(pokemon.XP - pokemon.LEVEL_BASE_XP, callback);
		}
		
		private var tempCallback:Function;
		private function finishUpdatingLevelUp():void
		{
			this.removeChild(xpBar);
			xpBar.destroy();
			xpBar = null;
			createXPBar(true);
			
			pokemonLevelText.text = "Lv" + pokemon.LEVEL;
			displayedLevel = pokemon.LEVEL;
			updateXPBar(tempCallback);
			tempCallback = null;
		}
		
		private function createXPBar(startAtZero:Boolean = false):void
		{
			xpBar = new UIPokemonXPBar(startAtZero ? 0 : pokemon.XP - pokemon.LEVEL_BASE_XP, pokemon.NEXT_LEVEL_BASE_XP - pokemon.LEVEL_BASE_XP, 2);
			xpBar.x = 31 * Configuration.SPRITE_SCALE;
			xpBar.y = 33 * Configuration.SPRITE_SCALE;
			this.addChild(xpBar);
		}
		
		override public function construct():void
		{
			if (large)
			{
				if (left == false)
					_background = getSprite(0, 25, 103, 36);
				else
				{
					// Probably shouldn't be on the left side...
				}
			}
			else
			{
				if (left)
					_background = getSprite(0, 0, 100, 25);
				else
					_background = getSprite(100, 0, 100, 25);
			}
			
			this.addChild(_background);
			
			pokemonNameText = new TextField();
			Configuration.setupTextfield(pokemonNameText, TEXT_FORMAT_POKEDEX, TEXT_FILTER_POKEDEX);
			pokemonNameText.x = (left ? 7 : 15) * Configuration.SPRITE_SCALE;
			pokemonNameText.y = 2 * Configuration.SPRITE_SCALE + 1;
			pokemonNameText.width = 64 * Configuration.SPRITE_SCALE;
			pokemonNameText.autoSize = TextFieldAutoSize.LEFT;
			pokemonNameText.text = pokemon.NAME;
			this.addChild(pokemonNameText);
			
			if (pokemon.GENDER == PokemonGender.FEMALE || pokemon.GENDER == PokemonGender.MALE)
			{
				gender = getSprite(pokemon.GENDER == PokemonGender.FEMALE ? 103 : 108, 25, 5, 8);
				gender.x = pokemonNameText.x + pokemonNameText.textWidth + 1 * Configuration.SPRITE_SCALE;
				gender.y = 5 * Configuration.SPRITE_SCALE;
				this.addChild(gender);
			}
			
			var owned:Boolean = Configuration.ACTIVE_TRAINER.ownedPokemon(pokemon.base.name);
			if (owned && left)
			{
				// Must be on the right side and owned to add the pokeball sprite
				_pokeball = getSprite(113, 25, 7, 7);
				_pokeball.x = 7 * Configuration.SPRITE_SCALE;
				_pokeball.y = 14 * Configuration.SPRITE_SCALE;
				this.addChild(_pokeball);
			}
			
			pokemonLevelText = new TextField();
			Configuration.setupTextfield(pokemonLevelText, TEXT_FORMAT_POKEDEX_RIGHT, TEXT_FILTER_POKEDEX);
			pokemonLevelText.x = (left ? 62 : 70) * Configuration.SPRITE_SCALE;
			pokemonLevelText.y = 2 * Configuration.SPRITE_SCALE + 1;
			pokemonLevelText.width = 26 * Configuration.SPRITE_SCALE;
			pokemonLevelText.text = "Lv" + pokemon.LEVEL;
			this.addChild(pokemonLevelText);
			
			displayedLevel = pokemon.LEVEL;
			
			if (large)
			{
				displayedHP = pokemon.CURRENT_HP;
				
				hpText = new TextField();
				Configuration.setupTextfield(hpText, TEXT_FORMAT_POKEDEX_RIGHT, TEXT_FILTER_POKEDEX);
				hpText.x = 61 * Configuration.SPRITE_SCALE;
				hpText.y = 20 * Configuration.SPRITE_SCALE - 1;
				hpText.width = 34 * Configuration.SPRITE_SCALE;
				updateHPText();
				this.addChild(hpText);
				
				createXPBar();
				
			}
			
			hpBar = new UIPokemonHPBar(pokemon.CURRENT_HP, pokemon.getStat(PokemonStat.HP), 1);
			hpBar.x = (left ? 39 : 47) * Configuration.SPRITE_SCALE;
			hpBar.y = 17 * Configuration.SPRITE_SCALE;
			this.addChild(hpBar);
			
			updateStatusCondition();
		}
		
		public function updateStatusCondition():void
		{
			destroyStatusCondition();
			
			if (pokemon.getNonVolatileStatusCondition() != null)
			{
				statusCondition = new UIPokemonStatusCondition(pokemon.getNonVolatileStatusCondition());
				statusCondition.x = (left ? 3 : 11) * Configuration.SPRITE_SCALE;
				statusCondition.y = 14 * Configuration.SPRITE_SCALE;
				this.addChild(statusCondition);
				if (large)
					statusCondition.y = 22 * Configuration.SPRITE_SCALE;
			}
		}
		
		override public function destroy():void
		{
			this.removeChild(_background);
			_background.bitmapData.dispose();
			_background = null;
			
			this.removeChild(pokemonLevelText);
			this.removeChild(pokemonNameText);
			this.removeChild(hpBar);
			hpBar.destroy();
			hpBar = null;
			pokemonLevelText = pokemonNameText = null;
			
			destroyStatusCondition();
			
			if (gender)
			{
				this.removeChild(gender);
				gender.bitmapData.dispose();
				gender = null;
			}
			
			pokemon = null;
			
			if (hpText)
			{
				this.removeChild(hpText);
				hpText = null;
				this.removeChild(xpBar);
				xpBar.destroy();
				xpBar = null;
			}
			
			if (_pokeball)
			{
				this.removeChild(_pokeball);
				_pokeball.bitmapData.dispose();
				_pokeball = null;
			}
		}
		
		private function destroyStatusCondition():void
		{
			if (statusCondition)
			{
				this.removeChild(statusCondition);
				statusCondition.destroy();
				statusCondition = null;
			}
		}
		
		public function get POKEMON():Pokemon
		{
			return pokemon;
		}
		
		public function updateHPText():void
		{
			if (hpText == null)
				return;
			
			var tempValue:int = Math.ceil(displayedHP);
			hpText.text = (tempValue < 100 ? " " : "") + (tempValue < 10 ? " " : "") + tempValue + "/" + (pokemon.getStat(PokemonStat.HP) < 100 ? " " : "") + (pokemon.getStat(PokemonStat.HP) < 10 ? " " : "") + pokemon.getStat(PokemonStat.HP);
		}
	
	}

}