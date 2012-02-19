package playtiLib.view.mediators.social.fb
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.model.proxies.social.fb.SendSocialGiftsReqProxy;
	import playtiLib.view.components.social.fb.SelectFriendsSendGiftVLogic;
	import playtiLib.view.components.social.fb.SelectFriendsVLogic;
	
	public class SelectFriendsSendGiftMediator extends SelectFriendsMediator
	{
		public static const NAME:String = 'SelectFriendsSendGiftMediator';
		
		public function SelectFriendsSendGiftMediator( mc_name:String ){
			
			super(mc_name, new SelectFriendsSendGiftVLogic( mc_name ) );
			this.selectFriendsVLogic = popup_logic as SelectFriendsSendGiftVLogic;
		}
		
		override public function listNotificationInterests():Array{
			return super.listNotificationInterests().concat([GeneralAppNotifications.SEND_SOCIAL_REQ_DATA_READY,
				GeneralAppNotifications.TODAY_RECEIVERS_READY,
				GeneralAppNotifications.UPDATE_AFTER_SOCIAL_REQ_SENT
			]);
		}
		
		override public function handleNotification( notification:INotification ):void{
			super.handleNotification( notification );
			var usersArray:Array;
			switch(notification.getName() ){
				case GeneralAppNotifications.SEND_SOCIAL_REQ_DATA_READY:
					usersArray = ( [].concat(sendSocialGiftsReqProxy.allFriends ) );
					selectFriendsVLogic.insertFriends( usersArray, SelectFriendsVLogic.ALL_FRIENDS_LIST );
					break;
				case GeneralAppNotifications.TODAY_RECEIVERS_READY:
					var todayReceivers:string = notification.getBody();
					sendSocialGiftsReqProxy.updateTodayReceivers( todayReceivers );
					break;
				case GeneralAppNotifications.UPDATE_AFTER_SOCIAL_REQ_SENT:
					usersArray = [].concat( ( notification.getBody() as String ).split(',') );
					selectFriendsVLogic.updateAfterUsersSent( usersArray );
					break;
			}
		}
		
		protected override function registerListeners():void{
			selectSendGiftFriendVLogic.appFriendsBtn.addEventListener( MouseEvent.CLICK, onAppFriendsTabClick );
			selectSendGiftFriendVLogic.allFriendsBtn.addEventListener( MouseEvent.CLICK, onAllFriendsTabClick ); 
			super.registerListeners();
		}
		
		private function onAppFriendsTabClick(event:MouseEvent):void{
			
			var appFriendArray:Array = [].concat( sendSocialGiftsReqProxy.appFriends );
			selectFriendsVLogic.insertFriends( appFriendArray, SelectFriendsVLogic.APP_FRIENDS_LIST );
		}
		
		private function onAllFriendsTabClick(event:MouseEvent):void{
			
			var allFriendArray:Array = [].concat( sendSocialGiftsReqProxy.allFriends );
			selectFriendsVLogic.insertFriends( allFriendArray, SelectFriendsVLogic.ALL_FRIENDS_LIST );
		}
		
		protected override function onSendBtnClick(event:MouseEvent):void{
			
			var post_vo:SocialPostVO = sendSocialGiftsReqProxy.current_post_vo;
			post_vo.user_sn_id = selectFriendsVLogic.nextSendFriendsArray.join(',');
//			sendNotification( GeneralAppNotifications.CREATE_COUPON, post_vo );
		}
		
		private function get selectSendGiftFriendVLogic():SelectFriendsSendGiftVLogic{
			return this.selectFriendsVLogic as SelectFriendsSendGiftVLogic;
		}
		
		private function get sendSocialGiftsReqProxy():SendSocialGiftsReqProxy{
			return facade.hasProxy( SendSocialGiftsReqProxy.NAME ) ? facade.retrieveProxy( SendSocialGiftsReqProxy.NAME ) as SendSocialGiftsReqProxy : null;
		}
		
		public override function closePopup(event:Event=null):void{
			sendNotification( GeneralAppNotifications.CLOSE_SEND_GIFTS_PROXY );
			super.closePopup( event );
		}	
	}
}