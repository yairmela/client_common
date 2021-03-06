package playtiLib.model.vo.social
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import playtiLib.model.vo.amf.response.Coupon;
	import playtiLib.model.vo.amf.response.helpers.UserInfo;
	import playtiLib.model.vo.amf.response.helpers.UserLevel;
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.utils.text.TextUtil;

	public class SocialPostVO  
	{
		public var user_sn_id:String;
		public var image_path:String;
		public var image_to_post:DisplayObject;
		public var is_gift:Boolean;
		public var gift_token:String;
		public var gift_type:int;
		public var token:String;
		public var title:String;
		public var descreiption:String;
		public var user_msg:String;//will be an offer for the user to do personal msg to friends
		public var user_promt_msg:String;//will pront the user to do the post
		public var event_type:int;//for add to publish link for tracking mechanism
		public var coupon:Coupon;
		public var today_receivers_ids:String
		
		public var addition_object:Object;
		
		public function SocialPostVO( user_sn_id:String=null, image_to_post:DisplayObject=null, descreiption:String=null, title:String=null, image_path:String=null, event_type:int=0 )	{
			
			this.user_sn_id 	= user_sn_id;
			this.image_to_post 	= image_to_post;
			this.title 			= title;
			this.descreiption 	= descreiption;
			this.image_path 	= image_path;
			this.event_type 	= event_type;
		}

		public static function injectUserParamsToString( str:String, user_level:UserLevel,user_info:UserSocialInfo, game_name:String = null, ...num_params : Array ):String {
			
			var params:Object = {};

			params["level"] = user_level.level;
			params["user_name"] = user_info.first_name;
			params["game_name"] = game_name;

			if ( num_params.length == 1 ) {				
				params["num"] = ((num_params[0] is Number) || (num_params[0] is int) || (num_params[0] is uint)) ? TextUtil.numberFormat(num_params[0]) : String(num_params[0]);				
			}	else {
				for( var i : int = 0; i < num_params.length; i++ ) {
					params["num"+i] = String(num_params[i]);
				}
			}

			return TextUtil.injectUserParamsToString(str, params);
		}
	}
}