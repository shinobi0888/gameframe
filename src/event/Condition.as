package event {
	/**
	 * Represents an expression used in evaluating conditional commands.
	 * @author shinobi0888
	 */
	public class Condition {
		// TODO: write NotCondition, AndCondition, and OrCondition classes
		public function Condition() {
			
		}
		
		public static function parseCondition(cond:String):Condition {
			// TODO: write this function
			return null;
		}
		
		public function evaluate(e:EventDispatcher):Boolean {
			// TODO: evaluate expression
			return true;
		}
		
	}

}