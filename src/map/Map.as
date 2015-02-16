package map {
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	import mx.utils.StringUtil;
	import resource.TextAsset;
	import settings.DisplaySettings;
	
	/**
	 * Represents an overworld map with map entities, composed of tiles.
	 * @author shinobi0888
	 */
	public class Map {
		// Layer IDs
		public static const L_GROUND:int = 0;
		public static const L_EVENT:int = 1;
		public static const L_CHAR:int = 2;
		public static const L_OVERHEAD:int = 3;
		public static const L_AIR:int = 4;
		
		private var name:String;
		private var filename:String;
		
		// Layers of MapEntities
		private var layers:Array;
		
		// Tiles
		private var tileset:TileSet;
		// 2D arrays
		private var tiles:Array;
		private var tileStates:Array;
		
		private var width:int, height:int, widthInPixels:int, heightInPixels:int;
		
		private function parseMap(data:String):void {
			var lines:Array = data.split("\n");
			name = StringUtil.trim(lines[0]);
			tileset = new TileSet(StringUtil.trim(lines[1]));
			var pieces:Array = StringUtil.trim(lines[2]).split(",");
			width = parseInt(pieces[0]);
			height = parseInt(pieces[1]);
			widthInPixels = width * TileSet.TILE_WIDTH_PX;
			heightInPixels = height * TileSet.TILE_WIDTH_PX;
			pieces = StringUtil.trim(lines[3]).split(",");
			for (var i:int = 0; i < width; i++) {
				tiles[i] = new Array();
				tileStates[i] = new Array();
				for (var j:int = 0; j < height; j++) {
					tiles[i].push(parseInt(pieces[i + j * width]));
					tileStates[i].push(0);
				}
			}
		}
		
		/**
		 * Not to be called externally. Please use loadMap.
		 */
		public function Map() {
			layers = new Array();
			for (var i:int = 0; i <= L_AIR; i++) {
				layers.push(new Array());
			}
			tiles = new Array();
			tileStates = new Array();
		}
		
		private static var maps:Array = [new Map(), new Map(), new Map(), new Map(), new Map(), new Map()];
		
		/**
		 * Loads map from the LRU cache or reads map into cache if unavailable.
		 * @param	name The name of the map to load.
		 * @return The singleton instance, with the new loaded data.
		 */
		public static function loadMap(name:String):Map {
			for (var i:int = 0; i < maps.length; i++) {
				if (name == maps[i].filename) {
					var result:Map = maps[i];
					maps = maps.splice(i, 1);
					maps.unshift(result);
					return result;
				}
			}
			var singleton:Map = maps[maps.length - 1];
			// TODO: unload required resources for the old map and load those for new map
			for (i = 0; i < L_AIR; i++) {
				singleton.layers[i].length = 0;
			}
			if (singleton.tileset != null) {
				singleton.tileset.unload();
			}
			singleton.tiles.length = 0;
			singleton.tileStates.length = 0;
			singleton.parseMap(TextAsset.load("../src/assets/maps/mp_" + name + ".txt"));
			singleton.filename = name;
			singleton.tileset.load();
			maps.pop();
			maps.unshift(singleton);
			return singleton;
		}
		
		/**
		 * Adds a MapEntity to the current map at a given layer.
		 * @param	entity The MapEntity to add. Should not be already on a map.
		 * @param	layer The integer ID of the layer to add onto.
		 */
		public function add(entity:MapEntity, layer:int):void {
			entity.setMap(this, layer);
			entity.setLayer(layer);
			layers[layer].push(entity);
		}
		
		public function processMap():void {
			var time:int = getTimer();
			for (var i:int = 0; i <= L_AIR; i++) {
				for each (var entity:MapEntity in layers[i]) {
					entity.process(time);
				}
			}
		}
		
		public function drawMap(canvas:BitmapData):void {
			// Bottoms, all layers except air, tops, air layers
			drawTilesBot(canvas);
			for (var i:int = 0; i <= L_OVERHEAD; i++) {
				for each (var entity:MapEntity in layers[i]) {
					entity.draw(canvas, MapCamera.getCameraX(), MapCamera.getCameraY());
				}
			}
			drawTilesTop(canvas);
			for each (entity in layers[L_AIR]) {
				entity.draw(canvas, MapCamera.getCameraX(), MapCamera.getCameraY());
			}
		}
		
		/**
		 * Gets the width of the map in tiles.
		 * @return The width of the map in tiles.
		 */
		public function getWidth():int {
			return width;
		}
		
		/**
		 * Gets the height of the map in tiles.
		 * @return The height of the map in tiles.
		 */
		public function getHeight():int {
			return height;
		}
		
		public function getWidthInPixels():int {
			return widthInPixels;
		}
		
		public function getHeightInPixels():int {
			return heightInPixels;
		}
		
		// Variables for drawing tiles
		private var t_cameraX:int, t_cameraY:int, t_startX:int, t_endX:int, t_startY:int, t_endY:int;
		
		/**
		 * Draws the tiles seen by the camera and advances the state of all tiles
		 * with an animation sequence. For tiles with an animation sequence that
		 * have yet to start an animation cycle, has a random probability of
		 * beginning an animation next cycle.
		 * @param	canvas The canvas to draw onto.
		 */
		private function drawTilesBot(canvas:BitmapData):void {
			t_cameraX = MapCamera.getCameraX();
			t_cameraY = MapCamera.getCameraY();
			t_startX = t_cameraX / TileSet.TILE_WIDTH_PX;
			t_endX = (t_cameraX + DisplaySettings.DISP_WIDTH) / TileSet.TILE_WIDTH_PX;
			t_startY = t_cameraY / TileSet.TILE_WIDTH_PX;
			t_endY = (t_cameraY + DisplaySettings.DISP_HEIGHT) / TileSet.TILE_WIDTH_PX;
			for (var i:int = t_startX; i <= t_endX; i++) {
				for (var j:int = t_startY; j <= t_endY; j++) {
					// Draw tile bot
					tileset.drawTile(canvas, i * TileSet.TILE_WIDTH_PX - t_cameraX, j * TileSet.TILE_WIDTH_PX -
						t_cameraY, tiles[i][j], tileStates[i][j]);
				}
			}
		}
		
		private function drawTilesTop(canvas:BitmapData):void {
			for (var i:int = t_startX; i <= t_endX; i++) {
				for (var j:int = t_startY; j <= t_endY; j++) {
					// Draw tile top
					tileset.drawTileTop(canvas, i * TileSet.TILE_WIDTH_PX - t_cameraX, j *
						TileSet.TILE_WIDTH_PX - t_cameraY, tiles[i][j], tileStates[i][j]);
				}
			}
			for (i = 0; i < width; i++) {
				for (j = 0; j < height; j++) {
					// Advance tile state
					var totalStates:int = tileset.stateCount(tiles[i][j]);
					if (tileStates[i][j] > 0 || (totalStates > 1 && Math.random() < tileset.animationProb(tiles[i][j]))) {
						tileStates[i][j] = (tileStates[i][j] + 1) % totalStates;
					}
				}
			}
		}
		
		public function getTileSet():TileSet {
			return tileset;
		}
		
		public function getTileIndex(xPos:int, yPos:int):int {
			return tiles[xPos][yPos];
		}
		
		public function getEntitiesInLayer(layer:int):Array {
			return layers[layer];
		}
	}

}