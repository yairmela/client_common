package playtiLib.view.components.user
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.user.User;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.interfaces.IViewLogic;
	
	public class MultiUserPanelVLogic extends EventDispatcher implements IViewLogic	{
		
		public var on_scrolled_num:int 			= 5;
		public var scrolled_panel_padding:int;
		
		private var panel_mc:MovieClip;
		public var userItemClass:Class 			= MultiUserPanelItemVLogic;
		
		private var left_one_page_btn	:ButtonSimple;
		private var left_one_btn		:ButtonSimple;
		private var left_to_edge_btn	:ButtonSimple;
		private var right_one_btn		:ButtonSimple;
		private var right_one_page_btn	:ButtonSimple;
		private var right_to_eage_btn	:ButtonSimple;
		
		private var scrolled_contnent_mc:MovieClip;
		private var panels_in_scrolled:Array = [];
		//models
		private var scrolled_index:int = 0;
		private var scrolled_users_data:Array;
		
		private var player_id:String;
		private var index:int;
		/**
		 * The constructor of this class. It add (mouse CLICK) listeners to the buttons and
		 * sets the scroll content area  
		 * @param panel_mc
		 * @param user_item_class
		 */		
		public function MultiUserPanelVLogic( panel_mc:MovieClip, user_item_class:Class = null){
			
			this.panel_mc = panel_mc;
			if( user_item_class != null )
				userItemClass = user_item_class;
			index = 1;
			scrolled_panel_padding =  72;
			with( panel_mc ) {
				//set the scroll content area
				scrolled_contnent_mc = getChildByName("content") as MovieClip
				//register scroll area btns + add listeners for scroll_handler
				//left
				left_one_btn = new ButtonSimple( getChildByName("btn_left_one") as MovieClip ) ;
				left_one_btn.enabled = false;
				left_one_btn.addEventListener( MouseEvent.CLICK, scrollUsers );
				left_one_page_btn = new ButtonSimple( getChildByName("btn_left_one_screen") as MovieClip );
				left_one_page_btn.enabled = false;
				left_one_page_btn.addEventListener( MouseEvent.CLICK, scrollUsers );
				left_to_edge_btn = new ButtonSimple( getChildByName("btn_left_to_edge") as MovieClip );
				left_to_edge_btn.enabled = false;
				left_to_edge_btn.addEventListener( MouseEvent.CLICK, scrollUsers );
				//right
				right_one_btn = new ButtonSimple( getChildByName("btn_right_one") as MovieClip );
				right_one_btn.enabled = false;
				right_one_btn.addEventListener( MouseEvent.CLICK, scrollUsers );
				right_one_page_btn = new ButtonSimple( getChildByName("btn_right_one_screen") as MovieClip );
				right_one_page_btn.enabled = false;
				right_one_page_btn.addEventListener( MouseEvent.CLICK, scrollUsers );
				right_to_eage_btn = new ButtonSimple( getChildByName("btn_right_to_edge") as MovieClip );
				right_to_eage_btn.enabled = false;
				right_to_eage_btn.addEventListener( MouseEvent.CLICK, scrollUsers );
			}
		}
		
		public function insertUsers( users_arr:Array, complete_to_on_scroll_num:Boolean = true , player_id:String = '' ):void {
			
			//set data models
			this.scrolled_users_data = users_arr;
			//insert initial users
			this.player_id = player_id;
			if( complete_to_on_scroll_num )
				addEmptyToArray( scrolled_users_data, on_scrolled_num );
			//insert top 3
			var userItem_mc:MovieClip;
			//clean the scrolled content mc
			while( scrolled_contnent_mc.numChildren > 0 )
				scrolled_contnent_mc.removeChildAt( 0 );
			insertUserItemPanels( scrolled_users_data.slice(0,on_scrolled_num) )
			setScrollBtnsAvilability();
		}
		/**
		 * Updates the display objects in the panel_in_scrolled array. 
		 * It udate it's mouseChildren, mouseEnabled and the sent gift flag to be false.
		 * It returns null if the array (panels_in_scrolled) is empty. 
		 * @param reciver_ids
		 * 
		 */		
		public function updateGiftRecievers( reciver_ids:String ):void{
			
			if ( panels_in_scrolled == null ) return;
			for( var i:int = 0; i < panels_in_scrolled.length; i++ ){
				if ( panels_in_scrolled[i].user_info as User != null && ( panels_in_scrolled[i].user_info as User).userSocialInfo != null && reciver_ids.indexOf( ( panels_in_scrolled[i].user_info as User).userSocialInfo.sn_id) != -1 ) {
					( panels_in_scrolled[i].user_info as User).userInfo.is_gift_sent = true;
					var movie:MovieClip = panels_in_scrolled[i].content as MovieClip;
					movie.mouseChildren = false;
					movie.mouseEnabled = false;
				}
			}
		}
		/**
		 * Handles the mouse event CLICK on the buttons.
		 * @param event
		 * 
		 */		
		private function scrollUsers( event:MouseEvent ):void {
			
			//set params for users_data slice
			var start_index:int;
			var end_index:int;
			//set number of slots moving if negative move right
			var slots_move_num:int;
			//set the inital x of the new userPanels
			var first_panel_start_x:int;
			//assign params according to the pressed button
			switch( event.currentTarget ) {
				case left_one_btn:
					start_index = scrolled_index + on_scrolled_num;
					end_index = start_index + 1;
					slots_move_num = 1;
					first_panel_start_x = -scrolled_panel_padding;
					scrolled_index += slots_move_num;
					break;
				case right_one_btn:
					start_index = scrolled_index-1;
					end_index = start_index + 1;
					slots_move_num = -1;
					first_panel_start_x = on_scrolled_num * scrolled_panel_padding;
					scrolled_index += slots_move_num;
					break;
				case left_one_page_btn:
					start_index = scrolled_index + on_scrolled_num;
					end_index = start_index + on_scrolled_num;
					slots_move_num = on_scrolled_num;
					first_panel_start_x = -on_scrolled_num * scrolled_panel_padding;
					scrolled_index += slots_move_num;
					break;
				case right_one_page_btn:
					start_index = scrolled_index-on_scrolled_num;
					end_index = start_index + on_scrolled_num;
					slots_move_num = -on_scrolled_num;
					first_panel_start_x = on_scrolled_num * scrolled_panel_padding;
					scrolled_index += slots_move_num;
					break;
				case left_to_edge_btn:
					start_index = Math.max(scrolled_users_data.length - on_scrolled_num*2, scrolled_index);
					end_index = scrolled_users_data.length;
					slots_move_num = end_index-start_index;
					first_panel_start_x = -slots_move_num * scrolled_panel_padding;
					scrolled_index = scrolled_users_data.length - on_scrolled_num;
					break;
				case right_to_eage_btn:
					start_index = 0;
					end_index = Math.min(on_scrolled_num*2, scrolled_index);
					slots_move_num = -end_index;
					first_panel_start_x = on_scrolled_num * scrolled_panel_padding;
					scrolled_index = 0;
					break;
			}
			//insert new users
			insertUserItemPanels( scrolled_users_data.slice(start_index, end_index), first_panel_start_x );
			//initiate usersPanel move
			moveUserItemPanels( slots_move_num );
		}

		private function insertUserItemPanels( new_users:Array, start_x:int=0 ):void {
			
//			start_x = start_x;
			new_users = new_users.reverse();
			for each( var user:User in new_users ) {
				if(user){
					user.userPositionInLeaderBoard = index;	
				}
				index++;
				if( user && !user.userSocialInfo.isReady ){
					dispatchEvent( new EventTrans( GeneralAppNotifications.LOAD_USER_SOCIAL_INFO_EVENT, user.userSocialInfo.sn_id, true ) );
				}
				var userItem:MultiUserPanelItemVLogic;
				userItem = new userItemClass( user ) as MultiUserPanelItemVLogic;
				if ( user )
				   if ( player_id == user.userSocialInfo.sn_id || user.userInfo.is_gift_sent ) {
				       var movie:MovieClip 	= userItem.content as MovieClip;
					   movie.mouseChildren 	= false;
					   movie.mouseEnabled 	= false;
				   }
				userItem.addEventListener( EventTrans.DATA, dispatchEvent, false, 0, true );
				scrolled_contnent_mc.addChild( userItem.content ).x = start_x;
				start_x += scrolled_panel_padding;
				panels_in_scrolled.push( userItem );
			}
			dispatchEvent(new Event(GeneralAppNotifications.UPDATE_GIFT_ON_SCOREBOARD_EVENT));
		}
		/**
		 * Sets new position to the users item in the user panel. 
		 * It also add listener for enter frame event.
		 * @param number_of_slots
		 * 
		 */		
		private function moveUserItemPanels( number_of_slots:int ):void {
			
			setScrollBtnsAvilability( true );
			for each( var userItem:MultiUserPanelItemVLogic in panels_in_scrolled ) {
				userItem.desiredX = userItem.content.x + number_of_slots * scrolled_panel_padding;
			}
			scrolled_contnent_mc.addEventListener( Event.ENTER_FRAME, updateUserItemPanels );
		}
		/**
		 * Handles the ENTER_FRAME event on the scrolled_content movie clip. 
		 * @param event
		 * 
		 */		
		private function updateUserItemPanels( event:Event ):void {
			
			var last_move_step:Boolean;
			for each( var userItem:MultiUserPanelItemVLogic in panels_in_scrolled ) {
				last_move_step = Math.abs( userItem.desiredX - userItem.content.x ) < .2 || last_move_step;
				userItem.update();
			}
			if( last_move_step )
				userItemPanelsMoveComplete();
		}
		
		private function userItemPanelsMoveComplete():void {
			
			scrolled_contnent_mc.removeEventListener( Event.ENTER_FRAME, updateUserItemPanels );
			var for_removal:Array = [];
			for each( var userItem:MultiUserPanelItemVLogic in panels_in_scrolled ) {
				userItem.content.x = userItem.desiredX;
				if( userItem.content.x < 0 || 
					userItem.content.x >= on_scrolled_num*scrolled_panel_padding ) {
					for_removal.push( userItem );
				}
			}
			for each( userItem in for_removal ) {
				if( userItem.content.parent )
					userItem.content.parent.removeChild( userItem.content );
				panels_in_scrolled.splice( panels_in_scrolled.indexOf( userItem ), 1 );
			}
			setScrollBtnsAvilability();
		}
		/**
		 * Sets the left and right btns enable. 
		 * @param forceDisable
		 * 
		 */		
		private function setScrollBtnsAvilability( forceDisable:Boolean = false ):void {
			
			left_one_btn.enabled = left_to_edge_btn.enabled = !forceDisable && ( scrolled_index+on_scrolled_num ) < scrolled_users_data.length;
			left_one_page_btn.enabled = !forceDisable && scrolled_index < scrolled_users_data.length-on_scrolled_num * 2;
			right_one_btn.enabled = right_to_eage_btn.enabled = !forceDisable && scrolled_index > 0 ;
			right_one_page_btn.enabled = !forceDisable && scrolled_index > on_scrolled_num;
		}
		/**
		 * Pushs empty cells to an array.  
		 * @param arr The array that the function pushs into te cells.
		 * @param length The number of cells that the pushed into the array.
		 * 
		 */		
		private function addEmptyToArray( arr:Array, length:int ):void {
			
			for( var i:int = arr.length; i < length; i++ ) {
				arr.push( null );
			}
		}
		/**
		 * Sets the userItem position (x) on stage.
		 * @param value This is the value that the user item moves right in pixels.
		 * 
		 */		
		public function forceItemsOffsetMove( value:Number ):void {
			
			for each( var userItem:MultiUserPanelItemVLogic in panels_in_scrolled ) {
				userItem.content.x += value;
			}
		}
		
		public function get scroll_btns():Array {
			
			return [left_one_btn,left_one_page_btn, left_to_edge_btn,
					right_one_btn, right_one_page_btn, right_to_eage_btn];
		}
		
		public function get content():DisplayObject	{
			
			return panel_mc;
		}
	}
}