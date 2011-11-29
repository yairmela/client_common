package playtiLib.controller.commands.social.vk
{
	import api.serialization.json.JSON;
	
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.VO.FlashVarsVO;
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.model.proxies.config.AppConfigProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.data.DataHolder;
	import playtiLib.utils.display.DisplayObjectUtil;
	import playtiLib.utils.social.vk.VkWrapperUtil;
	import playtiLib.utils.tracing.Logger;
	
	public class VKPublishToWallCommand extends SimpleCommand
	{
		public static const BOUNDARY_RAND_STRING:String = 'gc0p4Jq0M2Yt08j34c0p';
		
		private var post_image_url_path:String;
		private var post_id:String; //its id of post on VK wall
		private var post_data:SocialPostVO;
		
		override public function execute(notification:INotification):void
		{
			post_data = notification.getBody() as SocialPostVO;
			
			var data_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule([SocialCallsConfig.SOCIAL_GET_PHOTO_UPLOAD_SERVER]);
			data_capsule.addEventListener(Event.COMPLETE, onGetPhotoServer);
			data_capsule.loadData();
		}
		
		private function onGetPhotoServer(event:Event):void
		{
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			dataCapsule.removeEventListener(Event.COMPLETE, onGetPhotoServer);
			var dataHolder:DataHolder = dataCapsule.getDataHolderByIndex(0);
			post_image_url_path = dataHolder.data.upload_url as String;
			
			// prepare image
			var imageBA:ByteArray = DisplayObjectUtil.convertMovieToByteArrayPicture(post_data.image_to_post, BOUNDARY_RAND_STRING, new Point(130,130));
			Logger.log("postMovie saveImageToVkontakte");
			
			var url:String = post_image_url_path;
			var urlRequestPOST:URLRequest = new URLRequest(url);
			urlRequestPOST.method = URLRequestMethod.POST;
			
			// new workaround for 
			urlRequestPOST.requestHeaders.push(new URLRequestHeader("Content-type", "multipart/form-data; boundary=" + BOUNDARY_RAND_STRING));
			urlRequestPOST.data = imageBA ;
			
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, onUploadComplete);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loader.load(urlRequestPOST);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			Logger.log("securityErrorHandler: " + event);
			clearListeners(event.currentTarget as URLLoader);
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_COMPLETE, false);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			
			Logger.log("httpStatusHandler: " + event);
			clearListeners(event.currentTarget as URLLoader);
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_COMPLETE, false);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Logger.log("ioErrorHandler: " + event);
			clearListeners(event.currentTarget as URLLoader);
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_COMPLETE, false);
		}
		
		private function onUploadComplete(event: Event): void 
		{
			Logger.log("Upload complete");
			clearListeners(event.currentTarget as URLLoader);
			var data: Object = JSON.decode(event.target["data"]);	
			if (data.photo) 
			{
				for(var i:Object in data)
					Logger.log("onUploadComplete data: "+ i + " = " + data[i]);
				data.message = post_data.descreiption;
				data.wall_id = post_data.user_sn_id;
				data.post_id = data.hash;
				post_id = data.hash;
				
				var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule([SocialCallsConfig.getSocialWallSavePostCallConfig(data)]);
				dataCapsule.addEventListener(Event.COMPLETE, onWallSavePost);
				dataCapsule.loadData();
			}
		}
		
		private function onWallSavePost(event:Event):void
		{
			Logger.log("onWallSavePost");
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			dataCapsule.removeEventListener(Event.COMPLETE, onWallSavePost);
			var dataHolder:DataHolder = dataCapsule.getDataHolderByIndex(0);
			var response:Object = dataHolder.data;
			
			for(var i:Object in response)
				Logger.log("onWallSavePost response: "+ i + " = " + response[i]);
			
			VkWrapperUtil.getInstance().addEventListener(VkWrapperUtil.EVENT_onWallPostSave, onWallPostSaveCompleted);
			VkWrapperUtil.getInstance().addEventListener(VkWrapperUtil.EVENT_onWallPostCancel, onWallPostSaveCanceled);
			
			VkWrapperUtil.getInstance().saveWallPost(response.post_hash);
		}
		
		private function onWallPostSaveCompleted(event:Event):void
		{
			Logger.log("onWallPostSaveCompleted");
			clearListeners();
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_APPROVED, post_data, post_id);
		}
		
		private function onWallPostSaveCanceled(event:Event):void
		{
			Logger.log("onWallPostSaveCanceled");
			clearListeners();
			sendNotification(GeneralAppNotifications.PUBLISH_TO_WALL_COMPLETE, false);
		}
		
		private function clearListeners(loader:URLLoader = null):void
		{
			if(loader)
			{
				loader.removeEventListener(Event.COMPLETE, onUploadComplete);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
				
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onWallPostSave, onWallPostSaveCompleted);
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onWallPostCancel, onWallPostSaveCanceled)
		}
		
		private function get appConfigProxy():AppConfigProxy
		{
			return facade.retrieveProxy(AppConfigProxy.NAME) as AppConfigProxy;
		}
	}
}