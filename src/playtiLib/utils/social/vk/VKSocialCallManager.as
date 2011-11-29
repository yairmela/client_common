package playtiLib.utils.social.vk
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.utils.core.ObjectUtil;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.server.IServerManager;
	import playtiLib.utils.tracing.Logger;
	
	public class VKSocialCallManager extends EventDispatcher implements IServerManager {
		
		private var on_result_func:Function, on_io_error_func:Function;
		
		public function VKSocialCallManager()	{
			
			super();
		}
		
		public function send( server_path:String, module:String, command:String, params:Object, on_result_func:Function, on_io_error_func:Function ):void {
			
			this.on_result_func = on_result_func;
			this.on_io_error_func = on_io_error_func;
			switch( command ) {
				case SocialCallsConfig.SOCIAL_USER_INFO_COMMAND_NAME:
					VKRequestsQueue.addRequest( VKDataProvider.GET_PROFILES, params, onDataProviderComplete, onDataProviderError );
					break;
				case SocialCallsConfig.SOCIAL_FRIENDS_COMMAND_NAME:
					VKRequestsQueue.addRequest( VKDataProvider.GET_FRIENDS, params, onDataProviderComplete, onDataProviderError );
					break;
				case SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS_COMMAND_NAME:
					VKRequestsQueue.addRequest( VKDataProvider.GET_APP_FRIENDS, params, onDataProviderComplete, onDataProviderError );
					break;
				case SocialCallsConfig.SOCIAL_GET_GROUPS_COMMAND_NAME:
					VKRequestsQueue.addRequest( VKDataProvider.GET_GROUPS, params, onDataProviderComplete, onDataProviderError );
					break;
				case SocialCallsConfig.SOCIAL_BALANCE_COMMAND_NAME:
					VKRequestsQueue.addRequest( VKDataProvider.GET_USER_BALANCE, params, onDataProviderComplete, onDataProviderError );
					break;
				case SocialCallsConfig.SOCIAL_GET_PHOTO_UPLOAD_SERVER_COMMAND_NAME:
					VKRequestsQueue.addRequest( VKDataProvider.WALL_GET_PHOTOUPLOADSERVER, params, onDataProviderComplete, onDataProviderError );
					break;
				case SocialCallsConfig.SOCIAL_WALL_SAVE_POST_COMMAND_NAME:
					VKRequestsQueue.addRequest( VKDataProvider.WALL_SAVE_POST, params, onDataProviderComplete, onDataProviderError );
					break;
			}
		}
		
		private function onDataProviderComplete( responseObject:Object ):void	{
			
			Logger.log( "VKSocialCallManager onDataProviderComplete " + ObjectUtil.propertiesToString( responseObject ) );
			on_result_func( new EventTrans( Event.COMPLETE, responseObject ) );
		}
		
		private function onDataProviderError( responseObject:Object ):void{
			
			Logger.log( " onDataProviderError " + responseObject.error_code + " " + responseObject.error_msg );
			//on_io_error_func();
		}	
		
	}
}