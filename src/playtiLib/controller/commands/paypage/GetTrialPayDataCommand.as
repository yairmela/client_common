package playtiLib.controller.commands.paypage
{
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.model.proxies.user.UserProxy;
	
	public class GetTrialPayDataCommand extends SimpleCommand {
		
		public override function execute( notification:INotification ):void {
			if (ExternalInterface.available)
			{
				ExternalInterface.call('insertDealSpot', userProxy.user_info.payer, userProxy.user_info.userCreateTs);
			} 
		}
		
		protected function get userProxy() : UserProxy {			
			return (facade.retrieveProxy(UserProxy.NAME) as UserProxy);
		}
	}
}