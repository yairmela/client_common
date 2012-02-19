package playtiLib.model.vo.amf.social.fb
{
	import api.serialization.json.JSON;
	
	import playtiLib.model.vo.social.SNRequestDataVO;
	/**
	 * Gets an object and enters it's properties to the FB coupon object (id, date, message, sender info, reciever info) 
	 */
	public class FBRequestDataVO extends SNRequestDataVO	{
		
		public function FBRequestDataVO( data:Object ) {
			//TODO: make a configuration file for all the properties
			super( data );
			created_time 		= data['created_time'];
			message 			= data['message'];
			var inner_data:* 	= data['data'];
			inner_data 			= JSON.decode( data['data'] );
			
			coupon_token 	= String(inner_data['coupon_token']).replace( "\"", "" );
			while(coupon_token.indexOf( "\"" ) != -1 ) {
				coupon_token = coupon_token.replace( "\"", "" );			
			}
			sender_id 		= data['from']['id'];
			senderName 		= data['from']['name'];
			receiver_id 	= data['to']['id'];
			receiver_name 	= data['to']['name'];
			id 				= data['id'];
			
			invite			= inner_data['invite'];
		}
	}
}