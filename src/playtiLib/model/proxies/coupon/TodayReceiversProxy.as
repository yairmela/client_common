package playtiLib.model.proxies.coupon
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	/**
	 * Proxy that stores the today receiver after the call to server in GetTodayReceiversCommand. It adds receivers each time the client
	 * send coupons to his friends
	 */
	public class TodayReceiversProxy extends Proxy	{
		
		public static const NAME:String = "TodayReceiversProxy"; 
		
		public function TodayReceiversProxy( receivers:String ){
			
			super( NAME, '' );
			addRecievers( receivers );
			
		}
		
		public function get today_receivers():String{
			return getData() as String;
		}
		
		public function addRecievers( receivers:String ):void{
			data = ( today_receivers == null || today_receivers == "" ) ? receivers : today_receivers + "," + receivers;
			//send notificatoin that data is ready for scoreBoard 
			sendNotification( GeneralAppNotifications.TODAY_RECEIVERS_READY, today_receivers );
			//set the coupons sendGiftBack to false of the users that already sent today
			if(facade.hasProxy(UserCouponProxy.NAME)){
				(facade.retrieveProxy(UserCouponProxy.NAME) as UserCouponProxy).setCouponSendGiftBack(receivers);
			}
		}
	}
}