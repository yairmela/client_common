package playtiLib.model.proxies.data
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.server.ServerConfig;
	/**
	 * Handles the XML data. It loads the xml_path on the register, and dispatches events
	 * if there is a network problems. 
	 * @see flash.net.URLLoader
	 * @see flash.net.URLRequest
	 * @see org.puremvc.as3.patterns.proxy.Proxy
	 */	
	public class XMLProxy extends Proxy implements IEventDispatcher
	{
		private static const LOAD_ATTEMPTS:int = 3;
		
		private var xml_path:String;
		//TODO: change to 2 tries xml loader
		private var xmlLoader:URLLoader;
		private var load_attempts:int;
		
		public function XMLProxy(proxyName:String, xml_path:String=null, xml:XML=null)
		{
			super(proxyName, xml);
			if(!xml && xml_path) {
				this.xml_path = xml_path+"?cache_id="+ServerConfig.ASSETS_CACHE_ID;
				xmlLoader = new URLLoader();
				xmlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler, false, 5);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEvent, false, 5);
			}
		}
		
		override public function onRegister():void {
			if( xmlLoader )
				load( xml_path );
		}
		
		public function get loader():URLLoader {
			return xmlLoader;
		}
		
		protected function get xml():XML {
			return data as XML;
		}
		
		protected function loadCompleteHandler( event:Event ):void {
			data = new XML( event.target.data );
		}
		/**
		 * Gives number of chances to load but if it isn't load after few time, it sends an event(IOErrorEvent.NETWORK_ERROR)
		 * @param event
		 * 
		 */		
		protected function ioErrorEvent( event:Event ):void {
			
			if( load_attempts < LOAD_ATTEMPTS ){
				setTimeout( load, 1000, xml_path.slice( 0,xml_path.indexOf( '?' )) + '?' + Math.random().toFixed(5) );
			}else{
				dispatchEvent( new IOErrorEvent( IOErrorEvent.NETWORK_ERROR ) );
			}
			load_attempts++;
		}
		/**
		 * Make a new URLRequest from the string var and load it by the xmlLoder var. It also saves the variable in xml_path (class variable) 
		 * @param url_path
		 * 
		 */		
		public function load( url_path:String ):void {
			
			xmlLoader.load( new URLRequest( url_path ) );
			xml_path = url_path;
		}
		/**
		 * Adds event listener to the xmlLoader 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		public function addEventListener( type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false ):void	{
			
			xmlLoader.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		/**
		 * Removes the event listener with this listener and type from the xmlLoader 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * 
		 */		
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean=false ):void {
			
			xmlLoader.removeEventListener( type, listener, useCapture );
		}
		/**
		 * Dispatch an event from the xmlLoader and return true if succeeds and false otherwise 
		 * @param event
		 * @return 
		 * 
		 */		
		public function dispatchEvent( event:Event ):Boolean {
			
			return xmlLoader.dispatchEvent( event );
		}
		/**
		 * Return true if the xmlLoader hasEventListener in the variable type
		 *  and false otherwise. 
		 * @param type
		 * @return 
		 * 
		 */	
		public function hasEventListener(type:String):Boolean
		{
			return xmlLoader.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return xmlLoader.willTrigger(type);
		}
	}
}