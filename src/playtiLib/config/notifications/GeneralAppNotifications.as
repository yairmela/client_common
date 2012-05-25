package playtiLib.config.notifications
{
	/**
	 * This class configures all the notifications that fired at Playtilib like: adding child notifications, loading data notifications,
	 * social channels notifications, popup handling notifications, sound notifications and more.
	 */	
	public class GeneralAppNotifications {
		
		public static const STARTUP:String 							= 'startup';
		public static const CLOSE:String 							= 'close';
		
		public static const START_APPLICATION:String				= 'start_application';
		//adding child
		public static const ADD_CHILD_TO_ROOT:String 				= 'add_child_to_root';
		public static const ADD_CHILD_TO_ROOT_AT:String 			= 'add_child_to_root_at';
		public static const ADD_CHILD_TO_ROOT_AT_BOTTOM:String 		= 'add_child_to_root_at_bottom';
		//loading data
		public static const LOAD_EXTERNAL_ASSETS:String 			= 'load_external_assets';
		public static const EXECUTE_EXTERNAL_CALL:String 			= 'execute_external_call';

		public static const LOAD_CUSTOM_PRELOADER_PROGRESS:String 	= 'load_custom_preloader_progress';
		public static const LOAD_CUSTOM_PRELOADER_COMPLETE:String 	= 'load_custom_preloader_complete';
		public static const LOAD_INITIAL_ASSETS_PROGRESS:String 	= 'load_lobby_progress';
		public static const LOAD_INITIAL_ASSETS_COMPLETE:String 	= 'load_initial_assets_complete';
		public static const INITIAL_DATA_LOADED:String 				= 'initial_data_loaded';
		public static const SHOW_LOADING_DIALOG_BY_NAME:String 		= 'show_loading_dialog_by_name';
		public static const SHOW_VERSION_NUMBER:String 				= 'show_version_number';

		//social channels
		public static const SOCIAL_REGISTER_COMMANDS	:String 	= 'social_register_commands';
		public static const SOCIAL_INIT_CONNECTIONS		:String 	= 'social_init_connections';
		public static const SOCIAL_GAME_INSTALL_CHECK	:String 	= 'social_game_install';
		public static const SOCIAL_INVITE_FRIENDS		:String	 	= 'social_invite_friends';

		public static const SOCIAL_API_INITIALIZE		:String 	= 'social_api_initialize';
		public static const SOCIAL_GAME_NOT_INSTALLED	:String 	= 'social_game_not_installed';
		public static const SOCIAL_GAME_SETTINGS_CHECK	:String 	= 'social_game_settings_check';
		public static const SOCIAL_GAME_SETTINGS_NOT_APPROVED:String= 'social_game_settings_not_approved';
		public static const SOCIAL_INSTALL_APPROVED:String 			= 'social_install_approved';
		public static const SOCIAL_LIKE_APP:String 					= 'social_like_app';
		public static const SOCIAL_LIKE_APP_CALLBACK:String 		= 'social_like_app_callback';
		public static const SOCIAL_LIKE_APP_DATA_READY:String 		= 'social_like_app_data_ready';
		public static const SET_PAUSE_POPUP_WITH_LOADING:String 	= 'set_pause_popup_with_loading';
		public static const SET_SOCIAL_BANNERS:String 				= 'social_set_banners';
		public static const SOCIAL_ACCEPT_SURPRISE_GIFT:String		= 'social_accept_surprise_gift';
		
		public static const FULLSCREEN_MODE:String 					= 'fullscreen_mode';
		public static const FRAMERATE_CHANGED:String 				= 'framerate_changed';

		//sounds
		public static const MUTE_SOUNDS:String 						= 'mute_sounds';
		//popup handling
		public static const SETUP_UI_DISPLAY:String 				= 'setup_ui_display';
		public static const OPEN_POPUP:String 						= 'open_popup';
		public static const SHOW_NEXT_POPUP:String 					= 'show_next_popup';
		public static const CLOSED_LAST_POPUP_IN_QUEUE:String 		= 'closed_last_popup_in_queue';
		public static const SET_PAUSE_POPUP:String 					= 'set_pause_popup';
		public static const SYSTEM_MSG_POPUP:String 				= 'set_system_msg_popup';
		public static const SYSTEM_ERROR:String 					= 'system_error';
		//toolTip commands
		public static const TOOLTIP_ROLL_EVENT:String 				= 'tooltip_roll_event';
		//server commands
		public static const SERVER_LOGIN_COMPLETE:String 			= 'server_login_complete';
		public static const SERVER_RELOGIN : String					= "server_relogin";
		public static const SERVER_RELOGIN_COMPLETE : String		= "server_relogin_complete";
		public static const SERVER_FAULT : String					= "server_fault";
		public static const SERVER_FAULT_HANDLED : String			= "server_fault_handled";
		//user handle commands
		public static const REGISTER_NEW_USER:String 				= 'register_new_user';
		public static const UPDATE_USER_INFO:String 				= 'update_user_info';
		public static const BALANCE_CHANGED:String 					= 'balance_changed';
		public static const SETTINGS_CHECK:String 					= 'settings_check';
		
		//tasks update command
		public static const UPDATE_TASKS_INFO:String 				= 'update_tasks_info';
		//pay page handlers
		public static const OPEN_PAY_PAGE:String 					= 'open_pay_page';
		public static const PAYTABLE_DATA_READY:String 				= 'paytable_data_ready';
		public static const CLOSE_PAYPAGE:String 					= 'close_paypage';

		public static const PUBLISH_TO_WALL_COMMAND:String 			= 'publish_to_wall_command';
		public static const PUBLISH_TO_WALL_APPROVED:String			= 'publish_to_wall_approved';
		public static const PUBLISH_TO_WALL_COMPLETE:String 		= 'publish_to_wall_complete';
		public static const PUBLISH_TO_WALL_CANCEL:String 			= 'publish_to_wall_cancel';
		public static const PUBLISH_GIFT_COMMAND:String 			= 'publish_gift_command';
		public static const PUBLISH_GIFT_COMPLETE:String 			= 'publish_gift_complete';

		public static const BUY_SELECTED_AMOUNT:String 				= 'buy_selected_amount';
		public static const CHECK_BUY_STATUS:String 				= 'check_buy_status';
		public static const BUY_RESULT:String 						= 'buy_result';
		//user handling
		public static const USER_DATA_READY:String 					= 'user_data_ready';
		
		public static const CHOOSE_SN_USER:String 					= 'choose_sn_user';
		public static const CHOOSE_SN_USER_COMPLETE:String 			= 'choose_user_sn_complete';
		public static const CHOOSE_SN_USER_DATA_READY:String 		= 'choose_user_data_ready';
		//game gifts popup
		public static const OPEN_SEND_GIFT_POPUP:String 			= 'show_send_gift_popup';

		public static const REFRESH_IFRAME:String 					= 'refresh_iframe';
		public static const RETRY_SERVER_CONNECTION:String 			= 'retry_server_connection';
		//enter frame for games heart beat
		public static const ENTER_FRAME:String 						= 'enter_frame';

		public static const COUPON_SYSTEM_UNAVAILABLE:String 		= 'coupon_system_unavailable';
		
		public static const LOAD_USER_GIFTS_FROM_GCP_HANDLER:String = 'load_user_gifts_from_gcp_handler';
		public static const REJECT_COUPON:String					= 'reject_coupon';
		public static const REJECT_COUPON_CONFIRM:String 			= 'reject_coupon_confirm';
		public static const REJECT_COUPON_CANCEL:String 			= 'reject_coupon_cancel';

		public static const OPEN_GIFT_COLLECTION_POPUP:String		= 'open_gift_collection_popup';
		public static const ADD_APP_REQUEST:String 					= 'add_app_request';
		public static const REMOVE_APP_REQUEST:String 				= 'remove_app_request';
		public static const OPEN_FREE_SPINS_COLLECTION_POPUP:String = 'open_free_spins_collection_popup';
		public static const SHOW_STATUS_GIFT_MSG:String 			= 'show_status_gift_msg';
		//request data
		public static const REQUESTS_DATA_RECEIVED:String 			= 'requests_data_received';
		public static const REQUEST_DATA_RECEIVED:String 			= 'request_data_received';
		public static const REQUEST_GET_GIFT_DATA:String 			= 'request_get_gift_data';
		//coupons
		public static const COUPON_REMOVED:String 					= 'coupon_removed';
		public static const COUPON_COLLECTED:String 				= 'coupon_collected';
		public static const COUPON_BACKED:String 					= 'coupon_backed';
		public static const COLLECT_SYSTEM_TO_USER_COUPON:String 	= 'collect_system_to_user_coupon';
		public static const COLLECT_FREE_SPIN_COUPON:String 		= 'collect_free_spin_coupon';
		public static const COLLECT_COINS_COUPON:String 			= 'collect_coins_coupon';
		public static const COUPON_POST_COMPLETE:String 			= 'coupon_post_complete';
		public static const COUPON_SEND_COMPLETE:String 			= 'coupon_send_complete';
		public static const SHOW_INVALID_COUPONS_POPUP:String 		= 'show_invalid_coupons_popup';
		public static const CHOOSE_GIFT_COMPLETE:String 			= 'choose_gift_complete';
		public static const CREATE_COUPON_NOTIFICATION:String		= 'create_coupon_notification'
		public static const SHOW_SYSTEM_COUPON:String 				= 'show_system_coupon';
		public static const COLLECT_COUPON_COMMAND:String 			= 'collect_coupon_command';
		public static const PRE_COLLECT_COUPON_COMMAND:String 		= 'pre_collect_coupon_command';
		public static const SEND_COUPON_COMMAND:String   			= 'send_coupon_comman';
		public static const SOCIAL_API_ERROR:String 				= '_social_API_error';
		public static const AFTER_COLLECT_COUPON_COMMAND:String		= 'after_collect_coupon_command';
		public static const VALIDATION_COUPON_COMMAND:String		= 'validation_coupon_command';
		public static const CHOOSE_GIFT_FROM_MEDIATOR_COMMAND:String= 'choose_gift_from_mediator_command';
		public static const LOAD_SOCIAL_REQUESTS:String				= 'load_social_requests';
		public static const GET_AND_VALIDATE_COUPONS:String 		= 'get_and_validate_coupons';
		public static const USER_COUPON_DATA_READY:String 			= 'user_coupons_data_ready';
		public static const TODAY_RECEIVERS_READY:String 			= 'today_receivers_ready';
		public static const CLEANUP_COUPONS_COMMAND:String 			= 'clean_up_coupons_command';
		public static const SYSTEM_TO_USER_COUPON_COLLECTION:String = 'system_to_user_coupon_collection';
		public static const GET_TODAY_RECEIVERS_COMMAND:String 		= 'get_today_receivers_command';
		public static const OPEN_SYSTEM_TO_USER_POPUP:String 		= 'open_system_to_user_popup';
		public static const UPDATE_TODAY_RECEIVERS:String 			= 'update_today_receivers';
		public static const SEND_COUPON_TO_FAKE_USERS:String 		= 'send_coupon_to_fake_users';
		public static const CREATE_EVENT_COUPON_COMMAND:String 		= 'create_event_coupon_command';
		public static const SHARE_EVENT_COUPON_COMMAND:String 		= 'share_event_coupon_command';
		public static const CREATE_COUPON:String 					= 'create_coupon';		
		

		public static const ON_SEND_BTN_CLICK:String				= 'on_send_btn_click';

		
		//tasks
		public static const GET_TASKS_COMMAND:String				= 'get_tasks_command';
		public static const TASK_HANDLER:String						= 'task_handler';
		//localization
		public static const LOAD_NEW_LOCALE_CONTENT:String 			= 'load_new_locale_content';
		public static const LOCALE_CONTENT_LOADED:String 			= 'locale_content_loaded';

		public static const TRACK:String 							= 'track_statistics';
		//user social info loading
		public static const USER_SOCIAL_INFO_READY:String 			= 'user_social_info_ready';
		public static const USER_SOCIAL_INFO_HAS_INVALIDATE_DATA:String	= 'user_social_info_has_invalidate_data';
		public static const LOAD_USER_SOCIAL_INFO_EVENT:String 		= 'load_user_social_info_event';
		public static const UPDATE_GIFT_ON_SCOREBOARD_EVENT:String 	= 'update_gift_on_scoreboard_event';
		public static const INIT_FIRST_LOGIN_ARROWS:String 			= 'init_first_login_arrows';
		public static const CANCEL_SHARE_POPUP_COMMAND:String 		= 'cancel_share_popup_command';
		public static const APPROVE_SHARE_POPUP_COMMAND:String 		= 'aprove_share_popup_command';

		public static const ENGINE_PRELOADER_PROGRESS:String 		= 'engine_preloader_progress';
		
		public static const OPEN_URL:String							= 'open_url';
		public static const CLOSE_POPUP:String						= 'close_popup';
		public static const SHOW_GAME_TAB_COMMAND:String			= 'show_game_tab_command';
		public static const SHOW_GIFTS_TAB_COMMAND:String			= 'show_gifts_tab_command';
		public static const SHOW_INVITE_TAB_COMMAND:String			= 'show_invite_tab_command';
		public static const INVITE_REQ_DATA_READY_COMMAND:String	= 'inite_req_data_ready_command';
		public static const GIFTS_REQ_DATA_READY_COMMAND:String		= 'gifts_req_data_ready_command';
		public static const UPDATE_AFTER_SOCIAL_REQ_SENT:String		= 'update_after_social_req_sent';
		public static const OPEN_SOCIAL_INVITE_FRIENDS_DIALOG:String= 'open_social_invite_friends_dialog';
		public static const CLOSE_INVITE_PROXY:String				= 'close_invite_proxy';
		public static const CLOSE_SEND_GIFTS_PROXY:String			= 'close_send_gifts_proxy';
		public static const INIT_ARENAS_PROXY_COMMAND:String		= 'init_arenas_proxy_command';
		
		/*wmode*/
		public static const EXPORT_SCREENSHOT:String				= 'export_screenshot';
		public static const SCREENSHOT_MADE:String					= 'screenshot_made';
		
		/*deal spot*/
		public static const DEAL_SPOT_READY:String					= 'deal_spot_ready';
		public static const SET_DEAL_SPOT:String					= 'set_deal_spot';
		public static const HIDE_DEAL_SPOT:String					= 'hide_deal_spot';
	}
}
