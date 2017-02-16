package com.cloakentertainment.pokemonline.world.map
{
	import com.cloakentertainment.pokemonline.world.entity.Entity;
	import com.cloakentertainment.pokemonline.world.entity.EntityManager;
	import com.cloakentertainment.pokemonline.world.map.ChunkManager;
	import com.cloakentertainment.pokemonline.world.map.LayerType;
	import com.cloakentertainment.pokemonline.world.map.MapManager;
	import com.cloakentertainment.pokemonline.world.tile.*;
	import com.cloakentertainment.pokemonline.world.tile.Tile;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Chunk extends Sprite
	{
		private var _chunkX:int;
		private var _chunkY:int;
		private var _chunkType:String;
		
		private var bmd:BitmapData;
		private var texture:Texture;
		private var image:Image;
		
		private var animatedTiles:Vector.<Tile>;
		
		public function Chunk(chunkX:int, chunkY:int, chunkType:String)
		{
			/// Create the bitmapData for this chunk and populate it with the corresponding tiles.
			redraw(chunkX, chunkY, chunkType);
		}
		
		public function redraw(chunkX:int, chunkY:int, chunkType:String):void
		{
			destroyAnimatedTiles();
			
			animatedTiles = new Vector.<Tile>();
			
			texture = construct(chunkX, chunkY, chunkType);
			if (!image) image = new Image(texture);
			else image.texture = texture;
			
			if (chunkType == LayerType.BOTTOM && animatedTiles.length == 0) image.blendMode = BlendMode.NONE;
			else image.blendMode = BlendMode.NORMAL;
			
			image.smoothing = TextureSmoothing.BILINEAR;
			image.touchable = this.touchable = false;
			
			if (animatedTiles.length == 0)
			{
				// There are no animated tiles in this chunk, so we can flatten it
				this.flatten();
				animatedTiles = null;
			}
			else this.unflatten();
			
			if (!this.contains(image)) this.addChild(image);
			else this.setChildIndex(image, this.numChildren - 1);
		}
		
		public function construct(chunkX:int, chunkY:int, chunkType:String):Texture
		{
			_chunkX = chunkX;
			_chunkY = chunkY;
			_chunkType = chunkType;
			
			if (!bmd) bmd = new BitmapData(ChunkManager.CHUNK_WIDTH * ChunkManager.TILE_SIZE, ChunkManager.CHUNK_HEIGHT * ChunkManager.TILE_SIZE, true, 0x000000);
			else bmd.fillRect(new Rectangle(0, 0, bmd.width, bmd.height), 0x00000000);
			
			var startXTile:int = (CHUNK_X - 1) * ChunkManager.CHUNK_WIDTH + 1;
			var startYTile:int = (CHUNK_Y - 1) * ChunkManager.CHUNK_HEIGHT + 1;
			var endXTile:int = startXTile + ChunkManager.CHUNK_WIDTH;
			var endYTile:int = startYTile + ChunkManager.CHUNK_HEIGHT;
			var destX:int = 0;
			var destY:int = 0;
			var tileindex:int = 0;
			//trace(startXTile + "," + startYTile + " to " + endXTile + "," + endYTile);
			for (var i:int = startYTile; i < endYTile; i++)
			{
				for (var j:int = startXTile; j < endXTile; j++)
				{
					tileindex = MapManager.getTileIndexAt(j, i, CHUNK_TYPE);
					if (tileindex != 0)
					{
						if (tileindex == 506) addAnimatedTile(TWater, j, i, destX, destY); // This is just a plain water tile - it shouldn't have anything under/above it
						else if (tileindex == 1048) addAnimatedTile(TWaterTopRight, j, i, destX, destY);
						else if (tileindex == 1049) addAnimatedTile(TWaterTop, j, i, destX, destY);
						else if (tileindex == 547) addAnimatedTile(TWaterTopRightInner, j, i, destX, destY);
						else if (tileindex == 631) addAnimatedTile(TWaterBottomRightInner, j, i, destX, destY);
						else if (tileindex == 880) addAnimatedTile(TWaterBottomRight, j, i, destX, destY);
						else if (tileindex == 964) addAnimatedTile(TWaterRight, j, i, destX, destY);
						else if (tileindex == 535) addAnimatedTile(TRockBottomRight, j, i, destX, destY);
						else if (tileindex == 451) addAnimatedTile(TRockTopRight, j, i, destX, destY);
						else if (tileindex == 450) addAnimatedTile(TRockTopLeft, j, i, destX, destY);
						else if (tileindex == 534) addAnimatedTile(TRockBottomLeft, j, i, destX, destY);
						else if (tileindex == 4700) addAnimatedTile(TWoodDoor, j, i, destX, destY);
						else if (tileindex == 5121) addAnimatedTile(TGreenDoor, j, i, destX, destY);
						else if (tileindex == 4110) addAnimatedTile(TFlower1, j, i, destX, destY);
						else if (tileindex == 6890) addAnimatedTile(TOrangeDoor, j, i, destX, destY);
						else if (tileindex == 6894 || tileindex == 7226) addAnimatedTile(TBlueDoor, j, i, destX, destY);
						else if (tileindex == 3748) addAnimatedTile(TDoubleBlueDoor, j, i, destX, destY);
						else if (tileindex == 7719) addAnimatedTile(TRedDoor, j, i, destX, destY);
						else if (tileindex == 7654) addAnimatedTile(TPokemonCenterPC, j, i, destX, destY);
						else if (tileindex == 5655) addAnimatedTile(TTelevision, j, i, destX, destY);
						else if (tileindex == 5460) addAnimatedTile(TLightWater, j, i, destX, destY);
						else if (tileindex == 5201)
						{
							// This is grass, create the animated representation of it and then place a regular field tile underneath it.
							addAnimatedTile(TGrass, j, i, destX, destY);
						}
						else TileManager.retrieveTile(tileindex, bmd, destX, destY);          // its real graphics placed over it.
						
						switch (tileindex)
						{
						case 421: /// These are all tiles that need water underneath them!
						case 422: 
						case 508: 
						case 505: 
						case 882: 
						case 881: 
						case 966: 
						case 546: 
						case 630: 
						case 1050: 
						case 1051: 
						case 1052: 
						case 1135: 
						case 1136: 
						case 6005:
						case 6006:
							case 6007:
						case 6089:
							case 6090:
							if (chunkType != LayerType.BOTTOM) break;
							addAnimatedTile(TWater, j, i, destX, destY);
							break;
						}
					}
					
					// Check for entities to be created
					if(_chunkType == LayerType.BOTTOM) addEntity(j - 1, i - 1);
					
					destX += ChunkManager.TILE_SIZE;
				}
				destX = 0;
				destY += ChunkManager.TILE_SIZE;
			}
			
			return Texture.fromBitmapData(bmd, false);
		}
		
		private function addEntity(xTile:int, yTile:int):void
		{
			// Check for an entity existing at these coordinates
			EntityManager.checkForExistingEntityObject(xTile, yTile);
		}
		
		private function addAnimatedTile(tileClass:Class, j:int, i:int, destX:int, destY:int):void
		{
			var animatedTile:Tile = new tileClass(j, i) as Tile;
			animatedTile.x = destX;
			animatedTile.y = destY;
			this.addChild(animatedTile);
			animatedTiles.push(animatedTile);
			WorldManager.JUGGLER.add(animatedTile);
			animatedTile.play();
			
			if (animatedTile.TYPE == Tile.WATER)
			{
				animatedTile.advanceTime(ChunkManager.CURRENT_WATERTILE_TIME);
			}
			else if (animatedTile.TYPE == Tile.DOOR)
			{
				animatedTile.loop = false;
				animatedTile.stop();
				
				// Set baseline
				animatedTile.y -= (animatedTile.height - ChunkManager.TILE_SIZE);
			} else if (animatedTile.TYPE == Tile.GRASS || animatedTile.TYPE == Tile.PC || animatedTile.TYPE == Tile.TELEVISION) animatedTile.stop();
			else if (animatedTile.TYPE == Tile.LIGHT_WATER)
			{
				animatedTile.advanceTime(ChunkManager.CURRENT_WATERTILE_TIME);
				animatedTile.advanceTime((j + (397 - i)) / 8);
			}
		}
		
		private function destroyAnimatedTiles():void
		{
			if (!animatedTiles) return;
			
			for (var i:int = 0; i < animatedTiles.length; i++)
			{
				WorldManager.JUGGLER.remove(animatedTiles[i]);
				animatedTiles[i].stop();
				this.removeChild(animatedTiles[i]);
				animatedTiles[i].destroy();
				animatedTiles[i] = null;
			}
			
			animatedTiles = null;
		}
		
		public function getAnimatedTileAt(xTile:int, yTile:int):Tile
		{
			if (!animatedTiles) return null;
			
			for (var i:int = 0; i < animatedTiles.length; i++)
			{
				if (animatedTiles[i].X_TILE == xTile && animatedTiles[i].Y_TILE == yTile) return animatedTiles[i];
			}
			
			return null;
		}
		
		public function toString():String
		{
			return "{" + CHUNK_X + ", " + CHUNK_Y + ", " + CHUNK_TYPE + "}";
		}
		
		public function get CHUNK_TYPE():String
		{
			return _chunkType;
		}
		
		public function get CHUNK_X():int
		{
			return _chunkX;
		}
		
		public function get CHUNK_Y():int
		{
			return _chunkY;
		}
		
		public function destroy():void
		{
			trace("Destroying Chunk", CHUNK_X, CHUNK_Y);
			bmd.dispose();
			bmd = null;
			texture.dispose();
			texture = null;
			this.removeChild(image);
			image.dispose();
			image = null;
			
			destroyAnimatedTiles();
			if(CHUNK_TYPE == LayerType.BOTTOM) destroyNPCs();
			animatedTiles = null;
		}
		
		public function destroyNPCs():void
		{
			var startXTile:int = (CHUNK_X - 1) * ChunkManager.CHUNK_WIDTH + 1;
			var startYTile:int = (CHUNK_Y - 1) * ChunkManager.CHUNK_HEIGHT + 1;
			var endXTile:int = startXTile + ChunkManager.CHUNK_WIDTH;
			var endYTile:int = startYTile + ChunkManager.CHUNK_HEIGHT;
			for (var i:int = startYTile; i < endYTile; i++)
			{
				for (var j:int = startXTile; j < endXTile; j++)
				{
					destroyNPC(j - 1, i - 1);
				}
			}
		}
		
		private function destroyNPC(xTile:int, yTile:int):void
		{
			var entity:Entity = EntityManager.getEntityAt(xTile, yTile, "", true);
			if (entity) 
			{
				EntityManager.removeEntity(entity);
			}
		}
		
		public function get NUMBER_OF_ANIMATEDTILES():int
		{
			return animatedTiles.length;
		}
	
	}

}