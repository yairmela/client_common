package playtiLib.controller.commands.social.fb 
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.vo.amf.response.Coupon;
	import playtiLib.model.vo.amf.response.CouponMessage;
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;

	public class FBAcceptSurpriseGift extends SimpleCommand  {
		
		private var gift_redeemed:Boolean;
		
		override public function execute( notification:INotification ):void {			
			
			gift_redeemed = notification.getBody() as Boolean;
			if( gift_redeemed ){
				sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.STATUS_COUPON_ALREADY_COLLECTED );
				ExternalInterface.call( 'setSurpiseGiftStatus');
				return;
			}
			var callConfig:DataCallConfig = AMFGeneralCallsConfig.ACCEPT_SURPRISE_GIFT;
			var capsule:DataCapsule = DataCapsuleFactory.getDataCapsule([callConfig]);
			capsule.addEventListener( Event.COMPLETE, onGiftDataReady );
			capsule.loadData();
		}
		
		private function onGiftDataReady( event:Event ):void{	
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			dataCapsule.removeEventListener( Event.COMPLETE, onGiftDataReady );
			var couponMessage:CouponMessage = dataCapsule.getDataHolderByIndex(0).data as CouponMessage;
			if (couponMessage && couponMessage.coupon ) {
				var coupon:Coupon = couponMessage.coupon ;
				if ( coupon.couponToken ) {
					sendNotification(GeneralAppNotifications.SYSTEM_TO_USER_COUPON_COLLECTION, coupon.couponToken, 'from_engagement_bar' );
				}
			}else {
				sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.STATUS_COUPON_ALREADY_COLLECTED );
			}
				ExternalInterface.call( 'setSurpiseGiftStatus');
		}
	}
}