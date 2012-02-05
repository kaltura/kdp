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
package com.kaltura.net.downloading
{
	import com.kaltura.base.IDisposable;
	import com.kaltura.net.events.LoaderEvent;
	import com.kaltura.net.streaming.ExNetConnection;
	import com.kaltura.net.streaming.ExNetStream;
	import com.kaltura.net.streaming.NetClient;
	import com.kaltura.net.streaming.status.NetStatus;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.net.NetConnection;

	public class FLVstream extends EventDispatcher implements IDisposable
	{
		private var progressiveFormats:Array = ['flv', 'f4v', 'mp4', 'm4v', 'm4a', 'mov', '3gp', 'f4a', 'f4b', 'mp3' ];
		private static const MeName:String = 'FLVStream';
		private var _Stream:ExNetStream;
		private var _Con:ExNetConnection;
		private var _ConURL:String;
		private var _recieveVideo:Boolean = true;
		public function get recieveVideo ():Boolean { return _recieveVideo};

		private static var _NullNC:NetConnection = new NetConnection ();

		public function get Stream():ExNetStream { return _Stream; }

		// if not passing ForceType than the proccess will decide, if forcetype is passed "flv" than flv will be forced to be used as loading method
		//TODO: use StreamSourceVO instead of this parsing.
		public function FLVstream(asset_uid:String, flvStreamURL:String, ForceType:String = "", recieve_video:Boolean = true, video_width:Number = 640, video_height:Number = 480):void
		{
			if (video_width <= 0)
				 video_width = 640;
			if (video_height <= 0)
				video_height = 480;
			_recieveVideo = recieve_video;
			_ConURL = flvStreamURL;
			// HTTP, HTTPS, RTMP, HTTP + xml (FVSS)
			var protocol:String = _ConURL.toLowerCase().substr(0, 4);
			protocol = protocol == "http" || protocol == "rtmp" || protocol == "rtmps" ? protocol : "-1";
			var reqindex:int = _ConURL.indexOf("?");
			var urlNoParams:String = _ConURL.substring(0, reqindex > 0 ? reqindex : 0x7fffffff);
			var postfix:String = urlNoParams.toLowerCase().substr(urlNoParams.length - 3, 3);
			// HTTP - Progressive download :
			if (ForceType || (protocol == "http" || protocol == "-1") || checkProgressiveType(postfix))
			{
				_NullNC.connect (null);
				_Stream = new ExNetStream(_NullNC, _ConURL, asset_uid, true, recieveVideo, 0, -1, true, false, video_width, video_height);
				_Stream.addEventListener("Stream.Load.Success", StreamStatus, false, 0, true);
				// If it's PD than set pre-buffer to a large number (3 is good usually)
				registerListeners (_Stream);
			} else {
				// RTMP - Direct streaming server :
				_Con = new ExNetConnection();
				var ConStr:String = _ConURL.substr(0, _ConURL.lastIndexOf("/"));
				_Con.client = new NetClient(ConStr);
				_Con.connect(ConStr);
				_Con.addEventListener(NetStatusEvent.NET_STATUS, OnConStatus, false, 0, true);
			}
		}

		private function registerListeners(broadcaster:IEventDispatcher):void
        {
			Object(broadcaster).addEventListener( ProgressEvent.PROGRESS, progressHandler, false, 0, true );
			Object(broadcaster).addEventListener( LoaderEvent.OBJECTLOADED, LoadCompleteHandler, false, 0, true );
    		Object(broadcaster).addEventListener( IOErrorEvent.IO_ERROR, errorHandler, false, 0, true );
        }

		private function OnConStatus(netEvent:NetStatusEvent):void
		{
			if (netEvent.info.code == NetStatus.NETCONNECTION_CONNECT_SUCCESS)
			{
				_Stream = new ExNetStream(_Con, "SingleViewVideo", "SingleViewVideo", true, recieveVideo, 0, -1, false, false);
				var StreamStr:String = _ConURL.substr(_ConURL.lastIndexOf("/") + 1, _ConURL.length);
				_Stream.client = new NetClient(StreamStr);
				_Stream.play(StreamStr);
				_Stream.addEventListener("Stream.Load.Success", StreamStatus, false, 0, true );
				registerListeners (_Stream);
			}
		}

		private function StreamStatus(event:Event):void
		{
			dispatchEvent(new Event("SingleStream.Load.Success"));
		}

		public function CloseStream ():void
		{
			if (_Stream != null)
				_Stream.close();
		}

		private function LoadCompleteHandler (e:LoaderEvent):void
        {
        	dispatchEvent(new LoaderEvent(LoaderEvent.OBJECTLOADED, _ConURL));
        }

        private function progressHandler ( e:ProgressEvent ):void
        {
        	dispatchEvent (new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal));
        }

        private function errorHandler ( e:IOErrorEvent ):void
        {
            dispatchEvent( e );
        }

        private function checkProgressiveType (file_type:String):Boolean
        {
        	var N:int = progressiveFormats.length;
        	for (var i:int = 0; i < N; ++i)
        	{
        		if (progressiveFormats[i] == file_type)
        			return true;
        	}
        	return false;
        }

        public function dispose ():void
        {
        	if (_Stream != null) _Stream.dispose();
        	_Stream = null;
			_Con = null;
        }
	}
}