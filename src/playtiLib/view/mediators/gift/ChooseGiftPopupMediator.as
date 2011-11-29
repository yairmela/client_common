package playtiLib.view.mediators.gift
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.gift.ChooseGift;
	import playtiLib.model.VO.gift.Gift;
	import playtiLib.model.VO.popup.PopupDoActionVO;
	import playtiLib.view.components.gift.ChooseGiftsViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	 
	public class ChooseGiftPopupMediator extends PopupMediator	{
		
		public static const NAME:String = 'ChooseGiftPopupMediator';
		
		private var send_gift_vlogic:ChooseGiftsViewLogic;
		private var default_friend_sn_uid:String;
		private var pre_gift:Gift;
		
		public function ChooseGiftPopupMediator( default_friend_sn_uid:String="0", pre_gift:Gift = null, doAction:PopupDoActionVO=null )	{
			
			super( NAME, new ChooseGiftsViewLogic() );
			send_gift_vlogic = viewComponent as ChooseGiftsViewLogic;
			
			this.default_friend_sn_uid = default_friend_sn_uid;
			this.pre_gift = pre_gift;
			
			registerListeners();
		}
		
		private function registerListeners():void {
			
			send_gift_vlogic.addEventListener( Event.COMPLETE, sendHandler );
		}
		
		public function sendHandler( giftTypeId:String ):void {
			
			var choose_gift:ChooseGift = new ChooseGift;
			choose_gift.friend_uid = default_friend_sn_uid;
			choose_gift.pre_gift = pre_gift;
			//sends notification to the game engine for converting the chosen radio_btn to gift_type_id 
			//and sends choose_gift_complete notification
			sendNotification( GeneralAppNotifications.CHOOSE_GIFT_FROM_MEDIATOR_COMMAND, choose_gift, send_gift_vlogic.gift_radio_group.current.toString() );
			closePopup();
		}
	}
}