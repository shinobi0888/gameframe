package event {
	import dialogue.Dialogue;
	import event.command.CmdAvaDisableCtrl;
	import event.command.CmdAvaEnableCtrl;
	import event.command.CmdDialogChoice;
	import event.command.CmdDialogEnd;
	import event.command.CmdDialogLfc;
	import event.command.CmdDialogLfi;
	import event.command.CmdDialogLfo;
	import event.command.CmdDialogRfc;
	import event.command.CmdDialogRfi;
	import event.command.CmdDialogRfo;
	import event.command.CmdDialogStart;
	import event.command.CmdDialogText;
	import event.command.CmdNpcAnimSync;
	import event.command.CmdNpcDisableProcess;
	import event.command.CmdNpcEnableProcess;
	import event.command.CmdNpcTurnToAvatar;
	import event.command.CmdNpcUpdate;
	import event.command.CmdVarSet;
	import map.entities.NPC;
	import map.MapEntity;
	import mx.utils.StringUtil;
	import resource.SaveMem;
	
	/**
	 * Represents a command in an NPC script.
	 * @author shinobi0888
	 */
	public class Command {
		protected static var COMMAND_MAP:Object = new Object();
		
		protected var params:Array = new Array();
		
		public static function init(callback:Function = null):void {
			var ALL_COMMANDS:Array = [CmdAvaDisableCtrl, CmdAvaEnableCtrl, CmdDialogChoice, CmdDialogEnd, CmdDialogLfc, CmdDialogLfi, CmdDialogLfo, CmdDialogRfc, CmdDialogRfi, CmdDialogRfo, CmdDialogStart, CmdDialogText, CmdNpcAnimSync, CmdNpcDisableProcess, CmdNpcEnableProcess, CmdNpcTurnToAvatar, CmdNpcUpdate, CmdVarSet];
			for each (var commandClass:Class in ALL_COMMANDS) {
				COMMAND_MAP[commandClass.TAGNAME] = commandClass;
			}
			if (callback != null) {
				callback();
			}
		}
		
		public function Command() {
		}
		
		/**
		 * Takes a string representation of multiple commands and parses it
		 * into a single block command.
		 * @param	commands The string representation of all commands in an
		 * event.
		 * @return The BlockCommand representing the entire event.
		 */
		public static function parseAllCommands(commands:Array):BlockCommand {
			// TODO: handle comments, multiline, etc
			for (var i:int = 0; i < commands.length; i++) {
				commands[i] = StringUtil.trim(commands[i]);
			}
			var result:BlockCommand = new BlockCommand();
			while (commands.length > 0) {
				result.addCommand(parseCommand(commands));
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
			if (!COMMAND_MAP.hasOwnProperty(headCommand)) {
				trace("BAD COMMAND: " + headCommand);
				return null;
			}
			var result:Command = new (COMMAND_MAP[headCommand] as Class)();
			result.params = headString.match(COMMAND_MAP[headCommand].REGEX);
			if (result.params != null) {
				result.params.shift();
				result.cleanParams();
			}
			return result;
		}
		
		public function cleanParams():void {
		}
		
		public function execute(e:EventDispatcher, callback:Function = null):void {
		}
		
		/**
		 * Adds all dependencies of this command and all subcommands
		 * into the dependency set.
		 * @param	deps A set of dependencies (mapped to by key) that will
		 * be added to.
		 */
		public function addDependencies(deps:Object):void {
		}
		
		/**
		 * Resolves the text in a command by replacing variables, etc.
		 * @param	text The text to resolve.
		 * @return The resolved text, with variables swapped out.
		 */
		protected function resolveText(text:String):String {
			var beforeText:String = null;
			while (beforeText != text) {
				beforeText = text;
				for (var i:int = 0; i < text.length; i++) {
					if (text.charAt(i) == "$") {
						var varEnd:int = text.indexOf("$", i + 1);
						var varName:String = text.substr(i + 1, varEnd == -1 ? text.length :
							(varEnd - (i + 1)));
						if (SaveMem.existsVar(varName)) {
							var afterVar:String = text.substr(varEnd + 1);
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
	}

}