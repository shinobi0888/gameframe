package event {
	import map.entities.NPC;
	
	/**
	 * Static class to dispatch events scripted in NPC scripts.
	 * @author shinobi0888
	 */
	public class EventDispatcher {
		private static const singleton:EventDispatcher = new EventDispatcher();
		
		private var deployer:NPC;
		
		public static function dispatcher(deployer:NPC):EventDispatcher {
			singleton.deployer = deployer;
			return singleton;
		}
		
		public function getDeployer():NPC {
			return deployer;
		}
	}

}