package map {
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display3D.textures.RectangleTexture;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import resource.Image;
	import resource.TextAsset;
	
	/**
	 * Represents a collection of tiles used together in multiple maps. Can be
	 * used to load and unload tilesets as needed when certain maps go from
	 * in use to out of use. Contains both methods to draw tiles as well as
	 * obtain battle characteristics of tiles. Can be loaded and unloaded to
	 * conserve memory. It is up to the coder to guarantee no calls to draw and
	 * statistics functions are made when the tileset is unloaded. By default,
	 * all tilesets begin in an unloaded state.
	 *
	 * Naming conventions of resources:
	 * 	ts_setname.png
	 * 	ts_setname_data.txt
	 * Resource format convention:
	 * 	tiledata:
	 * 		sprite index, passability, movecost, defense, resistance, avoid, health, energy, state count, ticks per state, animationProbability, 3d;
	 * @author shinobi0888
	 */
	public class TileSet {
		public static const TILE_WIDTH_PX:int = 48;
		private static const ASSET_PATH:String = "../src/assets/tilesets/";
		private static const TILEDATA_FORMAT:RegExp = new RegExp("^([0-9]+,\\s*[0-9]+,\\s*[0-9]+,\\s*[0-9]+,\\s*[0-9]+,\\s*[0-9]+,\\s*[0-9]+,\\s*[0-9]+,\\s*[0-9]+,\\s*[0-9]+,\\s*[0-9]+,\\s*[0-9]+;\\s*)+$",
			"gm");
		
		private var setName:String;
		private var isLoaded:Boolean;
		private var tileBitmapData:BitmapData;
		private var tileData:Array; // 2D array of numbers
		private var tilesPerRow:int;
		
		public function TileSet(setName:String) {
			this.setName = setName;
			unload();
		}
		
		/**
		 * Loads both the tileset bitmaps and the text data associated wtih tile
		 * stats. Can be provided a callback function to call when both pieces
		 * have been successfully loaded.
		 * @param	callback A callback function to be called at the end of loading
		 * process.
		 */
		public function load(callback:Function = null):void {
			var loadFinishCount:int = 0;
			Image.loadImage(ASSET_PATH + "ts_" + setName + ".png", function(image:BitmapData):void {
					tileBitmapData = image;
					tilesPerRow = tileBitmapData.width / TILE_WIDTH_PX;
					parseAndLoadTileData(TextAsset.load(ASSET_PATH + "ts_" + setName + "_data.txt"));
					isLoaded = true;
					if (callback != null)
						callback();
				});
		}
		
		// Helper to parse text data for tile stats
		private function parseAndLoadTileData(textData:String):void {
			tileData = new Array();
			var tileTextData:Array = textData.match(TILEDATA_FORMAT)[0].split(";");
			for (var i:int = 0; i < tileTextData.length; i++) {
				var tileEntry:String = tileTextData[i];
				if (tileEntry.length == 0) {
					continue;
				}
				var tileEntryValues:Array = tileEntry.replace(";", "").split(",");
				var tileEntryParsed:Array = new Array(tileEntryValues.length);
				for (var j:int = 0; j < tileEntryValues.length; j++) {
					tileEntryParsed[j] = parseInt(tileEntryValues[j]);
				}
				tileData.push(tileEntryParsed);
			}
		}
		
		/**
		 * Unloads and releases stored data about the tileset so the garbage
		 * collector can reuse memory. After an unload call, no further
		 * calls to draw and stat functions should be made until resources are
		 * reloaded.
		 */
		public function unload():void {
			Image.unloadImage(ASSET_PATH + "ts_" + setName + ".png");
			tileData = null;
			tileBitmapData = null;
			isLoaded = false;
		}
		
		public function loaded():Boolean {
			return isLoaded;
		}
		
		private var drawRect:Rectangle = new Rectangle(0, 0, TILE_WIDTH_PX, TILE_WIDTH_PX);
		private var drawPoint:Point = new Point();
		
		/**
		 * Draws the specified tile with the given tile ID onto the canvas at the
		 * specified x and y coordinates. If the tile is a multistate tile, the
		 * state can be provided to draw a different tile state.
		 * @param	canvas The canvas to draw onto.
		 * @param	x The x position of the destination.
		 * @param	y The y position of the destination.
		 * @param	tileId The tile ID (integer) of the tile to draw.
		 * @param	state Optional state when depicting different states of a multi
		 * state tile.
		 */
		public function drawTile(canvas:BitmapData, x:int, y:int, tileId:int, state:int = 0):void {
			var tileIndex:int = tileData[tileId][0] + int(state / tileData[tileId][9]);
			drawRect.x = int(tileIndex % tilesPerRow) * TILE_WIDTH_PX;
			drawRect.y = int(tileIndex / tilesPerRow) * TILE_WIDTH_PX;
			drawPoint.x = x;
			drawPoint.y = y;
			canvas.copyPixels(tileBitmapData, drawRect, drawPoint, null, null, true);
		}
		
		public function drawTileTop(canvas:BitmapData, x:int, y:int, tileId:int, state:int = 0):void {
			if (tileData[tileId][11] > 0) {
				var tileIndex:int = tileData[tileId][0] + int(state / tileData[tileId][9]) +
					tileData[tileId][8];
				drawRect.x = int(tileIndex % tilesPerRow) * TILE_WIDTH_PX;
				drawRect.y = int(tileIndex / tilesPerRow) * TILE_WIDTH_PX;
				drawPoint.x = x;
				drawPoint.y = y;
				canvas.copyPixels(tileBitmapData, drawRect, drawPoint, null, null, true);
			}
		}
		
		// Functions to retrieve battle properties of tiles by tileId
		
		public function passability(tileId:int):int {
			return tileData[tileId][1];
		}
		
		public function moveCost(tileId:int):int {
			return tileData[tileId][2];
		}
		
		public function defenseBuff(tileId:int):int {
			return tileData[tileId][3];
		}
		
		public function resistanceBuff(tileId:int):int {
			return tileData[tileId][4];
		}
		
		public function avoidBuff(tileId:int):int {
			return tileData[tileId][5];
		}
		
		public function healthRegenBuff(tileId:int):int {
			return tileData[tileId][6];
		}
		
		public function energyRegenBuff(tileId:int):int {
			return tileData[tileId][7];
		}
		
		public function stateCount(tileId:int):int {
			return tileData[tileId][8] * tileData[tileId][9];
		}
		
		public function ticksPerState(tileId:int):int {
			return tileData[tileId][9];
		}
		
		public function animationProb(tileId:int):Number {
			return tileData[tileId][10] / 100.0;
		}
	}

}