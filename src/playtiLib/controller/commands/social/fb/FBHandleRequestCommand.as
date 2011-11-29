package playtiLib.controller.commands.social.fb
{

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.VO.FlashVarsVO;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.utils.statistics.Tracker;

	/**
	 * Gets request_data object by the notification's body and tracks the information that inside it(et, pid, crt).
	 * @see playtiLib.utils.statistics.Tracker
	 */
	public class FBHandleRequestCommand extends SimpleCommand{
		
		public override function execute( notification:INotification ):void {
			
			var request_data : Object = notification.getBody();
			
			var flash_vars : FlashVarsVO = (facade.retrieveProxy(FlashVarsProxy.NAME) as FlashVarsProxy).flash_vars;
			flash_vars.et = request_data.et;
			flash_vars.crt = request_data.crt;
			
			sendNotification(GeneralAppNotifications.TRACK, {app_installed: true}, GeneralStatistics.LOADED_FROM_INVITE);
		}
	}
}