package playtiLib.view.mediators.social.vk
{
	import playtiLib.view.components.social.vk.VKSplashVLogic;
	import playtiLib.view.mediators.UIMediator;
	
	public class VKSplashMediaotr extends UIMediator{
		
		public static const NAME:String = 'VKSplashMediaotr';
		private var splash:VKSplashVLogic;
		
		public function VKSplashMediaotr( splash_path:String, navigte_to_app_url:String ){
			
			super( NAME, new VKSplashVLogic( splash_path ) );
			splash = viewComponent as VKSplashVLogic;
			splash.content.scaleX = splash.content.scaleY = 1.57;
		}
	}
}