package playtiLib.controller.commands.coupons
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.vo.amf.request.CouponRequest;
	import playtiLib.model.vo.amf.response.Coupon;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;

	/**
	 * Gets coupon via notification' body. Sends rejectCoupon call config, remove the app request and from the coupon list at the UserCouponProxy.
	 * Sends notification COUPON_REMOVED; 
	 */	
	public class RejectCouponCommand extends CouponCommand	{
		
		private var coupon:Coupon;
		
		override public function execute( notification:INotification ):void {
			
			coupon = notification.getBody() as Coupon;
			
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [AMFGeneralCallsConfig.REJECT_USER_COUPON.setRequestProperties( coupon ) ] );
			dataCapsule.addEventListener( Event.COMPLETE, onDataReady);
			dataCapsule.loadData();
		}
		
		private function onDataReady( event:Event ):void {
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			dataCapsule.removeEventListener( Event.COMPLETE, onDataReady );
			if ( CouponSystemConfig.isCouponSystemUnavailable( dataCapsule.getDataHolderByIndex(0).server_response.service.errorCode ) ){
				sendNotification( GeneralAppNotifications.COUPON_SYSTEM_UNAVAILABLE );
				return;
			}	
			fb_request_proxy.removeCouponRequest( coupon.couponToken );
			coupon_proxy.removeCoupon( coupon.couponToken );
			sendNotification( GeneralAppNotifications.COUPON_REMOVED, coupon );
		}
	}
}