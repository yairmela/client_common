package playtiLib.controller.commands.coupons
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.vo.amf.response.CouponReceiversMessage;
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
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			dataCapsule.removeEventListener( Event.COMPLETE, onDataReady );
			var receiversMessage:CouponReceiversMessage = dataCapsule.getDataHolderByIndex(0).data as CouponReceiversMessage;
			if (receiversMessage){
				var recrivers:String = receiversMessage.receivers;
				//init the todayReceivers proxy
				facade.registerProxy( new TodayReceiversProxy( recrivers ) );
			}
		}
	}
}