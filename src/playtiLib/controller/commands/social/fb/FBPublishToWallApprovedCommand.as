package playtiLib.controller.commands.social.fb
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.social.SocialPostVO;
	/**
	 * Gets a SocialPostVO object from the notification's body and if it's is_gift parameter is true, it sends notifications(ADD_APP_REQUEST, PUBLISH_GIFT_COMPLETE)
	 * and if not it sends notification (PUBLISH_GIFT_COMPLETE)
	 * @see playtiLib.config.notifications.GeneralAppNotifications
	 * @see playtiLib.model.vo.social.SocialPostVO
	 * @see org.puremvc.as3.interfaces.INotification
	 */	
	public class FBPublishToWallApprovedCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var post_vo:SocialPostVO = notification.getBody() as SocialPostVO;
			if( post_vo && post_vo.is_gift ) {
				sendNotification( GeneralAppNotifications.ADD_APP_REQUEST, post_vo.user_sn_id );
				sendNotification( GeneralAppNotifications.PUBLISH_GIFT_COMPLETE, post_vo );
			} else 
				sendNotification( GeneralAppNotifications.PUBLISH_TO_WALL_COMPLETE, true );
		}
	}
}