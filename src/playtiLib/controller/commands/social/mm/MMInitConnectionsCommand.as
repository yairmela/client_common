package playtiLib.controller.commands.social.mm
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.DeploymentConfig;
	import playtiLib.model.VO.social.SocialConfigVO;
	import playtiLib.utils.social.mm.MailruCall;
	/**
	 * Get a SocialConfigVO object. It adds listener to MailruCall (complete) and handles it, and handles the deployment mode
	 * (dev mode, staging mode and production mode)
	 * @see playtiLib.model.VO.social.SocialConfigVO
	 * @see playtiLib.utils.social.mm.MailruCall
	 */	
	public class MMInitConnectionsCommand extends SimpleCommand {
		
		override public function execute( notification:INotification ):void {
			
			MailruCall.addEventListener( Event.COMPLETE, mailruReadyHandler );
			//TODO: add config file to config -> MM that configures this strings
			switch ( DeploymentConfig.DEPLOYMENT_MODE ){
			 case DeploymentConfig.DEV_MODE: 
				 MailruCall.init( 'game_swf', 'dfd4057e1f1f0046c23bf0f8fbb8a573' );
				 break;
			 case DeploymentConfig.STAGING_MODE: 
				 MailruCall.init( 'game_swf', '613324ac5fa83393384c667227d1ceb0' );
				 break;
			 case DeploymentConfig.PRODUCTION_MODE: 
				 MailruCall.init( 'game_swf', 'e60830cebd5c93885475f5fc5795e296' );
				 break;
			}
		}
		/**
		 * Sends notification SOCIAL_GAME_INSTALL_CHECK.
		 * @param event
		 * 
		 */		
		private function mailruReadyHandler( event:Event ) : void {
			
			sendNotification( GeneralAppNotifications.SOCIAL_GAME_INSTALL_CHECK );
		}
	}
}