package com.cloakentertainment.pokemonline
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.world.map.ChunkManager;
	import com.cloakentertainment.pokemonline.multiplayer.AccountManager;
	import com.cloakentertainment.pokemonline.ui.MenuType;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import com.cloakentertainment.pokemonline.multiplayer.MultiplayerManager;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class GameManager
	{
		private static var _triedConnectingAlready:Boolean = false;
		
		public function GameManager()
		{
		
		}
		
		public static function startGame():void
		{
			// Retrieve the Messages of the Day
			AccountManager.retrieveMOTDs();
			
			Configuration.createMenu(MenuType.LOGIN);
		}
		
		public static function enterOverworld():void
		{
			WorldManager.startOverworld();
		}
		
		public static function connectToPlayerIO():void
		{
			if (_triedConnectingAlready) return;
			_triedConnectingAlready = true;
			
			MultiplayerManager.connect(connectedToPlayerIO);
		}
		
		public static function connectedToPlayerIO():void
		{
			Configuration.chatModule.construct();
		}
	
	}

}