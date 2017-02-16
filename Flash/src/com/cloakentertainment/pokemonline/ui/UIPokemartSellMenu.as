package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.stats.PokemonItems;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.cloakentertainment.pokemonline.ui.Message;
	import com.cloakentertainment.pokemonline.ui.MessageCenter;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemartSellMenu extends UISprite implements UIElement
	{
		[Embed(source = "assets/UIBagMenu.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var background:Bitmap;
		private var pokeball_spinner:Sprite;
		private var pokeball_spinner_bmp:Bitmap;
		private var itemDetail:TextField;
		
		private var left_arrow:Bitmap;
		private var right_arrow:Bitmap;
		private var up_arrow:Bitmap;
		private var down_arrow:Bitmap;
		
		private var arrow:Bitmap;
		
		private var _callback:Function;
		private var _items:String;
		
		public function UIPokemartSellMenu(callback:Function = null, items:String = "")
		{
			super(spriteImage);
			
			_callback = callback;
			_items = items;
			
			construct();
		}
		
		override public function construct():void
		{
			if (Configuration.BAG_STATE_VECTOR.length != 0)
			{
				state1 = Configuration.BAG_STATE_VECTOR[0];
				state2 = Configuration.BAG_STATE_VECTOR[1];
				state3 = Configuration.BAG_STATE_VECTOR[2];
				state4 = Configuration.BAG_STATE_VECTOR[3];
				state5 = Configuration.BAG_STATE_VECTOR[4];
			}
			
			if (TrainerType.isMale(Configuration.ACTIVE_TRAINER.TYPE))
			{
				background = getSprite(0, 0, 240, 160);
			}
			else
				background = getSprite(240, 0, 240, 160);
			this.addChild(background);
			
			pokeball_spinner_bmp = getSprite(480, 0, 10, 10);
			pokeball_spinner = new Sprite();
			pokeball_spinner_bmp.x = -0.5 * 10 * Configuration.SPRITE_SCALE;
			pokeball_spinner_bmp.y = -0.5 * 10 * Configuration.SPRITE_SCALE;
			pokeball_spinner.addChild(pokeball_spinner_bmp);
			pokeball_spinner.x = pokeball_spinner.y = 16 * Configuration.SPRITE_SCALE;
			
			this.addChild(pokeball_spinner);
			
			itemDetail = new TextField();
			Configuration.setupTextfield(itemDetail, Configuration.TEXT_FORMAT_POKEDEX, Configuration.TEXT_FILTER);
			itemDetail.width = 105 * Configuration.SPRITE_SCALE;
			itemDetail.multiline = true;
			itemDetail.wordWrap = true;
			itemDetail.height = 50 * Configuration.SPRITE_SCALE;
			itemDetail.x = 2 * Configuration.SPRITE_SCALE;
			itemDetail.y = 104 * Configuration.SPRITE_SCALE;
			this.addChild(itemDetail);
			itemDetail.text = "Return to\nthe shop.";
			
			arrow = getSprite(480, 38, 6, 10);
			arrow.x = 112 * Configuration.SPRITE_SCALE;
			arrow.y = 16 * 1 * Configuration.SPRITE_SCALE + 3 * Configuration.SPRITE_SCALE;
			this.addChild(arrow);
			
			left_arrow = getSprite(492, 0, 9, 14);
			right_arrow = getSprite(492 + 9, 0, 9, 14);
			left_arrow.y = right_arrow.y = 9 * Configuration.SPRITE_SCALE;
			left_arrow.x = 24 * Configuration.SPRITE_SCALE;
			right_arrow.x = 96 * Configuration.SPRITE_SCALE;
			this.addChild(right_arrow);
			this.addChild(left_arrow);
			up_arrow = getSprite(480, 48, 14, 9);
			down_arrow = getSprite(480, 48 + 9, 14, 9);
			up_arrow.x = down_arrow.x = 165 * Configuration.SPRITE_SCALE;
			up_arrow.y = 7 * Configuration.SPRITE_SCALE;
			down_arrow.y = 144 * Configuration.SPRITE_SCALE;
			this.addChild(up_arrow);
			this.addChild(down_arrow);
			
			animateArrows();
			
			drawPocket(Configuration.BAG_CURRENTLY_SELECTED);
			
			KeyboardManager.registerKey(Configuration.LEFT_KEY, pressLeft, InputGroups.POKEMART_SELL_MENU, true);
			KeyboardManager.registerKey(Configuration.RIGHT_KEY, pressRight, InputGroups.POKEMART_SELL_MENU, true);
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressCancel, InputGroups.POKEMART_SELL_MENU, true);
			KeyboardManager.registerKey(Configuration.UP_KEY, pressUp, InputGroups.POKEMART_SELL_MENU, false);
			KeyboardManager.registerKey(Configuration.DOWN_KEY, pressDown, InputGroups.POKEMART_SELL_MENU, false);
			KeyboardManager.registerKey(Configuration.ENTER_KEY, pressEnter, InputGroups.POKEMART_SELL_MENU, true);
		}
		
		private var arrowBlack:Boolean = true;
		
		private function toggleArrow():void
		{
			var x:int = arrow.x;
			var y:int = arrow.y;
			this.removeChild(arrow);
			if (arrowBlack)
				arrow = getSprite(506, 38, 6, 10);
			else
				arrow = getSprite(480, 38, 6, 10);
			arrow.x = x;
			arrow.y = y;
			arrowBlack = !arrowBlack;
			this.addChild(arrow);
		}
		
		private var _moneyBox:UIDoubleTextBox;
		private var _moneyText:UIPokemartMoneyText;
		
		private function drawMoneyBox():void
		{
			if (_moneyBox) destroyMoneyBox();
			
			_moneyBox = new UIDoubleTextBox("", Configuration.CURRENCY_SYMBOL + Configuration.ACTIVE_TRAINER.MONEY, 96, 32, 7, 7, 7, 7);
			this.addChild(_moneyBox);
			_moneyText = new UIPokemartMoneyText();
			_moneyText.x = _moneyText.y = 6 * Configuration.SPRITE_SCALE;
			this.addChild(_moneyText);
		}
		
		private function destroyMoneyBox():void
		{
			this.removeChild(_moneyBox);
			_moneyBox.destroy();
			_moneyBox = null;
			
			this.removeChild(_moneyText);
			_moneyText.destroy();
			_moneyText = null;
		}
		
		private var itemSelectionBox:UIBox;
		private var itemSelectionType:int = 1; // 1 for standard 4 option box, 2 for 5 option berry box, 3 for 3 option key item box, 4 for 3 option pokeball box, 5 for the tms and hms
		private var textBoxes:Vector.<TextField>;
		
		private var _sellingItem:String;
		private var _sellingQuantity:int;
		private var _sellingCost:int;
		
		private function pressEnter():void
		{
			SoundManager.playEnterKeySoundEffect();
			
			if (_quantitySelector)
			{
				if (MessageCenter.WAITING_ON_FINISH_MESSAGE) MessageCenter.finishMessage();
				destroyQuantitySelector();
				_sellingCost = _sellingQuantity * PokemonItems.getItemSellPriceByName(_sellingItem);
				MessageCenter.addMessage(Message.createQuestionFromArray("I can pay " + Configuration.CURRENCY_SYMBOL + _sellingCost + ".\nWould that be okay?", sellItem, ["YES", "NO"], 23));
				return;
			}
			
			// select the item
			var item:UIBagMenuItem = itemObjects[currentlySelectedItem - 1];
			if (item.ITEM_NAME == "CLOSE BAG")
				closeBag();
			else
			{
				// Select item!
				_sellingItem = item.ITEM_REAL_NAME;
				_sellingQuantity = 1;
				if (item.ITEM_COUNT == 1)
				{
					// We can only sell one!
					drawMoneyBox();
					_sellingCost = _sellingQuantity * PokemonItems.getItemSellPriceByName(_sellingItem);
					MessageCenter.addMessage(Message.createQuestionFromArray("I can pay " + Configuration.CURRENCY_SYMBOL + _sellingCost + ".\nWould that be okay?", sellItem, ["YES", "NO"], 23));
				}
				else
				{
					MessageCenter.addMessage(Message.createMessage(item.ITEM_NAME + "?\nHow many would you like to sell?", false, 0, showQuantitySelector, 23, true));
				}
			}
			
			toggleArrow();
		}
		
		private function sellItem(answer:String):void
		{
			toggleArrow();
			if (answer == "NO")
			{
				// Do nothing
				destroyMoneyBox();
			}
			else if (answer == "YES")
			{
				
				Configuration.ACTIVE_TRAINER.giveMoney(_sellingCost);
				for (var i:int = 0; i < _sellingQuantity; i++) Configuration.ACTIVE_TRAINER.consumeItem(_sellingItem);
				drawPocket(Configuration.BAG_CURRENTLY_SELECTED, false, true);
				drawMoneyBox();
				SoundManager.playSoundEffect(SoundEffect.POKEMART_BUY);
				MessageCenter.addMessage(Message.createMessage("Turned over the " + _sellingItem.toUpperCase() + "\nand received " + Configuration.CURRENCY_SYMBOL + _sellingCost + ".", true, 0, closeSell, 23));
			}
		}
		
		private function closeSell():void
		{
			destroyMoneyBox();
		}
		
		private var _quantitySelector:UIDoubleTextBox;
		
		private function showQuantitySelector():void
		{
			drawMoneyBox();
			
			_quantitySelector = new UIDoubleTextBox("", "", 96, 32, 7, 7, 7, 7);
			_quantitySelector.x = 136 * Configuration.SPRITE_SCALE;
			_quantitySelector.y = 80 * Configuration.SPRITE_SCALE;
			this.addChild(_quantitySelector);
			
			selectQuantity(1);
			KeyboardManager.enableInputGroup(InputGroups.POKEMART_SELL_MENU);
		}
		
		private function selectQuantity(num:int):void
		{
			if (num < 1) num = itemObjects[currentlySelectedItem - 1].ITEM_COUNT;
			if (num > itemObjects[currentlySelectedItem - 1].ITEM_COUNT) num = 1;
			
			_sellingQuantity = num;
			
			_sellingCost = _sellingQuantity * PokemonItems.getItemSellPriceByName(_sellingItem);
			_quantitySelector.TEXT_FIELD1.text = "x" + (_sellingQuantity < 10 ? "0" : "") + _sellingQuantity;
			_quantitySelector.TEXT_FIELD2.text = Configuration.CURRENCY_SYMBOL + _sellingCost;
		}
		
		private function destroyQuantitySelector():void
		{
			if (_quantitySelector)
			{
				this.removeChild(_quantitySelector);
				_quantitySelector.destroy();
				_quantitySelector = null;
				if (MessageCenter.WAITING_ON_FINISH_MESSAGE) MessageCenter.finishMessage();
			}
		}
		
		private function pressCancel():void
		{
			SoundManager.playEnterKeySoundEffect();
			if (_quantitySelector)
			{
				toggleArrow();
				destroyMoneyBox();
				destroyQuantitySelector();
				return;
			}
			closeBag();
		}
		
		private function closeBag():void
		{
			unregisterKeys();
			Configuration.FADE_OUT_AND_IN(finishPressCancel);
		}
		
		private function finishPressCancel():void
		{
			// copy the states into the vector of the Configuration
			switch (currentlySelected)
			{
			case 1: 
				state1 = createState();
				break;
			case 2: 
				state2 = createState();
				break;
			case 3: 
				state3 = createState();
				break;
			case 4: 
				state4 = createState();
				break;
			case 5: 
				state5 = createState();
				break;
			}
			Configuration.BAG_CURRENTLY_SELECTED = currentlySelected;
			Configuration.BAG_STATE_VECTOR[0] = state1;
			Configuration.BAG_STATE_VECTOR[1] = state2;
			Configuration.BAG_STATE_VECTOR[2] = state3;
			Configuration.BAG_STATE_VECTOR[3] = state4;
			Configuration.BAG_STATE_VECTOR[4] = state5;
			
			Configuration.createMenu(MenuType.POKEMART, 1, _callback, true, _items);
			_callback = null;
			destroy();
		}
		
		private function pressLeft():void
		{
			if (_quantitySelector) return;
			
			switchLeft();
		}
		
		private function pressRight():void
		{
			if (_quantitySelector) return;
			
			switchRight();
		}
		
		private var backpack:Sprite;
		private var backpack_bmp:Bitmap;
		
		private function drawBackpack(pocketNumber:int):void
		{
			if (!backpack)
			{
				backpack = new Sprite();
				backpack.x = 36 * Configuration.SPRITE_SCALE + 64 * 0.5 * Configuration.SPRITE_SCALE;
				backpack.y = 34 * Configuration.SPRITE_SCALE + 64 * 0.5 * Configuration.SPRITE_SCALE;
				this.addChild(backpack);
			}
			if (backpack_bmp)
			{
				backpack.removeChild(backpack_bmp);
				backpack_bmp = null;
			}
			
			backpack_bmp = getSprite((pocketNumber - 1) * 64, 210 + (TrainerType.isFemale(Configuration.ACTIVE_TRAINER.TYPE) ? 64 : 0), 64, 64);
			backpack_bmp.x = 64 * -0.5 * Configuration.SPRITE_SCALE;
			backpack_bmp.y = 64 * -0.5 * Configuration.SPRITE_SCALE;
			backpack.addChild(backpack_bmp);
			
			TweenLite.to(backpack, 0.05, {y: backpack.y - 2 * Configuration.SPRITE_SCALE, onComplete: finishTweeningBackpack});
		}
		
		private var itemContainer:Sprite;
		private var itemObjects:Vector.<UIBagMenuItem> = new Vector.<UIBagMenuItem>();
		
		private function drawItemList(itemType:String):void
		{
			var i:int;
			destroyItemList();
			
			itemContainer = new Sprite();
			itemListMask = new Sprite();
			itemObjects = new Vector.<UIBagMenuItem>();
			
			itemListMask.graphics.beginFill(0x000000);
			itemListMask.graphics.drawRect(0, 0, 120 * Configuration.SPRITE_SCALE, 128 * Configuration.SPRITE_SCALE);
			itemListMask.graphics.endFill();
			
			var itemList:Vector.<String> = Configuration.ACTIVE_TRAINER.getInventory(itemType);
			var completedList:Vector.<String> = new Vector.<String>();
			for (i = 0; i < itemList.length; i++)
			{
				// ensure this item has not already been listed.
				var found:Boolean = false;
				var j:int;
				for (j = 0; j < completedList.length; j++)
				{
					if (completedList[j] == itemList[i])
					{
						found = true;
						break;
					}
				}
				if (found)
					continue;
				
				completedList.push(itemList[i]);
				
				var count:int = 0;
				for (j = 0; j < itemList.length; j++)
				{
					if (itemList[j] == itemList[i])
						count++;
				}
				
				// Now we have the item and how many of it we have, let's create the listing in the list holder
				var item_name:String = itemList[i];
				if (currentlySelected == 4)
				{
					// These are Berries, add their ID number!
					var id:int = PokemonItems.getBerryIDByName(item_name);
					item_name = "No" + (id < 10 ? "0" : "") + id + " " + item_name.toUpperCase().replace("É", "é");
				}
				else
					item_name = item_name.toUpperCase().replace("É", "é");
				
				var object:UIBagMenuItem = new UIBagMenuItem(item_name, count, itemList[i]);
				object.x = 6 * Configuration.SPRITE_SCALE;
				object.y = itemObjects.length * object.height;
				itemObjects.push(object);
				itemContainer.addChild(object);
			}
			
			var closeObject:UIBagMenuItem = new UIBagMenuItem("CLOSE BAG", 0);
			closeObject.x = 6 * Configuration.SPRITE_SCALE;
			closeObject.y = itemObjects.length * closeObject.height;
			itemObjects.push(closeObject);
			itemContainer.addChild(closeObject);
			
			up_arrow.visible = false;
			down_arrow.visible = true;
			
			if (itemObjects.length <= 8)
			{
				down_arrow.visible = false;
			}
			
			this.addChild(itemContainer);
			itemContainer.x = itemListMask.x = 112 * Configuration.SPRITE_SCALE;
			itemContainer.y = itemListMask.y = 16 * Configuration.SPRITE_SCALE;
			
			this.addChild(itemListMask);
			itemContainer.mask = itemListMask;
			
			currentlySelectedItem = 1;
			arrow.y = 16 * Configuration.SPRITE_SCALE + 3 * Configuration.SPRITE_SCALE;
			
			drawItem(itemObjects[currentlySelectedItem - 1].ITEM_REAL_NAME);
		}
		
		private var state1:UIBagMenuState;
		private var state2:UIBagMenuState;
		private var state3:UIBagMenuState;
		private var state4:UIBagMenuState;
		private var state5:UIBagMenuState;
		
		private function shakeBackpack(addCallback:Boolean = true):void
		{
			if (!backpack)
				return;
			
			if (addCallback)
				TweenLite.to(backpack, 0.03, {rotation: 5, onComplete: midwayShakeBackpack});
			else
				TweenLite.to(backpack, 0.03, {rotation: 0});
		}
		
		private function midwayShakeBackpack():void
		{
			TweenLite.to(backpack, 0.06, {rotation: -5, onComplete: shakeBackpack, onCompleteParams: [false]});
		}
		
		private function finishTweeningBackpack():void
		{
			TweenLite.to(backpack, 0.05, {y: backpack.y + 2 * Configuration.SPRITE_SCALE});
		}
		
		private var item:UIItemSprite;
		private var itemPlaceholder:Bitmap;
		
		private function drawItem(itemType:String = ""):void
		{
			destroyItem();
			
			if (itemType == "" || itemType == "CLOSE BAG")
			{
				itemPlaceholder = getSprite(480, 14, 24, 24);
				itemPlaceholder.x = 8 * Configuration.SPRITE_SCALE;
				itemPlaceholder.y = 72 * Configuration.SPRITE_SCALE;
				this.addChild(itemPlaceholder);
				
				itemDetail.text = "Return to\nthe shop.";
			}
			else
			{
				item = new UIItemSprite(PokemonItems.getItemSpriteNameByName(itemType));
				item.x = 8 * Configuration.SPRITE_SCALE + 24 * 0.5 * Configuration.SPRITE_SCALE;
				item.y = 72 * Configuration.SPRITE_SCALE + 24 * 0.5 * Configuration.SPRITE_SCALE;
				this.addChild(item);
				
				itemDetail.text = PokemonItems.getItemDescriptionByName(itemType);
			}
		}
		
		private var pocketLabel:Bitmap;
		private var blockIcon:Bitmap;
		private var pocketLabelTMP:Bitmap;
		private var pocketLabelTMPMask:Bitmap;
		private var pocketLabelTMPMask2:Bitmap;
		private var currentlySelected:int = -1;
		private var doneAnimating:Boolean = true;
		private var itemListMask:Sprite;
		
		private function switchLeft():void
		{
			if (!doneAnimating)
				return;
			doneAnimating = false;
			
			// get the state
			if (currentlySelected == 1)
				state1 = createState();
			else if (currentlySelected == 2)
				state2 = createState();
			else if (currentlySelected == 3)
				state3 = createState();
			else if (currentlySelected == 4)
				state4 = createState();
			else if (currentlySelected == 5)
				state5 = createState();
			
			currentlySelected--;
			if (currentlySelected <= 0)
				currentlySelected = 5;
			
			SoundManager.playEnterKeySoundEffect();
			
			drawPocket(currentlySelected, true);
		}
		
		private function switchRight():void
		{
			if (!doneAnimating)
				return;
			doneAnimating = false;
			
			// get the state
			if (currentlySelected == 1)
				state1 = createState();
			else if (currentlySelected == 2)
				state2 = createState();
			else if (currentlySelected == 3)
				state3 = createState();
			else if (currentlySelected == 4)
				state4 = createState();
			else if (currentlySelected == 5)
				state5 = createState();
			
			currentlySelected++;
			if (currentlySelected > 5)
				currentlySelected = 1;
			
			SoundManager.playEnterKeySoundEffect();
			
			drawPocket(currentlySelected, false);
		}
		
		private function createState():UIBagMenuState
		{
			return new UIBagMenuState(arrow.y, itemContainer.y, currentlySelectedItem);
		}
		
		private function restoreState(state:UIBagMenuState):void
		{
			if (!state)
				return;
			
			arrow.y = state.ARROW_Y;
			itemContainer.y = state.CONTAINER_Y;
			currentlySelectedItem = state.CURRENTLY_SELECTED;
			
			drawItem(itemObjects[currentlySelectedItem - 1].ITEM_REAL_NAME);
		}
		
		private function drawPocket(pocketNumber:int, left:Boolean = false, fastTween:Boolean = false):void
		{
			currentlySelected = pocketNumber;
			
			if (!blockIcon)
			{
				if (TrainerType.isMale(Configuration.ACTIVE_TRAINER.TYPE))
					blockIcon = getSprite(480, 10, 4, 4);
				else
					blockIcon = getSprite(480 + 4, 10, 4, 4);
				this.addChild(blockIcon);
				blockIcon.y = 27 * Configuration.SPRITE_SCALE;
			}
			switch (currentlySelected)
			{
			case 1: 
				blockIcon.x = 42 * Configuration.SPRITE_SCALE;
				break;
			case 2: 
				blockIcon.x = 50 * Configuration.SPRITE_SCALE;
				break;
			case 3: 
				blockIcon.x = 58 * Configuration.SPRITE_SCALE;
				break;
			case 4: 
				blockIcon.x = 66 * Configuration.SPRITE_SCALE;
				break;
			case 5: 
				blockIcon.x = 74 * Configuration.SPRITE_SCALE;
				break;
			}
			
			drawBackpack(pocketNumber);
			
			if (pocketLabel)
			{
				
				pocketLabelTMP = getPocketLabel(currentlySelected);
				pocketLabelTMP.y = 12 * Configuration.SPRITE_SCALE;
				pocketLabelTMP.x = 26 * Configuration.SPRITE_SCALE;
				pocketLabelTMP.mask = pocketLabelTMPMask;
				pocketLabel.mask = pocketLabelTMPMask2;
				this.addChild(pocketLabelTMP);
				
				if (left)
					pocketLabelTMP.x -= pocketLabelTMP.width;
				else
					pocketLabelTMP.x += pocketLabelTMP.width;
				
				TweenLite.to(pocketLabelTMP, fastTween ? 1 : 0.25, {x: 26 * Configuration.SPRITE_SCALE, onComplete: finishAnimatingLabel, useFrames: fastTween});
				TweenLite.to(pocketLabel, fastTween ? 1 : 0.25, {x: pocketLabel.x + (left ? 1 : -1) * pocketLabel.width, useFrames: fastTween});
				
			}
			else
			{
				pocketLabel = getPocketLabel(currentlySelected);
				pocketLabel.y = 12 * Configuration.SPRITE_SCALE;
				pocketLabel.x = 26 * Configuration.SPRITE_SCALE;
				this.addChild(pocketLabel);
				
				pocketLabelTMPMask = getPocketLabel(currentlySelected);
				pocketLabelTMPMask.x = pocketLabel.x;
				pocketLabelTMPMask.y = pocketLabel.y;
				this.addChild(pocketLabelTMPMask);
				
				pocketLabelTMPMask2 = getPocketLabel(currentlySelected);
				pocketLabelTMPMask2.x = pocketLabel.x;
				pocketLabelTMPMask2.y = pocketLabel.y;
				this.addChild(pocketLabelTMPMask2);
			}
			
			this.setChildIndex(left_arrow, this.numChildren - 1);
			this.setChildIndex(right_arrow, this.numChildren - 1);
			
			drawItem("");
			
			switch (pocketNumber)
			{
			case 1: 
				drawItemList(PokemonItems.TYPE_ITEMS);
				restoreState(state1);
				break;
			case 2: 
				drawItemList(PokemonItems.TYPE_POKEBALLS);
				restoreState(state2);
				break;
			case 3: 
				drawItemList(PokemonItems.TYPE_TMs_and_HMs);
				restoreState(state3);
				break;
			case 4: 
				drawItemList(PokemonItems.TYPE_BERRIES);
				restoreState(state4);
				break;
			case 5: 
				drawItemList(PokemonItems.TYPE_KEY_ITEMS);
				restoreState(state5);
				break;
			}
		}
		
		private var currentlySelectedItem:int = 1;
		
		private function pressUp():void
		{
			if (_quantitySelector)
			{
				SoundManager.playEnterKeySoundEffect();
				selectQuantity(_sellingQuantity + 1);
				return;
			}
			
			if (currentlySelectedItem <= 1)
				return;
			
			currentlySelectedItem--;
			SoundManager.playEnterKeySoundEffect();
			
			if (itemObjects.length > 8)
			{
				if (itemContainer.y < 16 * Configuration.SPRITE_SCALE && arrow.y <= 16 * 4 * Configuration.SPRITE_SCALE + 3 * Configuration.SPRITE_SCALE)
					itemContainer.y += 16 * Configuration.SPRITE_SCALE;
				else
					arrow.y -= 16 * Configuration.SPRITE_SCALE;
				
				updateArrowVisibility();
			}
			else
				arrow.y -= 16 * Configuration.SPRITE_SCALE;
			
			drawItem(itemObjects[currentlySelectedItem - 1].ITEM_REAL_NAME);
			
			shakeBackpack();
		}
		
		private function updateArrowVisibility():void
		{
			if (itemObjects.length > 8)
			{
				if (currentlySelectedItem > 4)
					up_arrow.visible = true;
				else
					up_arrow.visible = false;
				
				if (itemObjects.length - currentlySelectedItem > 4)
					down_arrow.visible = true;
				else
					down_arrow.visible = false;
			}
			else
			{
				up_arrow.visible = down_arrow.visible = false;
			}
		}
		
		private function pressDown():void
		{
			if (_quantitySelector)
			{
				SoundManager.playEnterKeySoundEffect();
				selectQuantity(_sellingQuantity - 1);
				return;
			}
			
			if (currentlySelectedItem >= itemObjects.length)
				return;
			SoundManager.playEnterKeySoundEffect();
			
			currentlySelectedItem++;
			
			if (itemObjects.length > 8)
			{
				if (arrow.y >= 16 * 4 * Configuration.SPRITE_SCALE + 3 * Configuration.SPRITE_SCALE && itemObjects.length - currentlySelectedItem > 3)
					itemContainer.y -= 16 * Configuration.SPRITE_SCALE;
				else
					arrow.y += 16 * Configuration.SPRITE_SCALE;
				
				updateArrowVisibility();
			}
			else
				arrow.y += 16 * Configuration.SPRITE_SCALE;
			
			drawItem(itemObjects[currentlySelectedItem - 1].ITEM_REAL_NAME);
			
			shakeBackpack();
		}
		
		private function finishAnimatingLabel():void
		{
			this.removeChild(pocketLabel);
			pocketLabel = pocketLabelTMP;
			pocketLabelTMP = null;
			doneAnimating = true;
		}
		
		private function getPocketLabel(labelNum:int):Bitmap
		{
			switch (labelNum)
			{
			case 1: 
				return getSprite(0, 160, 76, 10);
				break;
			case 2: 
				return getSprite(0, 160 + 10 * 1, 76, 10);
				break;
			case 3: 
				return getSprite(0, 160 + 10 * 2, 76, 10);
				break;
			case 4: 
				return getSprite(0, 160 + 10 * 3, 76, 10);
				break;
			case 5: 
				return getSprite(0, 160 + 10 * 4, 76, 10);
				break;
			default: 
				throw(new Error("Unknown Pocket label " + labelNum));
				return null;
				break;
			}
		}
		
		private function spinPokeballSpinner(clockwise:Boolean = true):void
		{
			if (pokeball_spinner)
				TweenLite.to(pokeball_spinner, 0.25, {rotation: 180 * (clockwise ? 1 : -1), onComplete: spinPokeballSpinner, onCompleteParams: [false], ease: Linear.easeNone});
		}
		
		private function animateArrows():void
		{
			TweenLite.to(left_arrow, 0.25, {x: left_arrow.x - 4 * Configuration.SPRITE_SCALE, onComplete: finishAnimatingArrows});
			TweenLite.to(right_arrow, 0.25, {x: right_arrow.x + 4 * Configuration.SPRITE_SCALE});
			
			TweenLite.to(up_arrow, 0.25, {y: up_arrow.y - 2 * Configuration.SPRITE_SCALE});
			TweenLite.to(down_arrow, 0.25, {y: down_arrow.y + 2 * Configuration.SPRITE_SCALE});
		}
		
		private function finishAnimatingArrows():void
		{
			TweenLite.to(left_arrow, 0.25, {x: left_arrow.x + 4 * Configuration.SPRITE_SCALE, onComplete: animateArrows});
			TweenLite.to(right_arrow, 0.25, {x: right_arrow.x - 4 * Configuration.SPRITE_SCALE});
			
			TweenLite.to(up_arrow, 0.25, {y: up_arrow.y + 2 * Configuration.SPRITE_SCALE});
			TweenLite.to(down_arrow, 0.25, {y: down_arrow.y - 2 * Configuration.SPRITE_SCALE});
		}
		
		private function unregisterKeys():void
		{
			KeyboardManager.unregisterKey(Configuration.LEFT_KEY, pressLeft);
			KeyboardManager.unregisterKey(Configuration.RIGHT_KEY, pressRight);
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, pressCancel);
			KeyboardManager.unregisterKey(Configuration.UP_KEY, pressUp);
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, pressDown);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, pressEnter);
		}
		
		private function destroyItem():void
		{
			if (item)
			{
				this.removeChild(item);
				item.destroy();
				item = null;
			}
			if (itemPlaceholder)
			{
				this.removeChild(itemPlaceholder);
				itemPlaceholder = null;
			}
		}
		
		private function destroyItemList():void
		{
			var i:int;
			if (itemContainer)
			{
				for (i = 0; i < itemObjects.length; i++)
				{
					itemContainer.removeChild(itemObjects[i]);
					itemObjects[i].destroy();
					itemObjects[i] = null;
				}
				
				itemObjects = null;
				this.removeChild(itemContainer);
				itemContainer = null;
			}
			if (itemListMask)
			{
				this.removeChild(itemListMask);
				itemListMask = null;
			}
		}
		
		override public function destroy():void
		{
			destroyItemList();
			
			this.removeChild(itemDetail);
			itemDetail = null;
			
			this.removeChild(arrow);
			arrow = null;
			
			this.removeChild(background);
			background = null;
			
			pokeball_spinner.removeChild(pokeball_spinner_bmp);
			pokeball_spinner_bmp = null;
			this.removeChild(pokeball_spinner);
			pokeball_spinner = null;
			
			TweenLite.killTweensOf(left_arrow);
			TweenLite.killTweensOf(right_arrow);
			
			this.removeChild(left_arrow);
			this.removeChild(right_arrow);
			this.removeChild(up_arrow);
			this.removeChild(down_arrow);
			left_arrow = right_arrow = up_arrow = down_arrow = null;
			
			if (backpack_bmp)
			{
				if (backpack)
				{
					backpack.removeChild(backpack_bmp);
					backpack_bmp = null;
				}
			}
			if (backpack)
			{
				this.removeChild(backpack);
				backpack = null;
			}
			
			this.removeChild(blockIcon);
			this.removeChild(pocketLabel);
			if (pocketLabelTMP)
			{
				this.removeChild(pocketLabelTMP);
			}
			if (pocketLabelTMPMask)
			{
				this.removeChild(pocketLabelTMPMask);
				this.removeChild(pocketLabelTMPMask2);
			}
			pocketLabelTMP = pocketLabel = blockIcon = pocketLabelTMPMask2 = pocketLabelTMPMask = null;
			
			state1 = state2 = state3 = state4 = state5 = null;
			
			destroyItem();
			
			unregisterKeys();
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
	
	}

}