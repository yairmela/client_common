package playtiLib.utils.data
{
	import playtiLib.model.VO.amf.request.ClientRequest;
	import playtiLib.utils.core.ObjectUtil;

	/**
	 * Holds the server call parameters. It used to define general server calls.
	 */
	public class DataCallConfig{
		private static var server_url:String;
		
		public static function set server_path( server_path:String ) : void {
			server_url = server_path;
		}

		public var server_url:String;
		public var server_module:String;
		public var command_name:String
		public var request_params:Object;
		public var vo_generator:Class;
		public var is_cached:Boolean;
		public var data_stipulation:DataStipulationVO;
		
		public function DataCallConfig( server_module:String, command_name:String, is_cached:Boolean = false, request_params:Object=null, vo_generator:Class=null, data_stipulation:DataStipulationVO=null )	{
			this.server_url			= DataCallConfig.server_url;
			this.server_module 		= server_module;
			this.command_name 		= command_name;
			this.vo_generator 		= vo_generator;
			this.request_params 	= request_params ? request_params : {cmd:command_name};
			this.data_stipulation 	= data_stipulation;
			this.is_cached 			= is_cached;
		}
		
		public function get call_signature():String {
			
			return server_module + "::" + command_name + " request_params = " + ObjectUtil.propertiesToString( request_params );
		}
	
		public function setStipulationData( data:Object ):void {
			
			if( request_params.hasOwnProperty( data_stipulation.param_name ) && request_params[data_stipulation.param_name] is String ) {
				//if data is "" and we see a , in the end of param we should delete the comma to make this arr.toString valid
				if ( request_params[data_stipulation.param_name].toString().indexOf( ',' ) )
				    request_params[data_stipulation.param_name] = request_params[data_stipulation.param_name].toString().slice( 0, request_params[data_stipulation.param_name].toString().indexOf( ',' ) );
				if ( !data == "" ) {
					request_params[data_stipulation.param_name] += ',' + data;
				}
			} else {
				request_params[data_stipulation.param_name] = data;
			}
		}
		
		public function setRequestProperties( params:Object, ...args ):DataCallConfig {
			setRequsetPropertiesByObject(params);
			for each( params in args)
				setRequsetPropertiesByObject(params);
			return this;
		}
		
		private function setRequsetPropertiesByObject(params:Object):void {
			var vo_properties:Array = ObjectUtil.getPropertiesType( request_params );
			for each( var property_info:Object in vo_properties ) {
				var key:String = property_info.name;
				if( params.hasOwnProperty( key ) )
					request_params[key] = params[key];
			}
		}
	}
}