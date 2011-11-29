package playtiLib.controller.commands.popup
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.view.mediators.popups.PauseGamePopupMediator;
	/**
	 * Class that sends notification force open popup and wait for action from the external intrface to resume game and removes popup.
	 */	
	public class SetPausePopupCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			if(notification.getBody() as Boolean) {
				sendNotification( GeneralAppNotifications.OPEN_POPUP, new PauseGamePopupMediator(), OpenPopupCommand.FORCE_OPEN );
			}
			else {
				facade.removeMediator( PauseGamePopupMediator.NAME );
			}
		}
	}
}