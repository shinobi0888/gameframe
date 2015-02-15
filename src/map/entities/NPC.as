package map.entities {
	import map.Map;
	import map.WalkingMapEntity;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class NPC extends WalkingMapEntity {
		
		public function NPC(containingMap:Map, spriteName:String, gridX:int, gridY:int, layer:int, occupiedCells:Array=null) {
			super(containingMap, spriteName, gridX, gridY, layer, occupiedCells);
		}
	}
}