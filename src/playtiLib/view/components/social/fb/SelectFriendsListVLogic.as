package playtiLib.view.components.social.fb
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	import playtiLib.model.vo.social.fb.FBSelectUserVO;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.view.components.list.AutoArrangeDisplayContainer;
	import playtiLib.view.components.list.ListBoxSimple;
	import playtiLib.view.components.list.ListItemSimple;
	import playtiLib.view.interfaces.IViewLogic;
	
	public class SelectFriendsListVLogic extends EventDispatcher implements IViewLogic	{
		
		public static const SELECT_FRIEND_CLICK:String = 'select_friend_click';
		
		private var list_mc:MovieClip;
		public var list:ListBoxSimple;
		public var itemName:String;
		private var content_con_mc:AutoArrangeDisplayContainer;
		private var scrollable_content_mc:MovieClip;
		private var mask_mc:MovieClip;
		private var usersArray:Array;
		
		public function SelectFriendsListVLogic( list_mc:MovieClip, itemName:String ){
			
			this.list_mc 	= list_mc;
			this.itemName 	= itemName;
		}
		
		public function insertFriends( users:Array, value:Number=0 ):void {
			
			if(content_con_mc){
				content_con_mc.removeAll();	
			}
			usersArray 				= [].concat(users);
			list 					= null;
			list 					= new ListBoxSimple( list_mc );
			mask_mc 				=  list_mc['listItems']['viewportMask'] as MovieClip;
			scrollable_content_mc 	=  list_mc['listItems']['scrollableContent'] as MovieClip;
			content_con_mc 			= new AutoArrangeDisplayContainer( mask_mc.width, scrollable_content_mc );
			
			for( var i:int=0; i < users.length;i++ ) {
				var user:FBSelectUserVO = users[i] as FBSelectUserVO;
				var friend_mc:MovieClip = GraphicsWarehouseList.getAsset( itemName ) as MovieClip;
				content_con_mc.addChild( friend_mc );
				var selectFriend:SelectFriendItemVLogic = new SelectFriendItemVLogic( user, friend_mc );
				selectFriend.addEventListener( SELECT_FRIEND_CLICK, onFriendClick );
				list.GetListWindow().AddItem( friend_mc ).data = user;
			} 
			updatePosition();
		}
		
		private function onFriendClick( event:EventTrans ):void{
			(event.currentTarget as SelectFriendItemVLogic).removeEventListener( SELECT_FRIEND_CLICK, onFriendClick );
			dispatchEvent( event );
		}
		
		public function get content():DisplayObject	{
			
			return list_mc;
		}
		
		public function updateList(users:Array):void{
			
			var scrollValue:Number = list.GetScroll().value;
			
			var addUsers:Array = users.filter(function( item:FBSelectUserVO, ...args):Boolean{
				return usersArray.indexOf(item) == -1});
			
			var removeUsers:Array = usersArray.filter(function(item:FBSelectUserVO, ...args):Boolean{
				return users.indexOf(item) == -1});
			
			if(removeUsers.length){
				removeItems(removeUsers);
			}
			if(addUsers.length){
				addItems( addUsers );
			}
		}
		
		private function addItems( users:Array ):void{
			
			if( usersArray.length == 0 ){
				insertFriends( users );
				return;
			}
			for each ( var user:FBSelectUserVO in users ){
				var friend_mc:MovieClip = GraphicsWarehouseList.getAsset( itemName ) as MovieClip;
				content_con_mc.addChild( friend_mc, true, false );
				var selectFriend:SelectFriendItemVLogic = new SelectFriendItemVLogic( user, friend_mc );
				selectFriend.addEventListener( SELECT_FRIEND_CLICK, onFriendClick );
				list.GetListWindow().AddItem( friend_mc ).data = user;
			}
			usersArray = usersArray.concat( users );
			updatePosition()
		}
		
		private function removeItems( users:Array ):void{
			
			for each( var user:FBSelectUserVO in users ){
				for( var i:int = 0 ; i < list.GetListWindow().length ; i++){
					var item:ListItemSimple = list.GetListWindow().GetItem(i);
					if( user.id == ( item.data as FBSelectUserVO ).id ){
						content_con_mc.removFromStage( item.content );
						list.GetListWindow().RemoveItems( i, 1 );
						user.position = -1;
						i--;
						break;
					}		
				}
				usersArray = usersArray.filter( function( item:FBSelectUserVO, ...args):Boolean{
					return users.indexOf(item) == -1 ;});
			}
			updatePosition();
		}
		
		private function updatePosition():void{
			usersArray = sortArray( usersArray );
			for( var i:int = 0 ; i < usersArray.length ; i++){
				var user:FBSelectUserVO = usersArray[i] as FBSelectUserVO;
				user.position = i;
				list.GetListWindow().GetItem(i).content.y = (list.GetListWindow().GetItem(i).content.height+4)*i;
			}
		}
		
		public function sortArray( users:Array ):Array{
			return users.sortOn( 'name' );
		}
	}
}