package playtiLib.controller.commands.user
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.vo.amf.response.helpers.UserInfo;
	import playtiLib.model.proxies.user.UserProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	
	public class UserDataReadyCoreCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {
			
			//remove command - since this command will be called only on the first initial user data ready event.
			facade.removeCommand( GeneralAppNotifications.USER_DATA_READY );

			trackUserInfo();
		}
		
		private function trackUserInfo():void {
			
			var data_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [SocialCallsConfig.ALL_SOCIAL_FRIENDS_INFO] );
			data_capsule.addEventListener( Event.COMPLETE, onFriendsInfoReady );
			data_capsule.loadData();
		}
		/**
		 * Tracks the user's friends info.
		 * @param event
		 * 
		 */
		private function onFriendsInfoReady( event:Event ):void {
			
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			data_capsule.removeEventListener( Event.COMPLETE, onFriendsInfoReady );
			
			var friends_list:Array = ( data_capsule.getDataHolderByIndex(0).data as Array );
			
			var user_profile : UserInfo = userProxy.user_info;

			if(user_profile.userLastLoginTs) {
				var last_login_date : Date = new Date(user_profile.userLastLoginTs * 1000);
				var current_date : Date = new Date();
				
				if( last_login_date.dateUTC >= current_date.dateUTC ) {
					return;
				}
			}
			
			sendNotification(GeneralAppNotifications.TRACK, {friends_count: friends_list.length}, GeneralStatistics.USER_INFO);
		}
		
		private function get userProxy():UserProxy {
			
			return ( facade.retrieveProxy( UserProxy.NAME ) as UserProxy );
		}
	}
}