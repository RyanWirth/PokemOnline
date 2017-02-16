package com.cloakentertainment.pokemonline.world.entity
{
	import com.cloakentertainment.pokemonline.battle.BattleManager;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.multiplayer.MultiplayerManager;
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonBerry;
	import com.cloakentertainment.pokemonline.stats.PokemonItems;
	import com.cloakentertainment.pokemonline.stats.StatManager;
	import com.cloakentertainment.pokemonline.stats.StatType;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.cloakentertainment.pokemonline.ui.MenuType;
	import com.cloakentertainment.pokemonline.ui.Message;
	import com.cloakentertainment.pokemonline.ui.MessageCenter;
	import com.cloakentertainment.pokemonline.world.entity.*;
	import com.cloakentertainment.pokemonline.world.map.ChunkManager;
	import com.cloakentertainment.pokemonline.battle.BattleType;
	import com.cloakentertainment.pokemonline.battle.BattleSpecialTile;
	import com.cloakentertainment.pokemonline.battle.BattleWeatherEffect;
	import com.cloakentertainment.pokemonline.world.map.LayerType;
	import com.cloakentertainment.pokemonline.world.map.MapManager;
	import com.cloakentertainment.pokemonline.world.PlayerManager;
	import com.cloakentertainment.pokemonline.world.region.RegionManager;
	import com.cloakentertainment.pokemonline.world.sprite.*;
	import com.cloakentertainment.pokemonline.world.tile.Tile;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import io.arkeus.tiled.TiledObject;
	import playerio.Message;
	import starling.display.MovieClip;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class EntityManager
	{
		private static var _entities:Vector.<Entity>;
		private static var _entityObjects:Vector.<TiledObject>;
		
		public static var _animateDoorUponLoad:Boolean = false;
		
		private static const _linkageReferences:Array = [ETree, EDevonCorpMale, EMan3Male, EWoman2Female, EBoat, EHatMan3Male, EScottMale, EBaldMan1Male, EWallyMale, ENormanMale, EWoman1Female, EBerryAguav, EBerryAspear, EBerryBelue, EBerryBluk, EBerryCheri, EBerryChesto, EBerryCornn, EBerryDurin, EBerryFigy, EBerryGrepa, EBerryHondew, EBerryIapapa, EBerryKelpsy, EBerryLeppa, EBerryLum, EBerryMago, EBerryMagost, EBerryNanab, EBerryNomel, EBerryOran, EBerryPamtre, EBerryPecha, EBerryPersim, EBerryPinap, EBerryPomeg, EBerryQualot, EBerryRabuta, EBerryRawst, EBerryRazz, EBerrySitrus, EBerrySpelon, EBerryTamato, EBerryWatmel, EBerryWepear, EBerryWiki, EChild1Male, EHatMan2Male, ENotebook, EHatMan1Male, EMan2Male, EPokemonCenterNurseFemale, EMan1Male, EPokemart1Female, EPokemart2Female, EHatKid1Male, EVigoroth1, EVigoroth2, EMotherFemale, EZigzagoon, EBag, EItem, ELabAideMale, ELittleGirlFemale, EAquaAdminFemale, EAquaAdminMale, EAquaGruntFemale, EAquaGruntMale, EAquaLeaderMale, EArenaTycoonFemale, EAromaLadyFemale, EBattleGirlFemale, EBroMale, EBugManiacMale, EDomeAceMale, EDragonTamerMale, EExpertFemale, EExpertMale, EFactoryHeadMale, EHeroFemale, EHeroMale, EHexManiacFemale, EInterviewerFemale, EInterviewerMale, EKindlerMale, ELadyFemale, ELassFemale, EMagmaAdminFemale, EMagmaAdminMale, EMagmaGruntFemale, EMagmaGruntMale, ENinjaBoyMale, EOldCoupleFemale, EOldCoupleMale, EPalaceMavenMale, EParasolLadyFemale, EPikeQueenFemale, EPokemonBreederFemale, EPokemonBreederMale, EPokemonRangerFemale, EPokemonRangerMale, EProfessorBirchMale, EPyramidKingMale, ERichBoy1Male, ERichBoy2Male, ERoundManMale, ERuinManiacMale, ESalonMavenFemale, ESisFemale, ETeammatesFemale, ETriathleteBikeFemale, ETriathleteBikeMale, ETriathleteRunFemale, ETriathleteRunMale, ETriathleteSwimFemale, ETriathleteSwimMale, ETuberFemale, ETuberMale, EWinstrateVickiFemale, EWinstrateVictoriaFemale, EWinstrateVictorMale, EWinstrateVitoMale, EWinstrateViviFemale, EYoungCoupleFemale, EYoungCoupleMale];
		
		public function EntityManager()
		{
		
		}
		
		public static function destroy():void
		{
			for (var i:int = 0; i < _entities.length; i++)
			{
				destroyEntity(_entities[i]);
				_entities[i] = null;
			}
			
			for (var j:int = 0; j < _entityObjects.length; j++)
			{
				_entityObjects[j].destroy();
				_entityObjects[j] = null;
			}
			
			TweenLite.killDelayedCallsTo(moveEntity);
			
			_entities = null;
			_entityObjects = null;
			
			_questionCommandCallbacks = null;
			_questionCommandE = null;
			_questionCommandEntity = null;
			_questionCommandOptions = null;
			_pickingBerryEntity = null;
			
			if (_sPokemonCenterMachine) _sPokemonCenterMachine.removeFromParent(true);
			_sPokemonCenterMachine = null;
			
			if (_sPokemonCenterScreen) _sPokemonCenterScreen.removeFromParent(true);
			_sPokemonCenterScreen = null;
		}
		
		public static function removeEntity(e:Entity):void
		{
			for (var i:int = 0; i < _entities.length; i++)
			{
				if (_entities[i] == e)
				{
					_entities.splice(i, 1);
					destroyEntity(e);
				}
			}
			e = null;
		}
		
		public static function checkForExistingEntityObject(xTile:int, yTile:int, ignoreVisibility:Boolean = false, lookingForName:String = "", ignoreOtherEntitiesInWay:Boolean = false):void
		{
			var e:TiledObject = getEntityObjectAt(xTile, yTile, lookingForName, "entity");
			if (e == null || e.type != "entity") return;
			var entityInWay:Entity = getEntityAt(xTile, yTile);
			if (entityInWay != null && !ignoreOtherEntitiesInWay) return;
			else if (ignoreOtherEntitiesInWay && entityInWay != null && entityInWay.NAME == lookingForName) return;
			
			// check for visibility conditions!
			if (!ignoreVisibility && e.properties.properties.hasOwnProperty("visibility"))
			{
				//trace("Making sure entity is visible: " + e.properties.properties.visibility);
				if (isEntityVisible(e) == false) return;
			}
			
			var className:String = e.properties.properties["class"];
			var makeInvisibleOnCreation:Boolean = false;
			var initialFrame:int = 0;
			if (className == "%RIVALCLASS%")
			{
				if (Configuration.ACTIVE_TRAINER.TYPE == TrainerType.HERO_FEMALE) className = "EHeroMale";
				else className = "EHeroFemale";
			}
			else if (className == "%BERRY%")
			{
				// Lookup the type of berry from the states
				var berryState:String = "B" + xTile + "x" + yTile;
				if (Configuration.ACTIVE_TRAINER.getState(berryState) != "")
				{
					// stored as: [Name]-[timecode]-stage1watered-stage2watered-stage3watered-stage4watered
					var berryData:Array = String(Configuration.ACTIVE_TRAINER.getState(berryState)).split("-");
					className = berryData[0] != "Unset" ? "EBerry" + berryData[0] : "EBerryWatmel";
					if (berryData[0] == "Unset") makeInvisibleOnCreation = true;
					var dT:int = (new Date()).time / 1000 - int(berryData[1]);
					var berryTimePeriod:int = PokemonBerry.getFullGrowthTime(berryData[0]) / 4;
					trace("Berry state exists for " + berryState, dT, berryTimePeriod, berryData);
					if (dT <= berryTimePeriod) initialFrame = 0;
					else if (dT <= berryTimePeriod * 2) initialFrame = 1;
					else if (dT <= berryTimePeriod * 3) initialFrame = 2;
					else if (dT <= berryTimePeriod * 4) initialFrame = 3;
					else if (dT <= berryTimePeriod * 8) initialFrame = 4;
					else
					{
						// Reset the timestamp!
						initialFrame = 1;
						Configuration.ACTIVE_TRAINER.setState(berryState, berryData[0] + "-" + (dT - berryTimePeriod * 8) + "-" + berryData[2] + "-" + berryData[3] + "-" + berryData[4] + "-" + berryData[5]);
					}
				}
				else
				{
					if (e.properties.properties.initial != "Unset")
						className = "EBerry" + e.properties.properties.initial;
					else
					{
						className = "EBerryWatmel";
						makeInvisibleOnCreation = true;
						
					}
					initialFrame = 4;
					trace("Berry state does not exist for " + berryState, className);
				}
			}
			
			var cl:Class = getDefinitionByName("com.cloakentertainment.pokemonline.world.entity." + className) as Class;
			
			var entity:Entity = createEntity(cl, xTile, yTile, className.substr(0, 6) != "EBerry" ? AnimationType.WALK_DOWN : "", false, "", true);
			cl = null;
			if (!entity)
				return;
			
			if (makeInvisibleOnCreation) entity.visible = false;
			entity.currentFrame = initialFrame;
			entity.alpha = 0;
			entity.isOtherPlayer = false;
			entity.setName(e.name, false);
			TweenLite.to(entity, 0.25, {alpha: 1});
			
			if (e.properties.properties.hasOwnProperty("direction")) entity.turn(e.properties.properties.direction);
			if (e.properties.properties.hasOwnProperty("onVisible")) addCommand(e.properties.properties.onVisible, e, entity, true);
			var i:int = 2;
			while (true)
			{
				if (e.properties.properties.hasOwnProperty("onVisible" + i))
				{
					addCommand(e.properties.properties["onVisible" + i], e, entity, false, true);
					i++;
				}
				else break;
			}
			
			e = null;
			entity = null;
		}
		
		private static function isEntityVisible(e:TiledObject):Boolean
		{
			var visibilityString:String = e.properties.properties.visibility;
			var visData:Array = visibilityString.split(";");
			var isVisible:Boolean = true;
			var subcommand:Array;
			var key:String;
			var stateKey:String;
			var stateValue:String;
			for (var i:int = 0; i < visData.length; i++)
			{
				if (visData[i] == "") continue;
				subcommand = String(visData[i]).split("::");
				if (subcommand.length < 3) continue;
				key = subcommand[0];
				stateKey = subcommand[1];
				stateValue = subcommand[2];
				if (key == "" || stateKey == "" || stateValue == "") continue;
				
				//trace("Checking " + key + " with " + stateKey + " against " + stateValue + ": " + Configuration.ACTIVE_TRAINER.getState(stateKey));
				
				if (key == "if")
				{
					
					if (Configuration.ACTIVE_TRAINER.getState(stateKey) != stateValue) isVisible = false;
				}
				else if (key == "ifnot")
				{
					if (Configuration.ACTIVE_TRAINER.getState(stateKey) == stateValue) isVisible = false;
				}
			}
			
			return isVisible;
		}
		
		public static function prepareEntityObjects(_objects:Vector.<TiledObject>):void
		{
			_entityObjects = _objects;
			if (!_entityObjects) return;
			
			for (var i:int = 0, l:int = _entityObjects.length; i < l; i++)
			{
				_entityObjects[i].x = Math.floor(_entityObjects[i].x / 16);
				_entityObjects[i].y = Math.floor(_entityObjects[i].y / 16);
				
					//trace(_entityObjects[i].name, _entityObjects[i].type, _entityObjects[i].x, _entityObjects[i].y);
			}
		}
		
		public static function getEntityObjectAt(xTile:int, yTile:int, lookingForName:String = "", lookingForType:String = "", activatableEntitiesOnly:Boolean = false):TiledObject
		{
			var object:TiledObject;
			for (var i:int = 0, l:int = _entityObjects.length; i < l; i++)
			{
				object = _entityObjects[i];
				if (object.x == xTile && object.y == yTile)
				{
					if (lookingForName == "" || (lookingForName != "" && object.name == lookingForName))
					{
						if (lookingForType == "" || (lookingForType != "" && object.type == lookingForType))
						{
							if (!activatableEntitiesOnly) return object;
							else
							{
								if (object.type != "script" && object.type != "door") return object;
							}
						}
					}
				}
			}
			
			return null;
		}
		
		public static function getEntityObjectWithName(name:String):TiledObject
		{
			for (var i:int = 0, l:int = _entityObjects.length; i < l; i++)
			{
				if (_entityObjects[i].name == name) return _entityObjects[i];
			}
			
			return null;
		}
		
		public static function getEntityAt(xTile:int, yTile:int, lookingForName:String = "", npcsOnly:Boolean = false):Entity
		{
			if (!_entities) return null;
			
			for (var i:int = 0, l:int = _entities.length; i < l; i++)
			{
				if (_entities[i].X_TILE == xTile && _entities[i].Y_TILE == yTile)
				{
					if (npcsOnly && (_entities[i].isOtherPlayer || PlayerManager.PLAYER == _entities[i])) continue;
					
					if (lookingForName == "" || (lookingForName != "" && _entities[i].NAME == lookingForName)) return _entities[i];
				}
			}
			
			return null;
		}
		
		public static function isEntityAt(xTile:int, yTile:int, onlyNPCs:Boolean = false, checkAgainst:Entity = null):Boolean
		{
			for (var i:int = 0, l:int = _entities.length; i < l; i++)
			{
				if (_entities[i].X_TILE == xTile && _entities[i].Y_TILE == yTile)
				{
					if (onlyNPCs && _entities[i].isOtherPlayer == false)
					{
						if (checkAgainst != null && _entities[i] != checkAgainst) return true;
						else if (checkAgainst == null) return true;
					}
					else if (!onlyNPCs) return true;
				}
			}
			
			return false;
		}
		
		public static function createEntity(entityClass:Class, xTile:int, yTile:int, initialAnimation:String = AnimationType.WALK_DOWN, isPlayer:Boolean = false, name:String = "", ignoreEntitiesInWay:Boolean = false):Entity
		{
			if (!_entities) _entities = new Vector.<Entity>();
			
			if (!isPlayer && isEntityAt(xTile, yTile) && !ignoreEntitiesInWay) 
			{
				trace("Attempted creation of", entityClass, xTile, yTile);
				return null;
			}
			
			var entity:Entity = new entityClass() as Entity;
			entity.x = (xTile + 0.5) * ChunkManager.TILE_SIZE;
			entity.y = yTile * ChunkManager.TILE_SIZE;
			if (initialAnimation != "") entity.animate(initialAnimation);
			entity.updateLocation(xTile, yTile);
			entity.setName(name);
			entity.className = getQualifiedClassName(entityClass);
			_entities.push(entity);
			ChunkManager.addEntity(entity);
			entity.stop();
			
			sortEntitiesByDepth();
			
			if (isPlayer)
			{
				animateTile(xTile, yTile - 1, entity, true);
			}
			
			return entity;
		}
		
		public static function destroyEntity(entity:Entity):void
		{
			if (entity == null) return;
			
			ChunkManager.removeEntity(entity);
			TweenLite.killTweensOf(entity);
			TweenLite.killDelayedCallsTo(entity.finishMoving);
			
			var e:TiledObject = getEntityObjectAt(entity.X_TILE, entity.Y_TILE);
			if (e) e.commands = new Vector.<String>();
			
			entity.destroy();
		}
		
		public static function moveEntity(e:Entity, direction:String, xTileOverride:int = -1, yTileOverride:int = -1, callback:Function = null, callbackParams:Array = null, overrideImmobilization:Boolean = false):void
		{
			if (e.MOBILE == false && !overrideImmobilization) return;
			if (e.destroyed) return;
			
			var dX:int;
			var dY:int;
			
			if (xTileOverride != -1 && yTileOverride != -1)
			{
				dX = xTileOverride - e.X_TILE;
				dY = yTileOverride - e.Y_TILE;
				if (dX > 0) direction = "right";
				else if (dX < 0) direction = "left";
				else if (dY > 0) direction = "down";
				else if (dY < 0) direction = "up";
				else direction = "down";
			}
			
			// Check if the entity is already moving. If it is, cue up this movement call for their next movement direction and return.
			if (e.MOVING && (e.isOtherPlayer == true || PlayerManager.isEntityThePlayer(e)))
			{
				e.setNextMove(direction, xTileOverride, yTileOverride);
				return;
			}
			else if (e.MOVING) return;
			
			// If the entity isn't facing the movement direction and wasn't just moving (within the last 100 or so milliseconds, turn them and wait.
			if (e.DIRECTION != direction && e.JUST_MOVING == false && xTileOverride == -1)
			{
				e.turn(direction);
				if (PlayerManager.isEntityThePlayer(e)) sendOurDirection();
				e.startMoving();
				e.setNextMove("", -1, -1);
				TweenLite.delayedCall(0.2, e.finishMoving, [false]);
				return;
			}
			else if (e.DIRECTION != direction)
			{
				e.turn(direction); // The entity was just moving but isn't facing the correct direction. Therefore, turn the entity and continue with animating the entity.
				if (PlayerManager.isEntityThePlayer(e)) sendOurDirection();
			}
			
			// Determine the change in x and y from the provided "direction" string
			if (xTileOverride == -1) dX = direction == "left" ? -1 : (direction == "right" ? 1 : 0);
			if (yTileOverride == -1) dY = direction == "up" ? -1 : (direction == "down" ? 1 : 0);
			
			// Check to see if the tile can be walked on. If not, return the function and stop processing.
			if (!MapManager.isTileWalkable(e.X_TILE + dX, e.Y_TILE + dY) || !MapManager.isTileWalkable(e.X_TILE + dX, e.Y_TILE + dY, LayerType.MIDDLE)) return;
			if ((PlayerManager.isEntityThePlayer(e) || e.isOtherPlayer == false) && isEntityAt(e.X_TILE + dX, e.Y_TILE + dY, true, e))
			{
				if (callback != null && MessageCenter.isMessageOpen() == false)
				{
					TweenLite.delayedCall(0.1, moveEntity, [e, direction, xTileOverride, yTileOverride, callback, callbackParams, overrideImmobilization]);
				}
				return;
			}
			
			var entityObject:TiledObject = getEntityObjectAt(e.X_TILE, e.Y_TILE, e.NAME);
			if (entityObject && e.isOtherPlayer == false && PlayerManager.isEntityThePlayer(e) == false)
			{
				entityObject.x = e.X_TILE + dX;
				entityObject.y = e.Y_TILE + dY;
			}
			
			// Check for specially animated tiles (sand footprints)
			var bottomTileID:int = e ? MapManager.getTileIndexAt(e.X_TILE + 1, e.Y_TILE + 1, LayerType.BOTTOM) : -1;
			if (bottomTileID == 965 && e)
			{
				// Create a sand effect
				var initialFrame:int = -1;
				if (e.DIRECTION == "up") initialFrame = 0;
				else if (e.DIRECTION == "down") initialFrame = 1;
				else if (e.DIRECTION == "left") initialFrame = 2;
				else if (e.DIRECTION == "right") initialFrame = 3;
				createSprite(SSandEffect, e.X_TILE, e.Y_TILE, initialFrame, true);
			}
			
			// check for the tile being animated
			var onDoor:Boolean = animateTile(e.X_TILE + dX, e.Y_TILE + dY, e);
			
			if (onDoor)
			{
				e.stopRunning();
				e.setMoveSpeed(2);
			}
			
			// check for the tile forcing the entity to move again (ledges, etc.)
			var jumpDirection:String = MapManager.getTilePropertyAt(e.X_TILE + dX, e.Y_TILE + dY, "jumpDir");
			if (jumpDirection == "") jumpDirection = MapManager.getTilePropertyAt(e.X_TILE + dX, e.Y_TILE + dY, "jumpDir", LayerType.MIDDLE);
			if (jumpDirection != "" && direction == jumpDirection)
			{
				// We're moving in the proper direction!
				e.jump();
			}
			else if (jumpDirection != "") return; // We're not moving the proper direction, stop!
			
			// Update the entity's location
			e.updateLocation(e.X_TILE + dX, e.Y_TILE + dY);
			
			// If the entity is the player, pan the camera to the new tile and check for region changes
			if (PlayerManager.isEntityThePlayer(e))
			{
				ChunkManager.panTo(e.X_TILE, e.Y_TILE, e.MOVE_SPEED);
				RegionManager.checkForRegionChange(e.X_TILE, e.Y_TILE);
				Configuration.ACTIVE_TRAINER.updateLocation(e.X_TILE, e.Y_TILE);
				sendOurLocation();
				
				if (MapManager.MAP_TYPE == "OVERWORLD") PlayerManager.updateLastOverworldLocation(e.X_TILE, e.Y_TILE);
			}
			
			// Start the entity animating and tweening
			e.startMoving();
			e.play();
			//trace("Animating " + e.NAME, callback, callbackParams);
			var duration:Number = 1 / e.MOVE_SPEED * 60;
			duration *= dX != 0 ? Math.abs(dX) : 1;
			duration *= dY != 0 ? Math.abs(dY) : 1;
			
			TweenLite.to(e, duration, {useFrames: true, onUpdate: roundEntityMovement, onUpdateParams: [e], ease: Linear.easeNone, x: (e.X_TILE + 0.5) * ChunkManager.TILE_SIZE, y: e.Y_TILE * ChunkManager.TILE_SIZE, onComplete: finishMoving, onCompleteParams: [e, callback, callbackParams]});
		
		}
		
		public static function animateTile(xTile:int, yTile:int, e:Entity, doorsOnly:Boolean = false, stopAnimating:Boolean = false, hideGrass:Boolean = false):Boolean
		{
			var tile:Tile = ChunkManager.getAnimatedTile(xTile, yTile);
			var destroyGrassEffect:Boolean = true;
			if (tile)
			{
				// There is an animated tile here!
				if (tile.TYPE == Tile.DOOR)
				{
					tile.playThenReverse(); // Animate the door opening
					return true;
				}
				else if (tile.TYPE == Tile.GRASS && !doorsOnly)
				{
					tile.playEffect();
					createSprite(SGrassEffect, xTile, yTile);
					e.enterGrass();
					destroyGrassEffect = false;
				}
				else if (tile.TYPE == Tile.PC)
				{
					tile.flickerOn();
				}
				else if (tile.TYPE == Tile.TELEVISION)
				{
					if (stopAnimating) tile.stop();
					else tile.play();
				}
			}
			
			if (destroyGrassEffect && e) e.destroyGrass();
			
			return false;
		}
		
		public static function receivePlayerCoordinates(m:playerio.Message, xPos:int, yPos:int, name:String):void
		{
			// check if this entity already exists
			var entity:Entity;
			var foundEntity:Entity = null;
			for (var i:int = 0, l:int = _entities.length; i < l && foundEntity == null; i++)
			{
				entity = _entities[i];
				if (entity.NAME == name && entity.isOtherPlayer) foundEntity = entity;
			}
			entity = null;
			
			var dX:int = xPos - PlayerManager.PLAYER.X_TILE;
			var dY:int = yPos - PlayerManager.PLAYER.Y_TILE;
			var dist:Number = dX * dX + dY * dY;
			
			if (foundEntity == null && dist <= 529 && name != Configuration.ACTIVE_TRAINER.NAME)
			{
				// There is no entity matching this description, so we'll request this person's identity
				MultiplayerManager.CONNECTION.send("PlayerRequest", name);
			}
			else if (foundEntity != null)
			{
				if (dist <= 529)
				{
					foundEntity.setNextMove("down", xPos, yPos);
				}
				else removeEntity(foundEntity);
			}
		}
		
		public static function receivePlayerRequest(m:playerio.Message, name:String, type:String, xPos:int, yPos:int, direction:String, running:Boolean, busy:Boolean):void
		{
			// Make sure they're within our 18 block radius
			var dX:int = xPos - PlayerManager.PLAYER.X_TILE;
			var dY:int = yPos - PlayerManager.PLAYER.Y_TILE;
			var dist:Number = dX * dX + dY * dY;
			if (dist > 529) return;
			
			var cl:Class = getDefinitionByName(type) as Class;
			
			var e:Entity = createEntity(cl, xPos, yPos, "walk_" + direction, true, name);
			if (!e) return;
			e.alpha = 0;
			TweenLite.to(e, 1, {alpha: 1});
			e.isOtherPlayer = true;
			if (running) e.startRunning();
			if (busy) e.setBusy(true);
			
			// Send our location, just to be sure!
			sendOurLocation();
		}
		
		public static function receivePlayerDirectionChange(m:playerio.Message, name:String, direction:String):void
		{
			for (var i:int = 0, l:int = _entities.length; i < l; i++)
			{
				if (_entities[i].NAME == name && _entities[i].isOtherPlayer)
				{
					_entities[i].turn(direction);
					return;
				}
			}
		}
		
		public static function receivePlayerBusyState(m:playerio.Message, name:String, busy:Boolean):void
		{
			for (var i:int = 0, l:int = _entities.length; i < l; i++)
			{
				if (_entities[i].NAME == name && _entities[i].isOtherPlayer)
				{
					_entities[i].setBusy(busy);
					return;
				}
			}
		}
		
		public static function receivePlayerRunState(m:playerio.Message, name:String, running:Boolean):void
		{
			for (var i:int = 0, l:int = _entities.length; i < l; i++)
			{
				if (_entities[i].NAME == name && _entities[i].isOtherPlayer)
				{
					if (running) _entities[i].startRunning();
					else _entities[i].stopRunning();
					_entities[i].stop();
					return;
				}
			}
		}
		
		public static function receivePlayerChangeMap(m:playerio.Message, name:String):void
		{
			for (var i:int = 0, l:int = _entities.length; i < l; i++)
			{
				if (_entities[i].NAME == name && _entities[i].isOtherPlayer)
				{
					TweenLite.to(_entities[i], 0.25, {alpha: 0, onComplete: removeEntity, onCompleteParams: [_entities[i]]});
					return;
				}
			}
		}
		
		public static function createSprite(spriteClass:Class, xTile:int, yTile:int, initialFrame:int = -1, addToBottom:Boolean = false):void
		{
			var sprite:MovieClip = new spriteClass() as MovieClip;
			sprite.x = xTile * ChunkManager.TILE_SIZE;
			sprite.y = yTile * ChunkManager.TILE_SIZE;
			WorldManager.JUGGLER.add(sprite);
			ChunkManager.addEntity(sprite, addToBottom);
			
			if (initialFrame != -1) sprite.currentFrame = initialFrame;
		}
		
		private static function checkForAdjacentTrainers():void
		{
			var entity:Entity;
			var playerXTile:int = PlayerManager.PLAYER.X_TILE;
			var playerYTile:int = PlayerManager.PLAYER.Y_TILE;
			
			for (var i:int = 0; i < EntityManager._entities.length; i++)
			{
				entity = EntityManager._entities[i];
				if (entity.isTrainer())
				{
					if (checkTrainerVisibility(entity, playerXTile, playerYTile)) return;
				}
			}
		}
		
		private static function checkTrainerVisibility(entity:Entity, playerXTile:int, playerYTile:int):Boolean
		{
			var dX:int = entity.X_TILE - playerXTile;
			var dY:int = entity.Y_TILE - playerYTile;
			var entityViewDistance:int = entity.viewDistance;
			if (entity.DIRECTION == "down" && dX == 0 && dY < 0 && dY >= -entityViewDistance)
			{
				activateTrainer(entity, playerXTile, playerYTile - 1, "up", dX, dY);
				return true;
			}
			else if (entity.DIRECTION == "up" && dX == 0 && dY > 0 && dY <= entityViewDistance)
			{
				activateTrainer(entity, playerXTile, playerYTile + 1, "down", dX, dY);
				return true;
			}
			else if (entity.DIRECTION == "left" && dY == 0 && dX > 0 && dX <= entityViewDistance)
			{
				activateTrainer(entity, playerXTile + 1, playerYTile, "right", dX, dY);
				return true;
			}
			else if (entity.DIRECTION == "right" && dY == 0 && dX < 0 && dX >= -entityViewDistance)
			{
				activateTrainer(entity, playerXTile - 1, playerYTile, "left", dX, dY);
				return true;
			}
			return false;
		}
		
		private static function activateTrainer(entity:Entity, xTile:int, yTile:int, direction:String, dX:int, dY:int):void
		{
			var e:TiledObject = getEntityObjectWithName(entity.NAME);
			if (!e) throw(new Error("Entity does not exist with name: " + entity.NAME));
			if (e.activated) return;
			
			e.commands = new Vector.<String>();
			e.activated = true;
			
			if (Math.abs(dX) == 1 || Math.abs(dY) == 1)
			{
				e.commands.push("immobilizeplayer;alert;turnplayer::" + direction + ";cmd::activate");
			}
			else e.commands.push("immobilizeplayer;alert;move::" + xTile + "," + yTile + ";turnplayer::" + direction + ";cmd::activate");
			
			nextCommand(e, entity);
		}
		
		private static function finishMoving(e:Entity, callback:Function = null, callbackParams:Array = null):void
		{
			if (PlayerManager.isEntityThePlayer(e))
			{
				checkForPlayerStandingOnEntities();
				checkForAdjacentTrainers();
				
				StatManager.incrementStat(StatType.STEPS_TAKEN);
				Configuration.ACTIVE_TRAINER.incrementSteps();
				
				var tile:Tile = ChunkManager.getAnimatedTile(e.X_TILE, e.Y_TILE);
				if (tile != null && tile.TYPE == Tile.GRASS && !BattleManager.isBattleOccuring() && PlayerManager.PLAYER.MOBILE)
				{
					var wildPokemon:Pokemon = RegionManager.stepInGrass();
					if (wildPokemon != null)
					{
						// We encountered a Pokemon!
						PlayerManager.startBeingBusy();
						e.setMobility(false);
						PlayerManager.stopRunning();
						e.stop();
						BattleManager.startWildBattle(wildPokemon);
					}
				}
				
			}
			else if (e.isOtherPlayer == false && e.isTrainer())
			{
				checkTrainerVisibility(e, PlayerManager.PLAYER.X_TILE, PlayerManager.PLAYER.Y_TILE);
			}
			
			e.finishMoving();
			sortEntitiesByDepth();
			
			if (callback != null)
			{
				TweenLite.delayedCall(1, callback, callbackParams, true);
			}
		}
		
		public static function sendOurLocation():void
		{
			if (MultiplayerManager.CONNECTION != null) MultiplayerManager.CONNECTION.send("Location", PlayerManager.PLAYER.X_TILE, PlayerManager.PLAYER.Y_TILE);
		}
		
		public static function sendOurDirection():void
		{
			if (MultiplayerManager.CONNECTION != null) MultiplayerManager.CONNECTION.send("DirectionChange", PlayerManager.PLAYER.DIRECTION);
		}
		
		public static function stepOnDoor(linkage:String, spawnXT:int, spawnYT:int, initialTurn:String = "", fadeWhite:Boolean = false):void
		{
			PlayerManager.PLAYER.setMobility(false);
			PlayerManager.PLAYER.stopRunning();
			PlayerManager.PLAYER.stop();
			if (MultiplayerManager.CONNECTION != null) MultiplayerManager.CONNECTION.send("ChangeMap", linkage);
			if (initialTurn != "") PlayerManager.initialTurnDirection = initialTurn;
			TweenLite.delayedCall(0.25, WorldManager.switchOverworld, [linkage, spawnXT, spawnYT, fadeWhite]);
			return;
		}
		
		private static function checkForPlayerStandingOnEntities():void
		{
			var e:TiledObject = getEntityObjectAt(PlayerManager.PLAYER.X_TILE, PlayerManager.PLAYER.Y_TILE);
			if (e == null) return;
			
			if (e.type == "door")
			{
				// We're standing on a door!
				stepOnDoor(e.properties.properties.linkage, e.properties.properties.spawnXT, e.properties.properties.spawnYT, e.properties.properties.hasOwnProperty("turn") ? e.properties.properties.turn : "");
				return;
			}
			else if (e.type == "script")
			{
				trace("Stepped on script " + e.name);
				addCommand(e.properties.properties.onWalk, e, null);
				
				var i:int = 2;
				while (true)
				{
					if (e.properties.properties.hasOwnProperty("onWalk" + i)) addCommand(e.properties.properties["onWalk" + i], e, null);
					else break;
					i++;
				}
			}
		}
		
		private static function roundEntityMovement(e:Entity):void
		{
			e.x = Math.round(e.x);
			e.y = Math.round(e.y);
		}
		
		public static function sortEntitiesByDepth():void
		{
			_entities.sort(sortByYTile);
			
			for (var i:int = 0, l:int = _entities.length; i < l; i++)
			{
				ChunkManager.moveEntityToBack(_entities[i]);
			}
		}
		
		/** Called when the player presses the ENTER_KEY. Searches for an entity (NPC or a sign) to activate in the given direction the player is facing. */
		public static function checkForActivatableEntity(direction:String):void
		{
			var player:Entity = PlayerManager.PLAYER;
			var xTile:int = player.X_TILE;
			var yTile:int = player.Y_TILE;
			var direction:String = player.DIRECTION;
			player = null;
			
			switch (direction)
			{
			case "right": 
				xTile++;
				break;
			case "left": 
				xTile--;
				break;
			case "up": 
				yTile--;
				break;
			case "down": 
				yTile++;
				break;
			}
			
			trace("Getting entity at " + xTile + "x" + yTile, getEntityObjectAt(xTile, yTile), _entityObjects);
			activateEntity(getEntityObjectAt(xTile, yTile, "", "", true), getEntityAt(xTile, yTile));
		}
		
		public static function activateEntity(e:TiledObject, entity:Entity):void
		{
			if (e == null || e.executing || (e.type == "entity" && entity == null)) return;
			
			var i:int = 1;
			var command:String;
			while (true)
			{
				command = e.properties.properties["cmd" + i];
				if (command == null || command == "" || command == "undefined") break;
				i++;
			}
			
			for (var j:int = i - 1; j > 0; j--)
			{
				addCommand(e.properties.properties["cmd" + j], e, entity, true, false);
			}
			
			trace("Activated " + e.name);
			SoundManager.playEnterKeySoundEffect();
			e.executing = false;
			nextCommand(e, entity);
		}
		
		private static function addCommand(command:String, e:TiledObject, entity:Entity, addToFront:Boolean = false, startExecuting:Boolean = true):void
		{
			//trace("Adding " + command);
			if (!e) return;
			
			if (addToFront) e.commands.splice(0, 0, command);
			else e.commands.push(command);
			
			if (e.executing == false && startExecuting)
			{
				nextCommand(e, entity);
			}
		}
		
		private static function nextCommand(e:TiledObject, entity:Entity, forceExecution:Boolean = false):void
		{
			if (!e) return;
			
			//trace("NextCommand for " + e, e.commands.length, e.executing, forceExecution, entity != null ? entity.MOVING : "null");
			if (e.commands == null)
			{
				e.destroy();
				if (entity) entity.destroy();
				entity = null;
				e = null;
				return;
			}
			if (e.commands.length == 0)
			{
				e.executing = false;
				return;
			}
			if (e.executing && !forceExecution) return;
			if (entity != null)
			{
				e.x = entity.X_TILE;
				e.y = entity.Y_TILE;
				if (entity.MOVING && !forceExecution) return;
			}
			
			e.executing = true;
			var command:String = e.commands[0];
			e.commands.splice(0, 1);
			
			if (command == "")
			{
				e.executing = false;
				nextCommand(e, entity, forceExecution);
				return;
			}
			
			//trace("Executing command on " + e.name + ": " + command);
			executeCommand(command, e, entity);
		}
		
		public static function executeCommand(command:String, e:TiledObject, entity:Entity):void
		{
			if (command == null) return;
			
			var commandData:Array = command.split(";");
			var subcommand:String;
			var subcommandData:Array;
			var keyword:String;
			var restOfCommand:String;
			var j:int;
			var eTemp:TiledObject;
			var entityTemp:Entity;
			CommandLoop: for (var i:int = 0, l:int = commandData.length; i < l; i++)
			{
				subcommand = commandData[i];
				subcommandData = subcommand.split("::");
				keyword = subcommandData[0];
				restOfCommand = "";
				eTemp = null;
				entityTemp = null;
				
				// Assemble the rest of the command that is yet to be interpreted.
				for (j = i + 1; j < l; j++)
				{
					if (commandData[j] == "") continue;
					restOfCommand += commandData[j] + ";";
				}
				if (keyword == "") continue;
				
				switch (keyword)
				{
				case "say": 
					//e.executing = false;
					//SoundManager.playEnterKeySoundEffect();
					PlayerManager.stopRunning();
					PlayerManager.PLAYER.stop();
					RegionManager.hideRegionIcon();
					var params:Array = [e, entity, true];
					var messages:Vector.<String> = new Vector.<String>();
					// Add all the messages beside one another into the same queue. This will eliminate message flickering
					var stillConcurrent:Boolean = true;
					restOfCommand = "";
					for (j = i; j < commandData.length; j++)
					{
						subcommandData = commandData[j].split("::");
						if (stillConcurrent && subcommandData[0] == "say") messages.push(subcommandData[1]);
						else
						{
							stillConcurrent = false;
							restOfCommand += commandData[j] + ";";
						}
					}
					addCommand(restOfCommand, e, entity, true);
					for (j = 0; j < messages.length; j++)
					{
						MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage(messages[j], true, 0, j == messages.length - 1 ? nextCommand : null, 23, false, j == messages.length - 1 ? params : null));
					}
					return;
					break;
				case "turn": 
					var turnDir:String = subcommandData[1];
					if (turnDir == "player")
					{
						if (PlayerManager.PLAYER.Y_TILE < entity.Y_TILE) turnDir = "up";
						else if (PlayerManager.PLAYER.Y_TILE > entity.Y_TILE) turnDir = "down";
						else if (PlayerManager.PLAYER.X_TILE < entity.X_TILE) turnDir = "left";
						else if (PlayerManager.PLAYER.X_TILE > entity.X_TILE) turnDir = "right";
						else turnDir = entity.DIRECTION;
					}
					entityTemp = entity;
					if (subcommandData.length > 2)
					{
						var targetName:String = subcommandData[2];
						eTemp = getEntityObjectWithName(targetName);
						entityTemp = getEntityAt(eTemp.x, eTemp.y, targetName);
						if (!entityTemp) entityTemp = entity;
					}
					entityTemp.turn(turnDir);
					animateTile(entityTemp.X_TILE, entityTemp.Y_TILE, entityTemp, false, false, true);
					if (entityTemp.isTrainer())
					{
						if (e.activated == false && checkTrainerVisibility(entityTemp, PlayerManager.PLAYER.X_TILE, PlayerManager.PLAYER.Y_TILE))
						{
							nextCommand(e, entity, true);
							return;
						}
					}
					break;
				case "reset": 
					var loc:Array = String(subcommandData[1]).split(",");
					var xTile3:int = int(loc[0]);
					var yTile3:int = int(loc[1]);
					e.x = xTile3;
					e.y = yTile3;
					e.executing = false;
					removeEntity(entity);
					break;
				case "checkberry": 
					if (entity.currentFrame != 4 && entity.visible)
					{
						// The berry is not yet ripe!
						var berryUnripeData:Array = Configuration.ACTIVE_TRAINER.getState("B" + entity.X_TILE + "x" + entity.Y_TILE).split("-");
						if (entity.currentFrame == 0) MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("One " + String(berryUnripeData[0]).toUpperCase() + " BERRY was planted here.", true, 0, null, 23));
						else if (entity.currentFrame == 1) MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage(String(berryUnripeData[0]).toUpperCase() + " has sprouted.", true, 0, null, 23));
						else if (entity.currentFrame == 2) MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("This " + String(berryUnripeData[0]).toUpperCase() + " plant is growing taller.", true, 0, null, 23));
						else if (entity.currentFrame == 3)
						{
							var berryAdjective:String = "cutely";
							var berryUnripeWater:int = int(berryUnripeData[2]) + int(berryUnripeData[3]) + int(berryUnripeData[4]) + int(berryUnripeData[5]);
							if (berryUnripeWater <= 1) berryAdjective = "cutely";
							else if (berryUnripeWater <= 3) berryAdjective = "prettily";
							else berryAdjective = "very beautifully";
							MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("These " + String(berryUnripeData[0]).toUpperCase() + " flowers are blooming " + berryAdjective + ".", true, 0, null, 23));
						}
						
						if (Configuration.ACTIVE_TRAINER.hasItem("Wailmer Pail")) 
						{
							_questionCommandE = e;
							_questionCommandEntity = entity;
							MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createQuestionFromArray("Want to water the " + String(berryUnripeData[0]).toUpperCase() + " with the\nWAILMER PAIL?", waterBerry, ["YES", "NO"], 23));
						}

					}
					else if (entity.currentFrame == 4 && entity.visible)
					{
						// The berry is ripe.
						// [Name]-[timecode]-[water1]-[water2]-[water3]-[water4]
						var berryNumber:int = 2;
						var berryName:String;
						if (Configuration.ACTIVE_TRAINER.getState("B" + entity.X_TILE + "x" + entity.Y_TILE) != "")
						{
							var berryData:Array = Configuration.ACTIVE_TRAINER.getState("B" + entity.X_TILE + "x" + entity.Y_TILE).split("-");
							berryName = berryData[0];
							var berryWatered:int = int(berryData[2]) + int(berryData[3]) + int(berryData[4]) + int(berryData[5]);
							var berryMin:int = PokemonBerry.getMinimumYield(berryName);
							var berryMax:int = PokemonBerry.getMaximumYield(berryName);
							var berryRand:int = (Math.floor(Math.random() * ((berryMax - berryMax) + 1)));
							
							if (berryWatered == 0) berryNumber = PokemonBerry.getMinimumYield(berryName);
							else berryNumber = ((berryMax - berryMin) * (berryWatered - 1) + berryRand) / 4 + berryMin;
							
						}
						else
						{
							berryName = e.properties.properties.initial;
							berryNumber = PokemonBerry.getMinimumYield(berryName);
						}
						
						_pickingBerryEntity = entity;
						_pickingBerryNumber = berryNumber;
						_pickingBerryName = berryName;
						MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("You found " + berryNumber + " " + berryName.toUpperCase() + (berryNumber > 1 ? " BERRIES" : " BERRY") + "!", true, 0, null, 23));
						MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createQuestionFromArray("Do you want to pick the\n" + berryName.toUpperCase() + (berryNumber > 1 ? " BERRIES" : " BERRY") + "?", pickBerry, ["YES", "NO"], 23));
					}
					else if (entity.visible == false)
					{
						// We can plant something here!
						_pickingBerryEntity = entity;
						MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createQuestionFromArray("It's soft, loamy soil.<br>Want to plant a BERRY?", plantBerry, ["YES", "NO"], 23));
					}
					break;
				case "if": 
					var stateName:String = subcommandData[1];
					var value:String = subcommandData[2];
					if (stateName == "direction")
					{
						if (PlayerManager.PLAYER.DIRECTION != value) break CommandLoop;
					}
					else if (Configuration.ACTIVE_TRAINER.getState(stateName) != value) break CommandLoop;
					break;
				case "ifnot": 
					var stateName1:String = subcommandData[1];
					var value1:String = subcommandData[2];
					if (stateName1 == "direction")
					{
						if (PlayerManager.PLAYER.DIRECTION == value1) break CommandLoop;
					}
					else if (Configuration.ACTIVE_TRAINER.getState(stateName1) == value1) break CommandLoop;
					break;
				case "istrainer": 
					entity.setIsTrainer(int(subcommandData[1]));
					break;
				case "nottrainer": 
					entity.setIsTrainer(-1);
					break;
				case "tree":
					MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("This tree looks like it can be<br>CUT down!", true, 0, null, 23));
					break;
				case "set": 
					var stateName2:String = subcommandData[1];
					var value2:String = subcommandData[2];
					Configuration.ACTIVE_TRAINER.setState(stateName2, value2);
					break;
				case "immobilizeplayer": 
					if (PlayerManager.PLAYER == null) PlayerManager.playerWillBeMobile = false;
					else PlayerManager.PLAYER.setMobility(false);
					PlayerManager.stopRunning();
					PlayerManager.PLAYER.stop();
					break;
				case "mobilizeplayer": 
					if (PlayerManager.PLAYER == null) PlayerManager.playerWillBeMobile = true;
					else PlayerManager.PLAYER.setMobility(true);
					break;
				case "startbattle": 
					PlayerManager.PLAYER.setMobility(false);
					PlayerManager.stopRunning();
					PlayerManager.PLAYER.stop();
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					BattleManager.startTrainerBattle(entity.TRAINER_TYPE, subcommandData, nextCommand, [e, entity]);
					return;
					break;
				case "ignoreregionchanges": 
					RegionManager.startIgnoringRegionChanges();
					break;
				case "stopignoringregionchanges": 
					RegionManager.startIgnoringRegionChanges(false);
					break;
				case "starttrainerbattle": 
					var trackToPlay:int = 117;
					switch(subcommandData[2])
					{
						case TrainerType.AQUA_ADMIN_FEMALE:
						case TrainerType.AQUA_ADMIN_MALE:
						case TrainerType.TEAM_AQUA_GRUNT_FEMALE:
						case TrainerType.TEAM_AQUA_GRUNT_MALE:
						case TrainerType.MAGMA_ADMIN_FEMALE:
						case TrainerType.MAGMA_ADMIN_MALE:
						case TrainerType.TEAM_MAGMA_GRUNT_FEMALE:
						case TrainerType.TEAM_MAGMA_GRUNT_MALE:
							trackToPlay = 125;
							break;
						case TrainerType.MAGMA_LEADER_MALE:
						case TrainerType.AQUA_LEADER_MALE:
							trackToPlay = 222;
							break;
					}
					SoundManager.playMusicTrack(trackToPlay, 0, false, true);
					PlayerManager.PLAYER.setMobility(false);
					PlayerManager.stopRunning();
					PlayerManager.PLAYER.stop();
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					BattleManager.startMinorTrainerBattle(subcommandData, nextCommand, [e, entity]);
					return;
					break;
				case "startdoubletrainerbattle":
					var trackToPlay2:int = 117;
					switch(subcommandData[2])
					{
						case TrainerType.AQUA_ADMIN_FEMALE:
						case TrainerType.AQUA_ADMIN_MALE:
						case TrainerType.TEAM_AQUA_GRUNT_FEMALE:
						case TrainerType.TEAM_AQUA_GRUNT_MALE:
						case TrainerType.MAGMA_ADMIN_FEMALE:
						case TrainerType.MAGMA_ADMIN_MALE:
						case TrainerType.TEAM_MAGMA_GRUNT_FEMALE:
						case TrainerType.TEAM_MAGMA_GRUNT_MALE:
							trackToPlay2 = 125;
							break;
						case TrainerType.MAGMA_LEADER_MALE:
						case TrainerType.AQUA_LEADER_MALE:
							trackToPlay2 = 222;
							break;
					}
					SoundManager.playMusicTrack(trackToPlay2, 0, false, true);
					PlayerManager.PLAYER.setMobility(false);
					PlayerManager.stopRunning();
					PlayerManager.PLAYER.stop();
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					BattleManager.startMinorTrainerBattle(subcommandData, nextCommand, [e, entity], BattleSpecialTile.PLAIN, BattleWeatherEffect.CLEAR_SKIES, BattleType.DOUBLE_TRAINERxTRAINER);
					return;
					break;
				case "startwallytutorialbattle": 
					SoundManager.playMusicTrack(109, 0, false, true);
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					BattleManager.startWallyTutorialBattle(nextCommand, [e, entity]);
					return;
					break;
				case "move": 
					var moveData:Array = String(subcommandData[1]).split(",");
					var xTile:int = int(moveData[0]);
					var yTile:int = int(moveData[1]);
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					e.x = entity.X_TILE;
					e.y = entity.Y_TILE;
					moveEntity(entity, "down", xTile, yTile, nextCommand, [e, entity, true]);
					return;
					break;
				case "animatetile": 
					if (subcommandData.length > 1)
					{
						var coords2:Array = String(subcommandData[1]).split(",");
						animateTile(int(coords2[0]), int(coords2[1]), null);
					}
					else animateTile(e.x, e.y, null);
					break;
				case "stopanimatingtile": 
					var coords3:Array = String(subcommandData[1]).split(",");
					animateTile(int(coords3[0]), int(coords3[1]), null, false, true);
					break;
				case "playsound": 
					SoundManager.playSoundEffect(subcommandData[1]);
					break;
				case "startpc": 
					PlayerManager.PLAYER.setMobility(false);
					_questionCommandE = e;
					e.executing = false;
					Configuration.createMenu(MenuType.PC_SELECT, 1, closePC);
					return;
					break;
				case "startpokemart": 
					PlayerManager.PLAYER.setMobility(false);
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					_questionCommandE = e;
					var items:String = String(subcommandData[1]);
					Configuration.createMenu(MenuType.POKEMART, 1, closePokemart, false, items);
					return;
					break;
				case "healpokemon": 
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					_questionCommandE = e;
					MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage(subcommandData[1], false, 0, createHealSprite, 23, true, [e.x, e.y]));
					return;
					break;
				case "moveplayer": 
					var moveData1:Array = String(subcommandData[1]).split(",");
					var xTile1:int = int(moveData1[0]);
					var yTile1:int = int(moveData1[1]);
					var waitForFinish:Boolean = true;
					if (subcommandData.length > 2) waitForFinish = subcommandData[2] == "false" ? false : true;
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					if (waitForFinish)
					{
						moveEntity(PlayerManager.PLAYER, "down", xTile1, yTile1, nextCommand, [e, entity], true);
						return;
					}
					else
					{
						moveEntity(PlayerManager.PLAYER, "down", xTile1, yTile1, null, null, true);
					}
					break;
				case "turnplayer": 
					PlayerManager.PLAYER.turn(subcommandData[1]);
					sendOurDirection();
					break;
				case "alert": 
					SoundManager.playSoundEffect(SoundEffect.ALERT);
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					entity.alertEffect(nextCommand, [e, entity]);
					return;
					break;
				case "trace": 
					trace("COMMAND TRACE: " + subcommandData[1]);
					break;
				case "exit": 
					// Stops processing
					e.executing = false;
					e.commands = new Vector.<String>();
					return;
					break;
				case "rest": 
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					Configuration.FADE_OUT_AND_IN(midwayRest, false, 4, [e, entity]);
					return;
					break;
				case "cmd": 
					trace("Running command " + subcommandData[1]);
					if (subcommandData.length > 2)
					{
						// There is a specified target for this command!
						var otherTarget:TiledObject = getEntityObjectWithName(subcommandData[2]);
						var otherEntity:Entity = otherTarget != null ? getEntityAt(otherTarget.x, otherTarget.y) : null;
						if (otherTarget != null)
						{
							if (otherEntity) otherEntity.finishMoving(false);
							otherTarget.executing = false;
							addCommand(otherTarget.properties.properties[subcommandData[1]], otherTarget, otherEntity, true, false);
							nextCommand(otherTarget, otherEntity, true);
						}
					}
					else addCommand(e.properties.properties[subcommandData[1]], e, entity, true, false);
					addCommand(restOfCommand, e, entity, false, false);
					if (e) e.executing = false;
					if (entity) entity.finishMoving(false);
					//trace("Running next command on " + e);
					nextCommand(e, entity, true);
					return;
					break;
				case "wait": 
					addCommand(restOfCommand, e, entity);
					e.executing = false;
					if (entity) entity.overrideMoving(false);
					TweenLite.delayedCall(Number(subcommandData[1]), nextCommand, [e, entity]);
					return;
					break;
				case "activate": 
					// activate the specified entity!
					for (j = 0; j < _entityObjects.length; j++)
						if (_entityObjects[j].name == subcommandData[1]) eTemp = _entityObjects[j];
					if (eTemp != null) entityTemp = getEntityAt(eTemp.x, eTemp.y);
					if (eTemp != null && entityTemp != null) activateEntity(eTemp, entityTemp);
					break;
				case "setactivatedflag":
					e.activated = true;
					break;
				case "create": 
					for (j = 0; j < _entityObjects.length; j++)
						if (_entityObjects[j].name == subcommandData[1]) eTemp = _entityObjects[j];
					if (eTemp != null) checkForExistingEntityObject(eTemp.x, eTemp.y, true, subcommandData[1], true);
					break;
				case "destroy": 
					for (j = 0; j < _entityObjects.length; j++)
						if (_entityObjects[j].name == subcommandData[1]) eTemp = _entityObjects[j];
					if (eTemp) entityTemp = getEntityAt(eTemp.x, eTemp.y, subcommandData[1]);
					if (entityTemp)
					{
						TweenLite.to(entityTemp, 0.25, {alpha: 0, onComplete: removeEntity, onCompleteParams: [entityTemp]});
					}
					break;
				case "playtrack": 
					var trackID:int = int(subcommandData[1]);
					var trackLoops:int = int(subcommandData[2]);
					var fastFade:Boolean = false;
					if (subcommandData.length > 3) fastFade = Boolean(subcommandData[3]);
					SoundManager.playMusicTrack(trackID, trackLoops, true, fastFade);
					break;
				case "hide": 
					TweenLite.to(entity, 0.25, {alpha: 0});
					break;
				case "show": 
					TweenLite.to(entity, 0.25, {alpha: 1});
					break;
				case "playsoundeffect": 
					SoundManager.playSoundEffect(subcommandData[1]);
					break;
				case "giveitem": 
					// %PLAYER% received a %ITEM%!
					// %PLAYER% put away the %ITEM% in the %POCKET% POCKET.
					var itemName:String = String(subcommandData[1]);
					var pocketName:String = PokemonItems.getItemPocketByName(itemName);
					addCommand(restOfCommand, e, entity, false, false);
					e.executing = false;
					var count:int = subcommandData.length < 3 ? 1 : int(subcommandData[2]);
					var plural:String = count > 1 ? "S" : "";
					while (count > 0)
					{
						Configuration.ACTIVE_TRAINER.giveItem(itemName);
						count--;
					}
					var found:Boolean = subcommandData.length < 4 ? false : (subcommandData[3] == "true" ? true : false);
					SoundManager.playMusicTrack(256, 1, true, true);
					var itemNameUppercase:String = itemName.toUpperCase().replace("É", "é");
					var an:String = "";
					switch(itemNameUppercase.charAt(0))
					{
						case "A":
						case "E":
						case "I":
						case "O":
						case "U":
							an = "n";
							break;
					}
					if (!found) MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("Obtained the " + itemNameUppercase + plural + "!", false, 2000, null, 23));
					else MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("%PLAYER% found a" + an + " " + itemNameUppercase + plural + "!", false, 2000, null, 23));
					MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("%PLAYER% put away the " + itemNameUppercase + plural + " in the " + pocketName + " POCKET.", true, 0, nextCommand, 23, false, [e, entity, true]));
					return;
					break;
				case "switch": 
					var variable:String = String(subcommandData[1]);
					var dataTemp:Array;
					var value3:String;
					var commandName:String;
					for (j = 2; j < subcommandData.length; j++)
					{
						dataTemp = String(subcommandData[j]).split("-");
						value3 = String(dataTemp[0]);
						commandName = String(dataTemp[1]);
						
						if (variable == "direction")
						{
							if (PlayerManager.PLAYER.DIRECTION == value3) addCommand("cmd::" + commandName, e, entity, true, true);
						}
						else if (variable == "y")
						{
							if (PlayerManager.PLAYER.Y_TILE == int(value3)) addCommand("cmd::" + commandName, e, entity, true, true);
						}
						else if (variable == "x")
						{
							if (PlayerManager.PLAYER.X_TILE == int(value3)) addCommand("cmd::" + commandName, e, entity, true, true);
						}
						else if (value3 == "*")
						{
							addCommand("cmd::" + commandName, e, entity, true, true);
							break;
						}
						else if (Configuration.ACTIVE_TRAINER.getState(variable) == value3)
						{
							addCommand("cmd::" + commandName, e, entity, true, true);
							break;
						}
					}
					dataTemp = null;
					break;
				case "startrun": 
					var keepWalkAnimation:Boolean = false;
					if (subcommandData.length > 1) keepWalkAnimation = subcommandData[1] == "true" ? true : false;
					entity.startRunning(keepWalkAnimation);
					break;
				case "stoprun": 
					entity.stopRunning();
					entity.stop();
					break;
				case "play": 
					entity.play();
					break;
				case "stop": 
					entity.stop();
					break;
				case "createmenu": 
					Configuration.FADE_OUT_AND_IN(createMenu, false, -1, [subcommandData[1]]);
					break;
				case "starttutorial": 
					// Begins the battle where the player must save Professor Birch.
					Configuration.FADE_OUT_AND_IN(Configuration.createMenu, false, -1, [MenuType.POKEMON_SELECT, 1, returnFromTutorial]);
					break;
				case "loadmap": 
					var map:String = subcommandData[1];
					var coords:Array = String(subcommandData[2]).split(",");
					var xTile2:int = int(coords[0]);
					var yTile2:int = int(coords[1]);
					PlayerManager.PLAYER.setMobility(false);
					if (MultiplayerManager.CONNECTION != null) MultiplayerManager.CONNECTION.send("ChangeMap", map);
					if (subcommandData.length > 3) PlayerManager.initialTurnDirection = subcommandData[3];
					TweenLite.delayedCall(0.25, WorldManager.switchOverworld, [map, xTile2, yTile2]);
					return;
					break;
				case "question": 
					var question:String = subcommandData[1];
					_questionCommandOptions = new Array();
					_questionCommandCallbacks = new Vector.<String>();
					for (j = 2; j < subcommandData.length; j++)
					{
						var option:Array = String(subcommandData[j]).split("-");
						_questionCommandOptions.push(option[0]);
						_questionCommandCallbacks.push(option[1]);
					}
					_questionCommandE = e;
					_questionCommandEntity = entity;
					addCommand(restOfCommand, e, entity, false, false);
					MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createQuestionFromArray(question, answerCommandQuestion, _questionCommandOptions, 23));
					return;
					break;
				case "nickname": 
					_questionCommandE = e;
					_questionCommandEntity = entity;
					addCommand(restOfCommand, e, entity, false, false);
					Configuration.FADE_OUT_AND_IN(Configuration.createMenu, false, -1, [MenuType.NICKNAME, 1, returnFromNickname]);
					return;
					break;
				case "createprofile": 
					_questionCommandE = e;
					_questionCommandEntity = entity;
					addCommand(restOfCommand, e, entity, false, false);
					Configuration.FADE_OUT_AND_IN(Configuration.createMenu, false, -1, [MenuType.PROFILE, 1, returnFromNickname, false, subcommandData[1]]);
					return;
					break;
				default: 
					throw(new Error("Unknown command '" + keyword + "'"));
					break;
				}
			}
			
			// Check to see if there is another command line. If there is, execute it now. If not, exit.
			if (e)
			{
				e.executing = false;
				nextCommand(e, entity);
			}
		}
		
		private static function plantBerry(answer:String):void
		{
			if (answer == "NO")
			{
				// Do nothing
				PlayerManager.PLAYER.setMobility(true);
				_pickingBerryEntity = null;
			}
			else if (answer == "YES")
			{
				// Open the bag menu
				PlayerManager.PLAYER.setMobility(false);
				Configuration.FADE_OUT_AND_IN(createBerryMenu);
			}
		}
		
		private static function waterBerry(answer:String):void
		{
			if (answer == "NO")
			{
				PlayerManager.PLAYER.setMobility(true);
				_questionCommandE = null;
				_questionCommandEntity = null;
			} else
			if (answer == "YES")
			{
				var berryUnripeData:Array = Configuration.ACTIVE_TRAINER.getState("B" + _questionCommandEntity.X_TILE + "x" + _questionCommandEntity.Y_TILE).split("-");
				MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("%PLAYER% watered the " + String(berryUnripeData[0]).toUpperCase() +".", false, 0, playWaterAnimation, 23, true));
				var water1:String = berryUnripeData[2];
				var water2:String = berryUnripeData[3];
				var water3:String = berryUnripeData[4];
				var water4:String = berryUnripeData[5];
				switch(_questionCommandEntity.currentFrame)
				{
					case 0:
						water1 = "1";
						break;
					case 1:
						water2 = "1";
						break;
					case 2:
						water3 = "1";
						break;
					case 3:
						water4 = "1";
						break;
				}
				Configuration.ACTIVE_TRAINER.setState("B" + _questionCommandEntity.X_TILE + "x" + _questionCommandEntity.Y_TILE, berryUnripeData[0] + "-" + berryUnripeData[1] + "-" + water1 + "-" + water2 + "-" + water3 + "-" + water4)
			}
		}
		
		private static function playWaterAnimation():void
		{
			PlayerManager.PLAYER.animate("water_" + PlayerManager.PLAYER.DIRECTION);
			PlayerManager.PLAYER.setMobility(false);
			TweenLite.delayedCall(2, finishWaterAnimation, null);
		}
		
		private static function finishWaterAnimation():void
		{
			if (MessageCenter.WAITING_ON_FINISH_MESSAGE) MessageCenter.finishMessage();
			PlayerManager.PLAYER.animate("walk_" + PlayerManager.PLAYER.DIRECTION);
			PlayerManager.PLAYER.stop();
			PlayerManager.PLAYER.setMobility(true);
			_questionCommandEntity = null;
			_questionCommandE = null;
			MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("The plant seems to be delighted.", true, 0, null, 23));
		}
		
		private static function createBerryMenu():void
		{
			Configuration.createMenu(MenuType.BAG, 1, chooseBerry, false, "berry");
		}
		
		private static function chooseBerry(item:String):void
		{
			if (item == null) 
			{
				PlayerManager.PLAYER.setMobility(true);
				return;
			}
			
			var berryData:Array = item.split(" ");
			var xTile:int = _pickingBerryEntity.X_TILE;
			var yTile:int = _pickingBerryEntity.Y_TILE;
			Configuration.ACTIVE_TRAINER.setState("B" + xTile + "x" + yTile, berryData[0] + "-" + Math.floor((new Date()).time / 1000) + "-0-0-0-0");
			removeEntity(_pickingBerryEntity);
			_pickingBerryEntity = null;
			checkForExistingEntityObject(xTile, yTile);
			Configuration.ACTIVE_TRAINER.consumeItem(item);
			
			TweenLite.delayedCall(1, createBerryMessage, [item], false);
		}
		
		private static function createBerryMessage(berry:String):void
		{
			PlayerManager.PLAYER.setMobility(true);
			MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("%PLAYER% planted one " + berry.toUpperCase() + " in<br>the soft, loamy soil.", true, 0, null, 23));
		}
		
		private static var _pickingBerryEntity:Entity;
		private static var _pickingBerryNumber:int;
		private static var _pickingBerryName:String;
		
		private static function pickBerry(answer:String):void
		{
			if (answer == "NO")
			{
				MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("%PLAYER% left the " + _pickingBerryName.toUpperCase() + (_pickingBerryNumber > 1 ? " BERRIES" : " BERRY") + "\nunpicked.", true, 0, null, 23));
				_pickingBerryEntity = null;
			}
			else if (answer == "YES")
			{
				for (var i:int = 0; i < _pickingBerryNumber; i++) Configuration.ACTIVE_TRAINER.giveItem(_pickingBerryName + " Berry");
				MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("%PLAYER% picked the " + _pickingBerryNumber + " " + _pickingBerryName.toUpperCase() + (_pickingBerryNumber > 1 ? " BERRIES" : " BERRY") + ".", true, 0, null, 23));
				MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("%PLAYER% put away the " + _pickingBerryName.toUpperCase() + (_pickingBerryNumber > 1 ? " BERRIES" : " BERRY") + "\nin the BAG's BERRIES POCKET.", true, 0, null, 23));
				MessageCenter.addMessage((com.cloakentertainment.pokemonline.ui.Message).createMessage("The soil returned to its soft and loamy state.", true, 0, resetBerryState, 23));
			}
		}
		
		private static function resetBerryState():void
		{
			_pickingBerryEntity.visible = false;
			Configuration.ACTIVE_TRAINER.setState("B" + _pickingBerryEntity.X_TILE + "x" + _pickingBerryEntity.Y_TILE, "Unset-0-0-0-0-0");
			_pickingBerryEntity = null;
		}
		
		private static var _sPokemonCenterMachine:SPokemonCenterMachine;
		private static var _sPokemonCenterScreen:SPokemonCenterScreen;
		
		private static function createHealSprite(xTile:int, yTile:int):void
		{
			// Move left two tiles and up two to get the top right corner of the machine
			xTile -= 2;
			yTile -= 2;
			
			_sPokemonCenterMachine = new SPokemonCenterMachine(finishCreateHealSprite);
			_sPokemonCenterMachine.x = xTile * ChunkManager.TILE_SIZE;
			_sPokemonCenterMachine.y = yTile * ChunkManager.TILE_SIZE;
			ChunkManager.addEntity(_sPokemonCenterMachine);
			
			var e:TiledObject = getEntityObjectWithName("nurse1");
			var entity:Entity = getEntityAt(e.x, e.y, "nurse1");
			entity.turn("left");
			entity = null;
			e = null;
		}
		
		private static function finishCreateHealSprite():void
		{
			Configuration.ACTIVE_TRAINER.restAllPokemon();
			
			ChunkManager.removeEntity(_sPokemonCenterMachine);
			MessageCenter.finishMessage();
			_sPokemonCenterMachine.destroy();
			_sPokemonCenterMachine = null;
			
			var e:TiledObject = getEntityObjectWithName("nurse1");
			if (e)
			{
				var entity:Entity = getEntityAt(e.x, e.y, "nurse1");
				entity.turn("down");
				entity.playOnce();
				entity = null;
			}
			e = null;
			
			Configuration.ACTIVE_TRAINER.updateLastPokemonCenterLocation(MapManager.map.properties.properties["overworldXT"], MapManager.map.properties.properties["overworldYT"]);
			
			nextCommand(_questionCommandE, null);
		}
		
		private static function closePC():void
		{
			if (!_questionCommandE) return;
			
			var tile:Tile = ChunkManager.getAnimatedTile(_questionCommandE.x, _questionCommandE.y);
			if (tile) tile.currentFrame = 0;
			_questionCommandE = null;
			tile = null;
			
			PlayerManager.PLAYER.setMobility(true);
		}
		
		private static function closePokemart():void
		{
			PlayerManager.PLAYER.setMobility(true);
			nextCommand(_questionCommandE, null);
			_questionCommandE = null;
		}
		
		private static function midwayRest(e:TiledObject, entity:Entity):void
		{
			Configuration.ACTIVE_TRAINER.restAllPokemon();
			SoundManager.playMusicTrack(114, 1, true, true);
			TweenLite.delayedCall(Configuration.FADE_DURATION / 2, nextCommand, [e, entity], false);
		}
		
		private static function returnFromNickname():void
		{
			_questionCommandE.executing = false;
			nextCommand(_questionCommandE, _questionCommandEntity);
			_questionCommandE = null;
			_questionCommandEntity = null;
		}
		
		private static var _questionCommandOptions:Array;
		private static var _questionCommandCallbacks:Vector.<String>;
		private static var _questionCommandE:TiledObject;
		private static var _questionCommandEntity:Entity;
		
		private static function answerCommandQuestion(answer:String):void
		{
			var command:String = "";
			for (var i:int = 0; i < _questionCommandOptions.length; i++)
			{
				if (_questionCommandOptions[i] == answer) command = _questionCommandCallbacks[i];
			}
			addCommand("cmd::" + command, _questionCommandE, _questionCommandEntity, true, false);
			_questionCommandE.executing = false;
			if (_questionCommandEntity) _questionCommandEntity.finishMoving(false);
			//trace("Running next command on " + e);
			nextCommand(_questionCommandE, _questionCommandEntity, true);
		}
		
		private static function returnFromTutorial():void
		{
			trace("Returned from tutorial.");
			activateEntity(getEntityObjectAt(132, 281, "birch_attack"), getEntityAt(132, 281, "birch_attack"));
			
			Configuration.ACTIVE_TRAINER.setState("LRpokemonchosen", Configuration.ACTIVE_TRAINER.getPokemon(0).base.name);
		}
		
		private static function createMenu(menuType:String):void
		{
			Configuration.createMenu(menuType);
		}
		
		private static function sortByYTile(ent1:Entity, ent2:Entity):Number
		{
			if (ent1.Y_TILE == ent2.Y_TILE) return 0;
			else if (ent1.Y_TILE > ent2.Y_TILE) return -1;
			else return 1;
		}
	
	}

}