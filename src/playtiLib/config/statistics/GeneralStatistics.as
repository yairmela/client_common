package playtiLib.config.statistics
{
	/**
	 * This class configures the main statistics in playtilib( assets, buy and pay, erors, sounds, startup ).
	 */	
	public class GeneralStatistics	{
		
		//assets
		public static const INITIAL_ASSETS_LOAD_START:String 				= 'initial_assets_load_start';
		public static const INITIAL_ASSETS_LOAD_CONFIG_COMPLETE:String	 	= 'initial_assets_load_config_complete';
		public static const INITIAL_ASSETS_PRELOADER_READY:String 			= 'initial_assets_preloader_ready';
		public static const INITIAL_ASSETS_READY:String 					= 'initial_assets_ready';
		//buy and pay
		public static const OPEN_PAY_PAGE:String 							= 'open_pay_page';
		public static const BUY_TRANSACTION_SUCCESS:String 					= 'buy_transaction_success';
		public static const BUY_TRANSACTION_CANCEL:String 					= 'buy_transaction_cancel';
		public static const BUY_TRANSACTION_NOT_ENOUGH_MONEY:String 		= 'buy_transaction_not_enough_money';
		public static const BUY_TRANSACTION_ERORR:String 					= 'buy_transaction_erorr';
		public static const OPEN_PAY_PAGE_AFTER_TRANSACTION_ERROR:String 	= 'open_pay_page_after_transaction_error';
		public static const REJECT_PAY_PAGE_AFTER_TRANSACTION_ERROR:String 	= 'reject_pay_page_after_transaction_error';
		public static const REFRESH_IFRAME_AFTER_SYSTEM_MSG:String 			= 'refresh_iframe_after_system_msg';
		//erors
		public static const ERROR_FROM_SERVER:String 						= 'error_from_server';
		public static const ERROR_SYSTEM:String 							= 'error_system';
		
		public static const OPEN_INVITE_FRIENDS_DIALOG:String 				= 'open_invite_friends_dialog';
		//sounds
		public static const MUTE_SOUNDS:String 								= 'mute_sounds';
		public static const MUTE_SOUNDS_CANCEL:String 						= 'mute_sounds_cancel';
		//startup
//		public static const REGISTER_NEW_USER:String 						= 'traking_register_new_user';
		public static const START_PLAYING_GAME:String 						= 'start_playing_game';
		
		public static const PUBLISH_TO_WALL_COMPLETE:String					= 'publish_to_wall_complete';
		public static const INVITE_SENT:String								= 'invite_sent';
		public static const APP_REGISTERED:String							= 'app_registered';
		public static const USER_INFO:String								= 'user_info';
		public static const LOADED_FROM_FEED:String							= 'loaded_from_feed';
		public static const LOADED_FROM_INVITE:String						= 'loaded_from_invite';
		public static const MENU_TAB_SELECT:String							= 'menu_tab_select';
		public static const USER_LOGIN:String								= 'user_login';
	}
}