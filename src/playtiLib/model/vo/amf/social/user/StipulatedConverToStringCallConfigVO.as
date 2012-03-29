package playtiLib.model.vo.amf.social.user
{
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.data.DataStipulationVO;
	
	public class StipulatedConverToStringCallConfigVO extends DataCallConfig	{
		
		public function StipulatedConverToStringCallConfigVO( server_module:String, command_name:String, is_cached:Boolean, request_params:Object, vo_generator:Class, data_stipulation:DataStipulationVO = null )	{
			
			super( server_module, command_name, is_cached, request_params, vo_generator, data_stipulation );
		}
		/**
		 * Gets a data object and checks if it is an array it convert it to string with ',' seperate and if not, it executes toString 
		 * function on it. It also calls the super.serStipulationData (from DataCallConfig)
		 * @param data
		 * 
		 */		
		override public function setStipulationData( data:Object ):void {
			
			if( data is Array )
				data = ( data as Array ).join( "," );
			else if( data.hasOwnProperty( data_stipulation.param_name ) )
				data = data[data_stipulation.param_name];
			else
				data = data.toString();
			super.setStipulationData( data );
		}
	}
}