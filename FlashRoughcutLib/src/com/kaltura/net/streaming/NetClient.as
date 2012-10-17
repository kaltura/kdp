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
package com.kaltura.net.streaming
{
	import com.kaltura.net.streaming.events.NetClientEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.events.MetadataEvent;
	import mx.utils.ObjectUtil;

	/**
	 *  Dispatched when the Netstream client gets BufferSizes object on the metadata.
	 *  @eventType com.kaltura.net.streaming.events.NetClientEvent.ON_METADATA_BUFFER_SIZES
	 */
	[Event(name="onMetadataBufferSizes", type="com.kaltura.net.streaming.events.NetClientEvent")]

	/**
	 *  Dispatched when the Netstream client gets to the end of the stream.
	 *  @eventType com.kaltura.net.streaming.events.NetClientEvent.ON_STREAM_END
	 */
	[Event(name="onStreamEnd", type="com.kaltura.net.streaming.events.NetClientEvent")]

	/**
	 *  Dispatched when the Netstream client gets event that the stream has been switched on the server sequence (playlist mode).
	 *  @eventType com.kaltura.net.streaming.events.NetClientEvent.ON_STREAM_SWITCH
	 */
	[Event(name="onStreamSwitch", type="com.kaltura.net.streaming.events.NetClientEvent")]

	/**
	 *  Dispatched when the Netstream client gets to the last second before the stream ends.
	 *  @eventType com.kaltura.net.streaming.events.NetClientEvent.ON_LAST_SECOND
	 */
	[Event(name="onLastSecond", type="com.kaltura.net.streaming.events.NetClientEvent")]

	/**
	 *  Dispatched after the Netstream client gets the metadata and parse it to a StreamMetaData object.
	 *  @eventType mx.events.MetadataEvent.METADATA_RECEIVED
	 * @see com.kaltura.net.streaming.StreamMetaData
	 */
	[Event(name="metadataReceived", type="mx.events.MetadataEvent")]

	public class NetClient extends EventDispatcher
	{
		private var _clientID:String = "";
		public var metaData:StreamMetaData = new StreamMetaData ();

		public function get clientId():String
		{
			return _clientID;
		}

		public function set clientId(value:String):void{
			_clientID = value;
		}

		public function NetClient(client_id:String):void{
			_clientID = client_id;
		}

	    public function onMetaData(info:Object, ...args):void
	    {
	    	if (metaData.dispatchedMetaData)
	    		return;
	    	if (!metaData.hasEventListener(MetadataEvent.METADATA_RECEIVED))
	    		metaData.addEventListener(MetadataEvent.METADATA_RECEIVED, metadataReady, false, 0, true);
			metaData.onMetaDataObject = info;
	    }

	    private function metadataReady (event:MetadataEvent):void
	    {
	    	dispatchEvent(event.clone());
	    }

	    public function onXMPData (xmpData:Object):void
	    {
			///////////////////////////////////////////////////////////////
			//Doesn't compile with flash player 10.2, remove it for now
			////////////////////////////////////////////////////////////
/*	    	if (xmpData is XML)
	    	{
	    		metaData.xmp = xmpData as XML;
	    		trace ("we go XMP data as xml.");
	    	} else {
	    		trace ("we go XMP data, but it's not xml.");
	    	}*/
	    }

	    public function onLastSecond(info:Object):void
	    {
	    	trace("Client dispatches onLastSecond.");
	    	dispatchEvent(new NetClientEvent (NetClientEvent.ON_LAST_SECOND));
	    }

	    public function onCuePoint(info:Object):void
	    {
	        trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
	    }

	    public function onPlayStatus(info:Object):void
	    {
	    	if (info.code == "NetStream.Play.Complete")
	    	{
	    		trace("Play of the stream has completed.");
	    		dispatchEvent(new NetClientEvent (NetClientEvent.ON_STREAM_END));
	    	} else if (info.code == "NetStream.Play.Switch")
	    	{
	    		trace("switched streams!");
	    		dispatchEvent(new NetClientEvent (NetClientEvent.ON_STREAM_SWITCH));
	    	} else {
	    		trace (info.code);
	    	}
	    }

	    public function onBWCheck(...rest):Number
	    {
			return 0;
		}

	    public function onBWDone(...rest):void
	    {
			var p_bw:Number;
	        if (rest.length > 0) p_bw = rest[0];
            // your application should do something here when the bandwidth check is complete
            trace("bandwidth = " + p_bw + " Kbps.");
			dispatchEvent(new NetClientEvent (NetClientEvent.ON_BANDWIDTH_CHECK_COMPLETE, p_bw));
		}

		public function streamInfo(info:Object):void
		{
			trace("This is Stream info:  " + info);
		}

		public function close():void
		{
			trace("Closing Client: " + _clientID);
		}
	}
}