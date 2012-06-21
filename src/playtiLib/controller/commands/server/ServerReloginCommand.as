package playtiLib.controller.commands.server
{
	import flash.events.Event;
	
	import mx.rpc.events.FaultEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.server.ServerErrorsConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.vo.amf.response.ClientResponse;
	import playtiLib.model.vo.amf.response.LoginMessage;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.model.proxies.server.AMFServerCallManagerProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	
	public class ServerReloginCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {
			
			var showLoading : Boolean = notification.getBody() as Boolean;
			
			if (showLoading) {
				sendNotification(GeneralAppNotifications.SET_PAUSE_POPUP_WITH_LOADING, true);
			}
			
			var flash_vars:FlashVarsVO = (facade.retrieveProxy(FlashVarsProxy.NAME) as FlashVarsProxy).flash_vars as FlashVarsVO;
			
			var params:Object = {userSnId: SocialConfig.viewer_sn_id, password: flash_vars.signed_request, language: flash_vars.language};
			var data_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule([AMFGeneralCallsConfig.LOGIN.setRequestProperties(params)]);
			data_capsule.addEventListener(Event.COMPLETE, reloginResult);
			data_capsule.addEventListener(FaultEvent.FAULT, reloginFault);
			data_capsule.loadData();
		}
		
		private function reloginFault(e:FaultEvent):void {
			
			e.stopPropagation();
			sendNotification(GeneralAppNotifications.SYSTEM_ERROR, ServerErrorsConfig.ERROR_IOERROR);
		}
		
		/**
		 * Called when the data capsule object complete loading. It goes over all the ServerCallVO object in the array (waiting_for_relogin_calls)
		 * and a executes the send function. In the array (waiting_for_relogin_calls), there are all the functions that wait for login.
		 * @param event
		 */
		private function reloginResult(event:Event = null):void {
			
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			data_capsule.removeEventListener(Event.COMPLETE, reloginResult);
			data_capsule.removeEventListener(FaultEvent.FAULT, reloginFault);
			
			sendNotification(GeneralAppNotifications.SET_PAUSE_POPUP_WITH_LOADING, false);
			
			var response:ClientResponse = data_capsule.getDataHolderByIndex(0).server_response as ClientResponse;
			
			ServerConfig.sessionInfo = (response.result as LoginMessage).sessionInfo;
		
			sendNotification(GeneralAppNotifications.SERVER_RELOGIN_COMPLETE, ServerConfig.sessionInfo);
		}
	}
}