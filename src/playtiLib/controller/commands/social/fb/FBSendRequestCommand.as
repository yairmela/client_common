package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.controller.commands.coupons.CouponCommand;
	import playtiLib.model.vo.social.SocialPostVO;
	import playtiLib.model.proxies.config.DisplaySettingsProxy;

	/**
	 * Gets a SocialPostVO object by the notificatio's body, sets the fullscreen setting to be false, makes an external interface call
	 * for sending gift with the object's infotmation (title, description, gift type, user id) and sends notification SET_PAUSE_POPUP.
	 * @see flash.external.ExternalInterface
	 * @see playtiLib.model.vo.social.SocialPostVO
	 * @see playtiLib.model.proxies.config.DisplaySettingsProxy
	 */
	public class FBSendRequestCommand extends CouponCommand	{
		 
		override public function execute( notification:INotification ):void {
			
			var postVO:SocialPostVO;
			postVO = notification.getBody() as SocialPostVO;
			//add today receivers to the postVO object
			postVO.today_receivers_ids = receivers_proxy.today_receivers;
			
			ExternalInterface.call( 'sendCoupon', postVO );
		}
	}
}