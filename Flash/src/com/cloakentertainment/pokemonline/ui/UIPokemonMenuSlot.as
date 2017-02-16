package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonGender;
	import com.cloakentertainment.pokemonline.stats.PokemonStat;
	import com.cloakentertainment.pokemonline.stats.PokemonStatusConditions;
	import flash.display.Bitmap;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonMenuSlot extends UISprite implements UIElement
	{
		[Embed(source="assets/UIPokemonMenuSlot.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		public static const TEXT_FORMAT_POKEDEX:TextFormat = new TextFormat("PokemonFont", 12 * Configuration.SPRITE_SCALE, 0xffffff, null, null, null, null, null, null, null, null, null, 5);
		public static const TEXT_FILTER_POKEDEX:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 2, 45, 0x707070, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);
		
		private var _background:Bitmap;
		private var _pokeball:Bitmap;
		private var _pokemonIcon:UIPokemonAnimatedTinySprite;
		
		private var chosen:Boolean = false;
		private var large:Boolean = false;
		private var fainted:Boolean = false;
		private var cancel:Boolean = false;
		private var pokemon:Pokemon;
		
		private var pokemonNameText:TextField;
		private var pokemonLevelText:TextField;
		private var statusCondition:UIPokemonStatusCondition;
		private var gender:Bitmap;
		private var hpText:TextField;
		private var hpBar:UIPokemonHPBar;
		private var helditem:Bitmap;
		
		public function UIPokemonMenuSlot(_pokemon:Pokemon, _large:Boolean, _fainted:Boolean = false, _cancel:Boolean = false)
		{
			super(spriteImage);
			
			pokemon = _pokemon;
			large = _large;
			fainted = _fainted;
			cancel = _cancel;
			
			if (pokemon && pokemon.getNonVolatileStatusCondition() == PokemonStatusConditions.FAINT)
				fainted = true;
			
			construct();
		}
		
		public function get POKEMON_NULL():Boolean
		{
			if (pokemon == null && cancel == false)
				return true;
			else
				return false;
		}
		
		override public function construct():void
		{
			if (cancel)
			{
				_background = getSprite(222, 98, 52, 16);
				this.addChild(_background);
				return;
			}
			if (!pokemon)
			{
				_background = getSprite(40, 164 + 22, 142, 22);
				this.addChild(_background);
				return;
			}
			
			deselect();
			
			if (pokemon.GENDER == PokemonGender.FEMALE || pokemon.GENDER == PokemonGender.MALE)
			{
				gender = getSprite(pokemon.GENDER == PokemonGender.FEMALE ? 5 : 0, 27, 5, 8);
				gender.x = 60 * Configuration.SPRITE_SCALE;
				gender.y = 14 * Configuration.SPRITE_SCALE;
				this.addChild(gender);
				if (large)
				{
					gender.y += 8 * Configuration.SPRITE_SCALE;
					gender.x += 2 * Configuration.SPRITE_SCALE;
				}
			}
			
			if (pokemon.HELDITEM != "")
			{
				// Create helditem icon
				helditem = getSprite(0, 20, 7, 7);
				helditem.x = 9 * Configuration.SPRITE_SCALE;
				helditem.y = 15 * Configuration.SPRITE_SCALE;
				if (large)
					helditem.y += 4 * Configuration.SPRITE_SCALE;
			}
			
			pokemonNameText = new TextField();
			Configuration.setupTextfield(pokemonNameText, TEXT_FORMAT_POKEDEX, TEXT_FILTER_POKEDEX);
			pokemonNameText.x = 22 * Configuration.SPRITE_SCALE;
			pokemonNameText.y = 2 * Configuration.SPRITE_SCALE;
			pokemonNameText.width = 64 * Configuration.SPRITE_SCALE;
			pokemonNameText.text = pokemon.NAME;
			if (large)
			{
				pokemonNameText.x += 2 * Configuration.SPRITE_SCALE;
				pokemonNameText.y += 8 * Configuration.SPRITE_SCALE;
			}
			this.addChild(pokemonNameText);
			
			pokemonLevelText = new TextField();
			Configuration.setupTextfield(pokemonLevelText, TEXT_FORMAT_POKEDEX, TEXT_FILTER_POKEDEX);
			pokemonLevelText.x = 26 * Configuration.SPRITE_SCALE;
			pokemonLevelText.y = 11 * Configuration.SPRITE_SCALE;
			pokemonLevelText.width = 64 * Configuration.SPRITE_SCALE;
			pokemonLevelText.text = "Lv" + pokemon.LEVEL;
			if (large)
			{
				pokemonLevelText.x += 2 * Configuration.SPRITE_SCALE;
				pokemonLevelText.y += 8 * Configuration.SPRITE_SCALE;
			}
			this.addChild(pokemonLevelText);
			
			hpText = new TextField();
			Configuration.setupTextfield(hpText, TEXT_FORMAT_POKEDEX, TEXT_FILTER_POKEDEX);
			hpText.x = 104 * Configuration.SPRITE_SCALE;
			hpText.y = 11 * Configuration.SPRITE_SCALE;
			hpText.width = 64 * Configuration.SPRITE_SCALE;
			hpText.text = pokemon.CURRENT_HP + "/" + (pokemon.getStat(PokemonStat.HP) < 100 ? " " : "") + pokemon.getStat(PokemonStat.HP);
			if (large)
			{
				hpText.x = 40 * Configuration.SPRITE_SCALE;
				hpText.y = 36 * Configuration.SPRITE_SCALE;
			}
			this.addChild(hpText);
			
			hpBar = new UIPokemonHPBar(pokemon.CURRENT_HP, pokemon.getStat(PokemonStat.HP));
			hpBar.x = 88 * Configuration.SPRITE_SCALE;
			hpBar.y = 8 * Configuration.SPRITE_SCALE;
			if (large)
			{
				hpBar.x = 24 * Configuration.SPRITE_SCALE;
				hpBar.y = 33 * Configuration.SPRITE_SCALE;
			}
			this.addChild(hpBar);
			
			if (pokemon.getNonVolatileStatusCondition() != null)
			{
				pokemonLevelText.visible = false;
				statusCondition = new UIPokemonStatusCondition(pokemon.getNonVolatileStatusCondition());
				statusCondition.x = 26 * Configuration.SPRITE_SCALE;
				statusCondition.y = 14 * Configuration.SPRITE_SCALE;
				this.addChild(statusCondition);
				if (large)
				{
					statusCondition.x += 2 * Configuration.SPRITE_SCALE;
					statusCondition.y += 8 * Configuration.SPRITE_SCALE;
				}
			}
			
			_pokemonIcon = new UIPokemonAnimatedTinySprite(pokemon.base.ID);
			_pokemonIcon.x = -12 * Configuration.SPRITE_SCALE;
			_pokemonIcon.y = -8 * Configuration.SPRITE_SCALE;
			if (large)
				_pokemonIcon.y += 4 * Configuration.SPRITE_SCALE;
			this.addChild(_pokemonIcon);
			
			if (fainted) _pokemonIcon.stopAnimating();
			
			if (helditem)
				this.addChild(helditem);
		}
		
		override public function destroy():void
		{
			this.removeChild(_background);
			
			if (_pokemonIcon)
			{
				this.removeChild(_pokemonIcon);
				this.removeChild(_pokeball);
				this.removeChild(pokemonNameText);
				this.removeChild(pokemonLevelText);
				this.removeChild(hpText);
				this.removeChild(hpBar);
				hpBar.destroy();
			}
			if (statusCondition)
			{
				this.removeChild(statusCondition);
				statusCondition.destroy();
				statusCondition = null;
			}
			if (gender)
			{
				this.removeChild(gender);
				gender = null;
			}
			if (helditem)
			{
				this.removeChild(helditem);
				helditem = null;
			}
			
			hpBar = null;
			pokemonLevelText = null;
			pokemonNameText = null;
			pokemon = null;
			hpText = null;
			_background = null;
			_pokemonIcon = null;
			_pokeball = null;
		}
		
		public function get POKEMON():Pokemon
		{
			return pokemon;
		}
		
		public function get LARGE():Boolean
		{
			return large;
		}
		
		public function choose():void
		{
			chosen = true;
			if (selected)
				select();
			else
				deselect();
		}
		
		public function unchoose():void
		{
			chosen = false;
			if (selected)
				select();
			else
				deselect();
		}
		
		private var selected:Boolean = false;
		
		public function deselect():void
		{
			if (cancel)
			{
				this.removeChild(_background);
				_background = getSprite(222, 98, 52, 16);
				this.addChild(_background);
				if (_pokeball)
				{
					this.removeChild(_pokeball);
					_pokeball = null;
				}
				_pokeball = getSprite(0, 0, 20, 20);
				_pokeball.y = -2 * Configuration.SPRITE_SCALE;
				_pokeball.x = -2 * Configuration.SPRITE_SCALE;
				this.addChild(_pokeball);
				return;
			}
			if (!pokemon)
				return;
			
			if (_background)
			{
				this.removeChild(_background);
				_background = null;
				this.removeChild(_pokeball);
				_pokeball = null;
			}
			
			if (!chosen)
			{
				if (large)
				{
					if (fainted)
						_background = getSprite(196, 0, 78, 49);
					else
						_background = getSprite(40, 0, 78, 49);
				}
				else
				{
					if (fainted)
						_background = getSprite(40, 208, 142, 22);
					else
						_background = getSprite(40, 98, 142, 22);
				}
			}
			else
			{
				if (large)
				{
					_background = getSprite(40, 49, 78, 49);
				}
				else
					_background = getSprite(40, 142, 142, 22);
			}
			
			_pokeball = getSprite(0, 0, 20, 20);
			_pokeball.y = 1 * Configuration.SPRITE_SCALE;
			_pokeball.x = -8 * Configuration.SPRITE_SCALE;
			
			this.addChild(_background);
			this.addChild(_pokeball);
			
			this.setChildIndex(_pokeball, 0);
			this.setChildIndex(_background, 0);
			
			selected = false;
		}
		
		public function select():void
		{
			if (cancel)
			{
				this.removeChild(_background);
				_background = getSprite(222, 114, 52, 16);
				this.addChild(_background);
				if (_pokeball)
				{
					this.removeChild(_pokeball);
					_pokeball = null;
				}
				_pokeball = getSprite(20, 0, 20, 24);
				_pokeball.y = -4 * Configuration.SPRITE_SCALE;
				_pokeball.x = -2 * Configuration.SPRITE_SCALE;
				this.addChild(_pokeball);
				return;
			}
			if (!pokemon)
				return;
			
			if (_background)
			{
				this.removeChild(_background);
				_background = null;
				this.removeChild(_pokeball);
				_pokeball = null;
			}
			
			if (!chosen)
			{
				if (large)
				{
					if (fainted)
						_background = getSprite(196, 49, 78, 49);
					else
						_background = getSprite(40 + 78, 0, 78, 49);
				}
				else
				{
					if (fainted)
						_background = getSprite(40, 230, 142, 22);
					else
						_background = getSprite(40, 120, 142, 22);
				}
			}
			else
			{
				if (large)
				{
					_background = getSprite(40 + 78, 49, 78, 49);
				}
				else
					_background = getSprite(40, 164, 142, 22);
			}
			
			_pokeball = getSprite(20, 0, 20, 24);
			_pokeball.y = -1 * Configuration.SPRITE_SCALE;
			_pokeball.x = -8 * Configuration.SPRITE_SCALE;
			
			this.addChild(_background);
			this.addChild(_pokeball);
			
			this.setChildIndex(_pokeball, 0);
			this.setChildIndex(_background, 0);
			
			selected = true;
		}
	
	}

}