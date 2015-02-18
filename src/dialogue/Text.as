package dialogue {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import resource.Image;
	
	/**
	 * Draws text for a multitude of UI components.
	 * @author shinobi0888
	 */
	public class Text {
		
		private static var fonts:Array;
		private static var fontSizes:Array;
		
		/**
		 * Initialization for Text resources including fonts.
		 * @param	callback A callback to be executed upon loading completion.
		 */
		public static function init(callback:Function = null):void {
			var fontResources:Array = ["../src/assets/text/txt_set1.png"];
			fontSizes = [16];
			fonts = new Array();
			Image.loadAll(fontResources, function():void {
					for each (var fontName:String in fontResources) {
						fonts.push(Image.getImage(fontName));
					}
					if (callback != null) {
						callback();
					}
				});
		}
		
		/**
		 * Draws text onto a given canvas with a provided font index.
		 * @param	font The index of the font to use.
		 * @param	text The string to actually draw.
		 * @param	canvas The BitmapData to draw onto.
		 * @param	x The x coordinate of the top left corner to draw to.
		 * @param	y The y coordinate of the top left corner to draw to.
		 * @param	width The width limit in pixels of the text; default value ignores width constraints.
		 * @param spacing The spacing between lines. Default is 0.
		 * @param alpha The alpha value to draw the text with. Default is 1.
		 * @param floatLast Whether or not to slightly raise the last character of the string. Default is false.
		 */
		public static function drawText(font:int, text:String, canvas:BitmapData, x:int,
			y:int, width:int = -1, spacing:int = 0, alpha:Number = 1, floatLast:Boolean = false):void {
			if (alpha == 0) {
				return;
			}
			var fontSize:int = fontSizes[font];
			var area:Rectangle = new Rectangle(0, 0, fontSize, fontSize);
			var widthLimit:int = width == -1 ? -1 : int(width / fontSize);
			for (var i:int = 0; i < text.length; i++) {
				var xPos:int = (widthLimit == -1 ? i * fontSize : int(i % widthLimit) * fontSize) +
					x;
				var yPos:int = (widthLimit == -1 ? 0 : int(i / widthLimit) * (fontSize +
					spacing)) + y + ((i == text.length - 1 && floatLast) ? -4 : 0);
				var index:int = text.charCodeAt(i) - 32;
				area.x = int(index % 15) * fontSize;
				area.y = int(index / 15) * fontSize;
				canvas.copyPixels(fonts[font], area, new Point(xPos, yPos), alpha == 1 ?
					null : new BitmapData(area.width, area.height, true, int(alpha * 256) *
					0x01000000), null, true);
			}
		}
		
		public static function cutText(font:int, text:String, width:int, height:int,
			spacing:int):int {
			var total:int = int(width / fontSizes[font]) * int(height / (fontSizes[font] +
				spacing));
			var newLine:int = text.indexOf("\\n");
			if (text.length <= total) {
				return Math.min(newLine == -1 ? text.length : newLine, text.length);
			}
			while (!isBoundary(text, total)) {
				total--;
			}
			return Math.min(total, newLine == -1 ? total : newLine);
		}
		
		public static function linesAllowed(font:int, height:int, spacing:int):int {
			return int(height / (fontSizes[font] + spacing));
		}
		
		public static function charsAllowed(font:int, width:int):int {
			return int(width / fontSizes[font]);
		}
		
		public static function fontSize(font:int):int {
			return fontSizes[font];
		}
		
		private static function isBoundary(text:String, index:int):Boolean {
			return index == text.length || text.charAt(index) == " " || text.charAt(index -
				1) == "." || text.charAt(index - 1) == "\"" || text.charAt(index - 1) ==
				"!" || text.charAt(index - 1) == "?";
		}
	}

}