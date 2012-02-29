
package playtiLib.model.proxies.social {

	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.controller.commands.paypage.CheckBuyTransactionStatusCommand;
	import playtiLib.model.proxies.payment.CurrencyCostProxy;
	import playtiLib.model.vo.payment.CurrencyCost;
	
	/**
	 * Handles the java script calls back
	 * @see flash.external.ExternalInterface
	 * @see playtiLib.view.mediators.popups.PauseGamePopupMediator
	 *
	 */
	public class JSProxy extends Proxy 
	{
		
		public static const NAME:String = 'JSProxy';
		
		public function JSProxy()
		{
			super(NAME, null);
			if (!ExternalInterface.available)
				return;
			//set listeners
			ExternalInterface.addCallback('externalCall', externalCall);
			ExternalInterface.addCallback('openPayPagePopup', openPayPagePopup);
			ExternalInterface.addCallback('inviteSent', inviteSent);
			ExternalInterface.addCallback('VKCurrencyData', VKCurrencyData);
			ExternalInterface.addCallback('waitForTransaction', waitForTransaction);
			ExternalInterface.addCallback( 'openGiftsPopup', openGiftsPopup );
//			ExternalInterface.addCallback( 'sendGiftsApproved', sendGiftsApproved );
			ExternalInterface.addCallback('pauseGame', addPausePopup);
			ExternalInterface.addCallback('resumeGame', removePausePopup);
			ExternalInterface.addCallback('showInviteFriends', showInviteFriends);
			ExternalInterface.addCallback('couponPostComplete', couponPostComplete);
			ExternalInterface.addCallback('deleteFBRequestCallback', emptyCallback);
			ExternalInterface.addCallback('publishComplete', publishComplete);
			ExternalInterface.addCallback('publishCancel', publishCancel);
			ExternalInterface.addCallback('FBGetRequestCallback', FBGetRequestCallback);
			ExternalInterface.addCallback("menuItemClick", menuItemClick);
			ExternalInterface.addCallback("acceptSurpriseGiftCoupon", acceptSurpriseGiftCoupon);
			ExternalInterface.addCallback("playTabClick", playTabClick);
		}
		
		private function playTabClick():void {
			sendNotification(GeneralAppNotifications.CLOSE_POPUP );
		}
		
		private function externalCall(call_params:Object):void {
			sendNotification(GeneralAppNotifications.EXECUTE_EXTERNAL_CALL, call_params);
		}
		
		private function couponPostComplete(reciver_ids:String, postVO:Object):void {
//			sendNotification( GeneralAppNotifications.COUPON_POST_COMPLETE, reciver_ids );
			sendNotification( GeneralAppNotifications.SEND_COUPON_COMMAND, postVO, reciver_ids );
			sendNotification( GeneralAppNotifications.UPDATE_AFTER_SOCIAL_REQ_SENT, reciver_ids );
			sendNotification( GeneralAppNotifications.UPDATE_TODAY_RECEIVERS, reciver_ids );
			sendNotification( GeneralAppNotifications.TRACK, null, GeneralStatistics.GIFT_SENT);
		}
		
		private function FBGetRequestCallback(response:Object):void {
			sendNotification(GeneralAppNotifications.REQUEST_DATA_RECEIVED, response);
		}
		
		private function emptyCallback(response:Object = null):void {
		
		}
		
		private function VKCurrencyData(transaction_token:String, currency:Object):void {
			
			if (!facade.hasProxy(CurrencyCostProxy.NAME))
				facade.registerProxy(new CurrencyCostProxy());
			sendNotification(GeneralAppNotifications.BUY_SELECTED_AMOUNT, currency);
		}
		
		private function publishComplete(event_type:String, pid:String, crt:String):void {
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_COMPLETE);
			sendNotification(GeneralAppNotifications.TRACK, {publish_data: {event_type: event_type, pid: pid, crt: crt}}, GeneralStatistics.PUBLISH_TO_WALL_COMPLETE);
		}
		
		private function publishCancel():void {
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_CANCEL);
		}

		private function waitForTransaction(transaction_token:String):void {
			
			if (!facade.hasProxy(CurrencyCostProxy.NAME)) {
				facade.registerProxy( new CurrencyCostProxy() );
			}
			
			currency_proxy.selected_cost = new CurrencyCost();
			currency_proxy.current_transaction_token = transaction_token;
			
			sendNotification(GeneralAppNotifications.BUY_SELECTED_AMOUNT);
			
			if (CheckBuyTransactionStatusCommand.timed_process_id == 0) { //only if there is no check status loop
				sendNotification(GeneralAppNotifications.CHECK_BUY_STATUS, false);
			}
		}
		
		private function get currency_proxy():CurrencyCostProxy {
			return facade.retrieveProxy(CurrencyCostProxy.NAME) as CurrencyCostProxy;
		}
		
		private function openGiftsPopup():void {
			sendNotification(GeneralAppNotifications.OPEN_SEND_GIFT_POPUP);
		}
		
		private function openPayPagePopup():void {
			sendNotification(GeneralAppNotifications.OPEN_PAY_PAGE, {buyType: GeneralStatistics.BUY_TYPE_TAB_CLICK});
		}
		
		private function inviteSent(event_type:String, users_list:String, pid:String, crt:String, initiated_from_menu:Boolean):void {
			sendNotification( GeneralAppNotifications.UPDATE_AFTER_SOCIAL_REQ_SENT, users_list );
			sendNotification(GeneralAppNotifications.TRACK, {invite_data: {event_type: event_type, users_list: users_list, pid: pid, crt: crt, initiated_from_menu: initiated_from_menu}}, GeneralStatistics.INVITE_SENT);
		}
		
		private function showInviteFriends():void {
			sendNotification(GeneralAppNotifications.SOCIAL_INVITE_FRIENDS);
		}
		
		private function acceptSurpriseGiftCoupon(gift_redeemed:Boolean):void {			
			sendNotification(GeneralAppNotifications.SOCIAL_ACCEPT_SURPRISE_GIFT, gift_redeemed);	
		}
		
		private function sendGiftsApproved(response:Object):void {
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_APPROVED, response);
		}
		
		private function addPausePopup():void {
			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP, true );
		}
		
		private function removePausePopup():void {
			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP, false );
		}
		
		private function menuItemClick(menu_type:String):void {
			sendNotification(GeneralAppNotifications.TRACK, {menu_type: menu_type}, GeneralStatistics.MENU_TAB_SELECT);
		}
	}
}
