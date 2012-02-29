package playtiLib.controller.commands.popup
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.utils.network.URLUtil;
	
	public class OpenURLCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {
			
			URLUtil.openWindow( URLUtil.validateURL(notification.getBody() as String) );
		}
	}
}