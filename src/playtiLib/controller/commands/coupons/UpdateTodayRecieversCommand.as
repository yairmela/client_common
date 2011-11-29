package playtiLib.controller.commands.coupons
{
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.model.proxies.coupon.TodayReceiversProxy;
	/**
	 * Update the TodayReceiversProxy (by the notification's body)
	 */
	public class UpdateTodayRecieversCommand extends CouponCommand	{
		
		override public function execute( notification:INotification ):void{
			
			var receivers:String = notification.getBody() as String;
			
			if( facade.hasProxy( TodayReceiversProxy.NAME ) )
				receivers_proxy.addRecievers( receivers );
		}
	}
}