package playtiLib.controller.commands.server
{
	import flash.external.ExternalInterface;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	/**
	 * Handles the refresh of a i-frame. If there is an available external intrface,
	 * it waits for it's page reload call and it also handles erors by sending an appropriate notification. 
	 * @see flash.external.ExternalInterface
	 */	
	public class RefreshIframeCommand extends SimpleCommand{
		
		override public function execute( notification:INotification ):void {
			
			if ( ExternalInterface.available ){
				try {
				   ExternalInterface.call( "pageReload", 0 );
			    }
			    catch( error : Error ) {
					trace( error.toString() );
					sendNotification( GeneralAppNotifications.RETRY_SERVER_CONNECTION );
			    }
			}
		}
	}
}