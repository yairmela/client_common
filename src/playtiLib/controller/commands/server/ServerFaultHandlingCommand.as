package playtiLib.controller.commands.server
{
	import mx.rpc.Fault;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.ServerErrorsConfig;
	import playtiLib.config.statistics.GeneralStatistics;
	
	public class ServerFaultHandlingCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {

			handleError(notification.getBody() as int);
		}

		protected function handleError(errorCode:int):void {
			
			switch (errorCode) {
				case ServerErrorsConfig.ERROR_SERVER_MAINTENANCE: 
				case ServerErrorsConfig.ERROR_COUPONS_MAINTENANCE: 
				case ServerErrorsConfig.ERROR_MISSIONS_MAINTENANCE: 
				case ServerErrorsConfig.ERROR_PLUGIN_MAINTENANCE: 
				case ServerErrorsConfig.ERROR_SERVER_USER_HAS_FEW_SESSION: 
				case ServerErrorsConfig.ERROR_SERVER_SESSION_IS_INVALID: 
					sendNotification(GeneralAppNotifications.SYSTEM_ERROR, errorCode);
					break;
		
				case ServerErrorsConfig.ERROR_SERVER_SOME_ERROR:
				case ServerErrorsConfig.ERROR_SERVER_SESSION_EXPIRE:
					sendNotification(GeneralAppNotifications.TRACK, {error_code: errorCode}, GeneralStatistics.ERROR_FROM_SERVER);
		
					sendNotification(GeneralAppNotifications.SERVER_RELOGIN, false);
					break;
			}
		}
	}
}