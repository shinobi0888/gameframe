package map {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import resource.Pattern;
	import resource.sprite.Sprite;
	import resource.sprite.SpriteBase;
	import settings.DisplaySettings;
	
	/**
	 * Represents anything that can be contained on a layer of a Map, with
	 * a drawable image. Occupies a position on the map on a certain layer
	 * in which it cannot collide with any other MapEntities.
	 * @author shinobi0888
	 */
	public class MapEntity {
		protected static const DEFAULT_PROCESS_DELAY:int = 8000;
		
		// Handling for move event (changing map position)
		protected var onMoveHandlers:Array;
		
		// Variables for drawing and animation
		protected var sprite:Sprite;
		protected var enabled:Boolean;
		
		// Map related properties
		protected var gridX:int, gridY:int;
		protected var occupiedCells:Array;
		protected var containingMap:Map;
		protected var layer:int;
		
		// Processing properties
		protected var needToProcess:Boolean;
		protected var nextProcessTime:int;
		
		public function MapEntity(containingMap:Map, spriteName:String, gridX:int, gridY:int,
			layer:int, occupiedCells:Array = null) {
			onMoveHandlers = new Array();
			containingMap.add(this, layer);
			this.gridX = gridX;
			this.gridY = gridY;
			enabled = true;
			this.occupiedCells = occupiedCells == null ? Pattern.getPattern("single") :
				occupiedCells;
			if (spriteName != null) {
				sprite = SpriteBase.getInstance(spriteName);
			}
		}
		
		/**
		 * Draws the current MapEntity onto the display canvas if it is currently
		 * visible to the camera.
		 * @param	canvas The canvas to draw to.
		 * @param	cameraX The x position of the camera.
		 * @param	cameraY The y position of the camera.
		 */
		public function draw(canvas:BitmapData, cameraX:int, cameraY:int):void {
			if (!enabled) {
				return;
			}
			var aniOffset:Point = sprite.getAnimationOffset();
			var offsetX:int = sprite.getDrawCornerX() + gridX * TileSet.TILE_WIDTH_PX;
			var aniOffsetX:int = offsetX + aniOffset.x;
			var offsetY:int = sprite.getDrawCornerY() + gridY * TileSet.TILE_WIDTH_PX;
			var aniOffsetY:int = offsetY + aniOffset.y;
			if (cameraX > aniOffsetX - DisplaySettings.DISP_WIDTH && cameraX < aniOffsetX +
				sprite.getWidth() && cameraY > aniOffsetY - DisplaySettings.DISP_HEIGHT &&
				cameraY < aniOffsetY + sprite.getHeight()) {
				sprite.draw(canvas, offsetX - cameraX, offsetY - cameraY);
			}
			sprite.advance();
		}
		
		/**
		 * Attaches this entity to a map. SHOULD ONLY BE CALLED BY MAP WHEN
		 * ADDING THIS ENTITY TO A LAYER. No other class should call this
		 * function.
		 * @param	map The calling Map that will contain this entity.
		 */
		public function setMap(map:Map, layer:int):void {
			this.containingMap = map;
			this.layer = layer;
		}
		
		public function setLayer(layer:int):void {
			this.layer = layer;
		}
		
		public function getGridX():int {
			return gridX;
		}
		
		public function getGridY():int {
			return gridY;
		}
		
		public function setPos(x:int, y:int):void {
			var oldX:int = gridX, oldY:int = gridY;
			gridX = x;
			gridY = y;
			signalMove(oldX, oldY, gridX, gridY);
		}
		
		/**
		 * Checks if a given position on a map collides with this
		 * MapEntity.
		 * @param	xPos The x position to check against.
		 * @param	yPos The y position to check against.
		 * @return True if the point collides with this MapEntity.
		 */
		public function checkCollision(xPos:int, yPos:int):Boolean {
			if (!enabled) {
				return false;
			}
			for each (var cell:Point in occupiedCells) {
				if (xPos == cell.x + this.gridX && yPos == cell.y + this.gridY) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Checks if an entire MapEntity collides with this MapEntity.
		 * @param	entity The entity to check against this one for
		 * collisions.
		 * @param xShift A test x offset to move the current entity
		 * by.
		 * @param yShift A test y offset to move the current entity
		 * by.
		 * @return True if there is no collision.
		 */
		public function checkEntityCollision(entity:MapEntity, xShift:int = 0, yShift:int = 0):Boolean {
			if (!enabled || !entity.enabled) {
				return false;
			}
			for each (var cell:Point in occupiedCells) {
				if (entity.checkCollision(cell.x + gridX + xShift, cell.y + gridY + yShift)) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Attaches a handler to this entity and responds when
		 * this entity moves.
		 * @param	callback
		 */
		public function onMove(callback:Function):void {
			onMoveHandlers.push(callback);
		}
		
		// Helper to signal move to all listeners
		private function signalMove(oldX:int, oldY:int, newX:int, newY:int):void {
			for each (var callback:Function in onMoveHandlers) {
				callback(oldX, oldY, newX, newY);
			}
		}
		
		// Processing
		
		/**
		 * Processes this entity and sets the next process time and if it needs
		 * to be processed later.
		 */
		public final function process(time:int):void {
			if (!needToProcess || time < nextProcessTime) {
				return;
			}
			processInner(time);
		}
		
		public function disableProcessing():void {
			nextProcessTime = int.MAX_VALUE;
		}
		
		public function enableProcessing():void {
			nextProcessTime = -1;
		}
		
		/**
		 * Internal processing that should be overridden by subclasses for
		 * functionality. Must set the nextProcessTime.
		 */
		protected function processInner(time:int):void {
			nextProcessTime = time + DEFAULT_PROCESS_DELAY;
		}
	}

}