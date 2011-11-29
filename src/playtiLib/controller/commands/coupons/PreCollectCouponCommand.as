package playtiLib.controller.commands.coupons
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.proxies.coupon.SelectedCouponProxy;

	//this class should be overrided at the game's core commands
	/**
	 * Command that called after the user press the collect btn on GCP. It can be extended on the game's commands. The class handles the
	 * pre collect functionality.
	 */	
	public class PreCollectCouponCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void{
			//store the coupon in the selectedCouponProxy
			if( !facade.hasProxy( SelectedCouponProxy.NAME ) ){
				facade.registerProxy( new SelectedCouponProxy( notification.getBody() as Coupon ) ) 
			}else{
				( facade.retrieveProxy( SelectedCouponProxy.NAME ) as SelectedCouponProxy ).coupon = notification.getBody() as Coupon;
			}
			
			switch( ( notification.getBody() as Coupon ).giftTypeId ){
				case CouponSystemConfig.MONEY_GIFT_TYPE:
					sendNotification( GeneralAppNotifications.COLLECT_COUPON_COMMAND );
					break;
			}
		}
	}
}