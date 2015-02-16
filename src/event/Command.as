package event {
	import dialogue.Dialogue;
	import mx.utils.StringUtil;
	import resource.SaveMem;
	
	/**
	 * Represents a command in an NPC script.
	 * @author shinobi0888
	 */
	public class Command {
		private var commandNumber:int;
		private var params:Array = new Array();
		
		public function Command() {
		}
		
		/**
		 * Takes a string representation of multiple commands and parses it
		 * into a single block command.
		 * @param	commands The string representation of all commands in an
		 * event.
		 * @return The BlockCommand representing the entire event.
		 */
		public static function parseAllCommands(commands:String):BlockCommand {
			// TODO: handle comments, multiline, etc
			var lines:Array = commands.split("\n");
			for (var i:int = 0; i < lines.length; i++) {
				lines[i] = StringUtil.trim(lines[i]);
			}
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
				commandStrings.shift();
				while (commandStrings[0] != "endif") {
					body2.addCommand(parseCommand(commandStrings));
				}
				commandStrings.shift();
				return new ConditionalCommand(cond, body, body2);
			} else if (headString.substr(0, 5) == "while") {
				cond = Condition.parseCondition(headString.substr(6));
				body = new BlockCommand();
				while (commandStrings[0] != "endwhile") {
					body.addCommand(parseCommand(commandStrings));
				}
				commandStrings.shift();
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
				case CommandConst.DLG_LFI:
					Dialogue.leftFadeIn(resolveText(params[0]), callback);
					break;
				case CommandConst.DLG_RFI:
					Dialogue.rightFadeIn(resolveText(params[0]), callback);
					break;
				case CommandConst.DLG_LFC:
					Dialogue.leftFadeCross(resolveText(params[0]), callback);
					break;
				case CommandConst.DLG_RFC:
					Dialogue.rightFadeCross(resolveText(params[0]), callback);
					break;
				case CommandConst.DLG_LFO:
					Dialogue.leftFadeOut(callback);
					break;
				case CommandConst.DLG_RFO:
					Dialogue.rightFadeOut(callback);
					break;
				case CommandConst.DLG_CHOICE:
					Dialogue.showChoice(params[2], params[1], params[0] == null ? callback :
						function():void {
							SaveMem.setVar(params[0].replace(/\$/g,""), Dialogue.getChoice());
							if (callback != null) {
								callback();
							}
						});
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
			var beforeText:String = null;
			while (beforeText != text) {
				beforeText = text;
				for (var i:int = 0; i < text.length; i++) {
					if (text.charAt(i) == "$") {
						var varEnd:int = text.indexOf("$", i+1);
						var varName:String = text.substr(i + 1, varEnd == -1 ? text.length :
							(varEnd - (i + 1)));
						if (SaveMem.existsVar(varName)) {
							var afterVar:String = text.substr(varEnd+1);
							text = text.substr(0, i) + SaveMem.getVar(varName);
							varEnd = text.length;
							text += afterVar;
						}
						i = varEnd;
					}
				}
			}
			return text;
		}
		
		/**
		 * Adds all dependencies of this command and all subcommands
		 * into the dependency set.
		 * @param	deps A set of dependencies (mapped to by key) that will
		 * be added to.
		 */
		public function addDependencies(deps:Object):void {
			CommandConst.addDependencies(deps, commandNumber, params);
		}
	}

}