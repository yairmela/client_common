package playtiLib.controller.commands.coupons
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.VO.amf.response.CouponMessage;
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;

	/**
	 * Class that create coupon event (user to anninomus user)
	 */	
	public class CreateEventCouponCommand extends SimpleCommand	{
			
		private var postVo:SocialPostVO;
		
		override public function execute( notification:INotification ):void {
			
			if( notification.getBody() as SocialPostVO ){
				postVo = notification.getBody() as SocialPostVO;	
			}else if( notification.getBody() as int ){
				postVo = new SocialPostVO();
				postVo.event_type = notification.getBody() as int;
			}
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [AMFGeneralCallsConfig.CREATE_SYSTEM_TO_USER_COUPON.setRequestProperties( {eventType:postVo.event_type} ) ] );
			dataCapsule.addEventListener( Event.COMPLETE, onCreateCouponComplete );
			dataCapsule.loadData();
		}
		
		private function onCreateCouponComplete( event:Event ):void {

			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			var coupon:Coupon;
			if( CouponSystemConfig.isCouponSystemUnavailable( dataCapsule.getDataHolderByIndex(0).server_response.service.errorCode ) ) {
//				sendNotification( GeneralAppNotifications.COUPON_SYSTEM_UNAVIABLE );
//				return;
				
			}else if( ( dataCapsule.getDataHolderByIndex(0).data as CouponMessage ) != null ){
				coupon = ( dataCapsule.getDataHolderByIndex(0).data as CouponMessage ).coupon;
				coupon.message = ( dataCapsule.getDataHolderByIndex(0).data as CouponMessage ).couponMessage;
			}
			postVo.coupon = coupon;
			sendNotification( GeneralAppNotifications.SHARE_EVENT_COUPON_COMMAND, postVo );
		}
	}
}