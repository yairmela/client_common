package playtiLib.model.VO.social.user
{
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.VO.server.ArrayListVO;
	import playtiLib.model.VO.user.UserSocialInfo;
	/**
	 * An array-list class that holds in it a list of usersVO 
	 */	
	public class SocialUsersListVO extends ArrayListVO {
		
		public function SocialUsersListVO()	{
			
			super(UserSocialInfo);
		}
		
		/**
		 * Gets a json object, runs over it's sub jason objects and pushes them to array-list
		 */
		override public function buildVO( json:Object ):void {
			
			for each( var sub_jason:Object in json ) {
				list.push( SocialConfig.social_parser.parseProfile( sub_jason ) );
			}
		}
	}
}