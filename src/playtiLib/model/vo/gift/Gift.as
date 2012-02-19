package playtiLib.model.vo.gift
{
	import playtiLib.model.vo.user.UserSocialInfo;
	
	public class Gift {
		
		public var sender_sn_id:String;
		public var gift_ts:int;
		public var gift_id:int;
		public var gift_type:int;
		public var gift_value:String;
		public var gift_token:String;
		
		//userVO will be inserted by the client
		public var sender:UserSocialInfo
		
		public function Gift()	{
			
		}
	}
}