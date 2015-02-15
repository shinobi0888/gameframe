package event {
	
	/**
	 * Holds command constants related to event commands.
	 * @author shinobi0888
	 */
	public class CommandConst {
		
		public static const CMD_REGEXES:Object = new Object();
		public static const CMD_INDEXES:Object = new Object();
		
		public static const DLG_START:int = 1001;
		public static const DLG_END:int = 1002;
		public static const DLG_TEXT:int = 1003;
		
		public static function init(callback:Function = null):void {
			CMD_REGEXES["dlg_start"] = /^dlg_start (.*) (.*)$/ms;
			CMD_INDEXES["dlg_start"] = DLG_START;
			CMD_REGEXES["dlg_end"] = /^dlg_end$/ms;
			CMD_INDEXES["dlg_end"] = DLG_END;
			CMD_REGEXES["dlg_text"] = /^dlg_text (.*)$/ms;
			CMD_INDEXES["dlg_text"] = DLG_TEXT;
			
			if (callback != null) {
				callback();
			}
		}
		
		public static function cleanParams(cmd:int, params:Array):void {
			switch (cmd) {
				case DLG_START:
					if (params[0] == "null") {
						params[0] = null;
					} else {
						params[0] = "../src/assets/portraits/" + params[0] + ".png";
					}
					if (params[1] == "null") {
						params[1] = null;
					} else {
						params[1] = "../src/assets/portraits/" + params[1] + ".png";
					}
					break;
				case DLG_END:
					break;
				case DLG_TEXT:
					break;
				default:
					return;
			}
		}
		
		public static function addDependencies(deps:Object, cmd:int, params:Array):void {
			switch (cmd) {
				case DLG_START:
					if (params[0] != null)
						deps[params[0]] = true;
					if (params[1] != null)
						deps[params[1]] = true;
					break;
				case DLG_END:
					break;
				case DLG_TEXT:
					break;
				default:
					return;
			}
		}
	
	}

}