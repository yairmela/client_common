package playtiLib.model.proxies.sound
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
 	import org.puremvc.as3.patterns.proxy.Proxy;
	import playtiLib.config.server.ServerConfig;
	/**
	 * Handles the music's data and functionalities 
	 * @see flash.media.Sound
	 * @see flash.media.SoundChannel
	 * @see flash.media.SoundTransform
	 * @flash.net.URLRequest
	 */	
	public class AmbientMusicProxy extends Proxy implements IEventDispatcher{
		
		public static const NAME:String = 'AmbientMusicProxy';
		
		private var autoPlayParams:Object;
		
		private var music:Sound;
		private var sChannel:SoundChannel;
		private var _volume:Number;
		private var fader:Timer;
		
		public function AmbientMusicProxy( sound_path:String, autoPlay:Boolean = true, startMilisec:int = 0, loops:int = 0, vol:Number = .75 )	{
			
			super( NAME, new Sound( new URLRequest( sound_path + '?cache_id=' + ServerConfig.ASSETS_CACHE_ID ) ) );
			music = data as Sound;
			if( autoPlay ) {
				autoPlayParams = {startMilisec:startMilisec, loops:loops, vol:vol};
				music.addEventListener( Event.COMPLETE, playAfterLoad );
			}
			fader = new Timer( 40,20 );
			fader.addEventListener( TimerEvent.TIMER, fadeLap );
			fader.addEventListener( TimerEvent.TIMER_COMPLETE, fadeComplete );
		}
		
		private function playAfterLoad( event:Event ):void {
			
			play( autoPlayParams.startMilisec, autoPlayParams.loops, autoPlayParams.vol );
		}
		/**
		 *  Sets the volume as the colume parameter 
		 * @param volume
		 * 
		 */		
		public function set volume( volume:Number ):void {
			
			_volume = volume;
			if( !sChannel )
				return;
			fader.reset();
			fader.start();
		}
		/**
		 * Generates a new SoundChannel object to play back the sound. This method returns a SoundChannel object, which you access to stop the sound and to monitor volume
		 * @param startMilisec The initial position in milliseconds at which playback should start.
		 * @param loops Defines the number of times a sound loops back to the startTime value before the sound channel stops playback.
		 * @param vol The volume of the sound
		 * 
		 */		
		public function play( startMilisec:int, loops:int = 0, vol:Number = .75 ):void {
			
			sChannel = music.play( startMilisec, loops, new SoundTransform(0) );
			volume = vol;
		}
		/**
		 * Sets the volume to 0. 
		 * 
		 */		
		public function mute():void {
			
			volume = 0;
		}
		
		private function fadeLap( event:TimerEvent ):void {
			
			var fadeinTimer:Timer = ( event.target as Timer );
			sChannel.soundTransform = new SoundTransform( fadeinTimer.currentCount / fadeinTimer.repeatCount * _volume );
		}
		
		private function fadeComplete( event:TimerEvent ):void {
			
			var fadeinTimer:Timer = ( event.target as Timer );
			fadeinTimer.removeEventListener( TimerEvent.TIMER, fadeLap );
			fadeinTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, fadeComplete );
			
			sChannel.soundTransform = new SoundTransform( _volume );
			if( _volume == 0 )
				sChannel.stop();
		}
		  
		// IEventDispatcher implementation
		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event. You can register event listeners on all nodes in the display list for a specific type of event, phase, and priority. 
		 * @param type The type of event.
		 * @param listener The listener function that processes the event.This function must accept an Event object as its only parameter and must return nothing, 
		 * @param useCapture This parameter applies to display objects in the ActionScript 3.0 display list architecture, used by SWF content. Determines whether the listener works in the capture phase or the target and bubbling phases. If useCapture is set to true, the listener processes the event only during the capture phase and not in the target or bubbling phase. If useCapture is false, the listener processes the event only during the target or bubbling phase. To listen for the event in all three phases, call addEventListener twice, once with useCapture set to true, then again with useCapture set to false.
		 * @param priority The priority level of the event listener. The priority is designated by a signed 32-bit integer. The higher the number, the higher the priority. All listeners with priority n are processed before listeners of priority n-1. If two or more listeners share the same priority, they are processed in the order in which they were added. The default priority is 0.
		 * @param useWeakReference Determines whether the reference to the listener is strong or weak. A strong reference (the default) prevents your listener from being garbage-collected. A weak reference does not.
		 * 
		 */		
		public function addEventListener( type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false ):void {
			
			music.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		/**
		 * Removes a listener from the Sound object. If there is no matching listener 
		 * registered with the EventDispatcher object, a call to this method has no effect.
		 * @param type The type of event.
		 * @param listener The listener object to remove.
		 * @param useCapture This parameter applies to display objects in the ActionScript 3.0
		 * display list architecture, used by SWF content. Specifies whether the listener was
		 * registered for the capture phase or the target and bubbling phases. 
		 * If the listener was registered for both the capture phase and the target and bubbling
		 * phases, two calls to removeEventListener() are required to remove both, one call with 
		 * useCapture() set to true, and another call with useCapture() set to false.
		 * 
		 */		
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean=false ):void {
			
			music.removeEventListener( type, listener, useCapture );
		}
		/**
		 * This function dispatches event from the Sound object.r 
		 * @param event
		 * @return A value of true if the event was successfully dispatched. 
		 * A value of false indicates failure or that preventDefault() was called on the event.
		 * 
		 */		
		public function dispatchEvent( event:Event ):Boolean {
			
			return music.dispatchEvent( event );
		}
		/**
		 * This function checks if the Sound object has event listener and returns true if it has
		 * and false otherwise 
		 * @param type
		 * @return 
		 * 
		 */		
		public function hasEventListener( type:String ):Boolean {
			
			return music.hasEventListener( type );
		}
		/**
		 * Checks whether an event listener is registered with this the Sound object or any of its
		 * ancestors for the specified event type. This method returns true if an event listener is
		 * triggered during any phase of the event flow when an event of the specified type is
		 * dispatched to this EventDispatcher object or any of its descendants.  
		 * @param type
		 * @return 
		 * 
		 */		
		public function willTrigger( type:String ):Boolean {
			
			return music.willTrigger( type );
		}
	}
}