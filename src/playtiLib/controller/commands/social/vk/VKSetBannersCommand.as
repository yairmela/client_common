package playtiLib.controller.commands.social.vk
{
	import com.bit.apps.banerrotator.AppgradeBannerRotator;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	
	public class VKSetBannersCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var game_banners_id:int = notification.getBody() as int;
			var banners_mc:MovieClip = new MovieClip();
			banners_mc.graphics.beginFill( 0xF7F7F7 );
			banners_mc.graphics.drawRect( 0,630,760,100 );
			AppgradeBannerRotator.init_rotator(banners_mc, game_banners_id, 5, 630, 750);
			sendNotification( GeneralAppNotifications.ADD_CHILD_TO_ROOT, banners_mc );
		}
	}
}