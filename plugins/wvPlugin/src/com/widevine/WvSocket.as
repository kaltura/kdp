/**
 WvSocket
 version 1.1
 03/08/2010
**/

package com.widevine
{
 	import flash.events.*;
	import flash.net.Socket;
	
	public class WvSocket extends Socket
	{
		private var myResponse:String;
		
		public function WvSocket() {
			super();		
  		}
 
 		private function errorHandler(e:IOErrorEvent):void{
   			trace("IOError: " + e.text);
  		}
  
 		private function securityHandler(e:SecurityErrorEvent):void{
   			trace ("SecurityError: " + e.text);
  		}
 
		public function sendRequest (str:String):void {
			//trace("sending:" + str);
			super.writeUTFBytes(str);
			super.flush();
		}
	}  // class
} // package
