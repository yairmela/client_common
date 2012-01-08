package playtiLib.model.VO.user
{
	import playtiLib.model.VO.server.DelayedModel;

	public class UserSocialInfo extends DelayedModel{
		
		public var uid:String;
		
		public var first_name:String;
		public var last_name:String;
		
		public var like:int;
		public var app_friends_count:int = 0;
		
		public var birthday_at:Date;
		public var create_at:Date;
		public var last_login_at:Date;
		public var time_till_next_bonus:int;
		public var max_special_bonus_count:int;
		public var special_bonus_counter:int;
		
		public var coin_gift_amount:int;
		
		public var invoker_id:int;
		
		public var photo:String;
		public var photo_medium:String;
		public var photo_big:String;
		
		public var sn_id:String;
		public var sex:int;

		public var city_id:String;
		public var country_id:String;

		public var nickname:String;
		public var timezone:int;	

		public var email:String;
		
		public function UserSocialInfo( id:String=null ){
			
			this.sn_id = id;
		}
		
		public function setUserInfo( user_social_info:UserSocialInfo ):void{

			buildVO( user_social_info );
			isReady = true;
		}
	}
}