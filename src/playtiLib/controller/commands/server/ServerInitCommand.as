package playtiLib.controller.commands.server {
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.config.server.ServerCallConfig;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.server.SystemErrorConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.vo.amf.response.ClientResponse;
	import playtiLib.model.vo.amf.response.LoginMessage;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.tracing.Logger;
	
	public class ServerInitCommand extends SimpleCommand 
	{
		/**
		 * Inits connection with server and try login.
		 * Gets data from the server (by loading a data capsule) 
		 * about the login (failed or success)
		 * */
		override public function execute(notification:INotification):void 
		{
			Logger.log("ServerInitCommand");
			//set the SocialConfig.viewer_sn_id
			SocialConfig.viewer_sn_id = flash_vars.viewer_id;
			
			var params:Object = {userSnId: SocialConfig.viewer_sn_id, password: flash_vars.signed_request, language: flash_vars.language, urlParams: flash_vars.toString()};
			var data_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule([AMFGeneralCallsConfig.LOGIN.setRequestProperties(params)]);
			data_capsule.addEventListener(Event.COMPLETE, onServerLogin);
			data_capsule.loadData();
		}
		
		/**
		 * Gets dataCapsule object, removes it's listener and checks if it needs registration - it sends notification (REGISTER_NEW_USER),
		 * if the login succeed, it executes the loginComplete function and tracks the actions.
		 * @param event
		 */
		private function onServerLogin(event:Event):void {
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			data_capsule.removeEventListener(Event.COMPLETE, onServerLogin);
			var response:ClientResponse = data_capsule.getDataHolderByIndex(0).server_response as ClientResponse;
			
			switch (response.service.errorCode){
				case ServerCallConfig.SRC_USER_NOT_REGISTERED: //if need registration
					Logger.log("login result - not registered");
					sendNotification(GeneralAppNotifications.REGISTER_NEW_USER);
					break;
				case ServerCallConfig.SRC_SUCCESS: //if login success
					ServerConfig.session_info = (response.result as LoginMessage).sessionInfo;
					Logger.log("login result - success");
					loginComplete();
					break;
				case SystemErrorConfig.LOGIN_NOT_ALLOWED_AT_THIS_MOMENT: 
					Logger.log("login not allowed");
					ExternalInterface.call('disableTabMenu');
					sendNotification(GeneralAppNotifications.SYSTEM_ERROR, SystemErrorConfig.LOGIN_NOT_ALLOWED_AT_THIS_MOMENT);
					return;
			}
		}

		private function loginComplete():void {
			sendNotification(GeneralAppNotifications.SERVER_LOGIN_COMPLETE, true);
			sendNotification(GeneralAppNotifications.UPDATE_USER_INFO);
			if (ExternalInterface.available){
				try {
					ExternalInterface.call('loginComplete');
				} catch (error:Error){
					trace(error.toString());
				}
			}			
		}
		
		private function get flash_vars():FlashVarsVO 
		{
			return (facade.retrieveProxy(FlashVarsProxy.NAME) as FlashVarsProxy).flash_vars;
		}
	}
}