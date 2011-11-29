package playtiLib.utils.data
{
	/**
	 * Holds all the holders and can handles them - gets holder, pushes a new one and updates .
	 * @see DataCapsule
	 * @see DataStipulationVO 
	 * @see DataHolder
	 */	
	public class DataHolderWarehouse{
		
		private var holders:Array = [];
		
		public function DataHolderWarehouse(){
			
		}
		/**
		 * Gets a DataCallConfig object, checks if there is a holder that has the same singature, and if there isn't, it makes a new 
		 * holder with the given object properties, and pushes it to the holders array. If there is, it pushes this
		 * holder to the holders array. It returns this holder.  
		 * @param dataCallConfig
		 * @return 
		 * 
		 */		
		public function getHolder( dataCallConfig:DataCallConfig ):DataHolder {
			
			var match_holders:Array = holders.filter( function( element:Object, ...args ):Boolean{ return element.sig == dataCallConfig.call_signature });
			var holder:DataHolder;
			if( match_holders.length == 0 ) {
				holder = new DataHolder( dataCallConfig );
				holders.push( { sig:dataCallConfig.call_signature, holder:holder } )
			} else {
				holder = match_holders[0].holder
			}
			return holder;
		}
		/**
		 * Runs over all the holders array and checks if one of the holders is equal to the givven holder. If it is, it takes it out and pushes 
		 * it back with new signature from the given holder.
		 * @param holder
		 * 
		 */		
		public function updateHolderSigRegistration( holder:DataHolder ):void {
			
			for each( var holder_data:Object in holders ) {
				if( holder_data.holder == holder ) {
					holders.splice( holders.indexOf( holder_data ), 1 );
					holders.push( { sig:holder.data_call_config.call_signature, holder:holder } );
				}
			}
		}
	}
}