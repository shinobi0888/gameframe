package event.command {
	import event.Command;
	import event.EventDispatcher;
	import map.entities.NPC;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdNpcUpdate  extends Command {
		public static const TAGNAME:String = "npc_update";
		public static const REGEX:RegExp = /^npc_update (.*)$/ms;
		
		override public function cleanParams():void {
			if (params[0] == "null" || params[0] == "self") {
				params.length = 0;
			}
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			if (params == null || params.length == 0) {
				e.getDeployer().determineState();
			} else {
				var entity:NPC = e.getDeployer().getContainingMap().findNPC(params[0]);
				if (entity != null) {
					entity.determineState();
				}
			}
			if (callback != null) {
				callback();
			}
		}
	}

}