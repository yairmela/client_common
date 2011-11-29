package playtiLib.controller.commands.paypage
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.ServerCallConfig;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.controller.commands.popup.OpenPopupCommand;
	import playtiLib.model.VO.amf.response.TransactionStatusMessage;
	import playtiLib.model.VO.popup.PopupDoActionVO;
	import playtiLib.model.proxies.user.UserProxy;
	import playtiLib.utils.statistics.Tracker;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;

	/**
	 * Handles the status results of the buy transaction (success, not enough money, errors). Gets a BuyTransactionVO object in the notification's
	 * body and handles it's status property. It also sends notification to open popup(force_open).
	 */	
	public class BuyTransactionResultCommand extends SimpleCommand {
		
		override public function execute( notification:INotification ):void {
			
			var transactionResult:TransactionStatusMessage = notification.getBody() as TransactionStatusMessage;
			var result_popup_name:String;
			
			switch ( transactionResult.transactionStatus ) {
				case ServerCallConfig.TRANSACTION_STATUS_COMPLETED:
					var user_proxy:UserProxy = facade.retrieveProxy( UserProxy.NAME ) as UserProxy;
					user_proxy.reloadAll();
					sendNotification( GeneralAppNotifications.TRACK, {transaction: transactionResult}, GeneralStatistics.BUY_TRANSACTION_SUCCESS );	
					sendNotification(GeneralAppNotifications.UPDATE_TASKS_INFO);
					return;
				case ServerCallConfig.TRANSACTION_STATUS_CANCELED:
					sendNotification( GeneralAppNotifications.TRACK, null, GeneralStatistics.BUY_TRANSACTION_CANCEL );
					return;
				case ServerCallConfig.TRANSACTION_STATUS_NOT_ENOUGH_MONEY:
					result_popup_name = GeneralDialogsConfig.POPUP_TRAN_NOT_ENOUGH_MONEY;
					sendNotification( GeneralAppNotifications.TRACK, null, GeneralStatistics.BUY_TRANSACTION_NOT_ENOUGH_MONEY );
					break;
				case ServerCallConfig.SRC_ERROR:
				case ServerCallConfig.SRC_NO_CONNECTION:
				default:
					result_popup_name = GeneralDialogsConfig.POPUP_TRAN_ERROR;
					sendNotification( GeneralAppNotifications.TRACK, null, GeneralStatistics.BUY_TRANSACTION_ERORR );
					break;
			}
			sendNotification( GeneralAppNotifications.OPEN_POPUP,
									new PopupMediator( result_popup_name, 
														new PopupViewLogic( result_popup_name ), 
														new PopupDoActionVO( [GeneralAppNotifications.OPEN_PAY_PAGE],null,null,[GeneralStatistics.OPEN_PAY_PAGE_AFTER_TRANSACTION_ERROR] ),
														new PopupDoActionVO( null,null,null,[GeneralStatistics.REJECT_PAY_PAGE_AFTER_TRANSACTION_ERROR] ) ),
							OpenPopupCommand.FORCE_OPEN);
		}
	}
}