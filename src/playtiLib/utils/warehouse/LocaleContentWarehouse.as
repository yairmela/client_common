package playtiLib.utils.warehouse 
{
	import flash.events.EventDispatcher;
	import playtiLib.config.content.LocaleContentConfig;
	import playtiLib.model.VO.amf.response.helpers.LocaleCommandParams;
	import playtiLib.model.VO.amf.response.helpers.LocalizedEntity;
	import playtiLib.model.VO.amf.response.LocaleResponse;
	/**
	 * Holds an array of all the localed contents
	 */	
	public class LocaleContentWarehouse extends EventDispatcher 
	{
		private static var warehouses_map : Array = []; 
		
		public function LocaleContentWarehouse() 
		{
			for each(var category:int in LocaleContentConfig.CATEGORYS)
				warehouses_map[category] = new Array();
		}
		
		/**
		 * Add localed objects to their assosiated category array in warehouses_map.
		 */		
		public static function addNewContent(localizationResponse:LocaleResponse):void
		{
			for each (var entity:LocalizedEntity in localizationResponse.entities)
				warehouses_map[localizationResponse.category][entity.techName] = entity.locString;
		}
		
		/**
		 * Gets a int category and returns array of LocatedContent from the warehouses_map. 
		 * If there is no such LocatedContent it returns null.
		 */		
		public static function getLocalContentByCategory(category:int):Array
		{
			return warehouses_map[category].length?warehouses_map[category]:null;
		}
		
		/**
		 * Get a LocalizationCommandParams and return not localed content.
		 * If the warehouses_map array don't contains such content and empty array otherwise. 
		 * @param	content
		 * @return
		 */
		public static function filterLoadedContent(content:LocaleCommandParams):Array
		{
			var result:Array = [];
			for each (var localeContent:String in content.techName)
				//check is localeContent already on warehouses_map or already localed
				if (warehouses_map[content.category][localeContent] == null)
					result.push(localeContent);
			return result;
		}
	}
}