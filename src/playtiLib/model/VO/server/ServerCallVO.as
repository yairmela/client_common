package playtiLib.model.VO.server
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
 	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.setTimeout;
	
	import playtiLib.config.server.ServerCallConfig;
	import playtiLib.config.server.ServerErrorsConfig;
	import playtiLib.utils.data.DataServerResponseVO;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.tracing.Logger;
	//TODO: change the class name to ServerCall
	public class ServerCallVO extends EventDispatcher{
		
		public static const MAX_CALLS_ATEMPTS:int = 3;
		
		public var server_path:String;
		public var server_module:String;
		public var command_name:String;
		public var request_params:Object;
		private var result_listeners:Array = [];
		private var io_error_listeners:Array = [];
		private var call_atempt_count:int;
		
		public function ServerCallVO( server_path:String, server_module:String, command_name:String, request_params:Object ){
			
			this.server_path 	= server_path;
			this.server_module 	= server_module;
			this.command_name 	= command_name;
			this.request_params = request_params;
		}
		
		public function addResultListener( result_func:Function ):void {
			
			result_listeners.push( result_func );
		}
		
		public function addIOErrorListener( io_error_func:Function ):void {
			
			io_error_listeners.push( io_error_func );
		}
		
		public function send():void		{
			
			if( !request_params )
				request_params = {};
			if( !request_params.cmd )
				request_params.cmd = command_name;
			
			var request : URLRequest = new URLRequest();
			request.contentType = "application/x-www-form-urlencoded; charset=utf-8";
			request.url = server_path + server_module;
			
			var variables:URLVariables = new URLVariables();
			
			var log_str:String = "request.url = " + request.url;
			log_str += "; params: "
			for ( var j: String in request_params ) {
				log_str += " " + j + " = " + request_params[j]
				variables[j] = request_params[j];
			}
			
			request.method = URLRequestMethod.POST;
			request.data = variables;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener( Event.COMPLETE, onResult );	
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );	
			
			Logger.log( "ServerCallManager " + log_str );
			
			try {
				loader.load( request );
			} catch ( error:Error ) {
				trace( error );
			}
			call_atempt_count++;
		}
		
		private function onResult( event:Event ):void	{
			
			var loader:URLLoader = event.currentTarget as URLLoader;
			Logger.log( "ServerCallManager onResult loader.data: " + loader.data );
			var response:DataServerResponseVO = new DataServerResponseVO( loader.data, ServerCallConfig.server_callback_format );
			if( response.response_code != -1 && response.response_code < 0 && response.response_code != ServerErrorsConfig.ERROR_SERVER_TRANSACTION_NOT_CREATED_YET && response.response_code != ServerErrorsConfig.ERROR_INVALID_GIFT_TOKEN )
				onResultError( response )
			else
				onResultSuccess( response );
		}
		
		private function onResultSuccess( response:DataServerResponseVO ):void {
			
			for each( var result_func:Function in result_listeners ) {
				result_func( new EventTrans( Event.COMPLETE, response ) );
			}
			result_listeners = new Array();
			dispatchEvent( new EventTrans( Event.COMPLETE, response ) );
		}
		/**
		 * Dispatches an ErrorEvent.ERROR 
		 * @param response
		 * 
		 */		
		private function onResultError( response:DataServerResponseVO ):void {
			
			dispatchEvent( new EventTrans( ErrorEvent.ERROR, response ) );
		}
		/**
		 * Handles the loader errors. If it passes a maximum call number, it dispatches event (IO_ERROR) 
		 * @param event
		 * 
		 */		
		private function onIOError( event:Event ):void{
			
			if( call_atempt_count < MAX_CALLS_ATEMPTS )	{
				setTimeout( send, 3000 );
			} else {
				dispatchEvent( new IOErrorEvent( IOErrorEvent.IO_ERROR ) );
			}
		}
	}
}
