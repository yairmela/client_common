package playtiLib.view.components.social.fb
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.social.fb.FBSelectUserVO;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.interfaces.IViewLogic;
	
	public class SelectFriendItemVLogic extends EventDispatcher implements IViewLogic{
		
		protected var item_mc:MovieClip;
		protected var user:FBSelectUserVO;
		protected var person_mc:MovieClip;
		
		public function SelectFriendItemVLogic( user:FBSelectUserVO, user_panel_item:MovieClip ){
			
			this.user = user;
			item_mc = user_panel_item;
			setUserParams();
		}
		
		protected function setUserParams():void {
			if( user ){
				person_mc 					= item_mc['person_mc'] as MovieClip;
				person_mc['name_txt'].text 	= user.name;
				item_mc.addEventListener(MouseEvent.CLICK, onMouseClick );
			}
		}
		
		private function onMouseClick( event:MouseEvent ):void{
			person_mc.gotoAndStop('over');
			dispatchEvent( new EventTrans( SelectFriendsListVLogic.SELECT_FRIEND_CLICK, user ) );
		}
		
		public function get content():DisplayObject	{
			
			return item_mc;
		}
		
		public function get user_info():FBSelectUserVO{
			
			return user;
		}
	}
}