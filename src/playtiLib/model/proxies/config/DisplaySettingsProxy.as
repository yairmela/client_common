package playtiLib.model.proxies.config
{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.geom.Point;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.config.DisplaySettings;

	/**
	 * Waits to full screen event on its constructor and then sets the relevant parameters.
	 */
	public class DisplaySettingsProxy extends Proxy	{
		
		public static const NAME:String = 'DisplaySettingsProxy';
		
		private var stage : Stage;

		public function DisplaySettingsProxy( stage:Stage )	{
			
			super( NAME, new DisplaySettings() );
			
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

			if(!displaySettings.fullscreenSize) {
				displaySettings.fullscreenSize = new Point();
			}
			displaySettings.fullscreenSize.x = stage.fullScreenWidth;
			displaySettings.fullscreenSize.y = stage.fullScreenHeight;
						
			displaySettings.fullscreen = (stage.displayState == StageDisplayState.FULL_SCREEN);
			displaySettings.defaultFramerate =
			displaySettings.framerate = stage.frameRate;
		}
		
		private function get displaySettings():DisplaySettings
		{
			return data as DisplaySettings;
		}
		
		public function get fullscreen_size():Point {
			
			return displaySettings.fullscreenSize;
		}
		
		public function resetFramerate() : void{
			
			framerate = displaySettings.defaultFramerate;
		}
		
		public function set framerate( value:Number ) : void{
			
			if( displaySettings.framerate == value ) {
				return;
			}
			displaySettings.framerate = value;
			sendNotification( GeneralAppNotifications.FRAMERATE_CHANGED, value );
		}
		
		public function get framerate():Number {
			
			return displaySettings.framerate;
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