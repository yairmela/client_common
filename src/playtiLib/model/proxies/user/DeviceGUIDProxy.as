package playtiLib.model.proxies.user
{
	import flash.net.SharedObject;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class DeviceGUIDProxy extends Proxy
	{
		public static const NAME:String = "DeviceGUIDProxy";
		
		private static var GUID_NAME:String = "GUID";
		
		public function DeviceGUIDProxy( viewerSNId : String ) {
			
			var guid : String;
			var sharedObject : SharedObject;
			try {
				sharedObject = SharedObject.getLocal(NAME);
				guid = sharedObject.data[GUID_NAME];
			}
			catch( error : Error ) {}			
			
			if( !guid ) {
				guid = ( viewerSNId + "_" + Math.round(Math.random()*100000000).toString() );
				
				if(sharedObject) {
					sharedObject.data[GUID_NAME] = guid;
					sharedObject.flush();
				}
			}
			
			super( NAME, guid );
		}
		
		public function get GUID():String {
			
			return data as String;
		}
	}
}