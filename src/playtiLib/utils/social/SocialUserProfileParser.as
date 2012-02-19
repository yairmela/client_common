package playtiLib.utils.social
{
	import playtiLib.model.VO.user.UserSocialInfo;

	public class SocialUserProfileParser{
		
		public function parseProfile( json:Object, user:UserSocialInfo = null ):UserSocialInfo {
			
			return new UserSocialInfo();
		}
		
		public function getInstallationsParams():Object {
			
			return {};
		}
		
		public function getInstallationsParamsForLogin():Object {
			
			return {};
		}
		
		public function getProfileFiledsList():String {
			
			//future implemntation can pass filters upon this request
			return '';
		}
		
		public function parseUserSnIds( result:Object ):Array {
			
			return [];
		}
		
		public function parseSnRequests ( result:Object ):Array {
			
			return [];
		}
		
		public function parseFriendsInfo ( result:Object ):Array {
			
			return [];
		}
	}
}
