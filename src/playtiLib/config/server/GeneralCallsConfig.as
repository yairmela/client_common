package playtiLib.config.server
{
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.vo.user.LoginVO;
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.model.vo.user.UserUpdateInfo;
	import playtiLib.utils.data.DataCallConfig;

	/**
	 * This class configures the communication with the server by making DataCallConfig objects. 
	 */
	// TODO: the class needs to be cleaned out from every call that moved to AMF implementation
	public class GeneralCallsConfig	{
		
		private static const LOGIN_COMMAND:String = 'LOGIN';
//		private static const UPDATE_REGISTRATION_INFO_COMMAND:String = 'UPDATE_REGISTRATION_INFO';
		private static const GET_USER_INFO_COMMAND:String = 'GET_USER_INFO';
		private static const PREPARE_GIFT_COMMAND:String = 'PREPARE_GIFT';
		
//		private static const POST_LOGIN:DataCallConfig = new DataCallConfig( ServerModulesConfig.LOGIN, 'POST_LOGIN');
		private static const USER_LOGIN:DataCallConfig = new DataCallConfig( ServerModulesConfig.LOGIN, LOGIN_COMMAND, false, null, LoginVO );
//		private static const REGISTER_NEW_USER:DataCallConfig = new DataCallConfig( ServerModulesConfig.LOGIN, 'REGISTER', false, null, UserSocialInfo );
//		private static const UPDATE_USER_INFO:DataCallConfig = new DataCallConfig( ServerModulesConfig.COMMON, UPDATE_REGISTRATION_INFO_COMMAND, false, new UserUpdateInfo() );
		public static const GET_USER_INFO:DataCallConfig = new DataCallConfig( ServerModulesConfig.COMMON, GET_USER_INFO_COMMAND, true, null, UserSocialInfo );
//		public static const BUY_CHIPS:DataCallConfig = new DataCallConfig( ServerModulesConfig.PAYMENT, 'BUY_CHIPS' );
		public static const PREPARE_GIFT:DataCallConfig = new DataCallConfig( ServerModulesConfig.GIFT, PREPARE_GIFT_COMMAND );

		public static function get LOGIN():DataCallConfig {
			
			var callConfigVO:DataCallConfig = USER_LOGIN;

			callConfigVO.request_params = SocialConfig.social_parser_params.getInstallationsParamsForLogin();
			
			return callConfigVO;
		}
		
		public static function getConfigByCommandName(cmd_name:String):DataCallConfig {
			return null;
		}

//		public static function getUpdateUserInfoCallConfig(	firstname:String,
//															lastname:String,
//															email:String,
//															gender:int,
//															birthday:String,
//															country_id:String,
//															city_id:String,
//															like:int,
//															app_friends_count:int,
//															language:String = ""):DataCallConfig{
//			
//			var callConfigVO:DataCallConfig;
//			callConfigVO = UPDATE_USER_INFO;
//			// create request params
//			var requestParams:Object = new Object();
//			requestParams.firstname = firstname;
//			requestParams.lastname = lastname;
//			if ( email != null && email != '' ){
//				requestParams.email_usage_authorized  = "1";
//				requestParams.email  = email;
//			}else
//				requestParams.email_usage_authorized  = "0";
//			
//			requestParams.gender = gender;
//			requestParams.birthday = birthday;
//			requestParams.gender = gender;
//			requestParams.birthday = birthday;
//			requestParams.country = country_id;
//			requestParams.city = city_id;
//			requestParams.language = language;
//			requestParams.like = String( like );
//			requestParams.app_friends_count = String( app_friends_count );
//
//			callConfigVO.request_params = requestParams;
//
//			return callConfigVO;
//		}

//		public static function getRegisterNewUserCallConfig( user_sn_id:String ):DataCallConfig{
//			var callConfigVO:DataCallConfig;
//			callConfigVO = REGISTER_NEW_USER;
//			// create request params
//			var requestParams:Object 	= SocialConfig.social_parser_params.getInstallationsParams();
//			requestParams.user_sn_id 	= user_sn_id;
//			//TODO:
//			//need implement friend_ids
//
//			callConfigVO.request_params = requestParams;
//
//			return callConfigVO;
//		}
	}
}
