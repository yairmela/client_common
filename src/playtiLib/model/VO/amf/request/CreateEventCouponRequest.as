package playtiLib.model.VO.amf.request
{
	public class CreateEventCouponRequest extends ClientRequest	{
		
		public var eventType:int;
		public var gameId:int;
		public var subGameId:int;
		
		public function CreateEventCouponRequest()		{
			
			super();
		}
	}
}