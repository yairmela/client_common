package playtiLib.controller.commands.task {
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import playtiLib.model.proxies.task.ClientTasksProxy;
	
	public class GetTasksCommand extends SimpleCommand {
		
		override public function execute(notification:INotification):void 
		{
			if (!facade.hasProxy(ClientTasksProxy.NAME)) {
				facade.registerProxy(new ClientTasksProxy());
			}else {
				(facade.retrieveProxy(ClientTasksProxy.NAME) as ClientTasksProxy).reloadAll();
			}
		}
	}
}