package playtiLib.model.vo.amf.request
{	
	public class ClientRequest
	{
		public var sessionInfo:SessionInfo;
		
		public var cmd:String;
		public var cheat:String;
				
		// TODO: reset default value to vary
		public var guest : Boolean = true;
		
		public function ClientRequest()
		{
		}
	}
}