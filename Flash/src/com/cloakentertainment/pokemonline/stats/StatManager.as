package com.cloakentertainment.pokemonline.stats 
{
	/**
	 * ...
	 * @author ...
	 */
	public class StatManager 
	{
		private static var _stats:Object;
		
		public function StatManager() 
		{
			
		}
		
		public static function resetStats():void
		{
			_stats = null;
		}
		
		public static function get STATS():Object
		{
			if (!_stats) _stats = new Object();
			return _stats;
		}
		
		public static function incrementStat(statType:String, incrementBy:int = 1):void
		{
			if (STATS.hasOwnProperty(statType) == false) STATS[statType] = 0;
			
			STATS[statType] += incrementBy;
		}
		
	}

}