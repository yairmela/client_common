package playtiLib.model.vo.amf.request
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