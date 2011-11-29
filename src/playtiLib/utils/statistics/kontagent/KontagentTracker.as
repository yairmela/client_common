package playtiLib.utils.statistics.kontagent
{
	import com.adobe.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.config.statistics.KontagentConfig;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.utils.core.DateUtil;
	import playtiLib.utils.statistics.ISpecificTracker;
	import playtiLib.utils.statistics.TrackSnapshot;

	/**
	 * This class should have only one instance (singletone). It handles the sending of data to
	 * track the user's actions like: login, start game, spin result, end game bonuses, open lobby, 
	 * buy coins, sending invitation, loggin from invitation, trackin the user info and more.
	 * It used mostly in the Tracker class. 
	 */
	public class KontagentTracker implements ISpecificTracker
    {
		static public const NAME : String = "KontagentTracker";
		
		static private var instance:KontagentTracker;

//		private var user_id : String;
		/**
		 * Static function that returns the singleton KontagentTracker
		 * @return 
		 * 
		 */
		static public function getInstance() : KontagentTracker	{
			
			if( !instance ) {
				instance = new KontagentTracker();
			}

			return instance;
		}

		public function KontagentTracker() {
		}
			
//		/**
//		 * Function that sets the user's id and the user's account type 
//		 * @param userId
//		 * @param accountType
//		 * 
//		 */
//		public function init( userId:String ):void {
//			user_id = userId;
//		}
		/**
		 * Function that does actual tracking.
		 * @param eventName
		 * @param snapshot
		 * 
		 */
		public function track(eventName:String, snapshot:*):void {
			
//			if( !isSnapshotSufficient(snapshot) ) {
//				return;
//			}
			
			switch(eventName) {
				case GeneralStatistics.USER_LOGIN:
					trackLogin(snapshot.flash_vars.viewer_id);
					break;
			
				case GeneralStatistics.APP_REGISTERED:
					trackAppRegistered(snapshot.flash_vars.viewer_id,
									   snapshot.flash_vars.upc_c,
									   snapshot.flash_vars.pid_c);
					break;
				
				case GeneralStatistics.INVITE_SENT:
					trackInviteSent(snapshot.flash_vars.viewer_id,
									snapshot.invite_data.event_type,
									snapshot.invite_data.users_list,
									snapshot.invite_data.pid,
									snapshot.invite_data.crt);
					break;
				
				case GeneralStatistics.LOADED_FROM_INVITE:
					trackLoadedFromInvite(snapshot.flash_vars.viewer_id,
										  snapshot.flash_vars.et,
										  snapshot.app_installed,
										  snapshot.flash_vars.pid,
										  snapshot.flash_vars.crt);
					break;
					
				case GeneralStatistics.PUBLISH_TO_WALL_COMPLETE:
					trackFeedPublished(snapshot.flash_vars.viewer_id,
									   snapshot.publish_data.event_type,
									   snapshot.publish_data.pid,
									   snapshot.publish_data.crt);
					break;
					
				case GeneralStatistics.LOADED_FROM_FEED:
					trackLoadedFromFeed(snapshot.flash_vars.viewer_id,
										snapshot.flash_vars.et,
										snapshot.app_installed,
										snapshot.flash_vars.pid,
										snapshot.flash_vars.crt);
					break;				
				
				case GeneralStatistics.OPEN_PAY_PAGE:
					trackBuyCoins(snapshot.flash_vars.viewer_id,
								  snapshot.user_level.level,
								  snapshot.flash_vars.account_type,
								  snapshot.buy_type);
					break;
				
				case GeneralStatistics.BUY_TRANSACTION_SUCCESS:
					trackCoinsBought(snapshot.flash_vars.viewer_id,
									 snapshot.user_level.level,
									 snapshot.flash_vars.account_type,
									 snapshot.transaction.cost);
					break;
				
				case GeneralStatistics.MENU_TAB_SELECT:
					trackMenu(snapshot.flash_vars.viewer_id,
							  snapshot.menu_type);
					break;
				
				case GeneralStatistics.USER_INFO:
					trackUserInfo(snapshot.flash_vars.viewer_id,
								  snapshot.user_info.gender,
								  snapshot.user_info.userBirthday,
								  snapshot.friends_count);
					break;
			}
		}
		
		// TODO: to be removed after QA confirmed it is not necessary to do the check
//		protected function isSnapshotSufficient(snapshot : *):Boolean
//		{
//			return (snapshot.user != null);
//		}

		private function trackLogin( user_id:String ):void {
			
			sendData(KontagentConfig.MESSAGE_TYPE_PAGE_REQUEST, {s: user_id, ts: DateUtil.toW3CDTF( new Date() )});
		}

		/**
		 * Function that sends data for tracking the buying coins action. It contains the user level
		 * and the buy type. It is for open the payment page. 
		 * @param userLevel
		 * @param buyType
		 * 
		 */
		private function trackBuyCoins( user_id:String, user_level:uint, account_type:String, buy_type:String ):void{
			
			sendData( KontagentConfig.MESSAGE_TYPE_CUSTOM_EVENT, {s: user_id, n: "PAYMENT_PAGE_OPEN", l: user_level, st1: account_type, st2: buy_type} );
		}
		/**
		 * Function that sends data for tracking the buying coins action. It contains the user level
		 * and the buy type. It used after the payment page buy clicked
		 * @param userLevel
		 * @param amount
		 * 
		 */
		private function trackCoinsBought( user_id:String, user_level:uint, account_type:String, amount:Number ):void	{
			
			sendData( KontagentConfig.MESSAGE_TYPE_CUSTOM_EVENT, {s:user_id, n:"PAYMENT_PAGE_BUY_CLICKED", l:user_level, st1:account_type, st2:amount} );
		}
		/**
		 * Function that sends data for tracking top menu when user click of one of it
		 * @param menuType
		 * 
		 */
		private function trackMenu( user_id:String, menu_type:String ):void {
			
			sendData( KontagentConfig.MESSAGE_TYPE_CUSTOM_EVENT, {s:user_id, n:menu_type} );
		}
		/**
		 * Function that sends data for tracking the application registration. It uses MD5 encyption
		 * function and sends it for tracking.
		 * @param src
		 * @param pid
		 * 
		 */
		private function trackAppRegistered( user_id:String, upc:String, pid:String = null ):void{
			
			var params : Object =  {s: user_id};
			
			if(pid) {
				params["u"] = formatPid(pid);
			}
			else {
				params["su"] = upc;
			}
			
			sendData( KontagentConfig.MESSAGE_TYPE_APPLICATION_ADDED, params );
		}
		/**
		 * Function that sends data for tracking the invitation sending. It contains the users list, 
		 * the event's type.
		 * @param eventType
		 * @param usersList
		 * @param pid
		 * @param crt
		 * 
		 */
		private function trackInviteSent( user_id:String, event_type:String, users:String, pid:String, crt:String ):void	{
			
			sendData( KontagentConfig.MESSAGE_TYPE_INVITE_SENT, {s:user_id, r:formatUsersList(users), u:formatPid( pid ), st1:event_type, st2:crt} );
		}

		/**
		 * Function that sends data for tracking when the appliction is loaded from invitation.
		 * It contains variables like: event's type, if the appliction has been installed or not.
		 * @param event_type
		 * @param appInstalled
		 * @param pid
		 * @param crt
		 * 
		 */
		private function trackLoadedFromInvite( user_id:String, event_type:String, appInstalled:Boolean, pid:String, crt:String ):void{

			sendData( KontagentConfig.MESSAGE_TYPE_INVITE_RESPONSE, {r: user_id, i: int( appInstalled ), u: formatPid( pid ), st1: event_type, st2: crt} );
		}
		/**
		 * Function that sends data for tracking after something published on the wall. 
		 * @param event_type
		 * @param pid
		 * @param crt
		 * 
		 */
		private function trackFeedPublished( user_id:String, event_type:String, pid:String, crt:String ):void {
			
			sendData( KontagentConfig.MESSAGE_TYPE_STREAM_POST, {s:user_id, tu:"stream", u:formatPid( pid ), st1:event_type, st2:crt} );
		}

		private function trackLoadedFromFeed( user_id:String, event_type:String, app_installed:Boolean, pid:String, crt:String ):void	{
			
			sendData( KontagentConfig.MESSAGE_TYPE_STREAM_POST_RESPONSE, {r: user_id, i: int(app_installed), u: formatPid(pid), tu: "stream", st1: event_type, st2: crt} );
		}

		private function trackUserInfo( user_id:String, user_sex:int, birthday_at:String, friends_count:int = 0 ): void{
			
			var params : Object = {s:user_id, g:getGender(user_sex)};

			if( birthday_at ) {
				var date : Date = new Date();
				date.setTime( Date.parse(birthday_at) );
				
				var birthdayYear:Number = date.fullYearUTC;
				
				if( !isNaN( birthdayYear ) ) {
					params["b"] = birthdayYear;
				}
			}
			//TODO: can we delete this??
		// Temporaly commented
		/*	if (country_id){
				params["lc"] = country_id.toUpperCase();
			}else{
				if(userVO.country_id) {
					params["lc"] = userVO.country_id.toUpperCase();
				}
			}
			if(userVO.country_id) {
				params["lc"] = userVO.country_id.toUpperCase();
			}
			*/
			if( friends_count > 0 ) {
				params["f"] = friends_count;
			}
			
			sendData( KontagentConfig.MESSAGE_TYPE_USER_INFORMATION, params );

			function getGender( sex:int ):String{
				
				switch( sex ) {
					case 1: 
						return "f";
					case 2: 
						return "m";
					default: 
						return "u";
				}
			}
		}
		/**
		 * Function that sends data for tracking when there is a revenue. It has information lik:
		 * value of the revenue, the payment provider and user id. 
		 * @param value
		 * @param paymentProvider
		 * 
		 */
		// TODO: use instead of current client task implementation
		private function trackRevenue( user_id:String, value:Number, payment_provider:String ):void {
			
			var params:Object = {s:user_id, st1:payment_provider};

			if( !isNaN( value ) ) {
				params["v"] = int( value * 100 );
			}

			sendData( KontagentConfig.MESSAGE_TYPE_REVENUE_TRACKING, params );
		}
		/**
		 * A main function in KontagentTracker class. It opens a new url reauest for the object we
		 * want to send, opens a new url loader, load the request(the passed object) and waits for 
		 * complete event.
		 * @param messageType
		 * @param params
		 * 
		 */
		protected function sendData( messageType:String, params:Object ):void	{
			
			validateParams(params);
			
			var request:URLRequest = new URLRequest( getRequestURL( messageType, params ) );
			request.contentType = "application/x-www-form-urlencoded";

			var loader:URLLoader = new URLLoader();

//			loader.addEventListener( Event.COMPLETE, onComplete );
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

			loader.load( request );
			
			function onError(event:Event):void {
				
				if(ExternalInterface.available) {
					ExternalInterface.call("generatePixelIframe", request.url);
				}
			}
		}
		
//		private function onComplete( event:Event ):void	{			
//		}
		
		protected function validateParams( params : Object ) : void {
			
			for(var field : String in params) {
				switch(params[field]) {
					case null:
					case "":
					case "null":
					case undefined:
					case NaN:
						delete params[field];
				}
			}
		}

		protected function getRequestURL( messageType:String, params:Object ):String	{
			
			var arr : Array = [];

			for( var field : String in params ) {
				arr.push( field + "=" + params[field] );
			}

			return KontagentConfig.server_path + "/" + KontagentConfig.api_key + "/" + messageType + "/?" + arr.join( "&" );
		}

		protected function formatPid( pid:String ):String {
			
			if( (pid == null) || (pid == "null") ) {
				return "";
			}
			
			pid = pid.substr( 0, 16 );
			while( pid.length < 16 ) {
				pid += "0";
			}

			return pid;
		}
		
		protected function formatUsersList( users:String ):String {
			
			var users_list : Array = users.split(",");
			users_list.forEach( trimUserIds );
			
			return users_list.join( "%2C" );
			
			function trimUserIds( item:*, index:int, arr:Array ):void  {
				
				arr[index] = StringUtil.trim( item );
			}
		}
	}
}
