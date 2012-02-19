package playtiLib.model.VO.social.fb
{
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.VO.server.ArrayListVO;
	
	public class SocialFriendsInfoListVo extends ArrayListVO
	{
		public function SocialFriendsInfoListVo()
		{
			super(FBSelectUserVO);
		}
		
		override public function buildVO( json:Object ):void {
			
			list = SocialConfig.social_parser_params.parseFriendsInfo( json );
		}
	}
}