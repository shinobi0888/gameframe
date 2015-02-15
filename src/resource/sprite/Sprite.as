
package resource.sprite {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import resource.Image;
	
	/**
	 * ...
	 * @author shinobi0888
	 */
	public class Sprite {
		public static const TOTAL_ANI_PARAMS:int = 8;
		
		protected var animationParams:Array;
		protected var spriteBase:SpriteBase;
		protected var animationStageQueue:Array;
		protected var aniOffset:Point;
		protected var imageIndex:int;
		
		public function Sprite(spriteBase:SpriteBase) {
			this.spriteBase = spriteBase;
			animationParams = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			aniOffset = new Point(0, 0);
			imageIndex = 0;
			animationStageQueue = new Array();
		}
		
		/**
		 * Sets an animation parameter. Animation parameters are used for dynamic
		 * animations (for example an attack moving to a given unit) and supply
		 * waypoints.
		 * @param	paramNumber The number of the parameter supplied, up to
		 * TOTAL_ANI_PARAMS.
		 * @param	x The x value of the parameter.
		 * @param	y The y value of the parameter.
		 */
		public function setAnimationParams(paramNumber:int, x:int, y:int):void {
			animationParams[paramNumber * 2] = x;
			animationParams[paramNumber * 2 + 1] = y;
		}
		
		/**
		 * Terminates all queued animations including and proceeding from a provided
		 * start point.
		 * @param	startPos The index of the animation to start terminating from.
		 */
		public function terminateAnimations(startPos:int = 0):void {
			animationStageQueue.length = startPos;
		}
		
		/**
		 * Breaks a looping animation cycle if any.
		 */
		public function breakAnimationLoop():void {
			if (animationStageQueue.length > 0) {
				animationStageQueue[0].loop = false;
			}
		}
		
		/**
		 * Retrieves the name of the current animation, if any or
		 * an empty string if not animating.
		 * @return The name of the current animation.
		 */
		public function getCurrentAnimation():String {
			if (animationStageQueue.length > 0) {
				return animationStageQueue[0].stageName;
			}
			return "";
		}
		
		public function getCurrentAnimationStep():int {
			if (animationStageQueue.length > 0) {
				return animationStageQueue[0].step;
			}
			return -1;
		}
		
		public function getCurrentAnimationTotalSteps():int {
			if (animationStageQueue.length > 0) {
				return spriteBase.animations[animationStageQueue[0].stageName].totalStages;
			}
			return -1;
		}
		
		/**
		 * Queues a given animation by name to be animated.
		 * @param	name The name of the animation to run.
		 * @param	loop Whether or not to continue looping the animation after
		 * completion.
		 * @param	parameters An optional array of parameters to overwrite
		 * the animation params.
		 * @param	callback An optional callback function to call at the completion
		 * of the animation, once if non looping or at the end of each iteration
		 * if looping.
		 */
		public function queueAnimation(name:String, loop:Boolean = false, parameters:Array = null,
			callback:Function = null):void {
			if (parameters != null) {
				for (var i:int = 0; i < parameters.length; i++) {
					animationParams[i] = parameters[i];
				}
			}
			animationStageQueue.push(new AnimationStage(name, loop, callback));
			if (animationStageQueue.length == 1) {
				var currentStage:AnimationStage = animationStageQueue[0];
				var paramNum:int = spriteBase.animations[currentStage.stageName].getParamIndex(currentStage.step);
				aniOffset = paramNum != -1 ? new Point(animationParams[paramNum * 2].animationParams[paramNum *
					2 + 1]) : spriteBase.animations[currentStage.stageName].getOffset(currentStage.step,
					animationParams, new Point(0, 0));
				imageIndex = spriteBase.animations[currentStage.stageName].getImageIndex(currentStage.step);
			}
		}
		
		/**
		 * Draws the sprite to the given place on the canvas.
		 * @param	canvas The canvas to draw onto.
		 * @param	x The x coordinate to draw to, ignoring animation offsets.
		 * @param	y The y coordinate to draw to, ignoring animation offsets.
		 */
		public function draw(canvas:BitmapData, x:int, y:int):void {
			if (imageIndex != -1) {
				Image.drawTo(spriteBase.spriteSheet, canvas, x + aniOffset.x, y + aniOffset.y,
					int(imageIndex % spriteBase.sheetWidth) * spriteBase.width, int(imageIndex /
					spriteBase.sheetWidth) * spriteBase.height, spriteBase.width, spriteBase.height);
			}
		}
		
		/**
		 * Advances the animation of the current sprite.
		 */
		public function advance():void {
			if (animationStageQueue.length > 0) {
				var currentStage:AnimationStage = animationStageQueue[0];
				currentStage.step++;
				if (currentStage.step == spriteBase.animations[currentStage.stageName].getTotalStages()) {
					if (currentStage.loop) {
						if (currentStage.callback != null) {
							currentStage.callback();
						}
						currentStage.step = 0;
					} else {
						animationStageQueue.shift();
						if (currentStage.callback != null) {
							currentStage.callback();
						}
					}
				}
				if (animationStageQueue.length > 0) {
					currentStage = animationStageQueue[0];
					aniOffset = spriteBase.animations[currentStage.stageName].getOffset(currentStage.step,
						animationParams, currentStage.step == 0 ? spriteBase.animations[currentStage.stageName].startPos :
						aniOffset);
					if (advanceListener != null) {
						advanceListener.onAdvance(aniOffset);
					}
					imageIndex = spriteBase.animations[currentStage.stageName].getImageIndex(currentStage.step);
				}
			}
		}
		
		// Listening on sprite advancement
		private var advanceListener:Object;
		
		public function setAdvanceListener(advanceListener:Object):void {
			this.advanceListener = advanceListener;
		}
		
		// Functions related to spritebase
		public function getWidth():int {
			return spriteBase.width;
		}
		
		public function getHeight():int {
			return spriteBase.height;
		}
		
		public function getDrawCornerX():int {
			return spriteBase.drawCorner.x;
		}
		
		public function getDrawCornerY():int {
			return spriteBase.drawCorner.y;
		}
		
		/**
		 * Gets the offset caused by a stage in a moving animation.
		 * Not accounted for by the draw corner, which is the
		 * point at which to draw this stationary sprite.
		 * @return The animation offset.
		 */
		public function getAnimationOffset():Point {
			return aniOffset;
		}
	
	}
}

class AnimationStage {
	public var step:int;
	public var stageName:String;
	public var loop:Boolean;
	public var callback:Function;
	
	public function AnimationStage(stageName:String, loop:Boolean, callback:Function) {
		this.stageName = stageName;
		this.loop = loop;
		this.callback = callback;
		this.step = 0;
	}
}