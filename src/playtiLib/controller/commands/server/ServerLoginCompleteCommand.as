package playtiLib.controller.commands.server
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.GeneralCallsConfig;
	import playtiLib.config.server.ServerCallConfig;
	import playtiLib.config.server.SystemErrorConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.data.DataServerResponseVO;
	import playtiLib.utils.statistics.Tracker;
	import playtiLib.utils.tracing.Logger;

	public class ServerLoginCompleteCommand extends SimpleCommand {
		
		override public function execute( notification:INotification ):void{
			Logger.log( "ServerLoginCompleteCommand" );
			
			trackLogin( notification.getBody() );//TODO: currently comes empty
			
			sendNotification(GeneralAppNotifications.START_APPLICATION);	
			//check for users to user gifts ( start process by loading the social requests )
			sendNotification( GeneralAppNotifications.LOAD_SOCIAL_REQUESTS );
			//check for system to user coupon
			sendNotification( GeneralAppNotifications.SYSTEM_TO_USER_COUPON_COLLECTION );
			//check for today receivers
			sendNotification( GeneralAppNotifications.GET_TODAY_RECEIVERS_COMMAND );
 		}
		
		private function trackLogin( appInstalled:Boolean ):void {
			var flash_vars:FlashVarsVO = ( facade.retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy ).flash_vars;
			
			sendNotification(GeneralAppNotifications.TRACK, null, GeneralStatistics.USER_LOGIN);
			//TODO: fix this in register command
			if( flash_vars.ch == "fs" ) {
				sendNotification(GeneralAppNotifications.TRACK, {app_installed: appInstalled}, GeneralStatistics.LOADED_FROM_FEED);
			}
			else if( flash_vars.ch == "gr" ) {
				var request_ids : String = unescape( flash_vars.request_ids );
				
				if( request_ids.length && ( request_ids != "null" ) ) {
					sendNotification( GeneralAppNotifications.REQUEST_GET_GIFT_DATA, request_ids );
				}
				else {
					sendNotification( GeneralAppNotifications.TRACK, {app_installed: appInstalled}, GeneralStatistics.LOADED_FROM_INVITE );
				}
			}			
		}
	}
}
