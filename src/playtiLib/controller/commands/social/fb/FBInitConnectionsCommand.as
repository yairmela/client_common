package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.social.SocialConfigVO;
	import playtiLib.utils.social.fb.FBSocialCallManager;

	/**
	 * Gets a socialConfigVO object and sets the swf name (in the FB social call manager) by it. If the external interface is available,
	 * it handles few calls back(fqlCallback, fqlCallbackError, OnSNLoginErrorTimeOut, OnCouponUnaviable, OnLikeCallback, fbDataCallback, fbDataCallback )
	 * @see playtiLib.utils.social.fb.FBSocialCallManager
	 * @see flash.external.ExternalInterface
	 */	
	public class FBInitConnectionsCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {		
			
			var social_vo:SocialConfigVO = notification.getBody() as SocialConfigVO;
			
			//TODO: try to move this into the constructor of social call manager
			FBSocialCallManager.swf_object_name = social_vo.main_view.loaderInfo.parameters.swf_object_name;
			if( ExternalInterface.available ) {
				ExternalInterface.addCallback( 'fqlCallback', FBSocialCallManager.getInstance().FQLCallback );
				ExternalInterface.addCallback( 'fqlCallbackError', FBSocialCallManager.getInstance().FQLCallbackError );
				ExternalInterface.addCallback( 'OnSNLoginErrorTimeOut', OnSNLoginErrorTimeOut);
				ExternalInterface.addCallback( 'OnCouponUnaviable', OnCouponUnaviable);
				ExternalInterface.addCallback( 'OnLikeCallback', onLikeCallback);
				ExternalInterface.addCallback( 'fbDataCallback',  FBSocialCallManager.getInstance().FBDataCallback );
				ExternalInterface.addCallback( 'fbDataCallback',  FBSocialCallManager.getInstance().FBDataCallback );
                        }
		}
		/**
		 * 
		 * Function that sends notification SOCIAL_API_ERROR when there is call back from the external interface about that issu
		 */		
		private function OnSNLoginErrorTimeOut():void{
			
			sendNotification( GeneralAppNotifications.SOCIAL_API_ERROR );	
		}
		/**
		 * Sends notification COUPON_SYSTEM_UNAVIABLE and SHOW_STATUS_GIFT_MSG when there is call back from the external interface. 
		 * It sets the coupon_system_enabled  property (in CouponSystemConfig)  to false.
		 * 
		 */		
		private function OnCouponUnaviable():void{
			
			sendNotification( GeneralAppNotifications.COUPON_SYSTEM_UNAVIABLE );
			sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.COUPON_SYSTEM_UNAVIABLE );
		}
		/**
		 * Sends notification SOCIAL_LIKE_APP_CALLBACK when there is call back from the external interface about that issu
		 * 
		 */		
		private function onLikeCallback():void{
			
			sendNotification( GeneralAppNotifications.SOCIAL_LIKE_APP_CALLBACK );
		}

	}
}
