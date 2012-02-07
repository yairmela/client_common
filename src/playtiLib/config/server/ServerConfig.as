package playtiLib.config.server
{
	import flash.display.Sprite;
	
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.VO.amf.request.SessionInfo;
	import playtiLib.utils.data.ContentDataCallConfig;
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.server.AMFServerCallManager;
	import playtiLib.utils.server.ServerCallManager;

	/**
	 * This class configures the server's parameters ( SERVER_IP, ASSETS_SERVER_IP, ASSETS_CACHE_ID, PAYPAGE_CACHE_ID ) 
	 */	
	public class ServerConfig{
		
		//these paramters will be added by the HostProxy upon host.xml loading
		public static var SERVER_IP:String;
		public static var CONTENT_SERVER_IP:String;
		public static var ASSETS_SERVER_IP:String;
		public static var ASSETS_CACHE_ID:String;
		public static var PAYPAGE_CACHE_ID:String;
		//server session
		public static var session_info:SessionInfo;
		
		/**
		 * Sets properties of the server from flash vars.
		 * @param flash_vars has all needed properties: server path, assets path, assets chache id, papage chache id.
		 * 
		 */		
		public static function setPropertiesFromFlashVars( flash_vars:Object, main_view:Sprite ):void {
			
			ServerConfig.SERVER_IP 					= flash_vars['server_path'];
			ServerConfig.CONTENT_SERVER_IP 			= flash_vars['content_server_path'];
			ServerConfig.ASSETS_SERVER_IP 			= flash_vars['assets_server_path'];
			ServerConfig.ASSETS_CACHE_ID 			= flash_vars['assets_cache_id'];
			ServerConfig.PAYPAGE_CACHE_ID 			= flash_vars['paypage_cache_id'];
			
			DataCallConfig.server_path 				= ServerConfig.SERVER_IP;
			ContentDataCallConfig.server_path 		= ServerConfig.CONTENT_SERVER_IP;
			
			AMFGeneralClassConfig.registerClasses();
			AMFServerCallManager.initializeRPC( main_view.loaderInfo );
		}
		/**
		 * Function that initializes the assets's server path. It sets the assets'd cache id, paypage cache id and assets server ip
		 * @param load_config
		 * @param user_sn_id
		 * 
		 */		
		public static function initAssetsServerPath( load_config:XML, user_sn_id:String ):void {
			
			var sn_config:XML = load_config.child( SocialConfig.current_social_network.toLowerCase() )[0]
			//set assets cache id
			ServerConfig.ASSETS_CACHE_ID 	= String( sn_config.assets_hosts.@assets_cache_id );
			ServerConfig.PAYPAGE_CACHE_ID 	= String( sn_config.assets_hosts.@paypage_cache_id );
			//set server assets path
			var assets_hosts:XMLList 		= sn_config.assets_hosts.host.( @mode == DeploymentConfig.DEPLOYMENT_MODE );
			var server_index:int 			= Number(user_sn_id) % ( assets_hosts.length() );
			if( ( sn_config.assets_hosts.override_server.user.( @sn_id == user_sn_id ) as XMLList ).length() > 0 )
				server_index = sn_config.assets_hosts.override_server.user.(@sn_id == user_sn_id.toString()).@server_index;
			if( server_index >= assets_hosts.length() )
				server_index = (assets_hosts.length()-1);
			ASSETS_SERVER_IP = assets_hosts[server_index].@ip_address.toString();
		}
	}
}