package playtiLib.config.server
{
	import playtiLib.model.vo.amf.request.BuyCoinsRequest;
	import playtiLib.model.vo.amf.request.ClientRequest;
	import playtiLib.model.vo.amf.request.CouponRequest;
	import playtiLib.model.vo.amf.request.CreateEventCouponRequest;
	import playtiLib.model.vo.amf.request.LocalizationRequest;
	import playtiLib.model.vo.amf.request.LoginRequest;
	import playtiLib.model.vo.amf.request.RegisterRequest;
	import playtiLib.model.vo.amf.request.TransactionStatusRequest;
	import playtiLib.model.vo.amf.request.UpdateClientTaskRequest;
	import playtiLib.model.vo.amf.request.UpdateRegistrationInfoRequest;
	import playtiLib.model.vo.amf.request.UpdateUserInfoRequest;
	import playtiLib.model.vo.amf.social.user.StipulatedConverToStringCallConfigVO;
	import playtiLib.utils.data.ContentDataCallConfig;
	import playtiLib.utils.data.DataCallConfig;

	public class AMFGeneralCallsConfig	{
		
		private static const LOBBY_SERVICE:String 						= 'lobbyService';
		private static const LOCALIZATION_SERVICE:String 				= 'localizationService';
		private static const PAYMENT_SERVICE:String 					= 'paymentService';
		
		private static const LOGIN_COMMAND:String 						= 'login';
		private static const REGISTER_COMMAND:String 					= 'register';
		private static const UPDATE_USER_INFO_COMMAND:String 			= 'updateUserInfo';
		private static const GET_USER_INFO_COMMAND:String 				= 'getUserInfo';
		private static const UPDATE_REGISTRATION_INFO_COMMAND:String 	= 'updateUserRegistrationInfo';
		
		private static const GET_LOCALIZATION_COMMAND:String 			= 'getLocalization';
		private static const GET_CLIENT_TASKS_COMMAND:String 			= 'getClientTasks';
		//coupons
		private static const REJECT_COUPON:String 						= 'rejectCoupon';
		private static const COLLECT_COUPON:String 						= 'collectCoupon';
		private static const CREATE_COUPON:String 						= 'createCoupon';
		private static const CREATE_EVENT_COUPON:String 				= 'createEventCoupon';
		private static const SEND_COUPON:String 						= 'sendCoupon';
		private static const GET_VALIDATE_COUPONS:String 				= 'getValidateUserCoupons';
		private static const ACCEPT_SURPRISE_GIFT_COMMAND:String 		= 'activateEngagementGift';
		
		private static const GET_TODAY_RECEIVERS:String 				= 'getTodayRecievers';
		private static const UPDATE_CLIENT_TASK_STATUS_COMMAND:String 	= 'updateClientTaskStatus';
		
		//payments
		private static const BUY_COINS_COMMAND:String 					= 'buyCoins';
		private static const GET_CURRENCY_COSTS_COMMAND:String 			= 'getCurrencyCosts';
		private static const GET_TRANSACTION_STATUS_COMMAND:String 		= 'getTransactionStatus';		
		
		public static const LOGIN:DataCallConfig 						= new DataCallConfig( LOBBY_SERVICE, LOGIN_COMMAND, false, new LoginRequest() );
		public static const REGISTER_NEW_USER:DataCallConfig 			= new DataCallConfig( LOBBY_SERVICE, REGISTER_COMMAND, false, new RegisterRequest() );
		public static const UPDATE_USER_INFO:DataCallConfig 			= new DataCallConfig( LOBBY_SERVICE, UPDATE_USER_INFO_COMMAND, false, new UpdateUserInfoRequest() );
		public static const USER_INFO:DataCallConfig 					= new DataCallConfig( LOBBY_SERVICE, GET_USER_INFO_COMMAND );
		public static const UPDATE_REGISTRATION_INFO:DataCallConfig 	= new DataCallConfig( LOBBY_SERVICE, UPDATE_REGISTRATION_INFO_COMMAND, false, new UpdateRegistrationInfoRequest() );
		//coupons
		public static const REJECT_USER_COUPON:DataCallConfig 			= new DataCallConfig( LOBBY_SERVICE, REJECT_COUPON, false, new CouponRequest );
		public static const COLLECT_USER_COUPON:DataCallConfig 			= new DataCallConfig( LOBBY_SERVICE, COLLECT_COUPON, false, new CouponRequest );
		public static const CREATE_USER_COUPON:DataCallConfig 			= new DataCallConfig( LOBBY_SERVICE, CREATE_COUPON, false, new CouponRequest );
		public static const CREATE_SYSTEM_TO_USER_COUPON:DataCallConfig = new DataCallConfig( LOBBY_SERVICE, CREATE_EVENT_COUPON, false, new CreateEventCouponRequest );
		public static const SEND_USER_TO_USER_COUPON:DataCallConfig 	= new DataCallConfig( LOBBY_SERVICE, SEND_COUPON, false, new CouponRequest );
		public static const GET_AND_VALIDATE_COUPONS:DataCallConfig 	= new DataCallConfig( LOBBY_SERVICE, GET_VALIDATE_COUPONS, false, new CouponRequest );				
		public static const ACCEPT_SURPRISE_GIFT:DataCallConfig 		= new DataCallConfig( LOBBY_SERVICE, ACCEPT_SURPRISE_GIFT_COMMAND );
		
		public static const TODAY_RECEIVERS:DataCallConfig 				= new DataCallConfig( LOBBY_SERVICE, GET_TODAY_RECEIVERS, false, new ClientRequest );
		public static const LOCALIZATION:ContentDataCallConfig 			= new ContentDataCallConfig( LOCALIZATION_SERVICE, GET_LOCALIZATION_COMMAND ,false, new LocalizationRequest());
		//tasks
		public static const GET_CLIENT_TASKS:DataCallConfig 			= new DataCallConfig(LOBBY_SERVICE, GET_CLIENT_TASKS_COMMAND);
		public static const UPDATE_CLIENT_TASK_STATUS:DataCallConfig 	= new DataCallConfig(LOBBY_SERVICE, UPDATE_CLIENT_TASK_STATUS_COMMAND, false, new UpdateClientTaskRequest());
		
		//payments
		public static const BUY_COINS:DataCallConfig 					= new DataCallConfig( PAYMENT_SERVICE, BUY_COINS_COMMAND, false, new BuyCoinsRequest() );	
		public static const GET_CURRENCY_COSTS:DataCallConfig 			= new DataCallConfig( PAYMENT_SERVICE, GET_CURRENCY_COSTS_COMMAND );
		public static const GET_TRANSACTION_STATUS:DataCallConfig 		= new DataCallConfig( PAYMENT_SERVICE, GET_TRANSACTION_STATUS_COMMAND, false, new TransactionStatusRequest() );
		
		public static function getConfigByCommandName(cmd_name:String):DataCallConfig {
			switch (cmd_name) {
				case BUY_COINS_COMMAND:
					return BUY_COINS;
				case UPDATE_REGISTRATION_INFO_COMMAND:
					return UPDATE_REGISTRATION_INFO;
				default:
					return null;
			}
		}
	}
}