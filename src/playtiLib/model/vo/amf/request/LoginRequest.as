package playtiLib.model.vo.amf.request
{
	public class LoginRequest extends ClientRequest
	{
		public var userSnId:String;
		public var password:String;
		public var posterSnId:String;
		public var postId:String;
		public var urlParams:String;
		
		public var language:String;
		
		public function LoginRequest()
		{
		}
	}
}