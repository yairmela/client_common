package playtiLib.model.VO.social.vk
{
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.utils.social.SocialUserProfileParser;
	import playtiLib.utils.social.vk.VKConfigConstants;
	import playtiLib.utils.tracing.Logger;

	public class VKSocialUserProfileParser extends SocialUserProfileParser
	{
		override public function parseProfile( json:Object, user:UserSocialInfo = null ):UserSocialInfo {
			
			if( !user )
				user = new UserSocialInfo;
			user.sn_id		 	= String( json[VKConfigConstants.PROFILE_FIELD_UID] );
			user.first_name 	= json[VKConfigConstants.PROFILE_FIELD_FIRST_NAME] as String;
			user.last_name 		= json[VKConfigConstants.PROFILE_FIELD_LAST_NAME] as String;
			user.photo 			= json[VKConfigConstants.PROFILE_FIELD_PHOTO] as String;
			user.photo_medium 	= json[VKConfigConstants.PROFILE_FIELD_PHOTO_MEDIUM] as String;
			user.photo_big 		= json[VKConfigConstants.PROFILE_FIELD_PHOTO_BIG] as String;
			user.birthday_at 	= buildDate( json[VKConfigConstants.PROFILE_FIELD_B_DATE] as String );
			user.city_id 		= json[VKConfigConstants.PROFILE_FIELD_CITY] as String;
			user.country_id 	= json[VKConfigConstants.PROFILE_FIELD_COUNTRY] as String;
			user.sex 			= int( json[VKConfigConstants.PROFILE_FIELD_SEX] as String );

			return user;
		}
		
		override public function getProfileFiledsList():String {
			
			var a_fields_names:Array = new Array();
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_UID );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_FIRST_NAME );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_LAST_NAME );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_NICKNAME );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_SEX );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_B_DATE );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_CITY );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_COUNTRY );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_TIMEZONE );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_PHOTO );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_PHOTO_MEDIUM );
			a_fields_names.push( VKConfigConstants.PROFILE_FIELD_PHOTO_BIG );
			
			return a_fields_names.join(',');
		}
		
		private function buildDate( dateString:String ):Date {
			
			if ( dateString == null || dateString == "") {
				return null//new Date();
			}
			
			var tmp_arr:Array = dateString.split(".");
			if ( tmp_arr[0] == null || tmp_arr[1] == null ){
				return null//new Date();
			}
			
			if( tmp_arr[2]==null )
				tmp_arr[2] = "0000";
			
			dateString = tmp_arr[2]+"/"+tmp_arr[1]+"/"+tmp_arr[0];
			return new Date( Date.parse( dateString ) );
		}
		
		override public function parseUserSnIds( result:Object ):Array {
			
			return result as Array;
		}
	}
}
