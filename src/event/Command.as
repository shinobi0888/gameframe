package event {
	import dialogue.Dialogue;
	
	/**
	 * Represents a command in an NPC script.
	 * @author shinobi0888
	 */
	public class Command {
		private var commandNumber:int;
		private var params:Array = new Array();
		
		public function Command() {
		}
		
		public static function parseAllCommands(commands:String):BlockCommand {
			// TODO: handle comments, multiline, etc
			var lines:Array = commands.split("\n");
			var result:BlockCommand = new BlockCommand();
			while (lines.length > 0) {
				result.addCommand(parseCommand(lines));
			}
			return result;
		}
		
		/**
		 * Consumes lines from the commandStrings array and produces the next
		 * intelligible command.
		 * @param	commandStrings An array of strings representing commands.
		 * @return A parsed command, or null.
		 */
		public static function parseCommand(commandStrings:Array):Command {
			if (commandStrings.length == 0) {
				return null;
			}
			var headString:String = commandStrings.shift();
			var cond:Condition;
			var body:BlockCommand, body2:BlockCommand;
			// Check for structured commands
			if (headString.substr(0, 2) == "if") {
				cond = Condition.parseCondition(headString.substr(3));
				body = new BlockCommand();
				body2 = new BlockCommand();
				while (commandStrings[0] != "else") {
					body.addCommand(parseCommand(commandStrings));
				}
				while (commandStrings[0] != "endif") {
					body2.addCommand(parseCommand(commandStrings));
				}
				return new ConditionalCommand(cond, body, body2);
			} else if (headString.substr(0, 5) == "while") {
				cond = Condition.parseCondition(headString.substr(6));
				body = new BlockCommand();
				while (commandStrings[0] != "endwhile") {
					body.addCommand(parseCommand(commandStrings));
				}
				return new LoopCommand(cond, body);
			}
			// Check for single commands
			var space:int = headString.indexOf(" ");
			var headCommand:String = headString.substr(0, space == -1 ? headString.length :
				space);
			if (!CommandConst.CMD_INDEXES.hasOwnProperty(headCommand)) {
				trace("BAD COMMAND: " + headCommand);
				return null;
			}
			var result:Command = new Command();
			result.commandNumber = CommandConst.CMD_INDEXES[headCommand];
			result.params = headString.match(CommandConst.CMD_REGEXES[headCommand]);
			if (result.params != null) {
				result.params.shift();
				CommandConst.cleanParams(result.commandNumber, result.params);
			}
			return result;
		}
		
		public function execute(e:EventDispatcher, callback:Function = null):void {
			switch (commandNumber) {
				case CommandConst.DLG_START:
					Dialogue.start(resolveText(params[0]), resolveText(params[1]), callback);
					break;
				case CommandConst.DLG_END:
					Dialogue.end(callback);
					break;
				case CommandConst.DLG_TEXT:
					Dialogue.showText(resolveText(params[0]), callback);
					break;
				default:
					if (callback != null) {
						callback();
					}
			}
		}
		
		/**
		 * Resolves the text in a command by replacing variables, etc.
		 * @param	text The text to resolve.
		 * @return The resolved text, with variables swapped out.
		 */
		private function resolveText(text:String):String {
			// TODO: swap out variables
			return text;
		}
		
		public function addDependencies(deps:Object):void {
			CommandConst.addDependencies(deps, commandNumber, params);
		}
	}

}