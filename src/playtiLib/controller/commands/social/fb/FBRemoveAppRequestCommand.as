package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.controller.commands.coupons.CouponCommand;

	/**
	 * Gets a request id and makes an external interface call to delete the FB request with the request id.
	 * @see flash.external.ExternalInterface
	 */	
	public class FBRemoveAppRequestCommand extends CouponCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var badRequests:Array = notification.getBody() as Array;
			for each( var request:String in badRequests ){
				ExternalInterface.call( 'deleteFBRequest', request );
			}
		}
	}
}