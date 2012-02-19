package playtiLib.utils.social
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.vo.social.SocialConfigVO;
	import playtiLib.model.proxies.config.AppConfigProxy;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.utils.server.IServerManager;
	import playtiLib.utils.social.fb.FBSocialCallManager;
	import playtiLib.utils.social.mm.MMSocialCallManager;
	import playtiLib.utils.social.simulate.SimulateSocialCallManager;
	import playtiLib.utils.social.vk.VKDataProvider;
	import playtiLib.utils.social.vk.VKRequestsQueue;
	import playtiLib.utils.social.vk.VKSocialCallManager;
	/**
	 * Handles the current social network manager (FB, VK, MM)
	 * @see playtiLib.utils.social.vk.VKSocialCallManager
	 * @see playtiLib.utils.social.vk.VKRequestsQueue
	 * @see playtiLib.utils.social.simulate.SimulateSocialCallManager
	 * @see playtiLib.utils.social.mm.MMSocialCallManager
	 * @see playtiLib.utils.social.fb.FBSocialCallManager
	 * @see playtiLib.utils.server.IServerManager
	 */	
	public class SocialCallManager	{
		
		private static var instance:IServerManager;
		private static var social_type:String; 
		
		public function SocialCallManager()	{
			
			super();
		}
		/**
		 * Checks the social network type and return it's server manager(VK, FB, MM or simulate). 
		 * @return 
		 * 
		 */		
		public static function getServerMgr():IServerManager{
			
			switch( social_type  ) {
				case SocialConfig.VK :
					return new VKSocialCallManager();
				case SocialConfig.FB :
					return FBSocialCallManager.getInstance();
				case SocialConfig.MM :
					return MMSocialCallManager.getInstance();
				case SocialConfig.SIMULATE:
					return new SimulateSocialCallManager();
			}
			return null;
		}
		//TODO: recheck the need of this configuration since we moved to IFrame in VK
		/**
		 * Gets the social network type and initializes it.
		 * @param social_type
		 * 
		 */		
		public static function init( social_type_id:String ):void 	{
			
			social_type = social_type_id;
			switch( social_type  )	{
				case SocialConfig.VK:
					var app_config_proxy:AppConfigProxy  = Facade.getInstance().retrieveProxy( AppConfigProxy.NAME ) as AppConfigProxy;
					var o_social_config_vo:SocialConfigVO = app_config_proxy.getConfigVO();
					var flash_vars_proxy:FlashVarsProxy  = Facade.getInstance().retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy;
					var o_flash_vars:FlashVarsVO 		   = flash_vars_proxy.flash_vars;
					var data_provider:VKDataProvider   = new VKDataProvider( o_flash_vars.api_id, 
												o_social_config_vo.api_secret,
												o_flash_vars.viewer_id, 
												o_flash_vars.api_url, 
												o_social_config_vo.api_is_test_mode );
					
					var init_options:Object = new Object();
					data_provider.setup( init_options );	
					VKRequestsQueue.init( data_provider );
					break;
				case SocialConfig.MM:
					
					break;
				case SocialConfig.SIMULATE:
					
					break;
			}
		}
	}
}