package playtiLib.model.VO.amf.request
{
	public class LoginRequest extends ClientRequest
	{
		public var userSnId:String;
		public var password:String;
		public var posterSnId:String;
		public var postId:String;
		
		public var language:String;
		
		public function LoginRequest()
		{
		}
	}
}