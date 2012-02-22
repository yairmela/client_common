package playtiLib.model.proxies.keyboard
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * Handles the keyboard cash by adding event listeners in the constructor  for key down and key up . 
	 */
	public class KeyboardCashProxy extends Proxy {
		
		public static const NAME:String = 'KeyboardCashProxy';
		
		public function KeyboardCashProxy( informer:InteractiveObject ) {
			
			super( NAME, new Object() );
			informer.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true );
			informer.stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true );
//			informer.stage.addEventListener( FocusEvent.FOCUS_IN, onFocusChange, true );
		}
		
//		private function onFocusChange( event:FocusEvent ):void {
//					
//			(event.currentTarget as Stage).focus = null;
//			
//			event.stopImmediatePropagation();
//		}
		
		private function keyDownHandler( event:KeyboardEvent ):void {
			
			keyDown( event.keyCode );
		}
		
		private function keyUpHandler( event:KeyboardEvent ):void {
			
			keyUp( event.keyCode );
		}
		/**
		 * Function that set the index of the key (by the keycode var ) to be true and send notification about it.
		 * @param keyCode
		 * 
		 */		
		public function keyDown( keyCode:uint ):void {
			
			data[keyCode] = true;
			sendNotification( KeyboardEvent.KEY_DOWN, keyCode );
		}
		/**
		 * Function that set the index of the key (by the keycode var ) to be false and send notification about it.  
		 * @param keyCode
		 * 
		 */		
		public function keyUp( keyCode:uint ):void {
			
			data[keyCode] = false;
			sendNotification( KeyboardEvent.KEY_UP, keyCode );
		}
		/**
		 * Function that checks if the key (by the kecode var) is press 
		 * @param keyCode
		 * @return 
		 * 
		 */		
		public function isKeyDown( keyCode:uint ):Boolean {
			
			return data[keyCode] == true;
		}
	}
}