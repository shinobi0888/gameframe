package event.command {
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdNpcDisableProcess  extends Command {
		public static const TAGNAME:String = "npc_dbl_prcs";
		public static const REGEX:RegExp = /^npc_dbl_prcs$/ms;
		
		override public function cleanParams():void {
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			e.getDeployer().disableProcessing();
			if (callback != null) {
				callback();
			}
		}
	}

}