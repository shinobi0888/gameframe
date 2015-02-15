package demos {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import resource.Image;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class AlphaDrawingTest {
		public static function run(stage:Stage):void {
			var stageCanvas:BitmapData = new BitmapData(640, 640, true, 0x00000000);
			var stageBitmap:Bitmap = new Bitmap(stageCanvas);
			stage.addChild(stageBitmap);
			Image.loadImage("../src/assets/tests/test.png", function(image:BitmapData):void {
					Image.drawTo("../src/assets/tests/test.png", stageCanvas, 0, 0);
					Image.drawTo("../src/assets/tests/test.png", stageCanvas, 0, 0, 24, 24,
						48, 48, 0.75);
					Image.drawTo("../src/assets/tests/test.png", stageCanvas, 24, 24, 0, 0,
						-1, -1, 0.5);
				});
		}
	}

}