package playtiLib.controller.commands.coupons
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.proxies.coupon.TodayReceiversProxy;
	import playtiLib.model.proxies.coupon.UserCouponProxy;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.model.proxies.social.FBRequestsProxy;
	import playtiLib.model.proxies.user.UserProxy;
	/**
	 * Class that has some getter function that helps some other commands that use it.
	 */	
	public class CouponCommand extends SimpleCommand {
		
		public function CouponCommand()	{
			super();
		}
		public function get coupon_proxy():UserCouponProxy{
			return facade.retrieveProxy( UserCouponProxy.NAME ) as UserCouponProxy;
		}
		public function get flash_vars_proxy():FlashVarsProxy {
			return facade.retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy;
		}
		public function get flashVars():FlashVarsVO {
			return flash_vars_proxy.flash_vars;
		}
		public function get user_proxy():UserProxy {
			return facade.retrieveProxy( UserProxy.NAME ) as UserProxy;
		}
		public function get fb_request_proxy():FBRequestsProxy{
			return facade.retrieveProxy( FBRequestsProxy.NAME ) as FBRequestsProxy;
		}
		public function get receivers_proxy():TodayReceiversProxy{
			return facade.retrieveProxy( TodayReceiversProxy.NAME ) as TodayReceiversProxy;
		}
	}
}