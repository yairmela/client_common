package playtiLib.controller.commands.social {
	
	import api.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.config.server.GeneralCallsConfig;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	
	public class ExecuteGeneralExternalCallCommand extends SimpleCommand {
		
		protected var call_params:Object;
		
		override public function execute(notification:INotification):void {
			
			call_params = notification.getBody();
			if (call_params.params is String) {
				call_params.params = JSON.decode(call_params.params as String) as Object;
			}
			
			var dataCallConfig:DataCallConfig = getCallConfig(call_params);
			
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule([dataCallConfig.setRequestProperties(call_params.params)]);
			dataCapsule.addEventListener(Event.COMPLETE, onResult);
			dataCapsule.loadData();
		}

		protected function getCallConfig( params : Object ) : DataCallConfig {
			
			var dataCallConfig : DataCallConfig = AMFGeneralCallsConfig.getConfigByCommandName(params.command);
		
			if(!dataCallConfig) {
				dataCallConfig = GeneralCallsConfig.getConfigByCommandName(params.command);
			}
			
			if(!dataCallConfig) {
				dataCallConfig = new DataCallConfig(params.module, params.command);
			}
			
			return dataCallConfig;
		}
		
		private function onResult(event:Event):void {
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			dataCapsule.removeEventListener(Event.COMPLETE, onResult);
			
			ExternalInterface.call('externalCallResult', call_params.call_id, dataCapsule.getDataHolderByIndex(0).server_response.result);
		}
	}
}