package playtiLib.model.vo.amf.social.mm
{
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.utils.social.SocialUserProfileParser;
	import playtiLib.utils.social.mm.MMConfigConstants;

	public class MMSocialUserProfileParser extends SocialUserProfileParser{
		/**
		 * Gets an json object and a userVO object. If the userVO is empty - it makes a new one. It inserts to the user objectm information
		 * from the json object (id, name, photo, b-date, location object, sex, e-mail). 
		 */
		override public function parseProfile( json:Object, user:UserSocialInfo = null ):UserSocialInfo {
			
			if( !user )
				user = new UserSocialInfo();
			user.sn_id 			= String( json[MMConfigConstants.PROFILE_FIELD_UID] );
			user.first_name 	= json[MMConfigConstants.PROFILE_FIELD_FIRST_NAME] as String;
			user.last_name 		= json[MMConfigConstants.PROFILE_FIELD_LAST_NAME] as String;
			user.photo 			= json[MMConfigConstants.PROFILE_FIELD_PHOTO] as String;
			user.photo_medium 	= json[MMConfigConstants.PROFILE_FIELD_PHOTO_MEDIUM] as String;
			user.photo_big 		= json[MMConfigConstants.PROFILE_FIELD_PHOTO_BIG] as String;
			user.birthday_at 	= buildDate( json[MMConfigConstants.PROFILE_FIELD_B_DATE] as String );
			user.country_id 	= getLocationInfo( json[MMConfigConstants.PROFILE_FIELD_LOCATION],MMConfigConstants.PROFILE_FIELD_COUNTRY ) as String;
			user.city_id 		= getLocationInfo( json[MMConfigConstants.PROFILE_FIELD_LOCATION],MMConfigConstants.PROFILE_FIELD_CITY ) as String;
			user.sex 			= int( json[MMConfigConstants.PROFILE_FIELD_SEX] as String );
			user.email 			= json[MMConfigConstants.PROFILE_FIELD_EMAIL] as String;

			return user;
		}
		/**
		 * Returns a string of the profile's field that there is ',' between every two fields (uid, name, sex, b-day, address, photo)
		 * @return 
		 * 
		 */		
		override public function getProfileFiledsList():String {
			
			var a_fields_names:Array = new Array();
			a_fields_names.push( MMConfigConstants.PROFILE_FIELD_UID );
			a_fields_names.push( MMConfigConstants.PROFILE_FIELD_FIRST_NAME );
			a_fields_names.push( MMConfigConstants.PROFILE_FIELD_LAST_NAME );
			a_fields_names.push( MMConfigConstants.PROFILE_FIELD_SEX );
			a_fields_names.push( MMConfigConstants.PROFILE_FIELD_B_DATE );
			a_fields_names.push( MMConfigConstants.PROFILE_FIELD_COUNTRY );
			a_fields_names.push( MMConfigConstants.PROFILE_FIELD_TIMEZONE );
			a_fields_names.push( MMConfigConstants.PROFILE_FIELD_PHOTO );
			a_fields_names.push( MMConfigConstants.PROFILE_FIELD_PHOTO_MEDIUM );
			a_fields_names.push( MMConfigConstants.PROFILE_FIELD_PHOTO_BIG );
			return a_fields_names.join( ',' );
		}
		/**
		 * Returns the result object as Array. 
		 */		
		override public function parseUserSnIds( result:Object ):Array {
			
			return result as Array;
		} 
		/**
		 * Gets a location object, check if it isn't null and returns it's id of the info type(given parameter). If it is null, it returns '0'. 
		 * 
		 */		
		private function getLocationInfo( location:Object, infoType:String ):String 	{
			
			if ( location )
				return location[infoType]['id'];
			else
				return '0';
		}
		/**
		 * Gets a date string and returns a date object. It checks if the string is empty or null and returns null if it is and checks 
		 * if it a currect string that contain of xx/xx/xx and if not it returns null.
		 */		
		private function buildDate( dateString:String ):Date {
			
			if ( dateString == null || dateString == "")  
				return null;//new Date();
			 
			var tmp_arr:Array = dateString.split( "." );
			
			if ( tmp_arr.length != 3 ) 
				return null;//new Date();
			
			dateString = tmp_arr[2] + "/" + tmp_arr[1] + "/" + tmp_arr[0];
			
			return new Date( Date.parse( dateString ) );
		}
	}
}
