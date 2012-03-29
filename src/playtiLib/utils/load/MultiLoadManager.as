package playtiLib.utils.load
{
 	import flash.events.Event;
 	import flash.events.EventDispatcher;
 	import flash.events.IEventDispatcher;
 	import flash.events.IOErrorEvent;
 	import flash.events.ProgressEvent;
 	import flash.utils.Dictionary;

	
	public class MultiLoadManager extends EventDispatcher
	{		
		public static const ALL_LOADINGS_COMPLETED:String = 'all loadings completed';
		
		private var loading_hash:Object;
		private var progress_hash:Dictionary;
		
		public function MultiLoadManager() 
		{
			loading_hash = new Object();
			progress_hash = new Dictionary();
		}
		
		public function load():void {}

		public function addLoadingProcess( instance:IEventDispatcher, constructor:Class, loadedEventType:String ):void 
		{
			if( loading_hash[constructor] == null )
				loading_hash[constructor] = [];
			loading_hash[constructor].push( instance );
			instance.addEventListener( loadedEventType, loadedAsset );
			instance.addEventListener( IOErrorEvent.IO_ERROR, IO_Error );
			progress_hash[instance] = [0,0];
			instance.addEventListener( ProgressEvent.PROGRESS, loadProgress );
		}

		private function IO_Error( event:IOErrorEvent ):void{

			dispatchEvent( event );
		}

		private function loadedAsset( event:Event ):void 
		{
			var loaded_class:Class = event.currentTarget.constructor;
			loading_hash[loaded_class].pop();
			if( allReady )
				dispatchEvent( new Event( Event.COMPLETE ) );
		}

		private function loadProgress( event:ProgressEvent ):void 
		{
			progress_hash[event.currentTarget] = [event.bytesLoaded,event.bytesTotal];
			dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS,false, false, bytesLoaded, bytesTotal ) );
		}

		private function get bytesLoaded():uint 
		{
			var result:uint;
			for each( var records:Array in progress_hash ) 
			{
				result += records[0]
			}
			return result;
		}
		
		private function get bytesTotal():uint {
			
			var result:uint;
			for each( var records:Array in progress_hash ) {
				result += records[1]
			}
			return result;
		}
		
		private function get allReady():Boolean {
			
			for each( var instances:Array in loading_hash ) {
				if( instances.length > 0 )
					return false;
			}
			return true;
		}
		
		override public function toString():String {
			
			var result:String = 'AInitialLoadings\n[';
			for each( var obj:Object in loading_hash ) {
				result += obj + '\n';
			}
			result += ']';
			return result;
		}
	}
}