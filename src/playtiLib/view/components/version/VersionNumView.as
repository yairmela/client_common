package playtiLib.view.components.version
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class VersionNumView extends Sprite{
		
		public function VersionNumView( version_num:String )	{
			
			var text_filed:TextField = new TextField();
			text_filed.autoSize = "center";
			text_filed.htmlText = '<FONT FACE="Arial" SIZE="14" COLOR="#ffffff" LETTERSPACING="0" KERNING="0"><b> version '+version_num+'</b></FONT>';
			var corner:int = 20;
			with( graphics ) {
				lineStyle( 5, 0xffffff, .15 );
				drawRoundRectComplex( -corner, 0, text_filed.textWidth+2*corner, text_filed.textHeight+corner/4, corner, corner, corner, corner );
				lineStyle( NaN );
				beginFill( 0x282828 );
				drawRoundRectComplex( -corner, 0, text_filed.textWidth+2*corner, text_filed.textHeight+corner/4, corner, corner, corner, corner);
				endFill();
			}
			addChild( text_filed );
		}
	}
}