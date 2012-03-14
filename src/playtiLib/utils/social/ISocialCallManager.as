package playtiLib.utils.social
{
	import playtiLib.utils.server.IServerManager;

	public interface ISocialCallManager extends IServerManager
	{
		function get SNInaccessible() : Boolean;
	}
}