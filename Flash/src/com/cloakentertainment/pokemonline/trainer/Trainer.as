package com.cloakentertainment.pokemonline.trainer
{
	import adobe.utils.CustomActions;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonFactory;
	import com.cloakentertainment.pokemonline.stats.PokemonItems;
	import com.cloakentertainment.pokemonline.stats.StatManager;
	import com.cloakentertainment.pokemonline.world.PlayerManager;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class Trainer
	{
		private var _uid:String = "";
		private var _name:String = "";
		private var _type:String = TrainerType.HERO_MALE;
		private var _money:int = 3000;
		private var _secondsplayed:int = 0;
		private var _level:int = 0; // This is calculated based on the user's party
		private var _xTile:int = 0;
		private var _yTile:int = 0;
		private var _map:String;
		private var _lastPokemonCenterXTile:int = 133;
		private var _lastPokemonCenterYTile:int = 297;
		
		private var _badges:Vector.<String> = new Vector.<String>();
		private var _seenPokemon:Vector.<int> = new Vector.<int>();
		private var _ownedPokemon:Vector.<int> = new Vector.<int>();
		private var _battles:Vector.<TrainerBattle> = new Vector.<TrainerBattle>();
		private var _currentParty:Vector.<Pokemon> = new Vector.<Pokemon>();
		private var _items:Vector.<String> = new Vector.<String>();
		private var _quests:Vector.<String> = new Vector.<String>();
		private var _states:Object = new Object();
		
		private var _winnings:int = 0;
		private var _inBattle:Boolean = false;
		
		public function Trainer(name:String, type:String, uid:String, secondsplayed:int, money:int, xTile:int, yTile:int, map:String, quests:Vector.<String>, items:Vector.<String>, badges:Vector.<String>, seenPokemon:Vector.<int>, ownedPokemon:Vector.<int>, currentParty:Vector.<Pokemon>, battles:Vector.<TrainerBattle> = null, lastPokemonCenterXTile:int = 133, lastPokemonCenterYTile:int = 297)
		{
			_name = name;
			_uid = uid;
			_type = type;
			_badges = badges;
			_secondsplayed = secondsplayed;
			_items = items;
			_money = money;
			_seenPokemon = seenPokemon;
			_ownedPokemon = ownedPokemon;
			_currentParty = currentParty;
			_quests = quests;
			_battles = battles;
			_xTile = xTile;
			_yTile = yTile;
			_map = map;
			_lastPokemonCenterXTile = lastPokemonCenterXTile;
			_lastPokemonCenterYTile = lastPokemonCenterYTile;
			
			if (!_badges) _badges = new Vector.<String>();
			if (!_seenPokemon) _seenPokemon = new Vector.<int>();
			if (!_ownedPokemon) _ownedPokemon = new Vector.<int>();
			if (!_currentParty) _currentParty = new Vector.<Pokemon>();
			if (!_items) _items = new Vector.<String>();
			if (!_quests) _quests = new Vector.<String>();
		}
		
		public function destroy():void
		{
			_badges = null;
			_seenPokemon = null;
			_ownedPokemon = null;
			var i:int = 0;
			for (i = 0; i < _battles.length; i++) _battles[i].destroy();
			_battles = null;
			for (i = 0; i < _currentParty.length; i++) _currentParty[i].destroy();
			_currentParty = null;
			_items = null;
			_quests = null;
			_states = null;
			_lastAddedPokemon = null;
			_tempParty = null;
			
		}
		
		public function addPokemonToPartyFromString(data:String):void
		{
			var pokemon:Pokemon = PokemonFactory.createPokemonFromString(data);
			addPokemonToParty(pokemon);
		}
		
		private var _lastAddedPokemon:Pokemon;
		public function addPokemonToParty(pokemon:Pokemon):void
		{
			_currentParty.push(pokemon);
			_lastAddedPokemon = pokemon;
			pokemon.setTrainer(this);
			seePokemon(pokemon.base.name);
			ownPokemon(pokemon.base.name);
		}
		
		public function get LAST_ADDED_POKEMON():Pokemon
		{
			return _lastAddedPokemon;
		}
		
		public function updateLastPokemonCenterLocation(xTile:int, yTile:int):void
		{
			_lastPokemonCenterXTile = xTile;
			_lastPokemonCenterYTile = yTile;
		}
		
		public function get LAST_PC_XTILE():int
		{
			return _lastPokemonCenterXTile;
		}
		
		public function get LAST_PC_YTILE():int
		{
			return _lastPokemonCenterYTile;
		}
		
		public function enterBattle():void
		{
			if (_inBattle) return;
			
			// This makes a temporary copy of the currentParty - to be restored once the battle is over
			_inBattle = true;
			
			_tempParty = new Vector.<Pokemon>();
			for (var i:int = 0; i < _currentParty.length; i++)
			{
				_tempParty.push(_currentParty[i]);
			}
		}
		
		public function catchPokemon(pokemon:Pokemon):void
		{
			_lastAddedPokemon = pokemon;
			pokemon.setTrainer(this);
			seePokemon(pokemon.base.name);
			ownPokemon(pokemon.base.name);
			if (_inBattle)
			{
				_tempParty.push(pokemon);
			} else
			{
				_currentParty.push(pokemon);
			}
		}
		
		private var _tempParty:Vector.<Pokemon>;
		
		public function exitBattle():void
		{
			if (!_inBattle) return;
			
			_inBattle = false;
			
			_currentParty = new Vector.<Pokemon>();
			
			for (var i:int = 0; i < _tempParty.length; i++)
			{
				_tempParty[i].setNonParticipant();
				_tempParty[i].deactivate();
				_tempParty[i].clearBattleModifiers();
				_currentParty.push(_tempParty[i]);
			}
			
			_tempParty.splice(0, _tempParty.length);
			_tempParty = null;
		
		}
		
		public function incrementSteps():void
		{
			for (var i:int = 0; i < _currentParty.length; i++) _currentParty[i].incrementSteps();
		}
		
		public function getInventory(itemType:String):Vector.<String>
		{
			var inv:Vector.<String> = new Vector.<String>();
			for (var i:int = 0; i < _items.length; i++)
			{
				if (PokemonItems.isItemOfType(_items[i], itemType))
					inv.push(_items[i]);
			}
			
			return inv;
		}
		
		public function getNumberOfItems(itemName:String):int
		{
			var count:int = 0;
			for (var i:int = 0; i < _items.length; i++) if (_items[i] == itemName) count++;
			return count;
		}
		
		public function giveItem(item:String):void
		{
			_items.push(item);
		}
		
		public function hasItem(item:String):Boolean
		{
			for (var i:int = 0; i < _items.length; i++)
			{
				if (_items[i] == item) return true;
			}
			
			return false;
		}
		
		public function consumeItem(item:String):Boolean
		{
			for (var i:int = 0; i < _items.length; i++)
			{
				if (_items[i] == item)
				{
					_items.splice(i, 1);
					return true;
				}
			}
			
			return false;
		}
		
		public function recalculateLevel():void
		{
			var sum:int = 0;
			for (var i:int = 0; i < _currentParty.length; i++)
			{
				sum += _currentParty[i].LEVEL;
			}
			
			_level = Math.floor(sum / _currentParty.length);
		}
		
		private var _clockactivated:Boolean = false;
		
		public function activateClock():void
		{
			if (_clockactivated)
				return;
			
			_clockactivated = true;
			setTimeout(incrementClock, 1000);
		}
		
		private function incrementClock():void
		{
			_secondsplayed++;
			
			if (_clockactivated == false)
				return;
			else
				setTimeout(incrementClock, 1000);
		}
		
		public function deactivateClock():void
		{
			_clockactivated = false;
		}
		
		public function get SECONDS_PLAYED():int
		{
			return _secondsplayed;
		}
		
		public function giveMoney(amount:int):void
		{
			_money += amount;
		}
		
		/*
		 * Deducts the amount from the Trainer's money balance, returns false if the transaction was unsuccessful (not enough cash).
		 */
		public function takeMoney(amount:int):Boolean
		{
			if (_money - amount < 0)
				return false;
			
			_money -= amount;
			return true;
		}
		
		/*
		 * Formats the seconds that this Trainer has played into HH:MM format.
		 */
		public function get TIME_PLAYED_HHMM():String
		{
			var minutes:Number = _secondsplayed / 60;
			var hours:int = 0;
			while (minutes >= 60)
			{
				hours++;
				minutes -= 60;
			}
			return (hours < 10 ? "0" : "") + Math.floor(hours) + ":" + (minutes < 10 ? "0" : "") + Math.floor(minutes);
		}
		
		public function get MONEY():int
		{
			return _money;
		}
		
		public function get UID():String
		{
			return _uid;
		}
		
		public function get TYPE():String
		{
			return _type;
		}
		
		public function loadBattle(battleNumber:int = 1):TrainerBattle
		{
			if (battleNumber < 1 || battleNumber > _battles.length)
				throw(new Error("Battle number " + battleNumber + " out of range " + _battles.length));
			// set the current party to the party outlined in the TrainerBattle
			if (!_currentParty)
				_currentParty = new Vector.<Pokemon>();
			_currentParty.splice(0, _currentParty.length);
			
			var trainerBattle:TrainerBattle = _battles[battleNumber - 1];
			for (var i:int = 0; i < trainerBattle.POKEMON_NAMES.length; i++)
			{
				var pokemon:Pokemon = PokemonFactory.createPokemon(trainerBattle.POKEMON_NAMES[i], trainerBattle.POKEMON_LEVELS[i], "Trainer's Pokémon");
				pokemon.setTrainer(this);
				pokemon.setOTName(NAME);
				_currentParty.push(pokemon);
			}
			
			recalculateLevel();
			
			_winnings = trainerBattle.WINNINGS;
			_losingTextQuote = trainerBattle.LOSING_TEXT_QUOTE;
			
			return _battles[battleNumber - 1];
		}
		
		public function prepareTrainerBattle(losingQuote:String):void
		{
			_winnings = MONEY;
			
			_losingTextQuote = losingQuote;
		}
		
		public function get WINNINGS():int
		{
			return _winnings;
		}
		
		public function get X_TILE():int
		{
			return _xTile;
		}
		
		public function get Y_TILE():int
		{
			return _yTile;
		}
		
		private var _losingTextQuote:String;
		
		public function get LOSING_TEXT_QUOTE():String
		{
			// What the trainer says when he loses
			return _losingTextQuote;
		}
		
		public function updateLocation(xTile:int, yTile:int, mapType:String = ""):void
		{
			_xTile = xTile;
			_yTile = yTile;
			if (mapType != "") _map = mapType;
		}
		
		public function get MAP():String
		{
			return _map;
		}
		
		public function setUID(uid:String):void
		{
			_uid = uid;
		}
		
		public function assignQuest(quest:String):void
		{
			if (hasQuest(quest)) return;
			
			_quests.push(quest);
		}
		
		public function completeQuest(quest:String):void
		{
			for (var i:int = 0; i < _quests.length; i++)
			{
				if (_quests[i] == quest)
					_quests.splice(i, 1);
			}
		}
		
		public function hasQuest(quest:String):Boolean
		{
			for (var i:int = 0; i < _quests.length; i++)
			{
				if (_quests[i] == quest) return true;
			}
			
			return false;
		}
		
		public var initialDirection:String = "";
		
		public function ENCODE_INTO_STRING():String
		{
			var string:String = "";
			var _badgeString:String = "";
			var _seenPokemonString:String = "";
			var _ownedPokemonString:String = "";
			var _itemsString:String = "";
			var _questsString:String = "";
			var i:uint = 0;
			for (i = 0; i < _badges.length; i++)
				_badgeString += _badges[i] + "_";
			for (i = 0; i < _seenPokemon.length; i++)
				_seenPokemonString += _seenPokemon[i] + "_";
			for (i = 0; i < _ownedPokemon.length; i++)
				_ownedPokemonString += _ownedPokemon[i] + "_";
			for (i = 0; i < _items.length; i++)
				_itemsString += _items[i] + "_";
			for (i = 0; i < _quests.length; i++)
				_questsString += _quests[i] + "_";
			
			var _statesString:String = "";
			var key:String;
			for (key in _states) {
				_statesString += "_" + key + "||" + _states[key];
			}
			var _statsString:String = "";
			for (key in StatManager.STATS)
			{
				_statsString += "_" + key + "||" + StatManager.STATS[key];
			}
				
			string += "NAME=" + _name;
			string += "&BADGES=" + _badgeString;
			string += "&SEENPOKEMON=" + _seenPokemonString;
			string += "&OWNEDPOKEMON=" + _ownedPokemonString;
			string += "&ITEMS=" + _itemsString;
			string += "&TYPE=" + _type;
			string += "&SECONDS_PLAYED=" + _secondsplayed;
			string += "&UID=" + _uid;
			string += "&MONEY=" + _money;
			string += "&XTILE=" + _xTile;
			string += "&YTILE=" + _yTile;
			string += "&QUESTS=" + _questsString;
			string += "&MAP=" + _map;
			string += "&STATES=" + _statesString;
			string += "&STATS=" + _statsString;
			string += "&LPCX=" + _lastPokemonCenterXTile;
			string += "&LPCY=" + _lastPokemonCenterYTile;
			string += "&TURN=" + (PlayerManager.PLAYER ? PlayerManager.PLAYER.DIRECTION : "");
			
			return string;
		}
		
		public function DECODE_FROM_STRING(string:String):void
		{
			var rows:Array = string.split("&");
			if (rows.length <= 4) throw(new Error("Malformed encoded Trainer string."));
			for (var i:uint = 0; i < rows.length; i++)
			{
				var row:Array = String(rows[i]).split("=");
				var key:String = row[0];
				var data:String = row[1];
				if (key == "NAME")
					_name = data;
				else if (key == "BADGES" || key == "SEENPOKEMON" || key == "OWNEDPOKEMON" || key == "ITEMS" || key == "QUESTS" || key == "STATES" || key == "STATS")
				{
					var components:Array = data.split("_");
					for (var j:uint = 0; j < components.length; j++)
					{
						var keyValueArray:Array;
						if (components[j] == "")
							continue;
						if (key == "BADGES")
							_badges.push(components[j]);
						else if (key == "SEENPOKEMON")
							_seenPokemon.push(components[j]);
						else if (key == "OWNEDPOKEMON")
							_ownedPokemon.push(components[j]);
						else if (key == "ITEMS")
							_items.push(components[j]);
						else if (key == "QUESTS")
							_quests.push(components[j]);
						else if (key == "STATES")
						{
							// get key/value pair
							keyValueArray = String(components[j]).split("||");
							if (keyValueArray[0] != "" && keyValueArray.length >= 2) _states[keyValueArray[0]] = keyValueArray[1];
						}
						else if (key == "STATS")
						{
							keyValueArray = String(components[j]).split("||");
							if (keyValueArray[0] != "" && keyValueArray.length >= 2) 
							{
								StatManager.STATS[keyValueArray[0]] = int(keyValueArray[1]);
							}
						}
					}
				}
				else if (key == "MAP")
				{
					_map = data;
				} else if (key == "TURN")
				{
					initialDirection = data;
				}
				else if (key == "TYPE")
				{
					_type = data;
				}
				else if (key == "MONEY")
				{
					_money = int(data);
				}
				else if (key == "UID")
				{
					_uid = data;
				}
				else if (key == "SECONDS_PLAYED")
				{
					_secondsplayed = int(data);
				}
				else if (key == "XTILE")
				{
					_xTile = int(data);
				}
				else if (key == "YTILE")
				{
					_yTile = int(data);
				} else if (key == "LPCX")
				{
					_lastPokemonCenterXTile = int(data);
				} else
				if (key == "LPCY")
				{
					_lastPokemonCenterYTile = int(data);
				}
			}
		}
		
		public function get NAME():String
		{
			return _name;
		}
		
		public function setName(name:String):void
		{
			_name = name;
		}
		
		public function getState(stateKey:String):String
		{
			if (_states.hasOwnProperty(stateKey) == false) return "";
			return _states[stateKey];
		}
		
		public function setState(stateKey:String, value:String):void
		{
			_states[stateKey] = value;
		}
		
		public function setMap(map:String):void
		{
			_map = map;
		}
		
		public function setType(type:String):void
		{
			_type = type;
		}
		
		public function getPokemon(partyIndex:int = 0):Pokemon
		{
			if (partyIndex < 0 || partyIndex >= _currentParty.length)
				return null;
			return _currentParty[partyIndex];
		}
		
		public function getParty():Vector.<Pokemon>
		{
			return _currentParty;
		}
		
		public function getPartySize():int
		{
			return _currentParty.length;
		}
		
		public function getTemporaryParty():Vector.<Pokemon>
		{
			return _tempParty;
		}
		
		public function switchPokemon(i1:int, i2:int):void
		{
			if (i1 < 0 || i2 < 0 || i1 > 6 || i2 > 6)
				return;
			var pokemon1:Pokemon = getPokemon(i1);
			var pokemon2:Pokemon = getPokemon(i2);
			
			_currentParty[i1] = pokemon2;
			_currentParty[i2] = pokemon1;
		}
		
		public function updateParty(newParty:Vector.<Pokemon>):void
		{
			_currentParty = newParty;
			
			recalculateLevel();
		}
		
		public function hasBadge(badgeType:String):Boolean
		{
			if (!_badges) return true;
			
			for (var i:uint = 0; i < _badges.length; i++)
			{
				if (_badges[i] == badgeType)
					return true;
			}
			
			return false;
		}
		
		public function restAllPokemon():void
		{
			for (var i:int = 0; i < _currentParty.length; i++)
			{
				_currentParty[i].rest();
			}
		}
		
		public function seePokemon(pokemonName:String):void
		{
			var found:Boolean = false;
			var pokemonID:int = PokemonFactory.getPokemonIDFromName(pokemonName);
			for (var i:uint = 0; i < _seenPokemon.length; i++)
			{
				if (_seenPokemon[i] == pokemonID)
					found = true;
			}
			
			if (!found)
				_seenPokemon.push(pokemonID);
		}
		
		public function seenPokemon(pokemonName:String):Boolean
		{
			var pokemonID:int = PokemonFactory.getPokemonIDFromName(pokemonName);
			for (var i:uint = 0; i < _seenPokemon.length; i++)
			{
				if (_seenPokemon[i] == pokemonID)
					return true;
			}
			
			return false;
		}
		
		public function ownedPokemon(pokemonName:String):Boolean
		{
			var pokemonID:int = PokemonFactory.getPokemonIDFromName(pokemonName);
			for (var i:uint = 0; i < _ownedPokemon.length; i++)
			{
				if (_ownedPokemon[i] == pokemonID)
					return true;
			}
			
			return false;
		}
		
		public function numberOfSeenPokemon():int
		{
			return _seenPokemon.length;
		}
		
		public function numberOfOwnedPokemon():int
		{
			return _ownedPokemon.length;
		}
		
		public function getTotalNumberOfItems():int
		{
			return _items.length;
		}
		
		public function ownPokemon(pokemonName:String):void
		{
			var pokemonID:int = PokemonFactory.getPokemonIDFromName(pokemonName);
			var found:Boolean = false;
			for (var i:uint = 0; i < _ownedPokemon.length; i++)
			{
				if (_ownedPokemon[i] == pokemonID)
					found = true;
			}
			
			if (!found)
				_ownedPokemon.push(pokemonID);
		}
	
	}

}