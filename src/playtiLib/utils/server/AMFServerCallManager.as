package playtiLib.utils.server {
	
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import mx.core.mx_internal;
	import mx.messaging.config.LoaderConfig;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.Operation;
	import mx.rpc.remoting.RemoteObject;
	import mx.rpc.Responder;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.model.vo.amf.request.ClientRequest;
	
	use namespace mx_internal;
	
	public class AMFServerCallManager extends EventDispatcher implements IServerManager {
		
		private static var instance:IServerManager;
		
		public var server_modules:Array = [];
		
		public function AMFServerCallManager(singleton_key:ServerCallManagerSKey){}
		
		public function send(server_url:String, module:String, command:String, params:Object, on_result_func:Function, on_io_error_func:Function):void {
			var client_request:ClientRequest = params as ClientRequest;
			if (!client_request)
				client_request = new ClientRequest;
			if (!client_request.sessionInfo)
				client_request.sessionInfo = ServerConfig.sessionInfo;
			
			var plugin_module:RemoteObject = server_modules[module] as RemoteObject;
			if (!plugin_module){
				plugin_module = new RemoteObject;
				plugin_module.destination = module;
				plugin_module.endpoint = server_url;
				server_modules[module] = plugin_module;
			}
			
			var remote_call:AsyncToken = (plugin_module[command] as Operation).send(client_request);
			remote_call.addResponder(new Responder(on_result_func, on_io_error_func));
			remote_call.addResponder(new Responder(remoteCallSuccessHandler, remoteCallFaultHandler));
		}
		
		private function remoteCallSuccessHandler(event:ResultEvent):void {
			dispatchEvent(event);
			trace(event);
		}
		
		private function remoteCallFaultHandler(event:FaultEvent):void {
			dispatchEvent(event);
			trace(event);
		}
		
		public static function getInstance():IServerManager {
			if (!instance)
				instance = new AMFServerCallManager(new ServerCallManagerSKey)
			return instance;
		}
		
		public static function initializeRPC(loader_info:LoaderInfo):void {
			LoaderConfig.mx_internal::_url = loader_info.url;
			LoaderConfig.mx_internal::_parameters = loader_info.parameters;
		}
	}
}

//the singleton private key
class ServerCallManagerSKey {
}