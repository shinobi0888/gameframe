package demos {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import resource.sprite.Sprite;
	import resource.sprite.SpriteBase;
	import settings.DisplaySettings;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class SpriteDemo {
		
		public static function run(stage:Stage):void {
			var stageCanvas:BitmapData = new BitmapData(DisplaySettings.DISP_WIDTH, DisplaySettings.DISP_HEIGHT,
				true, 0x00000000);
			var stageBitmap:Bitmap = new Bitmap(stageCanvas);
			var testSprite:Sprite = SpriteBase.load("test").getSpriteInstance();
			var range:int = -32;
			testSprite.queueAnimation("attack", true, [range, 0]);
			stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
					if (e.keyCode == 37) {
						range = Math.max(range - 16, -192);
						testSprite.breakAnimationLoop();
						testSprite.terminateAnimations(1);
						testSprite.queueAnimation("attack", true, [range, 0]);
						counter.text = range+"";
					} else if (e.keyCode == 39) {
						range = Math.min(range + 16, -32);
						testSprite.breakAnimationLoop();
						testSprite.terminateAnimations(1);
						testSprite.queueAnimation("attack", true, [range, 0]);
						counter.text = range+"";
					}
				});
			stage.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
					stageCanvas.fillRect(stageCanvas.rect, 0);
					testSprite.draw(stageCanvas, 192, 96);
					testSprite.advance();
				});
			stage.addChild(stageBitmap);
			var counter:TextField = new TextField();
			counter.text = range+"";
			stage.addChild(counter);
		}
	
	}
}