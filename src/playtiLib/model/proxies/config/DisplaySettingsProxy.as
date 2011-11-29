package playtiLib.model.proxies.config
{
	import flash.display.Stage;
	import flash.events.FullScreenEvent;
	import flash.geom.Point;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.config.DisplaySettingsVO;

	/**
	 * Waits to full screen event on its constructor and then sets the relevant parameters.
	 */
	public class DisplaySettingsProxy extends Proxy	{
		
		public static const NAME:String = 'DisplaySettingsProxy';
		private var game_stage:Stage;

		public function DisplaySettingsProxy( stage:Stage )	{
			
			super( NAME, new DisplaySettingsVO() );
			game_stage = stage;
			game_stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenModeChanged);
			setFullscreenSize();
		}		
		
		public override function onRemove():void {
			
			game_stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenModeChanged);
			game_stage = null;
			
			super.onRemove();
		}

		/**
		 * Seta the fullscreen parameter of the display settings
		 * @param event
		 * @see FullScreenEvent
		 * 
		 */
		private function onFullScreenModeChanged( event:FullScreenEvent ):void{
			
			fullscreen = event.fullScreen;
		}
		
		private function setFullscreenSize():void{
			
			var settings:DisplaySettingsVO = getData() as DisplaySettingsVO;
			if (!settings.fullscreen_size)
				settings.fullscreen_size = new Point();
			settings.fullscreen_size.x = game_stage.fullScreenWidth;
			settings.fullscreen_size.y = game_stage.fullScreenHeight;
		}
		
		public function get fullscreen_size():Point {
			
			return displaySettings.fullscreen_size;
		}
		
		private function get displaySettings():DisplaySettingsVO
		{
			return getData() as DisplaySettingsVO;
		}
		
		public function set fullscreen( value:Boolean ) : void{
			
			if( displaySettings.fullscreen == value ) {
				return;
			}
			displaySettings.fullscreen = value;
			sendNotification( GeneralAppNotifications.FULLSCREEN_MODE, value );
		}
		
		public function get fullscreen():Boolean{
			
			return displaySettings.fullscreen;
		}
	}
}