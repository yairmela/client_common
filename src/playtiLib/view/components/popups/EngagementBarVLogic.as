package playtiLib.view.components.popups
{
	import flash.text.TextField;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.model.VO.amf.response.helpers.UserInfo;
	import playtiLib.model.VO.amf.response.helpers.UserLevel;
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.utils.locale.TextLib;

	public class EngagementBarVLogic extends PopupViewLogic	{
		
		private var giftTypeValue:String;
		
		public function EngagementBarVLogic( giftTypeValue:String )	{
			
			super( GeneralDialogsConfig.POPUP_ENGAGEMENT_GIFT )
			this.giftTypeValue = giftTypeValue;
			setTexts()
		}
		
		private function setTexts():void{
			
			(popup_mc.body as TextField).text = SocialPostVO.injectUserParamsToString( TextLib.lib.retrive( 'wall_posts.gifts.eng_bar_gift.title' ),null,null,null,[giftTypeValue]  );
		}
	}
}
