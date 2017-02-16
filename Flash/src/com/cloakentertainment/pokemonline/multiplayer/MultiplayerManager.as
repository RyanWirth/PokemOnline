package com.cloakentertainment.pokemonline.multiplayer 
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.world.entity.EntityManager;
	import com.cloakentertainment.pokemonline.world.PlayerManager;
	import com.cloakentertainment.pokemonline.world.region.RegionManager;
	import com.cloakentertainment.pokemonline.world.map.ChunkManager;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import playerio.*;
	import playerio.Message;
	/**
	 * ...
	 * @author ...
	 */
	public class MultiplayerManager 
	{
		private static var _connected:Boolean = false;
		private static var _attemptingToConnect:Boolean = false;
		private static var _client:Client;
		private static var _connection:Connection;
		private static var _callback:Function;
		private static var _roomID:String;
		
		public function MultiplayerManager() 
		{
			
		}
		
		public static function connect(callback:Function = null):void
		{
			trace("ATTEMPTING CONNECTION...");
			if (_connected || _attemptingToConnect) return;
			if (ChunkManager.isPreparedForConnection() == false || WorldManager.isStillLoading())
			{
				destroyConnectionAttempt();
				return;
			}
			_attemptingToConnect = true;
			
			_callback = callback;
			
			Configuration.chatModule.connecting();
			PlayerIO.connect(Configuration.STAGE, Configuration.MULTIPLAYER_GAME_ID, "public", Configuration.ACTIVE_TRAINER.NAME, "", null, null, handleConnect, handleError);
		}
		
		private static function handleConnect(client:Client):void
		{
			if (WorldManager.isStillLoading())
			{
				destroyConnectionAttempt();
				return;
			}
			
			_client = client;
			
			if (Configuration.DEVELOPMENT_SERVER) _client.multiplayer.developmentServer = "localhost:8184";
			
			findPopulatedRoom(true);
		}
		
		public static function findPopulatedRoom(overrideAttempt:Boolean = false):void
		{
			if (_connected || (_attemptingToConnect && !overrideAttempt)) return;
			
			// Find a room to join!
			_attemptingToConnect = true;
			
			if (_client && _client.multiplayer && !WorldManager.isStillLoading()) _client.multiplayer.listRooms("PokemOnline", { }, int.MAX_VALUE, 0, getRooms, handleError);
			else 
			{
				_connected = false;
				_attemptingToConnect = false;
				Configuration.chatModule.connectionFailed();
			}
		}
		
		private static function getRooms(rooms:Array):void
		{
			if (WorldManager.isStillLoading())
			{
				destroyConnectionAttempt();
				return;
			}
			
			for (var i:int = 0; i < rooms.length; i++)
			{
				var room:RoomInfo = rooms[i] as RoomInfo;
				/// This room has less than 40 online users, so we can connect to it!
				if (room.onlineUsers < 40)
				{
					connectToRoom(room.id);
					return;
				}
			}
			
			// There wasn't a room with less than forty players, so we'll create our own.
			connectToRoom(Configuration.ACTIVE_TRAINER.UID);
		}
		
		public static function connectToRoom(ID:String, callback:Function = null):void
		{
			if (WorldManager.isStillLoading())
			{
				destroyConnectionAttempt();
				return;
			}
			
			if (callback != null) _callback = callback;
			_roomID = ID;
			_client.multiplayer.createJoinRoom(ID, "PokemOnline", true, { }, { Name:Configuration.ACTIVE_TRAINER.NAME, 
																				EncodedString:Configuration.ACTIVE_TRAINER.ENCODE_INTO_STRING(),
																				Type:PlayerManager.PLAYER.className,
																				Money:Configuration.ACTIVE_TRAINER.MONEY,
																				UID:Configuration.ACTIVE_TRAINER.UID,
																				Pokemon1:Configuration.ACTIVE_TRAINER.getPokemon(0) != null ? Configuration.ACTIVE_TRAINER.getPokemon(0).ENCODE_INTO_STRING() : "",
																				Pokemon2:Configuration.ACTIVE_TRAINER.getPokemon(1) != null ? Configuration.ACTIVE_TRAINER.getPokemon(1).ENCODE_INTO_STRING() : "",
																				Pokemon3:Configuration.ACTIVE_TRAINER.getPokemon(2) != null ? Configuration.ACTIVE_TRAINER.getPokemon(2).ENCODE_INTO_STRING() : "",
																				Pokemon4:Configuration.ACTIVE_TRAINER.getPokemon(3) != null ? Configuration.ACTIVE_TRAINER.getPokemon(3).ENCODE_INTO_STRING() : "",
																				Pokemon5:Configuration.ACTIVE_TRAINER.getPokemon(4) != null ? Configuration.ACTIVE_TRAINER.getPokemon(4).ENCODE_INTO_STRING() : "",
																				Pokemon6:Configuration.ACTIVE_TRAINER.getPokemon(5) != null ? Configuration.ACTIVE_TRAINER.getPokemon(5).ENCODE_INTO_STRING() : "",
																				xPos:PlayerManager.PLAYER.X_TILE,
																				yPos:PlayerManager.PLAYER.Y_TILE,
																				map:Configuration.ACTIVE_TRAINER.MAP,
																				region:RegionManager.CURRENT_REGION_NAME
																				}, handleJoin, handleError);
		}
		
		private static function handleJoin(connection:Connection):void
		{
			if (_callback != null) _callback();
			_callback = null;
			_connection = connection;
			_connected = true;
			_attemptingToConnect = false;
			
			_connection.addMessageHandler("ChatMessage", Configuration.chatModule.handleChatMessage);
			_connection.addMessageHandler("Location", EntityManager.receivePlayerCoordinates);
			_connection.addMessageHandler("PlayerRequest", EntityManager.receivePlayerRequest);
			_connection.addMessageHandler("DirectionChange", EntityManager.receivePlayerDirectionChange);
			_connection.addMessageHandler("RunState", EntityManager.receivePlayerRunState);
			_connection.addMessageHandler("BusyState", EntityManager.receivePlayerBusyState);
			_connection.addMessageHandler("ChangeMap", EntityManager.receivePlayerChangeMap);
			_connection.addMessageHandler("ChatShout", Configuration.chatModule.handleChatShout);
			_connection.addMessageHandler("*", handleMessages);
			_connection.addDisconnectHandler(disconnectFromRoom);
		}
		
		public static function disconnectFromRoom(disconnectedByServer:Boolean = true):void
		{
			if (_connected == false) return;
			_connected = false;
			_attemptingToConnect = false;
			_connection.removeMessageHandler("ChatMessage", Configuration.chatModule.handleChatMessage);
			_connection.removeMessageHandler("Location", EntityManager.receivePlayerCoordinates);
			_connection.removeMessageHandler("PlayerRequest", EntityManager.receivePlayerRequest);
			_connection.removeMessageHandler("DirectionChange", EntityManager.receivePlayerDirectionChange);
			_connection.removeMessageHandler("RunState", EntityManager.receivePlayerRunState);
			_connection.removeMessageHandler("BusyState", EntityManager.receivePlayerBusyState);
			_connection.removeMessageHandler("ChangeMap", EntityManager.receivePlayerChangeMap);
			_connection.removeMessageHandler("ChatShout", Configuration.chatModule.handleChatShout);
			_connection.removeMessageHandler("*", handleMessages);
			_connection.removeDisconnectHandler(disconnectFromRoom);
			_connection.disconnect();
			
			Configuration.chatModule.handleChatShout(null, ChatStyle.SYSTEM, "SYSTEM", "Disconnected from server.");
			if (disconnectedByServer) connectToRoom(Configuration.ACTIVE_TRAINER.NAME, Configuration.chatModule.roomSwitched);
		}
		
		private static function handleMessages(m:Message):void
		{
			//trace("Received: " + m);
		}
		
		private static function handleError(e:PlayerIOError):void
		{
			trace(e);
			_connected = false;
			_attemptingToConnect = false;
			Configuration.chatModule.connectionFailed();
		}
		
		static private function destroyConnectionAttempt():void 
		{
			_connected = false;
			_attemptingToConnect = false;
			Configuration.chatModule.connectionFailed();
		}
		
		public static function get CONNECTION():Connection
		{
			return _connection;
		}
		
		public static function get CONNECTED():Boolean
		{
			return _connected;
		}
		
		public static function get ROOM_ID():String
		{
			return _roomID;
		}
		
	}

}