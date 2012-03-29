package playtiLib.model.vo.amf.response
{
	import playtiLib.model.vo.amf.request.SessionInfo;

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