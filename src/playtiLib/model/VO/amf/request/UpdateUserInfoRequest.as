package playtiLib.model.VO.amf.request {
	
	import playtiLib.model.VO.amf.response.helpers.UserInfo;
	
	public class UpdateUserInfoRequest extends ClientRequest {
		
		public var userInfo:UserInfo;
		
		public function UpdateUserInfoRequest(){
		
		}
	}
}