package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.stats.PokemonItems;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemartBuyMenu extends UISprite
	{
		public static const TEXT_FORMAT_RIGHT:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0x606060, null, null, null, null, null, TextFormatAlign.RIGHT, null, null, null, 5);
		
		[Embed(source = "assets/UIPokemartBuyMenu.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _background:Bitmap;
		private var _moneyBox:UIBox;
		private var _moneyText:TextField;
		
		private var _callback:Function;
		private var _items:Array;
		private var _itemsString:String;
		
		private var _itemMask:Sprite;
		private var _itemHolder:Sprite;
		private var _itemObjects:Vector.<UIPokemartBuyMenuItem>;
		private var _itemIcon:UIItemSprite;
		private var _backIcon:Bitmap;
		private var _itemDescription:TextField;
		
		private var _arrow:Bitmap;
		
		private var _up_arrow:Bitmap;
		private var _down_arrow:Bitmap;
		
		public function UIPokemartBuyMenu(callback:Function = null, items:String = ""):void
		{
			super(spriteImage);
			
			_callback = callback;
			
			// Parse the items
			_itemsString = items;
			var itemsTemp:Array = items.split(",");
			_items = new Array();
			for (var i:int = 0; i < itemsTemp.length; i++)
			{
				if (itemsTemp[i] != null && itemsTemp[i] != undefined && itemsTemp[i] != "") _items.push(itemsTemp[i]);
			}
			
			construct();
		}
		
		override public function construct():void
		{
			_background = getSprite(0, 0, 240, 160);
			_moneyBox = new UIBox(96, 32);
			
			// The _moneyBox must be behind the background in order to show the "MONEY" text
			this.addChild(_moneyBox);
			this.addChild(_background);
			
			_moneyText = new TextField();
			Configuration.setupTextfield(_moneyText, TEXT_FORMAT_RIGHT, Configuration.TEXT_FILTER);
			_moneyText.width = 80 * Configuration.SPRITE_SCALE;
			_moneyText.height = 16 * Configuration.SPRITE_SCALE;
			_moneyText.x = _moneyText.y = 8 * Configuration.SPRITE_SCALE;
			this.addChild(_moneyText);
			_moneyText.text = Configuration.CURRENCY_SYMBOL + Configuration.ACTIVE_TRAINER.MONEY;
			
			Configuration.MENU_OPEN = true;
			
			_itemObjects = new Vector.<UIPokemartBuyMenuItem>();
			_itemHolder = new Sprite();
			_itemHolder.x = 120 * Configuration.SPRITE_SCALE;
			_itemHolder.y = 16 * Configuration.SPRITE_SCALE;
			this.addChild(_itemHolder);
			
			_itemMask = new Sprite();
			_itemMask.x = 112 * Configuration.SPRITE_SCALE;
			_itemMask.y = 16 * Configuration.SPRITE_SCALE;
			_itemMask.graphics.beginFill(0x000000);
			_itemMask.graphics.drawRect(0, 0, 120 * Configuration.SPRITE_SCALE, 128 * Configuration.SPRITE_SCALE);
			_itemMask.graphics.endFill();
			this.addChild(_itemMask);
			_itemHolder.mask = _itemMask;
			
			_itemDescription = new TextField();
			Configuration.setupTextfield(_itemDescription, UIPokemartBuyMenuItem.TEXT_FORMAT, Configuration.TEXT_FILTER);
			_itemDescription.multiline = true;
			_itemDescription.wordWrap = true;
			_itemDescription.width = 104 * Configuration.SPRITE_SCALE;
			_itemDescription.height = 48 * Configuration.SPRITE_SCALE;
			_itemDescription.x = 3 * Configuration.SPRITE_SCALE;
			_itemDescription.y = 104 * Configuration.SPRITE_SCALE;
			this.addChild(_itemDescription);
			
			createArrow(true);
			
			for (var i:int = 0; i < _items.length; i++)
			{
				createItem(_items[i], true);
			}
			createItem("CANCEL", false);
			
			_up_arrow = getSprite(241, 32, 14, 9);
			_down_arrow = getSprite(241, 41, 14, 9);
			
			_up_arrow.x = _down_arrow.x = (108 + 58) * Configuration.SPRITE_SCALE;
			_up_arrow.y = _up_arrow.height;
			_down_arrow.y = Configuration.VIEWPORT.height - _down_arrow.height * 2;
			this.addChild(_down_arrow);
			this.addChild(_up_arrow);
			animateArrows();
			
			selectItem(1);
			
			KeyboardManager.registerKey(Configuration.UP_KEY, pressUp, InputGroups.POKEMART_BUY_MENU, false);
			KeyboardManager.registerKey(Configuration.DOWN_KEY, pressDown, InputGroups.POKEMART_BUY_MENU, false);
			KeyboardManager.registerKey(Configuration.ENTER_KEY, pressEnter, InputGroups.POKEMART_BUY_MENU, false);
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressCancel, InputGroups.POKEMART_BUY_MENU, true);
		}
		
		private function animateArrows():void
		{
			TweenLite.to(_up_arrow, 0.5, { y:0, onComplete:animateArrowsDown } );
			TweenLite.to(_down_arrow, 0.5, { y:Configuration.VIEWPORT.height - _down_arrow.height } );
		}
		
		private function animateArrowsDown():void
		{
			TweenLite.to(_up_arrow, 0.5, { y:_up_arrow.height, onComplete:animateArrows} );
			TweenLite.to(_down_arrow, 0.5, { y:Configuration.VIEWPORT.height - _down_arrow.height * 2 } );
		}
		
		private function pressUp():void
		{
			if (_quantityInBag)
			{
				SoundManager.playEnterKeySoundEffect();
				selectQuantity(_quantity + 1);
				return;
			}
			
			if (_currentItem > 1)
			{
				SoundManager.playEnterKeySoundEffect();
				selectItem(_currentItem - 1);
			}
		}
		
		private function pressDown():void
		{
			if (_quantityInBag)
			{
				SoundManager.playEnterKeySoundEffect();
				selectQuantity(_quantity - 1, false);
				return;
			}
			
			if (_currentItem < _itemObjects.length)
			{
				SoundManager.playEnterKeySoundEffect();
				selectItem(_currentItem + 1);
			}
		}
		
		private function pressCancel():void
		{
			SoundManager.playEnterKeySoundEffect();
			if (_quantityInBag)
			{
				destroyQuantitySelector();
				return;
			}
			
			KeyboardManager.unregisterKey(Configuration.UP_KEY, pressUp);
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, pressDown);
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, pressCancel);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, pressEnter);
			
			Configuration.FADE_OUT_AND_IN(finishPressCancel);
		}
		
		private function pressEnter():void
		{
			if (_quantityInBag)
			{
				// Confirm
				SoundManager.playEnterKeySoundEffect();
				destroyQuantitySelector();
				MessageCenter.addMessage(Message.createQuestionFromArray(_currentItemName.toUpperCase().replace("É", "é") + "? And you wanted " + _quantity + "?\nThat will be " + Configuration.CURRENCY_SYMBOL + _currentQuantityCost + ".", buyItem, ["YES", "NO"], 23));
				return;
			}
			// Select
			if (_currentItem > _items.length)
			{
				// CANCEL!
				pressCancel();
			}
			else
			{
				SoundManager.playEnterKeySoundEffect();
				var cost:int = PokemonItems.getItemPriceByName(_items[_currentItem - 1]);
				if (Configuration.ACTIVE_TRAINER.MONEY < cost)
				{
					MessageCenter.addMessage(Message.createMessage("You don't have enough money.", true, 0, null, 23));
				}
				else
				{
					// We have enough money.
					createArrow(false);
					_currentItemName = String(_items[_currentItem - 1]);
					MessageCenter.addMessage(Message.createMessage(_currentItemName.toUpperCase().replace("É", "é") + "? Certainly.\nHow many would you like?", false, 0, showQuantitySelector, 23, true));
				}
			}
		}
		
		private function buyItem(answer:String):void
		{
			if (answer == "NO")
			{
				// Do nothing
			}
			else if (answer == "YES")
			{
				// Buy the item!
				Configuration.ACTIVE_TRAINER.takeMoney(_currentQuantityCost);
				_moneyText.text = Configuration.CURRENCY_SYMBOL + Configuration.ACTIVE_TRAINER.MONEY;
				for (var i:int = 0; i < _quantity; i++) Configuration.ACTIVE_TRAINER.giveItem(_currentItemName);
				SoundManager.playSoundEffect(SoundEffect.POKEMART_BUY);
				MessageCenter.addMessage(Message.createMessage("Here you go!\nThank you very much.", true, 0, null, 23));
			}
		}
		
		private var _quantitySelector:UIDoubleTextBox;
		private var _quantityInBag:UITextBox;
		private var _quantity:int = 1;
		private var _currentQuantityCost:int = 0;
		private var _currentItemName:String;
		
		private function showQuantitySelector():void
		{
			var quantity:int = Configuration.ACTIVE_TRAINER.getNumberOfItems(_currentItemName);
			_quantityInBag = new UITextBox("IN BAG:  " + (quantity < 1000 ? " " : "") + (quantity < 100 ? " " : "") + (quantity < 10 ? " " : "") + quantity, 112, 32, 7, 7, 7, 7);
			_quantityInBag.x = 0;
			_quantityInBag.y = 80 * Configuration.SPRITE_SCALE;
			this.addChild(_quantityInBag);
			
			_quantitySelector = new UIDoubleTextBox("", "", 96, 32, 7, 7, 7, 7);
			_quantitySelector.x = 136 * Configuration.SPRITE_SCALE;
			_quantitySelector.y = 80 * Configuration.SPRITE_SCALE;
			this.addChild(_quantitySelector);
			
			selectQuantity(1);
			
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.POKEMART_BUY_MENU);
		}
		
		private function selectQuantity(num:int, goingUp:Boolean = true):void
		{
			var maxNum:int = Math.floor(Configuration.ACTIVE_TRAINER.MONEY / PokemonItems.getItemPriceByName(_currentItemName));
			if (goingUp && (num > 99 || num > maxNum)) num = 1;
			else if (!goingUp && num < 1) num = (maxNum < 99 ? maxNum : 99);
			
			_quantity = num;
			_currentQuantityCost = _quantity * PokemonItems.getItemPriceByName(_currentItemName);
			
			_quantitySelector.TEXT_FIELD1.text = "x" + (_quantity < 10 ? "0" : "") + _quantity;
			_quantitySelector.TEXT_FIELD2.text = Configuration.CURRENCY_SYMBOL + _currentQuantityCost;
		}
		
		private function destroyQuantitySelector():void
		{
			if (_quantitySelector)
			{
				this.removeChild(_quantitySelector);
				_quantitySelector.destroy();
				_quantitySelector = null;
			}
			if (_quantityInBag)
			{
				this.removeChild(_quantityInBag);
				_quantityInBag.destroy();
				_quantityInBag = null;
			}
			createArrow(true);
			if (MessageCenter.WAITING_ON_FINISH_MESSAGE) MessageCenter.finishMessage();
		}
		
		private function finishPressCancel():void
		{
			Configuration.createMenu(MenuType.POKEMART, 1, _callback, true, _itemsString);
			destroy();
		}
		
		private function createArrow(black:Boolean = true):void
		{
			destroyArrow();
			_arrow = getSprite(241 + (black == false ? 6 : 0), 22, 6, 10);
			_arrow.x = -7 * Configuration.SPRITE_SCALE;
			_arrow.y = (_currentItem - 1) * 16 * Configuration.SPRITE_SCALE + 4 * Configuration.SPRITE_SCALE;
			_itemHolder.addChild(_arrow);
		}
		
		private var _currentItem:int = 1;
		
		private function selectItem(itemNum:int):void
		{
			_currentItem = itemNum;
			_arrow.y = (_currentItem - 1) * 16 * Configuration.SPRITE_SCALE + 4 * Configuration.SPRITE_SCALE;
			
			// Reset the y coordinate to the top of the list.
			_itemHolder.y = 16 * Configuration.SPRITE_SCALE;
			
			if (_currentItem >= 5 && _itemObjects.length > 8)
			{
				if (_itemObjects.length - _currentItem < 4)
				{
					_itemHolder.y += (_itemObjects.length - 8) * -16 * Configuration.SPRITE_SCALE;
				}
				else
				{
					_itemHolder.y += (_currentItem - 5) * -16 * Configuration.SPRITE_SCALE;
				}
			}
			
			if (_itemHolder.y == 16 * Configuration.SPRITE_SCALE) _up_arrow.visible = false;
			else _up_arrow.visible = true;
			
			if (_itemObjects.length >= 9 && _itemObjects.length - _currentItem > 3) _down_arrow.visible = true;
			else _down_arrow.visible = false;
			
			destroyItemIcon();
			destroyBackIcon();
			
			if (_currentItem > _items.length)
			{
				// We're on the "CANCEL" button, create the back icon
				_backIcon = getSprite(241, 0, 20, 20);
				_backIcon.x = 10 * Configuration.SPRITE_SCALE;
				_backIcon.y = 74 * Configuration.SPRITE_SCALE;
				this.addChild(_backIcon);
				
				_itemDescription.text = "Quit shopping.";
			}
			else
			{
				_itemIcon = new UIItemSprite(PokemonItems.getItemSpriteNameByName(_items[_currentItem - 1]));
				_itemIcon.x = 20 * Configuration.SPRITE_SCALE;
				_itemIcon.y = 84 * Configuration.SPRITE_SCALE;
				this.addChild(_itemIcon);
				
				_itemDescription.text = PokemonItems.getItemDescriptionByName(_items[_currentItem - 1]);
			}
		
		}
		
		override public function destroy():void
		{
			Configuration.MENU_OPEN = false;
			
			destroyArrow();
			destroyQuantitySelector();
			
			this.removeChild(_background);
			this.removeChild(_moneyBox);
			this.removeChild(_moneyText);
			
			_moneyBox.destroy();
			_background.bitmapData.dispose();
			
			_moneyBox = null;
			_background = null;
			_moneyText = null;
			
			_callback = null;
			
			for (var i:int = 0; i < _itemObjects.length; i++)
			{
				_itemHolder.removeChild(_itemObjects[i]);
				_itemObjects[i].destroy();
				_itemObjects[i] = null;
			}
			_itemObjects = null;
			
			this.removeChild(_itemHolder);
			_itemHolder = null;
			this.removeChild(_itemMask);
			_itemMask.graphics.clear();
			_itemMask = null;
			
			this.removeChild(_itemDescription);
			_itemDescription = null;
			
			TweenLite.killTweensOf(_up_arrow);
			TweenLite.killTweensOf(_down_arrow);
			
			this.removeChild(_up_arrow);
			this.removeChild(_down_arrow);
			_up_arrow.bitmapData.dispose();
			_down_arrow.bitmapData.dispose();
			_up_arrow = _down_arrow = null;
			
			destroyItemIcon();
			destroyBackIcon();
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
		
		private function createItem(name:String, includePrice:Boolean = true):void
		{
			var item:UIPokemartBuyMenuItem = new UIPokemartBuyMenuItem(String(name).toUpperCase(), includePrice ? PokemonItems.getItemPriceByName(name).toString() : "");
			item.x = 0;
			item.y = 16 * _itemObjects.length * Configuration.SPRITE_SCALE;
			_itemHolder.addChild(item);
			_itemObjects.push(item);
		}
		
		private function destroyArrow():void
		{
			if (!_arrow) return;
			_itemHolder.removeChild(_arrow);
			_arrow.bitmapData.dispose();
			_arrow = null;
		
		}
		
		private function destroyItemIcon():void
		{
			if (!_itemIcon) return;
			this.removeChild(_itemIcon);
			_itemIcon.destroy();
			_itemIcon = null;
		}
		
		private function destroyBackIcon():void
		{
			if (!_backIcon) return;
			this.removeChild(_backIcon);
			_backIcon.bitmapData.dispose();
			_backIcon = null;
		}
	
	}

}