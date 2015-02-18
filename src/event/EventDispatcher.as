package event {
	import demos.AvatarTest;
	import map.entities.Avatar;
	import map.entities.NPC;
	
	/**
	 * Static class to dispatch events scripted in NPC scripts.
	 * @author shinobi0888
	 */
	public class EventDispatcher {
		private static const singleton:EventDispatcher = new EventDispatcher();
		
		private var deployer:NPC;
		private var avatar:Avatar;
		
		public static function dispatcher(deployer:NPC):EventDispatcher {
			singleton.deployer = deployer;
			return singleton;
		}
		
		public static function setAvatar(avatar:Avatar):void {
			singleton.avatar = avatar;
		}
		
		public function getDeployer():NPC {
			return deployer;
		}
		
		public function getAvatar():Avatar {
			return avatar;
		}
	}

}