package playtiLib.model.vo.amf.request
{
	import playtiLib.utils.core.ObjectUtil;

	public class SessionInfo
	{
		public var sessionId:String;
		public var userSnId:String;
		public var userDbId:int;
		public var language:String;
		public var guid:String;
		
		public function clone() : SessionInfo {

			return ObjectUtil.setMatchingProperties( this, new SessionInfo() );
		}
	}
}