package playtiLib.model.vo.amf.social.fb
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.utils.social.SocialUserProfileParser;
	
	public class FBSocialParserParams extends SocialUserProfileParser{
		
		override public function getInstallationsParams():Object {
			
			var parser_data:Object = new Object();
			var flash_vars:FlashVarsVO = ( Facade.getInstance().retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy ).flash_vars;
			//TODO: make a configuration file for all the flashvars
			parser_data['ch'] 	= flash_vars.ch_c == null  ? '' : flash_vars.ch_c;
			parser_data['et'] 	= flash_vars.et_c == null  ? '' : flash_vars.et_c;
			parser_data['crt'] 	= flash_vars.crt_c == null ? '' : flash_vars.crt_c;
			parser_data['pid'] 	= flash_vars.pid_c == null ? '' : flash_vars.pid_c;
			parser_data['src'] 	= flash_vars.src_c == null ? '' : flash_vars.src_c;
			parser_data['iid'] 	= flash_vars.iid_c == null ? '' : flash_vars.iid_c;
			parser_data['language'] = flash_vars.locale == null ? '' : flash_vars.locale;
			
			return parser_data;
		}
		/**
		 * Retrieves the flash vars from the flash vars proxy and inserts it's installation vars for login to a new object and if there
		 * is a null var, it enters "". It returns this object. 
		 * @return 
		 * 
		 */		
		override public function getInstallationsParamsForLogin():Object {
			
			var parser_data:Object = new Object();
			var flash_vars:FlashVarsVO = ( Facade.getInstance().retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy ).flash_vars;
			
			parser_data['ch']  = flash_vars.ch == null  ? '' : flash_vars.ch;
			parser_data['et']  = flash_vars.et == null  ? '' : flash_vars.et;
			parser_data['crt'] = flash_vars.crt == null ? '' : flash_vars.crt;
			parser_data['pid'] = flash_vars.pid == null ? '' : flash_vars.pid;
			parser_data['src'] = flash_vars.src == null ? '' : flash_vars.src;
			parser_data['iid'] = flash_vars.iid == null ? '' : flash_vars.iid;
			parser_data['language'] = flash_vars.locale == null ? '' : flash_vars.locale;
			
			return parser_data;
		}
		/**
		 * Gets an object, runs over it's data property and tries to push the objects in it. If doesn't succsses, or catches an error.
		 * It returns the array of the objects that it successes to push. 
		 * 
		 */		
		override public function parseSnRequests( response:Object ):Array {
			
			var parser_data:Array = new Array();
			for each( var row:Object in response.data ) {
				try{
					parser_data.push( new FBRequestDataVO( row ) );
				}catch(e:Error){
					trace(e);
				}
			}

			return parser_data;
		}
	}
}
