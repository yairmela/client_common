package playtiLib.controller.commands.coupons
{
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.proxies.coupon.SelectedCouponProxy;

	//this class need to be override at the game core commands
	/**
	 * Called after the collectCouponCommand. It can be extended at the game's commands and can handle more types of coupons 
	 */	
	public class AfterCollectCouponCommand extends CouponCommand{
		
		override public function execute( notification:INotification ):void{
			
			var giftTypeValue:String = notification.getType();
			var coupon:Coupon = ( facade.retrieveProxy( SelectedCouponProxy.NAME ) as SelectedCouponProxy ).coupon;
			
			switch ( coupon.giftTypeId ){
				case CouponSystemConfig.GIFT_TYPE_COINS:
					user_proxy.user_status.balanceInCoins += Number( giftTypeValue ) ;
					user_proxy.updateUser( user_proxy.user_status );
					break;
			}
			
			sendNotification(GeneralAppNotifications.TRACK, null, GeneralStatistics.COLLECT_GIFT);			
		}		
	}
}