package playtiLib.utils.warehouse
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	
	import playtiLib.utils.tracing.Logger;
	/**
	 * Holds an array of all the SWFGraphicsWarehouse elements. It has only static
	 * functions that can add elements to the array, remove elements from the array, and gets those elements from the array.
	 * @see flash.display.DisplayObject
	 * @see flash.media.Sound
	 */	
	public class GraphicsWarehouseList extends EventDispatcher{
		
		protected static var warehouses_map : Array = [];
		
		/**
		 * Gets a string skin asset and returns the display object from the warehouse array. 
		 * If there is no such of display object it returns null.
		 */		
        public static function getAsset( skinAsset:String ):DisplayObject {
			
			for each( var warehouse:SWFGraphicsWarehouse in warehouses_map ) {
				if( warehouse.hasAsset( skinAsset ) )
					return warehouse.getSkinAsset( skinAsset );
			}
            return null;
        }			
		/**
		 * Get a string skin asset and return true if the warehouse array contains such skin asset and false otherwise. 
		 * @param skinAsset
		 */		
        public static function hasAsset( skinAsset:String ):Boolean {
			
        	for each( var warehouse:SWFGraphicsWarehouse in warehouses_map ) {
				if( warehouse.hasAsset( skinAsset ) )
					return true;
			}
            return false;
        }
		/**
		 * Get a string skin asset and return its Class if the warehouse array contains such. 
		 * @param skinAsset
		 */		
        public static function getClass( skinAsset:String ):Class {
			var result:Class;
        	for each( var warehouse:SWFGraphicsWarehouse in warehouses_map ) {
				result = warehouse.getSkinClass( skinAsset );
				if( result )
					return result;
			}
            return result;
        }
		/**
		 * Gets a string sound asset and returns a sound object from the warehouse array. 
		 * If there is no such of sound object it returns null. It also log this fail action.
		 */		
		public static function getSoundAsset( soundAsset:String ):Sound	{
			
			for each( var warehouse:SWFGraphicsWarehouse in warehouses_map ) {
				if( warehouse.hasAsset( soundAsset ) )
					return warehouse.getSoundAsset( soundAsset );
				Logger.log( "GraphicsWarehouseList not found in warehouse " + warehouse.name );
			}
			return null;
		}
		/**
		 * Adds swf grafics object to the first cell of the warehouse array. The other elements in the array, 
		 * are moved from thier original position to i+1. This action also been logged. 
		 */		
		public static function addNewWarehouse( warehouse:SWFGraphicsWarehouse ):void {
			
			Logger.log( "GraphicsWarehouseList addNewWarehouse " + warehouse.name );
			warehouses_map.unshift( warehouse );
		}
		/**
		 * Gets a SWFGraphicsWarehouse element name and removes it from the warehouse array. This action also been logged. 
		 */		
		public static function removeNewWarehouse( warehouse_name:String ):void {
			
			Logger.log("GraphicsWarehouseList removeNewWarehouse " + warehouse_name );
			var warehouse:SWFGraphicsWarehouse = warehouses_map.filter( function( element:*, index:int, arr:Array ):Boolean { return element.name == warehouse_name; } )[0] as SWFGraphicsWarehouse;
			if( !warehouse ) {
				Logger.log("GraphicsWarehouseList removeNewWarehouse " + warehouse_name + " *** fail *** " );
				return;
			}
			warehouses_map.splice( warehouses_map.indexOf( warehouse ), 1 );
		}
	}
}