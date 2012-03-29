package playtiLib.view.components.user
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.view.components.list.AutoArrangeDisplayContainer;
	import playtiLib.view.components.list.ListBoxSimple;
	import playtiLib.view.interfaces.IViewLogic;
	/**
	 * Represents the list of friends component that on the stage. It holds a ListBoxSimple object and a list of MovieClip. 
	 * @see flash.display.MovieClip
	 * @see playtiLib.utils.warehouse.GraphicsWarehouseList
	 * @see playtiLib.model.vo.user.UserVO
	 */	
	public class FriendsListVLogic implements IViewLogic{
		
		private var list_mc:MovieClip;
		public var list:ListBoxSimple;
		
		public function FriendsListVLogic( list_mc:MovieClip ){
			
			this.list_mc = list_mc;
			list = new ListBoxSimple( list_mc );
		}
		/**
		 * Gets an array of users and add it to a ListBoxSimple object.
		 * @param users
		 * 
		 */		
		public function insertFriends( users:Array ):void {
			
			var mask_mc:MovieClip =  list_mc['listItems']['viewportMask'] as MovieClip;
			var scrollable_content_mc:MovieClip =  list_mc['listItems']['scrollableContent'] as MovieClip;
			var content_con_mc:AutoArrangeDisplayContainer = new AutoArrangeDisplayContainer( mask_mc.width, scrollable_content_mc );
			for each( var user:UserSocialInfo in users ) {
				var friend_mc:MovieClip = GraphicsWarehouseList.getAsset( 'friend_item' ) as MovieClip;
				friend_mc['mark_as_sent'].visible = false;
				friend_mc.fname.text = user.first_name;
				friend_mc.lname.text = user.last_name;
				var user_poto:Loader = new Loader();
				user_poto.load( new URLRequest( user.photo ) );
				friend_mc.foto.addChild( user_poto );
				content_con_mc.addChild( friend_mc );
				list.GetListWindow().AddItem( friend_mc ).data = user;
			}
		}
		
		public function get content():DisplayObject	{
			
			return list_mc;
		}
	}
}