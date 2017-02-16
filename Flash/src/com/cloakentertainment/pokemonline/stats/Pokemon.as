package com.cloakentertainment.pokemonline.stats
{
	import com.cloakentertainment.pokemonline.battle.BattleEffect;
	import com.cloakentertainment.pokemonline.trainer.Trainer;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public final class Pokemon
	{
		public var base:PokemonBase = null;
		private var _uid:String = "";
		
		private var _currentHP:int = 0;
		
		private var _HP:int = 0;
		private var _ATK:int = 0;
		private var _DEF:int = 0;
		private var _SPATK:int = 0;
		private var _SPDEF:int = 0;
		private var _SPEED:int = 0;
		
		private var _HPev:int = 0;
		private var _ATKev:int = 0;
		private var _DEFev:int = 0;
		private var _SPATKev:int = 0;
		private var _SPDEFev:int = 0;
		private var _SPEEDev:int = 0;
		
		private var _HPevTEMP:int = 0;
		private var _ATKevTEMP:int = 0;
		private var _DEFevTEMP:int = 0;
		private var _SPATKevTEMP:int = 0;
		private var _SPDEFevTEMP:int = 0;
		private var _SPEEDevTEMP:int = 0;
		
		private var _HPiv:int = 0;
		private var _ATKiv:int = 0;
		private var _DEFiv:int = 0;
		private var _SPATKiv:int = 0;
		private var _SPDEFiv:int = 0;
		private var _SPEEDiv:int = 0;
		
		private var _name:String = "";
		private var _gender:String = PokemonGender.NONE;
		private var _shiny:Boolean = false;
		private var _ability:String = "";
		private var _level:int = 0;
		private var _XP:int = 0;
		private var _heldItem:String = "";
		private var _ribbon:String = "";
		private var _nature:String = PokemonNature.DOCILE;
		private var _friendship:int = 0;
		private var _distanceWalked:int = 0;
		private var _otname:String = "";
		private var _form:int = 1;
		private var _metatlevel:int = 1;
		private var _metatlocation:String = "";
		private var _pokeballType:String = Pokeballs.POKEBALL_BALL;
		
		private var _trainer:Trainer;
		
		public var ESCAPE_ATTEMPTS:int = 0;
		
		private var _lostItem:Boolean = false;
		private var _turnsActive:int = 0;
		private var _lastMoveUsed:int = 0;
		private var _usedMoveLength:int = 1;
		private var _lastHitBy:Pokemon;
		private var _lastHitByMove:int = 0;
		private var _lastTakenDamage:int = 0;
		private var _goingToUseMove:int = 0;
		private var _rageCounter:int = 0;
		private var _move1Disabled:int = 0;
		private var _move2Disabled:int = 0;
		private var _move3Disabled:int = 0;
		private var _move4Disabled:int = 0;
		private var _nDamageNumber:int = 1;
		private var _battleItemLost:String = "";
		private var _sleepingNumber:int = 0;
		public var OVERRIDE_TYPE:String = "";
		private var _active:Boolean = false;
		private var _activated:Boolean = false;
		private var _levelledUp:Boolean = false;
		private var _battleEffects:Vector.<String> = new Vector.<String>();
		
		/*
		 * Special Battle status conditions
		 * */
		private var _confusionLength:int = 0;
		private var _encoreLength:int = 0;
		private var _healblockLength:int = 0;
		private var _partiallytrappedLength:int = 0;
		private var _perishsongLength:int = 0;
		private var _tauntLength:int = 0;
		private var _telekineticlevitationLength:int = 0;
		
		private var _nonvolatileStatusCondition:PokemonStatusCondition;
		private var _volatileStatusConditions:Vector.<PokemonStatusCondition> = new Vector.<PokemonStatusCondition>();
		
		private var _ATKstage:int = 0;
		private var _DEFstage:int = 0;
		private var _SPATKstage:int = 0;
		private var _SPDEFstage:int = 0;
		private var _SPEEDstage:int = 0;
		private var _EVASIONstage:int = 0;
		private var _ACCURACYstage:int = 0;
		
		private var _MOVE1:String = "";
		private var _MOVE2:String = "";
		private var _MOVE3:String = "";
		private var _MOVE4:String = "";
		private var _MOVE1PP:int = 0;
		private var _MOVE2PP:int = 0;
		private var _MOVE3PP:int = 0;
		private var _MOVE4PP:int = 0;
		private var _MOVE1PPMAX:int = 0;
		private var _MOVE2PPMAX:int = 0;
		private var _MOVE3PPMAX:int = 0;
		private var _MOVE4PPMAX:int = 0;
		
		public var transformed:Pokemon = null;
		public var FOUGHT_LAST_POKEMON:Boolean = false;
		
		public function Pokemon(_base:PokemonBase)
		{
			base = _base;
		}
		
		public function transformInto(newPokemon:Pokemon):void
		{
			if (transformed == null)
			{
				transformed = new Pokemon(null);
				transformed.DECODE_FROM_STRING(ENCODE_INTO_STRING());
			}
			
			var oldTrainer:Trainer = _trainer;
			
			DECODE_FROM_STRING(newPokemon.ENCODE_INTO_STRING());
			
			/// Replace some of the stats that should stay the same.
			_name = transformed.NAME;
			_trainer = oldTrainer;
			_friendship = transformed.FRIENDSHIP;
			_distanceWalked = transformed.DISTANCE_WALKED;
			_gender = transformed.GENDER;
			_level = transformed.LEVEL;
			_HP = transformed.getStat(PokemonStat.HP);
			_XP = transformed.XP;
			_otname = transformed.OTNAME;
			_nature = transformed.NATURE;
			_currentHP = transformed.CURRENT_HP;
			_heldItem = transformed.HELDITEM;
			
			/// Copy the source Pokemon's stat stages
			_ATKstage = newPokemon.getStatStage(PokemonStat.ATK);
			_DEFstage = newPokemon.getStatStage(PokemonStat.DEF);
			_SPATKstage = newPokemon.getStatStage(PokemonStat.SPATK);
			_SPDEFstage = newPokemon.getStatStage(PokemonStat.SPDEF);
			_SPEEDstage = newPokemon.getStatStage(PokemonStat.SPEED);
			_EVASIONstage = newPokemon.getStatStage(PokemonStat.EVASION);
			_ACCURACYstage = newPokemon.getStatStage(PokemonStat.ACCURACY);
			
			/// Set the PP of all moves to 5
			setMovePP(5, 5, 5, 5);
		}
		
		public function rest():void
		{
			_currentHP = getStat(PokemonStat.HP);
			setMovePP(getMovePPMax(1), getMovePPMax(2), getMovePPMax(3), getMovePPMax(4));
			clearBattleModifiers();
			setNonVolatileStatusCondition(null);
		}
		
		public function destroy():void
		{
			if (transformed != null) transformed.destroy();
			transformed = null;
			base = null;
			learnableMoves = null;
			_volatileStatusConditions = null;
			_nonvolatileStatusCondition = null;
			_switchedMoves = null;
			IMPRISONED_BY = null;
			_lastHitBy = null;
			_battleEffects = null;
		}
		
		public function incrementSteps():void
		{
			_distanceWalked++;
		}
		
		public function get MET_AT_LEVEL():int
		{
			return _metatlevel;
		}
		
		public function get MET_AT_LOCATION():String
		{
			return _metatlocation;
		}
		
		/*
		 * The type of Pokéball the Pokémon was caught in.
		 */
		public function get POKEBALL_TYPE():String
		{
			return _pokeballType;
		}
		
		public function setPokeballType(type:String):void
		{
			_pokeballType = type;
		}
		
		public function setMetAt(level:int, location:String):void
		{
			_metatlocation = location;
			_metatlevel = level;
		}
		
		public function get DISTANCE_WALKED():int
		{
			return _distanceWalked;
		}
		
		public function get XP():int
		{
			return _XP;
		}
		
		/*
		 * The Pokémon's "form", or their unique visual appearance, used for Unown, Castform, etc.
		 */
		public function get FORM():int
		{
			return _form;
		}
		
		public function setForm(formNum:int):void
		{
			_form = formNum;
		}
		
		public function get NATURE():String
		{
			return _nature;
		}
		
		public function setUID(uid:String):void
		{
			_uid = uid;
		}
		
		public function get UID():String
		{
			return _uid;
		}
		
		public function ENCODE_INTO_STRING():String
		{
			var string:String = "";
			string += "BASE=" + base.name;
			string += "&UID=" + _uid;
			string += "&CURRENT_HP=" + _currentHP;
			string += "&HPev=" + _HPev;
			string += "&ATKev=" + _ATKev;
			string += "&DEFev=" + _DEFev;
			string += "&SPATKev=" + _SPATKev;
			string += "&SPDEFev=" + _SPDEFev;
			string += "&SPEEDev=" + _SPEEDev;
			string += "&HPevTEMP=" + _HPevTEMP;
			string += "&ATKevTEMP=" + _ATKevTEMP;
			string += "&DEFevTEMP=" + _DEFevTEMP;
			string += "&SPATKevTEMP=" + _SPATKevTEMP;
			string += "&SPDEFevTEMP=" + _SPDEFevTEMP;
			string += "&SPEEDevTEMP=" + _SPEEDevTEMP;
			string += "&HPiv=" + _HPiv;
			string += "&ATKiv=" + _ATKiv;
			string += "&DEFiv=" + _DEFiv;
			string += "&SPATKiv=" + _SPATKiv;
			string += "&SPDEFiv=" + _SPDEFiv;
			string += "&SPEEDiv=" + _SPEEDiv;
			string += "&NAME=" + _name;
			string += "&GENDER=" + _gender;
			string += "&SHINY=" + _shiny;
			string += "&ABILITY=" + _ability;
			string += "&LEVEL=" + _level;
			string += "&XP=" + _XP;
			string += "&HELDITEM=" + _heldItem;
			string += "&RIBBON=" + _ribbon;
			string += "&NATURE=" + _nature;
			string += "&FRIENDSHIP=" + _friendship;
			string += "&DISTANCEWALKED=" + _distanceWalked;
			string += "&OTNAME=" + _otname;
			string += "&FORM=" + _form;
			string += "&MOVE1=" + _MOVE1;
			string += "&MOVE2=" + _MOVE2;
			string += "&MOVE3=" + _MOVE3;
			string += "&MOVE4=" + _MOVE4;
			string += "&MOVE1PP=" + _MOVE1PP;
			string += "&MOVE2PP=" + _MOVE2PP;
			string += "&MOVE3PP=" + _MOVE3PP;
			string += "&MOVE4PP=" + _MOVE4PP;
			string += "&MOVE1PPMAX=" + _MOVE1PPMAX;
			string += "&MOVE2PPMAX=" + _MOVE2PPMAX;
			string += "&MOVE3PPMAX=" + _MOVE3PPMAX;
			string += "&MOVE4PPMAX=" + _MOVE4PPMAX;
			string += "&METATLVL=" + _metatlevel;
			string += "&METATLOC=" + _metatlocation;
			string += "&STATUS=" + PokemonStatusConditions.getStatusTextFromCondition(_nonvolatileStatusCondition);
			return string;
		}
		
		public function DECODE_FROM_STRING(string:String):void
		{
			var data:Array = string.split("&");
			if (data.length <= 4) throw(new Error("Malformed encoded Pokémon string: " + string));
			for (var i:int = 0; i < data.length; i++)
			{
				var pair:Array = String(data[i]).split("=");
				var key:String = String(pair[0]);
				var value:String = String(pair[1]);
				switch (String(pair[0]))
				{
					case "BASE": 
						base = PokemonFactory.getPokemonBaseFromName(value);
						break;
					case "METATLOC": 
						_metatlocation = value;
						break;
					case "METATLVL": 
						_metatlevel = int(value);
						break;
					case "FORM": 
						_form = int(value);
						break;
					case "UID": 
						_uid = value;
						break;
					case "GENDER": 
						_gender = value;
						break;
					case "SHINY": 
						_shiny = value == "true" ? true : false;
						break;
					case "ABILITY": 
						_ability = value;
						break;
					case "LEVEL": 
						_level = int(value);
						break;
					case "XP": 
						_XP = int(value);
						break;
					case "HELDITEM": 
						_heldItem = value;
						break;
					case "RIBBON": 
						_ribbon = value;
						break;
					case "NATURE": 
						_nature = value;
						break;
					case "FRIENDSHIP": 
						_friendship = int(value);
						break;
					case "DISTANCEWALKED": 
						_distanceWalked = int(value);
						break;
					case "OTNAME": 
						_otname = value;
						break;
					case "MOVE1": 
						_MOVE1 = value;
						break;
					case "MOVE2": 
						_MOVE2 = value;
						break;
					case "MOVE3": 
						_MOVE3 = value;
						break;
					case "MOVE4": 
						_MOVE4 = value;
						break;
					case "MOVE1PP": 
						_MOVE1PP = int(value);
						break;
					case "MOVE2PP": 
						_MOVE2PP = int(value);
						break;
					case "MOVE3PP": 
						_MOVE3PP = int(value);
						break;
					case "MOVE4PP": 
						_MOVE4PP = int(value);
						break;
					case "MOVE1PPMAX": 
						_MOVE1PPMAX = int(value);
						break;
					case "MOVE2PPMAX": 
						_MOVE2PPMAX = int(value);
						break;
					case "MOVE3PPMAX": 
						_MOVE3PPMAX = int(value);
						break;
					case "MOVE4PPMAX": 
						_MOVE4PPMAX = int(value);
						break;
					case "CURRENT_HP": 
						_currentHP = int(value);
						break;
					case "HPev": 
						_HPev = int(value);
						break;
					case "ATKev": 
						_ATKev = int(value);
						break;
					case "DEFev": 
						_DEFev = int(value);
						break;
					case "SPATKev": 
						_SPATKev = int(value);
						break;
					case "SPDEFev": 
						_SPDEFev = int(value);
						break;
					case "SPEEDev": 
						_SPEEDev = int(value);
						break;
					case "HPevTEMP": 
						_HPevTEMP = int(value);
						break;
					case "ATKevTEMP": 
						_ATKevTEMP = int(value);
						break;
					case "DEFevTEMP": 
						_DEFevTEMP = int(value);
						break;
					case "SPATKevTEMP": 
						_SPATKevTEMP = int(value);
						break;
					case "SPDEFevTEMP": 
						_SPDEFevTEMP = int(value);
						break;
					case "SPEEDevTEMP": 
						_SPEEDevTEMP = int(value);
						break;
					case "HPiv": 
						_HPiv = int(value);
						break;
					case "ATKiv": 
						_ATKiv = int(value);
						break;
					case "DEFiv": 
						_DEFiv = int(value);
						break;
					case "SPATKiv": 
						_SPATKiv = int(value);
						break;
					case "SPDEFiv": 
						_SPDEFiv = int(value);
						break;
					case "SPEEDiv": 
						_SPEEDiv = int(value);
						break;
					case "NAME": 
						_name = value;
						break;
					case "STATUS":
						_nonvolatileStatusCondition = PokemonStatusConditions.getStatusConditionFromString(value);
						break;
				}
			}
			
			calculateStats();
		}
		
		public function calculateStats():void
		{
			_HP = PokemonStat.calculateStat(PokemonStat.HP, base.HPBaseStat, _HPiv, _HPev, _level, _nature);
			_ATK = PokemonStat.calculateStat(PokemonStat.ATK, base.ATKBaseStat, _ATKiv, _ATKev, _level, _nature);
			_DEF = PokemonStat.calculateStat(PokemonStat.DEF, base.DEFBaseStat, _DEFiv, _DEFev, _level, _nature);
			_SPATK = PokemonStat.calculateStat(PokemonStat.SPATK, base.SPATKBaseStat, _SPATKiv, _SPATKev, _level, _nature);
			_SPDEF = PokemonStat.calculateStat(PokemonStat.SPDEF, base.SPDEFBaseStat, _SPDEFiv, _SPDEFev, _level, _nature);
			_SPEED = PokemonStat.calculateStat(PokemonStat.SPEED, base.SPEEDBaseStat, _SPEEDiv, _SPEEDev, _level, _nature);
		}
		
		public function get ACTIVE():Boolean
		{
			return _active;
		}
		
		/*
		 * An activated Pokémon is one that is currently in the battle
		 */
		public function get ACTIVATED():Boolean
		{
			return _activated;
		}
		
		public function get LEVELLED_UP():Boolean
		{
			return _levelledUp;
		}
		
		public function levelledUpThisBattle():void
		{
			_levelledUp = true;
		}
		
		public function activate():void
		{
			FOUGHT_LAST_POKEMON = true;
			_activated = true;
			_active = true;
		}
		
		public function setNonParticipant():void
		{
			FOUGHT_LAST_POKEMON = false;
		}
		
		public function deactivate():void
		{
			_active = false;
			clearBattleModifiers();
		}
		
		public function activateMoves():void
		{
			_move1Disabled = 0;
			_move2Disabled = 0;
			_move3Disabled = 0;
			_move4Disabled = 0;
		}
		
		public function resetStatStages():void
		{
			_ATKstage = 0;
			_DEFstage = 0;
			_SPEEDstage = 0;
			_SPATKstage = 0;
			_SPDEFstage = 0;
			_SPEEDstage = 0;
			_EVASIONstage = 0;
			_ACCURACYstage = 0;
		}
		
		public function changeStatStage(statType:String, stageDifference:int = 1):Boolean
		{
			switch (statType)
			{
				case PokemonStat.ATK: 
					if (_ATKstage >= 6 || _ATKstage <= -6)
					{
						return false;
					}
					_ATKstage += stageDifference;
					if (_ATKstage > 6)
						_ATKstage = 6;
					if (_ATKstage < -6)
						_ATKstage = -6;
					break;
				case PokemonStat.DEF: 
					if (_DEFstage >= 6 || _DEFstage <= -6)
					{
						return false;
					}
					_DEFstage += stageDifference;
					if (_DEFstage > 6)
						_DEFstage = 6;
					if (_DEFstage < -6)
						_DEFstage = -6;
					break;
				case PokemonStat.SPATK: 
					if (_SPATKstage >= 6 || _SPATKstage <= -6)
					{
						return false;
					}
					_SPATKstage += stageDifference;
					if (_SPATKstage > 6)
						_SPATKstage = 6;
					if (_SPATKstage < -6)
						_SPATKstage = -6;
					break;
				case PokemonStat.SPDEF: 
					if (_SPDEFstage >= 6 || _SPDEFstage <= -6)
					{
						return false;
					}
					_SPDEFstage += stageDifference;
					if (_SPDEFstage > 6)
						_SPDEFstage = 6;
					if (_SPDEFstage < -6)
						_SPDEFstage = -6;
					break;
				case PokemonStat.SPEED: 
					if (_SPEEDstage >= 6 || _SPEEDstage <= -6)
					{
						return false;
					}
					_SPEEDstage += stageDifference;
					if (_SPEEDstage > 6)
						_SPEEDstage = 6;
					if (_SPEEDstage < -6)
						_SPEEDstage = -6;
					break;
				case PokemonStat.EVASION: 
					if (_EVASIONstage >= 6 || _EVASIONstage <= -6)
					{
						return false;
					}
					_EVASIONstage += stageDifference;
					if (_EVASIONstage > 6)
						_EVASIONstage = 6;
					if (_EVASIONstage < -6)
						_EVASIONstage = -6;
					break;
				case PokemonStat.ACCURACY: 
					if (_ACCURACYstage >= 6 || _ACCURACYstage <= -6)
					{
						return false;
					}
					_ACCURACYstage += stageDifference;
					if (_ACCURACYstage > 6)
						_ACCURACYstage = 6;
					if (_ACCURACYstage < -6)
						_ACCURACYstage = -6;
					break;
				default: 
					trace("WARNING: Unknown stat stage \"" + statType + "\"");
					break;
			}
			
			return true;
		}
		
		/*
		 * Resets stages and VOLATILE status conditions
		 *
		 */
		public function clearBattleModifiers():void
		{
			_ATKstage = 0;
			_DEFstage = 0;
			_SPATKstage = 0;
			_SPDEFstage = 0;
			_SPEEDstage = 0;
			_EVASIONstage = 0;
			_ACCURACYstage = 0;
			
			for (var i:uint = 0; i < _switchedMoves.length; i++)
			{
				if (_MOVE1 == _switchedMoves[i][0])
					_MOVE1 = _switchedMoves[i][1];
				if (_MOVE2 == _switchedMoves[i][0])
					_MOVE2 = _switchedMoves[i][1];
				if (_MOVE3 == _switchedMoves[i][0])
					_MOVE3 = _switchedMoves[i][1];
				if (_MOVE4 == _switchedMoves[i][0])
					_MOVE4 = _switchedMoves[i][1];
			}
			
			ESCAPE_ATTEMPTS = 0;
			BIDE_COUNT = 0;
			USED_WATERSPORT = false;
			USED_MUDSPORT = false;
			SNATCHED = null;
			IMPRISONED_BY = null;
			if (_battleItemLost != "")
				_heldItem = _battleItemLost;
			_lostItem = false;
			_turnsActive = 0;
			_lastMoveUsed = 0;
			_usedMoveLength = 1;
			_lastHitBy = null;
			_lastHitByMove = 0;
			_lastTakenDamage = 0;
			_goingToUseMove = 0;
			_rageCounter = 0;
			_nDamageNumber = 1;
			OVERRIDE_TYPE = "";
			OVERRIDE_ABILITY = "";
			_battleEffects = new Vector.<String>();
			_switchedMoves = new Vector.<Array>();
			
			if (transformed != null)
			{
				var oldHealth:int = CURRENT_HP;
				DECODE_FROM_STRING(transformed.ENCODE_INTO_STRING());
				transformed = null;
				clearBattleModifiers();
				setCurrentHP(oldHealth);
			}
			
			_volatileStatusConditions.splice(0, _volatileStatusConditions.length);
		}
		
		/*
		 * Checks if the Pokémon is of a particular type
		 * Returns true is one of the Pokémon's types is given.
		 * Returns false otherwise.
		 */
		public function isType(pokemonType:String):Boolean
		{
			if (OVERRIDE_TYPE != "")
			{
				if (OVERRIDE_TYPE == pokemonType)
					return true;
				else
					return false;
			}
			return base.isType(pokemonType);
		}
		
		public function removeAllPPFromLastMove():void
		{
			if (_MOVE1 == PokemonMoves.getMoveNameByID(LAST_MOVE_USED))
			{
				_MOVE1PP = 0;
			}
			else if (_MOVE2 == PokemonMoves.getMoveNameByID(LAST_MOVE_USED))
			{
				_MOVE2PP = 0;
			}
			else if (_MOVE3 == PokemonMoves.getMoveNameByID(LAST_MOVE_USED))
			{
				_MOVE3PP = 0;
			}
			else if (_MOVE4 == PokemonMoves.getMoveNameByID(LAST_MOVE_USED))
			{
				_MOVE4PP = 0;
			}
		}
		
		private var _switchedMoves:Vector.<Array> = new Vector.<Array>();
		
		/*
		 * Replaces the indicated move with another (in battle)
		 */
		public function switchMoves(oldMoveID:int, newMoveID:int, newMovePP:int, permanent:Boolean = false):Boolean
		{
			var oldMovePP:int = 0;
			var newMoveName:String = PokemonMoves.getMoveNameByID(newMoveID);
			var oldMoveName:String = PokemonMoves.getMoveNameByID(oldMoveID);
			switch (newMoveName)
			{
				case "Chatter": 
				case "Metronome": 
				case "Sketch": 
				case "Struggle": 
					return false;
					break;
			}
			
			if (permanent == false && (newMoveID == 0 || _MOVE1 == newMoveName || _MOVE2 == newMoveName || _MOVE3 == newMoveName || _MOVE4 == newMoveName))
				return false;
			
			if (newMovePP == 0)
				newMovePP = PokemonMoves.getMovePPByID(newMoveID);
			
			if (_MOVE1 == oldMoveName)
			{
				//trace(newMoveName + " copied into 1");
				_MOVE1 = newMoveName;
				_MOVE1PP = newMovePP;
			}
			else if (_MOVE2 == oldMoveName)
			{
				//trace(newMoveName + " copied into 2");
				_MOVE2 = newMoveName;
				_MOVE2PP = newMovePP;
			}
			else if (_MOVE3 == oldMoveName)
			{
				//trace(newMoveName + " copied into 3");
				_MOVE3 = newMoveName;
				_MOVE3PP = newMovePP;
			}
			else if (_MOVE4 == oldMoveName)
			{
				//trace(newMoveName + " copied into 4");
				_MOVE4 = newMoveName;
				_MOVE4PP = newMovePP;
			}
			else
			{
				//trace(oldMoveName + " couldn't be found.");
				return false;
			}
			
			if (!permanent)
				_switchedMoves.push([newMoveName, oldMoveName]);
			
			return true;
		}
		
		public var IMPRISONED_BY:Pokemon;
		
		public function disableMove(moveInt:int, duration:int = 5):void
		{
			switch (moveInt)
			{
				case 1: 
					_move1Disabled = duration;
					break;
				case 2: 
					_move2Disabled = duration;
					break;
				case 3: 
					_move3Disabled = duration;
					break;
				case 4: 
					_move4Disabled = duration;
					break;
			}
		}
		
		public function get SLEEPING_NUMBER():int
		{
			return _sleepingNumber;
		}
		
		public function setSleepingNumber(sleepDuration:int):void
		{
			_sleepingNumber = sleepDuration;
		}
		
		public function get N_DAMAGE_NUMBER():int
		{
			return _nDamageNumber;
		}
		
		public function incrementNDamageNumber():void
		{
			_nDamageNumber++;
		}
		
		public function resetNDamageNumber():void
		{
			_nDamageNumber = 1;
		}
		
		public function loseItem():void
		{
			_lostItem = true;
			if (_battleItemLost == "")
				_battleItemLost = _heldItem;
			_heldItem = "";
		}
		
		public function setBattleStolenItem(item:String):void
		{
			if (_battleItemLost == "")
				_battleItemLost = _heldItem;
			_heldItem = item;
		}
		
		public function increaseTurnsActive():void
		{
			_turnsActive++;
		}
		
		public function get LAST_HIT_BY():Pokemon
		{
			return _lastHitBy;
		}
		
		public function get LAST_HIT_BY_MOVE():int
		{
			return _lastHitByMove;
		}
		
		public function get LAST_TAKEN_DAMAGE():int
		{
			return _lastTakenDamage;
		}
		
		public function get FRIENDSHIP():int
		{
			return _friendship;
		}
		
		public function changeLastHitBy(newPokemon:Pokemon):void
		{
			_lastHitBy = newPokemon;
		}
		
		public function changeLastTakenDamage(damage:int):void
		{
			_lastTakenDamage = damage;
		}
		
		public function changeGoingToUseMove(moveID:int):void
		{
			_goingToUseMove = moveID;
		}
		
		public function changeLastHitByMove(moveID:int):void
		{
			_lastHitByMove = moveID;
		}
		
		public function changeLastUsedMove(moveID:int):void
		{
			if (_lastMoveUsed == moveID)
				_usedMoveLength++;
			else
			{
				_usedMoveLength = 1;
				_rageCounter = 0;
			}
			_lastMoveUsed = moveID;
		}
		
		public function changeRageCounter(newVal:int):void
		{
			_rageCounter = newVal;
		}
		
		public function get RAGE_COUNTER():int
		{
			return _rageCounter;
		}
		
		public function get GOING_TO_USE_MOVE():int
		{
			return _goingToUseMove;
		}
		
		public function get LOST_ITEM():Boolean
		{
			return _lostItem;
		}
		
		public function get TURNS_ACTIVE():int
		{
			return _turnsActive;
		}
		
		public function get GENDER():String
		{
			return _gender;
		}
		
		public function get SHINY():Boolean
		{
			return _shiny;
		}
		
		public function replaceBattleEffect(oldBattleEffect:String, newBattleEffect:String):void
		{
			if (isBattleEffectActive(oldBattleEffect))
			{
				deactivateBattleEffect(oldBattleEffect);
				activateBattleEffect(newBattleEffect);
			}
		}
		
		public function isStatusConditionActive(statusCondition:PokemonStatusCondition):Boolean
		{
			for (var i:uint = 0; i < _volatileStatusConditions.length; i++)
			{
				if (_volatileStatusConditions[i] == statusCondition)
					return true;
			}
			if (_nonvolatileStatusCondition == statusCondition)
				return true;
			else
				return false;
		}
		
		public function get LAST_MOVE_USED():int
		{
			return _lastMoveUsed;
		}
		
		public function get USED_MOVE_LENGTH():int
		{
			return _usedMoveLength;
		}
		
		public function get NAME():String
		{
			return _name;
		}
		
		public function get HELDITEM():String
		{
			return _heldItem;
		}
		
		public function get ABILITY():String
		{
			if (OVERRIDE_ABILITY != "")
				return OVERRIDE_ABILITY;
			return _ability;
		}
		
		public var OVERRIDE_ABILITY:String = "";
		
		public function get LEVEL():int
		{
			return _level;
		}
		
		public function get BATTLE_EFFECTS():String
		{
			var string:String = "";
			for (var i:uint = 0; i < _battleEffects.length; i++)
			{
				string += _battleEffects[i] + ", ";
			}
			return string;
		}
		
		public function get SPEED():int
		{
			return _SPEED;
		}
		
		public function get TRAINER():Trainer
		{
			return _trainer;
		}
		
		public function isBattleEffectActive(effectType:String):Boolean
		{
			for (var i:int = 0; i < _battleEffects.length; i++)
			{
				if (_battleEffects[i] == effectType)
					return true;
			}
			return false;
		}
		
		public function areBattleEffectsActive(... args):Boolean
		{
			for (var i:int = 0; i < _battleEffects.length; i++)
			{
				for (var j:int = 0; j < args.length; j++)
				{
					if (args[j] == _battleEffects[i])
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function activateBattleEffect(effectType:String):void
		{
			if (isBattleEffectActive(effectType))
				return;
			else
			{
				_battleEffects.push(effectType);
			}
		}
		
		public function deactivateBattleEffect(effectType:String):void
		{
			for (var i:int = 0; i < _battleEffects.length; i++)
			{
				if (i >= 0 && _battleEffects[i] == effectType)
				{
					_battleEffects.splice(i, 1);
					i--;
				}
			}
		}
		
		public function getIV(statType:String):int
		{
			switch (statType)
			{
				case PokemonStat.HP: 
					return _HPiv;
					break;
				case PokemonStat.ATK: 
					return _ATKiv;
					break;
				case PokemonStat.DEF: 
					return _DEFiv;
					break;
				case PokemonStat.SPATK: 
					return _SPATKiv;
					break;
				case PokemonStat.SPDEF: 
					return _SPDEFiv;
					break;
				case PokemonStat.SPEED: 
					return _SPEEDiv;
					break;
			}
			throw(new Error('Unknown IV Stat Type "' + statType + '"!'));
			return 0;
		}
		
		public function get OTNAME():String
		{
			return _otname;
		}
		
		public function get isWild():Boolean
		{
			if (_trainer == null)
				return true;
			else
				return false;
		}
		
		public function getStatStage(statType:String):int
		{
			switch (statType)
			{
				case PokemonStat.ATK: 
					return _ATKstage;
					break;
				case PokemonStat.DEF: 
					return _DEFstage;
					break;
				case PokemonStat.SPATK: 
					return _SPATKstage;
					break;
				case PokemonStat.SPDEF: 
					return _SPDEFstage;
					break;
				case PokemonStat.SPEED: 
					return _SPEEDstage;
					break;
				case PokemonStat.EVASION: 
					return _EVASIONstage;
					break;
				case PokemonStat.ACCURACY: 
					return _ACCURACYstage;
					break;
			}
			
			throw(new Error('Unknown Stat Stage "' + statType + '"!'));
			return 0;
		}
		
		
		
		public function getRandomMove():String
		{
			var movesToChooseFrom:Array = [];
			if (_MOVE1 != "" && _MOVE1PP > 0 && _move1Disabled == 0 && (isBattleEffectActive(BattleEffect.TORMENT) == false || (isBattleEffectActive(BattleEffect.TORMENT) && PokemonMoves.getMoveIDByName(_MOVE1) != LAST_MOVE_USED)))
				movesToChooseFrom.push(_MOVE1);
			if (_MOVE2 != "" && _MOVE2PP > 0 && _move2Disabled == 0 && (isBattleEffectActive(BattleEffect.TORMENT) == false || (isBattleEffectActive(BattleEffect.TORMENT) && PokemonMoves.getMoveIDByName(_MOVE2) != LAST_MOVE_USED)))
				movesToChooseFrom.push(_MOVE2);
			if (_MOVE3 != "" && _MOVE3PP > 0 && _move3Disabled == 0 && (isBattleEffectActive(BattleEffect.TORMENT) == false || (isBattleEffectActive(BattleEffect.TORMENT) && PokemonMoves.getMoveIDByName(_MOVE3) != LAST_MOVE_USED)))
				movesToChooseFrom.push(_MOVE3);
			if (_MOVE4 != "" && _MOVE4PP > 0 && _move4Disabled == 0 && (isBattleEffectActive(BattleEffect.TORMENT) == false || (isBattleEffectActive(BattleEffect.TORMENT) && PokemonMoves.getMoveIDByName(_MOVE4) != LAST_MOVE_USED)))
				movesToChooseFrom.push(_MOVE4);
			if (movesToChooseFrom.length == 0)
				return "Struggle"; // There are no moves left to choose from!
			var rand:int = (Math.floor(Math.random() * movesToChooseFrom.length));
			//trace(movesToChooseFrom.length, movesToChooseFrom, rand);
			return movesToChooseFrom[rand];
		}
		
		public function getMovePP(moveInt:int):int
		{
			switch (moveInt)
			{
				case 1: 
					return _MOVE1PP;
					break;
				case 2: 
					return _MOVE2PP;
					break;
				case 3: 
					return _MOVE3PP;
					break;
				case 4: 
					return _MOVE4PP;
					break;
			
			}
			throw(new Error('Unknown Move int ' + moveInt));
			return 0;
		}
		
		public function getMovePPMax(moveInt:int):int
		{
			switch (moveInt)
			{
				case 1: 
					return _MOVE1PPMAX;
					break;
				case 2: 
					return _MOVE2PPMAX;
					break;
				case 3: 
					return _MOVE3PPMAX;
					break;
				case 4: 
					return _MOVE4PPMAX;
					break;
			
			}
			throw(new Error('Unknown Move int ' + moveInt));
			return 0;
		}
		
		public function getMove(moveInt:int):String
		{
			switch (moveInt)
			{
				case 1: 
					return _MOVE1;
					break;
				case 2: 
					return _MOVE2;
					break;
				case 3: 
					return _MOVE3;
					break;
				case 4: 
					return _MOVE4;
					break;
			
			}
			throw(new Error('Unknown Move int ' + moveInt));
			return "";
		}
		
		public function reduceDisableCounter():void
		{
			if (_move1Disabled > 0)
				_move1Disabled--;
			if (_move2Disabled > 0)
				_move2Disabled--;
			if (_move3Disabled > 0)
				_move3Disabled--;
			if (_move4Disabled > 0)
				_move4Disabled--;
		}
		
		public function changeUsedMoveLength(length:int):void
		{
			_usedMoveLength = length;
		}
		
		public function reducePP(moveID:int):void
		{
			if (getMove(1) == PokemonMoves.getMoveNameByID(moveID))
			{
				_MOVE1PP--;
			}
			else if (getMove(2) == PokemonMoves.getMoveNameByID(moveID))
			{
				_MOVE2PP--;
			}
			else if (getMove(3) == PokemonMoves.getMoveNameByID(moveID))
			{
				_MOVE3PP--;
			}
			else if (getMove(4) == PokemonMoves.getMoveNameByID(moveID))
			{
				_MOVE4PP--;
			}
		}
		
		public function setOTName(name:String):void
		{
			_otname = name;
		}
		
		public function setNonVolatileStatusCondition(condition:PokemonStatusCondition):void
		{
			if (condition != null && condition.TYPE != PokemonStatusConditions.NONVOLATILE)
			{
				throw(new Error('Cannot set a Pokémon\'s non-volatile status condition to a volatile condition!'));
				return;
			}
			
			_nonvolatileStatusCondition = condition;
		}
		
		public function giveVolatileStatusCondition(condition:PokemonStatusCondition):void
		{
			if (condition.TYPE != PokemonStatusConditions.VOLATILE)
			{
				throw(new Error('Cannot give a Pokémon a non-volatile status condition, must be a volatile condition!'));
				return;
			}
			
			if (isStatusConditionActive(condition))
				return;
			_volatileStatusConditions.push(condition);
		}
		
		public function removeVolatileStatusCondition(condition:PokemonStatusCondition):void
		{
			for (var i:uint = 0; i < _volatileStatusConditions.length; i++)
			{
				if (_volatileStatusConditions[i] == condition)
					_volatileStatusConditions.splice(i, 1);
			}
		}
		
		public function getVolatileStatusConditions():Vector.<PokemonStatusCondition>
		{
			return _volatileStatusConditions;
		}
		
		public function getNonVolatileStatusCondition():PokemonStatusCondition
		{
			return _nonvolatileStatusCondition;
		}
		
		public function setName(name:String):void
		{
			_name = name;
		}
		
		public function setLevel(level:int):void
		{
			_level = level;
			calculateStats();
		}
		
		public function setCurrentHP(health:int):void
		{
			_currentHP = health;
		}
		
		public function getStat(statType:String):int
		{
			switch (statType)
			{
				case PokemonStat.HP: 
					return _HP;
					break;
				case PokemonStat.ATK: 
					return _ATK;
					break;
				case PokemonStat.DEF: 
					return _DEF;
					break;
				case PokemonStat.SPEED: 
					return _SPEED;
					break;
				case PokemonStat.SPATK: 
					return _SPATK;
					break;
				case PokemonStat.SPDEF: 
					return _SPDEF;
					break;
			}
			
			throw(new Error('Unknown Stat Type "' + statType + '"!'));
			return 0;
		}
		
		public function get CURRENT_HP():int
		{
			return _currentHP;
		}
		
		public function setTrainer(trainer:Trainer):void
		{
			_trainer = trainer;
		}
		
		public function setNature(nature:String):void
		{
			_nature = nature;
		}
		
		public function setGender(gender:String):void
		{
			_gender = gender;
		}
		
		public function setHeldItem(heldItem:String):void
		{
			_heldItem = heldItem;
		}
		
		public function setRibbon(ribbon:String):void
		{
			_ribbon = ribbon;
		}
		
		public function get RIBBON():String
		{
			return _ribbon;
		}
		
		public function setShiny(shiny:Boolean):void
		{
			_shiny = shiny;
		}
		
		public function setXP(XP:int):void
		{
			_XP = XP;
		}
		
		public function giveEVs(HPev:int, ATKev:int, DEFev:int, SPATKev:int, SPDEFev:int, SPEEDev:int):void
		{
			if (transformed != null)
			{
				transformed.giveEVs(HPev, ATKev, DEFev, SPATKev, SPDEFev, SPEEDev);
				return;
			}
			while ((_HPevTEMP + HPev + _HPev > 255 || EV_TOTAL + HPev > 510) && HPev > 0)
			{
				HPev--;
			}
			
			while ((_ATKevTEMP + _ATKev + ATKev > 255 || EV_TOTAL + ATKev > 510) && ATKev > 0)
			{
				ATKev--;
			}
			
			while ((_DEFevTEMP + _DEFev + DEFev > 255 || EV_TOTAL + DEFev > 510) && DEFev > 0)
			{
				DEFev--;
			}
			
			while ((_SPATKevTEMP + _SPATKev + SPATKev > 255 || EV_TOTAL + SPATKev > 510) && SPATKev > 0)
			{
				SPATKev--;
			}
			
			while ((_SPDEFevTEMP + _SPDEFev + SPDEFev > 255 || EV_TOTAL + SPDEFev > 510) && SPDEFev > 0)
			{
				SPDEFev--;
			}
			
			while ((_SPEEDevTEMP + _SPEEDev + SPEEDev > 255 || EV_TOTAL + SPEEDev > 510) && SPEEDev > 0)
			{
				SPEEDev--;
			}
			_HPevTEMP += HPev;
			_SPEEDevTEMP += SPEEDev;
			_SPDEFevTEMP += SPDEFev;
			_SPATKevTEMP += SPATKev;
			_DEFevTEMP += DEFev;
			_ATKevTEMP += ATKev;
		}
		
		public function get EV_TOTAL():int
		{
			return _HPev + _HPevTEMP + _ATKev + _ATKevTEMP + _DEFev + _DEFevTEMP + _SPATKev + _SPATKevTEMP + _SPDEFev + _SPDEFevTEMP + _SPEEDev + _SPEEDevTEMP;
		}
		
		public function modifyEVs(stat:String, change:int, cap:int = int.MAX_VALUE):Boolean
		{
			switch (stat)
			{
				case PokemonStat.HP: 
					if (_HPev > cap)
						return false;
					_HPev += change;
					if (_HPev > cap)
						_HPev = cap;
					break;
				case PokemonStat.ATK: 
					if (_ATKev > cap)
						return false;
					_ATKev += change;
					if (_ATKev > cap)
						_ATKev = cap;
					break;
				case PokemonStat.DEF: 
					if (_DEFev > cap)
						return false;
					_DEFev += change;
					if (_DEFev > cap)
						_DEFev = cap;
					break;
				case PokemonStat.SPATK: 
					if (_SPATKev > cap)
						return false;
					_SPATKev += change;
					if (_SPATKev > cap)
						_SPATKev = cap;
					break;
				case PokemonStat.SPDEF: 
					if (_SPDEFev > cap)
						return false;
					_SPDEFev += change;
					if (_SPDEFev > cap)
						_SPDEFev = cap;
					break;
				case PokemonStat.SPEED: 
					if (_SPEEDev > cap)
						return false;
					_SPEEDev += change;
					if (_SPEEDev > cap)
						_SPEEDev = cap;
					break;
			}
			
			if (_HPev < 0)
				_HPev = 0;
			if (_ATKev < 0)
				_ATKev = 0;
			if (_DEFev < 0)
				_DEFev = 0;
			if (_SPATKev < 0)
				_SPATKev = 0;
			if (_SPDEFev < 0)
				_SPDEFev = 0;
			if (_SPEEDev < 0)
				_SPEEDev = 0;
			return true;
		}
		
		public function calculateStatDifference(statType:String):int
		{
			switch (statType)
			{
				case PokemonStat.HP: 
					return PokemonStat.calculateStat(PokemonStat.HP, base.HPBaseStat, _HPiv, _HPev + _HPevTEMP, _level, _nature) - PokemonStat.calculateStat(PokemonStat.HP, base.HPBaseStat, _HPiv, _HPev, _level, _nature);
					break;
				case PokemonStat.ATK: 
					return PokemonStat.calculateStat(PokemonStat.ATK, base.ATKBaseStat, _ATKiv, _ATKev + _ATKevTEMP, _level, _nature) - PokemonStat.calculateStat(PokemonStat.ATK, base.ATKBaseStat, _ATKiv, _ATKev, _level, _nature);
					break;
				case PokemonStat.DEF: 
					return PokemonStat.calculateStat(PokemonStat.DEF, base.DEFBaseStat, _DEFiv, _DEFev + _DEFevTEMP, _level, _nature) - PokemonStat.calculateStat(PokemonStat.DEF, base.DEFBaseStat, _DEFiv, _DEFev, _level, _nature);
					break;
				case PokemonStat.SPATK: 
					return PokemonStat.calculateStat(PokemonStat.SPATK, base.SPATKBaseStat, _SPATKiv, _SPATKev + _SPATKevTEMP, _level, _nature) - PokemonStat.calculateStat(PokemonStat.SPATK, base.SPATKBaseStat, _SPATKiv, _SPATKev, _level, _nature);
					break;
				case PokemonStat.SPDEF: 
					return PokemonStat.calculateStat(PokemonStat.SPDEF, base.SPDEFBaseStat, _SPDEFiv, _SPDEFev + _SPDEFevTEMP, _level, _nature) - PokemonStat.calculateStat(PokemonStat.SPDEF, base.SPDEFBaseStat, _SPDEFiv, _SPDEFev, _level, _nature);
					break;
				case PokemonStat.SPEED: 
					return PokemonStat.calculateStat(PokemonStat.SPEED, base.SPEEDBaseStat, _SPEEDiv, _SPEEDev + _SPEEDevTEMP, _level, _nature) - PokemonStat.calculateStat(PokemonStat.SPEED, base.SPEEDBaseStat, _SPEEDiv, _SPEEDev, _level, _nature);
					break;
			}
			
			return 0;
		}
		
		public function giveXP(XP:int):Boolean
		{
			if (transformed)
			{
				// Pass the XP through to the next Pokemon
				return transformed.giveXP(XP);
			}
			
			_XP += XP;
			if (_XP >= PokemonLevelRate.calculateXP(base.levellingRate, LEVEL + 1))
			{
				// We just levelled up!
				_level += 1;
				return true;
			}
			else
			{
				//trace("I still need " + (PokemonLevelRate.calculateXP(base.levellingRate, LEVEL + 1) - _XP) + " to level up.");
				return false;
			}
		}
		
		public function get canLearnMove():Boolean
		{
			if (getMove(1) == "")
				return true;
			if (getMove(2) == "")
				return true;
			if (getMove(3) == "")
				return true;
			if (getMove(4) == "")
				return true;
			return false;
		}
		
		public function teachMove(moveName:String, moveIndexID:int = 0):Boolean
		{
			if (moveIndexID != 0)
			{
				setMove(moveIndexID, moveName);
				return true;
			}
			if (!canLearnMove)
				return false;
			
			if (getMove(1) == "")
				setMove(1, moveName);
			else if (getMove(2) == "")
				setMove(2, moveName);
			else if (getMove(3) == "")
				setMove(3, moveName);
			else if (getMove(4) == "")
				setMove(4, moveName);
			return true;
		}
		
		private function setMove(moveSlotID:int, moveName:String):void
		{
			var moveID:int = PokemonMoves.getMoveIDByName(moveName);
			var movePP:int = PokemonMoves.getMovePPByID(moveID);
			switch (moveSlotID)
			{
				case 1: 
					_MOVE1 = moveName;
					_MOVE1PP = movePP;
					_MOVE1PPMAX = movePP;
					break;
				case 2: 
					_MOVE2 = moveName;
					_MOVE2PP = movePP;
					_MOVE2PPMAX = movePP;
					break;
				case 3: 
					_MOVE3 = moveName;
					_MOVE3PP = movePP;
					_MOVE3PPMAX = movePP;
					break;
				case 4: 
					_MOVE4 = moveName;
					_MOVE4PP = movePP;
					_MOVE4PPMAX = movePP;
					break;
			}
		}
		
		public function get REQUIRED_XP():int
		{
			return PokemonLevelRate.calculateXP(base.levellingRate, LEVEL + 1) - XP;
		}
		
		public function get LEVEL_BASE_XP():int
		{
			return PokemonLevelRate.calculateXP(base.levellingRate, LEVEL);
		}
		
		public function get NEXT_LEVEL_BASE_XP():int
		{
			return PokemonLevelRate.calculateXP(base.levellingRate, LEVEL + 1);
		}
		
		public function get LEVEL_UP_PERCENTAGE():Number
		{
			return (XP - PokemonLevelRate.calculateXP(base.levellingRate, LEVEL)) / (PokemonLevelRate.calculateXP(base.levellingRate, LEVEL + 1) - PokemonLevelRate.calculateXP(base.levellingRate, LEVEL));
		}
		
		public function finishLevellingUp():void
		{
			_HPev += _HPevTEMP;
			_ATKev += _ATKevTEMP;
			_DEFev += _DEFevTEMP;
			_SPATKev += _SPATKevTEMP;
			_SPDEFev += _SPDEFevTEMP;
			_SPEEDev += _SPEEDevTEMP;
			
			_HPevTEMP = 0;
			_ATKevTEMP = 0;
			_DEFevTEMP = 0;
			_SPATKevTEMP = 0;
			_SPDEFevTEMP = 0;
			_SPEEDevTEMP = 0;
			
			var previousHealth:int = getStat(PokemonStat.HP);
			
			calculateStats();
			
			_currentHP += (getStat(PokemonStat.HP) - previousHealth);
			
			// check for moves we can learn
			learnableMoves = base.movesFromLearnSetAtLevel(_level);
			trace("Finished levelling up:", learnableMoves);
		}
		
		public var learnableMoves:Vector.<String>;
		
		public var BIDE_COUNT:int = 0;
		public var USED_WATERSPORT:Boolean = false;
		public var USED_MUDSPORT:Boolean = false;
		public var SNATCHED:Pokemon = null;
		
		public function setAbility(ability:String):void
		{
			_ability = ability;
		}
		
		public function setFriendship(friendship:int):void
		{
			_friendship = friendship;
		}
		
		public function setDistanceWalked(steps:int):void
		{
			_distanceWalked = steps;
		}
		
		public function setIVs(HP:int, ATK:int, DEF:int, SPATK:int, SPDEF:int, SPEED:int):void
		{
			_HPiv = HP;
			_ATKiv = ATK;
			_DEFiv = DEF;
			_SPATKiv = SPATK;
			_SPDEFiv = SPDEF;
			_SPEEDiv = SPEED;
		}
		
		public function setEVs(HP:int, ATK:int, DEF:int, SPATK:int, SPDEF:int, SPEED:int):void
		{
			_HPev = HP;
			_ATKev = ATK;
			_DEFev = DEF;
			_SPATKev = SPATK;
			_SPDEFev = SPDEF;
			_SPEEDev = SPEED;
		}
		
		public function setMoves(moves:Array):void
		{
			_MOVE1 = moves.length >= 1 ? moves[0] : "";
			_MOVE2 = moves.length >= 2 ? moves[1] : "";
			_MOVE3 = moves.length >= 3 ? moves[2] : "";
			_MOVE4 = moves.length >= 4 ? moves[3] : "";
		}
		
		public function setMovePP(move1PP:int, move2PP:int = 0, move3PP:int = 0, move4PP:int = 0):void
		{
			_MOVE1PP = move1PP;
			_MOVE2PP = move2PP;
			_MOVE3PP = move3PP;
			_MOVE4PP = move4PP;
		}
		
		/*
		 * Rearranges the indicate moves in the Pokémon's data structure.
		 */
		public function swapMoves(move1:int, move2:int):void
		{
			var tmpMove1:String = this.getMove(move1);
			var tmpMove1PP:int = this.getMovePP(move1);
			var tmpMove1PPMax:int = this.getMovePPMax(move1);
			var tmpMove2:String = this.getMove(move2);
			var tmpMove2PP:int = this.getMovePP(move2);
			var tmpMove2PPMax:int = this.getMovePPMax(move2);
			
			if (move1 == 1)
			{
				_MOVE1 = tmpMove2;
				_MOVE1PP = tmpMove2PP;
				_MOVE1PPMAX = tmpMove2PPMax;
			}
			else if (move1 == 2)
			{
				_MOVE2 = tmpMove2;
				_MOVE2PP = tmpMove2PP;
				_MOVE2PPMAX = tmpMove2PPMax;
			}
			else if (move1 == 3)
			{
				_MOVE3 = tmpMove2;
				_MOVE3PP = tmpMove2PP;
				_MOVE3PPMAX = tmpMove2PPMax;
			}
			else if (move1 == 4)
			{
				_MOVE4 = tmpMove2;
				_MOVE4PP = tmpMove2PP;
				_MOVE4PPMAX = tmpMove2PPMax;
			}
			
			if (move2 == 1)
			{
				_MOVE1 = tmpMove1;
				_MOVE1PP = tmpMove1PP;
				_MOVE1PPMAX = tmpMove1PPMax;
			}
			else if (move2 == 2)
			{
				_MOVE2 = tmpMove1;
				_MOVE2PP = tmpMove1PP;
				_MOVE2PPMAX = tmpMove1PPMax;
			}
			else if (move2 == 3)
			{
				_MOVE3 = tmpMove1;
				_MOVE3PP = tmpMove1PP;
				_MOVE3PPMAX = tmpMove1PPMax;
			}
			else if (move2 == 4)
			{
				_MOVE4 = tmpMove1;
				_MOVE4PP = tmpMove1PP;
				_MOVE4PPMAX = tmpMove1PPMax;
			}
		}
		
		public function increasePP(moveID:int, increaseBy:int):void
		{
			var moveName:String = PokemonMoves.getMoveNameByID(moveID);
			if (_MOVE1 == moveName)
			{
				_MOVE1PP += increaseBy;
			}
			else if (_MOVE2 == moveName)
			{
				_MOVE2PP += increaseBy;
			}
			else if (_MOVE3 == moveName)
			{
				_MOVE3PP += increaseBy;
			}
			else if (_MOVE4 == moveName)
			{
				_MOVE4PP += increaseBy;
			}
			else
			{
				trace("WARNING: Move " + moveID + " could not be found on " + NAME + ".");
			}
			
			_MOVE1PP = _MOVE1PP >= _MOVE1PPMAX ? _MOVE1PPMAX : _MOVE1PP;
			_MOVE1PP = _MOVE2PP >= _MOVE2PPMAX ? _MOVE2PPMAX : _MOVE2PP;
			_MOVE1PP = _MOVE3PP >= _MOVE3PPMAX ? _MOVE3PPMAX : _MOVE3PP;
			_MOVE1PP = _MOVE4PP >= _MOVE4PPMAX ? _MOVE4PPMAX : _MOVE4PP;
		}
		
		public function setMovePPMax(move1PPMax:int, move2PPMax:int, move3PPMax:int, move4PPMax:int):void
		{
			_MOVE1PPMAX = move1PPMax;
			_MOVE2PPMAX = move2PPMax;
			_MOVE3PPMAX = move3PPMax;
			_MOVE4PPMAX = move4PPMax;
		}
		
		public function toString():String
		{
			return ENCODE_INTO_STRING();
			//return 'Name:' + this._name + "\n" + 'HP:' + this._HP + "\n" + 'ATK:' + this._ATK + "\n" + 'DEF:' + this._DEF + "\n" + 'SPATK:' + this._SPATK + "\n" + 'SPDEF:' + this._SPDEF + "\n" + 'SPEED:' + this._SPEED + "\n" + 'Gender:' + this._gender + "\n" + 'HeldItem:' + this._heldItem + "\n" + 'Shiny:' + this._shiny + "\n" + 'Level:' + this._level + "\n" + 'XP:' + this._XP + "\n" + 'Ability:' + this._ability + "\n" + 'Nature:' + this._nature + "\n" + 'HP IV:' + this._HPiv + "\n" + 'ATK IV:' + this._ATKiv + "\n" + 'DEF IV:' + this._DEFiv + "\n" + 'SPATK IV:' + this._SPATKiv + "\n" + 'SPDEF IV:' + this._SPDEFiv + "\n" + 'SPEED IV:' + this._SPEEDiv + "\n" + 'HP EV:' + this._HPev + "\n" + 'ATK EV:' + this._ATKev + "\n" + 'DEF EV:' + this._DEFev + "\n" + 'SPATK EV:' + this._SPATKev + "\n" + 'SPDEF EV:' + this._SPDEFev + "\n" + 'SPEED EV:' + this._SPEEDev + "\n" + 'Friendship:' + this._friendship + "\n" + 'MOVE 1:' + this._MOVE1 + " - " + this._MOVE1PP + "\n" + 'MOVE 2:' + this._MOVE2 + " - " + this._MOVE2PP + "\n" + 'MOVE 3:' + this._MOVE3 + " - " + this._MOVE3PP + "\n" + 'MOVE 4:' + this._MOVE4 + " - " + this._MOVE4PP + "\n";
		}
		
		public function earnEVs(statType:String, evNum:int = 1):void
		{
			switch (statType)
			{
				case PokemonStat.HP: 
					_HPev += evNum;
					if (_HPev >= 255)
						_HPev = 255;
					while (getEVtotal() > 510)
					{
						_HPev--;
					}
					break;
				case PokemonStat.ATK: 
					_ATKev += evNum;
					if (_ATKev >= 255)
						_ATKev = 255;
					while (getEVtotal() > 510)
					{
						_ATKev--;
					}
					break;
				case PokemonStat.DEF: 
					_DEFev += evNum;
					if (_DEFev >= 255)
						_DEFev = 255;
					while (getEVtotal() > 510)
					{
						_DEFev--;
					}
					break;
				case PokemonStat.SPATK: 
					_SPATKev += evNum;
					if (_SPATKev >= 255)
						_SPATKev = 255;
					while (getEVtotal() > 510)
					{
						_SPATKev--;
					}
					break;
				case PokemonStat.SPDEF: 
					_SPDEFev += evNum;
					if (_SPDEFev >= 255)
						_SPDEFev = 255;
					while (getEVtotal() > 510)
					{
						_SPDEFev--;
					}
					break;
				case PokemonStat.SPEED: 
					_SPEEDev += evNum;
					if (_SPEEDev >= 255)
						_SPEEDev = 255;
					while (getEVtotal() > 510)
					{
						_SPEEDev--;
					}
					break;
			}
		}
		
		public function getEVtotal():int
		{
			return _HPev + _ATKev + _DEFev + _SPATKev + _SPDEFev + _SPEEDev;
		}
	
	}

}