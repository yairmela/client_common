package playtiLib.view.components.social.fb
{
	import playtiLib.view.components.btns.ButtonSimple;

	public class SelectFriendsSendGiftVLogic extends SelectFriendsVLogic
	{
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
	}
}