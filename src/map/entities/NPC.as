package map.entities {
	import event.Command;
	import event.Condition;
	import event.EventDispatcher;
	import map.Map;
	import map.WalkingMapEntity;
	import resource.sprite.SpriteBase;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class NPC extends WalkingMapEntity {
		protected var stateIndex:int;
		protected var states:Array;
		
		public static function parseNPC(containingMap:Map, lines:Array):NPC {
			var result:NPC = new NPC(containingMap, lines[0], parseInt(lines[1].split(",")[0]),
				parseInt(lines[1].split(",")[1]), parseInt(lines[2]));
			var linePos:int;
			for (linePos = 3; lines[linePos] != "nullstate_start"; linePos++) {
			}
			linePos++;
			var newNPCState:NPCState = new NPCState();
			newNPCState.activationMode = -1;
			newNPCState.cmd = null;
			newNPCState.sprite = null;
			newNPCState.defaultSpriteAnimation = null;
			newNPCState.cond = Condition.parseCondition(lines[linePos]);
			result.states.push(newNPCState);
			linePos += 2;
			var cmdLines:Array = new Array();
			// Read all other states
			while (linePos < lines.length) {
				for (; lines[linePos] != "state_start"; linePos++) {
				}
				linePos++;
				newNPCState = new NPCState();
				newNPCState.activationMode = parseInt(lines[linePos]);
				if (lines[linePos + 1] != "null") {
					containingMap.addDependancy(lines[linePos + 1]);
					newNPCState.sprite = SpriteBase.load(lines[linePos + 1]).getSpriteInstance();
				} else {
					newNPCState.sprite = null;
				}
				newNPCState.defaultSpriteAnimation = lines[linePos + 2] == "null" ? null :
					lines[linePos + 2];
				newNPCState.cond = Condition.parseCondition(lines[linePos + 3]);
				cmdLines.length = 0;
				// Parse cmd lines
				for (linePos = linePos + 4; lines[linePos] != "state_end"; linePos++) {
					cmdLines.push(lines[linePos]);
				}
				newNPCState.cmd = Command.parseAllCommands(cmdLines);
				result.states.push(newNPCState);
				linePos++;
			}
			result.determineState();
			return result;
		}
		
		/**
		 * Constructor for an NPC. Should never be called externally. See parseNPC.
		 * Always call determineState after construction; parseNPC takes care of
		 * this.
		 * @param	containingMap
		 * @param	npcName
		 * @param	gridX
		 * @param	gridY
		 * @param	layer
		 */
		public function NPC(containingMap:Map, npcName:String, gridX:int, gridY:int,
			layer:int) {
			super(containingMap, null, gridX, gridY, layer, null);
			stateIndex = 0;
			states = new Array();
		}
		
		public function determineState():void {
			for (var i:int = 0; i < states.length; i++) {
				if ((states[i] as NPCState).cond.evaluate(EventDispatcher.dispatcher(this))) {
					stateIndex = i;
					break;
				}
			}
			sprite = states[i].sprite;
			if (sprite != null) {
				sprite.terminateAnimations(0);
				sprite.queueAnimation(states[i].defaultSpriteAnimation);
			}
		}
		
		public function canActivateEnter():Boolean {
			return stateIndex != 0 && (states[stateIndex] as NPCState).activationMode ==
				NPCState.ACTIVE_MAP_ENTER;
		}
		
		public function canActivateStep():Boolean {
			return stateIndex != 0 && (states[stateIndex] as NPCState).activationMode ==
				NPCState.ACTIVE_STEP;
		}
		
		public function canActivateInspect():Boolean {
			return stateIndex != 0 && (states[stateIndex] as NPCState).activationMode ==
				NPCState.ACTIVE_INSPECT;
		}
		
		public function canActivateStepInspect():Boolean {
			return stateIndex != 0 && (states[stateIndex] as NPCState).activationMode ==
				NPCState.ACTIVE_STEPINSPECT;
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
import resource.sprite.Sprite;

class NPCState {
	public static const ACTIVE_MAP_ENTER:int = 0;
	public static const ACTIVE_STEP:int = 1;
	public static const ACTIVE_INSPECT:int = 2;
	public static const ACTIVE_STEPINSPECT:int = 3;
	
	public var sprite:Sprite;
	public var defaultSpriteAnimation:String;
	// Switching condition for each state
	public var cond:Condition;
	public var cmd:BlockCommand;
	public var activationMode:int;
}