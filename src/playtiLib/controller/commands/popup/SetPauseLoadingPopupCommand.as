package playtiLib.controller.commands.popup
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.view.mediators.popups.PauseLoadingGamePopupMediator;
	/**
	 *  Class that gets a boolean parameter. If it is true, it sends notification to force open popup and if it is not, if the PauseLoadingGamePopupMediator
	 *  mediator is allready registered at the facade, it removed. 
	 */	
	public class SetPauseLoadingPopupCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			if ( ( notification.getBody() as Boolean ) ){
				sendNotification( GeneralAppNotifications.OPEN_POPUP, new PauseLoadingGamePopupMediator, OpenPopupCommand.FORCE_OPEN );
			}else{
				if ( facade.hasMediator( PauseLoadingGamePopupMediator.NAME ) ){
					facade.removeMediator( PauseLoadingGamePopupMediator.NAME );	
				}
			}
		}
	}
}