package playtiLib.view.components.popups
{
	import flash.text.TextField;
	
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.utils.locale.TextLib;

	public class EngagementBarVLogic extends PopupViewLogic	{
		
		private var giftTypeValue:String;
		
		public function EngagementBarVLogic( popup_name:String, giftTypeValue:String )	{
			
			super( popup_name )
			this.giftTypeValue = giftTypeValue;
			setTexts()
		}
		
		private function setTexts():void{
			
			(popup_mc.body as TextField).text = SocialPostVO.injectUserParamsToString( TextLib.lib.retrive( 'wall_posts.gifts.eng_bar_gift.title' ),null,null,[giftTypeValue]  );
		}
	}
}