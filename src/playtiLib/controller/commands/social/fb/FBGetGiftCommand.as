package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	/**
	 * Gets request id by the notification body and makes an external interface call to get FB request data with this id.
	 * @see flash.external.ExternalInterface
	 */
	public class FBGetGiftCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {

			var request_id:String = notification.getBody().toString();
			ExternalInterface.call( 'getFBRequestData', request_id );
		}
	}
}