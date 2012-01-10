package playtiLib.model.proxies.timer
{
	import flash.events.Event;
	import org.casalib.time.EnterFrame;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import playtiLib.config.notifications.GeneralAppNotifications;
	/**
	 * Handles the entering to the frame. It sends notifications (ENTER_FRAME)to all the system's listeners when there is ENTER_FRAME event.
	 */	
	public class EnterFrameProxy extends Proxy	{
		
		public static const NAME:String = 'EnterFrameProxy';
		
		public function EnterFrameProxy(){
			
			super( NAME, EnterFrame.getInstance() );
			EnterFrame.getInstance().addEventListener( Event.ENTER_FRAME, enterFrameHandler );
		}
		
		private function enterFrameHandler( event:Event ):void {
			
			sendNotification( GeneralAppNotifications.ENTER_FRAME );
		}
		
		override public function onRemove():void {
			EnterFrame.getInstance().removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
		}
	}
}