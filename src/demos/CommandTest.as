package demos {
	import dialogue.Dialogue;
	import event.BlockCommand;
	import event.Command;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.System;
	import resource.Image;
	import settings.DisplaySettings;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CommandTest {
		public static function run(stage:Stage):void {
			var stageData:BitmapData = new BitmapData(DisplaySettings.DISP_WIDTH, DisplaySettings.DISP_HEIGHT);
			var stageBitmap:Bitmap = new Bitmap(stageData);
			stage.addChild(stageBitmap);
			var cmd:BlockCommand = Command.parseAllCommands("dlg_start bulbasaur bulbasaur\ndlg_text Hello World!\ndlg_end");
			var images:Array = cmd.listDependencies();
			Image.loadAll(images);
			cmd.execute(null, function():void {
					System.exit(0);
				});
			stage.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
					stageData.fillRect(stageData.rect, 0);
					Dialogue.drawTick(stageData);
				});
		}
	}
}