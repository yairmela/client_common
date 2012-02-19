package playtiLib.controller.commands.social.mm
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.config.server.GeneralCallsConfig;
	import playtiLib.config.server.ServerCallConfig;
	import playtiLib.model.vo.amf.response.TransactionStatusMessage;
	import playtiLib.model.vo.payment.CurrencyCost;
	import playtiLib.model.proxies.payment.CurrencyCostProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.locale.TextLib;
	import playtiLib.utils.social.mm.MailruCall;
	import playtiLib.utils.social.mm.MailruCallEvent;

	/**
	 * Gets a CurrencyCostVO object by the notification's body, sends notification (CLOSE_PAYPAGE), if selected record is provided - save it, adds listerners
	 * (PAYMENT_PAGE, PAYMENT_DIALOG) to the MailruCall and exe mailru.app.payments.showDialog.
	 * @see playtiLib.utils.social.mm.MailruCall
	 * @see playtiLib.model.vo.payment.BuyTransactionVO
	 * @see playtiLib.model.vo.payment.CurrencyCostVO
	 * @see playtiLib.model.proxies.payment.CurrencyCostProxy
	 * @see playtiLib.utils.data.DataCapsule
	 */	
	public class MMBuyChipsCommand extends SimpleCommand implements ICommand	{
		
		override public function execute( notification:INotification ):void	{
			
			// set the buy properties
			var selected_currency:CurrencyCost = ( notification == null ) ? null : notification.getBody() as CurrencyCost;
			// close buy page
			sendNotification( GeneralAppNotifications.CLOSE_PAYPAGE );
			// if selected record is provided - save it 
			if( selected_currency != null ) {
				currency_proxy.selected_cost = selected_currency;
			}
						
			MailruCall.addEventListener( MailruCallEvent.PAYMENT_PAGE, onStatus );
			MailruCall.addEventListener( MailruCallEvent.PAYMENT_DIALOG, onDialogStatus );
			MailruCall.exec( "mailru.app.payments.showDialog",null,{service_id: 1,service_name:  TextLib.lib.retrive( 'payPage.buyCoins' ),other_price: currency_proxy.selected_cost.currencyCost} );
		}
		/**
		 * Makes new BuyTransactionVO object, set it's status as TRANSACTION_STATUS_CANCELED and sends notification BUY_RESULT with it.
		 * 
		 */		
		private function buyCanceled():void {
			
			var transactionResult:TransactionStatusMessage = new TransactionStatusMessage();
			transactionResult.transactionStatus = ServerCallConfig.TRANSACTION_STATUS_CANCELED;
			sendNotification( GeneralAppNotifications.BUY_RESULT, transactionResult  );
		}
		/**
		 * Gets an object and checks if it's status property is 'fail', it executes buyCanceled function, if it isn't, it gets data
		 * capsule from the data capsule factory, adds listener (complete) and load the dataCapsule.
		 * @param response
		 * 
		 */		
		private function onStatus( response:Object ):void{
			
			if ( response.data['status'] == 'fail' ) {
				buyCanceled();
			} else {
				var buy_request_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [AMFGeneralCallsConfig.BUY_COINS.setRequestProperties({type: currency_proxy.selected_cost.currencyCostId})] );
				buy_request_capsule.addEventListener( Event.COMPLETE, onBuyChips );
				buy_request_capsule.loadData();	
			}
		}
		/**
		 * Gets a dataCapsule object, removes the COMPLETE listener, sets the transaction id in the CurrencyCostProxy and sends
		 * notification (CHECK_BUY_STATUS).
		 * @param event
		 * 
		 */		
		private function onBuyChips( event:Event ):void	{
			
			var capsule:DataCapsule = event.currentTarget as DataCapsule;
			capsule.removeEventListener( Event.COMPLETE, onBuyChips );
			currency_proxy.current_transaction_id = capsule.getDataHolderByIndex(0).data.tran_id as int;
			sendNotification( GeneralAppNotifications.CHECK_BUY_STATUS, false );
		}
		/**
		 * Executes the buyCanceled function if the status in the response object (that the function gets) = 'closed'. 
		 * @param response
		 * 
		 */		
		private function onDialogStatus( response:Object ):void{
			
			if ( response.data['status'] == 'closed' )
				buyCanceled();
		}
		
		private function get currency_proxy():CurrencyCostProxy	{
			
			return facade.retrieveProxy( CurrencyCostProxy.NAME ) as CurrencyCostProxy;
		}
	}
}