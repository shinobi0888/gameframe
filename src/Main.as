package {
	import demos.AlphaDrawingTest;
	import demos.AvatarTest;
	import demos.CommandTest;
	import demos.DialogueBoxTest;
	import demos.EmbedsTest;
	import demos.MapDemo;
	import demos.SpriteDemo;
	import demos.TextTest;
	import demos.TileSetBasicDemo;
	import demos.WalkingDemo;
	import flash.display.Sprite;
	import demos.BitmapCopyTest;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import resource.Embeds;
	import resource.Init;
	import resource.SaveMem;
	import settings.DisplaySettings;
	/**
	 * ...
	 * @author shinobi0888
	 */
	[SWF(backgroundColor="0xD3D3D3")]
	
	public class Main extends Sprite {
		public function Main():void {
			Init.init(this, function():void {
					AvatarTest.run(stage);
					setUpFPSTimer();
				});
		}
		
		private function setUpFPSTimer():void {
			var frames:int = 0;
			var prevTimer:Number = 0;
			var curTimer:Number = 0;
			
			this.addEventListener(Event.ENTER_FRAME, performFrameTest);
			
			var fpsText:TextField = new TextField();
			fpsText.textColor = 0x0000FF;
			fpsText.x = DisplaySettings.DISP_WIDTH - 48;
			fpsText.y = DisplaySettings.DISP_HEIGHT - 16;
			this.stage.addChild(fpsText);
			
			function performFrameTest(e:Event):void {
				frames += 1;
				curTimer = getTimer();
				if (curTimer - prevTimer >= 1000) {
					fpsText.text = ("FPS: " + Math.round(frames * 1000 / (curTimer - prevTimer)));
					prevTimer = curTimer;
					frames = 0;
				}
			}
		}
	}
}