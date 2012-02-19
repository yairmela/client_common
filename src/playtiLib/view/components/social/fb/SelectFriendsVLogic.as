package playtiLib.view.components.social.fb
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.social.fb.FBSelectUserVO;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.components.popups.PopupViewLogic;
	
	public class SelectFriendsVLogic extends PopupViewLogic	{
		
		public static const DEFAULT_SEARCH_MSG:String 			= 'Search for friends';
		public static const NO_MORE_FRIENDS_TO_SEND:String 		= "NO_MORE_FRIENDS_TO_SEND";
		
		public static const APP_FRIENDS_LIST:String 			= 'app_friends_list';
		public static const ALL_FRIENDS_LIST:String 			= 'all_friends_list';
		
		public static const MAX_FRIENDS_TO_SEND:int 			= 50;
		
		protected var mainFriendsList:Array;
		protected var fullFriendsList:Array;
		protected var availableFriendsList:Array;
		protected var chosenFriendsList:Array;
		protected var sentFriendsArray:Array;
		
		protected var searchFriendsText:TextField;
		protected var user_sent:TextField;
		
		public var sendBtn:ButtonSimple;
		public var sendMoreBtn:ButtonSimple;
		
		protected var selectAllBtn:ButtonSimple;
		protected var unselectAllBtn:ButtonSimple;
		
		protected var friendsList:SelectFriendsListVLogic;
		protected var chosenList:SelectFriendsListVLogic;
		protected var preloader_mc:MovieClip;
		protected var progress:MovieClip;
		
		public function SelectFriendsVLogic( mc_name:String ){
			
			super( mc_name );
			
			registerComponents();			
		}
		
		protected function registerComponents():void{
			
			sendBtn 			= new ButtonSimple( popup_mc['send_to_all_btn']['send_btn'] );
			sendMoreBtn 		= new ButtonSimple( popup_mc['send_to_all_btn']['send_more_btn'] );
			
			selectAllBtn 		= new ButtonSimple( popup_mc['select_all_btn']['select_all_btn'] );
			unselectAllBtn 		= new ButtonSimple( popup_mc['select_all_btn']['unselect_all_btn'] );
			
			friendsList 		= new SelectFriendsListVLogic( popup_mc['scrolled_selected_friends'], 'friend_select_item' );
			chosenList 			= new SelectFriendsListVLogic( popup_mc['scrolled_chosen_friends'], 'chosen_friend_item' );
			
			searchFriendsText   = popup_mc['search_for_friends'] as TextField;
			
			preloader_mc 		= popup_mc['games_preloader'] as MovieClip;
			
			progress  			= popup_mc['progress'] as MovieClip;
			user_sent   		= progress.progress_bar.sent_number as TextField;
			
			initComponents();
		}
		
		protected function initComponents():void{
			
			searchFriendsText.mouseEnabled 				= true;
			sendBtn.enabled 							= false;
			unselectAllBtn.enabled						= false;
			selectAllBtn.enabled						= false;
			
			setVisble( progress, false );
			setVisble( sendMoreBtn.content, false );
			sendMoreBtn.enabled = false;
			
			fullFriendsList 							= [];
			availableFriendsList 						= [];
			chosenFriendsList 							= [];
			sentFriendsArray 							= [];
			mainFriendsList 							= [];
		}
		
		private function addListeners():void{
			
			searchFriendsText.addEventListener(FocusEvent.FOCUS_IN, onFocusEvent );
			searchFriendsText.addEventListener(FocusEvent.FOCUS_OUT, onFocusEvent );
			searchFriendsText.addEventListener(Event.CHANGE, onSearchFriends );
			friendsList.addEventListener(GeneralAppNotifications.SELECT_FRIEND_CLICK, onChooseFriend );
			chosenList.addEventListener(GeneralAppNotifications.SELECT_FRIEND_CLICK, onDeChooseFriend );
			selectAllBtn.addEventListener(MouseEvent.CLICK, onSelectAllClick );
			unselectAllBtn.addEventListener(MouseEvent.CLICK, onSelectAllClick );
		}
		//the function called only for init the component - by the mediator
		public function insertFriends( friendsInfoList:Array, listType:String ):void{
			
			if( preloader_mc && preloader_mc.parent )
				preloader_mc.parent.removeChild(preloader_mc);
			
			addListeners();
			showTab( listType );
			
			mainFriendsList 		= [].concat( friendsInfoList );
			
			friendsInfoList = friendsInfoList.filter(function(user:FBSelectUserVO, ...args):Boolean{
				return chosenFriendsList.indexOf( user ) == -1;});
			if( sentFriendsArray.length > 0 ){
				friendsInfoList = friendsInfoList.filter(function(user:FBSelectUserVO, ...args):Boolean{
					return sentFriendsArray.indexOf( user ) == -1;});
			}
			
			availableFriendsList 	= [].concat( friendsInfoList );
			fullFriendsList 		= [].concat( friendsInfoList );
			
			friendsList.insertFriends( friendsList.sortArray( availableFriendsList ) );
			chosenList.insertFriends( chosenFriendsList );
			friendsList.list.GetListWindow().currentItemIndex = 0;
			
			selectAllBtn.enabled = !( availableFriendsList.length == 0 );
			unselectAllBtn.enabled  = (!selectAllBtn.enabled) && chosenFriendsList.length > 0;
			
			onFocusEvent(new FocusEvent( FocusEvent.FOCUS_IN ) );
			onFocusEvent(new FocusEvent( FocusEvent.FOCUS_OUT ) );
		}
		//function that handles the click on friend id from the left list (select friends for sending request)
		private function onChooseFriend( event:EventTrans ):void{
			
			var fbSelectedUser:FBSelectUserVO = event.data as FBSelectUserVO;
			for each( var selectedFriend:FBSelectUserVO in availableFriendsList  ){
				if( selectedFriend.id == fbSelectedUser.id ){
					availableFriendsList.splice( availableFriendsList.indexOf( selectedFriend ), 1 );;
					fullFriendsList.splice( fullFriendsList.indexOf( selectedFriend ), 1 );;
					chosenFriendsList.push( selectedFriend );
					break;
				}
			}
			updateProgress();
			updateLists();
		}
		//function that handles the click on the right list (un select friends)
		private function onDeChooseFriend( event:EventTrans ):void{
			
			var fbSelectedUser:FBSelectUserVO = event.data as FBSelectUserVO;
			for each( var selectedFriend:FBSelectUserVO in chosenFriendsList  ){
				if( selectedFriend.id == fbSelectedUser.id ){
					chosenFriendsList.splice( chosenFriendsList.indexOf( selectedFriend ), 1 );
					if( mainFriendsList.indexOf( selectedFriend ) != -1 ){
						fullFriendsList.push( selectedFriend );
						availableFriendsList.push( selectedFriend );
					}
					break;
				}
			}
			updateProgress();
			updateLists();
		}
		
		private function onSelectAllClick( event:MouseEvent ):void{
			
			if( event.currentTarget == selectAllBtn ){
				for ( var i:int = 0 ; i < availableFriendsList.length ; i++ ) {
					var selectedFriend:FBSelectUserVO = availableFriendsList[i];
					chosenFriendsList.push( selectedFriend );
					availableFriendsList.splice( availableFriendsList.indexOf( selectedFriend ), 1 );;
					fullFriendsList.splice( fullFriendsList.indexOf( selectedFriend ), 1 );
					i--;
				}
			}
			else if( event.currentTarget == unselectAllBtn ){
				chosenFriendsList = chosenFriendsList.filter( function( user:FBSelectUserVO, ...args):Boolean{
					return mainFriendsList.indexOf( user ) != -1; } );
				availableFriendsList = availableFriendsList.concat( chosenFriendsList );
				fullFriendsList = fullFriendsList.concat( chosenFriendsList );
				chosenFriendsList = [];
			}
			updateProgress();
			updateLists();
		}
		//function that handles the focus in and out from the search component
		private function onFocusEvent( event:FocusEvent ):void{
			
			if( event.type == FocusEvent.FOCUS_IN ){
				searchFriendsText.text = searchFriendsText.text == DEFAULT_SEARCH_MSG ? "" : searchFriendsText.text;
				onSearchFriends( event );
			}else if( event.type == FocusEvent.FOCUS_OUT ){
				onSearchFriends( event );
				searchFriendsText.text = searchFriendsText.text == "" ? DEFAULT_SEARCH_MSG : searchFriendsText.text;
			}
		}
		//function that filter the left list by the search component
		private function onSearchFriends( event:Event ):void{
			
			var str:String = searchFriendsText.text.toLowerCase();
			availableFriendsList = fullFriendsList.filter(
				function(item:FBSelectUserVO, ...args):Boolean{
					return item.name.toLowerCase().indexOf( str ) > -1 });
			updateLists();
		}
		
		protected function updateLists():void{
			updateAvailableList();
			updateChosenList();
			updateComponents();
		}
		
		protected function updateComponents():void{
			
			var sentFriendsNumber:int = sentFriendsArray.length;
			var outOfSend:int = sentFriendsNumber + chosenFriendsList.length;
			
			if( getVisble(sendBtn.content) ){
				sendBtn.enabled = !( chosenFriendsList.length == 0 );
			}
			sendMoreBtn.enabled = !( chosenFriendsList.length == 0 );
			
			(progress.progress_bar.sent_of_number as TextField).text = 'Sent ' + sentFriendsNumber +' out of ' + outOfSend ;
		}
		
		private function updateAvailableList():void{
			
			friendsList.updateList( friendsList.sortArray( ( availableFriendsList ) ) );
			selectAllBtn.enabled = !( availableFriendsList.length == 0 );
			unselectAllBtn.enabled  = (!selectAllBtn.enabled) && chosenFriendsList.length > 0;
		}
		
		private function updateChosenList():void{
			
			chosenList.updateList( friendsList.sortArray( ( chosenFriendsList ) ) );
		}
		
		private function updatePosition( users:Array ):Array{
			
			var returnArray:Array = [].concat(users);
			var i:int = 0;
			for each( var user:FBSelectUserVO in users ){
				user.position = i;
				i++;
			}
			return returnArray;
		}
		
		protected function showTab( tabName:String ):void{
			
		}
		public function updateProgress():void{
			if( getVisble( progress ) ){
				var sentUserProgress:Number = Math.ceil( sentFriendsArray.length / (sentFriendsArray.length + chosenFriendsList.length) * 100 );
				( progress.progress_bar as MovieClip ).gotoAndStop( sentUserProgress );
			}
		}
		public function updateAfterUsersSent( sentUserArray:Array ):void{
			
			sentFriendsArray = sentFriendsArray.concat(sentUserArray);
			setVisble( sendMoreBtn.content, true );
			sendMoreBtn.enabled = true;
			//filter out from the chosen list(right list) the ids that the FB req was sent to them
			chosenFriendsList = chosenFriendsList.filter(
				function( item:FBSelectUserVO, ...args ):Boolean{
					return !( sentUserArray.indexOf( item.id ) > -1 );
				});
			//update progress bar
			setVisble( progress , true );
			updateProgress();
			//update progress arrow
			setVisble( progress.progress_arrow as MovieClip , chosenFriendsList.length > 0  );
			//			//update progress msg
			if(sendBtn.content && sendBtn.content.parent)
				sendBtn.content.parent.removeChild(sendBtn.content);
			
			if( chosenFriendsList.length == 0 ){
				dispatchEvent( new EventTrans(NO_MORE_FRIENDS_TO_SEND ) );
			}
			
			updateLists();
		}
		//retruns the next 'group' of friends that the user will send to - in that case - 50 friends each click on the send btn
		public function get nextSendFriendsArray():Array{
			
			var returnArray:Array = [];
			for( var i:int = 0 ; i < MAX_FRIENDS_TO_SEND ; i++ ){
				if( i < chosenFriendsList.length){
					returnArray.push( chosenFriendsList[i] );
				}else{
					break;
				}
			}
			returnArray = returnArray.map(function(user:FBSelectUserVO, ...args):String{
				return user.id;});
			return returnArray;
		}
		
		protected function setVisble( mc:MovieClip, value:Boolean ):void{
			mc.alpha = value?1:0;
			if( !value ){
				
			}	
		}
		
		protected function getVisble(mc:MovieClip):Boolean{
			return mc.alpha ? true : false;
		}
	}
}