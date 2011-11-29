package playtiLib.facade
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	/**
	 * This class will be the generic Facade to our games.
	 * It enables you to pass in the startup command the specific startup command that was writen in the game for initiating game.
	 * @see org.puremvc.as3.patterns.facade.Facade
	 */	
	public class GameFacade extends Facade{
		
		private static var instance:GameFacade;
		
		public function GameFacade(){
			
			super();
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getInstance():GameFacade	{
			
			if( !instance )
				instance = new GameFacade();
			return instance;
		}
		/**
		 * When the game start. call for the startup function, pass the game's startup command and the root DisplayObject
		 * @param command the class that initite the game (it can be SimpleCommand or MacroCommand).
		 * @param root this will be the main class of the application.
		 * @see flash.display.Sprite
		 */		
		public function startup( command:Class, root:Sprite ):void {
			
			registerCommand( GeneralAppNotifications.STARTUP, command );
			sendNotification( GeneralAppNotifications.STARTUP, root );
		}
	}
}