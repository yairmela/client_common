package playtiLib.controller.commands.sound
{
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.utils.sounds.SoundsLib;
	import playtiLib.utils.statistics.Tracker;

	/**
	 * Gets a boolean mute var and sets the mute parameter in soundsLib to be as the value of that parameter. It sets the soundTransform
	 * variable that in SoundMixer to be 0 if the mute value is true and 1 otherwise. It also tracks those actions.
	 * @see playtiLib.utils.sounds.SoundsLib
	 * @see flash.media.SoundMixer
	 * @see flash.media.SoundTransform
	 */	
	public class MuteSoundsCommand extends SimpleCommand
	{
		override public function execute( notification:INotification ):void {
			
			var mute:Boolean = notification.getBody() as Boolean;
			SoundsLib.lib.mute = mute;
			SoundMixer.soundTransform = new SoundTransform( mute ? 0 : 1 );
			sendNotification( GeneralAppNotifications.TRACK, null, ( mute ) ? GeneralStatistics.MUTE_SOUNDS : GeneralStatistics.MUTE_SOUNDS_CANCEL );
		}
	}
}