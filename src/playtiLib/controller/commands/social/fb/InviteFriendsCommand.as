package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.proxies.social.fb.SendSocialInviteReqProxy;
	
	public class InviteFriendsCommand extends SimpleCommand	{
						
		override public function execute( notification:INotification ):void {
			
//			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP_WITH_LOADING, true );
			
			if (!facade.retrieveProxy(SendSocialInviteReqProxy.NAME)) {
				facade.registerProxy( new SendSocialInviteReqProxy() );
			}
			else {
				(facade.retrieveProxy(SendSocialInviteReqProxy.NAME) as SendSocialInviteReqProxy).reloadAll();
			}
			
			sendNotification( GeneralAppNotifications.SHOW_INVITE_TAB_COMMAND );
		}
	}
}