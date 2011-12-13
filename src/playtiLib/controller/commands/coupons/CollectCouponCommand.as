package playtiLib.controller.commands.coupons
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.VO.amf.response.ClientResponse;
	import playtiLib.model.VO.amf.response.CollectCouponMessage;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.VO.amf.response.CouponMessage;
	import playtiLib.model.proxies.coupon.SelectedCouponProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;

	/**
	 * Senda to server couponCollect with  coupon's properties . When the data is ready, it sends AFTER_COLLECT_COUPON_COMMAND
	 * notification and removes the app request, removes coupon from UserCouponProxy and send COUPON_COLLECT notification.
	 */	
	public class CollectCouponCommand extends CouponCommand{
		
		private var notification:INotification;
		
		override public function execute( notification:INotification ):void {
			
			this.notification = notification;
			var coupon:Coupon = ( facade.retrieveProxy( SelectedCouponProxy.NAME) as SelectedCouponProxy ).coupon;
			if( !coupon.isUserToUser ){
				sendNotification( GeneralAppNotifications.AFTER_COLLECT_COUPON_COMMAND );
				return;
			}
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [AMFGeneralCallsConfig.COLLECT_USER_COUPON.setRequestProperties( coupon )] );
			dataCapsule.addEventListener( Event.COMPLETE, onDataReady );
			dataCapsule.loadData();
		}
		
		private function onDataReady( event:Event ):void {
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			if ( CouponSystemConfig.isCouponSystemUnavailable( dataCapsule.getDataHolderByIndex(0).server_response.service.errorCode ) ){
				sendNotification( GeneralAppNotifications.COUPON_SYSTEM_UNAVIABLE );
				sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.COUPON_SYSTEM_UNAVIABLE );
				return;
			}	
			var couponMessage:CouponMessage = dataCapsule.getDataHolderByIndex(0).data as CouponMessage;
			var result:ClientResponse = dataCapsule.getDataHolderByIndex(0).server_response as ClientResponse;
			if ( result.service.errorCode != CouponSystemConfig.NO_ERROR_COUPON ){
				if( couponMessage && couponMessage.coupon ){
					couponMessage.coupon.errorCode =  result.service.errorCode;
					sendNotification( GeneralAppNotifications.CLEANUP_COUPONS_COMMAND, [couponMessage.coupon], GeneralAppNotifications.COLLECT_COUPON_COMMAND );
				}else{
					sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, result.service.errorCode );	
				}
			}else{ 
				sendNotification( GeneralAppNotifications.AFTER_COLLECT_COUPON_COMMAND, this.notification.getBody(), couponMessage.coupon.giftTypeValue );
				fb_request_proxy.removeCouponRequest( couponMessage.coupon.couponToken );
				coupon_proxy.removeCoupon( couponMessage.coupon.couponToken );
				sendNotification( GeneralAppNotifications.COUPON_COLLECTED, couponMessage.coupon ) ;
			}
		}
	}
}