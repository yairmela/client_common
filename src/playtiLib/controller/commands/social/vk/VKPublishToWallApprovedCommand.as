package playtiLib.controller.commands.social.vk
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.social.SocialPostVO;
	
	public class VKPublishToWallApprovedCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var post_vo:SocialPostVO = notification.getBody() as SocialPostVO;
			if(post_vo && post_vo.is_gift) {
				sendNotification( GeneralAppNotifications.PUBLISH_GIFT_COMPLETE, post_vo, notification.getType() );
			} else {
				sendNotification( GeneralAppNotifications.PUBLISH_TO_WALL_COMPLETE, true );
			}
		}
	}
}