package com.cloakentertainment.pokemonline.multiplayer
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.ui.UIBox;
	import com.cloakentertainment.pokemonline.ui.UIChatModuleTab;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	import com.cloakentertainment.pokemonline.multiplayer.ChatStyle;
	import com.cloakentertainment.pokemonline.GameManager;
	import com.cloakentertainment.pokemonline.multiplayer.ChatScope;
	import playerio.Message;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class ChatModule extends Sprite
	{
		public static const TEXT_FORMAT:TextFormat = new TextFormat("PokemonFont", 20, 0xFFFFFF, null, null, null, null, null, null, null, null, null, 5);
		public static const TEXT_FORMAT_CENTERED:TextFormat = new TextFormat("PokemonFont", 20, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER, null, null, null, 5);
		public static const TEXT_FILTER:DropShadowFilter = new DropShadowFilter(1, 45, 0x414141, 1, 3, 3, 255.0, 1, false, false, false);
		
		private var textField:TextField;
		private var inputTextField:TextField;
		private var _waiting:TextField;
		
		private var _uiBoxInputText:UIBox;
		private var _uiBoxInputButton:UIBox;
		public var _tab_world:UIChatModuleTab;
		private var _tab_region:UIChatModuleTab;
		private var _tab_local:UIChatModuleTab;
		
		private var _belowTextBox:Sprite;
		private var _belowInputTextBox:Sprite;
		private var _scrollHandle:Sprite;
		
		private var _selectedTab:int = 1;
		
		public function ChatModule()
		{
			this.graphics.beginFill(0xe0e8e8, 1);
			this.graphics.drawRect(0, 0, 240, 480);
			this.graphics.endFill();
			this.mouseEnabled = true;
			this.x = 720;
			// Create the "waiting for login" page
			_waiting = new TextField();
			_waiting.embedFonts = true;
			_waiting.defaultTextFormat = TEXT_FORMAT_CENTERED;
			_waiting.filters = [TEXT_FILTER];
			_waiting.textColor = 0xFFFFFF;
			_waiting.width = 240;
			_waiting.height = 20 * 3 * Configuration.SPRITE_SCALE;
			_waiting.text = "Waiting for Player to Log In...";
			_waiting.selectable = false;
			_waiting.mouseEnabled = false;
			_waiting.y = Configuration.VIEWPORT.height / 2 - _waiting.height / 6;
			
			this.addChild(_waiting);
		}
		
		public function connecting():void
		{
			_waiting.text = "Connecting to Server...";
		}
		
		private var _countdownUntilRetry:int = 0;
		private var _connectionAttempts:int = 0;
		
		public function connectionFailed():void
		{
			if (!_waiting) return;
			
			_connectionAttempts++;
			_countdownUntilRetry = _connectionAttempts * 10;
			decrementRetryCountdown();
		}
		
		private function decrementRetryCountdown():void
		{
			TweenLite.killDelayedCallsTo(decrementRetryCountdown);
			if (_countdownUntilRetry <= 0) MultiplayerManager.connect(GameManager.connectedToPlayerIO);
			else
			{
				_countdownUntilRetry--;
				_waiting.text = "Connection Failed...\n\nRetrying in " + _countdownUntilRetry + " seconds";
				
				TweenLite.delayedCall(1, decrementRetryCountdown);
			}
		}
		
		public function construct():void
		{
			if (_waiting)
			{
				this.removeChild(_waiting);
				_waiting = null;
			}
			
			_connectionAttempts = 0;
			
			Configuration.fixFPSCounter();
			
			_belowTextBox = new Sprite();
			_belowTextBox.graphics.beginFill(0x8aace1, 1);
			_belowTextBox.graphics.lineStyle(3, 0x7e8086, 1, true);
			_belowTextBox.graphics.drawRoundRect(0, 0, 240 - 8, 410, 3, 3);
			_belowTextBox.graphics.endFill();
			_belowTextBox.y = 25 + 3 * 2;
			_belowTextBox.x = 3;
			this.addChild(_belowTextBox);
			
			_belowInputTextBox = new Sprite();
			_belowInputTextBox.graphics.beginFill(0x8aace1, 1);
			_belowInputTextBox.graphics.lineStyle(3, 0x7e8086, 1, true);
			_belowInputTextBox.graphics.drawRoundRect(0, 0, 240 - 8 - 32, 28, 3, 3);
			_belowInputTextBox.graphics.endFill();
			_belowInputTextBox.y = Configuration.VIEWPORT.height - _belowInputTextBox.height - 2;
			_belowInputTextBox.x = 3;
			this.addChild(_belowInputTextBox);
			
			textField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = TEXT_FORMAT;
			textField.filters = [TEXT_FILTER];
			textField.textColor = 0xFFFFFF;
			textField.width = 240 - 8 - 8;
			textField.height = 410;
			textField.multiline = true;
			textField.wordWrap = true;
			textField.text = "";
			textField.selectable = false;
			textField.y = 25 + 3 * 2 + 2;
			textField.x = 3 + 4;
			textField.mouseEnabled = false;
			this.addChild(textField);
			
			inputTextField = new TextField();
			inputTextField.embedFonts = true;
			inputTextField.defaultTextFormat = TEXT_FORMAT;
			inputTextField.filters = [TEXT_FILTER];
			inputTextField.width = 240 - 40;
			inputTextField.height = 24;
			inputTextField.type = TextFieldType.INPUT;
			inputTextField.x = 3 + 4;
			inputTextField.y = Configuration.VIEWPORT.height - inputTextField.height - 6;
			inputTextField.text = "Enter a message here...";
			inputTextField.maxChars = 128;
			inputTextField.addEventListener(FocusEvent.FOCUS_IN, onFocusInput);
			inputTextField.addEventListener(FocusEvent.FOCUS_OUT, onUnfocusInput);
			this.addChild(inputTextField);
			KeyboardManager.registerKey(13, checkSendMessage, InputGroups.CHAT_MODULE, true);
			
			_scrollHandle = new Sprite();
			_scrollHandle.graphics.beginFill(0x414141, 1);
			_scrollHandle.graphics.drawRoundRect(0, 0, 8, 80, 8, 8);
			_scrollHandle.graphics.endFill();
			_scrollHandle.x = _belowTextBox.x + _belowTextBox.width - (3 * _scrollHandle.width / 4) - 1;
			_scrollHandle.y = baseScrollY = _belowTextBox.y;
			_scrollHandle.buttonMode = true;
			this.addChild(_scrollHandle);
			
			_tab_world = new UIChatModuleTab("World", "The 'World' tab is a global channel - all other users can hear you!");
			_tab_region = new UIChatModuleTab("Region", "The 'Region' tab is confined to your particular route, town, or city. Only those in the same region can hear you.");
			_tab_local = new UIChatModuleTab("Local", "The 'Local' tab is localized to your immediate vicinity. Only those in a 25 metre radius can hear you.");
			
			_tab_world.x = (1 - 1) * _tab_world.width;
			_tab_region.x = (2 - 1) * _tab_world.width;
			_tab_local.x = (3 - 1) * _tab_world.width;
			
			this.addChild(_tab_world);
			this.addChild(_tab_region);
			this.addChild(_tab_local);
			
			_tab_world.addEventListener(MouseEvent.CLICK, clickTab);
			_tab_region.addEventListener(MouseEvent.CLICK, clickTab);
			_tab_local.addEventListener(MouseEvent.CLICK, clickTab);
			
			_scrollHandle.addEventListener(MouseEvent.MOUSE_DOWN, startScroll);
			//function to start scroll on mouse_down for the handle
			Configuration.STAGE.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			
			selectTab(1);
		}
		
		public function handleChatMessage(m:Message, scope:String, style:String, user:String, message:String):void
		{
			addChatMessage(user, message, style, scope);
		}
		
		public function handleChatShout(m:Message, style:String, user:String, message:String):void
		{
			addChatMessage("&lt;" + user + "&gt;", message, style, getCurrentScope(), false);
		}
		
		private function getCurrentScope():String
		{
			var scope:String;
			switch (_selectedTab)
			{
			case 1: 
				scope = ChatScope.WORLD;
				break;
			case 2: 
				scope = ChatScope.REGION;
				break;
			case 3: 
				scope = ChatScope.LOCAL;
				break;
			}
			return scope;
		}
		
		private var focussed:Boolean = false;
		
		private function onFocusInput(e:FocusEvent):void
		{
			if (!focussed && inputTextField.text == "Enter a message here...")
				inputTextField.text = "";
			focussed = true;
		}
		
		private function onUnfocusInput(e:FocusEvent):void
		{
			if (focussed && inputTextField.text == "")
				inputTextField.text = "Enter a message here...";
			focussed = false;
		}
		
		private function checkSendMessage():void
		{
			if (!focussed || inputTextField.text == "")
				return;
			
			//trace("SEND MESSAGE: " + inputTextField.text);
			var scope:String = getCurrentScope();
			//addChatMessage(Configuration.ACTIVE_TRAINER.NAME, inputTextField.text, ChatStyle.REGULAR, scope);
			
			// Check for commands
			var message:String = inputTextField.text;
			inputTextField.text = "";
			if (message.substr(0, 1) == "/")
			{
				var commandData:Array = message.substr(1, int.MAX_VALUE).split(" ");
				var keyword:String = commandData[0];
				if (keyword == "help")
				{
					// Output a list of commands
					addChatMessage("SYSTEM", "Command Help:\n" + "/connect [id] - Connect to a Room ([id] optional)\n" + "/disconnect - Disconnects from the Room\n" + "/users - Get a list of all users in the current tab and Room\n" + "/roomid - Get the current Room ID\n", ChatStyle.SYSTEM, scope);
				}
				else if (keyword == "connect")
				{
					if (commandData.length <= 1 || commandData[1] == "")
					{
						addChatMessage("SYSTEM", "Finding a populated Room...", ChatStyle.SYSTEM, scope);
						// Find a room for us
						MultiplayerManager.disconnectFromRoom(false);
						MultiplayerManager.findPopulatedRoom();
						return;
					} else
					{
						var roomID:String = commandData[1];
						addChatMessage("SYSTEM", "Reconnecting to Room " + roomID + "...", ChatStyle.SYSTEM, scope);
						MultiplayerManager.disconnectFromRoom(false);
						MultiplayerManager.connectToRoom(roomID, roomSwitched);
					}
				} else if (keyword == "disconnect")
				{
					MultiplayerManager.disconnectFromRoom(false);
				}
				else if (keyword == "users")
				{
					MultiplayerManager.CONNECTION.send("RequestListOfPlayers", scope);
				}
				else if (keyword == "roomid")
				{
					addChatMessage("SYSTEM", "Current Room ID: " + MultiplayerManager.ROOM_ID + ".", ChatStyle.SYSTEM, scope);
				}
				else if (keyword == "shout")
				{
					MultiplayerManager.CONNECTION.send("ChatShout", message.substr(7, int.MAX_VALUE));
				}
				
				// Don't transmit the command to the server
				return;
			}
			
			if (MultiplayerManager.CONNECTED == false) addChatMessage("SYSTEM", "You are not connected to the server.\nType /connect to go online.", ChatStyle.SYSTEM, scope);
			
			var m:Message = new Message("ChatMessage", scope, message);
			MultiplayerManager.CONNECTION.sendMessage(m);
		
		}
		
		public function roomSwitched():void
		{
			addChatMessage("SYSTEM", "Reconnected successfully.", ChatStyle.SYSTEM, getCurrentScope());
		}
		
		private var yOffset:Number;
		
		private function startScroll(e:MouseEvent):void
		{
			Configuration.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, handleMove);
			//now an event listener within the event listener for starting the startscroll. Within this, we define the 
			//function that actually moves the handle along with the mouse.
			yOffset = e.stageY - _scrollHandle.y;
			//here we calculate the offset variable we made earlier. It is the Y of the mouse - the Y of the handle so the
			//handle doesn't snap to the position of where you click with the mouse.
			e.updateAfterEvent();
			//this is very important! we don't want to rely on the frame rate of the document to refresh our scrolling
			//using updateAfterEvent makes it refresh every instance it is moved, making it run very smooth.
			//close startScroll function
		}
		
		private function handleMove(e:MouseEvent):void
		{
			var yMin:Number = baseScrollY;
			//in this variable, we set the minimum constraint for the handle. the 0 of the parent movie clip.
			var yMax:Number = _belowTextBox.height - _scrollHandle.height + baseScrollY;
			//in this variable, we set the max of the handle scroll down Y position. This is within this function so it 
			//can be set after the new height of the handle is set in the previous function. So the constraint changes
			//based on the changing height of the handle.
			textField.scrollV = (((_scrollHandle.y - yMin) / yMax) * textField.maxScrollV);
			//this scrolls the text
			_scrollHandle.y = e.stageY - yOffset;
			//Here, when scrolling is activated, and handle move...we then set the handle Y to the mouse Y - the
			//Y offset we made earlier to prevent snapping.
			if (_scrollHandle.y <= yMin)
				_scrollHandle.y = yMin;
			if (_scrollHandle.y >= yMax)
				_scrollHandle.y = yMax;
			// these if statements enforce our constraints.
			e.updateAfterEvent();
			//once again, very important. This makes the scrolling run smooth, and the text scrolling.
			// end handlemove
		}
		
		private function stopScroll(e:MouseEvent):void
		{
			Configuration.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, handleMove);
		}
		
		private function clickTab(e:MouseEvent):void
		{
			if (e.currentTarget == _tab_world)
				selectTab(1);
			if (e.currentTarget == _tab_region)
				selectTab(2);
			if (e.currentTarget == _tab_local)
				selectTab(3);
		}
		
		public function selectTab(num:int):void
		{
			_selectedTab = num;
			
			_tab_world.deselect();
			_tab_region.deselect();
			_tab_local.deselect();
			
			switch (_selectedTab)
			{
			case 1: 
				_tab_world.select();
				textField.htmlText = _tab_world.chatHistory;
				break;
			case 2: 
				_tab_region.select();
				textField.htmlText = _tab_region.chatHistory;
				break;
			case 3: 
				_tab_local.select();
				textField.htmlText = _tab_local.chatHistory;
				break;
			case 4:
				
				break;
			}
			
			checkScrollBarVisibility();
			checkScrollBarHeight();
			scrollToBottom();
		}
		
		private var baseScrollY:int = 0;
		
		public function destroy():void
		{
		
		}
		
		private function stateMessage(string:String, scope:String):void
		{
			var scopeMatch:Boolean = false;
			var firstMessageStated:Boolean = false;
			
			if (scope == ChatScope.WORLD && _selectedTab == 1)
				scopeMatch = true;
			if (scope == ChatScope.REGION && _selectedTab == 2)
				scopeMatch = true;
			if (scope == ChatScope.LOCAL && _selectedTab == 3)
				scopeMatch = true;
			
			switch (scope)
			{
			case ChatScope.WORLD: 
				_tab_world.addToUnreadMessageCounter();
				if (_tab_world.chatHistory == "")
					_tab_world.chatHistory = string;
				else
					_tab_world.chatHistory += "\n" + string;
				break;
			case ChatScope.REGION: 
				_tab_region.addToUnreadMessageCounter();
				if (_tab_region.chatHistory == "")
					_tab_region.chatHistory = string;
				else
					_tab_region.chatHistory += "\n" + string;
				break;
			case ChatScope.LOCAL: 
				_tab_local.addToUnreadMessageCounter();
				if (_tab_local.chatHistory == "")
					_tab_local.chatHistory = string;
				else
					_tab_local.chatHistory += "\n" + string;
				break;
			}
			
			if (_selectedTab == 1)
				textField.htmlText = _tab_world.chatHistory;
			if (_selectedTab == 2)
				textField.htmlText = _tab_region.chatHistory;
			if (_selectedTab == 3)
				textField.htmlText = _tab_local.chatHistory;
			
			checkScrollBarVisibility();
			checkScrollBarHeight();
			if (scopeMatch)
				scrollToBottom();
		}
		
		private function scrollToBottom():void
		{
			_scrollHandle.y = baseScrollY + _belowTextBox.height - _scrollHandle.height;
			textField.scrollV = textField.maxScrollV;
		}
		
		private function checkScrollBarVisibility():void
		{
			if (textField.scrollV > 0)
			{
				_scrollHandle.y = baseScrollY;
				textField.scrollV = 0;
			}
			if (textField.maxScrollV < 2)
			{
				_scrollHandle.visible = false;
			}
			else
			{
				_scrollHandle.visible = true;
			}
		}
		
		private function checkScrollBarHeight():void
		{
			var pc:Number = _belowTextBox.height / textField.maxScrollV;
			//get the ratio of the track to the max scroll of the textbox.
			_scrollHandle.height = pc + 40;
		}
		
		public function regionSwitched(regionName:String):void
		{
			if (_tab_region) addChatMessage("SYSTEM", "Moved into " + regionName + ".", ChatStyle.SYSTEM, ChatScope.REGION);
		}
		
		public function addChatMessage(user:String, message:String, userStyle:String = "", scope:String = "", addColon:Boolean = true):void
		{
			if (userStyle == "") userStyle = ChatStyle.REGULAR;
			if (scope == "") scope = ChatScope.WORLD;
			var color:String = "F4FCE8";
			switch (userStyle)
			{
			case ChatStyle.MODERATOR: 
				color = "87D69B";
				break;
			case ChatStyle.ADMINISTRATOR: 
				color = "4E9689";
				break;
			case ChatStyle.SYSTEM: 
				color = "7ED0D6";
				stateMessage("<font color='#" + color + "'>&lt;" + user + "&gt; " + message + "</font>", scope);
				return;
				break;
			}
			
			stateMessage('<font color="#' + color + '">' + user + "</font>" + (addColon ? ": " : " ") + message, scope);
		}
	
	}

}