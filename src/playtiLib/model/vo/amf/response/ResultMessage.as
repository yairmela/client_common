package playtiLib.model.vo.amf.response {
	import mx.collections.ArrayCollection;
	
	
	public class ResultMessage {
		
		public var baseItems:Array;
		
		public function ResultMessage(){
		}
		
		protected function convertArrayCollectionToArray( collection : ArrayCollection ) : Array {
			
			if(!collection) {
				return [];
			}
			
			var array : Array = collection.toArray();
			
			var item : *;
			for(var i : int = 0; i < array.length; i++) {
				item = array[i];
				
				if(item is ArrayCollection) {
					array[i] = convertArrayCollectionToArray(item);
				}	
			}
			
			return array;
		}
	}
}