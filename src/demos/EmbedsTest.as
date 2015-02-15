package demos {
	import flash.display.Stage;
	import resource.Embeds;
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class EmbedsTest {
		public static function run(stage:Stage):void {
			var imgClass:Class = Embeds.pathToClass("../src/assets/tests/test.png");
			stage.addChild(new imgClass());
		}
		
	}

}