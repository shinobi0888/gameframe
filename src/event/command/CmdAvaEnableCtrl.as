package event.command {
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdAvaEnableCtrl extends Command {
		public static const TAGNAME:String = "ava_ebl_ctrl";
		public static const REGEX:RegExp = /^ava_ebl_ctrl$/ms;
		
		override public function cleanParams():void {
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			e.getAvatar().enableKeys();
			if (callback != null) {
				callback();
			}
		}
	
	}

}