/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.net.streaming.cdn.vitalstream
{
	import com.kaltura.base.IDisposable;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class VitalStreamXMLloader extends EventDispatcher implements IDisposable
	{
		private var _XML_URL:String;
		private var _XMLURLreq:URLRequest;
		private var _XMLLoader:URLLoader;
		private var _appName:String;
		private var _ServerURL:String;
		private var _StreamName:String;
		private var PlaylistXML:XML;
		public var StartTime:Number;
		public var EndTime:Number;
		public var mDebugging:Boolean = false;

		public function VitalStreamXMLloader(XMLURI:String, start:Number = 0, end:Number = 0):void
		{
			EndTime = end;
			StartTime = start;
			_XML_URL = XMLURI;
			_XMLURLreq = new URLRequest(_XML_URL);
			_XMLLoader = new URLLoader(_XMLURLreq);
			_XMLLoader.addEventListener("complete", FVSSxmlLoaded, false, 0, true);
		}

		private function FVSSxmlLoaded(event:Event):void
		{
			var appURL:String;
			var serverName:String;
			var appName:String;
			var streamName:String;
			PlaylistXML = XML(event.currentTarget.data);
	        //trace("Data loaded:" + PlaylistXML);
	        streamName = PlaylistXML.streamName[0];
	        appURL = PlaylistXML.appURL[0];
	        appURL = appURL.substr (7, appURL.length);
	        var appURLArray:Array = appURL.split ('/');
	        serverName = appURLArray[0];
	        //this will rebuild the application name from the array
	        appName = appURLArray[1] + '/';
			for (var iAN:int = 2; iAN < appURLArray.length; ++iAN) {
				appName += appURLArray[iAN] + '/';
			}
			if (mDebugging == true) {
				trace("Server:  " + serverName);
		        trace("Application:  " + appName);
		        trace("Stream:  " + streamName);
			}
	        _appName = appName;
	        _ServerURL = serverName;
	        _StreamName = streamName;
	        dispatchEvent(new Event("FVSS_XML_LOADED"));
		}

		//Getters -
		public function get StreamName ():String
		{
			return _StreamName;
		}

		public function get ServerURL ():String
		{
			return _ServerURL;
		}

		public function get appName ():String
		{
			return _appName;
		}

		public function dispose ():void
		{
			_XMLURLreq = null;
			_XMLLoader = null;
			PlaylistXML = null;
		}
	}
}