package playtiLib.model.proxies.config
{
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.proxies.data.XMLProxy;
	/**
	 * This class holds the version information. It inheritors from XMLProxy and loads the xml_path and use in the LoadexternalCommand. 
	 * @see playtiLib.model.proxies.data.XMLProxy
	 */
	public class VersionProxy extends XMLProxy{
		
		public static const NAME:String = 'VersionProxy';
		
		public function VersionProxy( xml_path:String )	{
			
			super( NAME, xml_path );
		}
		/**
		 * A getter function that returns a string that contains the value of the major, 
		 * minor and revision components 
		 * @return 
		 * 
		 */		
		public function get version():String {
			
			var sn_version:XML = xml.child( SocialConfig.current_social_network.toLowerCase() )[0]
			return (sn_version.component.( @name == 'major' ).@value + '.' +
					sn_version.component.( @name == 'minor' ).@value + '.' +
					sn_version.component.( @name == 'revision' ).@value);
		}
	}
}