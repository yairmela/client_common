package playtiLib.controller.commands.coupons
{
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.amf.response.CouponMessage;
	import playtiLib.model.VO.popup.PopupDoActionVO;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	/**
	 * Opens the popup that represent the system to user coupon (should be extended in the game's classes)
	 */
	public class OpenSystemToUserPopupCommand extends CouponCommand{
		
		override public function execute ( notification:INotification ):void {
			
			var couponMessage:CouponMessage = notification.getBody() as CouponMessage;
			var doAction:PopupDoActionVO;
			var closeAction:PopupDoActionVO;
			switch( couponMessage.coupon.giftTypeId ){
				case CouponSystemConfig.GIFT_TYPE_COINS:
					user_proxy.user_status.balanceInCoins += Number( couponMessage.coupon.giftTypeValue ) ;
					doAction = new PopupDoActionVO([GeneralAppNotifications.USER_DATA_READY],null,null,[true]);
					closeAction = doAction;
					break;
			}
			sendNotification(GeneralAppNotifications.OPEN_POPUP,
				new PopupMediator( GeneralDialogsConfig.POPUP_GIFT_REDEEMED, 
					new PopupViewLogic(GeneralDialogsConfig.POPUP_GIFT_REDEEMED), 
					doAction, closeAction));
		}
		
	}
}