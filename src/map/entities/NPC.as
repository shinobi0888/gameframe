package map.entities {
	import event.Command;
	import event.Condition;
	import event.EventDispatcher;
	import flash.utils.getTimer;
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
		protected var name:String;
		
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
				linePos++;
				newNPCState.parseMovement(lines[linePos]);
				if (lines[linePos + 1] != "null") {
					var sb:SpriteBase = SpriteBase.load(lines[linePos + 1]);
					containingMap.addDependancy(lines[linePos + 1], sb);
					newNPCState.sprite = sb.getSpriteInstance();
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
			this.name = npcName;
			stateIndex = 0;
			states = new Array();
		}
		
		public function getName():String {
			return name;
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
			// Allow processing for moving NPCs
			if (states[i].movePattern != NPCState.MV_STILL) {
				needToProcess = true;
			} else {
				needToProcess = false;
			}
			// Check for nullstate
			if (stateIndex == 0) {
				enabled = false;
			} else {
				enabled = true;
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
		
		override public function disableProcessing():void {
			needToProcess = false;
		}
		
		override public function enableProcessing():void {
			needToProcess = true;
			super.processInner(getTimer());
		}
		
		override protected function processInner(time:int):void {
			if (stateIndex != 0 && (states[stateIndex] as NPCState).movePattern == NPCState.MV_TURN &&
				Math.random() < NPCState.MOVE_CHANCE) {
				var randomDir:int = (states[stateIndex] as NPCState).allowedDirections[Math.floor(Math.random() *
					(states[stateIndex] as NPCState).allowedDirections.length)];
				setWalk(randomDir, 0);
			} else if (stateIndex != 0 && (states[stateIndex] as NPCState).movePattern ==
				NPCState.MV_WALK && Math.random() < NPCState.MOVE_CHANCE) {
				var allowedWalkingDirections:Array = new Array();
				for (var possibleDir:int = 0; possibleDir < 4; possibleDir++) {
					var randomX:int = gridX + DIR_XCHANGE[possibleDir];
					var randomY:int = gridY + DIR_YCHANGE[possibleDir];
					for (var i:int = 0; i < (states[stateIndex] as NPCState).allowedTiles.length; i += 2) {
						if ((states[stateIndex] as NPCState).allowedTiles[i] == randomX && (states[stateIndex] as
							NPCState).allowedTiles[i + 1] == randomY) {
							allowedWalkingDirections.push(possibleDir);
							break;
						}
					}
				}
				randomDir = allowedWalkingDirections[Math.floor(Math.random() * allowedWalkingDirections.length)];
				setWalk(randomDir, 1);
			}
			super.processInner(time);
		}
	}
}
import event.BlockCommand;
import event.Condition;
import flash.geom.Point;
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
	
	// Passive movement patterns
	public var movePattern:int;
	public var allowedTiles:Array;
	public var allowedDirections:Array;
	
	public static const MV_STILL:int = 0;
	public static const MV_TURN:int = 1;
	public static const MV_WALK:int = 2;
	
	public static const MOVE_CHANCE:Number = 0.7;
	
	public function parseMovement(moveString:String):void {
		var pieces:Array = moveString.split(" ");
		if (pieces[0] == "still") {
			movePattern = MV_STILL;
		} else if (pieces[0] == "turn") {
			movePattern = MV_TURN;
			allowedDirections = new Array();
			for (var i:int = 1; i < pieces.length; i++) {
				allowedDirections.push(parseInt(pieces[i]));
			}
		} else if (pieces[0] == "walk") {
			movePattern = MV_WALK;
			allowedTiles = new Array();
			for (i = 1; i < pieces.length; i++) {
				var commaIndex:int = pieces[i].indexOf(",");
				allowedTiles.push(parseInt(pieces[i].substr(0, commaIndex)), parseInt(pieces[i].substr(commaIndex +
					1)));
			}
		}
	}
}