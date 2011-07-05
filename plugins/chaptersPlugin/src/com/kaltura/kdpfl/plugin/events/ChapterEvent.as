package com.kaltura.kdpfl.plugin.events
{
	import flash.events.Event;
	
	public class ChapterEvent extends Event
	{
		public static const CHAPTER_CLICKED : String = "chapterClicked";
		
		protected var _chapterId : String;
		
		public function ChapterEvent(type:String,n_chapterId : String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			chapterId = n_chapterId;
		}

		public function get chapterId():String
		{
			return _chapterId;
		}

		public function set chapterId(value:String):void
		{
			_chapterId = value;
		}

	}
}