package playtiLib.model.proxies.user
{
	import flash.events.Event;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.VO.social.user.SocialUsersListVO;
	import playtiLib.model.VO.user.User;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.events.EventTrans;
	
	public class UserSocialInfoProxy extends Proxy	{
		
		public static const NAME:String = 'UserSocialInfoProxy';
		private var userSocialInfoList:Array;
		
		public function UserSocialInfoProxy(){
			
			super( NAME, '' );
			userSocialInfoList = new Array();
		}
		//get and load users
		public function getAndLoadUserInfoByIds( ids:Array ):Array/*UserSocialInfo*/{
			
			var returnUserSocialInfoList:Array = new Array();
			var missingUserSocialInfoList:Array = new Array();
			var dataCapsule:DataCapsule;
			for each( var id:String in ids ){
				if( userSocialInfoList['id'+id] == null || !( userSocialInfoList['id'+id] as UserSocialInfo ).isReady ){
					missingUserSocialInfoList.push( id );
					if( userSocialInfoList['id'+id] == null ){
						userSocialInfoList['id'+id] = new UserSocialInfo();
						( userSocialInfoList['id'+id] as UserSocialInfo ).sn_id = id;
					}
				}
				returnUserSocialInfoList.push( userSocialInfoList['id'+id] );
			}
			if ( missingUserSocialInfoList.length > 0 ){
				dataCapsule = DataCapsuleFactory.getDataCapsule( [SocialCallsConfig.getUserProfileCallConfig( missingUserSocialInfoList ) ] );
				dataCapsule.addEventListener( Event.COMPLETE, onDataReady );
				dataCapsule.loadData();
			}
			return returnUserSocialInfoList;
		}
		//only load users - the users are already exist in the userSocialInfoList 
		public function loadUserSocialInfoByIds( ids:Array ):void{
			
			var missingUserSocialInfoList:Array = new Array();
			var dataCapsule:DataCapsule;
			for each( var id:String in ids ){
				if( userSocialInfoList['id'+id] == null ){
					userSocialInfoList['id'+id] = new UserSocialInfo();
					( userSocialInfoList['id'+id] as UserSocialInfo ).sn_id = id;
				}
				if( userSocialInfoList['id'+id] == null || !( userSocialInfoList['id'+id] as UserSocialInfo ).isReady ){
					missingUserSocialInfoList.push( id );
				}
			}
			if ( missingUserSocialInfoList.length > 0 ){
				dataCapsule = DataCapsuleFactory.getDataCapsule( [SocialCallsConfig.getUserProfileCallConfig( missingUserSocialInfoList ) ] );
				dataCapsule.addEventListener( Event.COMPLETE, onDataReady );
				dataCapsule.loadData();
			}
		}
		
		private function onDataReady( event:Event ):void{
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			var friendsListInfo:Array = ( dataCapsule.getDataHolderByIndex(0).data == null ) ? [] : ( dataCapsule.getDataHolderByIndex(0).data as SocialUsersListVO ).list;
			
			for each( var user:UserSocialInfo in friendsListInfo ){
				( userSocialInfoList['id'+user.sn_id] as UserSocialInfo ).setUserInfo( user );
			}
		}
		//only get the users - if the user isn't exist yet, make a new userSocialInfo
		public function getUserInfoByIds( ids:Array ):Array/*UserSocialInfo*/{
			
			var returnUserSocialInfoList:Array = new Array();
			for each( var id:String in ids ){
				if( userSocialInfoList['id'+id] == null ){
					userSocialInfoList['id'+id] = new UserSocialInfo();
					( userSocialInfoList['id'+id] as UserSocialInfo ).sn_id = id;
				}
				returnUserSocialInfoList.push( userSocialInfoList['id'+id] );
			}
			return returnUserSocialInfoList;
		}
	}
}