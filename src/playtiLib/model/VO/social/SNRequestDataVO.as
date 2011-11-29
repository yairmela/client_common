package playtiLib.model.VO.social
{
	/**
	 * Holds the s.n coupon's data (create date, message, coupon token, sender info, reciever info and id of the coupon) 
	 */	
	public class SNRequestDataVO	{
		
		public var created_time:String;
		public var message:String;
		public var coupon_token:String;
		
		public var sender_id:String;
		public var senderName:String;
		
		public var receiver_id:String;
		public var receiver_name:String;
		
		public var id:String;
		
		public var invite:Boolean;
		
		public function SNRequestDataVO( data:Object ) {}
	}
}