package com.kaltura.kdpfl.view.controls
{
	import flash.external.ExternalInterface;

	/**
	 * KTrace class enables to send the traces to javaScript. 
	 * @author Michal
	 * 
	 */	
	public class KTrace
	{
		private var _jsCallback:Boolean;
		
		private static var _instance:KTrace;
		
		
		public static function getInstance() : KTrace
		{
			if (_instance == null) _instance = new KTrace();
			return _instance as KTrace;
		}
		
		/**
		 * if true- traces will be added to the page 
		 * @param value
		 * 
		 */		
		public function set jsCallback(value:Boolean):void
		{
			if (!_jsCallback && value) {
				ExternalInterface.call("function() {var ta = document.createElement('textarea'); ta.setAttribute('id', 'kLog'); ta.setAttribute('style', 'width: 500px; height: 400px; position: absolute; top: 0; right: 1px;'); document.getElementsByTagName('body')[0].appendChild( ta );}");
			}
			_jsCallback = value;
		}
		
		public function get jsCallback():Boolean {
			return _jsCallback;
		}
		
		public function log(... args):void {
			trace(args);
			if (jsCallback) {
				args.push("\n");
				ExternalInterface.call("function( msg ) { document.getElementById('kLog').innerHTML += msg; }", args.join(' '));
			}
		}
	}
}