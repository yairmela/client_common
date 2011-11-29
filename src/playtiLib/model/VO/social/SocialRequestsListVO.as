package playtiLib.model.VO.social
{
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.VO.server.ArrayListVO;
	
	public class SocialRequestsListVO extends ArrayListVO{
		
		public function SocialRequestsListVO(){}
		
		override public function buildVO( json:Object ):void {
			
			list = SocialConfig.social_parser_params.parseSnRequests( json );
		}
	}
}