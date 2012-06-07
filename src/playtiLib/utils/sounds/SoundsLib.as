package playtiLib.utils.sounds
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.messaging.Channel;
	
	import playtiLib.utils.tracing.Logger;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.utils.warehouse.SWFGraphicsWarehouse;
	
	/**
	 * This class will hold sounds and will provide them by name
	 * You can load multiple sounds using an XML
	 *  <sound>
	 *		<sound name="test_sound" url="sound/sound/test_sound.mp3" />
	 *	</sound>
	 * @see flash.net.URLRequest
	 * @see flash.net.URLLoader
	 * @see flash.media.Sound
	 * @see flash.media.SoundChannel
	 * @see flash.media.SoundTransform
	 **/
	public class SoundsLib extends EventDispatcher	{
		
		public static const MAX_LOOPS:uint = 999999;
		private static var _lib:SoundsLib = new SoundsLib;
		
		public static function get lib():SoundsLib { 
			
			return _lib 
		}
		
		private var sounds_hash:Array = [];//will store loaded mp3 by the sound name
		private var sounds_swf_warehouses:Array = [];//will store sounds warehouses
		//loading mp3 parameters
		private var currently_loading:Boolean;
		private var load_path_prefix:String = '';
		private var mp3_load_queue:Array;
		//active sounds cash
		private var active_sounds_cash:Array = [];
		
		private var is_muted:Boolean;
		
		public function SoundsLib():void {}
		
		public function set load_prefix( loadPathPrefix:String ):void {
			
			this.load_path_prefix = loadPathPrefix;
		}
		
		/**
		 * Adds sound to the library and file it by its name
		 **/
		public function addSound( name:String, asset:Sound ):void	{
			
			sounds_hash[name] = asset;
		}
		
		/**
		 * Returns sound by its name
		 **/
		private function getSound( name:String ):Sound {
			
			if( sounds_hash[name] != null )//check the sound hash for sound
				return sounds_hash[name] as Sound
			//search the sounds warehouses for the sound
			for each( var warehouse:SWFGraphicsWarehouse in sounds_swf_warehouses ) {
				if( warehouse.hasAsset(name) ) {
					return warehouse.getSoundAsset( name );
				}
			}
			//didn't find this sound
			
			Logger.log("***** Warning ***** SoundsLib sound " + name + " was not found");
				
			return null;
		}
		
		public function hasSound( name:String ):Boolean {
			
			if( sounds_hash[name] != null ) {
				return true;
			}
		
			for each( var warehouse:SWFGraphicsWarehouse in sounds_swf_warehouses ) {
				if( warehouse.hasAsset(name) ) {
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Plays the sound at a given volume
		 **/
		public function playSound( name:String, volume:Number=1, startTime:Number=0, loops:uint=1 ):SoundChannel {
			
			if( is_muted || !getSound( name ) )
				return null;
			var sound:Sound = getSound( name );
			if( sound.bytesLoaded< sound.bytesTotal )//was not yet loaded
				return null;
			var trans:SoundTransform = new SoundTransform( volume );
			if( sound == null ) 
				return null;				
				
			var channel:SoundChannel = sound.play( startTime, loops, trans );
			if ( channel != null ) {//will happen when there are no more channels				
				channel.addEventListener( Event.SOUND_COMPLETE, removeSoundAfterComplete, false, 0, true );				
				active_sounds_cash.push( {sndChannel:channel, volume:volume, name:name} );
			}
			return channel;
		}
		
		public function stopAllSounds( soundsToSkip : Array = null ) : void {
			
			var restoreData : Array = [];
			
			if(soundsToSkip) {
				active_sounds_cash.forEach( function( element:*, index:int, arr:Array):void {
					if(soundsToSkip.indexOf(element.name) >= 0) {
						restoreData.push({name: element.name, position: (element.sndChannel as SoundChannel).position});
					}
				} );
			}
			
			SoundMixer.stopAll();
			
			while(active_sounds_cash.length) {
				removeSoundChannelFromActive(active_sounds_cash[0].sndChannel);
			}
			
			active_sounds_cash.forEach( function( element:*, index:int, arr:Array):void {
				playSound( element.name, element.position );
			} );		
		}
		
		public function isSoundActive( name:String ):Boolean {
			
			return getActiveByName( name ).length>0;
		}
		
		private function getActiveByName( name:String ):Array {
			
			return active_sounds_cash.filter( function( element:*, index:int, arr:Array):Boolean { return element.name == name } );
		}
		
		private function removeSoundAfterComplete( event:Event ):void {
			
			var channel:SoundChannel = event.currentTarget as SoundChannel;
			removeSoundChannelFromActive( channel );
		}
		
		private function removeSoundChannelFromActive( channel:SoundChannel ):void {
			
			channel.removeEventListener( Event.SOUND_COMPLETE, removeSoundAfterComplete );
			var active:Object = active_sounds_cash.filter( function( element:*, index:int, arr:Array):Boolean { return element.sndChannel == channel } )[0];
			//remove the channel from active list
			active_sounds_cash.splice( active_sounds_cash.indexOf( active ), 1 );
		}
		
		public function setActiveSoundsMute( value:Boolean ):void {
			
			//go over all the active sounds params --> {sndChannel:channel, volume:volume}
			for each( var activeSnd:Object in active_sounds_cash ) {
				activeSnd.sndChannel.soundTransform = new SoundTransform( value ? 0 : activeSnd.volume );
			}
		}
		
		public function stopSoundByName( name:String ):void {
			
			var active_of_name:Array = getActiveByName( name );
			for each( var activeSnd:Object in active_sounds_cash ) {
				if(activeSnd.name == name) {
					activeSnd.sndChannel.stop();
					removeSoundChannelFromActive( activeSnd.sndChannel );
				}
			}
		}
		
		/**
		 * Loads sounds by XML file config (fires SoundsLibrary.LOADED_ALL_SOUNDS event after all the sounds were loaded)
		 * @param url path url to the XML file;
		 **/
		public function loadSoundsByXML( url:String ):void {
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, loadedXML );
			loader.addEventListener( IOErrorEvent.IO_ERROR,  IO_Error );
			loader.load( new URLRequest( url) );
			//TODO: fix first time load ioError
		}
		
		private function IO_Error(event:IOErrorEvent):void{
			
			trace( event );
		}
		
		public function loadSoundsWarehouse( source:*, name:String=null ):void {
			
			var warehouse:SWFGraphicsWarehouse = new SWFGraphicsWarehouse( name );
			warehouse.addEventListener(IOErrorEvent.IO_ERROR, IO_Error );
			if(source is ByteArray) {
				warehouse.loadBytes(source);
			}
			else {
				warehouse.load(source);
			}
			sounds_swf_warehouses.push( warehouse );
		}
		
		public function removeSoundsWarehouse( name:String ):void {
			 
			var warehouse:SWFGraphicsWarehouse = active_sounds_cash.filter( function( element:*, index:int, arr:Array):Boolean { return element.name == name } )[0] as SWFGraphicsWarehouse;
			sounds_swf_warehouses.splice( sounds_swf_warehouses.indexOf( warehouse ), 1 );
		}
		
		private function loadedXML( event:Event ):void {
			
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener( Event.COMPLETE, loadedXML );
			
			var soundsList:XML = new XML( event.target.data );
			
			if( !mp3_load_queue )
				mp3_load_queue = [];
			
			for each( var soundData:XML in soundsList.sound) {
				mp3_load_queue.push( {name:soundData.@name, url:soundData.@url} );
			}
			
			if( !currently_loading )
				loadNextSound( null );
		}
		
		private function loadNextSound( event:Event ):void {
			
			if( mp3_load_queue.length > 0 ) {
				var next_to_load:Object = mp3_load_queue.shift();
				var new_sound:Sound = new Sound();
				new_sound.addEventListener( Event.COMPLETE, loadNextSound );
				new_sound.addEventListener( IOErrorEvent.IO_ERROR, loadNextSoundIOError );
				currently_loading = true;
				new_sound.load( new URLRequest( load_path_prefix+next_to_load.url ) );
				sounds_hash[next_to_load.name] = new_sound;
			} else {
				currently_loading = false;
				this.dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
		
		private function loadNextSoundIOError( event:IOErrorEvent ):void {
			//TODO: handle sound was'nt loaded
			
			dispatchEvent( event );
		}
		
		public function set mute( value:Boolean ):void {
			
			is_muted = value;
			setActiveSoundsMute( value );
		}
		
		public function isMuted():Boolean {
			
			return is_muted;
		}
	}
}