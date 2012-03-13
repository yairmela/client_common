package playtiLib.utils.social.mm
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.server.IServerManager;
	import playtiLib.utils.social.ISocialCallManager;

	/**
	 * A singletone class that handles all the MM calls by sending relevant scripts to the server, waits to get the data back and executes 
	 * the result function and the COMPLETE events. 
	 */	
	public class MMSocialCallManager extends EventDispatcher implements ISocialCallManager	{
		
		private static var instance:MMSocialCallManager;
		
		public function MMSocialCallManager( singleton_key:MMCallManagerSKey ){
			
			super();
		}
		
		public static function getInstance():MMSocialCallManager {
			
			if( !instance )
				instance = new MMSocialCallManager( new MMCallManagerSKey )
			return instance;
		}
		
		public function get SNInaccessible() : Boolean {
			
			// TODO: do an actual check
			return false;
		}
		/**
		 * Handles the commands and calls the ExternalInterface. It passes to the in the call function the params and the on result function.
		 * @param module
		 * @param command
		 * @param params
		 * @param on_result_func
		 * @param on_io_error_func
		 * 
		 */		
		public function send( server_path:String, module:String, command:String, params:Object, on_result_func:Function, on_io_error_func:Function ):void{
			
			var responceFunction:Function = function ( responseObject:Object ):void { 
				on_result_func( new EventTrans( Event.COMPLETE, responseObject ) ); 
			};
			
			switch( command ) {
				case SocialCallsConfig.SOCIAL_USER_INFO_COMMAND_NAME:					
					MailruCall.exec( "mailru.common.users.getInfo ", responceFunction, ( ( params.uids )as String ).split( ',' ) );
					break;
				case SocialCallsConfig.SOCIAL_FRIENDS_COMMAND_NAME:
					MailruCall.exec( "mailru.common.friends.getExtended ", responceFunction );
					break;
				case SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS_COMMAND_NAME:
					MailruCall.exec( "mailru.common.friends.getAppUsers", responceFunction );
					break;
				case SocialCallsConfig.SOCIAL_GET_GROUPS_COMMAND_NAME:
					break;
				case SocialCallsConfig.SOCIAL_BALANCE_COMMAND_NAME:
					break;
				case SocialCallsConfig.SOCIAL_GET_PHOTO_UPLOAD_SERVER_COMMAND_NAME:
					break;
				case SocialCallsConfig.SOCIAL_WALL_SAVE_POST_COMMAND_NAME:
					break;
			}
		}
		
	}
}
//the singleton private key
class MMCallManagerSKey {}