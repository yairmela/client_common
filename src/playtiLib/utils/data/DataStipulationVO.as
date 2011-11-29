package playtiLib.utils.data
{
	/**
	 * Holds param name, was added(boolean) parameters and a DataCallConfig object. 
	 * @see DataCapsule
	 * @see DataHolderWarehouse
	 */	
	public class DataStipulationVO	{
		
		public var param_name:String;
		public var data_config:DataCallConfig;
		public var was_added:Boolean;
		
		public function DataStipulationVO( param_name:String, data_config:DataCallConfig )	{
			
			this.param_name  = param_name;
			this.data_config = data_config;
		}
	}
}