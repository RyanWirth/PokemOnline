package com.cloakentertainment.pokemonline.multiplayer 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class AccountStatus 
	{
		
		public static const AUTHENTICATION_FAILED:String = "AUTHENTICATION_FAILED";
		public static const AUTHENTICATION_CREDENTIAL_MISSING:String = "AUTHENTICATION_CREDENTIAL_MISSING";
		
		public static const CREATION_NAME_TAKEN:String = "CREATION_NAME_TAKEN";
		public static const CREATION_CREDENTIAL_MISSING:String = "CREATION_CREDENTIAL_MISSING";
		public static const CREATION_SUCCESSFUL:String = "CREATION_SUCCESSFUL";
		public static const CREATION_FAILED:String = "CREATION_FAILED";
		
		public static const UPDATE_TRAINER_SUCCESSFUL:String = "UPDATE_TRAINER_SUCCESSFUL";
		public static const UPDATE_TRAINER_CREDENTIAL_MISSING:String = "UPDATE_TRAINER_CREDENTIAL_MISSING";
		public static const UPDATE_TRAINER_FAILED:String = "UPDATE_TRAINER_FAILED";
		
		public static const RETRIEVE_ACCOUNT_SUCCESSFUL:String = "RETRIEVE_ACCOUNT_SUCCESSFUL";
		public static const RETRIEVE_POKEMON_FAILED:String = "RETRIEVE_POKEMON_FAILED";
		public static const RETRIEVE_POKEMON_NULL:String = "RETRIEVE_POKEMON_NULL";
		public static const RETRIEVE_POKEMON_MISSING_CREDENTIALS:String = "RETRIEVE_POKEMON_MISSING_CREDENTIALS";
		public static const RETRIEVE_POKEMON_USER_NOT_FOUND:String = "RETRIEVE_POKEMON_USER_NOT_FOUND";
		public static const RETRIEVE_POKEMON_INVALID_PASSWORD:String = "RETRIEVE_POKEMON_INVALID_PASSWORD";
		
		public static const IO_ERROR:String = "IO_ERROR";
		
		public function AccountStatus() 
		{
			
		}
		
	}

}