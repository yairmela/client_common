package playtiLib.view.components.popups
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.user.UserUtil;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.components.user.FriendsListVLogic;
	/**
	 * Holds preloader mc, send gift btn, invite friends btn and FriendsListVLogic object that listeners to CHANGE event for
	 * enabling the send btn. It also has the functionality to insertFriends.
	 * @see playtiLib.view.components.user.FriendsListVLogic
	 * @see playtiLib.view.components.popups.PopupViewLogic
	 * @see playtiLib.utils.user.UserUtil
	 */
	public class ChooseSnUserViewLogic extends PopupViewLogic	{
		
		public var send_btn:ButtonSimple;
		public var invite_friends_btn:ButtonSimple;
		public var friends_list:FriendsListVLogic;
		public var default_friend_sn_uid:String;
		public var send_count_text:TextField;
		public var preloader_mc:MovieClip;
		
		public function ChooseSnUserViewLogic( default_friend_sn_uid:String ){
			
			super( 'pop_up_select_sn_users' );
			this.default_friend_sn_uid = default_friend_sn_uid;
			
			preloader_mc = popup_mc['preloader'] as MovieClip;
			preloader_mc.visible = false;
			
			send_btn = new ButtonSimple( popup_mc['sendGift'] );
			send_btn.enabled = false;
			
			invite_friends_btn = new ButtonSimple( popup_mc['invite_dock']['invite_btn'] );
			popup_mc['invite_dock'].visible = false;
			
			//this is regular send gifts popup state
			if( popup_mc.hasOwnProperty( 'sent_count_txt' ) )
				send_count_text = popup_mc['sent_count_txt'] as TextField;
			friends_list = new FriendsListVLogic( popup_mc['listUsers'] );
			friends_list.list.GetListWindow().itemsRadioGroup.addEventListener( Event.CHANGE, enableSendButton );
		}
		/**
		 * Gets an array of users. It checks if it empty and if it is, is set the invite dock (in the popup mc) to true.
		 * If it isn't empty, it checks if the defualt friend uid is empty. If it isn't, it gets this user and inserts the array to the
		 * friends list and gets the list window.
		 * @param users
		 * 
		 */		
		public function insertFriends( users:Array ):void {
			
			if( users.length == 0 ) {
				popup_mc['invite_dock'].visible = true;
				return;
			}
			if( default_friend_sn_uid != '' ) {
				var user:UserSocialInfo = UserUtil.getUserBySnUId( default_friend_sn_uid, users );
				if( user ) {
					users.splice( users.indexOf( user ), 1);
					users.unshift( user );
				}
			}
			
			friends_list.insertFriends( users );
			friends_list.list.GetListWindow().currentItemIndex = 0;
		}
		/**
		 * Sets the send_btn enable to true; 
		 * @param event
		 * 
		 */		
		private function enableSendButton( event:EventTrans ):void {
			
			send_btn.enabled = true;
		}
		
		private function setGiftBtnsDepth( event:EventTrans ):void {
			
			var btn_index:int = event.data as int;
			var choosed_btn:MovieClip = popup_mc['gifts_btns_con']['radio' + btn_index] as MovieClip;
			choosed_btn.parent.swapChildren( choosed_btn, choosed_btn.parent.getChildAt( choosed_btn.parent.numChildren-1 ) );
		}
	}
}