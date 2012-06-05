package playtiLib.view.mediators.social.fb
{
	import flash.events.Event;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.proxies.social.fb.SendSocialInviteReqProxy;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.components.social.fb.SelectFriendsToInviteVLogic;
	import playtiLib.view.components.social.fb.SelectFriendsVLogic;
	
	public class SelectFriendsToInviteMediator extends SelectFriendsMediator	{
		
		public static const NAME:String = 'InviteFriendsMediator';
		
		public function SelectFriendsToInviteMediator( mc_name:String ){
			
			super( mc_name, new SelectFriendsToInviteVLogic( mc_name ) );
			this.selectFriendsVLogic = popup_logic as SelectFriendsToInviteVLogic;
			sendNotification( GeneralAppNotifications.SHOW_INVITE_TAB_COMMAND );
		}
		
		protected override function onSendBtnClick(event:EventTrans):void{
			
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
		
		public override function fillFriendsList():void{
			var usersArray:Array = [].concat(sendSocialReqProxy.allFriendsToInviteInfo );
			selectFriendsVLogic.insertFriends( usersArray, SelectFriendsVLogic.ALL_FRIENDS_LIST );
		}
	}
}