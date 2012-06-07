package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.model.vo.social.SocialActionPostData;
	
	public class FBPostActionCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void
		{
			var actionPostData : SocialActionPostData = notification.getBody() as SocialActionPostData;
			
			if(!actionPostData) {
				return;
			}
			
			if(!ExternalInterface.available) {
				return;
			}
			
			
			ExternalInterface.call("postOGAction", actionPostData);
		}
	}
}