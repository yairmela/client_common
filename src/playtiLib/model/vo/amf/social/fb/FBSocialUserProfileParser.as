package playtiLib.model.vo.amf.social.fb
{
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.utils.social.SocialUserProfileParser;
	import playtiLib.utils.social.fb.FBConfigConstants;

	public class FBSocialUserProfileParser extends SocialUserProfileParser	{
		/**
		 * Gets an json object and a userVO object. If the userVO is empty - it makes a new one. It inserts to the user objectm information
		 * from the json object (id, name, photo, b-date, location object, sex, e-mail). 
		 */
		
		override public function parseProfile( json:Object, user:UserSocialInfo = null ):UserSocialInfo {
			
			if( !user )
				user = new UserSocialInfo();
			user.sn_id 			= String( json[FBConfigConstants.PROFILE_FIELD_UID] );
			user.first_name 	= json[FBConfigConstants.PROFILE_FIELD_FIRST_NAME] as String;
			user.last_name 		= json[FBConfigConstants.PROFILE_FIELD_LAST_NAME] as String;
			user.photo 			= ( json[FBConfigConstants.PROFILE_FIELD_PHOTO] as String ).replace('_t.jpg','_q.jpg');;
			user.photo_medium 	= json[FBConfigConstants.PROFILE_FIELD_PHOTO_MEDIUM] as String;
			user.photo_big 		= json[FBConfigConstants.PROFILE_FIELD_PHOTO_BIG] as String;
			user.birthday_at 	= buildDate(json[FBConfigConstants.PROFILE_FIELD_B_DATE] as String);
			//location parser*****************************
			var location_obj:Object;
			
			if ( json.hasOwnProperty( FBConfigConstants.PROFILE_CURRENT_LOCATION ) && json[FBConfigConstants.PROFILE_CURRENT_LOCATION]!= null ){
				location_obj = json[FBConfigConstants.PROFILE_CURRENT_LOCATION];
			}else if ( json.hasOwnProperty( FBConfigConstants.PROFILE_HOMETOWN_LOCATION ) ){
				location_obj = json[FBConfigConstants.PROFILE_HOMETOWN_LOCATION];
			} 
			//TODO: make a configuration file for all the flash vars
			if ( location_obj != null ){
				user.country_id = location_obj.hasOwnProperty('country') ? location_obj['country'] as String : '';
				user.city_id = location_obj.hasOwnProperty('city') ? location_obj['city'] as String : '';
			}
			//**********************************************
			var sex:String = json[FBConfigConstants.PROFILE_FIELD_SEX] as String
			user.sex = sex == "male" ? 2 : sex == "female" ? 1 : 0;
			
			user.email = json[FBConfigConstants.PROFILE_FIELD_EMAIL] as String;
			return user;
		}
		/**
		 * Returns a string of the profile's field that there is ',' between every two fields (uid, name, sex, b-day, address, photo, mail)
		 * @return 
		 * 
		 */		
		override public function getProfileFiledsList():String {
			
			var a_fields_names:Array = new Array();
			a_fields_names.push( FBConfigConstants.PROFILE_FIELD_UID );
			a_fields_names.push( FBConfigConstants.PROFILE_FIELD_FIRST_NAME );
			a_fields_names.push( FBConfigConstants.PROFILE_FIELD_LAST_NAME );
			a_fields_names.push( FBConfigConstants.PROFILE_FIELD_SEX );
			a_fields_names.push( FBConfigConstants.PROFILE_FIELD_B_DATE );
			a_fields_names.push( FBConfigConstants.PROFILE_CURRENT_LOCATION );
			a_fields_names.push( FBConfigConstants.PROFILE_HOMETOWN_LOCATION );
			a_fields_names.push( FBConfigConstants.PROFILE_FIELD_PHOTO );
			a_fields_names.push( FBConfigConstants.PROFILE_FIELD_PHOTO_MEDIUM );
			a_fields_names.push( FBConfigConstants.PROFILE_FIELD_PHOTO_BIG );
			a_fields_names.push( FBConfigConstants.PROFILE_FIELD_EMAIL );
			return a_fields_names.join( ',' );
		}
		/**
		 * Gets an object, runs over it's properties and push them uid propety to an array. It returns this array of the users id. 
		 * @param result
		 * @return 
		 * 
		 */		
		override public function parseUserSnIds( result:Object ):Array {
			
			var ids:Array = [];
			for each( var friend:Object in result ) {
				ids.push( friend.uid );
			}
			return ids;
		} 
		/**
		 * Gets a date string and returns a date object. It checks if the string is empty or null and returns null if it is and checks 
		 * if it a currect string that contain of xx/xx/xx and if not it returns null.
		 */			
		private function buildDate( dateString:String ):Date {
			
			if ( dateString == null || dateString == "") {
				return null;// new Date();
			}
			
			var tmp_arr:Array = dateString.split( "/" );
			
			if ( tmp_arr.length != 3 )
				return null;//new Date();
			
			dateString = tmp_arr[2] + "/" + tmp_arr[1] + "/" + tmp_arr[0];
			
			return new Date( Date.parse( dateString ) );
		}
	}
}
