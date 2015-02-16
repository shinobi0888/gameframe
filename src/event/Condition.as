package event {
	import mx.utils.StringUtil;
	import resource.SaveMem;
	
	/**
	 * Represents an expression used in evaluating conditional commands.
	 * @author shinobi0888
	 */
	public class Condition {
		private static const EQ:int = 1001;
		private static const NEQ:int = 1002;
		
		private var commandNumber:int;
		private var params:Array = new Array();
		
		public function Condition() {
		
		}
		
		/**
		 * Parses a string representation of the condition into a Condition
		 * object.
		 * @param	cond The string representation of the condition.
		 * @return The parsed condition if possible or null.
		 */
		public static function parseCondition(cond:String):Condition {
			// TODO: check for compound conditions or operators
			if (cond.indexOf("==") != -1) {
				var eqIndex:int = cond.indexOf("==");
				var result:Condition = new Condition();
				result.params[0] = StringUtil.trim(cond.substr(0, eqIndex));
				result.params[1] = StringUtil.trim(cond.substr(eqIndex + 2));
				result.commandNumber = EQ;
				return result;
			} else if (cond.indexOf("!=") != -1) {
				eqIndex = cond.indexOf("!=");
				result = new Condition();
				result.params[0] = StringUtil.trim(cond.substr(0, eqIndex));
				result.params[1] = StringUtil.trim(cond.substr(eqIndex + 2));
				result.commandNumber = NEQ;
				return result;
			}
			return null;
		}
		
		/**
		 * Evaluates the condition for truth.
		 * @param	e The event dispatcher (currently unused).
		 * @return True if the condition evaluates to true.
		 */
		public function evaluate(e:EventDispatcher):Boolean {
			switch (commandNumber) {
				case EQ:
					return resolveText(params[0]) == resolveText(params[1]);
				default:
					return false;
			}
		}
		
		/**
		 * Resolves the text in a command by replacing variables, etc.
		 * @param	text The text to resolve.
		 * @return The resolved text, with variables swapped out.
		 */
		private function resolveText(text:String):String {
			for (var i:int = 0; i < text.length; i++) {
				if (text.charAt(i) == "$") {
					var varEnd:int = text.indexOf("$", i + 1);
					var varName:String = text.substr(i + 1, varEnd == -1 ? text.length : (varEnd -
						(i + 1)));
					if (SaveMem.existsVar(varName)) {
						var afterVar:String = text.substr(varEnd + 1);
						text = text.substr(0, i) + resolveText(SaveMem.getVar(varName) + "");
						varEnd = text.length;
						text += afterVar;
					}
					i = varEnd;
				}
			}
			return text;
		}
	}

}