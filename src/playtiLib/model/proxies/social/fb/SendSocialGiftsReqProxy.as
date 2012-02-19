package playtiLib.model.proxies.social.fb
{
	import flash.events.Event;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.model.VO.social.fb.FBSelectUserVO;
	import playtiLib.model.VO.social.fb.SocialFriendsInfoListVo;
	import playtiLib.model.VO.social.user.SocialUserIdsVO;
	import playtiLib.model.proxies.coupon.TodayReceiversProxy;
	import playtiLib.model.proxies.data.DataCapsuleProxy;
	
	public class SendSocialGiftsReqProxy extends DataCapsuleProxy	{
		
		public static const NAME:String  = 'SendSocialGiftsReqProxy';
		
		private var default_list:String;
		private var allFriendsInfo:Array;
		private var appFriendsInfo:Array;
		private var todayReceivers:Array;
		
		private var allFriendsToInviteArray:Array;
		private var appFriendsArray:Array;
		private var commonFriendsArray:Array;
		public var current_post_vo:SocialPostVO;
		
		public function SendSocialGiftsReqProxy(){
			//add here all requests
			super( NAME, [SocialCallsConfig.FRIENDS_IDS_AND_NAMES, SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS] );
		}
		
		override protected function onDataReady(event:Event):void{
			
			super.onDataReady(event);
			initInfo();
			
			sendNotification(GeneralAppNotifications.SEND_SOCIAL_REQ_DATA_READY );
		}
		
		private function initInfo():void{
			
			var receivers:String 	= facade.hasProxy( TodayReceiversProxy.NAME ) ? ( facade.retrieveProxy( TodayReceiversProxy.NAME ) as TodayReceiversProxy ).today_receivers : "";
			todayReceivers  		= receivers != null && receivers != "" ? receivers.split(',') : [];
			allFriendsInfo 			= (data_capsule.getDataHolderByIndex(0).data as SocialFriendsInfoListVo).list.filter( function( user:FBSelectUserVO, ...args):Boolean{
				return todayReceivers.indexOf( user.id ) == -1;});
			appFriendsInfo 			= (data_capsule.getDataHolderByIndex(1).data as SocialUserIdsVO).ids.filter( function( id:String, ...args):Boolean{
				return todayReceivers.indexOf( id ) == -1;});
		}
		
		public function get allFriends():Array{
			
			var receivers:String 	= facade.hasProxy( TodayReceiversProxy.NAME ) ? ( facade.retrieveProxy( TodayReceiversProxy.NAME ) as TodayReceiversProxy ).today_receivers : "";
			todayReceivers  		= receivers != null && receivers != "" ? receivers.split(',') : [];
			allFriendsInfo 			= (data_capsule.getDataHolderByIndex(0).data as SocialFriendsInfoListVo).list.filter( function( user:FBSelectUserVO, ...args):Boolean{
				return todayReceivers.indexOf( user.id ) == -1;});
			
			return allFriendsInfo ? allFriendsInfo : [] ;
		}
		
		public function get appFriends():Array{
			
			if( (!appFriendsArray || appFriendsArray.length == 0) ){
				if( allFriendsInfo && appFriendsInfo ){
					appFriendsArray = new Array();
					appFriendsArray = allFriendsInfo.filter( function(
						user:FBSelectUserVO, ...args):Boolean{
						return appFriendsInfo.indexOf( user.id ) != -1;
					}); 
					return appFriendsArray;
				}else{
					return [];
				}
			}
			return appFriendsArray;
		}
		
		public function updateTodayReceivers( ids:String ):void{
			if( ids.length > 0 ){
				allFriendsInfo = allFriendsInfo.filter( function( user:FBSelectUserVO, ...args):Boolean{
					return todayReceivers.indexOf( user.id ) == -1;});
				appFriendsInfo = appFriendsInfo.filter( function( id:String, ...args):Boolean{
					return todayReceivers.indexOf( id ) == -1;});
			}
		}
	}
}