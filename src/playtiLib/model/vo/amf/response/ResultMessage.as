package playtiLib.model.vo.amf.response {
	import mx.collections.ArrayCollection;
	
	
	public class ResultMessage {
		
		public var baseItems:Array;
		
		public function ResultMessage(){
		}
		
		// TODO: remove after all server data types will use Arrays instead of ArrayCollections
		protected function convertToArray( collection : * ) : Array {
			
			if(!collection) {
				return [];
			}			
			else if(collection is ArrayCollection) {
				var array : Array = collection.toArray();
				
				var item : *;
				for(var i : int = 0; i < array.length; i++) {
					item = array[i];
					
					if(item is ArrayCollection) {
						array[i] = convertToArray(item);
					}	
				}
				
				return array;
			}

			return collection as Array;
		}
	}
}