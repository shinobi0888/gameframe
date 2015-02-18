package demos {
	import dialogue.Dialogue;
	import event.EventDispatcher;
	import flash.automation.StageCapture;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import map.CenteredWalkingMapEntity;
	import map.entities.Avatar;
	import map.entities.NPC;
	import map.Map;
	import map.MapCamera;
	import map.WalkingMapEntity;
	import resource.sprite.SpriteBase;
	import settings.DisplaySettings;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class AvatarTest {
		
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
					Dialogue.drawTick(stageCanvas);
				});
			SpriteBase.load("link");
			var demoWalker:Avatar = new Avatar(demoMap, 11, 2);
			EventDispatcher.setAvatar(demoWalker);
			demoWalker.registerKeys(stage);
			demoWalker.enableKeys();
			demoWalker.enableCenter();
			stage.addChild(stageBitmap);
		}
	
	}

}