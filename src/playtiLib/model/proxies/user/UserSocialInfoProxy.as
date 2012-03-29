package playtiLib.model.proxies.user
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.tracing.Logger;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.vo.amf.social.user.SocialUsersListVO;
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	
	public class UserSocialInfoProxy extends Proxy	{
		
		public static const NAME:String = 'UserSocialInfoProxy';
		private var userSocialInfoList:Array;
		private var missingUserSocialIds:Array;
		private var requestedIds:Array;
		
		public function UserSocialInfoProxy(){
			
			super( NAME, '' );
			userSocialInfoList = new Array();
			requestedIds = new Array();
		}
		
		//only load users - the users are already exist in the userSocialInfoList 
		public function loadUserSocialInfoByIds( ids:Array ):void{			
			missingUserSocialIds = new Array();			
			
			for each( var id:String in ids ){
				if( userSocialInfoList['id'+id] == null ){
					userSocialInfoList['id'+id] = new UserSocialInfo( id );
				}
				if( !( userSocialInfoList['id'+id] as UserSocialInfo ).isReady ){
					missingUserSocialIds.push( id );
				}
			}
			if ( missingUserSocialIds.length > 0 ) {
				var dataCapsule:DataCapsule;
				dataCapsule = DataCapsuleFactory.getDataCapsule( [SocialCallsConfig.getUserProfileCallConfig( missingUserSocialIds ) ] );
				dataCapsule.addEventListener( Event.COMPLETE, onDataReady );
				dataCapsule.loadData();
			}
		}
		
		//only get the users - if the user isn't exist yet, make a new userSocialInfo
		public function getUserInfoByIds( ids:Array ):Array/*UserSocialInfo*/{
			
			var returnUserSocialInfoList:Array = new Array();
			for each( var id:String in ids ){
				if( userSocialInfoList['id'+id] == null ){
					userSocialInfoList['id'+id] = new UserSocialInfo( id );
				}
				returnUserSocialInfoList.push( userSocialInfoList['id'+id] );
			}
			return returnUserSocialInfoList;
		}
		
		//get and load users
		public function getAndLoadUserInfoByIds( ids:Array ):Array/*UserSocialInfo*/{
			requestedIds = ids;
			loadUserSocialInfoByIds( requestedIds );
			return getUserInfoByIds( requestedIds );
		}
		
		private function onDataReady( event:Event ):void{
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			var friendsListInfo:Array = ( dataCapsule.getDataHolderByIndex(0).data == null ) ? [] : ( dataCapsule.getDataHolderByIndex(0).data as SocialUsersListVO ).list;
			
			var userSocialData:UserSocialInfo;
			for each( var user:UserSocialInfo in friendsListInfo ) {
				userSocialData = userSocialInfoList['id' + user.sn_id] as UserSocialInfo;
				userSocialData.setUserInfo( user );			
			
				missingUserSocialIds.splice(missingUserSocialIds.indexOf(user.sn_id), 1);			
			}
			
			if (missingUserSocialIds.length > 0) {
				invalidateUsersData(missingUserSocialIds);
			}			
		}
	
		private function invalidateUsersData(missingUserSocialIds:Array):void {
			for each (var id:String in missingUserSocialIds) {
				if( requestedIds.indexOf(id) != -1 ){
					requestedIds.splice( requestedIds.indexOf(id) ,1)
				}
				if( userSocialInfoList.indexOf('id' + id) != -1 ){
					userSocialInfoList.splice( userSocialInfoList.indexOf('id' + id), 1);
				}
			}
			sendNotification( GeneralAppNotifications.USER_SOCIAL_INFO_HAS_INVALIDATE_DATA, getUserInfoByIds(requestedIds) );
		}
	}
}