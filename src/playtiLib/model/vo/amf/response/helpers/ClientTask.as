package playtiLib.model.vo.amf.response.helpers {
	
	public class ClientTask {
		
		//task ids
        public static const UNDEF_PAYMENT:int = 0;
        public static const VK_PAYMENT:int = 1;
        public static const OD_PAYMENT:int = 2;
        public static const MM_PAYMENT:int = 3;
        public static const FB_PAYMENT:int = 4;
        public static const PAYPAL_PAYMENT:int = 5;
        public static const SUPERREWARDS_PAYMENT:int = 6;
        public static const APPLE_PAYMENT:int = 7;
              
        //task type ids
        public static const PAYMENT:int = 1;

		
		public var taskId:int;
		public var taskParams:Object;
		public var userTaskId:int;
		public var taskName:String;
		public var taskTypeId:int;
		public var taskData:Object;
		
		//response params
        public var userTaskStatus:int;
        public var userTaskCode:int;

		public function ClientTask(){
		
		}
	}
}