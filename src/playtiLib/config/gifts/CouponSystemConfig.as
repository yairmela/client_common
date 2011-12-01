package playtiLib.config.gifts
{
	/**
	 * This class configures the coupon system. 
	 * It contains a Configuration of server side erors, client side erors and accept coupon's type
	 * and accept coupon type.
	 */	
	public class CouponSystemConfig	{
		
		static public var coupon_system_enabled:Boolean = true;
		
		public static const STATUS_CUPON_SYSTEM_UNAVIABLE:int 				= 1200;
		public static const COUPON_UNKNOWN_ERROR:int						= 5000;
		public static const WARN_EVENT_IS_NOT_AVAILABLE:int					= 1201;
		//server side error cods
		public static const STATUS_MAX_COUNT_EXCEEDED:int 					= 1003;
		public static const STATUS_INVALID_COUPON_STATE:int 				= 1004;
		public static const STATUS_NONUNIQUE_COUPON_TOKEN:int 				= 1005;
		public static const STATUS_NO_ADMIN_USER_SPECIFIED_FOR_COUPON:int 	= 1006;
		public static const STATUS_COUPON_ALREADY_COLLECTED:int 			= 1007;
		public static const STATUS_COULD_NOT_SEND_COUPON:int 				= 1008;
		public static const STATUS_ALREADY_COLLECTED_COUPON_FROM_USER:int 	= 1009;
		public static const STATUS_SYSTEM_COPUON_CANT_COLLECT_TODAY:int 	= 1009;
		public static const STATUS_UNKNOWN_ERROR:int 						= 1000;
		public static const STATUS_UNKNOWN_COUPON:int 						= 1001;
		public static const STATUS_REMOVED_COUPON:int						= 1002;
		public static const STATUS_COUPON_SENT_BY_MYSELF:int 				= 1010;
		//cliet side error cods
		public static const STATUS_COUPON_CANT_BE_COLLECTED:int 			= 10000;
		public static const STATUS_INACCEPTABLE_COUPON:int 					= 10001;
		public static const STATUS_SOME_COUPONS_CANT_BE_COLLECTED:int 		= 10002;
		public static const STATUS_SOME_COUPONS_ALREADY_COLLECTED:int 		= 10003;
		public static const COUPON_SYSTEM_UNAVIABLE:int 					= 10004;

		public static const EVENT_COINS_GIFT:int 							= 5;//'coins';
		public static const EVENT_COINS_RE_GIFT:int 						= 6;//'coins_recip';
		public static const GIFT_TYPE_COINS:int 							= 1;
		public static const NO_ERROR_COUPON:int 							= 0;
		//gcp
		public static const SEND_BACK_BTN:String							= 'send_back_btn';
		public static const COLLECT_COUPON_BTN:String						= 'collect_coupon_btn';
		public static const REMOVE_COUPON_BTN:String						= 'remove_coupon_btn';
		public static const SEND_COUPON_BTN:String							= 'send_coupon_btn';
		
		public static function isCouponSystemUnavailable( responseError:int ):Boolean{
			
			if( responseError == COUPON_UNKNOWN_ERROR || 
				responseError == STATUS_CUPON_SYSTEM_UNAVIABLE || 
				responseError == WARN_EVENT_IS_NOT_AVAILABLE ||
				responseError == COUPON_SYSTEM_UNAVIABLE ){
				return true;
			}
			return false;
		}
	}
}
