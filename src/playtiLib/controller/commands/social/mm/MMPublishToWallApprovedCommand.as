package playtiLib.controller.commands.social.mm
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.social.SocialPostVO;
	/**
	 * Gets a SocialPostVO object and if it's is_gift property is true, it sends notification (PUBLISH_GIFT_COMPLETE) and if it 
	 * is false, it sends notification (PUBLISH_TO_WALL_COMPLETE)
	 */	
	public class MMPublishToWallApprovedCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var post_vo:SocialPostVO = notification.getBody() as SocialPostVO;
			if( post_vo && post_vo.is_gift ) {
				sendNotification( GeneralAppNotifications.PUBLISH_GIFT_COMPLETE, post_vo, post_vo.token );
			} else {
				sendNotification( GeneralAppNotifications.PUBLISH_TO_WALL_COMPLETE, true );
			}
		}
	}
}