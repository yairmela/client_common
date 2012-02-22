package playtiLib.view.components.social.fb
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.components.btns.ButtonSimple;

	public class SelectFriendsSendGiftVLogic extends SelectFriendsVLogic
	{
		public static const APP_FRIENDS_TAB_CLICK:String = 'appFriendsTabClick';
		public static const ALL_FRIENDS_TAB_CLICK:String = 'allFriendsTabClick';
		public var appFriendsBtn:ButtonSimple;
		public var allFriendsBtn:ButtonSimple;
		
		public function SelectFriendsSendGiftVLogic( mc_name:String ){
			super( mc_name );
		}
		
		protected override function registerComponents():void{
			
			appFriendsBtn 		= new ButtonSimple( popup_mc['app_friends_btn'] );
			allFriendsBtn 		= new ButtonSimple( popup_mc['all_btn'] );
			super.registerComponents();
		}
		
		protected override function initComponents():void{
			
			super.initComponents();
			appFriendsBtn.enabled = false;
			allFriendsBtn.enabled = false;
		}
		
		protected override function addListeners():void{
			super.addListeners();
			appFriendsBtn.addEventListener( MouseEvent.CLICK, onAppFriendsTabClick );
			allFriendsBtn.addEventListener( MouseEvent.CLICK, onAllFriendsTabClick );
		}
		
		protected override function showTab( tabName:String ):void{
			
			super.showTab(tabName);
			switch( tabName ){
				case ALL_FRIENDS_LIST:
					appFriendsBtn.enabled 	= true;
					allFriendsBtn.enabled 	= false;
					break;
				case APP_FRIENDS_LIST:
					allFriendsBtn.enabled 	= true;
					appFriendsBtn.enabled 	= false;
					break;
			}
		}
		
		private function onAllFriendsTabClick(event:MouseEvent):void	{
			dispatchEvent( new EventTrans( ALL_FRIENDS_TAB_CLICK ) );
			
		}
		
		private function onAppFriendsTabClick( event:MouseEvent ):void{
			dispatchEvent( new EventTrans( APP_FRIENDS_TAB_CLICK ) );
		}
	}
}