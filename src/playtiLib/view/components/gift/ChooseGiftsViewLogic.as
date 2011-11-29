package playtiLib.view.components.gift
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.components.btns.RadioButtonSimple;
	import playtiLib.view.components.btns.RadioGroupSimple;
	import playtiLib.view.components.popups.PopupViewLogic;
	 
	public class ChooseGiftsViewLogic extends PopupViewLogic	{
		
		public var invite_friends_btn:ButtonSimple;
//		public var friends_list:FriendsListVLogic;
		public var send_count_text:TextField;
		public var gift_radio_group:RadioGroupSimple;
		public var preloader_mc:MovieClip;
		
		public function ChooseGiftsViewLogic()	{
			
			super( 'pop_up_gifts_mc' );
			//this is regular send gifts popup state
				var gift_btns_con:MovieClip = popup_mc['gifts_btns_con'] as MovieClip;
				gift_radio_group = new RadioGroupSimple();
				
				var btns_index:int;
				while( gift_btns_con.hasOwnProperty( 'radio' + btns_index ) ) {
					var gift_btn:RadioButtonSimple = new RadioButtonSimple( gift_btns_con['radio'+btns_index] );
					gift_btn.data = btns_index;
					gift_radio_group.AddRadioButton( gift_btn );
					btns_index++;
				}
				gift_radio_group.addEventListener( Event.CHANGE, setGiftBtnsDepth );
			
			if( popup_mc.hasOwnProperty( 'sent_count_txt' ) )
				send_count_text = popup_mc['sent_count_txt'] as TextField;
		}
		
		private function setGiftBtnsDepth( event:EventTrans ):void {
			
			var btn_index:int = event.data as int;
			var choosed_btn:MovieClip = popup_mc['gifts_btns_con']['radio'+btn_index] as MovieClip;
			choosed_btn.parent.swapChildren( choosed_btn, choosed_btn.parent.getChildAt(choosed_btn.parent.numChildren-1 ) );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}