package playtiLib.config.social
{
	import playtiLib.config.server.ServerModulesConfig;
	import playtiLib.model.VO.social.SocialRequestsListVO;
	import playtiLib.model.VO.social.user.SocialUserIdsVO;
	import playtiLib.model.VO.social.user.SocialUsersListVO;
	import playtiLib.model.VO.social.user.StipulatedConverToStringCallConfigVO;
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.data.DataStipulationVO;

	/**
	 * This class configures the social calls (friend's id, groups, social balance, social user info). 
	 */
	public class SocialCallsConfig{
		
		//social frineds ids
		public static const SOCIAL_FRIENDS_COMMAND_NAME:String = 'social_friends_command_name';
		public static const SOCIAL_FRIENDS:DataCallConfig = new DataCallConfig( ServerModulesConfig.SOCIAL, SOCIAL_FRIENDS_COMMAND_NAME );
		private static const SOCIAL_FRIENDS_INFO:DataCallConfig 	= new StipulatedConverToStringCallConfigVO( ServerModulesConfig.SOCIAL, SOCIAL_FRIENDS_COMMAND_NAME, true, null, SocialUsersListVO, new DataStipulationVO('uids', SOCIAL_FRIENDS));
		
		public static const LIKE_APP_COMMAND_NAME:String = 'like_app_command_name';
		public static const LIKE_APP:DataCallConfig = new DataCallConfig( ServerModulesConfig.SOCIAL, LIKE_APP_COMMAND_NAME, false, { } );		

		
		// social friends with installed application
		public static const SOCIAL_APP_FRIENDS_IDS_COMMAND_NAME:String 	= 'social_app_friends_command_name';
		public static const SOCIAL_APP_FRIENDS_IDS:DataCallConfig 		= new DataCallConfig( ServerModulesConfig.SOCIAL, SOCIAL_APP_FRIENDS_IDS_COMMAND_NAME, true, {}, SocialUserIdsVO);
		
		// social groups 
		public static const SOCIAL_GET_GROUPS_COMMAND_NAME:String 	= 'social_get_groups_command_name';
		public static const SOCIAL_GET_GROUPS:DataCallConfig 		= new DataCallConfig( ServerModulesConfig.SOCIAL, SOCIAL_GET_GROUPS_COMMAND_NAME, true );
		
		// social groups 
		public static const SOCIAL_BALANCE_COMMAND_NAME:String 		= 'social_balance_command_name';
		public static const SOCIAL_BALANCE:DataCallConfig 		= new DataCallConfig( ServerModulesConfig.SOCIAL, SOCIAL_BALANCE_COMMAND_NAME );
		
		public static const SOCIAL_USER_INFO_COMMAND_NAME:String 	= 'social_user_info_command_name';
		private static const SOCIAL_USERS_INFO:DataCallConfig 		= new DataCallConfig( ServerModulesConfig.SOCIAL, SOCIAL_USER_INFO_COMMAND_NAME, true, null, SocialUsersListVO );
		private static const SOCIAL_APP_FRIENDS_INFO:DataCallConfig = new StipulatedConverToStringCallConfigVO( ServerModulesConfig.SOCIAL, SOCIAL_USER_INFO_COMMAND_NAME, true, null, SocialUsersListVO, new DataStipulationVO('uids', SOCIAL_APP_FRIENDS_IDS));
		private static const LEADERBOARD_USERS_INFO:DataCallConfig  = new DataCallConfig(ServerModulesConfig.SOCIAL, SOCIAL_USER_INFO_COMMAND_NAME, true, null, SocialUsersListVO);
				
		public static const SOCIAL_GET_PHOTO_UPLOAD_SERVER_COMMAND_NAME:String 	= 'social_get_photo_upload_server';
		public static const SOCIAL_GET_PHOTO_UPLOAD_SERVER:DataCallConfig 	= new DataCallConfig(ServerModulesConfig.SOCIAL, SOCIAL_GET_PHOTO_UPLOAD_SERVER_COMMAND_NAME );
		
		public static const SOCIAL_WALL_SAVE_POST_COMMAND_NAME:String 	= 'social_wall_save_post';
		public static const SOCIAL_WALL_SAVE_POST:DataCallConfig 		= new DataCallConfig(ServerModulesConfig.SOCIAL, SOCIAL_WALL_SAVE_POST_COMMAND_NAME );
		
		public static const LOAD_APP_REQUESTS_COMMAND_NAME:String 	= 'social_get_requests_data';
		public static const APP_REQUESTS:DataCallConfig		= new DataCallConfig(ServerModulesConfig.SOCIAL, LOAD_APP_REQUESTS_COMMAND_NAME , false, {}, SocialRequestsListVO);
		
		public static function getSocialWallSavePostCallConfig(data : Object):DataCallConfig{
			var callConfigVO:DataCallConfig = SOCIAL_WALL_SAVE_POST;
			callConfigVO.request_params = data;
			return callConfigVO;
		}
		/**
		 * Function that gets an array and returns a DataCallConfig objects with the profile field list. 
		 * It used for new user registeration and for update the user info.
		 * @param aUids
		 * @return 
		 * 
		 */	
		public static function getUserProfileCallConfig( aUids:Array ):DataCallConfig{
			
			var callConfigVO:DataCallConfig = SOCIAL_USERS_INFO;
			callConfigVO.request_params.fields = SocialConfig.social_parser.getProfileFiledsList();
			callConfigVO.request_params.uids= aUids.join();
			return callConfigVO;
		}
		
		public static function get LEADERBOARD_USERS_INFO_SOCIAL():DataCallConfig {
			
			var callConfig:DataCallConfig = LEADERBOARD_USERS_INFO;
			if (!callConfig.request_params.hasOwnProperty('fields'))
				callConfig.request_params.fields = SocialConfig.social_parser.getProfileFiledsList();
			return callConfig;
		}
		
		public static function get APP_FRIENDS_INFO():DataCallConfig{
			
			var callConfigVO:DataCallConfig = SOCIAL_APP_FRIENDS_INFO;
			if( !callConfigVO.request_params.hasOwnProperty( 'uids' ) )
				callConfigVO.request_params.uids = SocialConfig.viewer_sn_id + ",";
			if( !callConfigVO.request_params.hasOwnProperty( 'fields' ) )
				callConfigVO.request_params.fields = SocialConfig.social_parser.getProfileFiledsList();
			return callConfigVO;
		}
		
		public static function get FRIENDS_INFO():DataCallConfig{
			
			var callConfigVO:DataCallConfig = SOCIAL_FRIENDS_INFO;
			if( !callConfigVO.request_params.hasOwnProperty( 'uids' ) )
				callConfigVO.request_params.uids = SocialConfig.viewer_sn_id + ",";
			if( !callConfigVO.request_params.hasOwnProperty( 'fields' ) )
				callConfigVO.request_params.fields = SocialConfig.social_parser.getProfileFiledsList();
			return callConfigVO;
		}
		
		public static function get ALL_SOCIAL_FRIENDS_INFO() : DataCallConfig{
			
			var callConfigVO:DataCallConfig = SOCIAL_FRIENDS;
			callConfigVO.request_params.user_id = SocialConfig.viewer_sn_id;
			return callConfigVO;
		}
		
		public static function getLikeInfo( page_id : String ) : DataCallConfig	{
			
			var callConfigVO:DataCallConfig = LIKE_APP;
			callConfigVO.request_params.user_id = SocialConfig.viewer_sn_id;
			callConfigVO.request_params.page_id = page_id;
			return callConfigVO;
		}
	}
}
