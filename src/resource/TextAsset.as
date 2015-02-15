package resource {
	import flash.utils.ByteArray;
	/**
	 * Helper class to load text data.
	 * @author shinobi0888
	 */
	public class TextAsset {
		public static function load(path:String):String {
			var b:ByteArray = new (Embeds.pathToClass(path) as Class)() as ByteArray;
			return b.readUTFBytes(b.length);
		}
	}

}