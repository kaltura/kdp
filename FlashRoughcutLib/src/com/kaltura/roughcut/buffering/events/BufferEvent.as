package com.kaltura.roughcut.buffering.events
{
	import flash.events.Event;

	public class BufferEvent extends Event
	{
		static public const DOWNLOAD_COMPLETE:String = "downloadComplete";
		static public const UPDATE_BUFFER_TIME:String = "updateBufferTime";
		static public const PLUGINS_DOWNLOAD_COMPLETE:String = "pluginsDownloadComplete";

		public function BufferEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new BufferEvent (type, bubbles, cancelable);
		}
	}
}