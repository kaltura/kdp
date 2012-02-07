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
	import com.kaltura.net.streaming.ExNetStream;
	import com.kaltura.net.streaming.ExNetConnection;
	import com.kaltura.net.streaming.PlayStatusStates;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class NETConnectionVitalStream extends EventDispatcher implements IDisposable
	{
		private var _isConnected:Boolean = false;
		private var _NStream:ExNetStream;
		private var _NConnection:ExNetConnection;
		private var PlaylistXML:XML = new XML();
		private var XML_URL:String;
		private var myXMLURL:URLRequest;
		private var myLoader:URLLoader;
		private var FVSSLoader:VitalStreamXMLloader;
		//Future use (types of protocols) :
		private var m_connList:Array = [{protocol:"rtmp", port:1935}, {protocol:"rtmp", port:443}, {protocol:"rtmpt", port:80}];
		private var isPlaying:uint = PlayStatusStates.STOP;
		//Time Control :
		private var _PlayLength:Number			 = 0;
		private var _PlayStart:Number			 = 0;
		//Connection details :
		private var _ServerURL:String;
		private var _StreamName:String;
		private var _AppName:String;
		private var _volume:Number = 1;
		private var _pan:Number = 0;
		private var _isMP3:Boolean = false;
		//Debug Control :
		private var mDebugging:Boolean = false;
		// Does the stream needs to be checked for existance?
		private var _CheckExistance:Boolean = true;

		NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;

		// Getters
		public function get NStream ():ExNetStream
		{
			return _NStream;
		}

		public function get NConnection ():ExNetConnection
		{
			return _NConnection;
		}

		public function get isConnected ():Boolean
		{
			return _isConnected;
		}

		public function get PlayLength ():Number
		{
			return _PlayLength;
		}

		public function get PlayStart ():Number
		{
			return _PlayStart;
		}

		public function get StreamName ():String
		{
			return _StreamName;
		}

		public function get ServerName ():String
		{
			return _ServerURL;
		}

		public function get AppName ():String
		{
			return _AppName;
		}
		//------------------------------------------------------------------------------------

		/**
		 * Constructor, allows instantioation with loading.
		 * @param xmlURI	URL for the VitalStream XML file on the CDN origin delivery server
		 * @param start		start position in seconds time
		 * @param end		end position in seconds time
		 * @param vol		volime - between 0 - 1
		 * @param pan		paning - between -1 - 0 - 1 (left, center, right)
		 * @param isMP3		determins if the stream is MP3 file (audio) or flv (audio + video)
		 *
		 */
		public function NETConnectionVitalStream(xmlURI:String = "", start:Number = 0, end:Number = 0, vol:Number = 1, pan:Number = 0, isMP3:Boolean = false, CheckExistance:Boolean = true):void
		{
			_CheckExistance = CheckExistance;
			if (xmlURI != "")
			{
				LoadStream(xmlURI, start, end, vol, pan, isMP3);
			}
		}

		/**
		 * Will close the connection
		 *
		 */
		public function CloseConnection():void
		{
			if (_isConnected == true)
			{
				if (mDebugging == true) trace("removing listeners to connection...");
				_NConnection.removeEventListener(NetStatusEvent.NET_STATUS, ConOnStatus);
				if (mDebugging == true) trace("Closing connection...");
				_NStream.close();
				_NConnection.close();
				_isConnected = false;
				isPlaying = PlayStatusStates.STOP;
				//dispatchEvent (new Event(PlayStatusStates.END_OF_SEGMENT));
				if (mDebugging == true) trace("Connection Closed!");
			}
		}

		/**
		 * Load the stream, first load the xml from the CDN, then connect to the server, then connect to the stream
		 * @param xmlURI	URL for the VitalStream XML file on the CDN origin delivery server
		 * @param start		start position in seconds time
		 * @param end		end position in seconds time
		 * @param vol		volime - between 0 - 1
		 * @param pan		paning - between -1 - 0 - 1 (left, center, right)
		 * @param isMP3		determins if the stream is MP3 file (audio) or flv (audio + video)
		 *
		 */
		public function LoadStream(xmlURI:String, start:Number = 0, end:Number = 0, vol:Number = 1, pan:Number = 0, isMP3:Boolean = false):void
		{
			_isMP3 = isMP3;
			_volume = vol;
			_pan = pan;
			_PlayLength = end;
			_PlayStart = start;
			CloseConnection();
			FVSSLoader = new VitalStreamXMLloader(xmlURI, start, end);
			FVSSLoader.addEventListener("FVSS_XML_LOADED", FVSSxmlLoaded, false, 0, true);
		}

		/**
		 * XML from CDN was loaded, now connect to the FVSS server
		 * @param event
		 *
		 */
		private function FVSSxmlLoaded (event:Event):void
		{
			if (mDebugging == true) trace("FVSS XML LOADED --------------");
			var stName:String = event.currentTarget.StreamName;
			var serName:String = event.currentTarget.ServerURL;
			var app:String = event.currentTarget.appName;
			var starting:Number = event.currentTarget.StartTime;
			var ending:Number = event.currentTarget.EndTime;
			Connect2FVSS(serName, app, stName, 0, starting, ending);
		}

		/**
		 * this will initiate the connection;
		 *  the proper connection scheme for a player is .connect(appURI, false, streamName)
		 * for a publisher it should be .connect(appURI, false, streamName, "publisher")
		 * Conection String is:
		 * m_connList[protocolID].protocol + "://" + m_serverName + ":" + m_connList[m_connListCounter].port + "/" + m_appName, m_autoSenseBW = false, m_streamName
		 * @param serverURL		the media server URL
		 * @param appName		the application name
		 * @param StreamN		the stream name
		 * @param protocolID	the protocol to use [0=rtmp, 1=rtmp(Over SSL), 2=rtmpt(Tunneling)]
		 *
		 */
		private function Connect2FVSS(serverURL:String, appName:String, StreamN:String, protocolID:int, startT:Number, endT:Number):void
		{
			_ServerURL = serverURL;
			_AppName = appName;
			_StreamName = StreamN;
			if (_isConnected == false){
				var ConURI:String = m_connList[protocolID].protocol + "://" + serverURL + ":" + m_connList[protocolID].port + "/" + appName;
				var StreamInfoObject:Object = {stream:StreamN, sTime:startT, eTime:endT};
				_NConnection = new ExNetConnection(ConURI, StreamInfoObject);
				_NConnection.addEventListener (NetStatusEvent.NET_STATUS, ConOnStatus, false, 0, true);
			}
		}

		/**
		 * Status event for the connection, on connection success, load the stream requested.
		 * @param netEvent
		 *
		 */
		private function ConOnStatus(netEvent:NetStatusEvent):void
		{
			dispatchEvent(netEvent);
			var StreamInfoObject:Object = netEvent.currentTarget.connectionInfo;
			if (netEvent.info.code == "NetConnection.Connect.Success")
			{
				_NStream = new ExNetStream(_NConnection, StreamInfoObject.stream, StreamInfoObject.stream, true, true, 0, -1, _CheckExistance);
				var SNO:String = String(StreamInfoObject.stream)
				if (_isMP3 == true) SNO = "mp3:" + SNO.substring(0, SNO.indexOf(".mp3"));
				trace("(NetConVS) Stream Info:   " + [SNO, StreamInfoObject.sTime, StreamInfoObject.eTime]);
				_NStream.play(SNO, StreamInfoObject.sTime);
				_NStream.addEventListener("Stream.Load.Success", FinishedLoadingStream, false, 0, true);
				_NStream.soundTransform = new SoundTransform(_volume, _pan);
				_isConnected = true;
			}
		}

		/**
		 * Uppon loading success of the requested stream, dispatch event and notify to the manager.
		 * @param event
		 *
		 */
		private function FinishedLoadingStream(event:Event):void
		{
			dispatchEvent(new Event("Stream.Load.Success"));
		}

		public function dispose ():void
		{
			_NStream.dispose();
			_NConnection = null;
			PlaylistXML = null;
			myXMLURL = null;
			myLoader = null;
			if (FVSSLoader != null) FVSSLoader.dispose();
			FVSSLoader = null;
			m_connList = [];
		}
	}
}