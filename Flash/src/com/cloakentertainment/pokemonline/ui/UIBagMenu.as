package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.stats.PokemonItems;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.cloakentertainment.pokemonline.ui.Message;
	import com.cloakentertainment.pokemonline.ui.MessageCenter;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBagMenu extends UISprite implements UIElement
	{
		[Embed(source="assets/UIBagMenu.png")]
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
		
		private var selectItemCallback:Function;
		private var SELECTING_ITEM:Boolean = false;
		private var selectingBerry:Boolean = false;
		private var wally:Boolean = false;
		
		public function UIBagMenu(_selectItemCallback:Function = null, specialSelection:String = "")
		{
			super(spriteImage);
			
			selectItemCallback = _selectItemCallback;
			SELECTING_ITEM = selectItemCallback != null ? true : false;
			
			if (specialSelection == "berry") selectingBerry = true;
			else if (specialSelection == "wally") wally = true;
			
			construct();
		}
		
		override public function construct():void
		{
			if (Configuration.BAG_STATE_VECTOR.length != 0 && !wally)
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
			itemDetail.text = "Return to\nthe field.";
			
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
			
			if (selectingBerry) left_arrow.visible = right_arrow.visible = false;
			
			animateArrows();
			
			if (selectingBerry) drawPocket(4);
			else if (wally) drawPocket(1);
			else drawPocket(Configuration.BAG_CURRENTLY_SELECTED);
			
			if (!wally)
			{
				KeyboardManager.registerKey(Configuration.LEFT_KEY, pressLeft, InputGroups.BAG, true);
				KeyboardManager.registerKey(Configuration.RIGHT_KEY, pressRight, InputGroups.BAG, true);
				KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressCancel, InputGroups.BAG, true);
				KeyboardManager.registerKey(Configuration.UP_KEY, pressUp, InputGroups.BAG, false);
				KeyboardManager.registerKey(Configuration.DOWN_KEY, pressDown, InputGroups.BAG, false);
				KeyboardManager.registerKey(Configuration.ENTER_KEY, pressEnter, InputGroups.BAG, true);
			} else
			{
				TweenLite.delayedCall(2, pressRight);
				TweenLite.delayedCall(3, pressEnter);
				TweenLite.delayedCall(4, pressEnter);
			}
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
		
		private var itemSelectionBox:UIBox;
		private var itemSelectionType:int = 1; // 1 for standard 4 option box, 2 for 5 option berry box, 3 for 3 option key item box, 4 for 3 option pokeball box, 5 for the tms and hms
		private var textBoxes:Vector.<TextField>;
		
		private function pressEnter():void
		{
			if (itemSelectionBox)
			{
				chooseItemSelection();
				return;
			}
			
			SoundManager.playEnterKeySoundEffect();
			
			// select the item
			var item:UIBagMenuItem = itemObjects[currentlySelectedItem - 1];
			if (item.ITEM_NAME == "CLOSE BAG")
				closeBag();
			else
			{
				if (selectingBerry)
				{
					selectItemCallback(item.ITEM_REAL_NAME);
					closeBag();
					return;
				}
				
				itemDetail.text = item.ITEM_REAL_NAME.toUpperCase().replace("É", "é") + " is selected.";
				up_arrow.visible = down_arrow.visible = left_arrow.visible = right_arrow.visible = false;
				
				var isBW:int = 128 * Configuration.SPRITE_SCALE;
				var isBH:int = 48 * Configuration.SPRITE_SCALE;
				var isBX:int = Configuration.VIEWPORT.width - isBW;
				var isBY:int = Configuration.VIEWPORT.height - isBH;
				
				textBoxes = new Vector.<TextField>();
				
				if (currentlySelected == 1)
					itemSelectionType = 1;
				else if (currentlySelected == 2)
					itemSelectionType = 4;
				else if (currentlySelected == 3)
					itemSelectionType = 5;
				else if (currentlySelected == 4)
					itemSelectionType = 2;
				else if (currentlySelected == 5)
					itemSelectionType = 3;
				
				var txt1:TextField = new TextField();
				Configuration.setupTextfield(txt1, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
				txt1.width = 56 * Configuration.SPRITE_SCALE;
				txt1.height = 16 * Configuration.SPRITE_SCALE;
				txt1.text = "USE";
				txt1.x = isBX + 12 * Configuration.SPRITE_SCALE;
				txt1.y = isBY + 7 * Configuration.SPRITE_SCALE;
				textBoxes.push(txt1);
				var txt2:TextField = new TextField();
				Configuration.setupTextfield(txt2, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
				txt2.width = 56 * Configuration.SPRITE_SCALE;
				txt2.height = 16 * Configuration.SPRITE_SCALE;
				txt2.text = "TOSS";
				txt2.x = isBX + 12 * Configuration.SPRITE_SCALE;
				txt2.y = isBY + (7 + 16) * Configuration.SPRITE_SCALE;
				textBoxes.push(txt2);
				var txt3:TextField = new TextField();
				Configuration.setupTextfield(txt3, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
				txt3.width = 56 * Configuration.SPRITE_SCALE;
				txt3.height = 16 * Configuration.SPRITE_SCALE;
				txt3.text = "GIVE";
				txt3.x = isBX + (12 + 56) * Configuration.SPRITE_SCALE;
				txt3.y = isBY + 7 * Configuration.SPRITE_SCALE;
				textBoxes.push(txt3);
				var txt4:TextField = new TextField();
				Configuration.setupTextfield(txt4, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
				txt4.width = 56 * Configuration.SPRITE_SCALE;
				txt4.height = 16 * Configuration.SPRITE_SCALE;
				txt4.text = "CANCEL";
				txt4.x = isBX + (12 + 56) * Configuration.SPRITE_SCALE;
				txt4.y = isBY + (7 + 16) * Configuration.SPRITE_SCALE;
				textBoxes.push(txt4);
				var txt5:TextField = new TextField();
				Configuration.setupTextfield(txt5, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
				txt5.width = 56 * Configuration.SPRITE_SCALE;
				txt5.height = 16 * Configuration.SPRITE_SCALE;
				txt5.text = "";
				txt5.x = isBX + 12 * Configuration.SPRITE_SCALE;
				txt5.y = isBY + (7 - 16) * Configuration.SPRITE_SCALE;
				textBoxes.push(txt5);
				
				if (itemSelectionType == 4)
				{
					txt1.text = "GIVE";
					txt3.text = "";
				}
				else if (itemSelectionType == 5)
				{
					txt2.text = "";
				}
				else if (itemSelectionType == 2)
				{
					txt5.text = "CHECK TAG";
				}
				else if (itemSelectionType == 3)
				{
					txt3.text = "REGISTER";
					txt2.text = "";
				}
				
				var uses:Vector.<String> = PokemonItems.retrieveItemUsesForInBattle(item.ITEM_REAL_NAME);
				if (SELECTING_ITEM)
				{
					txt1.text = "";
					txt2.text = "";
					txt3.text = uses[0];
					txt5.text = "";
					txt4.text = "CANCEL";
				}
				
				isBH = txt5.text == "" ? 48 : 64;
				var yDiff:int = 0;
				if (SELECTING_ITEM && uses[0] == "") 
				{
					isBH = 24;
					yDiff = 4 * Configuration.SPRITE_SCALE;
					txt4.y += yDiff;
				}
				itemSelectionBox = new UIBox(SELECTING_ITEM == false ? 128 : 72, isBH);
				itemSelectionBox.x = Configuration.VIEWPORT.width - itemSelectionBox.width;
				itemSelectionBox.y = Configuration.VIEWPORT.height - itemSelectionBox.height;;
				this.addChild(itemSelectionBox);
				
				itemSelectionArrow = getSprite(480, 38, 6, 10);
				itemSelectionArrow.x = itemSelectionBox.x + 12 * Configuration.SPRITE_SCALE - itemSelectionArrow.width;
				itemSelectionArrow.y = itemSelectionBox.y + 11 * Configuration.SPRITE_SCALE - yDiff;
				this.addChild(itemSelectionArrow);
				this.addChild(txt1);
				this.addChild(txt2);
				this.addChild(txt3);
				this.addChild(txt4);
				this.addChild(txt5);
				
				if(SELECTING_ITEM) selectItemOption(2);
			}
			
			toggleArrow();
		}
		private var itemSelectionArrow:Bitmap;
		private var itemSelectionOption:int = 1; // 1 is top left, 2 is top right, 3 is bot left, 4 is bot right, 5 is upper left (Check Tag)
		
		private function chooseItemSelection():void
		{
			var selection:String = "";
			switch (itemSelectionOption)
			{
				case 1: 
					selection = textBoxes[0].text;
					break;
				case 2: 
					selection = textBoxes[2].text;
					break;
				case 3: 
					selection = textBoxes[1].text;
					break;
				case 4: 
					selection = textBoxes[3].text;
					break;
				case 5: 
					selection = textBoxes[4].text;
					break;
			}
			trace("SELECTION: " + selection);
			if (selection == "CANCEL")
			{
				destroyItemSelectionBox();
			}
			else if (selection == "TOSS")
			{
				if (itemObjects[currentlySelectedItem - 1].ITEM_COUNT > 1)
				{
					// ask how many items we want to throw away.
					askForTossCount();
				}
				else
				{
					// ask if we are sure we want to throw away this item!
					confirmToss();
				}
			} else if (selection == "USE" && SELECTING_ITEM)
			{
				unregisterKeys();
				SoundManager.playEnterKeySoundEffect();
				destroyItemSelectionBox();
				Configuration.FADE_OUT_AND_IN(useItem, false, -1, [itemObjects[currentlySelectedItem - 1].ITEM_REAL_NAME]);
			}
			else
			{
				KeyboardManager.disableInputGroup(InputGroups.BAG);
				MessageCenter.addMessage(Message.createMessage("DAD's advice...\n" + Configuration.ACTIVE_TRAINER.NAME + ", there's a time and place for everything!", true, 0, returnFromFailure));
			}
		}
		
		private function useItem(itemName:String):void
		{
			if (selectItemCallback != null) selectItemCallback(itemName);
			selectItemCallback = null;
			destroy();
		}
		
		private var tossCountBox:UIBox;
		private var tossCountText:TextField;
		
		private function askForTossCount():void
		{
			itemDetail.text = "Toss out how many " + itemObjects[currentlySelectedItem - 1].ITEM_NAME + "(s)?";
			destroyItemSelectionBox();
			
			tossCountBox = new UIBox(56, 32);
			tossCountBox.x = Configuration.VIEWPORT.width - tossCountBox.width;
			tossCountBox.y = Configuration.VIEWPORT.height - tossCountBox.height;
			this.addChild(tossCountBox);
			
			tossCountText = new TextField();
			Configuration.setupTextfield(tossCountText, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
			tossCountText.width = 40 * Configuration.SPRITE_SCALE;
			tossCountText.x = tossCountBox.x + 1 * Configuration.SPRITE_SCALE;
			tossCountText.y = tossCountBox.y + 10 * Configuration.SPRITE_SCALE;
			tossCountText.text = "x01";
			this.addChild(tossCountText);
		}
		
		private function setTossNumber(num:int = 1):void
		{
			
			tossCountText.text = "x" + (num < 10 ? "0" : "") + num;
		}
		
		private var itemTossNumber:int = 1;
		
		private function destroyTossCountBox():void
		{
			this.removeChild(tossCountBox);
			tossCountBox.destroy();
			tossCountBox = null;
			
			this.removeChild(tossCountText);
			tossCountText = null;
		}
		
		private function returnFromFailure():void
		{
			destroyItemSelectionBox();
			TweenLite.delayedCall(30, KeyboardManager.enableInputGroup, [InputGroups.BAG], true);
		}
		
		private function confirmToss():void
		{
			destroyTossCountBox();
			itemDetail.text = "Is it okay to throw away " + itemTossNumber + " " + itemObjects[currentlySelectedItem - 1].ITEM_NAME + "(s)?";
		
		}
		
		private function destroyItemSelectionBox():void
		{
			itemSelectionOption = 1;
			
			toggleArrow();
			this.removeChild(itemSelectionArrow);
			itemSelectionArrow = null;
			this.removeChild(itemSelectionBox);
			itemSelectionBox.destroy();
			itemSelectionBox = null;
			left_arrow.visible = right_arrow.visible = true;
			updateArrowVisibility();
			
			for (var i:int = 0; i < textBoxes.length; i++)
			{
				this.removeChild(textBoxes[i]);
				textBoxes[i] = null;
			}
			textBoxes.splice(0, textBoxes.length);
			textBoxes = null;
		}
		
		private function selectItemOption(option:int):void
		{
			switch (option)
			{
				case 1: 
					if (textBoxes[0].text == "")
						return;
					SoundManager.playEnterKeySoundEffect();
					itemSelectionArrow.x = itemSelectionBox.x + 12 * Configuration.SPRITE_SCALE - itemSelectionArrow.width;
					itemSelectionArrow.y = itemSelectionBox.y + 11 * Configuration.SPRITE_SCALE;
					break;
				case 2: 
					if (textBoxes[2].text == "")
						return;
					SoundManager.playEnterKeySoundEffect();
					itemSelectionArrow.x = itemSelectionBox.x + (12 + (SELECTING_ITEM == false ? 56 : 0)) * Configuration.SPRITE_SCALE - itemSelectionArrow.width;
					itemSelectionArrow.y = itemSelectionBox.y + 11 * Configuration.SPRITE_SCALE;
					break;
				case 3: 
					if (textBoxes[1].text == "")
						return;
					SoundManager.playEnterKeySoundEffect();
					itemSelectionArrow.x = itemSelectionBox.x + 12 * Configuration.SPRITE_SCALE - itemSelectionArrow.width;
					itemSelectionArrow.y = itemSelectionBox.y + (11 + 16) * Configuration.SPRITE_SCALE;
					break;
				case 4: 
					if (textBoxes[3].text == "")
						return;
					SoundManager.playEnterKeySoundEffect();
					itemSelectionArrow.x = itemSelectionBox.x + (12 + (SELECTING_ITEM == false ? 56 : 0)) * Configuration.SPRITE_SCALE - itemSelectionArrow.width;
					itemSelectionArrow.y = itemSelectionBox.y + (11 + 16) * Configuration.SPRITE_SCALE;
					break;
				case 5: 
					if (textBoxes[4].text == "")
						return;
					SoundManager.playEnterKeySoundEffect();
					itemSelectionArrow.x = itemSelectionBox.x + 12 * Configuration.SPRITE_SCALE - itemSelectionArrow.width;
					itemSelectionArrow.y = itemSelectionBox.y + (11 - 16) * Configuration.SPRITE_SCALE;
					break;
			}
			itemSelectionOption = option;
		}
		
		private function pressCancel():void
		{
			SoundManager.playEnterKeySoundEffect();
			if (itemSelectionBox)
			{
				destroyItemSelectionBox();
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
			
			destroy();
			if (selectItemCallback != null)
			{
				selectItemCallback(null);
				selectItemCallback = null;
			} else Configuration.createMenu(MenuType.IN_GAME_MENU);
		}
		
		private function pressLeft():void
		{
			if (itemSelectionBox)
			{
				if (itemSelectionOption == 2 || itemSelectionOption == 4)
				{
					selectItemOption(itemSelectionOption == 2 ? 1 : 3);
				}
				return;
			}
			switchLeft();
		}
		
		private function pressRight():void
		{
			if (itemSelectionBox)
			{
				if (itemSelectionOption == 1 || itemSelectionOption == 3)
				{
					selectItemOption(itemSelectionOption == 1 ? 2 : 4);
				}
				return;
			}
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
			if (wally) 
			{
				if (itemType == PokemonItems.TYPE_POKEBALLS) itemList = new < String > ["Poké Ball"];
				else itemList = new Vector.<String>();
			}
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
				
				itemDetail.text = "Return to\nthe field.";
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
		private var currentlySelected:int = 1;
		private var doneAnimating:Boolean = true;
		private var itemListMask:Sprite;
		
		private function switchLeft():void
		{
			if (selectingBerry) return;
			
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
			if (selectingBerry) return;
			
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
		
		private function drawPocket(pocketNumber:int, left:Boolean = false):void
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
				
				TweenLite.to(pocketLabelTMP, 0.25, {x: 26 * Configuration.SPRITE_SCALE, onComplete: finishAnimatingLabel});
				TweenLite.to(pocketLabel, 0.25, {x: pocketLabel.x + (left ? 1 : -1) * pocketLabel.width});
				
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
			if (itemSelectionBox)
			{
				if (itemSelectionOption == 1)
					selectItemOption(5);
				else if (itemSelectionOption == 3)
					selectItemOption(1);
				else if (itemSelectionOption == 4)
					selectItemOption(2);
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
			if (itemSelectionBox)
			{
				if (itemSelectionOption == 5)
					selectItemOption(1);
				else if (itemSelectionOption == 1)
					selectItemOption(3);
				else if (itemSelectionOption == 2)
					selectItemOption(4);
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