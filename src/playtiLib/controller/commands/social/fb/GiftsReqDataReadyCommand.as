package playtiLib.controller.commands.social.fb
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.proxies.social.fb.SendSocialGiftsReqProxy;
	import playtiLib.view.mediators.social.fb.SelectFriendsSendGiftMediator;
	
	public class GiftsReqDataReadyCommand extends SimpleCommand	{
		
		public static const MAX_NUMBER_OF_FRIENDS:int 	= 1200;
				
		override public function execute( notification:INotification ):void {
			
			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP_WITH_LOADING, false );
			
			sendNotification( GeneralAppNotifications.CLOSE_POPUP );
			
			if( sendSocialGiftsReqProxy.allFriends.length <= MAX_NUMBER_OF_FRIENDS ){
				openFlashPopup();
			}else{
				openFacebookPopup();
			}
			
			sendNotification( GeneralAppNotifications.FULLSCREEN_MODE, false );
		}
		
		private function openFacebookPopup():void
		{
			sendNotification( GeneralAppNotifications.CREATE_COUPON, sendSocialGiftsReqProxy.current_post_vo );
		}
		
		private function openFlashPopup():void
		{
			var selectFriendsToInviteMediator:SelectFriendsSendGiftMediator = new SelectFriendsSendGiftMediator( GeneralDialogsConfig.POPUP_SEND_GIFTS );
			facade.registerMediator( selectFriendsToInviteMediator );
			selectFriendsToInviteMediator.fillFriendsList ();			
		}
			
		private function get sendSocialGiftsReqProxy():SendSocialGiftsReqProxy {
			return facade.retrieveProxy( SendSocialGiftsReqProxy.NAME ) as SendSocialGiftsReqProxy;
		}
	}
}