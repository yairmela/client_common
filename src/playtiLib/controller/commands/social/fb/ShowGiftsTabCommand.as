package playtiLib.controller.commands.social.fb 
{
	import flash.external.ExternalInterface;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	

	public class ShowGiftsTabCommand extends SimpleCommand 
	{
		
		override public function execute( notification:INotification ):void {
			ExternalInterface.call('showGiftsTab');
		}
		
	}

}