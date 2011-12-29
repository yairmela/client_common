package playtiLib.model.VO.server
{
	import playtiLib.utils.core.ObjectUtil;

	public class DeserializedXMLModel implements IDeserializedModel
	{		
		public function buildVO( xml : Object ) : void {
			
			if ( !xml ) {
				return;
			}
			
			var properties:Array = ObjectUtil.getPropertiesType( this );
			
			var list:XMLList;
			var fieldName:String;
			var value:String;
			for each( var propertyData:Object in properties ) {
				fieldName = propertyData.name;
				
				list = xml.property.(@name == fieldName);
				
				if( !list.length() ) {
					continue;
				}
				
				value = list[0].@value.toString();
				
				if(propertyData.type == Array) {
					this[fieldName] = (value.length) ? value.split(",") : [];
				}
				else if(propertyData.type == Boolean) {
					this[fieldName] = (value == "true");
				}
				else {
					this[fieldName] = propertyData.type(value);
				}
			}
		}
	}
}