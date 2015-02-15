package event {
	
	/**
	 * Represents a block of commands to be executed sequentially.
	 * @author shinobi0888
	 */
	public class BlockCommand extends Command {
		private var commands:Array;
		
		public function BlockCommand() {
			commands = new Array();
		}
		
		public function addCommand(c:Command):void {
			commands.push(c);
		}
		
		override public function execute(e:EventDispatcher, callback:Function = null):void {
			createCallback(e, 0, callback)();
		}
		
		private function createCallback(e:EventDispatcher, index:int, ultimateCallback:Function):Function {
			return function():void {
				if (index >= commands.length) {
					if (ultimateCallback != null)
						ultimateCallback();
					return;
				}
				commands[index].execute(e, createCallback(e, index + 1, ultimateCallback));
			};
		}
		
		override public function addDependencies(deps:Object):void {
			for each (var command:Command in commands) {
				command.addDependencies(deps);
			}
		}
		
		public function listDependencies():Array {
			var deps:Object = new Object();
			addDependencies(deps);
			var result:Array = new Array();
			for (var key:String in deps) {
				result.push(key);
			}
			return result;
		}
	}

}