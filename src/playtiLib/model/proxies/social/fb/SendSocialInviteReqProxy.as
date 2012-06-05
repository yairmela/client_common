package playtiLib.model.proxies.social.fb
{
	import flash.events.Event;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.proxies.data.DataCapsuleProxy;
	import playtiLib.model.vo.amf.social.user.SocialUserIdsVO;
	import playtiLib.model.vo.social.fb.FBSelectUserVO;
	import playtiLib.model.vo.social.fb.SocialFriendsInfoListVo;
	
	public class SendSocialInviteReqProxy extends SendSocialReqProxy
	{
		public static const NAME:String  = 'SendSocialInviteReqProxy';
		
		private var default_list:String;
		
		private var commonGamesFriendsInfo:Array;
		
		private var allFriendsToInviteArray:Array;
		private var appFriendsArray:Array;
		private var commonFriendsArray:Array;
		
		public function SendSocialInviteReqProxy(){
			//add here all requests
			super(NAME);
		}
		
		override protected function onDataReady(event:Event):void{
			
			super.onDataReady(event);
			sendNotification(GeneralAppNotifications.INVITE_REQ_DATA_READY_COMMAND );
		}
		
		override protected function initInfo():void{
			
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
		
		public function get allFriendsToInviteIds():Array{

			var arrIds:Array = [];
			if( ( !allFriendsToInviteArray || allFriendsToInviteArray.length == 0 ) &&  allFriendsInfo && appFriendsInfo ){
				
				var userId : String;
				for (var i:uint = 0; i < allFriendsInfo.length; i++)
				{
					userId = allFriendsInfo[i].id;
					if (appFriendsInfo.indexOf( userId ) > -1) {
						arrIds.push(userId);
					}
				}
			}
			return arrIds;
		}
	}
}