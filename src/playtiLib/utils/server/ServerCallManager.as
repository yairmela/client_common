package playtiLib.utils.server
{
 	import flash.events.ErrorEvent;
 	import flash.events.Event;
 	import flash.events.EventDispatcher;
 	import flash.events.IOErrorEvent;
 	
 	import playtiLib.config.server.ServerCallConfig;
 	import playtiLib.model.vo.server.ServerCallVO;
 	import playtiLib.utils.core.ObjectUtil;
	/**
	 * Handles the server calls. Holds an array of the activ calls. 
	 * Sends the server's call by ServerCallVO object and dispatches events when it has the results.
	 * @see IServerManager
	 * @see playtiLib.model.vo.server.ServerCallVO
	 * 
	 */ 
	public class ServerCallManager extends EventDispatcher implements IServerManager{
		
		private static var server:String;
		private static var format:String;
		private var active_calls:Array = [];
		private static var instance:IServerManager;
		
		public static function getInstance():IServerManager {
			
			if( !instance )
				instance = new ServerCallManager( new ServerCallManagerSKey )
			return instance;
		}
		
		public function ServerCallManager( singleton_key:ServerCallManagerSKey ):void {
			
			if( ServerCallConfig.server_callback_format == '' )
				throw new Error( 'the server or format is not configured check ServerCallConfig initiation ' );
			
			format = ServerCallConfig.server_callback_format;
		}
		/**
		 * Returns a ServerCallVO that contains the current active call from the active call array. 
		 * @param call_sig
		 * @return 
		 * 
		 */		
		private function getActiveServerCall( call_sig:String ):ServerCallVO {
			
			var active_for_call:Array = active_calls.filter( function( call:ServerCallVO, i:int, arr:Array ):Boolean {
				return getCallSignature( call.server_path, call.server_module, call.command_name, call.request_params ) == call_sig } );
			if( active_for_call.length == 0 ) 
				return null;
			return active_for_call[0] as ServerCallVO;
		}
		/**
		 * Gets module, command and params and by those parameters, uses the get active server call  function (returns ServerCallVO object) and uses it's send function.
		 * It also adds listeners to the object for COMPLETE loading and for ERROR handling.
		 * @param module
		 * @param command
		 * @param params
		 * @param on_result_func
		 * @param on_io_error_func
		 * 
		 */		
		public function send( server_path:String, module:String, command:String, params:Object, on_result_func:Function, on_io_error_func:Function ):void {
			
			var call_sig:String = getCallSignature( server, module, command, params );
			var server_call:ServerCallVO = getActiveServerCall( call_sig );
			if( !server_call ) {
				server_call = new ServerCallVO( server, module, command, params );
				server_call.addEventListener( Event.COMPLETE, serverCallComplete, false, 0, true );
				server_call.addEventListener( ErrorEvent.ERROR, dispatchEvent, false, 0, true );
				server_call.addEventListener( IOErrorEvent.IO_ERROR, IO_Error, false, 0, true );
				active_calls.push( server_call );
			}
			server_call.addResultListener( on_result_func );
			server_call.addIOErrorListener( on_io_error_func );
			server_call.send();
		}
		
		private function IO_Error( event:IOErrorEvent ):void {
			
			trace( event );
			dispatchEvent( event );
		}
		
		public static function set server_path( server_path:String ) : void {
			
			server = server_path;
		}
		/**
		 * Retuns a concatenated string that contains the server, module, command and all the properties (string) in the params object
		 * @param server
		 * @param module
		 * @param command
		 * @param params
		 * @return 
		 * 
		 */		
		private function getCallSignature( server:String, module:String, command:String, params:Object ):String {
			
			return server + module + command + ObjectUtil.propertiesToString( params );
		}
		/**
		 * Called when the data is complete loaded. It pull the ServerCallVO from the active server call array and dispatches an event. 
		 * @param event
		 * 
		 */		
		private function serverCallComplete( event:Event ):void {
			
			var call:ServerCallVO = event.currentTarget as ServerCallVO;
			//remove the active call from active list
			active_calls.splice( active_calls.indexOf( call ), 1 );
			//notify listeners
			dispatchEvent( event );
		}
		/**
		 * Retuns the array of the active calls 
		 * @return 
		 * 
		 */		
		public function get_active_calls():Array{
			
			return active_calls;
		}
	}
}
//the singleton private key
class ServerCallManagerSKey {}