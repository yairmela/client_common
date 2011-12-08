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
			
			sendNotification( GeneralAppNotifications.FULLSCREEN_MODE,false );
		
			var callConfig:DataCallConfig = AMFGeneralCallsConfig.ACCEPT_SURPRISE_GIFT;
			var capsule:DataCapsule = DataCapsuleFactory.getDataCapsule([callConfig]);
			capsule.addEventListener( Event.COMPLETE, onGiftDataReady );
			capsule.loadData();
		}
		
		private function onGiftDataReady( event:Event ):void{			
			var giftDataHolder:Object = ( event.target as DataCapsule ).getDataHolderByIndex(0).data;
			if (giftDataHolder.hasOwnProperty('coupon')) {
				var coupon:Coupon = giftDataHolder.coupon as Coupon;
				var couponCreated:Boolean = coupon || coupon.couponId;
				ExternalInterface.call( 'setSurpiseGiftStatus', couponCreated);
			}

		}
		
	}

}