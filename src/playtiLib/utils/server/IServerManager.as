package playtiLib.utils.server
{
 	import flash.events.IEventDispatcher;
	
 	public interface IServerManager extends IEventDispatcher{
		
		function send( server_url:String,
					   module:String, 
					   command:String, 
					   params:Object, 
					   on_result_func:Function, 
					   on_io_error_func:Function ):void	
	}
}