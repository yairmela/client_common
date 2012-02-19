package playtiLib.model.proxies.config
{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.geom.Point;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.config.DisplaySettingsVO;

	/**
	 * Waits to full screen event on its constructor and then sets the relevant parameters.
	 */
	public class DisplaySettingsProxy extends Proxy	{
		
		public static const NAME:String = 'DisplaySettingsProxy';
		
		private var stage : Stage;

		public function DisplaySettingsProxy( stage:Stage )	{
			
			super( NAME, new DisplaySettingsVO() );
			
			this.stage = stage;
			this.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenModeChanged);
			
			initSettings();
		}		
		
		public override function onRemove():void {
			
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenModeChanged);
			stage = null;
			
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
		
		private function initSettings():void{

			if(!displaySettings.fullscreen_size) {
				displaySettings.fullscreen_size = new Point();
			}
			displaySettings.fullscreen_size.x = stage.fullScreenWidth;
			displaySettings.fullscreen_size.y = stage.fullScreenHeight;
			
			displaySettings.fullscreen = (stage.displayState == StageDisplayState.FULL_SCREEN);
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