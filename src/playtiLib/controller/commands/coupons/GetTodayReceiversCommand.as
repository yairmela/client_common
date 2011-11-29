package playtiLib.controller.commands.coupons
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.VO.amf.response.CouponReceiversMessage;
	import playtiLib.model.proxies.coupon.TodayReceiversProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	/**
	 * Gets the today receivers from server and stores it in TodayReceiversProxy.
	 */	
	public class GetTodayReceiversCommand extends CouponCommand	{
		
		override public function execute( notification:INotification ):void{
			
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [AMFGeneralCallsConfig.TODAY_RECEIVERS] );
			dataCapsule.addEventListener( Event.COMPLETE, onDataReady );
			dataCapsule.loadData();
		}
		
		private function onDataReady( event:Event ):void {
			
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			var receiversMessage:CouponReceiversMessage = data_capsule.getDataHolderByIndex(0).data as CouponReceiversMessage;
			var recrivers:String = receiversMessage.receivers;
			//init the todayReceivers proxy
			facade.registerProxy( new TodayReceiversProxy( recrivers ) );
		}
	}
}