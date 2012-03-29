package playtiLib.model.vo.amf.request
{
	import playtiLib.model.vo.amf.response.helpers.UserInfo;

	public class RegisterRequest extends LoginRequest
	{
		public var userInfo:UserInfo = new UserInfo;
		
		public function RegisterRequest()
		{
			super();
		}
	}
}