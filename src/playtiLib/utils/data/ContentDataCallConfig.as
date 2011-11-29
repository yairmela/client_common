package playtiLib.utils.data
{
	public class ContentDataCallConfig extends DataCallConfig
	{
		private static var server_url:String;
		
		public static function set server_path( server_path:String ) : void {
			server_url = server_path;
		}
		
		public function ContentDataCallConfig(server_module:String, command_name:String, is_cached:Boolean=false, request_params:Object=null, vo_generator:Class=null, data_stipulation:DataStipulationVO=null)
		{
			super(server_module, command_name, is_cached, request_params, vo_generator, data_stipulation);
			server_url = ContentDataCallConfig.server_url;
		}
	}
}