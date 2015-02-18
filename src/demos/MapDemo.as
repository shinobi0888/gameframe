package demos {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import map.Map;
	import map.MapCamera;
	import map.TileSet;
	import settings.DisplaySettings;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class MapDemo {
		public static function run(stage:Stage):void {
			var stageCanvas:BitmapData = new BitmapData(DisplaySettings.DISP_WIDTH, DisplaySettings.DISP_HEIGHT,
				true, 0x00000000);
			var stageBitmap:Bitmap = new Bitmap(stageCanvas);
			var demoMap:Map = Map.loadMap("test");
			stage.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
					stageCanvas.fillRect(stageCanvas.rect, 0);
					MapCamera.tick();
					demoMap.processMap();
					demoMap.drawMap(stageCanvas);
				});
			stage.addChild(stageBitmap);
			var t:Timer = new Timer(3000, 24);
			var coords:Array = [24*48-769, 0, 0, 200, 24*48-769, 200, 0, 400, 24*48-769, 400, 0, 0];
			var counter:int = 0;
			t.addEventListener(TimerEvent.TIMER, function():void {
					MapCamera.requestFocus(coords[counter * 2], coords[counter * 2 + 1]);
					counter = (counter + 1) % 6;
				});
			t.start();
		}
	
	}

}