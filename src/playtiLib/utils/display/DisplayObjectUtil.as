package playtiLib.utils.display
{
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * A util class that has some function that helps with display objects. Function list: getAllInstancesFromType, getAllSubInstancesFromType,
	 * searchChild, fromLabelToIndexOfFrame, convertMovieToByteArrayPicture.
	 */
	public class DisplayObjectUtil{
		
		private static const SEPERATOR:String = '.';
		/**
		 * Gets a resource(mc) and a type of class and makes a new dictionary and runs over all the mc children and their children
		 * as well and if it finds a child with the given parameter type of class, it add to dictionary. It returns the dictionary. 
		 */		
		public static function getAllInstancesFromType( resource:MovieClip, typeClass:Class ):Dictionary {
			
			var result:Dictionary = new Dictionary;
			getAllSubInstancesFromType( result, '', resource, typeClass );
			return result
		}
		/**
		 * Gets a dictionary, key, resource(movie clip) and type of class. It runs over all the resource children and adds them
		 * to the dictionary if the child type of class is as the given parameter. If the child is a resource too, 
		 * it executes this function on it recursively. 
		 */	
		private static function getAllSubInstancesFromType( dictionary:Dictionary, key:String, resource:MovieClip, typeClass:Class ):void {
			
			for ( var i:int=0; i < resource.numChildren; i++ ) {
				var child:DisplayObject = resource.getChildAt( i );
				if( child is typeClass )
					dictionary[key + SEPERATOR + child.name] = child;
				if( child is MovieClip )
					getAllSubInstancesFromType( dictionary, key + SEPERATOR + child.name, child as MovieClip, typeClass );
			}
		}
		
		public static function getAllInstanceNamed( resource:Sprite, name:String ):Array {
			var result:Array = [];
			getAllSubInstancesNamed( result, '', resource, name );
			return result
		}
		
		private static function getAllSubInstancesNamed( dictionary:Array, key:String, resource:Sprite, name:String ):void {
			for ( var i:int=0; i<resource.numChildren; i++ ) {
				var child:DisplayObject = resource.getChildAt(i);
				if( child.name == name )
					dictionary.push( child );
				if( child is MovieClip )
					getAllSubInstancesNamed( dictionary, key+SEPERATOR+child.name, child as MovieClip, name );
			}
		}
		
		/**
		 * Gets a resource(movie clip) and a child name. It runs over all the resource children and checks if their name is
		 * the same as the given parameter. If it is, it returns the child. If one of the children is a movie clip it self, it executes
		 * this function on it recursively. It returns 'null' if there is no children with this name.
		 * @param resource
		 * @param childName
		 * @return 
		 * 
		 */		
		public static function searchChild( resource:MovieClip, childName:String ):DisplayObject{
			
			for ( var i:int=0; i < resource.numChildren; i++ ) {
				var child:DisplayObject = resource.getChildAt( i );
				if( child.name == childName )
					return child;
				if( child is MovieClip )
					searchChild( child as MovieClip, childName );
			}
			return null;
		}
		/**
		 * Gets a moive clip and a frame label. It runs over all the labels in the mc and checks if one of their name is equal
		 * to the given parameter. If it is, it returns the frame number of this label and if it doesn't find an adjustment, it returns 0. 
		 * @param mc
		 * @param frameLabel
		 * @return 
		 * 
		 */		
		public static function fromLabelToIndexOfFrame( mc:MovieClip,frameLabel:String ):int{
			
			var frame:int;
			var labels:Array = mc.currentLabels;
			for( var i:int = 0; i < labels.length; i++ ){
				if( labels[i].name == frameLabel ){
					frame = labels[i].frame;
				}
			}
			return frame;
		}
		
		public static function convertMovieToByteArrayPicture( movie:DisplayObject, boundary_str:String, image_proportions:Point=null ) : ByteArray	{
			
			if( image_proportions == null )
				image_proportions = new Point( movie.width, movie.height )
			var snapshot_data:BitmapData = new BitmapData( image_proportions.x, image_proportions.y );
			snapshot_data.draw( movie );
			
			var o_png_snapshot_ba:ByteArray = PNGEncoder.encode( snapshot_data );
			var str_for_start:String = "\r\n--" + boundary_str + "\r\n" + "Content-Disposition: form-data; name=\"photo\"; filename=\"file1.png\"\r\n" + "Content-Type: image/png\r\n\r\n" + "";
			var str_for_end:String = "--" + boundary_str + "\r\n" + "Content-Disposition: form-data; name=\"Upload\"\r\n\r\n" + "Submit Query\r\n" + "--" + boundary_str + "--";
			
			var o_begin_ba:ByteArray = new ByteArray();
			o_begin_ba.writeMultiByte( str_for_start, "ascii" );
			var o_finish_ba:ByteArray  = new ByteArray();
			o_finish_ba.writeMultiByte( str_for_end, "ascii" );
			
			var o_result_bytes:ByteArray = new ByteArray();
			o_result_bytes.writeBytes(  o_begin_ba, 0, o_begin_ba.length );
			o_result_bytes.writeBytes( o_png_snapshot_ba, 0, o_png_snapshot_ba.length );
			o_result_bytes.writeBytes( o_finish_ba, 0, o_finish_ba.length );
			
			return o_result_bytes;
		}
	}
}