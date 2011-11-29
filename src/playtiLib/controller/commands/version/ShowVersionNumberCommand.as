package playtiLib.controller.commands.version
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.model.proxies.config.VersionProxy;
	import playtiLib.view.mediators.version.VersionNumMediator;
	/**
	 * Checks if the facade has VersionNumMediator mediator. If yes, it removes it and if not, it takes the version number from
	 * the VersionProxy and registers a new VersionNumMediator with the version number
	 */	
	public class ShowVersionNumberCommand extends SimpleCommand{
		
		override public function execute( notification:INotification ):void {
			
			if( !facade.hasMediator( VersionNumMediator.NAME ) ) {
				var version_num:String = ( facade.retrieveProxy( VersionProxy.NAME ) as VersionProxy ).version;
				facade.registerMediator( new VersionNumMediator( version_num ) ); 
			} else {
				facade.removeMediator( VersionNumMediator.NAME );
			}
		}
	}
}