package playtiLib.controller.commands.social.fb
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.proxies.social.fb.SendSocialInviteReqProxy;
	import playtiLib.model.vo.amf.social.user.SocialUserIdsVO;
	import playtiLib.model.vo.social.fb.SocialFriendsInfoListVo;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.view.mediators.social.fb.SelectFriendsToInviteMediator;
	
	public class InviteReqDataReadyCommand extends SimpleCommand	{
		
		public static const MAX_NUMBER_OF_FRIENDS:int 	= 1200;
				
		override public function execute( notification:INotification ):void {
			
			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP_WITH_LOADING, false );
			
			sendNotification( GeneralAppNotifications.CLOSE_POPUP );
			
			if( sendSocialInviteReqProxy.allFriends.length <= MAX_NUMBER_OF_FRIENDS ){
				openFlashPopup();
			}else{
				openFacebookPopup();
			}			
		}
		
		private function openFacebookPopup():void
		{
			ExternalInterface.call( 'FBInviteRequest', sendSocialInviteReqProxy.allFriendsToInviteIds );
		}
		
		private function openFlashPopup():void
		{
			var selectFriendsToInviteMediator:SelectFriendsToInviteMediator = new SelectFriendsToInviteMediator( GeneralDialogsConfig.POPUP_INVITE_FRIENDS );
			facade.registerMediator( selectFriendsToInviteMediator );
			selectFriendsToInviteMediator.fillFriendsList ();
			
		}
		
		private function get sendSocialInviteReqProxy():SendSocialInviteReqProxy {
			return facade.retrieveProxy( SendSocialInviteReqProxy.NAME ) as SendSocialInviteReqProxy;
		}
	}
}