package playtiLib.controller.commands.coupons
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.view.components.gift.GiftCollectionViewLogic;
	import playtiLib.view.mediators.gift.GiftCollectionPopupMediator;
	/**
	 * Opens the GCP popup. It is called by the collect gift(GCP) button, the sendGift button in the bottomPanelMediator 
	 * or by the scoreBoard. 
	 */
	public class OpenGiftCollectionPopupCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var forceUpdate:Boolean = notification.getType() == 'forceOpen' ? true : false;
			sendNotification( GeneralAppNotifications.OPEN_POPUP, new GiftCollectionPopupMediator(
																			new GiftCollectionViewLogic(
																						GeneralDialogsConfig.POPUP_COLLECT_GIFTS ), forceUpdate ));
			
			
		}
	}
}