package playtiLib.controller.commands.social.fb
{
	import by.blooddy.crypto.Base64;
	import by.blooddy.crypto.image.JPEGEncoder;
	
	import flash.display.BitmapData;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SendScreenshotCommand extends SimpleCommand
	{
		override public function execute( notification:INotification ):void {
			if (ExternalInterface.available)
			{
				var jpgBytes:ByteArray = JPEGEncoder.encode(notification.getBody() as BitmapData, 100 );
				var screenshotBase64:String = Base64.encode( jpgBytes );
				ExternalInterface.call('setScreenshot', screenshotBase64);
			}
		}
	}
}