package playtiLib.controller.commands.social.fb
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.proxies.data.FlashVarsProxy;

	public class FBAssetsLoadCompleteCommand extends SimpleCommand
	{
		
		override public function execute( notification:INotification ):void 
		{			
			SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS.request_params.user_id 
				= flashVarsProxy.flash_vars.viewer_id;
			
			sendNotification( GeneralAppNotifications.SOCIAL_INSTALL_APPROVED );
		}
		
		private function get flashVarsProxy():FlashVarsProxy 
		{
			return facade.retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy;
		}
	}
}