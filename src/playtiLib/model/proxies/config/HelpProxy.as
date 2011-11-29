package playtiLib.model.proxies.config
{
	import playtiLib.model.proxies.data.XMLProxy;
	/**
	 * Inheritors from XMLProxy and loads the xml_path and use in the LoadexternalCommand.
	 * @see playtiLib.model.proxies.data.XMLProxy
	 */
	public class HelpProxy extends XMLProxy	{
		
		public static const NAME:String = 'HelpProxy';
		
		public function HelpProxy( xml_path:String ){
			
			super( NAME, xml_path );
		}
	}
}