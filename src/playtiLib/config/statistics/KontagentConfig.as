package playtiLib.config.statistics
{
	import playtiLib.config.server.DeploymentConfig;

	/**
	 * 
	 */
	public class KontagentConfig
	{
		//messages
		public static const MESSAGE_TYPE_PAGE_REQUEST : String 			= "pgr";
		public static const MESSAGE_TYPE_CUSTOM_EVENT : String		 	= "evt";
		//public static const MESSAGE_TYPE_COMMUNICATION_CLICK : String 	= "ucc";
		public static const MESSAGE_TYPE_APPLICATION_ADDED : String 	= "apa";
		public static const MESSAGE_TYPE_INVITE_SENT : String 			= "ins";
		public static const MESSAGE_TYPE_INVITE_RESPONSE : String 		= "inr";
		public static const MESSAGE_TYPE_STREAM_POST : String 			= "pst";
		public static const MESSAGE_TYPE_STREAM_POST_RESPONSE : String 	= "psr";
		public static const MESSAGE_TYPE_USER_INFORMATION : String 		= "cpu";
		public static const MESSAGE_TYPE_REVENUE_TRACKING : String 		= "mtu";
		//buy click
		public static const BUY_TYPE_BUTTON_CLICK :String 				= "buy_coins_button_click";
		public static const BUY_TYPE_TAB_CLICK :String 					= "buy_coins_tab_click";
		public static const BUY_TYPE_POPUP_CLICK :String 				= "popup_click";
		//server url
		private static const SERVER_URL : String 						= "api.geo.kontagent.net/api/v1";
		private static const TEST_SERVER_URL : String 					= "test-server.kontagent.net/api/v1";
		
		public static var api_key:String;
		public static var use_secured_protocol : Boolean = false;
		
		public static function get server_path() : String {
			
			var server_url : String = ( (DeploymentConfig.DEPLOYMENT_MODE != DeploymentConfig.PRODUCTION_MODE) ? TEST_SERVER_URL : SERVER_URL );
			
			return (use_secured_protocol) ? ("https://" + server_url) : ("http://" + server_url);
		}
	}
}