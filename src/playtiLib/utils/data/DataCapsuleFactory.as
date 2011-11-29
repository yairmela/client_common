package playtiLib.utils.data
{
	/**
	 * Holds a DataHolderWarehouse objects and handles it by using the following functions:  getDataCapsule from array, 
	 * getHolder by DataCallConfig object, updateHolderSigRegistration by holder. It register a new DataHolderWarehouse only once 
	 * in the constructor.
	 * @see DataStipulationVO
	 * @see DataHolder
	 * @see DataCapsule
	 * @see DataHolderWarehouse
	 * @see DataStipulationVO
	 */	
	public class DataCapsuleFactory {
		
		private static var instance:DataCapsuleFactory;
		
		public var holders_warehouse:DataHolderWarehouse;
		
		public function DataCapsuleFactory(){
			
			holders_warehouse = new DataHolderWarehouse();
		}
		
		private static function getInstance():DataCapsuleFactory {
			
			if( instance == null ) {
				instance = new DataCapsuleFactory;
			}
			return instance;
		}
		/**
		 * Gets an array of DataCallConfig objects and goes over it and inserts all the dataHolders from it to the dataCapsule array.
		 * It also checks if there is stipulation and if there is , it executes the addStipulationData function on it.
		 * @param dataMembers
		 * @return 
		 * 
		 */		
		public static function getDataCapsule( dataMembers:Array ):DataCapsule {
			
			var data_capsule:DataCapsule = new DataCapsule();
			for each( var data_call_config:DataCallConfig in dataMembers ) {
				data_capsule.insertDataHolder( getHolder( data_call_config ) );
				if( data_call_config.data_stipulation )
					data_capsule.addStipulationData( getHolder(data_call_config.data_stipulation.data_config) );
			}
			return data_capsule;
		}
		/**
		 * Returns the holder that has the currect signature. 
		 * If there is no such an holder, it make new one and returns it.
		 * @param dataCallConfig
		 * @return 
		 * 
		 */		
		public static function getHolder( dataCallConfig:DataCallConfig ):DataHolder {
			
			return getInstance().holders_warehouse.getHolder( dataCallConfig );
		}
		/**
		 * Updates the holder and the holder's signature in the dataHolderWarehouse
		 * @param holder
		 * 
		 */		
		public static function updateHolderSigRegistration( holder:DataHolder ):void {
			
			getInstance().holders_warehouse.updateHolderSigRegistration( holder );
		}
	}
}