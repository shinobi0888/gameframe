package event.command {
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdAvaDisableCtrl extends Command {
		public static const TAGNAME:String = "ava_dbl_ctrl";
		public static const REGEX:RegExp = /^ava_dbl_ctrl$/ms;
		
		override public function cleanParams():void {
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			e.getAvatar().disableKeys();
			if (callback != null) {
				callback();
			}
		}
	}

}