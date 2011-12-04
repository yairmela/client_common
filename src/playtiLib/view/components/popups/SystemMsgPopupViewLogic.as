package playtiLib.view.components.popups
{
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	
	import playtiLib.model.VO.popup.SystemMsgVO;
	import playtiLib.view.components.btns.ButtonSimple;
	/**
	 * Holds a title textField, description textField, close and reload buttons and a SystemMsVO object.
	 * It sets the title.text, close btn, and reload btn (it is like do btn) by the popup mc, and handles the reload btn visible. 
	 * @see flash.external.ExternalInterface
	 * @see playtiLib.model.VO.popup.SystemMsgVO
	 */	
	public class SystemMsgPopupViewLogic extends PopupViewLogic{
		
		private var title_txt:TextField;
		private var description_txt:TextField;
		private var sys_msg:SystemMsgVO;
		private var close_btn:ButtonSimple;
		public var reload_btn:ButtonSimple;
		
		
		public function SystemMsgPopupViewLogic( sys_msg:SystemMsgVO, popup_mc_name:String )	{
			
			super( popup_mc_name );
			this.sys_msg = sys_msg;
			
			title_txt = popup_mc['title'] as TextField;
			title_txt.text = sys_msg.title;
			
			description_txt = popup_mc['body'] as TextField;
			description_txt.text = sys_msg.description;
			
			close_btn = new ButtonSimple( popup_mc['x_btn'] as MovieClip );
			if ( !sys_msg.has_close_btn )
				close_btn.content.visible = false;
			
			if ( !popup_mc.hasOwnProperty( 'do_btn' ) ) 
				return; 
				
			reload_btn = new ButtonSimple( popup_mc['do_btn'] as MovieClip );
			if ( !sys_msg.is_refresh_btn_needed || !ExternalInterface.available ) 
				reload_btn.content.visible = false;
		}
	}
}