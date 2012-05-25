package playtiLib.controller.commands.social.fb
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.proxies.config.DisplaySettingsProxy;
	import playtiLib.model.proxies.social.fb.SendSocialGiftsReqProxy;
	import playtiLib.model.proxies.social.fb.SendSocialInviteReqProxy;
	import playtiLib.model.vo.social.SocialPostVO;
	import playtiLib.model.vo.social.fb.SocialFriendsInfoListVo;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.view.mediators.social.fb.SelectFriendsSendGiftMediator;
	
	public class FBSendGiftRequestCommand extends SimpleCommand	{
		
		public static const NO_FRIENDS:String 			= '0';
		
		private var post_data:SocialPostVO;
		
		override public function execute( notification:INotification ):void {
			
			post_data = notification.getBody() as SocialPostVO;
			
			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP_WITH_LOADING, true );
			
			if ( post_data.user_sn_id == NO_FRIENDS ) {
				var sendSocialGiftsReqProxy:SendSocialGiftsReqProxy = new SendSocialGiftsReqProxy();
				sendSocialGiftsReqProxy.current_post_vo = post_data;
				
				facade.registerProxy( sendSocialGiftsReqProxy );
			}
			else{
				sendNotification( GeneralAppNotifications.CREATE_COUPON, post_data );
			}
			
			sendNotification( GeneralAppNotifications.SHOW_GIFTS_TAB_COMMAND );
		}
	}
}