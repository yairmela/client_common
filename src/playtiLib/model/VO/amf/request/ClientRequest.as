package playtiLib.model.VO.amf.request
{
	import playtiLib.model.VO.amf.cheat.CheatType;

	public class ClientRequest
	{
		public var sessionInfo:SessionInfo;
		
		public var cmd:String;
		public var cheat:String;
		
		
		public function ClientRequest()
		{
		}
	}
}