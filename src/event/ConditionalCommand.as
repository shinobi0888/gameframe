package event {
	
	/**
	 * Represents a conditional command, executing one path if the provided
	 * condition evaluates to true and the other if false.
	 * @author shinobi0888
	 */
	public class ConditionalCommand extends Command {
		
		private var cond:Condition;
		private var cmdTrue:Command;
		private var cmdFalse:Command;
		
		public function ConditionalCommand(cond:Condition, cmdTrue:Command, cmdFalse:Command) {
			this.cond = cond;
			this.cmdTrue = cmdTrue;
			this.cmdFalse = cmdFalse;
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			if (cond.evaluate(e)) {
				cmdTrue.execute(e, callback);
			} else {
				cmdFalse.execute(e, callback);
			}
		}
		
		override public function addDependencies(deps:Object):void {
			cmdTrue.addDependencies(deps);
			cmdFalse.addDependencies(deps);
		}
	
	}

}