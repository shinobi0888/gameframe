package event.command {
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdNpcTurnToAvatar  extends Command{
		public static const TAGNAME:String = "npc_trn_ava";
		public static const REGEX:RegExp = /^npc_trn_ava$/ms;

		override public function cleanParams():void {
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			e.getDeployer().turnTowards(e.getAvatar().getGridX(), e.getAvatar().getGridY(),
				1, callback);
		}
	}

}