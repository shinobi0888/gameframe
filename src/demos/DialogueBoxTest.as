package demos {
	import dialogue.Dialogue;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.Timer;
	import resource.Image;
	import settings.DisplaySettings;
	
	/**
	 * Tests the drawing of a simple dialog box.
	 * @author shinobi0888
	 */
	public class DialogueBoxTest {
		public static function run(stage:Stage):void {
			var stageData:BitmapData = new BitmapData(DisplaySettings.DISP_WIDTH, DisplaySettings.DISP_HEIGHT);
			var stageBitmap:Bitmap = new Bitmap(stageData);
			stage.addChild(stageBitmap);
			var images:Array = new Array();
			images.push("../src/assets/tests/test.png");
			images.push("../src/assets/tests/test2.png");
			Image.loadAll(images, function():void {
					Dialogue.start("../src/assets/tests/test.png", "../src/assets/tests/test.png");
					Dialogue.showChoice("Choose a choice the quick brown fox jumps over the lazy dog Electrode:",
						["Electrode", "Diglett", "Nidoran", "Mankey", "Venusaur", "Ratatta", "Fearow", "Pidgey"],
						function():void {
							Dialogue.showText("Hi, " + Dialogue.getChoice() + ". This is a Bulbasaur. It is a Pokemon. Welcome to the world of Pokemon! My name is Prof. Oak. People know me as the Pokemon Professor Lalalal Text aaaaaaaaaaaaaaaaaaaaa");
							Dialogue.leftFadeCross("../src/assets/tests/test2.png");
							Dialogue.rightFadeCross("../src/assets/tests/test2.png");
							Dialogue.showText("These are Ivysaurs, the evolved forms of Bulbasaur. The bulb on its back has developed into a sturdier plant, forcing it to use its hindlegs to support its weight.");
							Dialogue.end(function():void {
									System.exit(0);
								});
						});
					
					stage.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
							stageData.fillRect(stageData.rect, 0);
							Dialogue.drawTick(stageData);
						});
				});
		}
	}

}