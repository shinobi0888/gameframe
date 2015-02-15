package map {
	
	/**
	 * Singleton class for representing the camera position on the active Map.
	 * Can be moved and requested for focus
	 * @author shinobi0888
	 */
	public class MapCamera {
		// Number of frames to pan to a camera location
		private static const PAN_TIME:int = 60;
		
		private static var posX:Number, posY:Number;
		private static var destX:int, destY:int;
		private static var stepX:Number, stepY:Number;
		
		public static function init(callback:Function = null):void {
			posX = 0;
			posY = 0;
			stepX = 0;
			stepY = 0;
			destX = 0;
			destY = 0;
			if (callback != null) {
				callback();
			}
		}
		
		/**
		 * To be called at each tick to animate the camera if a destination
		 * central focus is provided.
		 */
		public static function tick():void {
			if (Math.abs(destX - posX) <= Math.abs(stepX) && Math.abs(destY - posY) <=
				Math.abs(stepY)) {
				posX = destX;
				posY = destY;
				stepX = stepY = 0;
			} else {
				posX += stepX;
				posY += stepY;
			}
		}
		
		public static function requestFocus(fx:int, fy:int, panTime:int = PAN_TIME):void {
			destX = fx;
			destY = fy;
			stepX = (destX - posX) / panTime;
			stepY = (destY - posY) / panTime;
		}
		
		public static function getCameraX():int {
			return int(posX);
		}
		
		public static function getCameraY():int {
			return int(posY);
		}
	}

}