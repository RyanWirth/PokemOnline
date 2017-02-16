package com.cloakentertainment.pokemonline.ui 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBagMenuState 
	{
		
		private var _aY:int;
		private var _cY:int;
		private var _cS:int;
		
		public function UIBagMenuState(arrowY:int, containerY:int, currentlySelected:int) 
		{
			_aY = arrowY;
			_cY = containerY;
			_cS = currentlySelected;
		}
		
		public function get ARROW_Y():int
		{
			return _aY;
		}
		
		public function get CONTAINER_Y():int
		{
			return _cY;
		}
		
		public function get CURRENTLY_SELECTED():int
		{
			return _cS;
		}
		
	}

}