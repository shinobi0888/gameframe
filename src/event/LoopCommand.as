package event {
	/**
	 * Repeats a command until a conditional evaluates to false.
	 * @author shinobi0888
	 */
	public class LoopCommand extends Command{
		
		private var cond:Condition;
		private var body:Command;
		
		public function LoopCommand(cond:Condition, body:Command) {
			this.cond = cond;
			this.body = body;
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			executeCommand(e, callback);
		}
		
		private function executeCommand(e:EventDispatcher, ultimateCallback:Function):void {
			if (!cond.evaluate(e) && ultimateCallback != null) {
				ultimateCallback();
				return;
			}
			body.execute(e, executeCommand);
		}
		
		override public function addDependencies(deps:Object):void {
			body.addDependencies(deps);
		}
	}

}