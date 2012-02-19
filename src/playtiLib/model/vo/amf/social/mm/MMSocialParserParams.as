package playtiLib.model.vo.amf.social.mm
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.utils.social.SocialUserProfileParser;
	
	public class MMSocialParserParams extends SocialUserProfileParser{
		/**
		 * Returns an object that it inserts some flash vars properties for installation (referer type, oid, crt, ch, src) 
		 */		
		override public function getInstallationsParams():Object {
			
			var parser_data:Object = new Object();
			
			parser_data['et']  = flashVars.referer_type == null ? '' : flashVars.referer_type;
			parser_data['iid'] = flashVars.oid == null ? '' : flashVars.oid;
			parser_data['crt'] = flashVars.crt == null ? '' : flashVars.crt;
			
			parser_data['ch']  = getChParameter();
			parser_data['src'] = getSrcParameter();
			
			return parser_data;
		}
		//TODO: make a mm configuration file for all of the flashvars.
		/**
		 * Returns the ch parameter after checking the flash vars site id and ch
		 */		
		private function getChParameter():String {
			
			if ( flashVars.site_id )     return 'mm_ad';
			if ( flashVars.ch == 'ad' )  return 'ad';
			if ( flashVars.ch == 'ptr' ) return 'ptr';
			
			switch( flashVars.referer_type ) {
				
				case 'stream.install':  return 'fs'; break;
				case 'stream.publish':  return 'fs'; break;
				case 'guestbook':       return 'ow'; break;
				case 'installed_apps':  return 'ow'; break;
				case 'widget':          return 'ow'; break;
				case 'invitation':      return 'gr'; break;
				case 'catalog':         return 'ref'; break;
				case 'mailru_featured': return 'ref'; break;
				case 'friends_apps':    return 'ref'; break;
				case 'agent':           return 'ref'; break;
			}
			
			return flashVars.ch;
		}
		/**
		 * Checks the flash var parameter and returns the src(site id, src or 'in') 
		 */		
		private function getSrcParameter():String {
			
			if ( flashVars.site_id )   		return flashVars.site_id;
			if ( flashVars.ch == 'ad' )  	return flashVars.src;
			if ( flashVars.ch == 'ptr' ) 	return flashVars.src;
			if ( flashVars.referer_type ) 	return 'in';
			
			return flashVars.src;
		}
		
		private function get flashVars():FlashVarsVO
		{
			return ( Facade.getInstance().retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy ).flash_vars;
		}
		
	}
}
