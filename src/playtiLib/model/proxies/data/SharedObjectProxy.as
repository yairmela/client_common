package playtiLib.model.proxies.data
{
	import flash.net.SharedObject;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SharedObjectProxy extends Proxy {
		
		private var _shared:SharedObject;
		 
		public function SharedObjectProxy( proxyName:String ) {
			
			super( proxyName, null );
			_shared = SharedObject.getLocal( proxyName );
			data = _shared.data;
		}
		
		public function save():void {
			
			_shared.flush();
		}
		/**
		 * Clears the variable _shared (SharedObject) and save after it.
		 * 
		 */		
		public function deleteAll():void {
			
			_shared.clear();
			save();
		}
		/**
		 * A getter function that return the variable _shared (SharedObject) 
		 * @return 
		 * 
		 */		
		public function get shared():SharedObject { return _shared; }
	}
}