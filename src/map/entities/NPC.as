package map.entities {
	import event.EventDispatcher;
	import map.Map;
	import map.WalkingMapEntity;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class NPC extends WalkingMapEntity {
		protected var stateIndex:int;
		protected var states:Array;
		
		public function NPC(containingMap:Map, npcName:String, gridX:int, gridY:int,
			layer:int) {
			super(containingMap, null, gridX, gridY, layer, null);
			// TODO: find the proper stateIndex to set
		}
		
		public function canActivateEnter():Boolean {
			return (states[stateIndex] as NPCState).activationMode == NPCState.ACTIVE_MAP_ENTER &&
				(states[stateIndex] as NPCState).cond.evaluate(EventDispatcher.dispatcher(this));
		}
		
		public function canActivateStep():Boolean {
			return (states[stateIndex] as NPCState).activationMode == NPCState.ACTIVE_STEP &&
				(states[stateIndex] as NPCState).cond.evaluate(EventDispatcher.dispatcher(this));
		}
		
		public function canActivateInspect():Boolean {
			return (states[stateIndex] as NPCState).activationMode == NPCState.ACTIVE_INSPECT &&
				(states[stateIndex] as NPCState).cond.evaluate(EventDispatcher.dispatcher(this));
		}
		
		public function canActivateStepInspect():Boolean {
			return (states[stateIndex] as NPCState).activationMode == NPCState.ACTIVE_STEPINSPECT &&
				(states[stateIndex] as NPCState).cond.evaluate(EventDispatcher.dispatcher(this));
		}
		
		public function activateEnter(callback:Function = null):void {
			if ((states[stateIndex] as NPCState).activationMode == NPCState.ACTIVE_MAP_ENTER) {
				(states[stateIndex] as NPCState).cmd.execute(EventDispatcher.dispatcher(this),
					callback);
			} else if (callback != null) {
				callback();
			}
		}
		
		public function activateStep(callback:Function = null):void {
			if ((states[stateIndex] as NPCState).activationMode == NPCState.ACTIVE_STEP) {
				(states[stateIndex] as NPCState).cmd.execute(EventDispatcher.dispatcher(this),
					callback);
			} else if (callback != null) {
				callback();
			}
		}
		
		public function activateInspect(callback:Function = null):void {
			if ((states[stateIndex] as NPCState).activationMode == NPCState.ACTIVE_INSPECT) {
				(states[stateIndex] as NPCState).cmd.execute(EventDispatcher.dispatcher(this),
					callback);
			} else if (callback != null) {
				callback();
			}
		}
		
		public function activateStepInspect(callback:Function = null):void {
			if ((states[stateIndex] as NPCState).activationMode == NPCState.ACTIVE_STEPINSPECT) {
				(states[stateIndex] as NPCState).cmd.execute(EventDispatcher.dispatcher(this),
					callback);
			} else if (callback != null) {
				callback();
			}
		}
	}
}
import event.BlockCommand;
import event.Condition;
import flash.display.Sprite;

class NPCState {
	public static const ACTIVE_MAP_ENTER:int = 0;
	public static const ACTIVE_STEP:int = 1;
	public static const ACTIVE_INSPECT:int = 2;
	public static const ACTIVE_STEPINSPECT:int = 3;
	
	public var sprite:Sprite;
	public var cond:Condition;
	public var cmd:BlockCommand;
	public var activationMode:int;
}