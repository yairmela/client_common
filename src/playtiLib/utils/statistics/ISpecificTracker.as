package playtiLib.utils.statistics
{
	import flash.utils.getQualifiedClassName;

	public interface ISpecificTracker
	{
		function track(eventName:String, snapshot:GeneralTrackSnapshot):void;
	}
}