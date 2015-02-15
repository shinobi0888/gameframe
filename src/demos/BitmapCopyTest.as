package demos {
	import flash.display.Stage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	/**
	 * Tests the copyPixels code for BitmapData, applying alpha levels from the loaded PNG.
	 * @author shinobi0888
	 */
	public class BitmapCopyTest {
		public static function run(stage:Stage):void {
			var stageData:BitmapData = new BitmapData(200, 200);
			var stageBitmap:Bitmap = new Bitmap(stageData);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
					var bitmapData:BitmapData = e.target.content.bitmapData;
					stageData.copyPixels(bitmapData, new Rectangle(0, 0, 96, 96), new Point(0, 0), null, null, true);
					stageData.copyPixels(bitmapData, new Rectangle(0, 0, 96, 96), new Point(32, 32), null, null, true);
				});
			loader.load(new URLRequest("../src/assets/tests/test.png"));
			stage.addChild(stageBitmap);
		}
	}

}