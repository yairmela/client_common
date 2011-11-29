package playtiLib.controller.commands.coupons
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.VO.amf.request.CouponRequest;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.VO.amf.response.CouponMessage;
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.model.proxies.coupon.TodayReceiversProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.social.SocialCallManager;

	/**
	 * Called after the coupon was created, user chooses some recievers and FB sends to those recievers the app requests.
	 * It sends to server the coupons id and the recievers id and the server adds them to the db.
	 */	
	public class SendCouponCommand extends CouponCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var sendDataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule( 
						[AMFGeneralCallsConfig.SEND_USER_TO_USER_COUPON.setRequestProperties( notification.getBody().coupon, {friendsIds : notification.getType()} )] );
			sendDataCapsule.addEventListener( Event.COMPLETE, onDataReady );
			sendDataCapsule.loadData();
		}
		
		private function onDataReady( event:Event ):void{
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			if( CouponSystemConfig.isCouponSystemUnavailable( dataCapsule.getDataHolderByIndex(0).server_response.service.errorCode ) ){
				sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.STATUS_CUPON_SYSTEM_UNAVIABLE );
				sendNotification( GeneralAppNotifications.COUPON_SYSTEM_UNAVIABLE );
				return;
			}
			sendNotification( GeneralAppNotifications.COUPON_SEND_COMPLETE )
		}
	}
}