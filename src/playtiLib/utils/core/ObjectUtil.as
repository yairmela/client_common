package playtiLib.utils.core
{
	import flash.net.getClassByAlias;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import playtiLib.utils.tracing.Logger;

	/**
	 * Helps to work with object's properties. It represented the object's properties
	 * by string, array and can also returns an array of the object's properties's type in array. 
	 */
	public class ObjectUtil	{
		
		public static function isInstanceOfType( instance:Object, type:Class ):Boolean {

			return (instance["constructor"] == type);
		}
		/**
		 * Returns the object's properties listed in array.
		 * @param instance
		 * @return 
		 */		
		public static function getPropertiesType( instance:Object ):Array {
						
			var result:Array = [];
			var typeDesc:XML = describeType(instance);
			for each( var prop:XML in typeDesc.variable ) {
				result.push( {name:prop.@name, type:getDefinitionByName(prop.@type)} );
			}
			return result;
		}
		/**
		 * Makes the object's properties, represented by a string type.
		 * @param instance
		 * @return 
		 */		
		public static function propertiesToString( obj:* ):String {
			var result:String = "{ ";
			var info:XML = describeType(obj);
			
			if( info.@isDynamic == 'true' ) {
				for( var prop_name:String in obj ) {
					result += ( result.length < 3 ) ? "" : ", ";
					result += prop_name+":"+String(obj[prop_name]);
				}
			} else {
				for each( var prop:XML in info.variable ) {
					result += ( result.length < 3 ) ? "" : ", ";
					if( !obj[prop.@name] || isTypeSimple( prop.@type ) ) {
						result += prop.@name+":"+ obj[prop.@name];
					} else {
						result += propertiesToString( obj[prop.@name] );
					}
				}
			}
			return result + " }";
		}
		/**
		 * Makes the object's properties, represented by an array type.
		 * @param instance
		 * @return 
		 */		
		public static function propertiesToArray( instance:Object ):Array {
			
			var result:Array = new Array();
			for( var prop:String in instance ) {
				result.push( instance[prop] );
			}
			return result;
		}
		/**
		 * Using this function you can copy properties from one object (copy_from) to the other (copy_to).
		 * The function will run over the copy_from's properties and if copy_to object has also a property with the same name it will override the value of copy_to.
		 * @param copy_from
		 * @param copy_to
		 * @return 
		 */	
		public static function setMatchingProperties( copy_from:Object, copy_to:Object ):* {
			var vo_properties:Array = getPropertiesType( copy_from );
			for each( var property_info:Object in vo_properties ) {
				var key:String = property_info.name;
				if( copy_to.hasOwnProperty( key ) ) {
					try {
						copy_to[key] = copy_from[key];
					} catch( e:Error ) { //if one of the object doesn't have the property
						Logger.log( e.message );
					}
				}
			}
			return copy_to;
		}
		
		public static function toInstance( obj:* ):* {
			if(!obj) {
				return null;
			}
			
			var info:XML = describeType(obj);
			var clazz:Class = getDefinitionByName(convertFullyQualifiedName(info.@name)) as Class;
			var result:* = new clazz();
			var prop:XML;
			for each( prop in info.variable ) {
				if( !obj[prop.@name] || isTypeSimple( prop.@type ) ) {
					result[prop.@name] = obj[prop.@name];
				} else {
					result[prop.@name] = toInstance( obj[prop.@name] );
				}
			}
			
			if (result is String) {
				result = obj;
			}
			
			if (result is Array)
				for each (var element:* in obj)
					(result as Array).push(toInstance(element));

			return result;
		}
		
		public static function convertFullyQualifiedName(className:String):String {
			return className.replace('::', '.');
		}
		
		public static function castArrayElements( array : Array, castTo : Class ) : void {
			array.forEach(function(item:*, index:int, array:Array):void {
				array[index] = castTo(item);
			});
		}
		
		private static function isTypeSimple(typeName:String):Boolean {
			switch ( typeName ) {
				case "int":
				case "Number":
				case "String":
				case "Boolean":
				case "Date":
//				case "Array":
					return true;
			}
			
			return false;
		}
	}
}