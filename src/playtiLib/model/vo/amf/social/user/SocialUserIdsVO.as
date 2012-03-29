package playtiLib.model.vo.amf.social.user
{
	import playtiLib.config.social.SocialConfig;
	import playtiLib.model.vo.server.DeserializedJSONModel;
	/**
	 * Holds an array of the user SN ids  
	 */	
	public class SocialUserIdsVO extends DeserializedJSONModel	{
		
		public var ids:Array;
		
		public function SocialUserIdsVO()	{
			
			super();
		}
		/**
		 * Returns a string of the ids from the id-array, seperate with ','
		 * @return 
		 * 
		 */		
		public function toString():String {
			
			if( !ids )
				return '';
			return ids.join( ',' );
		}
		/**
		 * Gets a json object and inserts the id-array ids from the json.
		 */		
		override public function buildVO( json:Object ):void {
			
			ids = SocialConfig.social_parser.parseUserSnIds( json );
		}
	}
}