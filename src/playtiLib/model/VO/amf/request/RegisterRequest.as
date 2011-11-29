package playtiLib.model.VO.amf.request
{
	import playtiLib.model.VO.amf.response.helpers.UserInfo;

	public class RegisterRequest extends LoginRequest
	{
		public var userInfo:UserInfo = new UserInfo;
		
		public function RegisterRequest()
		{
			super();
		}
	}
}