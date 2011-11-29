package playtiLib.controller.commands.task {
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import playtiLib.model.proxies.task.TasksProxy;
	
	public class GetTasksCommand extends SimpleCommand {
		
		override public function execute(notification:INotification):void 
		{
			if (!facade.hasProxy(TasksProxy.NAME)) {
				facade.registerProxy(new TasksProxy());
			}else {
				(facade.retrieveProxy(TasksProxy.NAME) as TasksProxy).reloadAll();
			}
		}
	}
}