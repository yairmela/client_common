package playtiLib.model.proxies.config
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.model.VO.social.SocialConfigVO;
	
	public class AppConfigProxy extends Proxy{
		
		public static const NAME:String = 'AppConfigProxy';
		
		public function AppConfigProxy( data:SocialConfigVO )	{
			
			super( NAME, data );
		}

		public function getConfigVO():SocialConfigVO {
			
			return getData() as SocialConfigVO;
		}
	}
}