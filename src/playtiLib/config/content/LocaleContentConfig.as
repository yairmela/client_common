package playtiLib.config.content {
	import playtiLib.model.VO.FlashVarsVO;
	
	/**
	 * This class configures the localization parameters ( language )
	 */
	public class LocaleContentConfig {
		
		public static const CATEGORYS:Array = [CATEGORY_MISSION];
		public static const CATEGORY_MISSION:int = 0;
		
		private static var current_language:String;
		
		public static function get language():String {
			return current_language;
		}
		
		public static function setLanguageFromFlashVars(flash_vars_vo:FlashVarsVO):void {
			current_language = flash_vars_vo.language;
		}
	}
}