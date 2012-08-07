package playtiLib.view.components.preloaders
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.view.interfaces.IViewLogic;
	
	public class MainPreloaderVLogic implements IViewLogic
	{
		public static const REMOVE_ANIMATION_FINISHED:String = 'REMOVE_ANIMATION_FINISHED';

		public function get content():DisplayObject	{	return preloaderMc;	}
		
		protected var preloaderMc:MovieClip;
		private var progressFrameNumber:int;
		private var isFrameByFrame:Boolean;
		
		public function MainPreloaderVLogic()
		{
		}
		
		
		public function updateProgress(event:ProgressEvent):void
		{
			//this function can hanle two cases of progress bar in the preloader:
			//if the movie clip of the preloader called 'progress' - in every time that this mediator gets notification of updating the progress, it does it
			//if the movie clip called 'progress_frame_by_frame' - it's progress will be frame by frame by Event.ENTER_FRAME
			if( getGamePreloader() ){
				var ratio:Number = Math.min( event.bytesLoaded/event.bytesTotal, .9 );
				var progress_mc:MovieClip = preloaderMc['progress'] as MovieClip;
				if( !progress_mc ){
					isFrameByFrame = true;
					progress_mc = preloaderMc.getChildByName('progress_frame_by_frame') as MovieClip;
					var preloaderPrecent:MovieClip = preloaderMc.getChildByName('perc_effect2_mc') as MovieClip
					progressFrameNumber = ratio*progress_mc.totalFrames;
					if( !preloaderMc.hasEventListener( Event.ENTER_FRAME ) ){
						preloaderMc.addEventListener( Event.ENTER_FRAME, onEnterFrame );
					}
				}else
				{
					progress_mc.gotoAndStop( ratio*progress_mc.totalFrames );
				}
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			var progress_mc:MovieClip = preloaderMc.getChildByName('progress_frame_by_frame') as MovieClip;
			if( progress_mc.currentFrame < progressFrameNumber ){
				progress_mc.gotoAndStop( progress_mc.currentFrame + 1 );
				var precent:int = Math.floor( (progress_mc.currentFrame /  progress_mc.totalFrames) * 100 );
				updateProgressPrecent( progress_mc, precent );
			}else{
				preloaderMc.removeEventListener( Event.ENTER_FRAME, onEnterFrame )
			}
		}
		
		private function updateProgressPrecent(progress_mc:MovieClip, precent:int):void
		{
			var progressPrecentMc:MovieClip = progress_mc.getChildByName('perc_effect2_mc') as MovieClip;
			var progressPrecentText:TextField = progressPrecentMc.getChildByName('perc_txt') as TextField;
			progressPrecentText.text = precent + "%";
			
			progressPrecentMc = progress_mc.getChildByName('perc_effect_mc') as MovieClip;
			progressPrecentText = progressPrecentMc.getChildByName('perc_txt') as TextField;
			progressPrecentText.text = precent + "%";
			
			var percMc:MovieClip = progress_mc.getChildByName('perc_mc') as MovieClip;
			progressPrecentText = percMc.getChildByName('perc_txt') as TextField;
			progressPrecentText.text = precent + "%";
		}
		
		public function onRemove():void
		{
			if( isFrameByFrame ){
				preloaderMc.gotoAndPlay('out');
				preloaderMc.addEventListener( REMOVE_ANIMATION_FINISHED, afterAnimationRemove );
			}else{
				content.dispatchEvent( new Event(REMOVE_ANIMATION_FINISHED));
			}
		}
		
		private function afterAnimationRemove( event:Event ):void
		{
			preloaderMc.removeEventListener( REMOVE_ANIMATION_FINISHED, afterAnimationRemove );
			if( preloaderMc.hasEventListener( Event.ENTER_FRAME ) ){
				preloaderMc.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			}
			if( preloaderMc && preloaderMc.parent )
				preloaderMc.parent.removeChild( preloaderMc );
			content.dispatchEvent( new Event(REMOVE_ANIMATION_FINISHED));
		}
		
		public function removeCostumPreloader():void
		{
			//remove the preloader
			if( preloaderMc.parent )
				preloaderMc.parent.removeChild( preloaderMc );
		}
		
		public function getGamePreloader():MovieClip
		{
			if( !preloaderMc ){
				preloaderMc = GraphicsWarehouseList.getAsset( 'game_preloader' ) as MovieClip;
			}
			return preloaderMc;
		}
	}
}