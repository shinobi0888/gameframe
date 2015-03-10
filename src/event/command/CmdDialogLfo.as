package event.command {
	import dialogue.Dialogue;
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdDialogLfo extends Command {
		public static const TAGNAME:String = "dlg_lfo";
		public static const REGEX:RegExp = /^dlg_lfo$/ms;
		
		override public function cleanParams():void {
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			Dialogue.leftFadeOut(callback);
		}
	}

}