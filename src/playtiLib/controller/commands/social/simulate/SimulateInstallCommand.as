package playtiLib.controller.commands.social.simulate
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;

	public class SimulateInstallCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			sendNotification( GeneralAppNotifications.SOCIAL_INSTALL_APPROVED );
		}
	}
}