package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	/**
	 * Gets FB user id by the notification's body and makes a external interface call the to add FB request.
	 * @see flash.external.ExternalInterface
	 */	
	public class FBAddApprequestCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var fb_user_id:String 	= String( notification.getBody() );
			var message:String 		= 'message';
			var data:String;
			var title:String;
			ExternalInterface.call( 'addFBRequest', fb_user_id, message, data, title );
		}
	}
}