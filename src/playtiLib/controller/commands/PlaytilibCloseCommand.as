package playtiLib.controller.commands
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.proxies.config.DisplaySettingsProxy;
	import playtiLib.view.mediators.core.RootMediator;
	
	public class PlaytilibCloseCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {
			
			facade.removeMediator( RootMediator.NAME );
			facade.removeProxy( DisplaySettingsProxy.NAME );
			
			facade.removeCommand( GeneralAppNotifications.CLOSE );
			
			super.execute(notification);
		}
	}
}