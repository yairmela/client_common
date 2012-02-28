package playtiLib.controller.commands.popup
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.utils.network.URLUtil;
	
	public class OpenURLCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {
			
			var url : String = validateURL(notification.getBody() as String);
			
			URLUtil.openWindow(url);
		}
		
		private function validateURL( url : String ) : String {
			
			if( !URLUtil.isHttpURL(url) ) {
				url = "http://"+url;
			}
			
			return url;
		}
	}
}