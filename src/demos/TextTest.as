package demos {
	import dialogue.Text;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import settings.DisplaySettings;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class TextTest {
		public static function run(stage:Stage):void {
			var stageData:BitmapData = new BitmapData(DisplaySettings.DISP_WIDTH, DisplaySettings.DISP_HEIGHT);
			var stageBitmap:Bitmap = new Bitmap(stageData);
			stage.addChild(stageBitmap);
			stageData.fillRect(new Rectangle(0, 0, 768, 432), 0xFF006888);
			Text.drawText(0, "The quick brown fox jumps over the lazy dog", stageData,
				32, 32, 640, 8, 1, true);
		}
	}

}