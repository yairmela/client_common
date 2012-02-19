package playtiLib.controller.commands.social.fb
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
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
		
		public static const SEND_GIFTS_MC:String 		= 'pop_up_send_gifts';
		public static const MAX_NUMBER_OF_FRIENDS:int 	= 1600;
		
		private var post_data:SocialPostVO;
		private var today_receivers:String;
		
		override public function execute( notification:INotification ):void {
			
			post_data = notification.getBody() as SocialPostVO;
			today_receivers = notification.getType() as String;
			
			if ( post_data.user_sn_id && post_data.user_sn_id != '' && post_data.user_sn_id == '0' ){
				//check if there are more\less then 600 friends
				var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule([SocialCallsConfig.FRIENDS_IDS_AND_NAMES]);
				dataCapsule.addEventListener( Event.COMPLETE, onDataReady );
				dataCapsule.loadData();
			}
			else{
				sendNotification( GeneralAppNotifications.CREATE_COUPON, post_data );
			}
		}
		
		private function onDataReady(event:Event):void{
			
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			var allFriendsInfo:Array = (data_capsule.getDataHolderByIndex(0).data as SocialFriendsInfoListVo).list;
			if( allFriendsInfo.length <= MAX_NUMBER_OF_FRIENDS ){
				if( facade.hasProxy(SendSocialInviteReqProxy.NAME) ){
					( facade.retrieveProxy( SendSocialInviteReqProxy.NAME ) as SendSocialInviteReqProxy ).onRemove();
				}
				sendNotification( GeneralAppNotifications.CLOSE_POPUP );
				
				facade.registerMediator( new SelectFriendsSendGiftMediator( SEND_GIFTS_MC ) );
				facade.registerProxy( new SendSocialGiftsReqProxy() );
				(facade.retrieveProxy(SendSocialGiftsReqProxy.NAME) as SendSocialGiftsReqProxy).current_post_vo = post_data;
			}
			else{
				( facade.retrieveProxy( DisplaySettingsProxy.NAME ) as DisplaySettingsProxy ).fullscreen = false;
				ExternalInterface.call( 'sendGift', 
					post_data.title, 
					post_data.descreiption, 
					post_data.gift_type, 
					post_data.event_type, 
					today_receivers);
			}
			ExternalInterface.call('showFreeGiftstab'); 
		}
	}
}