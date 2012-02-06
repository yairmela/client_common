package playtiLib.controller.commands.sound
{
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.proxies.user.UserPreferencesProxy;
	import playtiLib.utils.sounds.SoundsLib;

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
			
			var muteValue:Boolean = notification.getBody() as Boolean;
			var userPreferencesProxy :UserPreferencesProxy = ( facade.retrieveProxy( UserPreferencesProxy.NAME ) as UserPreferencesProxy );
			userPreferencesProxy.setProperties( {mute: muteValue} );
			SoundsLib.lib.mute = muteValue;
			SoundMixer.soundTransform = new SoundTransform( muteValue ? 0 : 1 );			
		}
	}
}