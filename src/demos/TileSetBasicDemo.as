package demos {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.Timer;
	import map.TileSet;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class TileSetBasicDemo {
		public static function run(stage:Stage):void {
			trace(System.totalMemory);
			var testSet:TileSet = new TileSet("test");
			var stageCanvas:BitmapData = new BitmapData(640, 640, true, 0x00000000);
			var stageBitmap:Bitmap = new Bitmap(stageCanvas);
			testSet.load(function():void {
					trace(System.totalMemory);
					trace("Tile characteristics: " + testSet.passability(0) + ", " + testSet.moveCost(0) +
						", " + testSet.defenseBuff(0) + ", " + testSet.resistanceBuff(0) + ", " +
						testSet.avoidBuff(0) + ", " + testSet.healthRegenBuff(0) + ", " + testSet.energyRegenBuff(0) +
						", " + testSet.stateCount(0));
					testSet.drawTile(stageCanvas, 0, 0, 0);
					testSet.drawTile(stageCanvas, 48, 0, 0);
					testSet.drawTile(stageCanvas, 0, 48, 0);
					testSet.drawTile(stageCanvas, 48, 48, 0);
					stage.addChild(stageBitmap);
					testSet.unload();
				});
			var timer:Timer = new Timer(3000);
			timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
					trace(System.totalMemory);
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					testSet.load(function():void {
							trace("Tile characteristics: " + testSet.passability(0) + ", " + testSet.moveCost(0) +
								", " + testSet.defenseBuff(0) + ", " + testSet.resistanceBuff(0) +
								", " + testSet.avoidBuff(0) + ", " + testSet.healthRegenBuff(0) +
								", " + testSet.energyRegenBuff(0) + ", " + testSet.stateCount(0));
							testSet.drawTile(stageCanvas, 96, 0, 0);
							testSet.drawTile(stageCanvas, 144, 0, 0, 1);
							testSet.drawTile(stageCanvas, 96, 48, 0, 1);
							testSet.drawTile(stageCanvas, 144, 48, 0);
							testSet.unload();
						});
				});
			timer.start();
		}
	}

}