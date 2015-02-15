package map {
	import flash.geom.Point;
	import settings.DisplaySettings;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class CenteredWalkingMapEntity extends WalkingMapEntity {
		
		public function CenteredWalkingMapEntity(containingMap:Map, spriteName:String,
			gridX:int, gridY:int, layer:int, occupiedCells:Array = null) {
			super(containingMap, spriteName, gridX, gridY, layer, occupiedCells);
		}
		
		public function enableCenter():void {
			sprite.setAdvanceListener(this);
		}
		
		public function disableCenter():void {
			sprite.setAdvanceListener(null);
		}
		
		public function onAdvance(aniOffset:Point):void {
			MapCamera.requestFocus(Math.min(containingMap.getWidthInPixels() - 1 - DisplaySettings.DISP_WIDTH,
				Math.max(0, gridX * TileSet.TILE_WIDTH_PX + aniOffset.x + (sprite.getWidth() -
				DisplaySettings.DISP_WIDTH) / 2)), Math.min(containingMap.getHeightInPixels() -
				1 - DisplaySettings.DISP_HEIGHT, Math.max(0, gridY * TileSet.TILE_WIDTH_PX +
				aniOffset.y + (sprite.getHeight() - DisplaySettings.DISP_HEIGHT) / 2)), 1);
		}
	
	}

}