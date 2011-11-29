package playtiLib.controller.commands.social.fb
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.social.SocialPostVO;
	/**
	 * Gets a socialPostVO object and user SN id from the notification's body. It removes the command (CHOOSE_SN_USER_COMPLETE) and sends 
	 * notification PUBLISH_TO_WALL_COMMAND.
	 * by the information it got. 
	 * @see playtiLib.model.VO.social.SocialPostVO
	 */	
	public class FBPublishGiftUserSelectedCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var post_vo:SocialPostVO = notification.getBody().additional_data as SocialPostVO;
			post_vo.user_sn_id = String( notification.getBody().user_sn_id );
			facade.removeCommand( GeneralAppNotifications.CHOOSE_SN_USER_COMPLETE );
			sendNotification( GeneralAppNotifications.PUBLISH_TO_WALL_COMMAND, post_vo );
		}
	}
}