package playtiLib.config.social.fb
{
	import playtiLib.config.server.ServerModulesConfig;
	import playtiLib.utils.data.DataCallConfig;
	/**
	 * Class that configures the special FB server calls.
	 * These calls are unique to Facebook and therefore are not configured in SocialCallsConfig.
	 * @see playtiLib.config.social.SocialCallsConfig
	 */
	public class FBCallsConfig{//TODO: unified this class to social calls config
		
		public static const FB_APP_PERMISSIONS_COMMAND_NAME:String 	= 'fb_app_permissions_command_name';
		public static var FB_APP_PERMISSIONS:DataCallConfig 		= new DataCallConfig( ServerModulesConfig.SOCIAL, FB_APP_PERMISSIONS_COMMAND_NAME, false, {} );
		public static const FB_LIKE_APP_COMMAND_NAME:String 		= 'fb_like_app_command_name';
		public static var FB_LIKE_APP:DataCallConfig 				= new DataCallConfig( ServerModulesConfig.SOCIAL, FB_LIKE_APP_COMMAND_NAME, false, {} );
	}
}
