package playtiLib.model.VO.server
{
	import api.serialization.json.JSON;
	import playtiLib.utils.core.ObjectUtil;

	public class DeserializedJSONModel implements IDeserializedModel {
		
		public function DeserializedJSONModel(){
			
		}
		
		public function buildVO( json:Object ):void {
			
			if ( !json ){
				return;
			}
			
			var vo_properties:Array = ObjectUtil.getPropertiesType( this );
			for each( var property_info:Object in vo_properties ) {
				var key:String = property_info.name;
				if( json.hasOwnProperty( key ) && json[key] != null ) {
					if( new property_info.type is Date ) {//convert string to date
						this[key] = buildDate( json[key] );
					} else if( new property_info.type is Array ) {
						this[key] = parseArray( json[key] );
					} else if( new property_info.type is XML ) {
						this[key] = new XML ( json[key].result );
					} else if( new property_info.type is DeserializedJSONModel ) {//recursivly build more serverDataVOs
						var server_vo:DeserializedJSONModel = new property_info.type as DeserializedJSONModel;
						server_vo.buildVO( json[key] );
						this[key] = server_vo;
					} else {
						this[key] = json[key];
					}
				}
			}
		}
		
		private function parseArray( json:Object ):Array {
			
			if( json is Array ) {//if came as an array return as array
				return json as Array;
			} else if( json is String ) {//will parse "[1,2,3]" to array
				var arr_str:String = json as String;
				if( arr_str.search( ']' ) < 0 )
					arr_str = '[' + arr_str + ']'
				return JSON.decode( arr_str ) as Array;
			}
			var result:Array = [];
			for each( var sub_json:Object in json ) {
				result.push( parseArray( sub_json ) );
			}
			return result;
		}
		
		private function buildDate( dateString:String ):Date {
			
			dateString = dateString.split( "-" ).join( "/" );
			return new Date( Date.parse( dateString ) );
		}
	}
}