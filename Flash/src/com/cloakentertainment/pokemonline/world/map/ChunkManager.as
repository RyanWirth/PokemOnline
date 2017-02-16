package com.cloakentertainment.pokemonline.world.map
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.world.PlayerManager;
	import com.cloakentertainment.pokemonline.world.sprite.SDarkEffect;
	import com.cloakentertainment.pokemonline.world.sprite.SDayNightCycle;
	import com.cloakentertainment.pokemonline.world.tile.Tile;
	import com.cloakentertainment.pokemonline.world.tile.TWater;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.filters.LineGlitchFilter;
	
	/**
	 * Holds the sprites that contain all the chunks (as well as the sprite for entities)
	 * @author Ryan Wirth
	 */
	public class ChunkManager
	{
		public static const OBJECT_POOLING:Boolean = false;
		
		private static var _sprite_bottom:Sprite;
		private static var _sprite_top:Sprite;
		private static var _sprite_entities:Sprite;
		
		private static var _sDayNightCycle:SDayNightCycle;
		private static var _sDarkEffect:SDarkEffect;
		
		private static var _centeredXTile:int;
		private static var _centeredYTile:int;
		private static var _centeredXChunk:int;
		private static var _centeredYChunk:int;
		
		/// The height and width of each chunk - measured in tiles.
		private static var _chunkWidth:int;
		private static var _chunkHeight:int;
		
		private static var _tileSize:int;
		
		private static var chunks:Vector.<Chunk>;
		private static var chunkPool:Vector.<Chunk>;
		
		private static var _checkPaddingBufferTiles:int = 2;
		
		private static var _masterWaterTile:TWater;
		
		public function ChunkManager()
		{
		
		}
		
		public static function prepareSprites():void
		{
			if (OBJECT_POOLING) trace("Object pooling enabled.");
			
			if(!_sprite_bottom) _sprite_bottom = new Sprite();
			if(!_sprite_entities) _sprite_entities = new Sprite();
			if(!_sprite_top) _sprite_top = new Sprite();
			
			WorldManager.RENDERER.addChild(_sprite_bottom);
			WorldManager.RENDERER.addChild(_sprite_entities);
			WorldManager.RENDERER.addChild(_sprite_top);
			
			if (Configuration.DAY_NIGHT_CYCLE)
			{
				_sDayNightCycle = new SDayNightCycle(SDayNightCycle.EVENING_START);
				WorldManager.RENDERER.addChild(_sDayNightCycle);
			}
			
			if (MapManager.map.properties.properties.hasOwnProperty("colorOverlay"))
			{
				_sDarkEffect = new SDarkEffect(MapManager.map.properties.properties.colorOverlay);
				WorldManager.RENDERER.addChild(_sDarkEffect);
			}
			
			_tileSize = 16 * Configuration.SPRITE_SCALE;
			
			_chunkWidth = Configuration.VIEWPORT.width / (TILE_SIZE);
			_chunkHeight = Configuration.VIEWPORT.height / (TILE_SIZE);
			
			visibleRect.width = visibleSourceRect.width = CHUNK_WIDTH * TILE_SIZE;
			visibleRect.height = visibleSourceRect.height = CHUNK_HEIGHT * TILE_SIZE;
			visibleSourceRect.width += _checkPaddingBufferTiles * TILE_SIZE;
			visibleSourceRect.height += _checkPaddingBufferTiles * TILE_SIZE; // Margin of 2 * TILE_SIZE
			
			trace("Chunk Size: " + _chunkWidth + "x" + _chunkHeight);
			
			chunks = new Vector.<Chunk>();
			chunkPool = new Vector.<Chunk>();
			
			_masterWaterTile = new TWater(-TILE_SIZE, -TILE_SIZE);
			WorldManager.RENDERER.addChild(_masterWaterTile);
			WorldManager.JUGGLER.add(_masterWaterTile);
			_masterWaterTile.play();
			_masterWaterTile.visible = false;
		}
		
		public static function isPreparedForConnection():Boolean
		{
			if (_masterWaterTile != null) return true;
			else return false;
		}
		
		private static var filter_type:int = 1;
		private static var filter1:LineGlitchFilter;
		public static function animateIntoBattle():void
		{
			// choose a filter
			
			if (filter_type == 1)
			{
				filter1 = new LineGlitchFilter(1 * Configuration.SPRITE_SCALE, 90, 0.01);
				WorldManager.RENDERER.filter = filter1;
				
				TweenLite.to(filter1, 2, { distance:0.5, onComplete:removeFilter } );
			}
		}
		
		private static function removeFilter():void
		{
			WorldManager.RENDERER.filter = null;
			
			filter1.dispose();
			filter1 = null;
		}
		
		private static var _panning:Boolean = false;
		
		public static function panTo(newCenterXTile:int, newCenterYTile:int, moveSpeed:Number = 0):void
		{
			if (_panning)
			{
				//return;
				if (moveSpeed == 0) return;
				else
				{
					TweenLite.killTweensOf(_sprite_bottom);
					TweenLite.killTweensOf(_sprite_entities);
					TweenLite.killTweensOf(_sprite_top);
				}
			}
			_panning = true;
			
			_centeredXTile = newCenterXTile;
			_centeredYTile = newCenterYTile;
			
			var xPos:int = -1 * _centeredXTile * TILE_SIZE + Configuration.VIEWPORT.width / 2 - TILE_SIZE / 2;
			var yPos:int = -1 * _centeredYTile * TILE_SIZE + Configuration.VIEWPORT.height / 2;
			
			var duration:Number;
			if (moveSpeed == 0)
			{
				var distance:Number = Math.sqrt(Math.pow(xPos - _sprite_bottom.x, 2) + Math.pow(yPos - _sprite_bottom.y, 2));
				duration = distance / TILE_SIZE * 15;
			} else duration = 60 / moveSpeed;
			
			if (distance > TILE_SIZE) _multitilePan = true;
			else _multitilePan = false;
			
			//checkForVisibleAdjacentChunks();
			
			TweenLite.to(_sprite_bottom, duration, {x: xPos, y: yPos, ease: Linear.easeNone, useFrames:true});
			TweenLite.to(_sprite_entities, duration, {x: xPos, y: yPos, ease: Linear.easeNone, useFrames:true});
			TweenLite.to(_sprite_top, duration, {x: xPos, y: yPos, ease: Linear.easeNone, onUpdate: checkPan, onComplete: finishPanning, useFrames:true});
		}
		
		private static var _multitilePan:Boolean = false;
		private static var _checkedAdjacentChunksPerPanTicks:int = 0;
		
		private static function checkPan():void
		{
			_sprite_bottom.x = _sprite_entities.x = _sprite_top.x = Math.round(_sprite_bottom.x);
			_sprite_bottom.y = _sprite_entities.y = _sprite_top.y = Math.round(_sprite_bottom.y);
			
			//if (_multitilePan) checkForVisibleAdjacentChunks();
		}
		
		private static function finishPanning():void
		{
			_panning = false;
			
			centerTile(_centeredXTile, _centeredYTile);
			
			if (!_multitilePan) checkForVisibleAdjacentChunks();
		}
		
		public static function destroy():void
		{
			var i:int;
			for (i = 0; i < chunks.length; i++)
			{
				destroyChunk(chunks[i], i);
				i--;
			}
			chunks = null;
			
			for (var j:int = 0; j < chunkPool.length; j++)
			{
				chunkPool[j] = null;
			}
			chunkPool = null;
			
			
			TweenLite.killTweensOf(_sprite_bottom);
			TweenLite.killTweensOf(_sprite_entities);
			TweenLite.killTweensOf(_sprite_top);
			TweenLite.killDelayedCallsTo(createChunk);
			
			WorldManager.RENDERER.removeChild(_sprite_bottom);
			WorldManager.RENDERER.removeChild(_sprite_entities);
			WorldManager.RENDERER.removeChild(_sprite_top);
			
			_sprite_bottom.removeChildren(0, -1, true);
			_sprite_entities.removeChildren(0, -1, true);
			_sprite_top.removeChildren(0, -1, true);
			
			_sprite_top = null;
			_sprite_bottom = null;
			_sprite_entities = null;
			
			if (_sDayNightCycle)
			{
				WorldManager.RENDERER.removeChild(_sDayNightCycle);
				_sDayNightCycle.destroy();
			}
			_sDayNightCycle = null;
			
			if (_sDarkEffect)
			{
				WorldManager.RENDERER.removeChild(_sDarkEffect);
				_sDarkEffect.destroy();
			}
			_sDarkEffect = null;
			
			_centeredChunkPoint = null;
			_centeredXChunk = -10;
			_centeredXTile = -10;
			_centeredYChunk = -10;
			_centeredYTile = -10;
			
			WorldManager.RENDERER.removeChild(_masterWaterTile);
			WorldManager.JUGGLER.remove(_masterWaterTile);
			_masterWaterTile.destroy();
			_masterWaterTile = null;
			
			MemoryTracker.gcAndCheck();
		}
		
		public static function drawChunk(chunkX:int, chunkY:int):void
		{
			if (doesChunkExist(chunkX, chunkY)) return;
			else if (couldChunkBeVisible(chunkX, chunkY) == false) return;
			trace("Drawing Chunk", chunkX, chunkY);
			createChunk(chunkX, chunkY, LayerType.BOTTOM);
			//createChunk(chunkX, chunkY, LayerType.MIDDLE);
			//createChunk(chunkX, chunkY, LayerType.TOP);
			
			//TweenLite.delayedCall(1, createChunk, [chunkX, chunkY, LayerType.BOTTOM], true);
			TweenLite.delayedCall(1, createChunk, [chunkX, chunkY, LayerType.MIDDLE], true);
			TweenLite.delayedCall(2, createChunk, [chunkX, chunkY, LayerType.TOP, true], true);
			
			checkForInvisibleChunks();
		}
		
		private static function createChunk(chunkX:int, chunkY:int, chunkType:String, flatten:Boolean = false):void
		{
			if (doesChunkExist(chunkX, chunkY, chunkType)) return;
			var chunk:Chunk = getNewChunk(chunkX, chunkY, chunkType);
			chunk.x = (chunkX - 1) * _chunkWidth * TILE_SIZE;
			chunk.y = (chunkY - 1) * _chunkHeight * TILE_SIZE;
			switch (chunkType)
			{
			case LayerType.BOTTOM: 
				_sprite_bottom.addChild(chunk);
				break;
			case LayerType.MIDDLE: 
				_sprite_bottom.addChild(chunk);
				break;
			case LayerType.TOP: 
				_sprite_top.addChild(chunk);
				break;
			}
			
			chunks.push(chunk);
			
			Configuration.fixFPSCounter();
			
			if (flatten)
			{
				//_sprite_bottom.flatten(); /// Cannot flatten because it may have animatedTiles in it
				_sprite_top.flatten();
			}
		}
		
		private static function getNewChunk(chunkX:int, chunkY:int, chunkType:String):Chunk
		{
			var chunk:Chunk;
			if (chunkPool.length > 0 && OBJECT_POOLING)
			{
				chunk = chunkPool[0];
				chunkPool.splice(0, 1);
				//trace("Pooled chunk.");
				chunk.redraw(chunkX, chunkY, chunkType);
			}
			else
			{
				chunk = new Chunk(chunkX, chunkY, chunkType);
			}
			
			return chunk;
		}
		
		public static function removeChunk(chunkX:int, chunkY:int):void
		{
			for (var i:int = 0, l:int = chunks.length; i < l; i++)
			{
				if (chunks[i].CHUNK_X == chunkX && chunks[i].CHUNK_Y == chunkY)
				{
					destroyChunk(chunks[i], i);
					i--;
				}
			}
		}
		
		public static function doesChunkExist(chunkX:int, chunkY:int, chunkType:String = ""):Boolean
		{
			for (var i:int = 0, l:int = chunks.length; i < l; i++)
			{
				if (chunks[i].CHUNK_X == chunkX && chunks[i].CHUNK_Y == chunkY)
				{
					if (chunkType != "")
					{
						if (chunks[i].CHUNK_TYPE == chunkType) return true;
					}
					else return true;
				}
			}
			
			return false;
		}
		
		public static function centerTile(xTile:int, yTile:int):void
		{
			_centeredXTile = xTile;
			_centeredYTile = yTile;
			
			_sprite_bottom.x = _sprite_entities.x = _sprite_top.x = -1 * _centeredXTile * TILE_SIZE + Configuration.VIEWPORT.width / 2 - TILE_SIZE / 2;
			_sprite_bottom.y = _sprite_entities.y = _sprite_top.y = -1 * _centeredYTile * TILE_SIZE + Configuration.VIEWPORT.height / 2;
			
			if (PlayerManager.PLAYER == null) WorldManager.createPlayer(xTile, yTile);
			
			checkForVisibleAdjacentChunks();
		}
		
		private static var _centeredChunkPoint:Point;
		
		public static function checkForVisibleAdjacentChunks():void
		{
			_centeredChunkPoint = getClosestChunkCoordinates((_sprite_bottom.x + TILE_SIZE / 2 - Configuration.VIEWPORT.width / 2) * -1 / TILE_SIZE, (_sprite_bottom.y - Configuration.VIEWPORT.height / 2) * -1 / TILE_SIZE);
			//trace(_centeredChunkPoint, _centeredXChunk, _centeredYChunk);
			//if (_centeredXChunk == _centeredChunkPoint.x && _centeredYChunk == _centeredChunkPoint.y) return;
			_centeredXChunk = _centeredChunkPoint.x;
			_centeredYChunk = _centeredChunkPoint.y;
			_centeredChunkPoint = null;
			
			//trace("Checking for visible adjacent chunks:", _centeredXChunk, _centeredYChunk);
			
			checkForVisibleAdjacentChunk(_centeredXChunk, _centeredYChunk);
			checkForVisibleAdjacentChunk(_centeredXChunk - 1, _centeredYChunk);
			checkForVisibleAdjacentChunk(_centeredXChunk + 1, _centeredYChunk);
			checkForVisibleAdjacentChunk(_centeredXChunk, _centeredYChunk - 1);
			checkForVisibleAdjacentChunk(_centeredXChunk, _centeredYChunk + 1);
			checkForVisibleAdjacentChunk(_centeredXChunk - 1, _centeredYChunk - 1);
			checkForVisibleAdjacentChunk(_centeredXChunk - 1, _centeredYChunk + 1);
			checkForVisibleAdjacentChunk(_centeredXChunk + 1, _centeredYChunk - 1);
			checkForVisibleAdjacentChunk(_centeredXChunk + 1, _centeredYChunk + 1);
		}
		
		public static function checkForInvisibleChunks():void
		{
			var chunk:Chunk;
			for (var i:int = 0; i < chunks.length; i++)
			{
				chunk = chunks[i];
				
				if (chunk.CHUNK_X < _centeredXChunk - 1 || chunk.CHUNK_X > _centeredXChunk + 1 || chunk.CHUNK_Y < _centeredYChunk - 1 || chunk.CHUNK_Y > _centeredYChunk + 1 || couldChunkBeVisible(chunk.CHUNK_X, chunk.CHUNK_Y) == false)
				{
					destroyChunk(chunk, i);
					i--;
				}
			}
		}
		
		private static function checkForVisibleAdjacentChunk(chunkX:int, chunkY:int):void
		{
			drawChunk(chunkX, chunkY);
		}
		
		private static function destroyChunk(chunk:Chunk, i:int):void
		{
			//trace("Removing Chunk " + chunk.CHUNK_X + "," + chunk.CHUNK_Y);
			switch (chunk.CHUNK_TYPE)
			{
			case LayerType.BOTTOM: 
				_sprite_bottom.removeChild(chunk);
				break;
			case LayerType.MIDDLE: 
				_sprite_bottom.removeChild(chunk);
				break;
			case LayerType.TOP: 
				_sprite_top.removeChild(chunk);
				break;
			}
			if (OBJECT_POOLING)
			{
				chunkPool.push(chunk);
			}
			else
			{
				chunk.destroy();
				chunk = null;
			}
			chunks.splice(i, 1);
			
			chunk = null;
		}
		
		private static var visibleRect:Rectangle = new Rectangle();
		private static var visibleSourceRect:Rectangle = new Rectangle();
		
		public static function couldChunkBeVisible(chunkX:int, chunkY:int):Boolean
		{
			// first, find the chunk bounds - in the form of a rectangle
			visibleRect.x = (chunkX - 1) * visibleRect.width;
			visibleRect.y = (chunkY - 1) * visibleRect.height;
			
			visibleSourceRect.x = _centeredXTile * TILE_SIZE - Configuration.VIEWPORT.width * 0.5 + TILE_SIZE * 0.5 - _checkPaddingBufferTiles * 0.5 * TILE_SIZE;
			visibleSourceRect.y = _centeredYTile * TILE_SIZE - Configuration.VIEWPORT.height * 0.5 - _checkPaddingBufferTiles * 0.5 * TILE_SIZE;
			
			return visibleRect.intersects(visibleSourceRect);
		}
		
		public static function get CHUNK_WIDTH():int
		{
			return _chunkWidth;
		}
		
		public static function get CHUNK_HEIGHT():int
		{
			return _chunkHeight;
		}
		
		public static function get TILE_SIZE():int
		{
			return _tileSize;
		}
		
		public static function getClosestChunkCoordinates(xTile:int, yTile:int):Point
		{
			xTile--;
			yTile--;
			var chunkX:int = Math.floor(xTile / CHUNK_WIDTH) + 1;
			var chunkY:int = Math.floor(yTile / CHUNK_HEIGHT) + 1;
			
			return new Point(chunkX, chunkY);
		}
		
		public static function getChunkAtCoords(xTile:int, yTile:int, layerType:String):Chunk
		{
			var chunkCoords:Point = getClosestChunkCoordinates(xTile, yTile);
			//trace("Searching for chunk at " +xTile + " " + yTile, "got", chunkCoords.x, chunkCoords.y);
			for (var i:int = 0; i < chunks.length; i++)
			{
				if (chunks[i].CHUNK_X == chunkCoords.x && chunks[i].CHUNK_Y == chunkCoords.y && chunks[i].CHUNK_TYPE == layerType) return chunks[i];
			}
			
			return null;
		}
		
		public static function getAnimatedTile(xTile:int, yTile:int):Tile
		{
			xTile++;
			yTile++;
			var chunk:Chunk = getChunkAtCoords(xTile, yTile, LayerType.BOTTOM);
			if (chunk) return chunk.getAnimatedTileAt(xTile, yTile);
			else return null;
		}
		
		public static function get CENTER_X_TILE():int
		{
			return _centeredXTile;
		}
		
		public static function get CENTER_Y_TILE():int
		{
			return _centeredYTile;
		}
		
		public static function get CURRENT_WATERTILE_TIME():Number
		{
			if (!_masterWaterTile) return 0;
			else return _masterWaterTile.currentTime;
		}
		
		public static function get CURRENT_WATERTILE_FRAME():int
		{
			if (!_masterWaterTile) return 0;
			else return _masterWaterTile.currentFrame;
		}
		
		public static function get CHUNKS():int
		{
			if (!chunks) return 0;
			return chunks.length / 3;
		}
		
		public static function get NUMBER_OF_ANIMATEDTILES():int
		{
			if (!chunks) return 0;
			var num:int = 0;
			for (var i:int = 0; i < chunks.length; i++) num += chunks[i].NUMBER_OF_ANIMATEDTILES;
			return num;
		}
		
		public static function addEntity(e:DisplayObject, addToBottom:Boolean = false):void
		{
			if (addToBottom) _sprite_bottom.addChild(e);
			else _sprite_entities.addChild(e);
		}
		
		public static function moveEntityToBack(e:DisplayObject):void
		{
			if(_sprite_entities.contains(e)) _sprite_entities.setChildIndex(e, 0);
		}
		
		public static function removeEntity(e:DisplayObject):void
		{
			_sprite_entities.removeChild(e);
		}
	
	}

}