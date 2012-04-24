package playtiLib.model.proxies.data
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.model.vo.FlashVarsVO;
	/**
	 * @see org.puremvc.as3.patterns.proxy.Proxy
	 * @see playtiLib.model.vo.FlashVarsVO
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
		
		public function get account_typeA():Boolean {
			return flash_vars.account_type == FlashVarsVO.ACCOUNT_TYPE_A;
		}
	}
}