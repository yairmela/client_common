package playtiLib.model.VO.social.vk
{
	import playtiLib.utils.social.SocialUserProfileParser;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.model.VO.FlashVarsVO;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class VKSocialParserParams extends SocialUserProfileParser	{
		
		override public function getInstallationsParams():Object {
			
			var parser_data:Object = new Object();
			var flash_vars:FlashVarsVO = ( Facade.getInstance().retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy ).flash_vars;

			parser_data['poster_id'] = flash_vars.poster_id == null ? '' : flash_vars.poster_id;
			parser_data['post_id'] = flash_vars.post_id == null ? '' : flash_vars.post_id;
			parser_data['user_id'] = flash_vars.user_id == null ? '' : flash_vars.user_id;
			parser_data['referrer'] = flash_vars.referrer == null ? '' : flash_vars.referrer;
			parser_data['group_id'] = flash_vars.group_id;
			
			return parser_data;
		}
		
		override public function getInstallationsParamsForLogin():Object {
			
			return getInstallationsParams();
		}
		
	}
}
