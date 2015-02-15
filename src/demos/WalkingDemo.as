package demos {
	import flash.automation.StageCapture;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import map.CenteredWalkingMapEntity;
	import map.Map;
	import map.MapCamera;
	import map.WalkingMapEntity;
	import resource.sprite.SpriteBase;
	import settings.DisplaySettings;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class WalkingDemo {
		
		public static function run(stage:Stage):void {
			var stageCanvas:BitmapData = new BitmapData(DisplaySettings.DISP_WIDTH, DisplaySettings.DISP_HEIGHT,
				true, 0x00000000);
			var stageBitmap:Bitmap = new Bitmap(stageCanvas);
			var demoMap:Map = Map.loadMap("test");
			stage.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
					stageCanvas.fillRect(stageCanvas.rect, 0);
					MapCamera.tick();
					demoMap.drawMap(stageCanvas);
				});
			SpriteBase.load("link");
			var demoWalker:CenteredWalkingMapEntity = new CenteredWalkingMapEntity(demoMap,
				"link", 11, 2, 1);
			demoWalker.enableCenter();
			var walking:Boolean = false;
			var code:int;
			var speed:int;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
					var fn:Function = function():void {
						code = e.keyCode;
						if (e.keyCode == 37) {
							demoWalker.startWalk(WalkingMapEntity.LEFT, speed+1);
							walking = true;
						} else if (e.keyCode >= 38 && e.keyCode <= 40) {
							demoWalker.startWalk(e.keyCode - 38, speed+1);
							walking = true;
						}
					}
					if (e.keyCode >= 37 && e.keyCode <= 40) {
						if (walking && e.keyCode != code) {
							demoWalker.stopWalk(fn);
						} else if(!walking) {
							fn();
						}
					}
				});
			stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
					if (walking && e.keyCode >= 37 && e.keyCode <= 40 && e.keyCode == code) {
						demoWalker.stopWalk();
						walking = false;
					} else if (!walking && e.keyCode == 32) {
						speed = ((speed + 1) % 4);
					}
				});
			stage.addChild(stageBitmap);
		}
	
	}

}