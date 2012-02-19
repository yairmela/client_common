package playtiLib.model.vo.social
{
	import flash.display.Sprite;
	
	import playtiLib.config.social.SocialConfig;
	import playtiLib.utils.tracing.Logger;
	
	public class SocialConfigVO	{
		
		public var sn_type:String;
		
		public var api_id:String;
		public var api_secret:String;
		public var api_is_test_mode:Boolean;
		public var external_payment_acc:String;
		// for vk wrapper
		public var main_view:Sprite;
		public var app_width:int; 
		public var app_height:int;
		public var app_frame_rate:int;
		
		public function SocialConfigVO( mainView:Sprite, app_width:int=0, app_height:int=0, app_frame_rate:uint=0,
									   sn_type:String=null, api_id:String=null, api_secret:String=null, api_is_test_mode:Boolean=false, 
									   external_payment_acc:String="" ) {
			
			Logger.log( "SocialConfigVO arguments = " + arguments );
			this.main_view 				= mainView;
			
			this.sn_type 				= ( sn_type!= null ) ? sn_type : SocialConfig.SIMULATE;
			
			this.api_id 				= api_id;
			this.api_secret 			= api_secret;
			this.api_is_test_mode 		= api_is_test_mode;
			this.external_payment_acc 	= external_payment_acc;
			this.app_width 				= app_width;
			this.app_height 			= app_height;
			this.app_frame_rate 		= app_frame_rate;
		}
	}
}