package playtiLib.controller.commands.popup
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.view.components.popups.PopupViewLogic;

	public class SetupPopupsDisplayCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {
			
			var centerTo : Object = notification.getBody();
			
			PopupViewLogic.POPUPS_CENTER_TO_HEIGHT = centerTo["height"];
			PopupViewLogic.POPUPS_CENTER_TO_WIDTH = centerTo["width"];
		}
	}
}