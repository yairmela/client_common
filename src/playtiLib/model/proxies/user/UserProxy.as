package playtiLib.model.proxies.user
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.config.server.GeneralCallsConfig;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.VO.FlashVarsVO;
	import playtiLib.model.VO.amf.response.UserInfoMessage;
	import playtiLib.model.VO.amf.response.helpers.UserInfo;
	import playtiLib.model.VO.amf.response.helpers.UserLevel;
	import playtiLib.model.VO.amf.response.helpers.UserStatus;
	import playtiLib.model.VO.social.user.SocialUsersListVO;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.model.proxies.data.DataCapsuleProxy;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.utils.core.ObjectUtil;
	import playtiLib.utils.data.DataCallConfig;

	/**
	 * Handles the user data and has an update information function inside.
	 * The function uses dataCapsule to load the user data from the server. 
	 * @see flash.external.ExternalInterface
	 * @see playtiLib.model.proxies.data.DataCapsuleProxy
	 */ 
	public class UserProxy extends DataCapsuleProxy	{
		
		public static const NAME:String = 'UserProxy';
		private var user_social_info:UserSocialInfo;
		
		public function UserProxy( user_id:String ){
			super( NAME, [AMFGeneralCallsConfig.USER_INFO] );
			if( !facade.hasProxy( UserSocialInfoProxy.NAME ) ){
				facade.registerProxy( new UserSocialInfoProxy() );
			}
			user_social_info = ( facade.retrieveProxy( UserSocialInfoProxy.NAME ) as UserSocialInfoProxy ).getAndLoadUserInfoByIds( [user_id] )[0];
		}
		
		/**
		 * An overriding function that sends notification (USER_DATA_READY) and call the externalIntrface('userDataReady') 
		 * @param event
		 */
		override protected function onDataReady( event:Event ):void {
			normalizeLoadedData();
			sendNotification( GeneralAppNotifications.USER_DATA_READY );			
			if( ExternalInterface.available )
				ExternalInterface.call( 'userDataReady' );
		}
		
		private function normalizeLoadedData() : void {
			user_level.prevLevelExperience = Math.min(user_status.experience, user_level.prevLevelExperience);
		}

		/**
		 * Returns the user information as UserVO object
		 * @return 
		 */
		private function get user_info_msg():UserInfoMessage {
			return getResultOf( AMFGeneralCallsConfig.USER_INFO ) as UserInfoMessage;
		}
		/**
		 * Returns the user static information as UserInfo object
		 * @see playtiLib.model.VO.amf.response.helpers.UserInfo
		 * @return 
		 */
		public function get user_info():UserInfo {
			
			return user_info_msg.userInfo;
		}
		
		/**
		 * Returns the user balance info as UserStatus object
		 * @see playtiLib.model.VO.amf.response.helpers.UserStatus
		 * @return 
		 */
		public function get user_status():UserStatus {
			return user_info_msg.userStatus;
		}
		
		/**
		 * Returns the user balance info as UserLevel object
		 * @see playtiLib.model.VO.amf.response.helpers.UserLevel
		 * @return 
		 */
		public function get user_level():UserLevel {
			return user_info_msg.userLevel;
		}
		
		/**
		 * Returns the user information as UserVO object
		 * @return 
		 */
		public function get userSocialInfo():UserSocialInfo {
			
			return user_social_info;
		}
		
		/**
		 * Updates the user information and sends notification if is_need_send_notification == true
		 * @param updated_params An object that contains the user infomation to update
		 * @param is_need_send_notification If the variable is true, the function sends notification and if the variable is false it isn't,
		 */
		public function updateUser( updated_params:Object, is_need_send_notification:Boolean = true ):void {
			var storedPrevLevelExperience : Number = user_level.prevLevelExperience;
			
			if( updated_params is UserStatus ) {
				user_info_msg.userStatus = updated_params as UserStatus;
			} else if ( updated_params is UserLevel ) {
				user_info_msg.userLevel = updated_params as UserLevel;
			} else if ( updated_params is UserInfo ) {
				user_info_msg.userInfo = updated_params as UserInfo;
			} else {
				ObjectUtil.setMatchingProperties(updated_params, user_info_msg);
			}
			
			if(user_status.experience < user_level.prevLevelExperience) {
				user_level.prevLevelExperience = storedPrevLevelExperience;
			}
			
			if ( is_need_send_notification ){
				sendNotification( GeneralAppNotifications.USER_DATA_READY );
			}
		}
	}
}
