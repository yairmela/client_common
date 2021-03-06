package playtiLib.controller.commands.user
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.vo.amf.response.helpers.UserInfo;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.GeneralCallsConfig;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.vo.amf.social.user.SocialUsersListVO;
	import playtiLib.model.vo.user.UserSocialInfo;
 	import playtiLib.model.proxies.data.FlashVarsProxy;
 	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.statistics.Tracker;
	import playtiLib.utils.tracing.Logger;

	/**
	 * Handles the update of users by importing his information from the server by data capsule(id, full name, sex, birthday date, adress and mail) 
	 * @see playtiLib.model.proxies.data.FlashVarsProxy
	 * @see playtiLib.utils.data.DataCapsule
	 */
	public class UpdateUserInfoCommand extends SimpleCommand{
		
		private var user_profile:UserSocialInfo;

		override public function execute( notification:INotification ):void{
			
			Logger.log( "UpdateUserInfoCommand" );
			
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [SocialCallsConfig.getUserProfileCallConfig([flash_vars.viewer_id]), SocialCallsConfig.getLikeInfo(flash_vars.page_id), SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS ] );
			dataCapsule.addEventListener( Event.COMPLETE, onUserInfoReady );
			dataCapsule.addEventListener( ErrorEvent.ERROR, onDataReadyWithErrors);
			dataCapsule.addEventListener( IOErrorEvent.IO_ERROR,  IO_Error);
			
			dataCapsule.loadData();
		}
		
		private function IO_Error(event:IOErrorEvent):void{
			
			Logger.log( "IO_Error " + event );
		}
		
		protected function onDataReadyWithErrors( event:EventTrans ):void {
			
			Logger.log( "onDataReadyWithErrors " + event );
		}

		
		private function onUserInfoReady(event:Event):void	{
			
			Logger.log("onUserInfoReady");
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			data_capsule.removeEventListener( Event.COMPLETE, onUserInfoReady );
			
			user_profile = (data_capsule.getDataHolderByIndex(0).data as SocialUsersListVO).list_copy[0] as UserSocialInfo;
			
			var like_data_holder:Object = data_capsule.getDataHolderByIndex(1).data;
			Logger.log( "dataHolder " + like_data_holder );
			if ( like_data_holder.length > 0 ){
				user_profile.like = 1;
			}else{
				user_profile.like = 0;
			}
			
			Logger.log( "Like " + user_profile.like );
			
			var friends_holder:Object = data_capsule.getDataHolder( SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS ).data;
			if ( friends_holder != null ){
				user_profile.app_friends_count = friends_holder.ids.length;
			}
			
			var birthday_at:String="0000-00-00";
			if( user_profile.birthday_at!=null ) {
				birthday_at = user_profile.birthday_at.fullYear
								+ "-"
								+ ( user_profile.birthday_at.month < 9 ? "0" : "" )
								+ ( user_profile.birthday_at.month + 1 )
								+ "-"
								+ ( user_profile.birthday_at.date < 10 ? "0" : "" )
								+ user_profile.birthday_at.date;
			}
			var flash_vars:FlashVarsVO = ( Facade.getInstance().retrieveProxy( FlashVarsProxy.NAME ) as FlashVarsProxy ).flash_vars;

			var userInfo:UserInfo = new UserInfo();
				userInfo.userFirstName = user_profile.first_name;
				userInfo.userLastName = user_profile.last_name;
				userInfo.email = user_profile.email;
				userInfo.gender = user_profile.sex;
				userInfo.userBirthday = birthday_at;
				userInfo.country = user_profile.country_id;
				userInfo.city = user_profile.city_id;
				userInfo.userLikesApp = Boolean(user_profile.like);
				userInfo.friendsCount = user_profile.app_friends_count;
				userInfo.locale = flash_vars.locale == null ? '' : flash_vars.locale;
			var update_config:DataCallConfig = AMFGeneralCallsConfig.UPDATE_USER_INFO.setRequestProperties( { userInfo:userInfo } );
			
			data_capsule = DataCapsuleFactory.getDataCapsule( [ update_config ] );
			data_capsule.addEventListener( Event.COMPLETE, updateResult );
			data_capsule.addEventListener( IOErrorEvent.IO_ERROR,  trace );
			data_capsule.loadData();
		}
		
		private function updateResult( event:Event ):void {
			
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			data_capsule.removeEventListener( Event.COMPLETE, updateResult );
		}
		
		private function get flash_vars():FlashVarsVO{
			
			return (facade.retrieveProxy(FlashVarsProxy.NAME) as FlashVarsProxy).flash_vars;
		}
	}
}
