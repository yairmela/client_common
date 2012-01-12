package playtiLib.utils.warehouse
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import playtiLib.config.server.ServerConfig;
	import playtiLib.utils.network.URLUtil;
	import playtiLib.utils.tracing.Logger;
	
	/**
	 * The Gui elements container.
	 * will supply the graphic elements at runtime.
	 **/
    public class SWFGraphicsWarehouse extends EventDispatcher {
		
		private static const LOAD_ATTEMPTS:int = 3;
		//name id generator
		private static var uid:int;
		//loader parameters
		private var name_id:String;
		protected var asset_loader:Loader;
		private var path_url:String = "";
		private var is_loaded:Boolean = false;
		private var load_attempts:int;
		
		public function SWFGraphicsWarehouse( name_id:String = null ) {
			
			this.name_id = name_id;
			// Workaround: we used 2 loaders - because URLLoader do not check security issues.
			// URLLoader loads data like bytearray and provide it to Loader; 
			asset_loader = new Loader();
			configureListeners( asset_loader.contentLoaderInfo );
		}

		public function get name():String{
			
			return (name_id)?name_id:path_url;
		}
		
		public function isContentLoaded():Boolean	{
			
			return is_loaded;
		}
		
		public function load( url:String ):void {
			
			// TODO: temporary, because of server caching. SHOULD BE DELETED
			if(!URLUtil.isRunnedLocaly() && url.indexOf('?')<0 )
				url += "?cache_id=" + ServerConfig.ASSETS_CACHE_ID;
			path_url = url;
			
			var request:URLRequest = new URLRequest( url );
			var context:LoaderContext = new LoaderContext( true );
			
	        if( !URLUtil.isRunnedLocaly() && URLUtil.isHttpURL( url ) )
	        	context.securityDomain = SecurityDomain.currentDomain;
			
			is_loaded = false;
			asset_loader.load( request, context );
			
	 	}
		
		public function loadBytes( bytes:ByteArray, context:LoaderContext=null ):void {
			
			is_loaded = false;
			asset_loader.loadBytes( bytes, context );
	 	}
		
		public function getSkinAssetClass( skinAsset:String ):Class {
			
			return asset_loader.contentLoaderInfo.applicationDomain.getDefinition( skinAsset ) as Class;
		}
	 	
		public function getSkinClass( skinAsset:String ):Class {
			
			try{
				return asset_loader.contentLoaderInfo.applicationDomain.getDefinition( skinAsset ) as Class;
	        } catch(e:Error) {
	            return null;
	        }
	        return null;
		}
		
		public function getSkinAsset( skinAsset:String ):DisplayObject {
			
			try{
				var assetClass:Class = getSkinAssetClass( skinAsset );
				var dis_obj:DisplayObject = new assetClass();
				return dis_obj;
	        } catch(e:Error) {
	            throw new IllegalOperationError( 'getSkinAsset( ' + skinAsset + ' ) - error msg: ' + e.message );
	        }
	        return null;
		}
		
		public function getSkinAssetBitmap( skinAsset:String ):DisplayObject {
			
			var con:Sprite = new Sprite();
			var asset_graphics:DisplayObject = getSkinAsset( skinAsset );
			con.addChild(asset_graphics);
			var rec:Rectangle = asset_graphics.getBounds( con );
			asset_graphics.x -= rec.x;
			asset_graphics.y -= rec.y;
			var bitmap_data:BitmapData = new BitmapData( rec.width, rec.height, true, 0 );
			bitmap_data.draw( con );
			var result:Bitmap = new Bitmap( bitmap_data,PixelSnapping.ALWAYS, true );
			result.x = rec.x;
			result.y = rec.y;
			con.removeChild( asset_graphics );
			con.addChild( result );
			return con;
		}
		
		public function hasAsset( soundAsset:String ):Boolean {
			
			try{
				var asset_class:Class = asset_loader.contentLoaderInfo.applicationDomain.getDefinition( soundAsset ) as Class;
				return asset_class!=null;
	        } catch( e:Error ) {
	        	return false;
	        }
	        return false;
		}
		
		public function getSoundAsset( soundAsset:String ):Sound {
			
			try{
				var assetClass:Class = asset_loader.contentLoaderInfo.applicationDomain.getDefinition( soundAsset ) as Class;
				return new assetClass();
	        } catch( e:Error ) {
	            throw new IllegalOperationError( "problem found with asset: " + soundAsset + " error: " + e );
	        }
	        return null;
		}
		
        public function getLoadedSWF():DisplayObject {
			
        	return this.asset_loader.content;
        }
		// **********************************************************************************************
		// AssetsLoader handlers
		// **********************************************************************************************
		
		private function configureListeners( loaderDispatcher:IEventDispatcher ):void {
			
			loaderDispatcher.addEventListener( ProgressEvent.PROGRESS,progressHandler );
			loaderDispatcher.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
	        loaderDispatcher.addEventListener( Event.COMPLETE, completeHandler );
        }
		
        private function completeHandler( event:Event ):void {
			
			Logger.log( "SWFGraphicsWarehouse completeHandler " + event.currentTarget );
			is_loaded = true;
			
       		this.dispatchEvent( event );
        }
        
		private function progressHandler( event:ProgressEvent ):void {
			
        	this.dispatchEvent( event );
        }
		
        private function ioErrorHandler( event:IOErrorEvent ):void {
			
            trace( "GraphicElements - ioError while loading: " + asset_loader.loaderInfo );
			if( load_attempts < LOAD_ATTEMPTS )
				setTimeout( load, 1000, path_url.slice( 0,path_url.indexOf( '?' ) ) + '?' + Math.random().toFixed( 5 ) );
			else
				dispatchEvent( event );
			load_attempts++;
        }
    }
}