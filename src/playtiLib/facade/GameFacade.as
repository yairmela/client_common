package playtiLib.facade
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	import playtiLib.config.notifications.GeneralAppNotifications;

	public class GameFacade extends Facade{
		
		private static var instance:GameFacade;
		
		public function GameFacade(){
			
			super();
		}

		public static function getInstance():GameFacade	{
			
			if( !instance )
				instance = new GameFacade();
			return instance;
		}
	
		public function startup( command:Class, root:Sprite ):void 
		{
			registerCommand( GeneralAppNotifications.STARTUP, command );
			sendNotification( GeneralAppNotifications.STARTUP, root );
		}
	}
}