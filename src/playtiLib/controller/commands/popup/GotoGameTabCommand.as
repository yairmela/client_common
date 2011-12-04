package playtiLib.controller.commands.popup
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GotoGameTabCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {
			
			if(ExternalInterface.available) {
				ExternalInterface.call("showGameTab");
			}
		}
	}
}