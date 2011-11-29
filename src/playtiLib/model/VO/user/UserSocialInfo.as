package playtiLib.model.VO.user
{
	import playtiLib.model.VO.server.DelayedModel;
	import playtiLib.model.VO.server.DeserializedModel;

	/**
	 * Holds all the data of the user like: full name, sex, addres, dates, bonuses, levels, max betand more. 
	 */
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
		
//		public var level:int;
//		public var experience:Number;
//		public var next_level_experience:Number;
//		public var next_level_reward:Number;
//		public var level_reward:Number;
//		public var prev_level_experience:Number;
		
		public var coin_gift_amount:int;
		
		//additional_params
//		public var max_bet:String;
//		public var special_bonus:String;
		
//		public var balance:Number;
		
//		public var level_poster_id:int;
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
		
		public var is_gift_sent:Boolean;
		
		public function UserSocialInfo(){
			
		}
		
		public function setUserInfo( user_social_info:UserSocialInfo ):void{
			//save the level and the balance
			buildVO( user_social_info );
			isReady = true;
		}
	}
}