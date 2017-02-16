package com.cloakentertainment.pokemonline.multiplayer
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.StatManager;
	import com.cloakentertainment.pokemonline.trainer.Trainer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import com.cloakentertainment.pokemonline.ui.Message;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.ui.MessageCenter;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class AccountManager
	{
		private static var _authenticated:Boolean = false;
		private static var _authenticationCallback:Function;
		private static var _createAccountCallback:Function;
		private static var _saveTrainerCallback:Function;
		private static var _retrieveAccountCallback:Function;
		
		private static var _retrievingAccount:Boolean = false;
		
		public function AccountManager()
		{
		
		}
		
		public static function retrieveMOTDs():void
		{
			var url:String = Configuration.WEB_ASSETS_URL + "motd.txt?d=" + (new Date().getTime());
			var request:URLRequest = new URLRequest(url);
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, retrieveMOTDsevent, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEvent, false, 0, true);
			urlLoader.load(request);
		}
		
		private static function retrieveMOTDsevent(e:Event):void
		{
			var data:String = clearDelimeters(String(e.currentTarget.data));
			var messages:Vector.<String> = new Vector.<String>();
			var dataArr:Array = data.split(";");
			for (var i:int = 0; i < dataArr.length; i++)
			{
				if (dataArr[i] == null || dataArr[i] == undefined || dataArr[i] == "undefined" || dataArr[i] == "") continue;
				var messageData:Array = String(dataArr[i]).split("//");
				var identifier:String = String(messageData[0]);
				var message:String = String(messageData[1]) + (messageData.length > 2 ? "//" + String(messageData[2]) : "");
				if (identifier == "MESSAGE") messages.push(message);
				else if (identifier.substr(0, 12) == "IFVERSIONNOT")
				{
					var version:String = identifier.substr(13, int.MAX_VALUE);
					if (version != Configuration.VERSION) messages.push(message);
				}
			}
			
			Configuration.MAIN_MENU_MOTDs = messages;
		}
		
		public static function clearDelimeters(formattedString:String):String
		{
			return formattedString.replace(/[\u000d\u000a\u0008]+/g, "");
		}
		
		public static function get RETRIEVING_ACCOUNT():Boolean
		{
			return _retrievingAccount;
		}
		
		public static function get AUTHENTICATED():Boolean
		{
			return _authenticated;
		}
		
		public static function retrieveAccount(username:String, password:String, callback:Function = null):void
		{
			_retrieveAccountCallback = callback;
			_retrievingAccount = true;
			
			Configuration.USERNAME = username;
			Configuration.PASSWORD = password;
			
			StatManager.resetStats();
			
			authenticate(username, password, _retrieveAccountAuthenticated);
		}
		
		private static function _retrieveAccountAuthenticated(statusCode:String):void
		{
			if (statusCode != AccountStatus.AUTHENTICATION_CREDENTIAL_MISSING && statusCode != AccountStatus.AUTHENTICATION_FAILED && statusCode != AccountStatus.IO_ERROR)
			{
				_authenticated = true;
				Configuration.ACTIVE_TRAINER.DECODE_FROM_STRING(statusCode); // Decode the loaded data.
				// Now proceed to retrieve each of the player's pokemon
				pokemonResponses = 0;
				pokemonExpectedResponses = 6;
				pokemonResponseData = new Array();
				retrievePokemon(1);
				retrievePokemon(2);
				retrievePokemon(3);
				retrievePokemon(4);
				retrievePokemon(5);
				retrievePokemon(6);
			}
			else
			{
				_retrieveAccountCallback(statusCode);
			}
		}
		
		private static function retrievePokemon(pokemonNumber:int):void
		{
			var url:String = Configuration.WEB_ASSETS_URL + "retrievepokemon.php?d=" + (new Date().getTime());
			var request:URLRequest = new URLRequest(url);
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.username = Configuration.USERNAME;
			requestVars.password = Configuration.PASSWORD;
			requestVars.traineruid = Configuration.ACTIVE_TRAINER.UID;
			requestVars.requestedPokemon = pokemonNumber;
			
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, retrievePokemonEvent, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, retrievePokemonIOError, false, 0, true);
			urlLoader.load(request);
		}
		
		private static function retrievePokemonIOError(e:IOErrorEvent):void
		{
			if (_retrieveAccountCallback != null) _retrieveAccountCallback(AccountStatus.IO_ERROR);
			_retrieveAccountCallback = null;
		}
		
		private static var pokemonResponses:int = 0;
		private static var pokemonExpectedResponses:int = 0;
		private static var pokemonResponseData:Array;
		
		private static function retrievePokemonEvent(e:Event):void
		{
			pokemonResponses++;
			
			var pokemonData:String = String(e.currentTarget.data);
			
			if (pokemonData == AccountStatus.RETRIEVE_POKEMON_MISSING_CREDENTIALS || pokemonData == AccountStatus.RETRIEVE_POKEMON_USER_NOT_FOUND || pokemonData == AccountStatus.RETRIEVE_POKEMON_INVALID_PASSWORD)
			{
				//trace("Missing credentials.");
				throw(new Error("Pokemon retrieval error code " + pokemonData)); /// If we get to this point with any of these errors, something is fishy
			}
			else if (pokemonData == AccountStatus.RETRIEVE_POKEMON_NULL)
			{
				//trace("Response counted, line is null");
			}
			else
			{
				var data:Array = pokemonData.split("//");
				var pokemonNumber:int = int(data[0]);
				var pokemonDataTemp:String = String(data[1]);
				pokemonResponseData[pokemonNumber - 1] = pokemonDataTemp;
			}
			
			if (pokemonResponses == pokemonExpectedResponses)
			{
				for (var i:int = 0; i < pokemonResponses; i++)
				{
					if (pokemonResponseData[i] == null) continue;
					var datatemp:String = pokemonResponseData[i];
					Configuration.ACTIVE_TRAINER.addPokemonToPartyFromString(datatemp);
				}
				
				_retrievingAccount = false;
				
				if (_retrieveAccountCallback != null) _retrieveAccountCallback(AccountStatus.RETRIEVE_ACCOUNT_SUCCESSFUL);
				_retrieveAccountCallback = null;
				pokemonResponseData = null;
				pokemonResponses = 0;
				pokemonExpectedResponses = 0;
			}
		}
		
		public static function saveAccount(username:String, password:String, trainer:Trainer, callback:Function = null):void
		{
			if (!AUTHENTICATED) throw(new Error("AccountManager: User not authenticated."));
			
			_saveTrainerCallback = callback;
			
			// register all of this trainer's pokemon
			for (var i:int = 0; i < 6; i++)
			{
				var pokemon:Pokemon = trainer.getPokemon(i);
				if (pokemon != null) registerPokemon(pokemon);
			}
			
			// now update the trainer
			var url:String = Configuration.WEB_ASSETS_URL + "updateuser.php?d=" + (new Date().getTime());
			var request:URLRequest = new URLRequest(url);
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.username = username;
			requestVars.password = password;
			requestVars.data = trainer.ENCODE_INTO_STRING();
			requestVars.pok1 = trainer.getPokemon(0) != null ? trainer.getPokemon(0).UID : "";
			requestVars.pok2 = trainer.getPokemon(1) != null ? trainer.getPokemon(1).UID : "";
			requestVars.pok3 = trainer.getPokemon(2) != null ? trainer.getPokemon(2).UID : "";
			requestVars.pok4 = trainer.getPokemon(3) != null ? trainer.getPokemon(3).UID : "";
			requestVars.pok5 = trainer.getPokemon(4) != null ? trainer.getPokemon(4).UID : "";
			requestVars.pok6 = trainer.getPokemon(5) != null ? trainer.getPokemon(5).UID : "";
			
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, saveTrainerEvent, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, saveTrainerIOError, false, 0, true);
			urlLoader.load(request);
		}
		
		private static function saveTrainerIOError(e:IOErrorEvent):void
		{
			_saveTrainerCallback(AccountStatus.UPDATE_TRAINER_FAILED, e.errorID);
			_saveTrainerCallback = null;
		}
		
		private static function saveTrainerEvent(e:Event):void
		{
			var statusCode:String = String(e.currentTarget.data);
			
			if (_saveTrainerCallback != null) _saveTrainerCallback(statusCode);
			switch (statusCode)
			{
			case AccountStatus.UPDATE_TRAINER_CREDENTIAL_MISSING: 
				trace("AccountManager: Missing credential on account update.");
				break;
			case AccountStatus.UPDATE_TRAINER_FAILED: 
				trace("AccountManager: Account update failed.");
				break;
			case AccountStatus.UPDATE_TRAINER_SUCCESSFUL: 
				trace("AccountManager: Account update successful.");
				break;
			}
			
			_saveTrainerCallback = null;
		}
		
		public static function registerPokemon(pokemon:Pokemon):void
		{
			var pokemonuid:String = pokemon.UID;
			var traineruid:String = pokemon.TRAINER.UID;
			var pokemondata:String = pokemon.ENCODE_INTO_STRING();
			
			var url:String = Configuration.WEB_ASSETS_URL + "registerpokemon.php?d=" + (new Date().getTime());
			var request:URLRequest = new URLRequest(url);
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.pokemonuid = pokemonuid;
			requestVars.traineruid = traineruid;
			requestVars.pokemondata = pokemondata;
			
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, urlLoaderEvent, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEvent, false, 0, true);
			urlLoader.load(request);
		}
		
		private static function ioErrorEvent(e:IOErrorEvent):void
		{
			trace(e.toString());
		}
		
		private static function urlLoaderEvent(e:Event):void
		{
			
		}
		
		public static function createAccount(username:String, password:String, trainer:Trainer, callback:Function = null):void
		{
			_createAccountCallback = callback;
			
			var url:String = Configuration.WEB_ASSETS_URL + "createuser.php?d=" + (new Date().getTime());
			var request:URLRequest = new URLRequest(url);
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.password = password;
			requestVars.username = username;
			requestVars.data = trainer.ENCODE_INTO_STRING();
			requestVars.pok1 = trainer.getPokemon(0) != null ? trainer.getPokemon(0).UID : "";
			requestVars.pok2 = trainer.getPokemon(1) != null ? trainer.getPokemon(1).UID : "";
			requestVars.pok3 = trainer.getPokemon(2) != null ? trainer.getPokemon(2).UID : "";
			requestVars.pok4 = trainer.getPokemon(3) != null ? trainer.getPokemon(3).UID : "";
			requestVars.pok5 = trainer.getPokemon(4) != null ? trainer.getPokemon(4).UID : "";
			requestVars.pok6 = trainer.getPokemon(5) != null ? trainer.getPokemon(5).UID : "";
			
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, createAccountEvent, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, createAccountIOError, false, 0, true);
			urlLoader.load(request);
		}
		
		private static function createAccountEvent(e:Event):void
		{
			var statusCode:String = String(e.currentTarget.data);
			
			if (AccountStatus.CREATION_SUCCESSFUL) _authenticated = true;
			
			if (_createAccountCallback != null) _createAccountCallback(statusCode);
			else
			{
				switch (statusCode)
				{
				case AccountStatus.CREATION_CREDENTIAL_MISSING: 
					trace("AccountManager: Account creation failed - credential missing.");
					break;
				case AccountStatus.CREATION_NAME_TAKEN: 
					trace("AccountManager: Account creation failed - name is taken.");
					break;
				case AccountStatus.CREATION_SUCCESSFUL: 
					trace("AccountManager: Account creation successful.");
					break;
				}
			}
			
			_createAccountCallback = null;
		}
		
		public static function saveAccountWithMessage():void
		{
			_saveComplete = false;
			MessageCenter.addMessage(Message.createMessage("Saving...", false, 0, saveMessageComplete, -1, true));
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.MESSAGE_CENTER);
			saveAccount(Configuration.USERNAME, Configuration.PASSWORD, Configuration.ACTIVE_TRAINER, finishSaving);

		}
		
		private static var _saveComplete:Boolean = false;
		private static function finishSaving(statusCode:String, extraData:String = ""):void
		{
			if (MessageCenter.WAITING_ON_FINISH_MESSAGE) MessageCenter.finishMessage();
			_saveComplete = true;
			switch(statusCode)
			{
				case AccountStatus.UPDATE_TRAINER_CREDENTIAL_MISSING:
				case AccountStatus.UPDATE_TRAINER_FAILED:
					MessageCenter.addMessage(Message.createMessage("Error! Save failed.\nE: " + extraData, true, 0));
					break;
				case AccountStatus.UPDATE_TRAINER_SUCCESSFUL:
					MessageCenter.addMessage(Message.createMessage(Configuration.ACTIVE_TRAINER.NAME + " saved the game!", true, 0));
					break;
			}
		}
		
		private static function saveMessageComplete():void
		{
			if (_saveComplete && MessageCenter.WAITING_ON_FINISH_MESSAGE) MessageCenter.finishMessage();
		}
		
		private static function createAccountIOError(e:IOErrorEvent):void
		{
			if (_createAccountCallback != null) _createAccountCallback(AccountStatus.CREATION_FAILED);
			
			_createAccountCallback = null;
		}
		
		public static function authenticate(username:String, password:String, callback:Function = null):void
		{
			_authenticationCallback = callback;
			
			var url:String = Configuration.WEB_ASSETS_URL + "authuser.php?d=" + (new Date().getTime());
			var request:URLRequest = new URLRequest(url);
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.password = password;
			requestVars.username = username;
			
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, authenticateEvent, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, authenticateIOError, false, 0, true);
			urlLoader.load(request);
		}
		
		private static function authenticateIOError(e:IOErrorEvent):void
		{
			if (_authenticationCallback != null) _authenticationCallback(AccountStatus.IO_ERROR);
			
			_authenticationCallback = null;
		}
		
		private static function authenticateEvent(e:Event):void
		{
			var statusCode:String = String(e.currentTarget.data);
			
			if (_authenticationCallback != null) _authenticationCallback(statusCode);
			else
			{
				switch (statusCode)
				{
				case AccountStatus.AUTHENTICATION_CREDENTIAL_MISSING: 
					trace("AccountManager: Authentication request is missing a credential.");
					break;
				case AccountStatus.AUTHENTICATION_FAILED: 
					trace("AccountManager: Authentication request failed.");
					break;
				default: 
					_authenticated = true;
					trace("AccountManager: Authentication request success.");
					Configuration.ACTIVE_TRAINER.DECODE_FROM_STRING(statusCode);
					break;
				}
			}
			
			_authenticationCallback = null;
		}
	
	}

}