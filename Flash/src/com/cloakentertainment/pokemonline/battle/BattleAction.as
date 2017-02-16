package com.cloakentertainment.pokemonline.battle
{
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonMoves;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class BattleAction
	{
		public static const MOVE:String = "move";
		public static const ITEM:String = "item";
		public static const SWITCH:String = "switch";
		public static const RUN:String = "run";
		public static const FLEE:String = "flee";
		public static const FLINCH:String = "flinch";
		
		private var _type:String;
		private var _owner:Pokemon;
		private var _target:Pokemon;
		private var _move:int;
		
		private var _itemName:String = "";
		
		private var _quickclaw:Boolean = false;
		private var _accuracy:int = 0;
		
		private var _obedienceA:int = 0;
		private var _obedienceB:int = 0;
		private var _obedienceC:int = 0;
		private var _ignoreMove:int = 0;
		private var _magnitude:int = 0;
		private var _metronome:int = 0;
		private var _criticalhit:int = 0;
		private var _astonish:int = 0;
		private var _damagevariance:int = 0;
		
		public function BattleAction(type:String, owner:Pokemon, target:Pokemon, extraData:int, extraData2:String = "")
		{
			_type = type;
			_owner = owner;
			_target = target;
			
			if (TYPE == BattleAction.MOVE)
				_move = extraData;
			
			if (TYPE == BattleAction.ITEM)
				_itemName = extraData2;
		}
		
		public function get ITEM_NAME():String
		{
			return _itemName;
		}
		
		public function setTarget(pokemon:Pokemon):void
		{
			_target = pokemon;
		}
		
		public function get TARGET():Pokemon
		{
			return _target;
		}
		
		public static function recreateMove(owner:Pokemon, target:Pokemon, moveID:int, quickclaw:Boolean, accuracy:int, obedienceA:int, obedienceB:int, obedienceC:int, ignoreMove:int, magnitude:int, metronome:int, criticalhit:int, astonish:int, damagevariance:int):BattleAction
		{
			var battleAction:BattleAction = new BattleAction(BattleAction.MOVE, owner, target, moveID);
			battleAction.setQuickclaw(quickclaw);
			battleAction.setAccuracy(accuracy);
			battleAction.setObedience(obedienceA, obedienceB, obedienceC);
			battleAction.setIgnoreMove(ignoreMove);
			battleAction.setMagnitude(magnitude);
			battleAction.setMetronome(metronome);
			battleAction.setCriticalHit(criticalhit);
			battleAction.setAstonish(astonish);
			battleAction.setDamageVariance(damagevariance);
			return battleAction;
		}
		
		public static function generateSwitch(oldPokemon:Pokemon, newPokemon:Pokemon):BattleAction
		{
			var battleAction:BattleAction = new BattleAction(BattleAction.SWITCH, oldPokemon, newPokemon, 0);
			battleAction.setAccuracy(Math.floor(Math.random()*256));
			return battleAction;
		}
		
		public static function generateRun(ownerPokemon:Pokemon):BattleAction
		{
			var battleAction:BattleAction = new BattleAction(BattleAction.RUN, ownerPokemon, null, 0);
			return battleAction;
		}
		
		public static function generateItem(ownerPokemon:Pokemon, enemyPokemon:Pokemon, itemName:String):BattleAction
		{
			var battleAction:BattleAction = new BattleAction(BattleAction.ITEM, ownerPokemon, enemyPokemon, 0, itemName);
			battleAction.setAccuracy(Math.floor(Math.random()*256));
			return battleAction;
		}
		
		public static function generateMove(owner:Pokemon, target:Pokemon, moveID:int):BattleAction
		{
			var rand:int;
			
			var quickclaw:Boolean = false;
			var accuracy:int = Math.floor(Math.random() * 99) + 1;
			var obedienceA:int = Math.floor(Math.random() * 256);
			var obedienceB:int = Math.floor(Math.random() * 256);
			var obedienceC:int = Math.floor(Math.random() * 256);
			var magnitude:int = 0;
			var metronome:int = 0;
			var criticalhit:int = Math.floor(Math.random() * 100) + 1;
			var astonish:int = Math.floor(Math.random() * 100) + 1;
			var damagevariance:int = Math.floor(Math.random() * 16) + 85;
			
			var magnitudeRandomNumber:int = Math.floor(Math.random() * 100) + 1;
			if (magnitudeRandomNumber >= 95)
				magnitude = 4;
			else if (magnitudeRandomNumber >= 85)
				magnitude = 5;
			else if (magnitudeRandomNumber >= 65)
				magnitude = 6;
			else if (magnitudeRandomNumber >= 35)
				magnitude = 7;
			else if (magnitudeRandomNumber >= 15)
				magnitude = 8;
			else if (magnitudeRandomNumber >= 5)
				magnitude = 9;
			else
				magnitude = 10;
			
			if (owner.HELDITEM == "Quick Claw")
			{
				// owner has a 20% chance of getting a first-strike
				rand = Math.floor(Math.random() * 100) + 1;
				if (rand <= 20)
					quickclaw = true;
			}
			var ignoreMove:int = 0;
			var attempt:int = 0; // Ignore Move: a move to be used if the pokemon ignores orders
			do
			{
				ignoreMove = PokemonMoves.getMoveIDByName(owner.getRandomMove());
				attempt++;
			} while (ignoreMove == moveID && attempt <= 10);
			if (ignoreMove == 0)
				ignoreMove = PokemonMoves.getMoveIDByName("Struggle");
			
			var metronomeMoveName:String = "";
			do
			{
				metronome = Math.floor(Math.random() * 354) + 1;
				metronomeMoveName = PokemonMoves.getMoveNameByID(metronome);
			} while (metronomeMoveName == "Metronome" || metronomeMoveName == "Counter" || metronomeMoveName == "Covet" || metronomeMoveName == "Destiny Bond" || metronomeMoveName == "Detect" || metronomeMoveName == "Endure" || metronomeMoveName == "Focus Punch" || metronomeMoveName == "Follow Me" || metronomeMoveName == "Helping Hand" || metronomeMoveName == "Mimic" || metronomeMoveName == "Mirror Coat" || metronomeMoveName == "Protect" || metronomeMoveName == "Sketch" || metronomeMoveName == "Sleep Talk" || metronomeMoveName == "Snatch" || metronomeMoveName == "Struggle" || metronomeMoveName == "Thief" || metronomeMoveName == "Trick");
			
			return recreateMove(owner, target, moveID, quickclaw, accuracy, obedienceA, obedienceB, obedienceC, ignoreMove, magnitude, metronome, criticalhit, astonish, damagevariance);
		}
		
		public function makeUserFlinch():void
		{
			_type = BattleAction.FLINCH;
		}
		
		public function getObedience(num:int):int
		{
			if (num == 1)
				return _obedienceA;
			else if (num == 2)
				return _obedienceB;
			else if (num == 3)
				return _obedienceC;
			
			throw(new Error('Unknown Obedience num ' + num));
			return 0;
		}
		
		public function get TYPE():String
		{
			return _type;
		}
		
		public function get OWNER():Pokemon
		{
			return _owner;
		}
		
		public function get METRONOME():int
		{
			return _metronome;
		}
		
		public function get CRITICAL_HIT():int
		{
			return _criticalhit;
		}
		
		public function get ASTONISH():int
		{
			return _astonish;
		}
		
		public function get DAMAGE_VARIANCE():int
		{
			return _damagevariance;
		}
		
		public function get MOVEID():int
		{
			if (TYPE != BattleAction.MOVE)
				return 0;
			return _move;
		}
		
		public function setOVERRIDEMOVEID(newMoveID:int):void
		{
			_move = newMoveID;
		}
		
		public function setMagnitude(magnitude:int):void
		{
			_magnitude = magnitude;
		}
		
		public function setMetronome(metronome:int):void
		{
			_metronome = metronome;
		}
		
		public function setCriticalHit(criticalhit:int):void
		{
			_criticalhit = criticalhit;
		}
		
		public function setAstonish(astonish:int):void
		{
			_astonish = astonish;
		}
		
		public function setDamageVariance(damagevariance:int):void
		{
			_damagevariance = damagevariance;
		}
		
		public function get MAGNITUDE():int
		{
			return _magnitude;
		}
		
		public function get QUICKCLAW():Boolean
		{
			return _quickclaw;
		}
		
		public function get ACCURACY():int
		{
			return _accuracy;
		}
		
		public function get IGNORE_MOVE():int
		{
			return _ignoreMove;
		}
		
		public function setQuickclaw(quickclaw:Boolean):void
		{
			_quickclaw = quickclaw;
		}
		
		public function setAccuracy(accuracy:int):void
		{
			_accuracy = accuracy;
		}
		
		public function setObedience(a:int, b:int, c:int):void
		{
			_obedienceA = a;
			_obedienceB = b;
			_obedienceC = c;
		}
		
		public function setIgnoreMove(moveID:int):void
		{
			_ignoreMove = moveID;
		}
	
	}

}