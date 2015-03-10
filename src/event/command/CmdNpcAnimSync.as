package event.command {
	import event.Command;
	import event.EventDispatcher;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CmdNpcAnimSync  extends Command {
		public static const TAGNAME:String = "npc_anim_sync";
		public static const REGEX:RegExp = /^npc_anim_sync (.*)$/ms;
		
		override public function cleanParams():void {
		}
		
		override public function addDependencies(deps:Object):void {
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			e.getDeployer().queueAnimationImmediateSync(params[0], callback);
		}
	}

}