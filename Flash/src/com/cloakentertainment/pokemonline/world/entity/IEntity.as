package com.cloakentertainment.pokemonline.world.entity
{
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public interface IEntity
	{
		function animate(animationType:String):void;
		function play():void;
		function stop():void;
	}

}