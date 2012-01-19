package playtiLib.controller.commands.social.fb
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.proxies.data.FlashVarsProxy;
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
			
			sendNotification( GeneralAppNotifications.FULLSCREEN_MODE,false );
			if ( notification.getName() == GeneralAppNotifications.SOCIAL_LIKE_APP ){
				ExternalInterface.call( 'showLikePage' );
				return;
			}
		
			var like_call_config:DataCallConfig = SocialCallsConfig.LIKE_INFO;
			
			var flash_vars_proxy:FlashVarsProxy = facade.retrieveProxy(FlashVarsProxy.NAME) as FlashVarsProxy;
			like_call_config.request_params.page_id = flash_vars_proxy.flash_vars.page_id;
			
			var like_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule([like_call_config]);
			like_capsule.addEventListener( Event.COMPLETE, onLikeDataReady );
			like_capsule.loadData();
		}
		/**
		 * Function that gets a dataCapsule object and check if has leength and with that sends notification SOCIAL_LIKE_APP_CHANGE.
		 * @param event
		 * 
		 */
		private function onLikeDataReady( event:Event ):void{
			
			var like_data_holder:Object = ( event.target as DataCapsule ).getDataHolderByIndex(0).data;
			var like:int = 2;
			if ( like_data_holder.length > 0 ){
				like = 1;
			}
		}
	}
}