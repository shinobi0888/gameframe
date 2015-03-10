package event.command {
	import dialogue.Dialogue;
	import event.Command;
	import event.EventDispatcher;
	import resource.SaveMem;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdDialogChoice extends Command {
		public static const TAGNAME:String = "dlg_choice";
		public static const REGEX:RegExp = /^dlg_choice (.*)~(.*)~(.*)$/ms;
		
		override public function cleanParams():void {
			if (params[0] == "null") {
				params[0] = null;
			}
			params[1] = params[1].split(";");
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			Dialogue.showChoice(params[2], params[1], params[0] == null ? callback : function():void {
					SaveMem.setVar(params[0].replace(/\$/g, ""), Dialogue.getChoice());
					if (callback != null) {
						callback();
					}
				});
		}
	}

}