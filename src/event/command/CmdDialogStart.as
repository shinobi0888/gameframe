package event.command {
	import dialogue.Dialogue;
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdDialogStart extends Command {
		public static const TAGNAME:String = "dlg_start";
		public static const REGEX:RegExp = /^dlg_start (.*) (.*)$/ms;
		
		override public function cleanParams():void {
			if (params[0] == "null") {
				params[0] = null;
			} else {
				params[0] = "../src/assets/portraits/" + params[0] + ".png";
			}
			if (params[1] == "null") {
				params[1] = null;
			} else {
				params[1] = "../src/assets/portraits/" + params[1] + ".png";
			}
		}
		
		override public function addDependencies(deps:Object):void {
			if (params[0] != null)
				deps[params[0]] = true;
			if (params[1] != null)
				deps[params[1]] = true;
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			Dialogue.start(resolveText(params[0]), resolveText(params[1]), callback);
		}
	}

}