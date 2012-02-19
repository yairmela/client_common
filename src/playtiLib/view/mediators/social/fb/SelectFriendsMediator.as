package playtiLib.view.mediators.social.fb
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.popup.PopupDoActionVO;
	import playtiLib.view.components.popups.PopupViewLogic;
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
			return super.listNotificationInterests().concat([GeneralAppNotifications.CLOSE_POPUP]);
		}
		
		override public function handleNotification(notification:INotification):void{
			super.handleNotification( notification );
			switch(notification.getName() ){
				case GeneralAppNotifications.CLOSE_POPUP:
					closePopup();
					break;
			}
		}
		override public function onRegister():void{
			super.onRegister();
			registerListeners();
		}
		
		protected function registerListeners():void{
			
			selectFriendsVLogic.sendBtn.addEventListener(MouseEvent.CLICK, onSendBtnClick );
			selectFriendsVLogic.addEventListener( SelectFriendsVLogic.NO_MORE_FRIENDS_TO_SEND, closePopup );
			selectFriendsVLogic.sendMoreBtn.addEventListener(MouseEvent.CLICK, onSendBtnClick );
		}
		
		public override function closePopup(event:Event=null):void{
			sendNotification( GeneralAppNotifications.SHOW_GAME_TAB_COMMAND );
			super.closePopup(event);
		} 
		
		protected function onSendBtnClick( event:MouseEvent ):void{
			//implement in each extended class
		}
	}
}