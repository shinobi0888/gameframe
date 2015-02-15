package resource.sprite {
	import flash.geom.Point;
	
	/**
	 * Represents a collection of animation stages.
	 * @author shinobi0888
	 */
	
	public class Animation {
		public var ticks:Array;
		public var totalStages:int;
		public var startPos:Point;
		
		public function Animation(startX:int, startY:int) {
			ticks = new Array();
			startPos = new Point(startX, startY);
			totalStages = 0;
			cachedStep = -1;
		}
		
		public function addTick(newTickData:String):void {
			var newTick:AnimationTick = new AnimationTick(newTickData, totalStages);
			ticks.push(newTick);
			totalStages += newTick.stages;
		}
		
		public function getTotalStages():int {
			return totalStages;
		}
		
		private var cachedPreviousTick:AnimationTick;
		private var cachedTick:AnimationTick;
		private var cachedStep:int;
		
		private function getTick(step:int):AnimationTick {
			if (cachedStep == step) {
				return cachedTick;
			}
			for (var i:int = 0; i < ticks.length; i++) {
				var tick:AnimationTick = ticks[i];
				if (step >= tick.stages) {
					step -= tick.stages;
				} else {
					cachedPreviousTick = i == 0 ? null : ticks[i - 1];
					cachedTick = tick;
					cachedStep = step;
					return tick;
				}
			}
			return null;
		}
		
		public function getParamIndex(step:int):int {
			var tick:AnimationTick = getTick(step);
			return tick == null ? -1 : tick.animationParamIndex;
		}
		
		public function getOffset(step:int, animationParams:Array, initialOffset:Point):Point {
			var tick:AnimationTick = getTick(step);
			var previousX:int = (cachedPreviousTick == null ? initialOffset.x : (cachedPreviousTick.animationParamIndex !=
				-1 ? animationParams[cachedPreviousTick.animationParamIndex * 2] : cachedPreviousTick.x));
			var previousY:int = (cachedPreviousTick == null ? initialOffset.y : (cachedPreviousTick.animationParamIndex !=
				-1 ? animationParams[cachedPreviousTick.animationParamIndex * 2 + 1] : cachedPreviousTick.y));
			var curX:int = tick.animationParamIndex == -1 ? tick.x : animationParams[2 *
				tick.animationParamIndex];
			var curY:int = tick.animationParamIndex == -1 ? tick.y : animationParams[2 *
				tick.animationParamIndex + 1];
			return tick == null ? new Point(0, 0) : new Point((curX - previousX) * (step -
				tick.stepsUpTo) / tick.stages + previousX, (curY - previousY) * (step - tick.stepsUpTo) /
				tick.stages + previousY);
		}
		
		public function getImageIndex(step:int):int {
			var tick:AnimationTick = getTick(step);
			return tick == null ? 0 : tick.imgIndex;
		}
	}

}
import mx.utils.StringUtil;

class AnimationTick {
	
	public var imgIndex:int;
	public var x:int;
	public var y:int;
	public var animationParamIndex:int;
	public var stages:int;
	public var stepsUpTo:int;
	
	public function AnimationTick(data:String, stepsUpTo:int) {
		this.stepsUpTo = stepsUpTo;
		var pieces:Array = data.split(",");
		imgIndex = parseInt(pieces[0]);
		pieces[1] = StringUtil.trim(pieces[1]);
		animationParamIndex = pieces[1].indexOf("p") == 0 ? parseInt(pieces[1].substr(1)) :
			-1;
		x = animationParamIndex == -1 ? parseInt(pieces[1]) : -1;
		y = animationParamIndex == -1 ? parseInt(pieces[2]) : -1;
		stages = parseInt(pieces[3]);
	}

}