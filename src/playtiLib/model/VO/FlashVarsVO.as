package playtiLib.model.VO
{
    import com.adobe.serialization.json.JSON;
    
    import playtiLib.config.server.ServerCallConfig;
    import playtiLib.utils.tracing.Logger;

	/**
	 * Holds all the data of the flash vars casting to its type for MM, VK anf FB 
	 */
	public class FlashVarsVO {
		
		public var parameters:Object;
		
		public function get assets_server_path():String {
			
			return getCastedProperty("assets_server_path", String);
		}

		public function get api_url():String { 		return getCastedProperty( "api_url", String ); }
		public function get api_id():String { 		return getCastedProperty( "api_id", String );}
		public function set api_id( id:String ):void { parameters["api_id"] = id }

		public function get is_like_app():Boolean {
			
			return getCastedProperty( "is_like", int ) == 1;
		}

		public function get account_type():String {
			
			return getCastedProperty( "account_type", String );
		}

		public function get viewer_id():String {
			
			return getCastedProperty( "viewer_id", String );
		}
		
		public function get session_id():String {
			
			return getCastedProperty( "session_id", String );
		}
		
		public function set viewer_id( id:String ):void {
			
//			parameters["vid"] = id;
		}

		public function get is_app_user():Boolean { return parameters.hasOwnProperty("is_app_user") && parameters["is_app_user"]  == "1" }
		public function set is_app_user( value:Boolean ):void { parameters["is_app_user"]  = value?"1":"0" }

		public function get viewer_type():int { return getCastedProperty( "viewer_type", int ) }
		public function get auth_key():String { return getCastedProperty( "auth_key", String ) }
		public function get language():String { return getCastedProperty( "locale", String ) }
		public function get locale():String { return getCastedProperty( "locale", String ) }
		public function get api_result():String { return getCastedProperty( "api_result", String ) }

		public function get api_settings():int { return getCastedProperty( "api_settings", int ) }
		public function set api_settings( id:int ):void { parameters["api_settings"] = id }

		public function get couponsExpiredDays():int { return getCastedProperty( "coupons_expired_days", int ) }
		public function get serverDate():String { return getCastedProperty( "server_date", String ) }
		//instalation url params***********************************

		//MM
		public function get oid():String {			return getCastedProperty( "oid", String );	}
		public function get referer_type():String {	return getCastedProperty( "referer_type", String );	}
		public function get site_id():String {		return getCastedProperty( "site_id", String )}
		//FB
		// register
		public function get ch_c():String {			return getCastedProperty( "ch_c", String );	}
		public function get et_c():String {			return getCastedProperty( "et_c", String );	}
		public function get crt_c():String {		return getCastedProperty( "crt_c", String );}
		public function get pid_c():String {		return getCastedProperty( "pid_c", String );}
		public function get src_c():String {		return getCastedProperty( "src_c", String );}
		public function get iid_c():String {		return getCastedProperty( "iid_c", String );}
		//login
		public function get ch():String {			return getCastedProperty( "ch", String );}
		public function get et():String {			return getCastedProperty( "et", String );}
		public function set et( value:String ):void {	parameters["et"] = value; }
		public function get crt():String {			return getCastedProperty( "crt", String );}
		public function set crt( value:String ):void { parameters["crt"] = value; }
		public function get pid():String {			return getCastedProperty( "pid", String );}
		public function set pid( value:String ):void { parameters["pid"] = value; }
		public function get src():String {			return getCastedProperty( "src", String );}
		public function get iid():String {			return getCastedProperty( "iid", String );}
		public function get request_ids():String {	return getCastedProperty( "request_ids", String );}
		public function set request_ids(request_ids:String):void {	parameters["request_ids"] = request_ids;}

		public function get coupon_token():String {	return getCastedProperty( "coupon_token", String );	}
		public function set coupon_token(coupon_token:String):void {parameters["coupon_token"] = coupon_token;}
		//VK
		public function get referrer():String {		return getCastedProperty( "referrer", String );	}
		public function get poster_id():String{		return getCastedProperty( "poster_id", String );}
		public function get post_id():String {		return getCastedProperty( "post_id", String );}
		public function get user_id():String {		return getCastedProperty( "user_id", String );}
		public function get group_id():int { return getCastedProperty( "group_id", int ); }

		public function set post_id( value:String ):void { parameters["post_id"] = value; }
		//******************************************************

		public function get gift_token():String {
			
			var token:String = getCastedProperty( "gift_token", String );
			if ( token == null ){
				token = getCastedProperty( "post_id", String ); //for VK get post_id like gift_token
			}
			return  token;
		}
		public function set gift_token( value:String ):void { parameters["gift_token"] = value; }

		public function FlashVarsVO( parameters:Object ){
			
			this.parameters = parameters;
			for( var i:String in parameters ){
				Logger.log( "FlashVarsVO ['"+i+"'] = " + parameters[i] );
			}
		}

		protected function getCastedProperty( name:String, cast:Class ):* {
			
			if( !parameters.hasOwnProperty( name ) )
				return null;
			return cast( parameters[name] );
		}
		
		public function toString() : String {
			
			return JSON.encode(parameters);
		}
	}
}
