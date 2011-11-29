package playtiLib.view.components.social.vk
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import playtiLib.utils.network.URLUtil;
	import playtiLib.utils.tracing.Logger;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.interfaces.IViewLogic;
	
	public class VKSplashVLogic extends EventDispatcher implements IViewLogic	{
		
		private var splash_loader:Loader;
		private var play_btn:ButtonSimple;
		
		public function VKSplashVLogic( splash_path:String )	{
			
			var context:LoaderContext = new LoaderContext( true );
			if( !URLUtil.isRunnedLocaly() && URLUtil.isHttpURL( splash_path ) )
				context.securityDomain = SecurityDomain.currentDomain;
			splash_loader = new Loader();
			splash_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onSplashLoadComplete );
			splash_loader.load( new URLRequest( splash_path ), context );
		}
		
		private function onSplashLoadComplete( event:Event ):void {
			
			Logger.log( 'onSplashLoadComplete splash_mc=' + splash_loader.content['splash_mc'] );
			play_btn = new ButtonSimple( splash_loader.content['splash_mc']['play_btn'] );
			play_btn.addEventListener( MouseEvent.CLICK, dispatchEvent );
		}
		
		public function get content():DisplayObject	{
			
			return splash_loader;
		}
	}
}