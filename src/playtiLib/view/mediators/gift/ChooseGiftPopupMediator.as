package playtiLib.view.mediators.gift
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.gift.ChooseGift;
	import playtiLib.model.vo.gift.Gift;
	import playtiLib.model.vo.popup.PopupDoActionVO;
	import playtiLib.view.components.gift.ChooseGiftsViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	 
	public class ChooseGiftPopupMediator extends PopupMediator {
		
		public static const NAME:String = 'ChooseGiftPopupMediator';
		
		private var send_gift_vlogic:ChooseGiftsViewLogic;
		private var default_friend_sn_uid:String;
		private var pre_gift:Gift;
		
		public function ChooseGiftPopupMediator( default_friend_sn_uid:String="0", pre_gift:Gift = null, doAction:PopupDoActionVO=null, closeAction:PopupDoActionVO=null ) {
			
			super( NAME, new ChooseGiftsViewLogic(), doAction, closeAction );
			send_gift_vlogic = viewComponent as ChooseGiftsViewLogic;
			
			this.default_friend_sn_uid = default_friend_sn_uid;
			this.pre_gift = pre_gift;
			
			registerListeners();
			sendNotification( GeneralAppNotifications.SHOW_GIFTS_TAB_COMMAND );
			sendNotification( GeneralAppNotifications.COLLAPSE_BOTTOM_PANEL, true );
		}
		
		private function registerListeners():void {
			
			send_gift_vlogic.addEventListener( Event.COMPLETE, sendHandler );
		}
		
		public override function listNotificationInterests():Array{
			return super.listNotificationInterests().concat([GeneralAppNotifications.CLOSE_POPUP]);
		}
		
		public override function handleNotification(notification:INotification):void{
			super.handleNotification(notification);
			switch( notification.getName() ) {
				case GeneralAppNotifications.CLOSE_POPUP:
					closePopup();
					break;
			}
		}
		
		public function sendHandler( giftTypeId:String ):void {
			
			var choose_gift:ChooseGift = new ChooseGift;
			choose_gift.friend_uid = default_friend_sn_uid;
			choose_gift.pre_gift = pre_gift;
			//sends notification to the game engine for converting the chosen radio_btn to gift_type_id 
			//and sends choose_gift_complete notification
			sendNotification( GeneralAppNotifications.CHOOSE_GIFT_FROM_MEDIATOR_COMMAND, choose_gift, send_gift_vlogic.gift_radio_group.current.toString() );
			super.closePopup();
		}
		
		public override function closePopup():void{
			
			sendNotification( GeneralAppNotifications.SHOW_GAME_TAB_COMMAND );
			sendNotification( GeneralAppNotifications.COLLAPSE_BOTTOM_PANEL, false )
			super.closePopup();
		} 
	}
}