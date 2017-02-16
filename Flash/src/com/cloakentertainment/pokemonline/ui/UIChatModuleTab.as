package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.multiplayer.ChatModule;
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIChatModuleTab extends Sprite
	{
		
		private var _label:String;
		private var _tf:TextField;
		private var _expanded:Boolean = true;
		private var _unreadMessages:int = 0;
		
		private var selected:Boolean = false;
		
		public var chatHistory:String = "";
		
		public function UIChatModuleTab(label:String, defaultChatHistory:String = "")
		{
			super();
			
			_label = label;
			if(defaultChatHistory != "") chatHistory = "<font color='#C3FF68'>" + defaultChatHistory + "</font>";
			
			
			construct();
		}
		
		public function construct():void
		{
			deselect();
			
			_tf = new TextField();
			Configuration.setupTextfield(_tf, ChatModule.TEXT_FORMAT_CENTERED, ChatModule.TEXT_FILTER);
			_tf.width = 80;
			_tf.height = 24;
			updateTextField();
			this.addChild(_tf);
			_tf.mouseEnabled = false;
		}
		
		private function drawBackground(color:uint):void
		{
			this.graphics.clear();
			this.graphics.beginFill(color, 1);
			this.graphics.drawRect(0, 0, 80, 24);
			this.graphics.beginFill(0x325795, 1);
			this.graphics.drawRect(0, 24, 80, 3);
			this.graphics.endFill();
		}
		
		public function select():void
		{
			drawBackground(0x325795);
			selected = true;
			this.buttonMode = false;
			
			resetUnreadMessageCounter();
		}
		
		public function deselect():void
		{
			drawBackground(0x527DC5);
			selected = false;
			this.buttonMode = true;
		}
		
		public function minify():void
		{
			if (!_expanded) return;
			
			TweenLite.to(this, 0.25, { width:60 } );
		}
		
		public function expand():void
		{
			if (_expanded) return;
			TweenLite.to(this, 0.25, { width:80 } );
		}
		
		private function updateTextField():void
		{
			_tf.text = _label + (_unreadMessages != 0 ? " (" + _unreadMessages + ")" : "");
		}
		
		public function addToUnreadMessageCounter(num:int = 1):void
		{
			if (selected) return;
			_unreadMessages += num;
			updateTextField();
		}
		
		public function resetUnreadMessageCounter():void
		{
			_unreadMessages = 0;
			updateTextField();
		}
	
	}

}