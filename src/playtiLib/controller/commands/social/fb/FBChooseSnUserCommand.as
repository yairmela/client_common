package playtiLib.controller.commands.social.fb
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.controller.commands.popup.OpenPopupCommand;
	import playtiLib.model.proxies.user.ChooseSnUserProxy;
	import playtiLib.view.mediators.popups.ChooseSnUserPopupMediator;
	/**
	 * Gets a process_data object by the notification's body and sends notidication to force_open popup with the user id and additional 
	 * data from the process data. It also registers new chooseSnUserProxy.
	 * @see playtiLib.controller.commands.popup.OpenPopupCommand
	 * @see playtiLib.model.proxies.user.ChooseSnUserProxy
	 * @see playtiLib.view.mediators.popups.ChooseSnUserPopupMediator
	 */
	public class FBChooseSnUserCommand extends SimpleCommand {
		
		override public function execute( notification:INotification ):void {
			
			var process_data:Object = notification.getBody();
			
			sendNotification( GeneralAppNotifications.OPEN_POPUP,
				new ChooseSnUserPopupMediator( process_data.user_sn_id, process_data.additional_data ), OpenPopupCommand.FORCE_OPEN );
			
			facade.registerProxy( new ChooseSnUserProxy() );			
		}
	}
}