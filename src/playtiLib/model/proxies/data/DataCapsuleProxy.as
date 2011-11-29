package playtiLib.model.proxies.data
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.events.EventTrans;
	/**
	 * Handles the data capsule system. In it's constructor it gets the proxy name and an array
	 * of members. The class that will implement it, will need to implement the functions : onDataReady
	 * and onDataReadyWithErrors
	 * @see org.puremvc.as3.patterns.proxy.Proxy
	 * @see playtiLib.utils.data.DataCapsule
	 * @see playtiLib.utils.data.DataCapsuleFactory
	 */	
	public class DataCapsuleProxy extends Proxy {
		
		protected var data_capsule:DataCapsule;
		
		public function DataCapsuleProxy( proxyName:String, dataMemebers:Array ) {
			
			super( proxyName, DataCapsuleFactory.getDataCapsule( dataMemebers ) );
			data_capsule = data as DataCapsule;
			data_capsule.addEventListener( Event.COMPLETE, onDataReady );
			data_capsule.addEventListener( ErrorEvent.ERROR, onDataReadyWithErrors );
			data_capsule.addEventListener(IOErrorEvent.IO_ERROR,  IO_Error );
		}
		
		/**
		 * Trace the IOErrorEvent 
		 * @param event
		 * 
		 */		
		private function IO_Error( event:IOErrorEvent ):void {
			
			trace(event);
		}
		/**
		 * On register, we load data from the dataCapsule 
		 * 
		 */		
		override public function onRegister():void {
			
			data_capsule.loadData();
		}
		/**
		 * The class that will inherit dataCapsuleProxy should implement this function  
		 * @param event
		 * 
		 */		
		protected function onDataReady( event:Event ):void {
			//implement this function to handle data ready event
		}
		/**
		 * The class that will inherit dataCapsuleProxy should implement this function  
		 * @param event
		 * 
		 */		
		protected function onDataReadyWithErrors( event:EventTrans ):void {
			//implement this function to handle data ready event
		}
		/**
		 * This function remove all the event listeners from the dataCapsule object. 
		 * 
		 */		
		override public function onRemove():void{
			
			data_capsule.removeEventListener( Event.COMPLETE, onDataReady);
			data_capsule.removeEventListener(IOErrorEvent.IO_ERROR,  IO_Error);
			data_capsule.removeEventListener( EventTrans.DATA, onDataReadyWithErrors);
		}
		/**
		 * This function returns the data inside the DataCallConfig that this function get 
		 * @param callConfig
		 * @return 
		 * 
		 */		
		protected function getResultOf( callConfig:DataCallConfig ):Object {
			
			return data_capsule.getDataHolder( callConfig ).data;
		}
		/**
		 * This function returns the data holder from the dataCapsule by index 
		 * @param index
		 * @return 
		 * 
		 */		
		protected function getResultByIndex( index:int ):Object {
			
			return data_capsule.getDataHolderByIndex( index ).data;
		}
		
		protected function getStipulationResultOf( callConfig:DataCallConfig ):Object {
			return data_capsule.getStipulationDataHolder(callConfig).data;
		}
		
		public function reloadAll(is_full_reload:Boolean = true):void {
			
			data_capsule.reloadAll(is_full_reload);
		}
		
		public function get dataReady() : Boolean {
			
			return data_capsule.is_ready;
		}
	}
}