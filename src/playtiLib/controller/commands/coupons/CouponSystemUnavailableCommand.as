package playtiLib.controller.commands.coupons
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.view.mediators.gift.GiftCollectionPopupMediator;
	
	public class CouponSystemUnavailableCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {

			facade.removeCommand(GeneralAppNotifications.COUPON_SYSTEM_UNAVAILABLE);
			
			if( facade.hasMediator( GiftCollectionPopupMediator.NAME ) ){
				facade.removeMediator( GiftCollectionPopupMediator.NAME );
			}
			
			sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.COUPON_SYSTEM_UNAVIABLE );
		}
	}
}