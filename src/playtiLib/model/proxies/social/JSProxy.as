
package playtiLib.model.proxies.social {

	import flash.external.ExternalInterface;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.model.proxies.server.AMFServerCallManagerProxy;
	import playtiLib.model.proxies.server.ServerCallManagerProxy;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.config.statistics.KontagentConfig;
	import playtiLib.controller.commands.paypage.CheckBuyTransactionStatusCommand;
	import playtiLib.model.VO.payment.CurrencyCost;
	import playtiLib.model.proxies.payment.CurrencyCostProxy;
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.view.mediators.popups.PauseGamePopupMediator;
	
	/**
	 * Handles the java script calls back
	 * @see flash.external.ExternalInterface
	 * @see playtiLib.view.mediators.popups.PauseGamePopupMediator
	 *
	 */
	public class JSProxy extends Proxy {
		
		public static const NAME:String = 'JSProxy';
		
		public function JSProxy(){
			
			super(NAME, null);
			if (!ExternalInterface.available)
				return;
			//set listeners
			try {
				ExternalInterface.addCallback('externalCall', externalCall);
				ExternalInterface.addCallback('openPayPagePopup', openPayPagePopup);
				ExternalInterface.addCallback('inviteSent', inviteSent);
				ExternalInterface.addCallback('VKCurrencyData', VKCurrencyData);
				ExternalInterface.addCallback('waitForTransaction', waitForTransaction);
				ExternalInterface.addCallback( 'openGiftsPopup', openGiftsPopup );
//				ExternalInterface.addCallback( 'sendGiftsApproved', sendGiftsApproved );
				ExternalInterface.addCallback('resumeGame', removePausePopup);
				ExternalInterface.addCallback('showInviteFriends', showInviteFriends);
				ExternalInterface.addCallback('couponPostComplete', couponPostComplete);
				ExternalInterface.addCallback('deleteFBRequestCallback', emptyCallback);
				ExternalInterface.addCallback('publishComplete', publishComplete);
				ExternalInterface.addCallback('publishCancel', publishCancel);
				ExternalInterface.addCallback('FBGetRequestCallback', FBGetRequestCallback);
				ExternalInterface.addCallback("onExternalTrackerEvent", trackMenu);
				ExternalInterface.addCallback("acceptSurpriseGiftCoupon", acceptSurpriseGiftCoupon);
			} catch (e:Error){
			}
		}
		
		private function externalCall(call_params:Object):void {
			sendNotification(GeneralAppNotifications.EXECUTE_EXTERNAL_CALL, call_params);
		}
		
		/**
		 * Sends notification - COUPON_POST_COMPLETE
		 * @param reciver_ids
		 *
		 */
		private function couponPostComplete(reciver_ids:String, postVO:Object = null):void {
//			sendNotification( GeneralAppNotifications.COUPON_POST_COMPLETE, reciver_ids );
			sendNotification( GeneralAppNotifications.SEND_COUPON_COMMAND, postVO, reciver_ids );
			sendNotification( GeneralAppNotifications.UPDATE_TODAY_RECEIVERS, reciver_ids )
		}
		
		/**
		 * Sends notification -  REQUEST_DATA_RECEIVED
		 * @param response
		 *
		 */
		private function FBGetRequestCallback(response:Object):void {
			sendNotification(GeneralAppNotifications.REQUEST_DATA_RECEIVED, response);
		}
		
		/**
		 * Empty function
		 * @param response
		 *
		 */
		private function emptyCallback(response:Object = null):void {
		
		}
		
		/**
		 * Checks if there is a registered CurrencyCostProxy and if not it registers new one and sends notification - BUY_SELECTED_AMOUNT
		 * @param transaction_token
		 * @param currency
		 *
		 */
		private function VKCurrencyData(transaction_token:String, currency:Object):void {
			
			if (!facade.hasProxy(CurrencyCostProxy.NAME))
				facade.registerProxy(new CurrencyCostProxy());
			sendNotification(GeneralAppNotifications.BUY_SELECTED_AMOUNT, currency);
		}
		
		/**
		 * Sends notification  PUBLISH_TO_WALL_COMPLETE and track this action
		 * @param eventType
		 * @param pid
		 * @param crt
		 *
		 */
		private function publishComplete(event_type:String, pid:String, crt:String):void {
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_COMPLETE);
			sendNotification(GeneralAppNotifications.TRACK, {publish_data: {event_type: event_type, pid: pid, crt: crt}}, GeneralStatistics.PUBLISH_TO_WALL_COMPLETE);
		}
		
		/**
		 * Sends notification -  PUBLISH_TO_WALL_CANCEL
		 *
		 */
		private function publishCancel():void {
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_CANCEL);
		}
		
		/**
		 * Checks if the CurrencyCostProxy is registered and if not, it registers a new one. Sends notification - BUY_SELECTED_AMOUNT
		 * and checks if CheckBuyTransactionStatusCommand.timed_process_id == 0 then it sends notification CHECK_BUY_STATUS
		 * @param transaction_token
		 *
		 */
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
		
		/**
		 *Sends notification  OPEN_SEND_GIFT_POPUP
		 *
		 */
		private function openGiftsPopup():void {
			sendNotification(GeneralAppNotifications.OPEN_SEND_GIFT_POPUP);
		}
		
		/**
		 * Sends notification OPEN_PAY_PAGE
		 */
		private function openPayPagePopup():void {
			sendNotification(GeneralAppNotifications.OPEN_PAY_PAGE, {buyType: KontagentConfig.BUY_TYPE_TAB_CLICK});
		}
		
		private function inviteSent(event_type:String, users_list:String, pid:String, crt:String):void {
			sendNotification(GeneralAppNotifications.TRACK, {invite_data: {event_type: event_type, users_list: users_list, pid: pid, crt: crt}}, GeneralStatistics.INVITE_SENT);
		}
		
		private function showInviteFriends():void {
			sendNotification(GeneralAppNotifications.SOCIAL_INVITE_FRIENDS);
		}
		
		
		private function acceptSurpriseGiftCoupon():void {			
			sendNotification(GeneralAppNotifications.SOCIAL_ACCEPT_SURPRISE_GIFT);	
		}
		
		private function sendGiftsApproved(response:Object):void {
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_APPROVED, response);
		}
		
		private function removePausePopup():void {
			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP, false );
		}
		
		private function trackMenu(menu_type:String):void {
			sendNotification(GeneralAppNotifications.TRACK, {menu_type: menu_type}, GeneralStatistics.MENU_TAB_SELECT);
		}
	}
}
