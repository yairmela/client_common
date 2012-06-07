package playtiLib.controller.commands.social
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.GeneralSocialActionPostConfig;
	import playtiLib.model.vo.social.SocialActionPostData;
	
	public class SocialActionCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {

			var actionPostData : SocialActionPostData = getSocialActionPostData( notification.getType(), notification.getBody() )
			
			sendNotification(GeneralAppNotifications.POST_SOCIAL_ACTION, actionPostData);
		}
		
		protected function getSocialActionPostData( actionType : String, actionData : Object ) : SocialActionPostData {
			
			var actionPostData : SocialActionPostData = new SocialActionPostData();
			
			switch( actionType ) {				
				case GeneralSocialActionPostConfig.GIFT_SENT:
					actionPostData.og_action = "grant";
					actionPostData.og_object = "gift";
					actionPostData.sent_gifts_number  = 1;
					break;
				
				default:
					return null;
			}
			
			return actionPostData;
		}
	}
}