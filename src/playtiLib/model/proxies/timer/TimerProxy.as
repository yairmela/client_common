package playtiLib.model.proxies.timer
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.puremvc.as3.patterns.proxy.Proxy;
	/**
	 * Handles the timer's data and has public functions that stop, restart the timer and send notifications about timer's issues 
	 */ 	
	public class TimerProxy extends Proxy{
		
		private var timer:Timer;
		
		public function TimerProxy( proxyName:String, delay:Number, repeatCount:int = 0, autoPlay:Boolean=true ){
			
			super( proxyName, new Timer( delay, repeatCount ) );
			timer = data as Timer;
			timer.addEventListener( TimerEvent.TIMER, tickHandler );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerCompleteHandler );
			if( autoPlay )
				restart();
		}
		
		public function get current_count():int {
			
			return timer.currentCount;
		}
		
		public function get is_running():Boolean {
			
			return timer.running;
		}
		/**
		 * Restarts the timer 
		 * 
		 */		
		public function restart():void {
			
			timer.reset();
			timer.start();
		}
		/**
		 * Stops the timer 
		 * 
		 */		
		public function stop():void {
			
			timer.stop();
		}
		/**
		 * Sends notifications - TimerEvent.TIMER like in the case of daily or hourly bouns
		 * @param event
		 * 
		 */		
		protected function tickHandler( event:TimerEvent ):void {
			
			sendNotification( TimerEvent.TIMER, timer.currentCount, proxyName );
		}
		/**
		 * Sends notification(TimerEvent.TIMER_COMPLETE) that the timer has completed 
		 * @param event
		 * 
		 */		
		protected function timerCompleteHandler( event:TimerEvent ):void {
			
			sendNotification( TimerEvent.TIMER_COMPLETE, timer.currentCount, proxyName );
		}
		/**
		 * Ovverides the function onRemove and stops the timer 
		 * 
		 */		
		override public function onRemove():void {
			
			stop();
		}
		
		public function get delay():Number {
			return timer.delay;
		}
		
		public function set delay(value:Number):void {
			timer.delay = value;
		}
	}
}