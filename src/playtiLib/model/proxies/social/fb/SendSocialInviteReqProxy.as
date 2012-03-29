package playtiLib.model.proxies.social.fb
{
	import flash.events.Event;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.proxies.data.DataCapsuleProxy;
	import playtiLib.model.vo.amf.social.user.SocialUserIdsVO;
	import playtiLib.model.vo.social.fb.FBSelectUserVO;
	import playtiLib.model.vo.social.fb.SocialFriendsInfoListVo;
	
	public class SendSocialInviteReqProxy extends DataCapsuleProxy
	{
		public static const NAME:String  = 'SendSocialInviteReqProxy';
		
		private var default_list:String;
		private var allFriendsInfo:Array;
		private var appFriendsInfo:Array;
		private var commonGamesFriendsInfo:Array;
		
		private var allFriendsToInviteArray:Array;
		private var appFriendsArray:Array;
		private var commonFriendsArray:Array;
		
		public function SendSocialInviteReqProxy(){
			//add here all requests
			super( NAME, [SocialCallsConfig.FRIENDS_IDS_AND_NAMES, SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS] );
		}
		
		override protected function onDataReady(event:Event):void{
			
			super.onDataReady(event);
			initInfo();
			
			sendNotification(GeneralAppNotifications.SEND_SOCIAL_REQ_DATA_READY );
		}
		
		private function initInfo():void{
			
			allFriendsToInviteArray = new Array();
			allFriendsInfo 			= (data_capsule.getDataHolderByIndex(0).data as SocialFriendsInfoListVo).list;
			appFriendsInfo 			= (data_capsule.getDataHolderByIndex(1).data as SocialUserIdsVO).ids;
		}
		
		public function get allFriendsToInviteInfo():Array{
			
			if( ( !allFriendsToInviteArray || allFriendsToInviteArray.length == 0 ) &&  allFriendsInfo && appFriendsInfo ){
				allFriendsToInviteArray = allFriendsInfo.filter( function(
					user:FBSelectUserVO, ...args):Boolean{
					return appFriendsInfo.indexOf( parseInt(user.id) ) == -1;
				}); 
			}
			return allFriendsToInviteArray;
		}
	}
}