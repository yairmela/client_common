package playtiLib.controller.commands.social.mm
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.config.social.mm.MMNotifications;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.utils.social.mm.MailruCall;
	
	public class MMGameInstallCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			//check the app was installed
			MailruCall.exec( 'mailru.app.users.requireInstallation', null, MMSettingsCheckCommand.required_params );
			MailruCall.exec( 'mailru.app.users.isAppUser',OnIsAppUser );
			//check settings
		}
		/**
		 * Gets a data object and if it has property isAppUser and has property isAppUser that = 1, it executes the getInfo
		 * by MailruCall and if not, it exrcutes the require installation by MailruCall  
		 * @param data
		 * 
		 */		
		private function OnIsAppUser( data:Object):void{
			
			if ( data.hasOwnProperty( 'isAppUser' ) && data.isAppUser == 1 ){
				MailruCall.exec( 'mailru.common.users.getInfo' , updateLoginStatus, 0 );
				sendNotification(GeneralAppNotifications.SETTINGS_CHECK);
			}else{
				MailruCall.exec( 'mailru.app.users.requireInstallation' );
			}
		}
		/**
		 * Gets some flash vars propertier and sets them in the FlashVarsProxy object and sends notification SOCIAL_INSTALL_APPROVED
		 * @param response
		 * 
		 */		
		private function updateLoginStatus( response:Object ):void {
			
			flashVarsProxy.flash_vars.viewer_id = response[0].uid;
		//	flashVarsProxy.flash_vars.parameters['viewer_id'] = response[0].uid;
			SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS.request_params.user_id = response[0].uid;
			sendNotification( GeneralAppNotifications.SOCIAL_INSTALL_APPROVED );
		}
		
		private function get flashVarsProxy():FlashVarsProxy	{
			
			return facade.retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy;
		}
	}
}