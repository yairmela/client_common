package playtiLib.controller.commands.social.vk
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	
	public class VKOpenPayPageCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			sendNotification(GeneralAppNotifications.FULLSCREEN_MODE,false);
			ExternalInterface.call('showPayPage');
		}
		
		
	}
}