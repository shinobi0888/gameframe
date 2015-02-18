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
		public static const DLG_LFI:int = 1004;
		public static const DLG_RFI:int = 1005;
		public static const DLG_LFC:int = 1006;
		public static const DLG_RFC:int = 1007;
		public static const DLG_LFO:int = 1008;
		public static const DLG_RFO:int = 1009;
		public static const DLG_CHOICE:int = 1010;
		public static const AVA_DBL_CTRL:int = 1011;
		public static const AVA_EBL_CTRL:int = 1012;
		
		public static function init(callback:Function = null):void {
			CMD_REGEXES["dlg_start"] = /^dlg_start (.*) (.*)$/ms;
			CMD_INDEXES["dlg_start"] = DLG_START;
			CMD_REGEXES["dlg_end"] = /^dlg_end$/ms;
			CMD_INDEXES["dlg_end"] = DLG_END;
			CMD_REGEXES["dlg_text"] = /^dlg_text (.*)$/ms;
			CMD_INDEXES["dlg_text"] = DLG_TEXT;
			CMD_REGEXES["dlg_lfi"] = /^dlg_lfi (.*)$/ms;
			CMD_INDEXES["dlg_lfi"] = DLG_LFI;
			CMD_REGEXES["dlg_rfi"] = /^dlg_rfi (.*)$/ms;
			CMD_INDEXES["dlg_rfi"] = DLG_RFI;
			CMD_REGEXES["dlg_lfc"] = /^dlg_lfc (.*)$/ms;
			CMD_INDEXES["dlg_lfc"] = DLG_LFC;
			CMD_REGEXES["dlg_rfc"] = /^dlg_rfc (.*)$/ms;
			CMD_INDEXES["dlg_rfc"] = DLG_RFC;
			CMD_REGEXES["dlg_lfo"] = /^dlg_lfo$/ms;
			CMD_INDEXES["dlg_lfo"] = DLG_LFO;
			CMD_REGEXES["dlg_rfo"] = /^dlg_rfo$/ms;
			CMD_INDEXES["dlg_rfo"] = DLG_RFO;
			CMD_REGEXES["dlg_choice"] = /^dlg_choice (.*)~(.*)~(.*)$/ms;
			CMD_INDEXES["dlg_choice"] = DLG_CHOICE;
			CMD_REGEXES["ava_dbl_ctrl"] = /^ava_dbl_ctrl$/ms;
			CMD_INDEXES["ava_dbl_ctrl"] = AVA_DBL_CTRL;
			CMD_REGEXES["ava_ebl_ctrl"] = /^ava_ebl_ctrl$/ms;
			CMD_INDEXES["ava_ebl_ctrl"] = AVA_EBL_CTRL;
			
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
				case DLG_LFI:
					if (params[0] == "null") {
						params[0] = null;
					} else {
						params[0] = "../src/assets/portraits/" + params[0] + ".png";
					}
					break;
				case DLG_RFI:
					if (params[0] == "null") {
						params[0] = null;
					} else {
						params[0] = "../src/assets/portraits/" + params[0] + ".png";
					}
					break;
				case DLG_LFC:
					if (params[0] == "null") {
						params[0] = null;
					} else {
						params[0] = "../src/assets/portraits/" + params[0] + ".png";
					}
					break;
				case DLG_RFC:
					if (params[0] == "null") {
						params[0] = null;
					} else {
						params[0] = "../src/assets/portraits/" + params[0] + ".png";
					}
					break;
				case DLG_LFO:
					break;
				case DLG_RFO:
					break;
				case DLG_CHOICE:
					if (params[0] == "null") {
						params[0] = null;
					}
					params[1] = params[1].split(";");
					break;
				case AVA_DBL_CTRL:
				case AVA_EBL_CTRL:
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
				case DLG_LFI:
					if (params[0] != null)
						deps[params[0]] = true;
					break;
				case DLG_RFI:
					if (params[0] != null)
						deps[params[0]] = true;
					break;
				case DLG_LFC:
					if (params[0] != null)
						deps[params[0]] = true;
					break;
				case DLG_RFC:
					if (params[0] != null)
						deps[params[0]] = true;
					break;
				case DLG_LFO:
					break;
				case DLG_RFO:
					break;
				case DLG_CHOICE:
					break;
				case AVA_DBL_CTRL:
				case AVA_EBL_CTRL:
					break;
				default:
					return;
			}
		}
	
	}

}