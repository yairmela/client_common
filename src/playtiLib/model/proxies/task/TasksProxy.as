package playtiLib.model.proxies.task {
	
	import flash.events.Event;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.proxies.data.DataCapsuleProxy;
	import playtiLib.model.VO.amf.response.ClientTasksMessage;
	import playtiLib.model.VO.amf.response.helpers.ClientTask;
	
	public class TasksProxy extends DataCapsuleProxy {
		
		public static const NAME:String = 'TasksProxy';
		
		private var tasks:Array = [];
		
		public function TasksProxy(){
			super(NAME, [AMFGeneralCallsConfig.GET_CLIENT_TASKS]);
		}
		
		override protected function onDataReady(event:Event):void {
			var new_tasks:Array = getNewTasks((data_capsule.getDataHolderByIndex(0).server_response.result as ClientTasksMessage).clientTasks);
			tasks = tasks.concat(new_tasks);
			for each (var task:ClientTask in new_tasks){
				sendNotification(GeneralAppNotifications.TASK_HANDLER, task);
			}
		}
		
		private function getNewTasks(incoming_tasks:Array):Array {
			for (var i:int = 0; i < incoming_tasks.length; i++){
				for (var j:int; j < tasks.length; j++){
					if ((incoming_tasks[i] as ClientTask).taskId == (tasks[j] as ClientTask).taskId){
						incoming_tasks.splice(i, 1);
						i--;
					}
				}
			}
			return incoming_tasks;
		}
	}
}