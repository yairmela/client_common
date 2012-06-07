package playtiLib.utils.data
{
	import com.adobe.serialization.json.JSON;
	
	import playtiLib.config.server.ServerCallConfig;

	public class DataServerResponseVO{
		
		public var response_str:String 	= "";
		public var response_json:Object 	= null;
		public var cmd:String 			= "";
		public var response_code:int 	= -1; 
		public var error_desc:String 	= "";
		public var result:Object 		= null;
		
		/**
		 * serverCallbeckFormat - shuld be taken from ServerCallConfig static constants
		 * */
		public function DataServerResponseVO( responseStr:String, serverCallbeckFormat:String ){
			
			this.response_str = responseStr;
			if( serverCallbeckFormat == ServerCallConfig.CALLBACK_JSON_FORMAT )	
				parseJSONResponse( responseStr );
			else if( serverCallbeckFormat == ServerCallConfig.CALLBACK_XML_FORMAT )
				parseXMLResponse( responseStr );
		}
		
		private function parseJSONResponse( responseStr:String ):void	{
			
			try{
				response_json = JSON.decode( responseStr );
				this.cmd = response_json.cmd as String;
				this.response_code = response_json.hasOwnProperty( "service" ) ? response_json.service.code : response_json.code as int; 
				//this.error_desc = response_json.service.error_desc as String;
				this.result = response_json.result as Object;
			}catch( e:Error ){
				trace( e.message );
			}
		}
		
		private function parseXMLResponse( responseStr:String ):void{
			
			var response : Object = new XML( responseStr );
		}
		
	}
}