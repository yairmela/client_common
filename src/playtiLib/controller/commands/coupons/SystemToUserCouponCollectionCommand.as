package playtiLib.controller.commands.coupons
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.vo.amf.response.Coupon;
	import playtiLib.model.vo.amf.response.CouponMessage;
	import playtiLib.model.vo.popup.PopupDoActionVO;
	import playtiLib.model.proxies.coupon.SelectedCouponProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;

	public class SystemToUserCouponCollectionCommand extends CouponCommand{
		private var is_from_engagement_bar:Boolean;
		
		override public function execute ( notification:INotification ):void {
			//check if the coupon_token is provided by notification
			var coupon_token:String = notification.getBody() != null ? notification.getBody() as String : null;
			is_from_engagement_bar = notification.getType() == 'from_engagement_bar';
			//check if the coupon_token is provided by flash_vars
			if ( flash_vars_proxy.flash_vars.coupon_token != null && flash_vars_proxy.flash_vars.coupon_token != "" && flash_vars_proxy.flash_vars.coupon_token != "null" ){
				coupon_token = flash_vars_proxy.flash_vars.coupon_token;  
				flash_vars_proxy.flash_vars.coupon_token = null;  
			} 
			if (coupon_token == null) 
				return;
			//call collect coupon
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule([AMFGeneralCallsConfig.COLLECT_USER_COUPON.setRequestProperties({couponToken:coupon_token})]);
			dataCapsule.addEventListener( Event.COMPLETE, onDataReady);
			dataCapsule.loadData();
		} 
		
		private function onDataReady(event:Event):void{
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			dataCapsule.removeEventListener( Event.COMPLETE, onDataReady );
			if ( CouponSystemConfig.isCouponSystemUnavailable ( dataCapsule.getDataHolderByIndex(0).server_response.service.errorCode) ){
				sendNotification( GeneralAppNotifications.COUPON_SYSTEM_UNAVIABLE );
				sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.COUPON_SYSTEM_UNAVIABLE );
				return;
			}	
			var couponMessage:CouponMessage = dataCapsule.getDataHolderByIndex(0).data as CouponMessage;
			var errorCode:int = ( couponMessage == null || couponMessage.coupon == null ) ? dataCapsule.getDataHolderByIndex(0).server_response.service.errorCode : couponMessage.coupon.errorCode;
			//handles response from server by different error codes
			switch( errorCode ){
				case CouponSystemConfig.NO_ERROR_COUPON:
					//move the switching between coupon's types to OpenSystemToUserPopupCommand
					if( !facade.hasProxy( SelectedCouponProxy.NAME ) ){
						facade.registerProxy( new SelectedCouponProxy( couponMessage.coupon ) ) 
					}else{
						( facade.retrieveProxy( SelectedCouponProxy.NAME ) as SelectedCouponProxy ).coupon = couponMessage.coupon;
					}
					sendNotification( GeneralAppNotifications.OPEN_SYSTEM_TO_USER_POPUP, couponMessage, is_from_engagement_bar.toString() );
					break;
				case CouponSystemConfig.STATUS_COUPON_ALREADY_COLLECTED:
					sendNotification(GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.STATUS_COUPON_ALREADY_COLLECTED);
					break;
				
				case CouponSystemConfig.STATUS_UNKNOWN_ERROR:
				case CouponSystemConfig.STATUS_UNKNOWN_COUPON:
				case CouponSystemConfig.STATUS_INVALID_COUPON_STATE:
				case CouponSystemConfig.STATUS_REMOVED_COUPON:
				case CouponSystemConfig.STATUS_MAX_COUNT_EXCEEDED:
				case CouponSystemConfig.STATUS_COUPON_SENT_BY_MYSELF:
				case CouponSystemConfig.COUPON_IS_NOT_AVAILABLE_NOW:
				case CouponSystemConfig.STATUS_SYSTEM_COPUON_CANT_COLLECT_TODAY:
					sendNotification(GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.STATUS_UNKNOWN_ERROR);
					break;
				case CouponSystemConfig.COUPON_SYSTEM_UNAVIABLE:
					sendNotification(GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.COUPON_SYSTEM_UNAVIABLE);
					break;
				default:
					sendNotification( GeneralAppNotifications.OPEN_POPUP, 
						new PopupMediator( GeneralDialogsConfig.POPUP_GIFT_MISSED, new PopupViewLogic( GeneralDialogsConfig.POPUP_GIFT_MISSED ) ) );
			}
		}
	}
}