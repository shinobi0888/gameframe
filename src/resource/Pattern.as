package resource {
	import flash.geom.Point;
	
	/**
	 * Represents patterns of points used in unit occupation, skills, etc.
	 * @author shinobi0888
	 */
	public class Pattern {
		private static const PATTERNS:Object = new Object();
		
		public static function init(callback:Function = null):void {
			PATTERNS["single"] = [new Point(0, 0)];
			if (callback != null) {
				callback();
			}
		}
		
		public static function getPattern(name:String):Array {
			return PATTERNS.hasOwnProperty(name) ? PATTERNS[name] : null;
		}
	}

}