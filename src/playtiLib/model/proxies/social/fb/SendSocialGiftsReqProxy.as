package playtiLib.model.proxies.social.fb
{
	import flash.events.Event;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.proxies.coupon.TodayReceiversProxy;
	import playtiLib.model.proxies.data.DataCapsuleProxy;
	import playtiLib.model.vo.amf.social.user.SocialUserIdsVO;
	import playtiLib.model.vo.social.SocialPostVO;
	import playtiLib.model.vo.social.fb.FBSelectUserVO;
	import playtiLib.model.vo.social.fb.SocialFriendsInfoListVo;
	
	public class SendSocialGiftsReqProxy extends SendSocialReqProxy	{
		
		public static const NAME:String  = 'SendSocialGiftsReqProxy';
		
		private var default_list:String;
		
		private var todayReceivers:Array;
		
		private var allFriendsToInviteArray:Array;
		private var appFriendsArray:Array;
		private var commonFriendsArray:Array;
		public var current_post_vo:SocialPostVO;
		
		public function SendSocialGiftsReqProxy(){
			//add here all requests
			super(NAME);
		}
		
		override protected function onDataReady(event:Event):void{
			
			super.onDataReady(event);
			sendNotification(GeneralAppNotifications.GIFTS_REQ_DATA_READY_COMMAND );
		}
		
		override protected function initInfo():void{
			
			var receivers:String 	= facade.hasProxy( TodayReceiversProxy.NAME ) ? ( facade.retrieveProxy( TodayReceiversProxy.NAME ) as TodayReceiversProxy ).today_receivers : "";
			todayReceivers  		= receivers != null && receivers != "" ? receivers.split(',') : [];
			allFriendsInfo 			= (data_capsule.getDataHolderByIndex(0).data as SocialFriendsInfoListVo).list.filter( function( user:FBSelectUserVO, ...args):Boolean{
				return todayReceivers.indexOf( user.id ) == -1;});
			appFriendsInfo 			= (data_capsule.getDataHolderByIndex(1).data as SocialUserIdsVO).ids.filter( function( id:String, ...args):Boolean{
				return todayReceivers.indexOf( id ) == -1;});
		}
		
		override public function get allFriends():Array{
			
			var receivers:String 	= facade.hasProxy( TodayReceiversProxy.NAME ) ? ( facade.retrieveProxy( TodayReceiversProxy.NAME ) as TodayReceiversProxy ).today_receivers : "";
			todayReceivers  		= receivers != null && receivers != "" ? receivers.split(',') : [];
			allFriendsInfo 			= (data_capsule.getDataHolderByIndex(0).data as SocialFriendsInfoListVo).list.filter( function( user:FBSelectUserVO, ...args):Boolean{
				return todayReceivers.indexOf( user.id ) == -1;});
			
			return allFriendsInfo ? allFriendsInfo : [] ;
		}
		
		override public function get appFriends():Array{
			
			if( (!appFriendsArray || appFriendsArray.length == 0) ){
				if( allFriendsInfo && appFriendsInfo ){
					appFriendsArray = new Array();
					appFriendsArray = allFriendsInfo.filter( function(
						user:FBSelectUserVO, ...args):Boolean{
						return appFriendsInfo.indexOf( parseInt(user.id) ) != -1;
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