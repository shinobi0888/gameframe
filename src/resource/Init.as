package resource {
	import dialogue.Dialogue;
	import dialogue.Text;
	import event.Command;
	import flash.events.KeyboardEvent;
	import flash.utils.getDefinitionByName;
	import map.MapCamera;
	
	/**
	 * Calls the initialization functions before the game starts.
	 * @author shinobi0888
	 */
	public class Init {
		public static function init(main:Main, callback:Function = null):void {
			initStatics(main, function():void {
					initKeyListeners(main);
					if (callback != null) {
						callback();
					}
				});
		}
		
		private static function initStatics(main:Main, callback:Function = null):void {
			var loadClasses:Array = [Command, Pattern, Dialogue, Text, MapCamera, SaveMem];
			var initFn:Function = function():void {
				if (loadClasses.length == 0) {
					if (callback != null) {
						callback();
					}
					return;
				}
				((loadClasses.shift()) as Class).init(initFn);
			}
			initFn();
		}
		
		private static function initKeyListeners(main:Main):void {
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN, Dialogue.onKeyDown);
			main.stage.addEventListener(KeyboardEvent.KEY_UP, Dialogue.onKeyUp);
		}
	}

}