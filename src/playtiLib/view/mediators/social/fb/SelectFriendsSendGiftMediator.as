package playtiLib.view.mediators.social.fb
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.GeneralSocialActionPostConfig;
	import playtiLib.model.proxies.social.fb.SendSocialGiftsReqProxy;
	import playtiLib.model.vo.social.SocialPostVO;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.components.social.fb.SelectFriendsSendGiftVLogic;
	import playtiLib.view.components.social.fb.SelectFriendsVLogic;
	
	public class SelectFriendsSendGiftMediator extends SelectFriendsMediator
	{
		public static const NAME:String = 'SelectFriendsSendGiftMediator';
		
		public function SelectFriendsSendGiftMediator( mc_name:String ){
			
			super(mc_name, new SelectFriendsSendGiftVLogic( mc_name ) );
			this.selectFriendsVLogic = popup_logic as SelectFriendsSendGiftVLogic;
		}
		
		override public function onRegister():void{
			super.onRegister();
			var chosenGiftId:int = sendSocialGiftsReqProxy.current_post_vo.gift_type;
			(selectFriendsVLogic as SelectFriendsSendGiftVLogic).registerChosenGift(chosenGiftId)
		}
		
		override public function listNotificationInterests():Array{
			return super.listNotificationInterests().concat([GeneralAppNotifications.TODAY_RECEIVERS_READY]);
		}
		
		override public function handleNotification( notification:INotification ):void{
			super.handleNotification( notification );
			var usersArray:Array;
			switch(notification.getName() ){
				case GeneralAppNotifications.TODAY_RECEIVERS_READY:
					var todayReceivers:String = notification.getBody() as String;
					sendSocialGiftsReqProxy.updateTodayReceivers( todayReceivers );
					break;
			}
		}
		
		protected override function registerListeners():void{
			selectSendGiftFriendVLogic.addEventListener( SelectFriendsSendGiftVLogic.APP_FRIENDS_TAB_CLICK, onAppFriendsTabClick );
			selectSendGiftFriendVLogic.addEventListener( SelectFriendsSendGiftVLogic.ALL_FRIENDS_TAB_CLICK, onAllFriendsTabClick );
			super.registerListeners();
		}
		
		private function onAppFriendsTabClick(event:EventTrans):void{
			
			var appFriendArray:Array = [].concat( sendSocialGiftsReqProxy.appFriends );
			selectFriendsVLogic.insertFriends( appFriendArray, SelectFriendsVLogic.APP_FRIENDS_LIST );
		}
		
		private function onAllFriendsTabClick(event:EventTrans):void{
			
			var allFriendArray:Array = [].concat( sendSocialGiftsReqProxy.allFriends );
			selectFriendsVLogic.insertFriends( allFriendArray, SelectFriendsVLogic.ALL_FRIENDS_LIST );
		}
		
		protected override function onSendBtnClick(event:EventTrans):void{
			
			var post_vo:SocialPostVO = sendSocialGiftsReqProxy.current_post_vo;
			post_vo.user_sn_id = selectFriendsVLogic.nextSendFriendsArray.join(',');
			sendNotification( GeneralAppNotifications.CREATE_COUPON, post_vo );
		}
		
		private function get selectSendGiftFriendVLogic():SelectFriendsSendGiftVLogic{
			
			return this.selectFriendsVLogic as SelectFriendsSendGiftVLogic;
		}
		
		private function get sendSocialGiftsReqProxy():SendSocialGiftsReqProxy{
			
			return facade.hasProxy( SendSocialGiftsReqProxy.NAME ) ? facade.retrieveProxy( SendSocialGiftsReqProxy.NAME ) as SendSocialGiftsReqProxy : null;
		}
				
		protected override function onNoMoreFriendsToSend(event:Event):void	{
			
			sendNotification(GeneralAppNotifications.SOCIAL_ACTION, null, GeneralSocialActionPostConfig.GIFT_SENT);
			
			super.onNoMoreFriendsToSend(event);
		}
		
		public override function closePopup():void{
			
			sendNotification( GeneralAppNotifications.CLOSE_SEND_GIFTS_PROXY );
			
			super.closePopup();
		}	
		
		public override function fillFriendsList():void{
			
			var usersArray:Array = ( [].concat(sendSocialGiftsReqProxy.allFriends ) );
			selectFriendsVLogic.insertFriends( usersArray, SelectFriendsVLogic.ALL_FRIENDS_LIST );
		}
	}
}