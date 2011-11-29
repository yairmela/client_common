package playtiLib.view.mediators.social.vk
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.statistics.vk.VKVSStatistics;
	import playtiLib.utils.social.vk.VkWrapperUtil;
	import playtiLib.view.components.social.vk.VKSplashVLogic;
	import playtiLib.view.mediators.UIMediator;
	
	public class VKSplashMediator extends UIMediator{
		
		public static const NAME:String = 'VKSplashMediaotr';
		
		private var splash:VKSplashVLogic;
		
		private var navigte_to_app_url:String;
		
		public function VKSplashMediator( splash_path:String, navigte_to_app_url:String ){
			
			super( NAME, new VKSplashVLogic( splash_path ) );
			
			this.navigte_to_app_url = navigte_to_app_url;
			
			splash = viewComponent as VKSplashVLogic;
			splash.content.scaleX = splash.content.scaleY = 1.57;
			
			splash.addEventListener(MouseEvent.CLICK, gotoApplication);
		}
		
		private function gotoApplication( event:Event ):void {
			
			sendNotification( GeneralAppNotifications.TRACK, null, VKVSStatistics.APP_SPLASH_GOTO_APP );
			//build the ref url
			VkWrapperUtil.getInstance().navigateToURL_byVkContainer( new URLRequest( navigte_to_app_url ), '_self' );
		}
	}
}