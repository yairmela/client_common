package playtiLib.utils.locale
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import playtiLib.config.server.ServerConfig;
	import playtiLib.utils.display.DisplayObjectUtil;
	import playtiLib.utils.tracing.Logger;
	/**
	 * Handles the xml loading. Holds an array of the xmls that when a xml is loaded, it push to this array.
	 * @see flash.net.URLLoader
	 * @see flash.net.URLRequest
	 * @see flash.utils.Dictionary
	 */	
	public class TextLib{
		//TODO: move this to folder utils/text
		private static var _lib:TextLib = new TextLib;
		
		private var strings_xmls:Array = [];
		
		public function TextLib(){
			
			super();
		}
		
		public static function get lib():TextLib { return _lib; }
		
		//TODO: change to 2 tries xml loader
		/**
		 * Gets a xml path and makes a URLLoader that loads this path. It listens to COMPLETE and IO_ERROR events and returns the URLLoader object 
		 * @param xml_path
		 * @return 
		 * 
		 */		
		public static function loadStringsXML( xml_path:String ):URLLoader {
			
			var xml_loader:URLLoader = new URLLoader();
			xml_loader.addEventListener( Event.COMPLETE, loadStringsXMLComplete );
			xml_loader.load( new URLRequest( xml_path + '?cache_id=' + ServerConfig.ASSETS_CACHE_ID ) );
			xml_loader.addEventListener( IOErrorEvent.IO_ERROR,  trace );
			return xml_loader;
		}
		/**
		 * Adds the xml to the TextLib object. It calls when the xml loaded is complete  
		 * @param event
		 * 
		 */		
		private static function loadStringsXMLComplete( event:Event ):void {
			
			lib.addXML( new XML( event.target.data ) );
		}
		/**
		 * Gets a xml and push it to the strings_xmls array
		 * @param data
		 * 
		 */		
		public function addXML( data:XML ):void {
			
			strings_xmls.push( data );
		}
		
		//enables call for texts
		public function retrive( path:String ):* {
			
			var result:String = null;
			for( var i:int = 0; i < strings_xmls.length && result == null; i++ ) {
				var strings_xml:XML = strings_xmls[i] as XML;
				result = getString( strings_xml, path.split( '.' ) );
			}
			return result;
		}
		/**
		 * Gets a XML and path array, runs over all of it and returns it's children recursively 
		 * @param source
		 * @param path_arr
		 * @return 
		 * 
		 */		
		protected function getString( source:XML, path_arr:Array ):* {
			
			for each( var xml_child:XML in source[path_arr[0].toString()] ) {
				if( path_arr.length <= 1 )
					return xml_child;
				
				return getString( xml_child, path_arr.slice(1) );
			}
			return null
		}
		/**
		 * Gets a mc and runs all over it. It inserts all it's TextField to dictionary and writes in it's text field(in the dictionary)  
		 * @param content
		 * 
		 */		
		public static function mcTextsAutoFill( content:MovieClip ):void {
			
			var text_fileds_dic:Dictionary = DisplayObjectUtil.getAllInstancesFromType( content, TextField );
			for ( var key:String in text_fileds_dic ) {
				var string_key:String = getQualifiedClassName( content ) + key;
				var text:String = TextLib.lib.retrive( string_key )
				//TODO: what is this??
				if(!text) {
//					Logger.log("***** Critical Error ***** Localication no text for textfield " + stringKey)
				} else {
					( text_fileds_dic[key] as TextField ).text = text;
				}
			}
		}
	}
}