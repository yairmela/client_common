package playtiLib.utils.social.vk {
	
	import api.serialization.json.JSON;
	
	import flash.errors.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.utils.getTimer;
	
	import playtiLib.utils.tracing.Logger;
	
	public class VKDataProvider {
		
		public static const API_SERVER_URL					: String 	= "http://api.vkontakte.ru/api.php";
		public static const GET_VARIABLE					: String    = "getVariable";
		public static const GET_VARIABLES					: String    = "getVariables";
		public static const PUT_VARIABLE					: String    = "putVariable";
		public static const GET_MESSAGES					: String    = "getMessages";
		public static const SEND_MESSAGE					: String    = "sendMessage";
		public static const GET_HIGH_SCORES					: String 	= "getHighScores";
		public static const SET_USER_SCORE					: String 	= "setUserScore";
		public static const GET_USER_INFO					: String   	= "getUserInfo";
		public static const GET_SERVER_TIME					: String 	= "getServerTime";
		public static const IS_APP_USER						: String 	= "isAppUser";
		public static const GET_FRIENDS						: String 	= "getFriends";
		public static const GET_APP_FRIENDS					: String 	= "getAppFriends";
		public static const GET_GROUPS						: String 	= "getGroups";
		public static const GET_PROFILES					: String 	= "getProfiles";
		public static const GET_USER_SETTINGS				: String	= "getUserSettings";
		public static const GET_USER_BALANCE				: String	= "getUserBalance";
		public static const WALL_GET_PHOTOUPLOADSERVER		: String	= "wall.getPhotoUploadServer";
		public static const WALL_SAVE_POST					: String	= "wall.savePost";
		
		private var api_url:String ;    
		private var api_id: String;
		private var api_secret: String;
		private var viewer_id: String;
		private var test_mode: Boolean;
		
		private var calls_queue:Array = [];
		
		private var global_options: Object;
		
		
		
		public function VKDataProvider( api_id: String, api_secret:String, viewer_id:String, api_url:String, test_mode:Boolean = false ) {
			
			Logger.log( "DataProvider constructor arguments = " + arguments );
			ExternalInterface.addCallback( "onApiResponse", _onApiResponse )
			
			api_id     	= api_id;
			api_secret 	= api_secret;
			viewer_id  	= viewer_id;
			test_mode  	= test_mode;
			api_url	  	= api_url;
			if( !api_url )
				api_url 	= API_SERVER_URL;
			
		}
		
		private function _onApiResponse( call_id:String, response:Object ):void{
			
			var listeners:Array = calls_queue[call_id];
			calls_queue[call_id] = null;
			for each( var result_func:Function in listeners )
				result_func( response );
		}
		
		private function _ApiCall( call_id:String, method:String, request_params:Object ):void{
			
			ExternalInterface.call( "VK_api_call", method, call_id, request_params );
		}
		
		
		public function setup( options: Object ):void {
			
			global_options = options;
		}
		
		public function request( methodName:String, methodParams:Object, onCompleteFunc:Function, onErrorFunc:Function, isTestMode:Boolean= false ):void	{
			
			var request_option:Object 	= new Object;
			request_option.params 		= methodParams;
			request_option.onComplete 	= onCompleteFunc;
			request_option.onError 		= onErrorFunc;
			request_option.isTestMode 	= isTestMode || test_mode;
			_checkAndSendRequest( methodName, request_option );
		}
		
		private function _checkAndSendRequest( method:String, options:Object = null ):void {
			
			log( "request " + arguments );
			var onComplete: Function, onError: Function;
			if ( options == null ) 
				options = new Object();
			options.onComplete = options.onComplete ? options.onComplete : ( global_options.onComplete ? global_options.onComplete : null );
			options.onError = options.onError ? options.onError : ( global_options.onError ? global_options.onError : null );
			
			_sendRequest( method, options );
		}
		
		
		
		/********************
		 * Private methods
		 ********************/
		private function _sendRequest( method:String, options:Object ):void {
			
			log( "_sendRequest " + arguments + " _api_id = "+ api_id );
			
			var request_params: Object = {method: method};
			request_params.api_id = api_id;
			
			if( options.format )
				request_params.format = options.format;
			else
				request_params.format = "JSON";
			// TODO: temporary all requests sends in test mode
			if (options.isTestMode)  
				request_params.test_mode = "1";
			
			if (options.params) {
				for (var i: String in options.params) {
					request_params[i] = options.params[i];
				}
			}
			//TODO:need add error_handler 
			var complete_handler:Function = function( response:Object ):void{
													options.onComplete( response );
											};
			var call_id:String = method+_generate_signature_string( request_params );
			if( calls_queue[call_id] ) 
				calls_queue[call_id].push(complete_handler);
			else
				calls_queue[call_id] = [complete_handler];
			
			_ApiCall( call_id, method, request_params )
		}
		
		private function _generate_signature_string( request_params:Object ): String {
			
			var signature:String = "";
			var sorted_array: Array = new Array();
			for ( var key:Object in request_params ) {
				sorted_array.push( key + "=" + request_params[key] );
			}
			sorted_array.sort();
			
			// Note: make sure that the signature parameter is not already included in
			//       request_params array.
			for ( key in sorted_array ) {
				signature += sorted_array[key];
			}
			
			signature = viewer_id + signature + api_secret;
			return signature;
		}
		
		/**
		 * Generates signature
		 *
		 */
		private function _generate_signature( request_params:Object ): String {
			
			var signature:String = _generate_signature_string( request_params );
			log( "signature = " + signature );
			return MD5.encrypt( signature );
		}
		
		private function log( str:String="" ):void{
			
			Logger.log( "[DataProvider] " + str );
		}
	}
}