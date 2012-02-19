package playtiLib.model.proxies.server {
	
	import flash.utils.getQualifiedClassName;
	
	import mx.messaging.messages.RemotingMessage;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.remoting.Operation;
	import mx.rpc.remoting.RemoteObject;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.server.ServerErrorsConfig;
	import playtiLib.model.vo.amf.request.ClientRequest;
	import playtiLib.utils.server.AMFServerCallManager;
	
	/**
	 * Handles the data and the errors of the server's calls. Holds an array of the server calls that don't call back and when it does the relogin
	 * function, it send to the server all those calls.
	 */
	public class AMFServerCallManagerProxy extends Proxy {
		
		public static const NAME:String = 'AMFServerCallManagerProxy';
		
		protected var storedOperations:Array = []; //will host server call vo that recived errors
		
		public function AMFServerCallManagerProxy(){
			
			super(NAME, AMFServerCallManager.getInstance());
			
			serverCallManager.addEventListener(FaultEvent.FAULT, onFault);
		}
		
		/**
		 * Do appropriate action by determinated fault code.
		 * Init the waiting_for_relogin_calls array and sends notification - SYSTEM_ERROR.
		 * @param event
		 */
		private function onFault(event:FaultEvent):void {
			
			//server not available
			if (event.fault.rootCause.faultCode){
				sendNotification(GeneralAppNotifications.SYSTEM_ERROR, ServerErrorsConfig.ERROR_IOERROR);
				
				storedOperations = [];
				return;
			}
			
			storeFailedOperation(event.token);
			
			if(!handlingInProgress) {
				handleFault(event.fault);
			}
		}
		
		private function get handlingInProgress() : Boolean	{
			
			return (storedOperations.length > 1);
		}

		protected function handleFault( fault : Fault ) : void {
						
			sendNotification(GeneralAppNotifications.SERVER_FAULT, fault.rootCause.errorCode);
		}
		
		public function setFaultHandled( result : * ) : void {
			
			restoreOperations();
			
			sendNotification(GeneralAppNotifications.SERVER_FAULT_HANDLED, result);
		}

		private function storeFailedOperation(token:AsyncToken):void {
			
			for each (var remoteObject:RemoteObject in serverCallManager.server_modules) {
				for each (var operation:Operation in remoteObject) {
					//push operation and asyncToken to waiting_for_relogin_calls
					//if  event.token.message.operation is current operation asyncToken will be taken from event.token otherwise close operations
					var asyncToken:AsyncToken = (operation.name == (token.message as RemotingMessage).operation) ? token : operation.cancel();
					
					if (asyncToken) {
						storedOperations.push({operation: operation, asyncToken: asyncToken});
					}
				}
			}
		}

		private function restoreOperations():void {
			
			for (var i:int = 0; i < storedOperations.length; i++){
				var asyncToken:AsyncToken = (storedOperations[i].asyncToken as AsyncToken);
				for (var j:int = 0; j < asyncToken.message.body.length; j++){
					(asyncToken.message.body[j] as ClientRequest).sessionInfo = ServerConfig.session_info;
					var remote_call:AsyncToken = (storedOperations[i].operation as Operation).send(asyncToken.message.body[j]);
					remote_call.addResponder(asyncToken.responders[j]);
					//TODO:delete after complete testing
					remote_call.addResponder(new Responder(trace, trace));
				}
			}
			
			storedOperations = [];
		}
		
		protected function get serverCallManager() : AMFServerCallManager {
			
			return (getData() as AMFServerCallManager);
		}
	}
}