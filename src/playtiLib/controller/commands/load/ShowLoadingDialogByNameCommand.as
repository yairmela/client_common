package playtiLib.controller.commands.load
{
	import flash.display.MovieClip;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.utils.tracing.Logger;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.view.mediators.UIMediator;
	/**
	 * Handles dialogs by showing and hiding the mediators. It gets the isShow (boolean) parameter in the notification's body and the dialog
	 * name parameter on the notification's type 
	 * and by that it removes the mediator or registers it.
	 */	
	public class ShowLoadingDialogByNameCommand extends SimpleCommand{
		
		override public function execute( notification:INotification ):void {
			
			var show:Boolean = notification.getBody() as Boolean;
			var dialog_name:String = notification.getType() as String;
			Logger.log( "ShowDialogByNameCommand name:" + dialog_name + " is_show:" + show );
			//HIDE
			if(!show) {
				facade.removeMediator( dialog_name );
				return;
			}
			//SHOW
			var dialog_mc:MovieClip = GraphicsWarehouseList.getAsset( dialog_name ) as MovieClip;
			facade.registerMediator( new UIMediator( dialog_name, dialog_mc ) );
		}
	}
}