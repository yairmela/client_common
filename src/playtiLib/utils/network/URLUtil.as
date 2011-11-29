package playtiLib.utils.network
{
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class URLUtil{
		
		protected static const WINDOW_OPEN_FUNCTION : String = "window.open";
		private static var _isRunnedLocaly:Boolean = true;
		
		public static function init( root:DisplayObject ):void{
			
			var loader_url:String = root.loaderInfo.loaderURL;
			_isRunnedLocaly = !isHttpURL( loader_url );
		}
		/**
		 * Return true if it is runned localy and false otherwise 
		 * @return 
		 * 
		 */		
		public static function isRunnedLocaly():Boolean{
			
			return _isRunnedLocaly;
		}
		/**
		 * Returns true if the url is 'http' and false otherwise 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function isHttpURL( url:String ):Boolean{
			
			return ( url.indexOf( "http" ) != -1 );
		}
		/**
		 * Calls to the external interface (WINDOW_OPEN_FUNCTION) 
		 */		
		public static function openWindow( url:String, window:String = "_blank", features:String = "" ):void {
			
			if ( !ExternalInterface.available ) {
				navigateToURL( new URLRequest( url ),window );
				
				return;
			}
			
			ExternalInterface.call( WINDOW_OPEN_FUNCTION, url, window, features );
		}
	}
}