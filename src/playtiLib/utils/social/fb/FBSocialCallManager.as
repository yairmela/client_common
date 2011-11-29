package playtiLib.utils.social.fb
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.config.social.fb.FBCallsConfig;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.server.IServerManager;
	import playtiLib.utils.tracing.Logger;
	/**
	 * A singletone class that handles all the FB calls by sending relevant queries to the server, wait to get the data back and executes 
	 * the result function and the COMPLETE events. 
	 */	
	public class FBSocialCallManager extends EventDispatcher implements IServerManager{
		
		//incase there are more than 1 swf on the page the js need to know to which swf to 
		//return the result so we pass upon request the swf_object_name
		//this param need to be filled in the intialize process
		public static var swf_object_name:String;
		private static var instance:FBSocialCallManager;
		private var calls_queue:Array = [];
		
		public function FBSocialCallManager( singleton_key:FBCallManagerSKey ){
			
			super();
		}
		
		public static function getInstance():FBSocialCallManager {
			
			if( !instance )
				instance = new FBSocialCallManager( new FBCallManagerSKey );

			return instance;
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
			
			switch( command ) {
				case SocialCallsConfig.SOCIAL_USER_INFO_COMMAND_NAME:
					callFQL( 'SELECT ' + params.fields + ' FROM user WHERE uid IN (' + params.uids + ')', 
							on_result_func );
					break;
				case SocialCallsConfig.SOCIAL_FRIENDS_COMMAND_NAME:
					callFQL( 'SELECT uid2 FROM friend WHERE uid1 = "' + params.user_id + '"',
						on_result_func);
					break;
				case SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS_COMMAND_NAME:
					callFQL( 'SELECT uid FROM user WHERE has_added_app=1 and uid IN (SELECT uid2 FROM friend WHERE uid1 = "' + params.user_id + '")',
							 on_result_func );
					break;
				case SocialCallsConfig.SOCIAL_GET_GROUPS_COMMAND_NAME:
					break;
				case SocialCallsConfig.SOCIAL_BALANCE_COMMAND_NAME:
					break;
				case SocialCallsConfig.SOCIAL_GET_PHOTO_UPLOAD_SERVER_COMMAND_NAME:
					break;
				case SocialCallsConfig.SOCIAL_WALL_SAVE_POST_COMMAND_NAME:
					break;
				case FBCallsConfig.FB_APP_PERMISSIONS_COMMAND_NAME:
					callFQL( 'SELECT bookmarked,status_update,photo_upload,create_event,email,publish_stream FROM permissions WHERE uid=' + params.user_id,
						on_result_func );
					break;
				case SocialCallsConfig.LIKE_APP_COMMAND_NAME:
				case FBCallsConfig.FB_LIKE_APP_COMMAND_NAME:
//					callFQL( 'SELECT target_id FROM connection WHERE source_id = ' + params.user_id + ' AND target_id = ' + params.app_id,
//						on_result_func );
					callFQL( 'SELECT uid, page_id FROM page_fan WHERE uid='+params.user_id+' AND page_id='+ params.app_id, on_result_func)
					break;
				
				case SocialCallsConfig.LOAD_APP_REQUESTS_COMMAND_NAME:
					callGetData( "me/apprequests", "", on_result_func );
					break;
			}
		}
		/**
		 * Gets a query and a function(need to be executed as a result function). It sets the result function in the cell with the query name
		 * and calls the ExternalInterface('callFql') 
		 * @param query
		 * @param on_result_func
		 * 
		 */		
		private function callFQL( query:String, on_result_func:Function ):void {
			
			var call_id:String = query;
			
			if( calls_queue[call_id] ) {
				calls_queue[call_id].push( on_result_func );
				return;
			}
			calls_queue[call_id] = [on_result_func];
			callExternalFQL( call_id, query );
		}
		/**
		 * Gets a command, some params(string) and a result function. It sets the result function with the command and the params (concatenated)
		 * and calls the ExternalInterface ('callFBData')
		 * @param command
		 * @param params
		 * @param on_result_func
		 * 
		 */		
		private function callGetData( command:String, params:String, on_result_func:Function ):void {
			
			var call_id:String = command + " " + params;
			
			if( calls_queue[call_id] ) {
				calls_queue[call_id].push( on_result_func );
				return;
			}
			calls_queue[call_id] = [on_result_func];
			callExternalGetData( call_id, command, params );
		}
		
		private function callExternalGetData( call_id:String, command:String, params:String ):void{
			
			ExternalInterface.call( 'callFBData', swf_object_name, call_id, command, params );
		}
		
		private function callExternalFQL( call_id:String, query:String ):void {
			
			if( !ExternalInterface.available ) {
				setTimeout( callExternalFQL, 1000, call_id, query );
				return;
			}
			ExternalInterface.call( 'callFql', swf_object_name, call_id, query );
		}
		
		public function FQLCallback( call_id:String, result:Object ):void {
			
			var listeners:Array = calls_queue[call_id];
			calls_queue[call_id] = null;
			for each( var result_func:Function in listeners )
				result_func( new EventTrans( Event.COMPLETE, result ) );
		}
		
		public function FQLCallbackError( call_id:String, error_message:String ):void {
			
			var listeners:Array = calls_queue[call_id];
			calls_queue[call_id] = null;
			for each( var result_func:Function in listeners )
				result_func( new EventTrans( ErrorEvent.ERROR, error_message ) );
			Logger.log( "FB API error:" + error_message );
		}
		/**
		 * Gets a call id(string) and result object and sets into array the calls id queue. It run over this array and dispatches new events(COMPLETE)
		 * @param call_id
		 * @param result
		 * 
		 */		
		public function FBDataCallback( call_id:String, result:Object ):void{
			
			var listeners:Array = calls_queue[call_id];
			calls_queue[call_id] = null;
			for each( var result_func:Function in listeners )
				result_func( new EventTrans( Event.COMPLETE, result ) );
		}
		
	}
}
//the singleton private key
class FBCallManagerSKey {}