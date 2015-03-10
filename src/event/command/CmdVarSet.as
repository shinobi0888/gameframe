package event.command {
	import event.Command;
	import event.EventDispatcher;
	import resource.SaveMem;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdVarSet extends Command {
		public static const TAGNAME:String = "var_set";
		public static const REGEX:RegExp = /^var_set (.*)~(.*)$/ms;
		
		override public function cleanParams():void {
			params[0] = params[0].substr(1, params[0].length - 2);
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			if (params[1] == "true" || params[1] == "false") {
				SaveMem.setVar(params[0], params[1] == "true");
			} else {
				SaveMem.setVar(params[0], isNaN(Number(params[1])) ? params[1] : Number(params[1]));
			}
			if (callback != null) {
				callback();
			}
		}
	}

}