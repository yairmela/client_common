package playtiLib.controller.commands.coupons
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.VO.amf.response.CouponMessage;
	import playtiLib.model.VO.amf.response.CouponsListMessage;
	import playtiLib.model.VO.popup.PopupDoActionVO;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
 
	public class CollectSystemToUserCouponCommand extends CouponCommand	{
		//need to be override at game's class
		override public function execute ( notification:INotification ):void{
			
			var coupon_token:String = notification.getBody() as String;
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [AMFGeneralCallsConfig.ACCEPT_USER_COUPON.setRequestProperties( coupon_token ) ] );
			dataCapsule.addEventListener( Event.COMPLETE, onDataReady );
			dataCapsule.loadData();
		} 
		
		public function onDataReady( event:Event ):void{
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			var coupons_validation_list:ArrayCollection = ( dataCapsule.getDataHolderByIndex(0).data as CouponsListMessage ).coupon;
			
			var coupon_validation:Coupon;
			
			for( var i:int = 0 ; i < coupons_validation_list.length; i++ ) {
				coupon_validation = coupons_validation_list[i] as Coupon;
				
				if ( coupon_validation.isUserToUser ){
					continue;
				}
				switch( coupon_validation.errorCode ){
					case CouponSystemConfig.NO_ERROR_COUPON:
						handleValidCoupon( coupon_validation );
						break;
					case CouponSystemConfig.STATUS_COUPON_ALREADY_COLLECTED:
						sendNotification(GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.STATUS_COUPON_ALREADY_COLLECTED );
						break;
					
					default:
						if ( coupon_validation.errorCode != CouponSystemConfig.STATUS_SYSTEM_COPUON_CANT_COLLECT_TODAY )
							sendNotification( GeneralAppNotifications.OPEN_POPUP, 
												new PopupMediator( GeneralDialogsConfig.POPUP_GIFT_MISSED, new PopupViewLogic( GeneralDialogsConfig.POPUP_GIFT_MISSED ) ) );
				}	
			}		
		}
		
		public function handleValidCoupon( coupon_validation_data:Coupon ):void{
			
			var doAction:PopupDoActionVO;
			var closeAction:PopupDoActionVO;
			switch ( coupon_validation_data.giftTypeId ) {
				case CouponSystemConfig.GIFT_TYPE_COINS: //Money
					user_proxy.updateUser({balance:Number( coupon_validation_data.giftTypeValue )}, false );
					doAction = new PopupDoActionVO([GeneralAppNotifications.USER_DATA_READY],null,null,[true] );
					closeAction = new PopupDoActionVO([GeneralAppNotifications.USER_DATA_READY],null,null,[true] );
					sendNotification(
						GeneralAppNotifications.OPEN_POPUP,
						new PopupMediator( GeneralDialogsConfig.POPUP_GIFT_REDEEMED, 
							new PopupViewLogic(GeneralDialogsConfig.POPUP_GIFT_REDEEMED), 
							doAction, closeAction));
					break;
			}
		}
	}
}