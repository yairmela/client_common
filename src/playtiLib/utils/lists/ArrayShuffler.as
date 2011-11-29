package playtiLib.utils.lists
{
	/**
	 * A database object that holds an array and has a shuffle function. 
	 */	
	public class ArrayShuffler{
		/**
		 * Gets an array and returns the values of this array but in different random order. 
		 * @param arr
		 * @return 
		 * 
		 */		
		public static function shuffle( arr:Array ):Array	{
			
			if( arr == null || arr.length < 2 )
				return arr;
			
			var shuffled:Array = arr.concat();
			var temp:*;
			var index:int;
			for( var i:uint = 0; i < shuffled.length; i++ ) {
				index 			= int( Math.random() * ( shuffled.length-1 ) );
				temp 			= shuffled[index];
				shuffled[index] = shuffled[i];
				shuffled[i] 	= temp;
			}
			return shuffled;
		}
	}
}