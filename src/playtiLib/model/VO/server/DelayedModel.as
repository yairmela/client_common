package playtiLib.model.VO.server
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.events.EventTrans;

	public class DelayedModel extends DeserializedJSONModel implements IEventDispatcher	{
		
		private var dispatcher:EventDispatcher;
		private var is_ready:Boolean;
		
		public function DelayedModel()	{
			
			super();
			dispatcher = new EventDispatcher( this );
		}
		
		public function get isReady():Boolean{ return this.is_ready };
			
		public function set isReady( is_ready:Boolean ):void{
			
			this.is_ready = is_ready;
			dispatchEvent( new EventTrans( GeneralAppNotifications.USER_SOCIAL_INFO_READY ) );
		}
		
		public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			dispatcher.addEventListener( type, listener, useCapture, priority );
		}
		
		public function dispatchEvent( evt:Event ):Boolean{
			return dispatcher.dispatchEvent( evt );
		}
		
		public function hasEventListener( type:String ):Boolean{
			return dispatcher.hasEventListener( type );
		}
		
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void{
			dispatcher.removeEventListener( type, listener, useCapture );
		}
		
		public function willTrigger( type:String ):Boolean {
			return dispatcher.willTrigger( type );
		}
	}
}