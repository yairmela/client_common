package playtiLib.utils.video {
	
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class NetVideo extends Sprite {
		private var video:Video;
		private var connection:NetConnection;
		private var stream:NetStream;
		private var video_url:String;
		private var center_relatively_to_stage:Boolean;
		
		public function NetVideo(video_url:String, center_relatively_to_stage:Boolean = false){
			this.video_url = video_url;
			this.center_relatively_to_stage = center_relatively_to_stage;
			
			connection = new NetConnection();
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			connection.addEventListener(NetStatusEvent.NET_STATUS, connectionStatusHandler);
			connection.connect(null);
		}
		
		private function connectionStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code){
				case "NetConnection.Connect.Success": 
					connectionSuccess();
					break;
				case "NetStream.Connect.Success": 
					break;
				case "NetConnection.Connect.Failed": 
				case "NetStream.Failed": 
				case "NetStream.Connect.Failed": 
				case "NetStream.Play.StreamNotFound": 
					netStatusErrorHandler(event.info.code);
					break;
			}
		
		}
		
		private function connectionSuccess():void {
			stream = new NetStream(connection);
			stream.client = {onMetaData: StreamOnMetaData};
			stream.addEventListener(NetStatusEvent.NET_STATUS, connectionStatusHandler);
			
			video = new Video();
			video.attachNetStream(stream);
			addChild(video);
			
			stream.play(video_url)
		}
		
		private function StreamOnMetaData(item:Object):void {
			if (center_relatively_to_stage){
				video.x = (stage.stageWidth - video.width) / 2;
				video.y = (stage.stageHeight - video.height) / 2;
			}
		}
		
		private function errorHandler(event:Event = null):void {
			trace(event);
			dispatchEvent(new Event(ErrorEvent.ERROR));
			destroy();
		}
		
		private function netStatusErrorHandler(code:String):void {
			trace(code);
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			destroy();
		}
		
		public function destroy():void {
			stream.removeEventListener(NetStatusEvent.NET_STATUS, connectionStatusHandler);
			stream.close();
			connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			connection.removeEventListener(NetStatusEvent.NET_STATUS, connectionStatusHandler);
			connection.close();
		}
	}
}