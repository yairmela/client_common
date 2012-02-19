package playtiLib.model.vo.amf.request
{	
	public class UpdateClientTaskRequest extends ClientRequest
	{
		public var userTaskId:String;
		public var taskStatus:String;
		public var taskCode:String;
		public var data:String;
		
		
		public function UpdateClientTaskRequest()
		{
		}
	}
}