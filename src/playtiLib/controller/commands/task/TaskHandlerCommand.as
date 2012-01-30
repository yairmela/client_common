package playtiLib.controller.commands.task {
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import playtiLib.model.proxies.task.TasksProxy;
	import playtiLib.model.VO.amf.response.helpers.ClientTask;
	
	public class TaskHandlerCommand extends SimpleCommand {
		
		private var task:ClientTask; 
        
		override public function execute(notification:INotification):void {
            task = notification.getBody() as ClientTask;
                     switch(task.taskTypeId){
                           case ClientTask.PAYMENT:
                                  switch(task.taskId){
                                         case ClientTask.UNDEF_PAYMENT:
                                                break;
                                         case ClientTask.VK_PAYMENT:
                                                break;
                                         case ClientTask.OD_PAYMENT:
                                                break;
                                         case ClientTask.MM_PAYMENT:
                                                break;
                                         case ClientTask.FB_PAYMENT:
                                                try{
                                                       task.taskData = JSON.decode(task.taskData as String);
                                                       var requestURL:URLRequest = new URLRequest(task.taskData.url as String);
                                                       var loader:URLLoader = new URLLoader();
                                                       loader.addEventListener(Event.COMPLETE, onUrlLoad);
                                                       loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlLoadSecurityError);
                                                       loader.load(requestURL);
                                                }catch(e:Error){
                                                       trace(e.message);
                                                }
                                                break;
                                         case ClientTask.PAYPAL_PAYMENT:
                                                break;
                                         case ClientTask.SUPERREWARDS_PAYMENT:
                                                break;
                                         case ClientTask.APPLE_PAYMENT:
                                                break;
                                  }
                                  break;
                           
                           default:
                                  break;
                     }
        }
        
		private function onUrlLoad(event:Event):void{
            var loader:URLLoader = event.target as URLLoader;
            onTaskComplete();
        }
        
		private function onUrlLoadSecurityError(event:Event):void{
            var loader:URLLoader = event.target as URLLoader;
            ExternalInterface.call("generatePixelIframe", task.taskData.url);
            onTaskComplete();
        }
              
        private function onTaskComplete():void{
            task.userTaskStatus = 1;
            task.userTaskCode = 0;
            (facade.retrieveProxy( TasksProxy.NAME) as TasksProxy).setTaskComplete(task);             
        }

	}
}