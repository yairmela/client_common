package playtiLib.model.VO.amf.response
{
	import playtiLib.model.VO.amf.request.SessionInfo;

	public class LoginMessage extends ResultMessage
	{
		public var sessionInfo:SessionInfo;
		
		public var firstName:String;
		public var lastName:String;
		
		public function LoginMessage()
		{
		}

	}
}