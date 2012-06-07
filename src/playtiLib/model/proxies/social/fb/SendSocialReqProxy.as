package playtiLib.model.proxies.social.fb
{
	import flash.events.Event;
	
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.proxies.data.DataCapsuleProxy;
	
	public class SendSocialReqProxy extends DataCapsuleProxy
	{
		public static const NAME:String  = 'SendSocialReqProxy';
		
		protected var allFriendsInfo:Array;
		protected var appFriendsInfo:Array;

		
		public function SendSocialReqProxy( name : String ){
			//add here all requests
			super( name, [SocialCallsConfig.FRIENDS_IDS_AND_NAMES, SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS] );
		}
		
		override protected function onDataReady(event:Event):void{
			super.onDataReady(event);
			initInfo();
		}
		
		protected function initInfo():void{
			
		}
		
		public function get allFriends():Array
		{
			return allFriendsInfo;
		}
		
		public function get appFriends():Array
		{
			return appFriendsInfo;
		}
	}
}