package resource {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	/**
	 * A class used to load in bitmap data.
	 * @author shinobi0888
	 */
	public class Image {
		private static const imageMap:Object = new Object();
		private static const imageLoader:Loader = new Loader();
		
		/**
		 * Loads an image for use. Does not actually load an image if it has
		 * already been loaded previously.
		 * @param	path The path of the image to load.
		 * @param	callback A callback function, taking the BitmapData of the
		 * expected loaded image as a parameter.
		 */
		public static function loadImage(path:String, callback:Function = null):void {
			if (imageMap.hasOwnProperty(path)) {
				if (callback != null) {
					callback(imageMap[path]);
				}
			} else {
				imageMap[path] = new (Embeds.pathToClass(path) as Class)().bitmapData;
				if (callback != null) {
					callback(imageMap[path]);
				}
			}
		}
		
		/**
		 * Loads all paths in an array of paths and calls a callback
		 * on completion.
		 * @param	paths An Array of paths to load.
		 * @param	callback A function taking no arguments that will be called
		 * on completion.
		 */
		public static function loadAll(paths:Array, callback:Function = null):void {
			paths = paths.slice();
			loadImage(paths.shift(), function(bitmapData:BitmapData):void {
					if (paths.length == 0) {
						if (callback != null)
							callback();
					} else {
						loadAll(paths, callback);
					}
				});
		}
		
		/**
		 * Retrieves a previously loaded image.
		 * @param	path The path to the image.
		 * @return The BitmapData for the requested image.
		 */
		public static function getImage(path:String):BitmapData {
			return imageMap.hasOwnProperty(path) ? imageMap[path] : null;
		}
		
		// Retrieves the width of an image
		public static function iWidth(path:String):int {
			return imageMap.hasOwnProperty(path) ? imageMap[path].width : -1;
		}
		
		// Retrieves the height of an image
		public static function iHeight(path:String):int {
			return imageMap.hasOwnProperty(path) ? imageMap[path].height : -1;
		}
		
		/**
		 * Unloads an image, freeing up memory. Does nothing if the image was not
		 * previously loaded.
		 * @param	path The path to the image.
		 */
		public static function unloadImage(path:String):void {
			if (imageMap.hasOwnProperty(path)) {
				delete imageMap[path];
			}
		}
		
		/**
		 * Unloads all images in an array of paths.
		 * @param	paths An Array of paths to unload.
		 */
		public static function unloadAll(paths:Array):void {
			for each (var path:String in paths) {
				if (imageMap.hasOwnProperty(path)) {
					delete imageMap[path];
				}
			}
		}
		
		// Related variables to draw
		private static var areaRect:Rectangle = new Rectangle();
		private static var drawPoint:Point = new Point();
		
		/**
		 * Draws a given loaded image to a canvas with a given opacity. Destination
		 * x and y are provided for drawing location.
		 * @param	path The path of the image to draw.
		 * @param	canvas The canvas, a BitmapData to draw onto.
		 * @param	x The x coordinate onto the canvas to draw to.
		 * @param	y The y coordinate onto the canvas to draw to.
		 * @param	alpha The alpha level to draw with.
		 */
		public static function drawTo(path:String, canvas:BitmapData, x:int, y:int, areaX:int = 0,
			areaY:int = 0, areaWidth:int = -1, areaHeight:int = -1, alpha:Number = 1.0):void {
			if (!imageMap.hasOwnProperty(path)) {
				throw new Error("Unloaded image being drawn");
			}
			var image:BitmapData = imageMap[path];
			drawPoint.x = x;
			drawPoint.y = y;
			areaRect.x = areaX;
			areaRect.y = areaY;
			areaRect.width = areaWidth == -1 ? image.width : areaWidth;
			areaRect.height = areaHeight == -1 ? image.height : areaHeight;
			if (alpha == 1.0) {
				canvas.copyPixels(image, areaRect, drawPoint, null, null, true);
			} else if (alpha == 0.0) {
				return;
			} else {
				var alphaData:BitmapData = new BitmapData(areaRect.width, areaRect.height,
					true, int(alpha * 256) * 0x01000000);
				canvas.copyPixels(image, areaRect, drawPoint, alphaData, null, true);
			}
		}
	}

}