package playtiLib.controller.commands.coupons {
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.vo.amf.request.CouponRequest;
	import playtiLib.model.vo.amf.response.CouponMessage;
	import playtiLib.model.vo.social.SocialPostVO;
	import playtiLib.model.proxies.config.DisplaySettingsProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;

	/**
	 * Creates a coupon (by sending createCoupon to server by choosing giftTypeId).
	 * When the response is back, it sends an externalInterface call to javascript(sendCoupon) for showing the Facebook dialog and
	 * to continue the send gift flow.
	 */
	public class CreateCouponCommand extends CouponCommand {
		
		private var postVo:SocialPostVO;
		
		override public function execute( notification:INotification ):void {
		
			var couponRequest:CouponRequest = new CouponRequest();
			postVo = notification.getBody() as SocialPostVO;
			couponRequest.couponTypeId = postVo.gift_type;
		
			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP, true );
			
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule([AMFGeneralCallsConfig.CREATE_USER_COUPON.setRequestProperties(couponRequest)]);
			dataCapsule.addEventListener(Event.COMPLETE, onDataReady);
			dataCapsule.loadData();
		}
		
		private function onDataReady(event:Event):void {
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			dataCapsule.removeEventListener( Event.COMPLETE, onDataReady );
			if( CouponSystemConfig.isCouponSystemUnavailable( dataCapsule.getDataHolderByIndex(0).server_response.service.errorCode ) ){
				sendNotification( GeneralAppNotifications.COUPON_SYSTEM_UNAVAILABLE );
				sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP, false );
				return;
			}
			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP, false );
			postVo.coupon =  ( dataCapsule.getDataHolderByIndex(0).data as CouponMessage ).coupon;
			//add today receivers to the postVO object
			postVo.today_receivers_ids = receivers_proxy.today_receivers;
			ExternalInterface.call( 'sendCoupon', postVo );
			
			( facade.retrieveProxy( DisplaySettingsProxy.NAME ) as DisplaySettingsProxy ).fullscreen = false;
		}
	}
}