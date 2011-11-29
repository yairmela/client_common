package playtiLib.utils.social.simulate
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.server.IServerManager;
	
	public class SimulateSocialCallManager extends EventDispatcher implements IServerManager{
		
		public function SimulateSocialCallManager( target:IEventDispatcher=null )	{
			
			super( target );
		}
		/**
		 * Handles few complete social calls by dispatching an apropriate events.   
		 * @param module
		 * @param command
		 * @param params
		 * @param on_result_func
		 * @param on_io_error_func
		 * 
		 */		
		public function send( server_path:String, module:String, command:String, params:Object, on_result_func:Function, on_io_error_func:Function ):void {
			
			switch( command ) {
				case SocialCallsConfig.SOCIAL_USER_INFO_COMMAND_NAME:
				case SocialCallsConfig.SOCIAL_FRIENDS_COMMAND_NAME:
				case SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS_COMMAND_NAME:
				case SocialCallsConfig.SOCIAL_GET_GROUPS_COMMAND_NAME:
				case SocialCallsConfig.SOCIAL_BALANCE_COMMAND_NAME:
					dispatchEvent( new EventTrans( Event.COMPLETE, [] ) );
					break;
			}
		}
	}
}