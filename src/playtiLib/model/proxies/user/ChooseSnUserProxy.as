package playtiLib.model.proxies.user
{
	import flash.events.Event;
	import playtiLib.utils.core.ObjectUtil;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.model.proxies.data.DataCapsuleProxy;
	import playtiLib.model.proxies.user.UserProxy;
	/**
	 * Handles the s.n user's friends 
	 * @see playtiLib.model.vo.user.UserVO
	 * @see playtiLib.model.proxies.data.DataCapsuleProxy
	 * @see playtiLib.model.proxies.user.UserProxy
	 */	
	public class ChooseSnUserProxy extends DataCapsuleProxy {
		
		public static const NAME:String = 'ChooseSnUserProxy';
		
		private var exclude_friend:Object;
		
		public function ChooseSnUserProxy( exclude_friend:Object = null ){
			
			super( NAME, [SocialCallsConfig.FRIENDS_INFO] );
			if ( exclude_friend )
			  this.exclude_friend = ObjectUtil.propertiesToArray( exclude_friend );
			else
			  this.exclude_friend = new Array();
		}
		/**
		 * Returns the array of friends (filtered) 
		 * @return 
		 * 
		 */		
		public function get friends():Array {
			
			exclude_friend.push( SocialConfig.viewer_sn_id );
			return ( data_capsule.getDataHolderByIndex(0).data.list as Array ).filter( 
						function ( element:UserSocialInfo, index:int, arr:Array):Boolean {
							if ( exclude_friend.indexOf(element.sn_id)!=-1 )
							    return false; 
							else
								return true;
						} );
		}
		
		public function get user_proxy():UserProxy {
			
			return facade.retrieveProxy( UserProxy.NAME ) as UserProxy;
		}
		/**
		 * Sends notification - CHOOSE_SN_USER_DATA_READY  
		 * @param event
		 * 
		 */		
		override protected function onDataReady( event:Event ):void {
			
			sendNotification( GeneralAppNotifications.CHOOSE_SN_USER_DATA_READY, friends );
		}
	}
}