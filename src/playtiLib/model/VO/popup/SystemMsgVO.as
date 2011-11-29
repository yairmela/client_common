package playtiLib.model.VO.popup
{
	/**
	 * Holds all the data about the system msg. Like title, description, is_refresh_btn_needed, has_close_btn, popup_name_mc
	 */	
	public class SystemMsgVO	{
		
		public var title:String;
		public var description:String;
		public var is_refresh_btn_needed:Boolean;
		public var has_close_btn:Boolean;
		public var popup_name_mc:String;
		public var is_auto_fixable:Boolean;
		
		public function SystemMsgVO(){
		}
	}
}