package playtiLib.model.proxies.load
{
	import playtiLib.model.proxies.data.XMLProxy;
	/**
	 * Handles the load config data 
	 * @see playtiLib.model.proxies.data.XMLProxy
	 */	
	public class LoadConfigProxy extends XMLProxy
	{
		private static const PRELOADER_WAREHOUSE:String = 'preloader'
		private static const GRAPHIC_WAREHOUSE:String = 'graphics'
		private static const SOUND_WAREHOUSE:String = 'sounds'
		//will be used for the main config proxy
		//note: since this proxy can be used as extended class the name is passed in constructor
		public static const NAME:String = 'LoadConfigProxy';
		
		public function LoadConfigProxy(proxy_name:String, xml_path:String, xml:XML=null)
		{
			super(proxy_name, xml_path, xml);
		}
		
		public function get preloader_name():String {
			return getWarehouseByType(PRELOADER_WAREHOUSE, 'preload')[0].@name;
		}
		public function get preloader_path():String {
			return getWarehouseByType(PRELOADER_WAREHOUSE, 'preload')[0].@url;
		}
		/**
		 * Returns the wareHouse by type(variable) from the xml libraries 
		 * @param type
		 * @param section
		 * @return 
		 * 
		 */	
		private function getWarehouseByType( type:String, section:String = 'main' ):XMLList {
			return xml.resources[section].libraries.library.(@type == type)
		}
		
		public function getAssetsForSection( section:String ):XMLList {
			return getWarehouseByType(GRAPHIC_WAREHOUSE, section) + getWarehouseByType(SOUND_WAREHOUSE, section);
		}
		/**
		 * Returns the wareHouse in type 'graphics' and 'spunds'
		 * @return 
		 * 
		 */	
		public function get warehouses_xml_list():XMLList {
			return getWarehouseByType(GRAPHIC_WAREHOUSE)+getWarehouseByType(SOUND_WAREHOUSE);
		}
		
		public function get graphics_paths():Array {
			return mapPropertyToArray( getWarehouseByType(GRAPHIC_WAREHOUSE), 'url' );
		}
		public function get graphics_names():Array {
			return mapPropertyToArray( getWarehouseByType(GRAPHIC_WAREHOUSE), 'name' );
		}
		
		public function get sounds_paths():Array {
			return mapPropertyToArray( getWarehouseByType(SOUND_WAREHOUSE), 'url' );
		}
		public function get sounds_names():Array {
			return mapPropertyToArray( getWarehouseByType(SOUND_WAREHOUSE), 'name' );
		}
		/**
		 * Gets xmlList variable and for each child in the list, it pushs the property 
		 * of this child to array 
		 * @param xml_list
		 * @param property
		 * @return 
		 * 
		 */	
		private function mapPropertyToArray(xml_list:XMLList, property:String):Array {
			var result:Array = [];
			for each( var child:XML in XMLList ) {
				result.push(child.@property);
			}
			return result;
		}
	}
}