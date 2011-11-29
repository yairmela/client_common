package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.model.proxies.user.UserProxy;
	import playtiLib.utils.statistics.Tracker;

	/**
	 *Gets notification about open pay page, tracks it and makes an external interface call to show the pay page. 
	 * @see flash.external.ExternalInterface
	 * @see playtiLib.utils.statistics.Tracker
	 */	
	public class FBOpenPayPageCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			sendNotification(GeneralAppNotifications.TRACK, {buy_type: notification.getBody()["buyType"]}, GeneralStatistics.OPEN_PAY_PAGE);
			sendNotification(GeneralAppNotifications.FULLSCREEN_MODE,false);
			ExternalInterface.call( 'showPayPage' );
		}
	}
}