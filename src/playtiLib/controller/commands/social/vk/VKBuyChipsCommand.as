package playtiLib.controller.commands.social.vk
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.config.server.ServerCallConfig;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.proxies.payment.CurrencyCostProxy;
	import playtiLib.model.vo.amf.response.TransactionStatusMessage;
	import playtiLib.model.vo.payment.CurrencyCost;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.social.vk.VkWrapperUtil;
	import playtiLib.utils.tracing.Logger;
	
	public class VKBuyChipsCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			// set the buy properties
			var selected_currency_data:Object = (notification==null)? null : notification.getBody();

			// if selected record is provided - save it 
			if ( selected_currency_data != null ) {
				var selected_currency:CurrencyCost = new CurrencyCost();
				selected_currency.currencyCostId = selected_currency_data.currencyCostId;
				selected_currency.currencyCost = selected_currency_data.currencyCost;
				currency_proxy.selected_cost = selected_currency;
			}
			
			Logger.log("VKBuyChipsCommand userslected to buy currency with " + currency_proxy.selected_cost.currencyCost+" votes");
			
			// get balance from social network
			var data_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [SocialCallsConfig.SOCIAL_BALANCE] );
			data_capsule.addEventListener( Event.COMPLETE, onSocialBalanceReceived );
			data_capsule.addEventListener(IOErrorEvent.IO_ERROR,  trace);
			data_capsule.loadData();
		}
		
		private function get currency_proxy():CurrencyCostProxy
		{
			return facade.retrieveProxy(CurrencyCostProxy.NAME) as CurrencyCostProxy;
		}
		
		private function onSocialBalanceReceived(event:Event):void
		{
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			data_capsule.removeEventListener( Event.COMPLETE, onSocialBalanceReceived );
			var current_balance_in_social:int = int( data_capsule.getDataHolderByIndex(0).server_response );
			
			Logger.log("VKBuyChipsCommand checkBalance currentSocBalance = " + current_balance_in_social);
			
			if( current_balance_in_social >= currency_proxy.selected_cost.currencyCost ) {
				Logger.log("VKBuyChipsCommand sendBuyRequest currencyId " + currency_proxy.selected_cost.currencyCost );
				var buy_request_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule([AMFGeneralCallsConfig.BUY_COINS.setRequestProperties({type: currency_proxy.selected_cost.currencyCostId})]);
				buy_request_capsule.addEventListener(Event.COMPLETE, onBuyChips );
				buy_request_capsule.loadData();
			} else {
				// wait for window close to see if buy was canceld
				VkWrapperUtil.getInstance().addEventListener( VkWrapperUtil.EVENT_onWindowFocus, onBuyVotesCancel );
				VkWrapperUtil.getInstance().addEventListener( VkWrapperUtil.EVENT_onBalanceChanged, onBalanceChanged );
				VkWrapperUtil.getInstance().showPaymentBox( currency_proxy.selected_cost.currencyCost - current_balance_in_social );
			}
		}
		
		private function onBuyChips(event:Event):void
		{
			Logger.log("VKBuyChipsCommand onBuyChips" );
			var capsule:DataCapsule = event.currentTarget as DataCapsule;
			capsule.removeEventListener(Event.COMPLETE, onBuyChips );
			
			currency_proxy.current_transaction_id = capsule.getDataHolderByIndex(0).data.tran_id as int;
			sendNotification( GeneralAppNotifications.CHECK_BUY_STATUS, false );
		}

		private function onBalanceChanged( event:Event ):void {
			Logger.log('VKBuyChipsCommand onBalanceChanged');
			VkWrapperUtil.getInstance().removeEventListener( VkWrapperUtil.EVENT_onBalanceChanged, onBalanceChanged );
			VkWrapperUtil.getInstance().removeEventListener( VkWrapperUtil.EVENT_onWindowFocus, onBuyVotesCancel );
			execute(null);
		}
		private function onBuyVotesCancel( event:Event ):void {
			Logger.log('VKBuyChipsCommand onBuyVotesCancel');
			VkWrapperUtil.getInstance().removeEventListener( VkWrapperUtil.EVENT_onBalanceChanged, onBalanceChanged );
			VkWrapperUtil.getInstance().removeEventListener( VkWrapperUtil.EVENT_onWindowFocus, onBuyVotesCancel );
			
			var transactionResult:TransactionStatusMessage = new TransactionStatusMessage();
			transactionResult.transactionStatus = ServerCallConfig.TRANSACTION_STATUS_CANCELED;
			sendNotification( GeneralAppNotifications.BUY_RESULT, transactionResult  );
		}

	}
}