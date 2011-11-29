package playtiLib.controller.commands.task {
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import playtiLib.model.VO.amf.response.helpers.ClientTask;
	
	public class TaskHandlerCommand extends SimpleCommand {
		
		override public function execute(notification:INotification):void {
			//TODO:add functionality for each taskTypeId
			switch ((notification.getBody() as ClientTask).taskTypeId){
			
			}
		}
	}
}