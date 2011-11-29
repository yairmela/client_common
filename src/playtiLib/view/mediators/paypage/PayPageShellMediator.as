package playtiLib.view.mediators.paypage
{
	import flash.display.Loader;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.components.paypage.PayPageShellVLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	/**
	 * @see playtiLib.view.mediators.popups.PopupMediator
	 */	
	public class PayPageShellMediator extends PopupMediator	{
		
		public static const NAME:String = 'PayPageShellMediator';
		
		private var pay_page_shell:PayPageShellVLogic;
		
		public function PayPageShellMediator( pay_page:Loader )	{
			
			super( NAME, new PayPageShellVLogic( pay_page ), null, null, true, false );
			pay_page_shell = viewComponent as PayPageShellVLogic;
			pay_page_shell.addEventListener( Event.CLOSE, closePopup );
			pay_page_shell.addEventListener( EventTrans.DATA, buyOptionSelected );
		}
		/**
		 * Returns array of the notifications that the mediator is listening for:
		 * PAYTABLE_DATA_READY, CLOSE_PAYPAGE.
		 * @return 
		 * 
		 */		
		override public function listNotificationInterests():Array {
			
			return [ GeneralAppNotifications.PAYTABLE_DATA_READY, GeneralAppNotifications.CLOSE_PAYPAGE ];
		}
		/**
		 * Handles the notifications that the mediator is listening for: 
		 * PAYTABLE_DATA_READY, CLOSE_PAYPAGE.
		 * @param notification
		 * 
		 */		
		override public function handleNotification( notification:INotification ):void {
			
			switch( notification.getName() ) {
				case GeneralAppNotifications.PAYTABLE_DATA_READY:
					pay_page_shell.pay_page.setPayTable( notification.getBody() as Array );
					break;
				case GeneralAppNotifications.CLOSE_PAYPAGE:
					pay_page_shell.pay_page.close();
					break;
			}
		}
		/**
		 * Handles the EventTrans.DATA event that the PayPageShellVLogic object
		 * is listening to. The function sends notification : GeneralAppNotifications.BUY_SELECTED_AMOUNT.
		 * @param event
		 * 
		 */		
		public function buyOptionSelected( event:EventTrans ):void {
			
			sendNotification( GeneralAppNotifications.BUY_SELECTED_AMOUNT, event.data );
		}
		
	}
}