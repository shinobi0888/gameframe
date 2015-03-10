package event.command {
	import dialogue.Dialogue;
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdDialogText extends Command {
		public static const TAGNAME:String = "dlg_text";
		public static const REGEX:RegExp = /^dlg_text (.*)$/ms;
		
		override public function cleanParams():void {
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			Dialogue.showText(resolveText(params[0]), callback);
		}
	}

}