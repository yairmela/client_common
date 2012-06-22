package playtiLib.controller.commands.social.fb
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.proxies.social.fb.SendSocialGiftsReqProxy;
	import playtiLib.model.vo.social.SocialPostVO;
	
	public class FBSendGiftRequestCommand extends SimpleCommand	{
		
		public static const NO_FRIENDS:String 			= '0';
		
		private var post_data:SocialPostVO;
		
		override public function execute( notification:INotification ):void {
			
			post_data = notification.getBody() as SocialPostVO;
			
//			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP_WITH_LOADING, true );
			
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