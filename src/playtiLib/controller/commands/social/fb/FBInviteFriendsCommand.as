package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;

	/**
	 * makes an external_interface call (showInviteFriends)
	 * @see flash.external.ExternalInterface
	 */	
	public class FBInviteFriendsCommand extends SimpleCommand {
		
		override public function execute( notification:INotification ):void {
			sendNotification(GeneralAppNotifications.FULLSCREEN_MODE,false);
			ExternalInterface.call( 'showInviteFriends', false );
		}
	}
}