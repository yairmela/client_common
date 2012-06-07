package playtiLib.view.mediators.popups
{
	import com.google.analytics.v4.Tracker;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.view.components.list.ListItemSimple;
	import playtiLib.view.components.popups.ChooseSnUserViewLogic;
	/**
	 * @see PopupMediator
	 */
	public class ChooseSnUserPopupMediator extends PopupMediator {
		
		public static const NAME:String = 'ChooseUserPopupMediator';
		private var choose_user_vlogic:ChooseSnUserViewLogic;
		private var additional_data:Object;
		
		public function ChooseSnUserPopupMediator( default_friend_sn_uid:String, additional_data:Object )	{
			
			super( NAME, new ChooseSnUserViewLogic( default_friend_sn_uid ) );
			choose_user_vlogic 		= viewComponent as ChooseSnUserViewLogic;
			this.additional_data 	= additional_data;
			registerListeners();
		}
		/**
		 * Returns an array with the notification the mediator is listening to:
		 * CHOOSE_SN_USER_DATA_READY. 
		 * @return 
		 * 
		 */		
		override public function listNotificationInterests():Array {
			
			return [GeneralAppNotifications.CHOOSE_SN_USER_DATA_READY];
		}
		/**
		 * Handles the notification the mediator is listening for:
		 * CHOOSE_SN_USER_DATA_READY.
		 * @param notification
		 * 
		 */		
		override public function handleNotification( notification:INotification ):void {
			
			switch( notification.getName() ) {
				case GeneralAppNotifications.CHOOSE_SN_USER_DATA_READY:
					choose_user_vlogic.insertFriends( notification.getBody() as Array );
					choose_user_vlogic.preloader_mc.visible = false;
					break;
			}
		}
		/**
		 * Adds mouse event ( CLICK ) listeners to the send and invite friends buttons. 
		 * 
		 */		
		private function registerListeners():void {
			
			choose_user_vlogic.invite_friends_btn.addEventListener( MouseEvent.CLICK, inviteFriendsHandler );
			choose_user_vlogic.send_btn.addEventListener( MouseEvent.CLICK, sendHandler );
		}
		//TODO: this function is not is used.
		private function markSelectedAsSent():void {
			
			var selected_friend:ListItemSimple = choose_user_vlogic.friends_list.list.GetListWindow().currentItem;
			selected_friend.content['mark_as_sent'].visible = true;
		}
		/**
		 * Handles the mouse event CLICK on the 'send' button.
		 * It sends notification :  CHOOSE_SN_USER_COMPLETE and closes the popup.
		 * @param event
		 * 
		 */		
		private function sendHandler( event:Event ):void {
			
			var selected_friend:ListItemSimple = choose_user_vlogic.friends_list.list.GetListWindow().currentItem;
			sendNotification( GeneralAppNotifications.CHOOSE_SN_USER_COMPLETE, {additional_data:additional_data, user_sn_id:selected_friend.data.sn_id} );
			
			sendNotification( GeneralAppNotifications.SHOW_GAME_TAB_COMMAND );
			closePopup();
		}
		/**
		 * Handles the mouse event CLICK on the 'invite friends' button.
		 * It sends notification :  SOCIAL_INVITE_FRIENDS.
		 * @param event
		 * 
		 */		
		private function inviteFriendsHandler( event:Event ):void {
			
			sendNotification( GeneralAppNotifications.SOCIAL_INVITE_FRIENDS );
		}		
	}
}