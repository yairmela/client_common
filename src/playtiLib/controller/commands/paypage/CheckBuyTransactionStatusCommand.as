package playtiLib.controller.commands.paypage
{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.observer.Notification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.config.server.GeneralCallsConfig;
	import playtiLib.config.server.ServerCallConfig;
	import playtiLib.config.server.ServerErrorsConfig;
	import playtiLib.model.vo.amf.response.ClientResponse;
	import playtiLib.model.vo.amf.response.TransactionStatusMessage;
	import playtiLib.model.proxies.payment.CurrencyCostProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.data.DataServerResponseVO;

	/**
	 * Checks the buy transaction status. It Gets a boolean parameter by the notification's body and if it is false, it handles the time 
	 * checking of the buying status.   
	 */	
	public class CheckBuyTransactionStatusCommand extends SimpleCommand	{
		
		public static var timed_process_id:int;
		public static var failed_to_get_tran_count:int;
		
		private var time_delay:int 						= 3;
		private var passed_time:int;
		
		override public function execute( notification:INotification ):void {
			
			var is_stop:Boolean = notification.getBody() as Boolean;
			if ( !is_stop ){
				if( passed_time ) {
					passed_time += time_delay;
					switch( passed_time ) {
						case ( 60 ):
							time_delay = 10;
							break;
						case ( 600 ):
							time_delay = 60;
							break;
						case ( 1800 ):
							clearTimeout( timed_process_id );
							return;
							break;
					}
				}
				timed_process_id = 0;
				
				var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [AMFGeneralCallsConfig.GET_TRANSACTION_STATUS.setRequestProperties( {transactionToken: currency_proxy.current_transaction_token} )] );
				dataCapsule.addEventListener( Event.COMPLETE, onServerResponse );
				dataCapsule.loadData();
			} else {
				clearTimeout( timed_process_id );
			}
		}
		/**
		 * Gets a dataCapsule object when it complete loaded with data from the server. It holds the buy result data and send notification with 
		 * this data (BUY_RESULT)   
		 * @param event
		 * 
		 */		
		private function onServerResponse( event:Event ):void {
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			dataCapsule.removeEventListener( Event.COMPLETE, onServerResponse );
			
			var serverResponse:ClientResponse = dataCapsule.getDataHolderByIndex(0).server_response as ClientResponse;
			var transactionResult:TransactionStatusMessage = dataCapsule.getDataHolderByIndex(0).data as TransactionStatusMessage;
			
			if( (transactionResult.transactionStatus == ServerCallConfig.TRANSACTION_STATUS_IN_PROGRESS) ||
				(transactionResult.transactionStatus == ServerCallConfig.TRANSACTION_STATUS_CREATED) ) {
				timed_process_id = setTimeout( execute, time_delay * 1000, new Notification( '', false ) );
			} else {
				sendNotification( GeneralAppNotifications.BUY_RESULT, transactionResult );
			}
		}
		
		private function get currency_proxy():CurrencyCostProxy	{
			
			return facade.retrieveProxy( CurrencyCostProxy.NAME ) as CurrencyCostProxy;
		}
		
	}
}