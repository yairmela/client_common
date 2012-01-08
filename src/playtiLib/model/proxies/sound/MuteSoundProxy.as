package playtiLib.model.proxies.sound
{
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import mx.charts.chartClasses.StackedSeries;
	
	import playtiLib.model.proxies.data.SharedObjectProxy;
	import playtiLib.utils.sounds.SoundsLib;
	
	public class MuteSoundProxy extends SharedObjectProxy
	{
		public static const NAME:String = 'MuteSoundProxy';
		public static const TRUE:String = 'true';
		private var viewerId:String;
		
		public function MuteSoundProxy( viewerId:String ){
			
			super(NAME);
//			deleteAll();
			this.viewerId = viewerId;
		}
		
		public function updateMuteBtn( mute:Boolean ):void{
			if( !shared.data[viewerId] ){
				shared.data[viewerId] = new Object();
			}
			shared.data[viewerId].mute = mute.toString();
			save();
			SoundsLib.lib.mute = mute;
			SoundMixer.soundTransform = new SoundTransform( mute ? 0 : 1 );
		}
		
		public function get mute():Boolean{
			return ( shared.data[viewerId] && shared.data[viewerId].mute == TRUE );
		}
	}
}