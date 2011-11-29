package playtiLib.utils.user
{
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.utils.core.ObjectUtil;

	public class UserUtil	{
		/**
		 * Gets two lists (master list and slave list) and returns one merged 
		 * list. It checks if the list contains users's id or s.n users's id. In the final list, 
		 * there'll be only uniqe users.
		 * @see playtiLib.model.VO.user.UserVO
		 * @see playtiLib.utils.core.ObjectUtil
		 */		
		public static function mergeUsersList( master_list:Array, slave_list:Array ):void {
			
			for each( var user:UserSocialInfo in master_list ) {
				//search user by server game uid
				var sub_user:UserSocialInfo = getUserByUId( user.uid, slave_list );
				if( !sub_user ) //if not found search by sn_id
					sub_user = getUserBySnUId( user.sn_id, slave_list );
				if( sub_user ) { //found match
					for each( var params:Object in ObjectUtil.getPropertiesType( user ) ) {
						if( sub_user[params.name] && !user[params.name] )
							user[params.name] = sub_user[params.name];
					}
				}
			}
		}
		/**
		 * Returns the userVO by getting the user's id and the array of the users.
		 * It returns null if the id is null and if there is no match user to the given id. 
		 * 
		 */		
		public static function getUserByUId( uid:String, users:Array ):UserSocialInfo {
			
			if ( uid == null ) 
				return null;
			var match_users:Array = users.filter( function( element:UserSocialInfo, index:int, arr:Array ):Boolean { return element.uid!='' && element.uid == uid; } );
			if( match_users.length == 0 ) //if not found search by sn_id
				return null;
			return match_users[0] as UserSocialInfo;
		}
		/**
		 * Returns the userVO by getting the user's s.n id and the array of the users.
		 * It returns null if the s.n id is null and if there is no match user to the given id. 
		 * 
		 */		
		public static function getUserBySnUId( sn_id:String, users:Array ):UserSocialInfo {
			
			if ( sn_id == null ) 
				return null;
			var match_users:Array = users.filter( function( element:UserSocialInfo, index:int, arr:Array):Boolean { return element.sn_id != '' && element.sn_id == sn_id; } );
			if( match_users.length == 0 ) //if not found search by sn_id
				return null;
			return match_users[0] as UserSocialInfo;
		}
	}
}