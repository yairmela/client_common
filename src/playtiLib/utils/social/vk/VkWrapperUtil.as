package playtiLib.utils.social.vk
{
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.tracing.Logger;

	public class VkWrapperUtil extends EventDispatcher	{
		
		public static const EVENT_onApplicationAdded		:String = "onApplicationAdded";
		public static const EVENT_onSettingsChanged			:String = "onSettingsChanged";
		public static const EVENT_onBalanceChanged			:String = "onBalanceChanged";
		public static const EVENT_onMerchantPaymentCancel	:String = "onMerchantPaymentCancel";
		public static const EVENT_onMerchantPaymentSuccess	:String = "onMerchantPaymentSuccess";
		public static const EVENT_onMerchantPaymentFail 	:String = "onMerchantPaymentFail";
		public static const EVENT_onProfilePhotoSave 		:String = "onProfilePhotoSave";
		public static const EVENT_onWallPostSave			:String = "onWallPostSave";
		public static const EVENT_onWallPostCancel			:String = "onWallPostCancel";
		public static const EVENT_onWindowResized			:String = "onWindowResized";
		public static const EVENT_onLocationChanged			:String = "onLocationChanged";
		public static const EVENT_onWindowBlur				:String = "onWindowBlur";
		public static const EVENT_onWindowFocus				:String = "onWindowFocus";
		public static const EVENT_onScrollTop				:String = "onScrollTop";
		 
		public static const CALL_METHOD_NAME 				:String = "VK_callMethod";
		public static const SHOW_INSTALL_BOX 				:String = "showInstallBox";
		public static const SHOW_SETTINGS_BOX 				:String = "showSettingsBox";
		public static const SHOW_INVITE_BOX 				:String = "showInviteBox";
		public static const SHOW_PAYMENT_BOX 				:String = "showPaymentBox";
		public static const RESIZE_WINDOW	 				:String = "resizeWindow";
		public static const SAVE_WALL_POST	 				:String = "saveWallPost";
		
		public static const PERMISSIONS_NOTIFICATIONS		:uint = 1;
		public static const PERMISSIONS_FRIENDS				:uint = 2;
		public static const PERMISSIONS_PHOTOS				:uint = 4;
		public static const PERMISSIONS_AUDIO				:uint = 8;
		public static const PERMISSIONS_PROPOSITIONS		:uint = 32;
		public static const PERMISSIONS_QUESTIONS			:uint = 64;
		public static const PERMISSIONS_WIKI_PAGES			:uint = 128;
		public static const PERMISSIONS_SIDE_BAR_MENU		:uint = 256;
		public static const PERMISSIONS_POST_ON_WALL		:uint = 512;
		
		private static var instance:VkWrapperUtil;
		//these 2 functions (openInstall and openSettings have restriction of once in 3 seconds)
		//we save the time to ovveride this restriction using setTimeOut
		private static const open_box_min_time:int = 3000;
		private var last_box_open_time:int = 0;
		
		
		public static function getInstance(): VkWrapperUtil {
			
			if ( instance == null ) {
				instance = new VkWrapperUtil();
			}
			return instance as VkWrapperUtil;
		}
		
		public function init():void{
			
			addListeners();			
			ExternalInterface.call( "VKinit" );
		}
		/**
		 * return is allowed permisions from aSettingsArr or not
		 * */
		public function analizeSettingNumber( numForCheck:uint, aSettingsArr:Array ):Boolean	{
			
			var is_allowed:Boolean = true;
			for( var i:uint = 0; i < aSettingsArr.length; i++ )
			{
				if((numForCheck & aSettingsArr[i]) == 0)
					is_allowed = false;
			}
			log( "isPermisionsAllowed isAllowed=" + is_allowed+ " settings " + aSettingsArr );
			return is_allowed;
		}
		
		//Call JS mathod*************************************************************
		private function jsCallMethod( ...args ):void{
			
			var open_time:int = getTimer();
			if( last_box_open_time > 0 && ( open_time-last_box_open_time ) < open_box_min_time ){
				setTimeout( jsCallMethod, open_box_min_time-(open_time-last_box_open_time), args[0], args[1], args[2], args[3], args[4] );
				return;
			}
			ExternalInterface.call( CALL_METHOD_NAME, args[0], args[1], args[2], args[3], args[4] );
		}
		//***************************************************************************
		/**
		 * Function that call the JS method to show install box. 
		 * 
		 */		
		public  function showInstallBox():void	{
			
			jsCallMethod( SHOW_INSTALL_BOX );
		}
		
		/**
		 * permisions for aPermisions should be taken from static constance of this class
		 * */
		public function showSettingsBox( aPermisions:Array = null ):void{
			
			var permisions:uint = 0;
			if(aPermisions)
				for( var i:uint = 0; i < aPermisions.length; i++ )
					permisions += aPermisions[i];
			
			log( "showSettingsBox permisions requierd= " + permisions );
			jsCallMethod( SHOW_SETTINGS_BOX, permisions );
		}
		/**
		 * Function that calls the JS method to show invite box. 
		 * 
		 */		
		public function showInviteBox():void{
			
			jsCallMethod( SHOW_INVITE_BOX );
		}
		/**
		 * Function that calls the JS method to show payment box. It also logs this action.
		 */
		public function showPaymentBox( countOfVoices:uint = 0 ):void	{
			
			log( "showPaymentBox countOfVoices "  + countOfVoices );
			jsCallMethod( SHOW_PAYMENT_BOX, countOfVoices );
		}
		/**
		 * Function that opens or replaces a window in the application that contains the Flash Player container (usually a browser). 
		 */		
		public function navigateToURL_byVkContainer( request:URLRequest, window:String = null ):void{
			
			navigateToURL( request, window );
		}
		/**
		 * Function that call the JS method to resuze the window's widht and height. It also logs this action. 
		 * @param width
		 * @param height
		 * 
		 */		
		public function resizeWindow( width:uint, height:uint ):void	{
			
			log( "resizeWindow width = " + width + "  height = " + height );
			jsCallMethod( RESIZE_WINDOW, width, height );
		}
		/**
		 * Function that gets a string call the JS method (by the jsCallMethod function) to save wall post. 
		 * @param hash
		 * 
		 */		
		public function saveWallPost( hash:String ):void	{
			
			jsCallMethod( SAVE_WALL_POST, hash );
		}
		/**
		 * Function that adds all the external interface call back. 
		 * 
		 */		
		private function addListeners():void{
			
			ExternalInterface.addCallback( EVENT_onApplicationAdded, onVKEvent );
			ExternalInterface.addCallback( EVENT_onSettingsChanged, onVKEvent );
			ExternalInterface.addCallback( EVENT_onBalanceChanged, onVKEvent );
			ExternalInterface.addCallback( EVENT_onMerchantPaymentCancel, onVKEvent );
			ExternalInterface.addCallback( EVENT_onMerchantPaymentSuccess, onVKEvent );
			ExternalInterface.addCallback( EVENT_onMerchantPaymentFail, onVKEvent );
			ExternalInterface.addCallback( EVENT_onProfilePhotoSave, onVKEvent );
			ExternalInterface.addCallback( EVENT_onWallPostSave, onVKEvent );
			ExternalInterface.addCallback( EVENT_onWallPostCancel, onVKEvent );
			ExternalInterface.addCallback( EVENT_onWindowResized, onVKEvent );
			ExternalInterface.addCallback( EVENT_onLocationChanged, onVKEvent );
			ExternalInterface.addCallback( EVENT_onWindowBlur, onVKEvent );
			ExternalInterface.addCallback( EVENT_onWindowFocus, onVKEvent );
		}
		/**
		 * Function that handles the call back of the external interface. If the type is equal to EVENT_onWindowFocus, it gets timer.
		 * It logs the type of the event and dispatch an event (EventTrans) with the type.
		 * @param type
		 * @param args
		 * 
		 */		
		public function onVKEvent( type:String, ...args ):void {
			
			if ( type == EVENT_onWindowFocus ){
				last_box_open_time = getTimer();
			}
			log( type );
			dispatchEvent( new EventTrans( type, args ) );
		}
		
		private function log( str:String="" ):void{
			
			Logger.log( "[VkWrapperUtil] " + str );
		}
	}
}