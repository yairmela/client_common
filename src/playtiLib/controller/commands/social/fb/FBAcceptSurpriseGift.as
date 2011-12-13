package playtiLib.controller.commands.social.fb 
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;

	public class FBAcceptSurpriseGift extends SimpleCommand 
	{
		
		override public function execute( notification:INotification ):void {			
		
			var callConfig:DataCallConfig = AMFGeneralCallsConfig.ACCEPT_SURPRISE_GIFT;
			var capsule:DataCapsule = DataCapsuleFactory.getDataCapsule([callConfig]);
			capsule.addEventListener( Event.COMPLETE, onGiftDataReady );
			capsule.loadData();
		}
		
		private function onGiftDataReady( event:Event ):void{			
			var giftDataHolder:Object = ( event.target as DataCapsule ).getDataHolderByIndex(0).data;
			if (giftDataHolder && giftDataHolder.hasOwnProperty('coupon')) {
				var coupon:Coupon = giftDataHolder.coupon as Coupon;
				if (coupon && coupon.couponToken) {
					sendNotification(GeneralAppNotifications.SYSTEM_TO_USER_COUPON_COLLECTION, coupon.couponToken);
				}
				
				ExternalInterface.call( 'setSurpiseGiftStatus', true);
			}else {
				ExternalInterface.call( 'setSurpiseGiftStatus', false);
			}

		}
		
	}

}