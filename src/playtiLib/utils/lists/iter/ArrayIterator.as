package playtiLib.utils.lists.iter
{
	/**
	 * A database object that holds an array and has functionalities on this array like: 
	 * get next, hasNext, reset, get size, current index and more.  
	 */	
	public class ArrayIterator {
		
		protected var index:int;
		protected var arr:Array;
		
		public function ArrayIterator( arr:Array ){
			
			this.arr = arr;
		}
		/**
		 * Returns the value that in the next index inside the array 
		 * @return 
		 * 
		 */		
		public function next():Object{
			
			return arr[index++];
		}
		/**
		 * Returns true if the index variable is in the range of the array legnth and if the array != null and false otherwise
		 * @return 
		 * 
		 */		
		public function hasNext():Boolean{
			
			return arr!=null && index < arr.length;
		}
		/**
		 * Sets the index value to 0. 
		 * 
		 */		
		public function reset():void{
			
			index = 0;
		}
		
		public function get size():int{
			
			return this.arr.length;
		}
		
		public function get current_index():int	{
			
			return index;
		}
		
		public function get current():Object{
			
			return arr[index-1];
		}
		
		public function get array():Array{
			
			return this.arr;
		}
	}
}