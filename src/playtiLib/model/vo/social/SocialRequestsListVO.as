package playtiLib.model.vo.social
{
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.vo.server.ArrayListVO;
	
	public class SocialRequestsListVO extends ArrayListVO{
		
		public function SocialRequestsListVO(){}
		
		override public function buildVO( json:Object ):void {
			
			list = SocialConfig.social_parser_params.parseSnRequests( json );
		}
	}
}