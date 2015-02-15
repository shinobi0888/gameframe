package resource.sprite {
	import flash.geom.Point;
	import map.TileSet;
	import mx.utils.StringUtil;
	import resource.Image;
	import resource.TextAsset;
	
	/**
	 * Represents the base information including animation sequences and sprite
	 * graphics for generating instances of sprites.
	 * @author shinobi0888
	 */
	
	public class SpriteBase {
		private static var loadedBases:Object = new Object();
		
		public static function load(spriteName:String):SpriteBase {
			if (loadedBases.hasOwnProperty(spriteName)) {
				return loadedBases[spriteName];
			}
			var spriteImagePath:String = "../src/assets/sprites/sp_" + spriteName + ".png";
			Image.loadImage(spriteImagePath);
			loadedBases[spriteName] = new SpriteBase(spriteImagePath, TextAsset.load("../src/assets/sprites/sp_" +
				spriteName + ".txt"));
			return loadedBases[spriteName];
		}
		
		public static function unload(spriteName:String):void {
			if (loadedBases.hasOwnProperty(spriteName)) {
				Image.unloadImage(loadedBases[spriteName].spriteSheet);
				delete loadedBases[spriteName];
			}
		}
		
		public static function get(spriteName:String):SpriteBase {
			if (loadedBases.hasOwnProperty(spriteName)) {
				return loadedBases[spriteName];
			}
			return null;
		}
		
		public static function getInstance(spriteName:String):Sprite {
			if (loadedBases.hasOwnProperty(spriteName)) {
				return loadedBases[spriteName].getSpriteInstance();
			}
			return null;
		}
		
		// Start of instance based code
		public var spriteSheet:String;
		public var animations:Object;
		public var width:int, height:int, center:Point, drawCorner:Point;
		public var sheetWidth:int, sheetHeight:int;
		
		public function SpriteBase(spriteSheet:String, data:String) {
			this.spriteSheet = spriteSheet;
			animations = new Object();
			parseData(data);
			sheetWidth = int(Image.iWidth(spriteSheet) / width);
			sheetHeight = int(Image.iHeight(spriteSheet) / height);
		}
		
		public function getSpriteInstance():Sprite {
			return new Sprite(this);
		}
		
		private function parseData(data:String):void {
			var lines:Array = data.split("\n");
			width = parseInt(lines[0].split(",")[0]);
			height = parseInt(lines[0].split(",")[1]);
			center = new Point();
			drawCorner = new Point();
			setCenterX(parseInt(lines[1].split(",")[0]));
			setCenterY(parseInt(lines[1].split(",")[1]));
			for (var i:int = 2; i < lines.length; i++) {
				if (lines[i].length == 0) {
					continue;
				}
				var animTicks:Array = lines[i].split(";");
				var name:String = StringUtil.trim(animTicks[0].split(":")[0]);
				var startPosString:Array = animTicks[0].split(":")[1].split(",");
				var startX:int = parseInt(startPosString[0]);
				var startY:int = parseInt(startPosString[1]);
				var animation:Animation = new Animation(startX, startY);
				for (var j:int = 1; j < animTicks.length; j++) {
					if (animTicks[j].length > 0) {
						animation.addTick(animTicks[j]);
					}
				}
				animations[name] = animation;
			}
		}
		
		// Helpers to initialize the center of the sprite being drawn
		private function setCenterX(x:int):void {
			center.x = x;
			drawCorner.x = -center.x + TileSet.TILE_WIDTH_PX / 2;
		}
		
		private function setCenterY(y:int):void {
			center.y = y;
			drawCorner.y = -center.y + TileSet.TILE_WIDTH_PX / 2;
		}
	}

}

