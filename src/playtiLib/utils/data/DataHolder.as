package playtiLib.utils.data
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.ResultEvent;
	
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.server.ServerModulesConfig;
	import playtiLib.model.VO.server.DeserializedModel;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.server.AMFServerCallManager;
	import playtiLib.utils.server.IServerManager;
	import playtiLib.utils.server.ServerCallManager;
	import playtiLib.utils.social.SocialCallManager;
	import playtiLib.utils.tracing.Logger;

	/**
	 * Holds one DataCallConfig object and has a 'ready' and 'has_error' properties. It used in the dataCapsule objects for loading data 
	 * from the server.
	 * @see DataStipulationVO
	 * @see DataCapsule
	 * @see DataHolderWarehouse
	 * @see playtiLib.utils.social.SocialCallManager
	 * @see playtiLib.utils.server.ServerCallManager
	 */	
	public class DataHolder extends EventDispatcher	{
		
		public var server_response:Object;//DataServerResponseVO
		public var data:Object = null;
		
		public var data_call_config:DataCallConfig;
		
		private var loading		:Boolean;
		private var _ready		:Boolean;
		private var _has_error	:Boolean;
		private var server_manager:IServerManager;
		
		public function DataHolder( data_call_config:DataCallConfig )	{
			
			this.data_call_config = data_call_config;
			
			if( data_call_config.server_module == ServerModulesConfig.SOCIAL ) 
				server_manager = SocialCallManager.getServerMgr();
			else
				server_manager = AMFServerCallManager.getInstance();
		}
		
		public function get call_signature():String {
			
			return data_call_config.call_signature;
		}
		/**
		 * Sends the server the call for gets the from it the data. It checks if the data is ready to use (if it came from server) and if it is,
		 * it dispatch an event (COMPLETE) if not, it checks if it is already loading this data and if not, it sends a call to the server.
		 */		
		public function loadData():void {
			
			if( !data_call_config.is_cached ){
				_ready = false;
				_has_error = false;
			}
			if( _ready ) {
				dispatchEvent( new Event( Event.COMPLETE ) );
			} else if( !loading ) {
				loading = true;
				server_manager.send( data_call_config.server_url, data_call_config.server_module, data_call_config.command_name, data_call_config.request_params, onResult, dispatchEvent );
			}
		}
		
		private function onAMFResult( event:ResultEvent ):void {
			server_response = event.result;
			data = server_response.result;
			Logger.log( "DataHolder onResult " + data_call_config.command_name +" :: " + event.result );
			_ready = true;
			loading = false;
			dispatchEvent( new EventTrans(Event.COMPLETE, event.result.result) );
		}
		
		/**
		 * Passed to the server manager when the send function is used as the result function. Gets the sever response, checks
		 * for errors and sets the ready to true, the loading to false and dispatch a relavent event abot finish loading.  
		 * @param event
		 * 
		 */		
		private function onResult( event:Event ):void {
			if( event is ResultEvent ) {
				onAMFResult( event as ResultEvent )
				return;
			}
			server_response = (event as EventTrans).data;
			
			Logger.log("DataHolder onResult " + data_call_config.command_name +" :: " + server_response);
			if( event.type != ErrorEvent.ERROR )
				data  = convertToVOInstance();
			else 
				_has_error = true;
			_ready = true;
			loading = false;
			dispatchEvent( event );
		}
		 
		private function convertToVOInstance():* {
			
			var data_result:Object = ( server_response is DataServerResponseVO ) ? server_response.result : server_response;
			if( data_call_config.vo_generator == null )
				return data_result;
			var instance:Object = new data_call_config.vo_generator();
			if( instance is DeserializedModel )
				instance.buildVO( data_result );
			return instance;
		}

		public function get ready():Boolean {
			
			return _ready;
		}
		
		public function set ready( ready:Boolean ):void{
			
			_ready = ready;
		}
		
		public function get has_error():Boolean {
			
			return _has_error;
		}
		 	
		public function set has_error( has_error:Boolean ):void{
			
			_has_error = has_error;
		}
		/**
		 * Checks if there are errors OR if the is_cached property of the DataCallConfig is false and sets the ready property to false.
		 */		
		public function refreshStatus():void{
			
			if( !data_call_config.is_cached || _has_error)
				_ready = false;
		}
		
		/**
		 * Sets the ready property to false. 
		 */		
		public function markNotUpdated():void {
			
			_ready = false;
		}
		/**
		 * Executes the setStipulationData on the DataCallConfig object. It sets the data on it's request_param field. 
		 * @param data
		 * 
		 */
		public function setStipulationData( data:Object ):void {
			
			data_call_config.setStipulationData( data );
		}
	}
}