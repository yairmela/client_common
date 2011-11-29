package playtiLib.model.proxies.config
{
	import flash.events.Event;
 	import playtiLib.config.server.DeploymentConfig;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.proxies.data.XMLProxy;
 	import playtiLib.utils.server.ServerCallManager;
	import playtiLib.utils.tracing.Logger;
	/**
	 * This class handles the the host. It inheritors from XMLProxy and loads the xml_path and use in the LoadexternalCommand.
	 * @see playtiLib.model.proxies.data.XMLProxy
	 * @see playtiLib.utils.server.ServerCallManager
	 */	
	public class HostProxy extends XMLProxy	{
		
		public static const NAME:String = 'HostProxy';
		
		public function HostProxy( xml_path:String ){
			
			super(NAME, xml_path);
		}
		
		override protected function loadCompleteHandler( event:Event ):void {
			
			super.loadCompleteHandler( event );
			
			Logger.log( "loadCompleteHandler server_ip " + server_ip );
			ServerConfig.SERVER_IP = server_ip;
			ServerCallManager.server_path = server_ip;
		}
		/**
		 * A getter function that returns the ip of the server
		 * @return 
		 * 
		 */		
		public function get server_ip():String {
			
			var sn_name:String = SocialConfig.current_social_network.toLowerCase();
			var sn_host:XML = xml.child( sn_name )[0];
			return sn_host.host.( @name == 'main_server' ).( @mode == DeploymentConfig.DEPLOYMENT_MODE ).@ip_address.toString();
		}
	}
}