package playtiLib.controller.commands.user
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.config.server.GeneralCallsConfig;
	import playtiLib.config.server.ServerCallConfig;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.vo.amf.request.ClientRequest;
	import playtiLib.model.vo.amf.request.RegisterRequest;
	import playtiLib.model.vo.amf.response.ClientResponse;
	import playtiLib.model.vo.amf.response.LoginMessage;
	import playtiLib.model.vo.amf.response.helpers.UserInfo;
	import playtiLib.model.vo.amf.social.user.SocialUsersListVO;
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.model.proxies.config.AppConfigProxy;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.model.proxies.user.UserProxy;
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.data.DataServerResponseVO;
	import playtiLib.utils.statistics.Tracker;
	import playtiLib.utils.tracing.Logger;

	/**
	 * Handles the registiration of a new user. It use dataCapsule to load the data from the server and after it loaded, it imports more data 
	 * (id, full name, sex, birthday date, adress and mail) again with data capsule and then sends notifications (SERVER_LOGIN_COMPLETE, REGISTER_NEW_USER) .
	 * @see  flash.external.ExternalInterface
	 * @see playtiLib.model.proxies.config.AppConfigProxy
	 * @see playtiLib.model.proxies.data.FlashVarsProxy
	 * @see playtiLib.model.proxies.user.UserProxy
	 * @see playtiLib.utils.data.DataCapsule
	 */
	public class RegisterNewUserCommand extends SimpleCommand {		

		override public function execute( notification:INotification ):void{
			
			Logger.log( "RegisterNewUserCommand" );
			var userInfo:UserInfo = new UserInfo();
			userInfo.userSnId = flash_vars.viewer_id;
			var data_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [ AMFGeneralCallsConfig.REGISTER_NEW_USER.setRequestProperties({ userSnId:flash_vars.viewer_id, userInfo:userInfo, urlParams: flash_vars.toString(), password: flash_vars.signed_request }) ] );
			data_capsule.addEventListener( Event.COMPLETE, registerResult );
			data_capsule.addEventListener( IOErrorEvent.IO_ERROR,  trace );
			data_capsule.loadData();
		}
		
		/**
		 * This function sends notifications(GeneralAppNotifications.SERVER_LOGIN_COMPLETE, GeneralStatistics.REGISTER_NEW_USER)
		 * whenever the dataCapsule completes it's missions 
		 * @param event
		 * 
		 */	
		private function registerResult( event:Event ):void {
			
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			data_capsule.removeEventListener( Event.COMPLETE, registerResult );
			
			var response:ClientResponse = data_capsule.getDataHolderByIndex( 0 ).server_response as ClientResponse;
			
			
			switch( response.service.errorCode ) {// TODO: needs to add cases for server response code
				case ServerCallConfig.SRC_SUCCESS:
					ServerConfig.sessionInfo = ( response.result as LoginMessage ).sessionInfo;
					trackAppRegistered();
					sendNotification( GeneralAppNotifications.SERVER_LOGIN_COMPLETE, false );					
					sendNotification( GeneralAppNotifications.UPDATE_USER_INFO );
					userProxy.firstLogin = true;
					if( ExternalInterface.available )
						ExternalInterface.call( 'loginComplete', true );									
					break;
				default:
					Logger.log( "ERROR REGISTRATION NOT SUCCESS responseCode = " + response.service.errorCode ); 
					break;
				
			}
		}
		
		private function get userProxy():UserProxy {
			
			return ( facade.retrieveProxy( UserProxy.NAME ) as UserProxy );
		}
		
		private function get flash_vars():FlashVarsVO {
			
			return ( facade.retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy ).flash_vars;
		}
		
		private function trackAppRegistered():void{
			
			sendNotification(GeneralAppNotifications.TRACK, null, GeneralStatistics.APP_REGISTERED);
		}

	}
}
