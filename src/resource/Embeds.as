package resource {
	import flash.utils.getDefinitionByName;
	
	public class Embeds {
		[Embed(source="../assets/dialogue/dg_border_test.png")]
		public static var dialogue_dg_border_test_png:Class;
		[Embed(source="../assets/maps/mp_test.txt",mimeType="application/octet-stream")]
		public static var maps_mp_test_txt:Class;
		[Embed(source="../assets/portraits/bulbasaur.png")]
		public static var portraits_bulbasaur_png:Class;
		[Embed(source="../assets/sprites/sp_link.png")]
		public static var sprites_sp_link_png:Class;
		[Embed(source="../assets/sprites/sp_link.txt",mimeType="application/octet-stream")]
		public static var sprites_sp_link_txt:Class;
		[Embed(source="../assets/sprites/sp_test.png")]
		public static var sprites_sp_test_png:Class;
		[Embed(source="../assets/sprites/sp_test.txt",mimeType="application/octet-stream")]
		public static var sprites_sp_test_txt:Class;
		[Embed(source="../assets/tests/test.png")]
		public static var tests_test_png:Class;
		[Embed(source="../assets/tests/test2.png")]
		public static var tests_test2_png:Class;
		[Embed(source="../assets/text/txt_set1.png")]
		public static var text_txt_set1_png:Class;
		[Embed(source="../assets/tilesets/ts_test.png")]
		public static var tilesets_ts_test_png:Class;
		[Embed(source="../assets/tilesets/ts_test2.png")]
		public static var tilesets_ts_test2_png:Class;
		[Embed(source="../assets/tilesets/ts_test2_data.txt",mimeType="application/octet-stream")]
		public static var tilesets_ts_test2_data_txt:Class;
		[Embed(source="../assets/tilesets/ts_test_data.txt",mimeType="application/octet-stream")]
		public static var tilesets_ts_test_data_txt:Class;
		
		private static const RESOURCE_PATH:String = "../src/assets/";
		
		public static function pathToClass(path:String):Class {
			return Embeds[path.substr(RESOURCE_PATH.length).replace("/", "_").replace(".",
				"_")] as Class;
		}
	}
}