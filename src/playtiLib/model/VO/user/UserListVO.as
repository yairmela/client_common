package playtiLib.model.VO.user
{
	import playtiLib.model.VO.server.ArrayListVO;
	/**
	 * This class is an array list of the data of the user 
	 */	
	public class UserListVO extends ArrayListVO	{
		
		public function UserListVO(){
			
			super( UserSocialInfo );
		}
		
		public function get uids():String {
			
			var result:Array = list.map( function( user:UserSocialInfo, ...args ):String{ return user.sn_id ;} );
			return result.join( ',' );
		}
	}
}