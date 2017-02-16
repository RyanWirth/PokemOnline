package com.cloakentertainment.pokemonline.ui 
{
	import com.cloakentertainment.pokemonline.Configuration;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class Message 
	{
		
		private var _type:String = "";
		private var _text:String = "";
		private var _options:Vector.<String>;
		private var _skippable:Boolean;
		private var _delayAfter:int;
		private var _initialPointer:int = 0;
		private var _callback:Function;
		private var _uiOverride:int;
		private var _doNotDismissAutomatically:Boolean;
		private var _callbackParams:Array;
		
		public function Message(type:String, text:String, options:Vector.<String> = null, skippable:Boolean = false, delayAfter:int = 0, initialPointer:int = 0, callback:Function = null, uiOverride:int = -1, doNotDismissAutomatically:Boolean = false, callbackParams:Array = null) 
		{
			_type = type;
			_text = text;
			_options = options;
			_skippable = skippable;
			_delayAfter = delayAfter;
			_initialPointer = initialPointer;
			_callback = callback;
			_uiOverride = uiOverride;
			_doNotDismissAutomatically = doNotDismissAutomatically;
			_callbackParams = callbackParams;
			
			_text = _text.replace("%PLAYER%", Configuration.ACTIVE_TRAINER.NAME);
		}
		
		public function get CALLBACK():Function
		{
			return _callback;
		}
		
		public function get CALLBACK_PARAMS():Array
		{
			return _callbackParams;
		}
		
		public function get DO_NOT_DISMISS_AUTOMATICALLY():Boolean
		{
			return _doNotDismissAutomatically;
		}
		
		public function get UI_OVERRIDE():int
		{
			return _uiOverride;
		}
		
		public function get INITIAL_POINTER():int
		{
			return _initialPointer;
		}
		
		public function get INITIAL_TEXT():String
		{
			return _text.substr(0, INITIAL_POINTER);
		}
		
		public function set changeText(text:String):void
		{
			_text = text;
		}
		
		public function nullCallback():void
		{
			_callback = null;
			_callbackParams = null;
		}
		
		public function get OPTIONS():Vector.<String>
		{
			return _options;
		}
		
		public function get SKIPPABLE():Boolean
		{
			return _skippable;
		}
		
		public function get DELAY_AFTER():int
		{
			return _delayAfter;
		}
		
		public function get TEXT():String
		{
			return _text;
		}
		
		public function get TYPE():String
		{
			return _type;
		}
		
		public static function createMessage(text:String, skippable:Boolean, delayAfter:int = 0, callback:Function = null, uiOverride:int = -1, waitForDismiss:Boolean = false, callbackParams:Array = null):Message
		{
			return new Message(MessageType.TEXT, Configuration.replaceStringTags(text), null, skippable, delayAfter, 0, callback, uiOverride, waitForDismiss, callbackParams);
		}
		
		public static function createQuestion(text:String, callback:Function, ...options):Message
		{
			var optionsVec:Vector.<String> = new Vector.<String>();
			for (var i:uint = 0; i < options.length; i++)
			{
				if (typeof(options[i]) != "string") continue;
				optionsVec.push(Configuration.replaceStringTags(options[i]));
			}
			return new Message(MessageType.QUESTION, Configuration.replaceStringTags(text), optionsVec, false, 0, 0, callback);
		}
		
		public static function createQuestionFromArray(text:String, callback:Function, options:Array, uiOverride:int = -1):Message
		{
			var optionsVec:Vector.<String> = new Vector.<String>();
			for (var i:uint = 0; i < options.length; i++)
			{
				if (typeof(options[i]) != "string") continue;
				optionsVec.push(Configuration.replaceStringTags(options[i]));
			}
			return new Message(MessageType.QUESTION, Configuration.replaceStringTags(text), optionsVec, false, 0, 0, callback, uiOverride);
		}
		
	}

}