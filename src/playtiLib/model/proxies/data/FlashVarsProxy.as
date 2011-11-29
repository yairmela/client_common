package playtiLib.model.proxies.data
{
	import org.puremvc.as3.patterns.proxy.Proxy;
 	import playtiLib.model.VO.FlashVarsVO;
	/**
	 * @see org.puremvc.as3.patterns.proxy.Proxy
	 * @see playtiLib.model.VO.FlashVarsVO
	 */ 	
	public class FlashVarsProxy extends Proxy {
		
		public static const NAME:String = "FlashVarsProxy";
		
		public function FlashVarsProxy( oFlashVars:FlashVarsVO ) {
			
			super( NAME, oFlashVars );
		}
		/**
		 * A getter function that returns the data casting to FlashVarsVO 
		 * @return 
		 * 
		 */		
		public function get flash_vars():FlashVarsVO {
			
			return getData() as FlashVarsVO;
		}
	}
}