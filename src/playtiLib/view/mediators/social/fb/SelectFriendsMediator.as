package playtiLib.view.mediators.social.fb
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.components.social.fb.SelectFriendsVLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	
	public class SelectFriendsMediator extends PopupMediator	{
		
		protected var selectFriendsVLogic:SelectFriendsVLogic;
		
		public function SelectFriendsMediator( mc_name:String, selectFriendsVLogic:SelectFriendsVLogic=null )	{
			this.selectFriendsVLogic = selectFriendsVLogic != null ? selectFriendsVLogic : new SelectFriendsVLogic(mc_name);
			super( NAME, selectFriendsVLogic );
			this.selectFriendsVLogic = popup_logic as SelectFriendsVLogic;			
		}
		
		override public function listNotificationInterests():Array{
			return super.listNotificationInterests().concat([GeneralAppNotifications.CLOSE_POPUP,
				GeneralAppNotifications.UPDATE_AFTER_SOCIAL_REQ_SENT
			]);
		}
		
		override public function handleNotification(notification:INotification):void{
			super.handleNotification( notification );
			switch(notification.getName() ){
				case GeneralAppNotifications.CLOSE_POPUP:
					closePopup();
					break;
				case GeneralAppNotifications.UPDATE_AFTER_SOCIAL_REQ_SENT:
					var usersArray:Array = [].concat( ( notification.getBody() as String ).split(',') );
					selectFriendsVLogic.updateAfterUsersSent( usersArray );
					break;
			}
		}
		
		override public function onRegister():void{
			super.onRegister();
			registerListeners();
		}
		
		protected function registerListeners():void{
			
			selectFriendsVLogic.addEventListener( GeneralAppNotifications.ON_SEND_BTN_CLICK, onSendBtnClick );
			selectFriendsVLogic.addEventListener( SelectFriendsVLogic.NO_MORE_FRIENDS_TO_SEND, onNoMoreFriendsToSend );
		}
		
		protected function onNoMoreFriendsToSend(event:Event):void{
			
			closePopup();
		}
		
		public override function closePopup():void{
			
			sendNotification( GeneralAppNotifications.SHOW_GAME_TAB_COMMAND );
			
			super.closePopup();
		} 
		
		protected function onSendBtnClick( event:EventTrans ):void{
			//implement in each extended class
		}
		
		public function fillFriendsList():void{
			//implement in each extended class
		}
	}
}