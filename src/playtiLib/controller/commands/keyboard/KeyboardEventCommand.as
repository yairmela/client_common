package playtiLib.controller.commands.keyboard
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.proxies.keyboard.KeyboardCashProxy;
	/**
	 * This command will implement all general keboard shourtcuts.
	 * Currently implements showing app version by pressing "v" + "?".
	 * @see playtiLib.model.proxies.keyboard.KeyboardCashProxy
	 */	
	public class KeyboardEventCommand extends SimpleCommand	{
		
		private static const KEY_NUM_1:int 				= 49;
		private static const KEY_NUM_2:int 				= 50;
		private static const V_KEY_CODE:int 			= 86;
		private static const QUSTION_MARK_KEY_CODE:int 	= 191;
		
		override public function execute( notification:INotification ):void {
			
			var key_code:int = notification.getBody() as int;
			var keyboard_proxy:KeyboardCashProxy = facade.retrieveProxy( KeyboardCashProxy.NAME ) as KeyboardCashProxy;
			//show version number
			if( keyboard_proxy.isKeyDown( V_KEY_CODE ) && key_code == QUSTION_MARK_KEY_CODE ) {
				sendNotification( GeneralAppNotifications.SHOW_VERSION_NUMBER );
			}
		}
	}
}