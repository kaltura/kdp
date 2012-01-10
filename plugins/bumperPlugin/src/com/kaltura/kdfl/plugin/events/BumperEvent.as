package com.kaltura.kdfl.plugin.events {
	import flash.events.Event;

	public class BumperEvent extends Event {

		private var _url:String;


		public function BumperEvent(type:String, url:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_url = url;
		}


		public function get url():String {
			return _url;
		}


		public function set url(value:String):void {
			_url = value;
		}

	}
}