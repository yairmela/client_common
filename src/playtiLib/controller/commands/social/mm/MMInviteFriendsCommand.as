package playtiLib.controller.commands.social.mm
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.social.mm.MailruCall;
	import playtiLib.utils.social.mm.MailruCallEvent;

	/**
	 * Adds listener (FRIENDS_INVITATION) and executes invite friends on MailreCall.
	 */	
	public class MMInviteFriendsCommand extends SimpleCommand{
		
		override public function execute( notification:INotification ):void {
			sendNotification(GeneralAppNotifications.FULLSCREEN_MODE,false);
			MailruCall.addEventListener( MailruCallEvent.FRIENDS_INVITATION, onInvite );
			MailruCall.exec( "mailru.app.friends.invite" );
		}
		/**
		 * Removes listener from MailruCall (FRIENDS_INVITATION) 
		 * @param response
		 * 
		 */		
		private function onInvite( response:Object ):void{
			
			MailruCall.removeEventListener( MailruCallEvent.FRIENDS_INVITATION, onInvite );
		}
	}
}