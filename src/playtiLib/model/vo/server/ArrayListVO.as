package playtiLib.model.vo.server
{
	/**
	 * Holds the cildren's type and a list array. 
	 */	
	public class ArrayListVO extends DeserializedJSONModel	{
		
		private var children_type:Class;
		protected var list_arr:Array = [];
		
		public function ArrayListVO( children_type:Class = null){
			
			super();
			if( children_type != null && !( new children_type is DeserializedJSONModel ) )
				throw new Error( 'ArrayListVO.children_type must be from type ServerDataVO' );
			this.children_type = children_type;
		}
		
		public function get list_copy():Array {
			
			return list_arr.concat();
		}
		
		public function get list():Array{
			
			return list_arr;
		}
		
		public function set list( value:Array ):void{
			
			list_arr = value;
		}
		/**
		 * Gets a json object, goes over all it's properties and push it to list 
		 * @param json
		 * 
		 */		
		override public function buildVO( json:Object ):void {
			
			if ( children_type == null ) return;
			for each( var sub_jason:Object in json ) {
				var sub_vo:DeserializedJSONModel = new children_type();
				sub_vo.buildVO( sub_jason );
				list.push( sub_vo );
			}
		}
	}
}