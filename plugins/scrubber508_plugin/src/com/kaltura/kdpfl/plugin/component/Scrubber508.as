package com.kaltura.kdpfl.plugin.component
{
	//import com.kaltura.kdpfl.component.IComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;

 
	public class Scrubber508 extends Sprite //implements IComponent
	{
		private var _mcProgress:MovieClip;
		private var _mcPlayhead:MovieClip;
		private var _duration:Number = 0;
		private var _progressWidth:Number;
		private var _playheadWidth:Number;
		private var _textDuration:TextField;
		private var _textPlayhead:TextField;
		
		public function Scrubber508()
		{	
			try
			{
				var cls:* = getDefinitionByName("scrubber_track") as Class;
				var mc:MovieClip = new cls as MovieClip;
				mc.visible = true;
				mc.x = 43;
				addChild (mc);

				cls = getDefinitionByName("scrubber_buffer") as Class;
				_mcProgress = new cls as MovieClip;
				_mcProgress.visible = true;
				_mcProgress.x = 45;
				_mcProgress.y = 2;
				_progressWidth = _mcProgress.width;
				_mcProgress.scrollRect = new Rectangle (0, 0, 0, _mcProgress.height);
				addChild (_mcProgress);

				cls = getDefinitionByName("scrubber_playhead") as Class;
				_mcPlayhead = new cls as MovieClip;
				_mcPlayhead.visible = true;
				_mcPlayhead.x = 45;
				_mcPlayhead.y = 2;
				_playheadWidth = _mcPlayhead.width;
				_mcPlayhead.scrollRect = new Rectangle (0, 0, 0, _mcPlayhead.height);
				addChild (_mcPlayhead);
				
				_textDuration = new TextField ();
				_textDuration.x = 343;
				_textDuration.y = -3;
				_textDuration.type = TextFieldType.DYNAMIC;
				_textDuration.text = "00:00";
				_textDuration.setTextFormat (new TextFormat ("Arial", 12, 0x000000, true));
				addChild (_textDuration);
				
				_textPlayhead = new TextField ();
				_textPlayhead.type = TextFieldType.DYNAMIC;
				_textPlayhead.y = -3;
				_textPlayhead.text = "00:00";
				_textPlayhead.setTextFormat (new TextFormat ("Arial", 12, 0x000000, true));
				addChild (_textPlayhead);
			}catch(e:Error){
				//trace('couldnt');
			}
		}

		public function mediaLoaded(duration:Number):void
		{
			_duration = duration;

			_textDuration.text = _formatTime (_duration);
			_textDuration.setTextFormat (new TextFormat ("Arial", 12, 0x000000, true));
		}

		public function updatePlayhead(data:Number):void
		{
			if (_duration == 0)
			{
				_mcPlayhead.scrollRect = new Rectangle (0, 0, 0, _mcPlayhead.height);
				return;
			}
			
			_mcPlayhead.scrollRect = new Rectangle (0, 0, _playheadWidth * data / _duration, _mcPlayhead.height);

			_textPlayhead.text = _formatTime (data);
			_textPlayhead.setTextFormat (new TextFormat ("Arial", 12, 0x000000, true));
		}

		public function bufferProgress(data:Number, totalBytes:Number):void
		{
			if (totalBytes == 0)
			{
				_mcProgress.scrollRect = new Rectangle (0, 0, 0, _mcProgress.height);
				return;
			}
			
			_mcProgress.scrollRect = new Rectangle (0, 0, _progressWidth * data / totalBytes, _mcProgress.height);
		}
				
		public function initialize():void
		{
		}
		
		public function setSkin(skinName:String, setSkinSize:Boolean=false):void
		{
			//this.setStyle("cellRenderer", CustomImageCacheCell);
		}
		
		public function setSize(width:Number, height:Number):void
		{
//			this.width = width;
//			this.height = height;
		}
		
		private function _formatTime (time:Number):String
		{
			var itime:int = Math.round(time);
			var mins:int = Math.floor (itime / 60);
			var secs:int = itime % 60;

			var str:String = (mins < 10 ? "0" + mins : mins) + ":" + (secs < 10 ? "0" + secs : secs);
			
			return str;
		}
	}
}