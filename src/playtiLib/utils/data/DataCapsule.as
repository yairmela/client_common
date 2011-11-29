package playtiLib.utils.data
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import mx.rpc.events.FaultEvent;
	import playtiLib.utils.events.EventTrans;
	/**
	 * loads and Holds the data from the server. It Holds an array of DataHolder objects and an array of integers that represents the errors number. 
	 * It can bring some data parralel and sends event when it is ready and it also can bring data after another data is complete\ready
	 * if there is an stipulation to one of the holders. 
	 * @see DataStipulationVO
	 * @see DataHolder
	 * @see DataCapsuleFactory
	 * @see DataHolderWarehouse
	 * @see DataStipulationVO
	 */
	public class DataCapsule extends EventDispatcher{
		
		private var stipulation_data_capsule:DataCapsule;
		private var holders_arr:Array;
		private var error_holders:Array;
		
		public function DataCapsule(){
			
			holders_arr = new Array();
			error_holders = new Array();
		}
		/**
		 * Push to the holders's array the holder that it got. 
		 * @param holder
		 * 
		 */		
		public function insertDataHolder( holder:DataHolder ):void {
			
			holders_arr.push( holder );
		}
		/**
		 * Checks if there is a stipulation and if there isn't, it adds the stipulation data to a new dataCapsule object and adds some listeners to it 
		 * (IO_ERROR, ERROR, COMPLETE) and inserts the holder. 
		 * @param holder
		 * 
		 */		
		public function addStipulationData( holder:DataHolder ):void {
			
			if( !stipulation_data_capsule ) {
				stipulation_data_capsule = new DataCapsule();
				stipulation_data_capsule.addEventListener( IOErrorEvent.IO_ERROR,  IO_Error );
				stipulation_data_capsule.addEventListener( ErrorEvent.ERROR, stipulationDataReady );
				stipulation_data_capsule.addEventListener( Event.COMPLETE, stipulationDataReady  );
			}
			stipulation_data_capsule.insertDataHolder( holder );
		}
		/**
		 * Executes the loadData function. 
		 * @param event
		 * 
		 */		
		private function stipulationDataReady( event:Event ):void {
			
			loadData();
		}
		/**
		 * Dispatch an IOErrorEvent event. 
		 * @param event
		 * 
		 */		
		private function IO_Error( event:IOErrorEvent ):void {
			
			dispatchEvent( event );
		}
		/**
		 * Loads data from the server by some order. It first checks if there isn't a stipulation or the data capsule stipulation is ready. 
		 * If it isn't, it calls this function again on the stipulation capsule object and returns. If yes, it refreshes the holders 
		 * status and then checks all the data is ready. If it is, it dispatch event and returns (holderLoadComplete function). 
		 * If it is false, it runs over all the holders in the array, checks if the the data hasn't loaded yet or if there is a sripulation ,
		 * adds listeners for the holders load and loads the holders.
		 * 
		 */		
		public function loadData():void {
			
			if( stipulation_data_capsule && !stipulation_data_capsule.is_ready ) {
				stipulation_data_capsule.loadData();
				return;
			}
			refreshHoldersStatus();
			
			if ( is_ready ){
				holderLoadComplete();
				return;
			}
			for each( var holder:DataHolder in holders_arr ) {
				//when we get to this point the data sipulation must be ready for us. all we need to do is to insert that data to call params.
				if( holder.data_call_config.data_stipulation && !holder.data_call_config.data_stipulation.was_added ) {
					var stipulation_holder:DataHolder = stipulation_data_capsule.getDataHolder( holder.data_call_config.data_stipulation.data_config );
					if ( stipulation_holder.has_error ){//TODO: check with Andrey the meaning of error handling he did.
						holder.has_error = true;
						holder.ready = true;
						holderLoadComplete();
						continue;
					}
					holder.setStipulationData( stipulation_holder.data );
					holder.data_call_config.data_stipulation.was_added = true;
					DataCapsuleFactory.updateHolderSigRegistration( holder );
				}
				//we cant use weakReference - because we lose holder 
				holder.addEventListener( Event.COMPLETE, holderLoadComplete, false, 0, false );
				holder.addEventListener( ErrorEvent.ERROR, holderLoadComplete, false, 0, false );
				holder.addEventListener( IOErrorEvent.IO_ERROR,  IO_Error );
				holder.addEventListener( FaultEvent.FAULT,  dispatchEvent );
				holder.loadData();
			}
		}
		/**
		 * Checks if the data from server is ready and if it is, it removes listener functions. It checks if there are errors
		 * and dispatches events about it and if there aren't, it dispatch a COMPLETE event. 
		 * @param event
		 * 
		 */		
		private function holderLoadComplete( event:Event = null ):void  {
			
			if( is_ready ) {
				removeListeners();
			if( error_holders.length > 0 )
				dispatchEvent( new EventTrans( ErrorEvent.ERROR, error_holders) );
			else
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
		/**
		 * Runs over the holders array and for every one refreshes status function. 
		 * 
		 */		
		private function refreshHoldersStatus():void {
			
			for each( var holder:DataHolder in holders_arr ) {
				holder.refreshStatus();
			}
		}
		/**
		 * Runs over the holers array and if the they all ready, it returns true. If not, it returns false.
		 * The function also checks for errors and if it finds one, it push it to the errors array. 
		 * @return 
		 * 
		 */		
		public function get is_ready():Boolean {
			
			var all_ready:Boolean = true;
			error_holders = new Array();
			for ( var i:int; i < holders_arr.length && all_ready ; i++ ) {
				var holder:DataHolder = holders_arr[i] as DataHolder;
				all_ready = all_ready && holder.ready;
				if ( holder.has_error ) // TODO: need to move to another place 
					error_holders.push(i);
			}
			return all_ready;
		}
		/**
		 * Gets a DataCallConfig object and runs over the holders array and checks if there is a holder that has the same singature 
		 * to the call singature in the passed object, if yes, it returns the current holder. If it runs over all the array and doesn't return any
		 * DataHolder object, it returns null 
		 * @param callConfig
		 * @return 
		 * 
		 */		
		public function getDataHolder( callConfig:DataCallConfig ):DataHolder {
			
			for each( var holder:DataHolder in holders_arr ) {
				if( holder.call_signature == callConfig.call_signature )
					return holder;
			}
			return null;
		}
		/**
		 * Gets an integer number and returns the DataHolder object that in that index in the holders array. 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getDataHolderByIndex( index:int ):DataHolder {
			
			return holders_arr[index];
		}
		
		public function getStipulationDataHolder( callConfig:DataCallConfig ):DataHolder {
			if( callConfig.data_stipulation ) {
				return stipulation_data_capsule.getDataHolder(callConfig.data_stipulation.data_config);
			}		
			return null;
		}
		
		/**
		 * Runs over the holders array and removes from each one the COMPLETE listeners. 
		 * 
		 */	
		private function removeListeners():void
		{
			for(var i:uint = 0; i < holders_arr.length; i++)
			{
				var holder:DataHolder = holders_arr[i];
				holder.removeEventListener( Event.COMPLETE, holderLoadComplete);
			}
		}
		/**
		 * If there is a stipulation, it executes the markNotUpdate function on it.
		 * For each holder, if it has stipulation, it sets the was add property to be false.
		 * If is it full reload, it sets the ready property of the holder to false, and if it isn't, it executes the refreshStatus on this 
		 * holder.
		 * @param is_full_reload
		 * 
		 */		
		public function markNotUpdated( is_full_reload:Boolean = true ):void {
			
			if( stipulation_data_capsule )
				stipulation_data_capsule.markNotUpdated();
			for each( var holder:DataHolder in holders_arr ) {
				if( holder.data_call_config.data_stipulation ) {
					holder.data_call_config.data_stipulation.was_added = false;
				}
				if ( is_full_reload ){
					holder.markNotUpdated();
				}else{
					holder.refreshStatus();
				}
			}
		}
		/**
		 * Executes the markNotUpdated and loadData functions. 
		 * @param is_full_reload
		 * 
		 */		
		public function reloadAll( is_full_reload:Boolean = true ):void {
			
			markNotUpdated( is_full_reload );
			loadData();
		}
	}
}
