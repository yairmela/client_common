package playtiLib.model.vo.amf.request {
	
	import playtiLib.model.vo.amf.response.helpers.UserInfo;
	
	public class UpdateUserInfoRequest extends ClientRequest {
		
		public var userInfo:UserInfo;
		
		public function UpdateUserInfoRequest(){
		
		}
	}
}