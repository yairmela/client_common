package playtiLib.controller.commands.popup
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.proxies.popup.ActivePopupsProxy;
	import playtiLib.model.proxies.popup.PopupQueueProxy;
	/**
	 * Retrieves the popup queue proxy and the active popup proxy and checks if the queue is empty or there isn't next popup in the
	 * queue or if the active popup is working and send notification CLOSED_LAST_POPUP_IN_QUEUE. If not, it registers the next popup that in 
	 * the queue.
	 * @see playtiLib.model.proxies.popup.ActivePopupsProxy
	 * @see playtiLib.model.proxies.popup.PopupQueueProxy
	 */	
	public class ShowNextPopupCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var active_popups_proxy:ActivePopupsProxy = facade.retrieveProxy( ActivePopupsProxy.NAME ) as ActivePopupsProxy;
			if( active_popups_proxy.hasActive() ) {
				return;
			}
			
			var popups_proxy:PopupQueueProxy = facade.retrieveProxy( PopupQueueProxy.NAME ) as PopupQueueProxy;
			if( !popups_proxy || !popups_proxy.hasNext() ) {
				sendNotification( GeneralAppNotifications.CLOSED_LAST_POPUP_IN_QUEUE );
				return;
			}
			
			facade.registerMediator( popups_proxy.next() );
		}
	}
}