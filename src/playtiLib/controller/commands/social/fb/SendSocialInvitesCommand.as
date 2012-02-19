package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	
	public class SendSocialInvitesCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var selectedFriendsIds:String = notification.getBody() as String;
			sendNotification(GeneralAppNotifications.FULLSCREEN_MODE , false);
			ExternalInterface.call( 'FBInviteRequest', selectedFriendsIds  );
		}
	}
}