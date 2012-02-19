package playtiLib.config.social
{
	import playtiLib.model.vo.amf.social.fb.FBSocialUserProfileParser;
	import playtiLib.model.vo.amf.social.fb.FBSocialParserParams;
	import playtiLib.model.vo.amf.social.mm.MMSocialUserProfileParser;
	import playtiLib.model.vo.amf.social.mm.MMSocialParserParams;
	import playtiLib.model.vo.amf.social.vk.VKSocialUserProfileParser;
	import playtiLib.model.vo.amf.social.vk.VKSocialParserParams;
	import playtiLib.utils.social.SocialUserProfileParser;

	//this is used as uint constants because we 
	/**
	 * This class configures parameters about the social networks. It has properties like current_social_network_id, social_parser_params,
	 * social_parser.
	 */	
	public class SocialConfig{
		
		public static var viewer_sn_id:String;
		public static var current_social_network:String;
		//this constants are similar to constance on server 
		public static const SIMULATE:String		= 'SIMULATE_NETWORK';
		public static const VK:String 			= 'VK';
		public static const FB:String 			= 'FB';
		public static const MM:String 			= 'MM';
		public static const FB_CH:String 		= 'FB_CH';
			
		private static const SIMULATE_ID:uint 	= 0;
		private static const VK_ID:uint 		= 1 ///< vk 
		private static const FB_ID:uint 		= 2 ///< FB
		private static const MM_ID:uint 		= 3 ///< MM (moj mir)
		private static const FB_CH_ID:uint 		= 4 ///< FB chinese
		
		// Like status
		public static const LIKE_STATUS_UNKNOWN:uint		= 0;
		public static const LIKE_STATUS_LIKED:uint			= 1;
		public static const LIKE_STATUS_UNLIKED:uint		= 2;
		
		public static function get current_social_network_id():int {
			
			switch( current_social_network ) {
				case VK: return VK_ID;
				case FB: return FB_ID;
				case MM: return MM_ID;
				case FB_CH: return FB_CH_ID;
			}
			return SIMULATE_ID;
		}
		
		public static function get social_parser_params():SocialUserProfileParser {
			
			switch( SocialConfig.current_social_network ) {
				case SocialConfig.FB:
					return new FBSocialParserParams();
				case SocialConfig.VK:
					return new VKSocialParserParams();
				case SocialConfig.FB_CH:
					return new FBSocialParserParams();
				case SocialConfig.MM:
					return new MMSocialParserParams();
			}
			return new SocialUserProfileParser();
		}
		
		public static function get social_parser():SocialUserProfileParser {
			
			switch( SocialConfig.current_social_network ) {
				case SocialConfig.VK:
					return new VKSocialUserProfileParser();
				case SocialConfig.FB:
					return new FBSocialUserProfileParser();
				case SocialConfig.MM:
					return new MMSocialUserProfileParser();
				case SocialConfig.FB_CH:
					return new FBSocialUserProfileParser();
			}
			return new SocialUserProfileParser();
		}
	}
}
