package playtiLib.view.mediators.social.fb
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.proxies.social.fb.SendSocialInviteReqProxy;
	import playtiLib.view.components.social.fb.SelectFriendsToInviteVLogic;
	import playtiLib.view.components.social.fb.SelectFriendsVLogic;
	
	public class SelectFriendsToInviteMediator extends SelectFriendsMediator	{
		
		public static const NAME:String = 'InviteFriendsMediator';
		
		public function SelectFriendsToInviteMediator( mc_name:String ){
			
			super( mc_name, new SelectFriendsToInviteVLogic( mc_name ) );
			this.selectFriendsVLogic = popup_logic as SelectFriendsToInviteVLogic;
		}
		
		override public function listNotificationInterests():Array{
			return super.listNotificationInterests().concat( [GeneralAppNotifications.SEND_SOCIAL_REQ_DATA_READY,
				GeneralAppNotifications.UPDATE_AFTER_SOCIAL_REQ_SENT ]);
		}
		
		override public function handleNotification( notification:INotification ):void{
			
			super.handleNotification( notification );
			var usersArray:Array;
			switch(notification.getName() ){
				case GeneralAppNotifications.UPDATE_AFTER_SOCIAL_REQ_SENT:
					usersArray = [].concat( notification.getBody() as Array );
					selectFriendsVLogic.updateAfterUsersSent( usersArray );
					break;
				case GeneralAppNotifications.SEND_SOCIAL_REQ_DATA_READY:
					usersArray = [].concat(sendSocialReqProxy.allFriendsToInviteInfo );
					selectFriendsVLogic.insertFriends( usersArray, SelectFriendsVLogic.ALL_FRIENDS_LIST );
					break;
			}
		}
		
		protected override function onSendBtnClick(event:MouseEvent):void{
			
			var selectedFriendsIds:String = selectFriendsVLogic.nextSendFriendsArray.join(',');
			sendNotification( GeneralAppNotifications.OPEN_SOCIAL_INVITE_FRIENDS_DIALOG, selectedFriendsIds );
		}
		
		public override function closePopup(event:Event=null):void{
			sendNotification( GeneralAppNotifications.CLOSE_INVITE_PROXY );
			super.closePopup( event );
		}
		
		private function get sendSocialReqProxy():SendSocialInviteReqProxy{
			return facade.retrieveProxy( SendSocialInviteReqProxy.NAME ) as SendSocialInviteReqProxy;
		}
	}
}