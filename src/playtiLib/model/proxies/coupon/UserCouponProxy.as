package playtiLib.model.proxies.coupon
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.amf.response.Coupon;
	/**
	 * Proxy that used to store the user's coupons information.It can add\remove coupons to the list and set the coupon's 'isSendGiftBack' property
	 */	
	public class UserCouponProxy extends Proxy	{
		
		public static const NAME:String = "UserCouponProxy"; 
		
		public function UserCouponProxy( all_coupons:Array ){
			
			super( NAME, all_coupons );
			if( facade.hasProxy( TodayReceiversProxy.NAME ) ){
				setCouponSendGiftBack( ( facade.retrieveProxy( TodayReceiversProxy.NAME) as TodayReceiversProxy ).today_receivers );
			}
		}
		
		public function get coupons():Array{
			return getData() as Array;
		}
		//get an array of all the coupon_tokens
		public function get tokens():Array{
			return coupons.map( function(item:Coupon, ...args):String { return item.couponToken } );
		}
		
		public function addCoupons( list:Array ):void {
			if( list.length > 0 ){
				//first make sure you dont have duplicated tokens
				list = list.filter(
					function( element:Coupon, ...args ):Boolean{
						//return true for coupon that its token doesn't appear in the current tokens
						return tokens.indexOf( element.couponToken ) < 0;
					});
				data = list.concat( coupons );
			}
			sendNotification( GeneralAppNotifications.USER_COUPON_DATA_READY, coupons.length );
		}
		
		public function setCouponSendGiftBack( receivers:String ):void{
			if( receivers && receivers != ""){
				for each( var coupon:Coupon in coupons ){
					if( receivers.indexOf( coupon.senderSnId ) != -1 ){
						coupon.isGiftBackAllowed = 0;
					}
				}
			}
		}
		
		public function removeCoupon( couponToken:String ):void {
			
			data = coupons.filter( 
				function( coupon:Coupon, ...args ):Boolean{
					return coupon.couponToken != couponToken;
				});
			
			sendNotification( GeneralAppNotifications.USER_COUPON_DATA_READY, coupons.length, GeneralAppNotifications.COUPON_REMOVED );
		}
	}
}