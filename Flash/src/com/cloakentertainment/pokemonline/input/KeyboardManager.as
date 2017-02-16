package com.cloakentertainment.pokemonline.input 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class KeyboardManager 
	{
		private static var _registeredKeys:Vector.<Array> = new Vector.<Array>();
		private static var _keysDown:Vector.<int> = new Vector.<int>();
		
		private static var INITIALIZED:Boolean = false;
		
		public function KeyboardManager() 
		{
			INITIALIZED = true;
			
			Configuration.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, checkKeyDown);
			Configuration.STAGE.addEventListener(KeyboardEvent.KEY_UP, checkKeyUp);
		}
		
		public static function cleanup():void
		{
			_registeredKeys = new Vector.<Array>();
			_keysDown = new Vector.<int>();
		}
		
		private static function checkKeyDown(e:KeyboardEvent):void
		{
			if (Configuration.uiFadeOut) return;
			
			var keyFound:Boolean = false;
			var i:uint;
			for (i = 0; i < _keysDown.length; i++)
			{
				if (_keysDown[i] == e.keyCode) keyFound = true;
			}
			if (!keyFound) _keysDown.push(e.keyCode);
			
			for (i = 0; i < _registeredKeys.length; i++)
			{
				if (_registeredKeys[i][0] == e.keyCode && _registeredKeys[i][3] == true) 
				{
					if ((_registeredKeys[i][4] == true && keyFound == false) || _registeredKeys[i][4] == false)
					{
						_registeredKeys[i][1]();
					}
				}
			}
		}
		
		public static function isKeyPressed(keyCode:int):Boolean
		{
			if (!INITIALIZED) throw(new Error("KeyboardManager not initialized."));
			for (var i:uint = 0; i < _keysDown.length; i++)
			{
				if (_keysDown[i] == keyCode) return true;
			}
			return false;
		}
		
		private static function checkKeyUp(e:KeyboardEvent):void
		{
			for (var i:uint = 0; i < _keysDown.length; i++)
			{
				if (_keysDown[i] == e.keyCode) _keysDown.splice(i, 1);
			}
		}
		
		public static function registerKey(keyCode:int, callback:Function, inputGroup:String, requireReleaseAndPress:Boolean = false):void
		{
			if (!INITIALIZED) throw(new Error("KeyboardManager not initialized."));
			var array:Array = new Array();
			array[0] = keyCode;
			array[1] = callback;
			array[2] = inputGroup;
			array[3] = true;
			array[4] = requireReleaseAndPress;
			_registeredKeys.push(array);
		}
		
		public static function disableInputGroup(inputGroup:String):void
		{
			for (var i:uint = 0; i < _registeredKeys.length; i++)
			{
				if (_registeredKeys[i][2] == inputGroup) _registeredKeys[i][3] = false;
			}
		}
		
		public static function isInputGroupEnabled(inputGroup:String):Boolean
		{
			for (var i:uint = 0; i < _registeredKeys.length; i++)
			{
				if (_registeredKeys[i][2] == inputGroup) return _registeredKeys[i][3];
			}
			
			return false;
		}
		
		public static function enableInputGroup(inputGroup:String):void
		{
			for (var i:uint = 0; i < _registeredKeys.length; i++)
			{
				if (_registeredKeys[i][2] == inputGroup) _registeredKeys[i][3] = true;
			}
		}
		
		public static function disableAllInputGroupsExcept(inputGroup:String):void
		{
			for (var i:uint = 0; i < _registeredKeys.length; i++)
			{
				if (_registeredKeys[i][2] != inputGroup && _registeredKeys[i][2] != InputGroups.CHAT_MODULE) _registeredKeys[i][3] = false;
				else _registeredKeys[i][3] = true;
			}
		}
		
		public static function enableAllInputGroupsExcept(inputGroup:String):void
		{
			for (var i:uint = 0; i < _registeredKeys.length; i++)
			{
				if (_registeredKeys[i][2] != inputGroup) _registeredKeys[i][3] = true;
				else _registeredKeys[i][3] = false;
			}
		}
		
		public static function unregisterKey(keyCode:int, callback:Function):void
		{
			if (!INITIALIZED) throw(new Error("KeyboardManager not initialized."));
			for (var i:uint = 0; i < _registeredKeys.length; i++)
			{
				if (_registeredKeys[i][0] == keyCode && _registeredKeys[i][1] == callback)
				{
					_registeredKeys.splice(i, 1);
				}
			}
		}
		
	}

}