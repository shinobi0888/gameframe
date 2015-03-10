package event.command {
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdNpcEnableProcess  extends Command{
		public static const TAGNAME:String = "npc_ebl_prcs";
		public static const REGEX:RegExp = /^npc_ebl_prcs$/ms;
		
		override public function cleanParams():void {
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			e.getDeployer().enableProcessing();
			if (callback != null) {
				callback();
			}
		}
	}

}