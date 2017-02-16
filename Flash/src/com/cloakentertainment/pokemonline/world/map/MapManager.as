package com.cloakentertainment.pokemonline.world.map
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.world.map.LayerType;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.System;
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledObject;
	import io.arkeus.tiled.TiledObjectLayer;
	import io.arkeus.tiled.TiledTile;
	import io.arkeus.tiled.TiledTileLayer;
	import io.arkeus.tiled.TiledTileset;
	/**
	 * ...
	 * @author ...
	 */
	public class MapManager
	{
		public static var map:TiledMap;
		private static var _mapLoaded:Boolean = false;
		private static var _mapXML:XML;
		
		private static var _bottomLayer:TiledTileLayer;
		private static var _middleLayer:TiledTileLayer;
		private static var _topLayer:TiledTileLayer;
		private static var _tileset:TiledTileset;
		private static var _regionLayer:TiledObjectLayer;
		private static var _objectsLayer:TiledObjectLayer;
		
		private static var firstgid:int;
		
		public function MapManager()
		{
		
		}
		
		public static function destroy():void
		{
			_bottomLayer.destroy();
			_middleLayer.destroy();
			_topLayer.destroy();
			if(_regionLayer) _regionLayer.destroy();
			_objectsLayer.destroy();
			_tileset.destroy();
			
			_bottomLayer.destroyLayer();
			_middleLayer.destroyLayer();
			_topLayer.destroyLayer();
			if(_regionLayer) _regionLayer.destroyLayer();
			_objectsLayer.destroyLayer();
			
			_bottomLayer = null;
			_middleLayer = null;
			_topLayer = null;
			_tileset = null;
			_regionLayer = null;
			_objectsLayer = null;
			
			System.disposeXML(_mapXML);
			_mapXML = null;
			_mapLoaded = false;
			map.destroy();
			map = null;
			firstgid = 0;
			
			_loadMapCallback = null;
		}
		
		private static var _loadMapCallback:Function;
		private static var _loadedMapType:String = "";
		
		public static function get MAP_TYPE():String
		{
			return _loadedMapType;
		}
		
		public static function loadMap(mapType:String, callback:Function):void
		{
			if (callback == null) throw(new Error("MapManager:loadMap requires a callback."));
			if (mapType == "") throw(new Error("MapManager:loadMap requires a proper MapType."));
			_mapLoaded = false;
			_loadMapCallback = callback;
			_loadedMapType = mapType;
			
			if (_mapXML) _mapXML = null;
			if (map) map = null;
			
			var url:String = Configuration.WEB_ASSETS_URL + "xml/" + mapType + ".tmx?l=" + Configuration.VERSION_LABEL + "&d=" + Configuration.VERSION + (Configuration.DEVELOPMENT_SERVER ? "&t=" + Math.floor(Math.random() * 1000000000000) : "");
			var request:URLRequest = new URLRequest(url);
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, loadMapEvent, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadMapIOErrorEvent, false, 0, true);
			urlLoader.load(request);
		}
		
		public static function getTileIndexAt(xTile:int, yTile:int, layerType:String):int
		{
			if (yTile < 1 || xTile < 1 || yTile > map.height || xTile > map.width) return 0;
			
			if (layerType == LayerType.BOTTOM) return _bottomLayer.data[yTile - 1][xTile - 1] - firstgid;
			else if (layerType == LayerType.MIDDLE) return _middleLayer.data[yTile - 1][xTile - 1] - firstgid;
			else return _topLayer.data[yTile - 1][xTile - 1] - firstgid;
		}
		
		private static function loadMapIOErrorEvent(e:IOErrorEvent):void
		{
			if(WorldManager.loadingSprite) WorldManager.loadingSprite.updateStatus("Network Error!");
			throw(new Error("IOError Event: " + e));
		}
		
		private static function loadMapEvent(e:Event):void
		{
			_mapXML = XML(e.currentTarget.data);
			map = new TiledMap(_mapXML);
			
			_mapLoaded = true;
			_mapXML = null;
			
			_bottomLayer = map.layers.getLayerWithName("map") as TiledTileLayer;
			_middleLayer = map.layers.getLayerWithName("mid") as TiledTileLayer;
			_topLayer = map.layers.getLayerWithName("top") as TiledTileLayer;
			_objectsLayer = map.layers.getLayerWithName("objects") as TiledObjectLayer;
			_regionLayer = map.layers.getLayerWithName("regions") as TiledObjectLayer;
			
			_tileset = map.tilesets.getTilesetByName("tileset");
			
			if (_tileset == null)
			{
				// We've encountered an unrecoverable error in loading the map. We'll have to restart.
				// Possible causes for this include a new map file currently being uploaded.
				System.disposeXML(_mapXML);
				map.destroy();
				map = null;
				_bottomLayer = _middleLayer = _topLayer = null;
				_objectsLayer = _regionLayer = null;
				_loadMapCallback = null;
				WorldManager.mapLoadError();
				return;
			}
			
			firstgid = _tileset.firstGid - 1;
			
			_loadMapCallback();
			_loadMapCallback = null;
		}
		
		public static function isTileWalkable(xTile:int, yTile:int, layerType:String = LayerType.BOTTOM, acceptNull:Boolean = true):Boolean
		{
			xTile++;
			yTile++;
			var tileindex:int = getTileIndexAt(xTile, yTile, layerType) - 1;
			if (tileindex < 0 && acceptNull) return true;
			else if (tileindex < 0 && !acceptNull) return false;
			
			var tile:TiledTile = _tileset.tiles[tileindex];
			if (tile == null) return true;
			else
			{
				if (tile.properties.properties.isWalkable != null && tile.properties.properties.isWalkable == "false") return false;
				else if (tile.properties.properties.isWater != null && tile.properties.properties.isWater == "true") return false;
				else return true;
			}
		}
		
		public static function getTilePropertyAt(xTile:int, yTile:int, propertyName:String, layerType:String = LayerType.BOTTOM):String
		{
			xTile++;
			yTile++;
			var tileindex:int = getTileIndexAt(xTile, yTile, layerType) - 1;
			if (tileindex < 0) return "";
			var tile:TiledTile = _tileset.tiles[tileindex];
			if (tile == null) return "";
			else
			{
				if (tile.properties.properties[propertyName] != null) return tile.properties.properties[propertyName];
				return "";
			}
		}
		
		public static function get MAP_LOADED():Boolean
		{
			return _mapLoaded;
		}
		
		public static function get REGIONS():Vector.<TiledObject>
		{
			if (!_regionLayer) return null;
			else return _regionLayer.objects;
		}
		
		public static function get ENTITIES():Vector.<TiledObject>
		{
			if (!_objectsLayer) return null;
			else return _objectsLayer.objects;
		}
	
	}

}