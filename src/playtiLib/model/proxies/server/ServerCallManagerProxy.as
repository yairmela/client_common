package playtiLib.model.proxies.server
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import mx.rpc.events.FaultEvent;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.GeneralCallsConfig;
	import playtiLib.config.server.ServerErrorsConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.VO.FlashVarsVO;
	import playtiLib.model.VO.server.ServerCallVO;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.server.ServerCallManager;
	import playtiLib.utils.statistics.Tracker;

	/**
	 * Handles the data and the errors of the server's calls. Holds an array of the server calls that don't call back and when it does the relogin
	 * function, it send to the server all those calls.
	 * @see playtiLib.model.proxies.data.FlashVarsProxy
	 * @see playtiLib.utils.data.DataCapsule
	 * @see playtiLib.utils.server.ServerCallManager
	 * 
	 */	
	public class ServerCallManagerProxy extends Proxy{
		
		public static const NAME:String = 'ServerCallManagerProxy';
		
		private var waiting_for_relogin_calls:Array = [];//will host server call vo that recived errors
		private var is_relogin_send:Boolean;
		
		public function ServerCallManagerProxy() {
			
			super( NAME, ServerCallManager.getInstance() );
			ServerCallManager.getInstance().addEventListener( ErrorEvent.ERROR, onResultError );
			ServerCallManager.getInstance().addEventListener( IOErrorEvent.IO_ERROR, IO_Error );
			ServerCallManager.getInstance().addEventListener( FaultEvent.FAULT, IO_Error );
		}
		/**
		 * Gets an event when there is an error in the ServerCallManager loading. It handles the errors and relogin 
		 * @param event
		 * 
		 */		
		private function onResultError( event:EventTrans ):void {
			
			var server_call:ServerCallManager = event.target as ServerCallManager;
			waiting_for_relogin_calls = waiting_for_relogin_calls.concat( server_call.get_active_calls() );
			//call reloagin using capsule
			var server_response:Object = event.data;
			var code:int = server_response.response_code;
			
			if ( !is_relogin_send )
			switch( code ){
				case ServerErrorsConfig.ERROR_SERVER_SOME_ERROR:
				case ServerErrorsConfig.ERROR_SERVER_SESSION_EXPIRE:
				case ServerErrorsConfig.ERROR_SERVER_USER_NOT_FOUND:
					sendNotification( GeneralAppNotifications.TRACK, {error_code: code}, GeneralStatistics.ERROR_FROM_SERVER );
					reLogin();
					break;
			}
		}
		/**
		 * Init the waiting_for_relogin_calls array and sends notification - SYSTEM_ERROR. 
		 * @param event
		 * 
		 */		
		private function IO_Error( event:IOErrorEvent ):void {
			
			waiting_for_relogin_calls = [];
			sendNotification( GeneralAppNotifications.SYSTEM_ERROR, ServerErrorsConfig.ERROR_IOERROR );
		}
		/**
		 * It loads the viewer_sn_id data from the server and waits for COMPLETE event 
		 * 
		 */		
		private function reLogin():void{
			//put flag for start
			is_relogin_send = true;
			
			var flash_vars:FlashVarsVO = ( facade.retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy ).flash_vars as FlashVarsVO;
			
			var data_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule([
				GeneralCallsConfig.LOGIN.setRequestProperties({user_sn_id: SocialConfig.viewer_sn_id, password: flash_vars.auth_key})
			]);
			
			data_capsule.addEventListener( Event.COMPLETE, reloginResult );
			data_capsule.loadData();
		}
		/**
		 * Called when the data capsule object complete loading. It goes over all the ServerCallVO object in the array (waiting_for_relogin_calls) 
		 * and a executes the send function. In the array (waiting_for_relogin_calls), there are all the functions that wait for login.
		 * @param event
		 * 
		 */		
		private function reloginResult( event:Event = null ):void {
			
			for each( var call:ServerCallVO in waiting_for_relogin_calls ) {
				call.send();
			}
			waiting_for_relogin_calls = [];
			//remove flag for finish
			is_relogin_send = false;
		}
	}
}