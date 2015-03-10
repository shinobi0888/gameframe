package event.command {
	import dialogue.Dialogue;
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdDialogRfo extends Command {
		public static const TAGNAME:String = "dlg_rfo";
		public static const REGEX:RegExp = /^dlg_rfo$/ms;
		
		override public function cleanParams():void {
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			Dialogue.rightFadeOut(callback);
		}
	}

}