package playtiLib.controller.commands.popup
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.proxies.popup.ActivePopupsProxy;
	import playtiLib.model.proxies.popup.PopupQueueProxy;
	import playtiLib.view.mediators.popups.PopupMediator;
	/**
	 * Gets popup mediator in the notification's body and a parameter for immidiatly force open in the notification's type. 
	 * If the notification doesn't have the FORCE_OPEN parameter, it inserts the popup to a queue and and wait and if it does, 
	 * it opens the popup even there is an active popup.
	 * @see playtiLib.model.proxies.popup.ActivePopupsProxy
	 * @see playtiLib.model.proxies.popup.PopupQueueProxy
	 * @see playtiLib.view.mediators.popups.PopupMediator
	 */	
	public class OpenPopupCommand extends SimpleCommand{
		
		public static const FORCE_OPEN:String = 'force_open';
		public static const HIGH_PRIORITY:String = 'high_priority';
		
		override public function execute( notification:INotification ):void {
			
			var popup_mediator:PopupMediator = notification.getBody() as PopupMediator;
			var popups_proxy:PopupQueueProxy;
			var force_open:Boolean = (notification.getType() ==  FORCE_OPEN);
			//make sure the active popups proxy is registered
			if( !facade.hasProxy( ActivePopupsProxy.NAME ) )
				facade.registerProxy( new ActivePopupsProxy );
			if( facade.hasProxy( PopupQueueProxy.NAME ) ) {
				popups_proxy = facade.retrieveProxy( PopupQueueProxy.NAME ) as PopupQueueProxy;
			} else {
				popups_proxy = new PopupQueueProxy;
				facade.registerProxy( popups_proxy );
			}
			if( force_open ) {
				facade.registerMediator( popup_mediator );
			} else {
				popups_proxy.addPopup( popup_mediator, (notification.getType() == HIGH_PRIORITY) );
				sendNotification( GeneralAppNotifications.SHOW_NEXT_POPUP );
			}
		}
	}
}