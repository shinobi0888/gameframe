package resource {
	
	/**
	 * Represents the state of the game to be saved into memory.
	 * @author shinobi0888
	 */
	public class SaveMem {
		private static var gameVarsStr:Object;
		private static var gameVarsInt:Object;
		private static var gameVarsBool:Object;
		
		public static function init(callback:Function = null):void {
			gameVarsStr = new Object();
			gameVarsInt = new Object();
			gameVarsBool = new Object();
			if (callback != null) {
				callback();
			}
		}
		
		/**
		 * Sets a game data variable. Strings should be contiguous strings with
		 * variable naming conventions and values should be strings, ints or
		 * boolean values.
		 * @param	name The name of the variable to set.
		 * @param	val The value of the variable being set.
		 * @return The updated value of the variable set.
		 */
		public static function setVar(name:String, val:Object):Object {
			if (val is String) {
				return gameVarsStr[name] = String(val).replace(/[\u000d\u000a\u0008]+/g,"");
			} else if (val is int) {
				return gameVarsInt[name] = val;
			} else if (val is Boolean) {
				return gameVarsBool[name] = val;
			}
			return null;
		}
		
		/**
		 * Gets the value of a variable.
		 * @param	name The name of the variable.
		 * @return The value of the variable if found, or null.
		 */
		public static function getVar(name:String):Object {
			return gameVarsStr.hasOwnProperty(name) ? gameVarsStr[name] : (gameVarsInt.hasOwnProperty(name) ?
				gameVarsInt[name] : gameVarsBool.hasOwnProperty(name) ? gameVarsBool[name] :
				null);
		}
		
		public static function existsVar(name:String):Boolean {
			return gameVarsStr.hasOwnProperty(name) || gameVarsInt.hasOwnProperty(name) ||
				gameVarsBool.hasOwnProperty(name);
		}
		
		private static function saveVars(saveLines:Array):void {
			var line:String = "";
			for (var key:String in gameVarsStr) {
				line += (key + String.fromCharCode(30) + gameVarsStr[key] + String.fromCharCode(31));
			}
			saveLines.push(line);
			line = "";
			for (key in gameVarsInt) {
				line += (key + String.fromCharCode(30) + gameVarsInt[key] + String.fromCharCode(31));
			}
			saveLines.push(line);
			line = "";
			for (key in gameVarsBool) {
				line += (key + String.fromCharCode(30) + gameVarsBool[key] + String.fromCharCode(31));
			}
			saveLines.push(line);
		}
		
		private static function loadVars(saveLines:Array):void {
			var line:String = saveLines.shift();
			for (var pair:String in line.split(String.fromCharCode(31))) {
				gameVarsStr[pair.split(String.fromCharCode(30))[0]] = pair.split(String.fromCharCode(30))[1];
			}
			line = saveLines.shift();
			for (pair in line.split(String.fromCharCode(31))) {
				gameVarsInt[pair.split(String.fromCharCode(30))[0]] = parseInt(pair.split(String.fromCharCode(30))[1]);
			}
			line = saveLines.shift();
			for (pair in line.split(String.fromCharCode(31))) {
				gameVarsBool[pair.split(String.fromCharCode(30))[0]] = pair.split(String.fromCharCode(30))[1] ==
					"true" ? true : false;
			}
		}
		
		/**
		 * Writes the game save memory as a string.
		 * @return The string representation of the game save.
		 */
		public static function toSaveString():String {
			// TODO: store all variable fields in text format
			var saveLines:Array = new Array();
			
			saveVars(saveLines);
			
			return saveLines.join("\n");
		}
		
		/**
		 * Loads the game save memory from a string.
		 * @param	saveString The string representation of the game save.
		 */
		public static function loadSaveString(saveString:String):void {
			var saveLines:Array = saveString.split("\n");
			
			loadVars(saveLines);
		}
	}
}