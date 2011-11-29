package playtiLib.controller.commands.social.mm
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.lists.iter.ArrayIterator;
	import playtiLib.utils.social.mm.MailruCall;
	import playtiLib.utils.social.mm.MailruCallEvent;
	/**
	 * Makes a new ArrayIterator with the const variable and check for next one  
	 */	
	public class MMSettingsCheckCommand extends SimpleCommand {
		
		public static const required_params:Array = ['widget', 'notifications'];
		
		private var settings:ArrayIterator;
		
		override public function execute( notification:INotification ):void {
			
			settings = new ArrayIterator( required_params );
			checkNext();
		}
		/**
		 * Checks if setting hasNext. If it is true, it executes users has app permission and if not, it sends notification
		 * (SOCIAL_INSTALL_APPROVED) 
		 * 
		 */		
		private function checkNext():void{
			
			if ( settings.hasNext() ) {
				MailruCall.exec( 'mailru.common.users.hasAppPermission', callbackAppPermission, new Array( settings.next() ) );
			}else{
				sendNotification( GeneralAppNotifications.SOCIAL_INSTALL_APPROVED );
			}
		}
		/**
		 * Gets an object and checks if it has own property like the current that in setting and if the current setting that 
		 * in the object is not 1. If they are, it adds listener to MailreCall (PERMISSIONS_CHANGED) and executes the user require premission
		 * and if not, it executes the checkNext function.
		 * @param data
		 * 
		 */		
		private function callbackAppPermission( data:Object ):void {
			
			if ( data.hasOwnProperty( settings.current ) && data[settings.current] != 1 ){
				MailruCall.addEventListener( MailruCallEvent.PERMISSIONS_CHANGED,onSettingsChange );
				MailruCall.exec( 'mailru.common.users.requirePermission',null,settings.current );
			}else
				checkNext();
		}
		/**
		 * Gets an object and checks if it's data permissionType is equal to the setting.current and if the status of the data
		 * property that in the data object is equal to 'success' and if they are, it removes listeners from MailruCall (PERMISSIONS_CHANGED)
		 * and executes the   
		 * @param data checkNext function. If they aren't, it executes the user's has app premoisson by MailruCall. 
		 * 
		 */		
		private function onSettingsChange( data:Object ):void	{
			
			if ( data.data.permissionType == settings.current && data.data.status == "success" ){ 
				MailruCall.removeEventListener( MailruCallEvent.PERMISSIONS_CHANGED, onSettingsChange );
				checkNext();
			}else
				MailruCall.exec( 'mailru.common.users.hasAppPermission', callbackAppPermission, new Array( settings.current ) );
		}
	}
}