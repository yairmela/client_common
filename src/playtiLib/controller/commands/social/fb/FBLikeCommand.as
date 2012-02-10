package playtiLib.controller.commands.social.fb
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.model.proxies.user.UserProxy;
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;

	/**
	 * Checks if the notification's name is SOCIAL_LIKE_APP and if it is, makes an ExternalInterface.call - 'showLikePage'.
	 * If not, it retrieves app id property from the flash vars proxy and gets (from DataCapsuleFactory) this dataCapsule and loads it's data
	 * from server and check what is the like value.
	 * @see flash.external.ExternalInterface
	 * @see playtiLib.config.social.SocialCallsConfig
	 * @see playtiLib.model.proxies.data.FlashVarsProxy
	 * @see playtiLib.utils.data.DataCapsule
	 */
	public class FBLikeCommand extends SimpleCommand{
		
		override public function execute( notification:INotification ):void {
			
			sendNotification( GeneralAppNotifications.FULLSCREEN_MODE, false );
			if ( notification.getName() == GeneralAppNotifications.SOCIAL_LIKE_APP ){
				ExternalInterface.call( 'showLikePage' );
				return;
			}
			
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule([SocialCallsConfig.getLikeInfo(flashVarsProxy.flash_vars.page_id)]);
			dataCapsule.addEventListener( Event.COMPLETE, onLikeDataReady );
			dataCapsule.loadData();
		}

		/**
		 * Function that gets a dataCapsule object and check if has leength and with that sends notification SOCIAL_LIKE_APP_DATA_READY.
		 * @param event
		 * 
		 */
		private function onLikeDataReady( event:Event ):void{
			
			var likeDataHolder:Object = ( event.target as DataCapsule ).getDataHolderByIndex(0).data;
			var like:int = SocialConfig.LIKE_STATUS_UNLIKED;
			if (likeDataHolder.has_error) {
				like = SocialConfig.LIKE_STATUS_UNKNOWN;
			}else if ( likeDataHolder.length > 0 ) {
				like = SocialConfig.LIKE_STATUS_LIKED;
			}
			
			if(userProxy.dataReady) {
				userProxy.user_info.userLikesApp = (like == SocialConfig.LIKE_STATUS_LIKED);
			}
			
			sendNotification(GeneralAppNotifications.SOCIAL_LIKE_APP_DATA_READY, like);
		}

		private function get flashVarsProxy():FlashVarsProxy {
			
			return facade.retrieveProxy(FlashVarsProxy.NAME) as FlashVarsProxy;
		}
		
		protected function get userProxy() : UserProxy {
			
			return (facade.retrieveProxy(UserProxy.NAME) as UserProxy);
		}
	}
}