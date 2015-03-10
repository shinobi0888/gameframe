package event.command {
	import dialogue.Dialogue;
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdDialogLfi extends Command {
		public static const TAGNAME:String = "dlg_lfi";
		public static const REGEX:RegExp = /^dlg_lfi (.*)$/ms;
		
		override public function cleanParams():void {
			if (params[0] == "null") {
				params[0] = null;
			} else {
				params[0] = "../src/assets/portraits/" + params[0] + ".png";
			}
		}
		
		override public function addDependencies(deps:Object):void {
			if (params[0] != null)
				deps[params[0]] = true;
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			Dialogue.leftFadeIn(resolveText(params[0]), callback);
		}
	}

}