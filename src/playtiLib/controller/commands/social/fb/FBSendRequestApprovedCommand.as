package playtiLib.controller.commands.social.fb
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	//TODO: check this class
	public class FBSendRequestApprovedCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var response:Object = notification.getBody();
			trace( response );
		}
	}
}