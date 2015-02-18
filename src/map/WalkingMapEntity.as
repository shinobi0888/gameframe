package map {
	
	/**
	 * MapEntities that support walking animation for traveling.
	 * Animation name convention is as follows:
	 *	 idle_[dir]: Idle animation state in a direction
	 *   walking_[dir]: Walking animation state in a direction
	 *   walking_[dir]_s[n]: Walking animation state in a direction with speed
	 * @author shinobi0888
	 */
	public class WalkingMapEntity extends MapEntity {
		public static const UP:int = 1;
		public static const RIGHT:int = 2;
		public static const DOWN:int = 3;
		public static const LEFT:int = 0;
		private static const DIR_STRINGS:Array = ["left", "up", "right", "down"];
		protected static const DIR_XCHANGE:Array = [-1, 0, 1, 0];
		protected static const DIR_YCHANGE:Array = [0, -1, 0, 1];
		
		protected var dir:int;
		private var shouldStopWalk:Boolean;
		private var stopCallback:Function;
		protected var inLoop:Boolean;
		protected var inStep:Boolean;
		
		public function WalkingMapEntity(containingMap:Map, spriteName:String, gridX:int,
			gridY:int, layer:int, occupiedCells:Array = null) {
			super(containingMap, spriteName, gridX, gridY, layer, occupiedCells);
			shouldStopWalk = false;
			inLoop = false;
			inStep = false;
			// Set idle animation
			sprite.queueAnimation("idle_down", true);
		}
		
		/**
		 * Turns the entity in the given direction, if idle.
		 * @param	direction The direction to turn.
		 */
		public function turn(direction:int):void {
			if (sprite.getCurrentAnimation().indexOf("idle_") == 0 && !inLoop && !inStep) {
				dir = direction;
				sprite.terminateAnimations(0);
				sprite.queueAnimation("idle_" + DIR_STRINGS[direction], true);
			}
		}
		
		/**
		 * Queues a walk animation to be started, immediately discarding any
		 * pending animation history. Will only act if the entity is in an
		 * idle state. Even if the entity cannot move in the given direction,
		 * an attempt to change the orientation of the entity will be performed.
		 * @param	direction The direction to attempt walking in.
		 * @param	speed The speed of the walk animation, default being 1.
		 */
		public function startWalk(direction:int, speed:int = 1):void {
			// Check if current state allows walking
			if (sprite.getCurrentAnimation().indexOf("idle_") == 0 && !inLoop && !inStep) {
				if (!canWalk(direction)) {
					sprite.terminateAnimations(0);
					sprite.queueAnimation("idle_" + DIR_STRINGS[direction], true);
					return;
				}
				dir = direction;
				inLoop = true;
				shouldStopWalk = false;
				sprite.terminateAnimations(0);
				sprite.queueAnimation("walking_" + DIR_STRINGS[dir] + (speed == 1 ? "" :
					("_s" + speed)), true, null, function():void {
						setPos(gridX + DIR_XCHANGE[dir], gridY + DIR_YCHANGE[dir]);
						if (!canWalk(dir) || shouldStopWalk) {
							sprite.terminateAnimations(0);
							sprite.queueAnimation("idle_" + DIR_STRINGS[dir], true);
							inLoop = false;
							if (stopCallback != null) {
								stopCallback();
							}
						}
					});
			}
		}
		
		/**
		 * Signals that an ongoing loop walk should be interrupted at the next
		 * completion stage.
		 * @param	callback An optional callback to call upon completion of walk.
		 */
		public function stopWalk(callback:Function = null):void {
			if (!shouldStopWalk && inLoop) {
				stopCallback = callback;
				shouldStopWalk = true;
			}
		}
		
		/**
		 * Queues a walk animation with a given distance duration. Will auto
		 * interrupt if the walk cannot be completed due to barriers or
		 * collisions/walkability constraints.
		 * @param	direction The direction to walk in.
		 * @param	steps The number of steps to take.
		 * @param	speed The speed of the walk, default 1.
		 * @param	callback An optional callback to perform at the end of the walk.
		 */
		public function setWalk(direction:int, steps:int, speed:int = 1, callback:Function = null):void {
			if (sprite.getCurrentAnimation().indexOf("idle_") == 0 && !inLoop && !inStep) {
				if (!canWalk(direction) || steps == 0) {
					sprite.terminateAnimations(0);
					sprite.queueAnimation("idle_" + DIR_STRINGS[direction], true);
					if (callback != null) {
						callback();
					}
					return;
				}
				dir = direction;
				sprite.terminateAnimations(0);
				sprite.queueAnimation("walking_" + DIR_STRINGS[dir] + (speed == 1 ? "" :
					("_s" + speed)), true, null, function():void {
						setPos(gridX + DIR_XCHANGE[dir], gridY + DIR_YCHANGE[dir]);
						steps--;
						if (!canWalk(dir) || steps == 0) {
							sprite.terminateAnimations(0);
							sprite.queueAnimation("idle_" + DIR_STRINGS[dir], true);
							inLoop = false;
							if (stopCallback != null) {
								stopCallback();
							}
						}
					});
			}
		}
		
		/**
		 * Checks if the current MapEntity can move in a given direction on its
		 * current map.
		 * @param	direction The direction to attempt to move in.
		 * @return True if possible, false otherwise.
		 */
		public function canWalk(direction:int, lookahead:int = 0):Boolean {
			// Check bounds
			var newX:int = gridX + DIR_XCHANGE[direction] * (lookahead + 1);
			var newY:int = gridY + DIR_YCHANGE[direction] * (lookahead + 1);
			if (newX < 0 || newX >= containingMap.getWidth() || newY < 0 || newY >= containingMap.getHeight()) {
				return false;
			}
			// Check passability of tile
			var tileIndex:int = containingMap.getTileIndex(newX, newY);
			if (!canPass(containingMap.getTileSet().passability(tileIndex), containingMap.getTileSet().moveCost(tileIndex))) {
				return false;
			}
			// Check same map collisions
			if (checkHypotheticalCollisions(newX, newY)) {
				return false;
			}
			return true;
		}
		
		/**
		 * Overrideable function to determine whether a certain WalkingMapEntity
		 * can pass over a given tile.
		 * @param	passability The passability of the tile.
		 * @param moveCost The cost of moving over the tile.
		 * @return True if the WalkingMapEntity can pass over the tile.
		 */
		public function canPass(passability:int, moveCost:int):Boolean {
			return passability == 0;
		}
		
		private function checkHypotheticalCollisions(newX:int, newY:int):Boolean {
			var deltaX:int = newX - gridX;
			var deltaY:int = newY - gridY;
			for each (var entity:MapEntity in containingMap.getEntitiesInLayer(layer)) {
				if (this.checkEntityCollision(entity, deltaX, deltaY)) {
					return true;
				}
			}
			return false;
		}
	}
}