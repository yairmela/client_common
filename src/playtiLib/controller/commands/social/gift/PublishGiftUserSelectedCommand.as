package playtiLib.controller.commands.social.gift
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.social.SocialPostVO;
	/**
	 * Gets a SocialPostVO object and user SN id from the notification's body, removes the command CHOOSE_SN_USER_COMPLETE and sends 
	 * notification PUBLISH_TO_WALL_COMMAND' with it's information.
	 */	
	public class PublishGiftUserSelectedCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var post_vo:SocialPostVO = notification.getBody().additional_data as SocialPostVO;
			post_vo.user_sn_id = String( notification.getBody().user_sn_id );
			facade.removeCommand( GeneralAppNotifications.CHOOSE_SN_USER_COMPLETE );
			sendNotification( GeneralAppNotifications.PUBLISH_TO_WALL_COMMAND, post_vo );
		}
	}
}