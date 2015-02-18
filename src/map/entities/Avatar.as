package map.entities {
	import flash.automation.StageCapture;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import map.CenteredWalkingMapEntity;
	import map.Map;
	import map.MapEntity;
	import settings.ControlSettings;
	
	/**
	 * Represents the controllable character in the game. Should only have 1.
	 * @author shinobi0888
	 */
	public class Avatar extends CenteredWalkingMapEntity {
		private var keyControlEnabled:Boolean;
		private var enableControlsOnNextTick:Boolean;
		private var walking:Boolean;
		
		public function Avatar(containingMap:Map, gridX:int, gridY:int) {
			super(containingMap, "link", gridX, gridY, Map.L_CHAR, null);
		}
		
		public function doInspect():void {
			// Check other layer stepInspect
			var possibleInteraction:MapEntity;
			for (var i:int = 0; i < Map.L_AIR; i++) {
				possibleInteraction = containingMap.findEntity(gridX, gridY, i);
				if (possibleInteraction != null && possibleInteraction != this && possibleInteraction is
					NPC && (possibleInteraction as NPC).canActivateStepInspect()) {
					(possibleInteraction as NPC).activateStepInspect();
					return;
				}
			}
			// Check self layer for inspect
			possibleInteraction = containingMap.findEntity(gridX + DIR_XCHANGE[dir], gridY +
				DIR_YCHANGE[dir], layer);
			if (possibleInteraction != null && possibleInteraction != this && possibleInteraction is
				NPC && (possibleInteraction as NPC).canActivateInspect()) {
				(possibleInteraction as NPC).activateInspect();
				return;
			}
			// Check all other layers
			for (i = 0; i < Map.L_AIR; i++) {
				if (i == layer) {
					continue;
				}
				possibleInteraction = containingMap.findEntity(gridX + DIR_XCHANGE[dir],
					gridY + DIR_YCHANGE[dir], i);
				if (possibleInteraction != null && possibleInteraction != this && possibleInteraction is
					NPC && (possibleInteraction as NPC).canActivateInspect()) {
					(possibleInteraction as NPC).activateInspect();
					return;
				}
			}
		}
		
		public function doStep():void {
			// Check other layer stepInspect
			var possibleInteraction:MapEntity;
			for (var i:int = 0; i < Map.L_AIR; i++) {
				if (i == layer) {
					continue;
				}
				possibleInteraction = containingMap.findEntity(gridX, gridY, i);
				if (possibleInteraction != null && possibleInteraction != this && possibleInteraction is
					NPC && (possibleInteraction as NPC).canActivateStep()) {
					(possibleInteraction as NPC).activateStep();
					return;
				}
			}
		}
		
		override protected function processInner(time:int):void {
			if (enableControlsOnNextTick) {
				enableControlsOnNextTick = false;
				keyControlEnabled = true;
				disableProcessing();
				needToProcess = false;
			}
		}
		
		// Key registration
		public function registerKeys(stage:Stage):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function enableKeys():void {
			enableControlsOnNextTick = true;
			enableProcessing();
			needToProcess = true;
		}
		
		public function disableKeys():void {
			keyControlEnabled = false;
		}
		
		private var keyHandleState:int;
		private static const KH_NOBATTLE:int = 0;
		
		private function onKeyDown(e:KeyboardEvent):void {
			if (keyControlEnabled) {
				switch (keyHandleState) {
					case KH_NOBATTLE:
						handleNoBattleKeyDown(e);
						break;
					default:
						return;
				}
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if (keyControlEnabled) {
				switch (keyHandleState) {
					case KH_NOBATTLE:
						handleNoBattleKeyUp(e);
						break;
					default:
						return;
				}
			}
		}
		
		// Walking controls key handling
		private function handleNoBattleKeyDown(e:KeyboardEvent):void {
			if (e.keyCode >= ControlSettings.LEFT && e.keyCode <= ControlSettings.DOWN) {
				if (walking && e.keyCode - ControlSettings.LEFT != dir) {
					stopWalk(function():void {
							if (e.keyCode >= ControlSettings.LEFT && e.keyCode <= ControlSettings.DOWN) {
								walking = true;
								startWalk(e.keyCode - ControlSettings.LEFT, function():void {
										walking = false;
									});
							}
						});
				} else if (!walking) {
					if (e.keyCode >= ControlSettings.LEFT && e.keyCode <= ControlSettings.DOWN) {
						walking = true;
						startWalk(e.keyCode - ControlSettings.LEFT, function():void {
								walking = false;
							});
					}
				}
			}
		}
		
		private function handleNoBattleKeyUp(e:KeyboardEvent):void {
			if (walking && e.keyCode >= ControlSettings.LEFT && e.keyCode <= ControlSettings.DOWN &&
				dir == e.keyCode - ControlSettings.LEFT) {
				stopWalk(function():void {
						walking = false;
					});
			} else if (!walking && e.keyCode == ControlSettings.BUTTON1) {
				doInspect();
			}
		}
	
	}

}

