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
package com.kaltura.managers.downloadManagers.protocols
{
	import com.kaltura.application.KalturaApplication;
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.dataStructures.HashMap;
	import com.kaltura.managers.downloadManagers.protocols.interfaces.INetProtocol;
	import com.kaltura.net.downloading.FLVstream;
	import com.kaltura.net.loaders.MediaSourceLoader;
	import com.kaltura.net.loaders.interfaces.IMediaSourceLoader;
	import com.kaltura.roughcut.Roughcut;
	import com.kaltura.utils.url.URLProccessing;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class NetProtocolProgressiveDUAL extends EventDispatcher implements INetProtocol
	{
		public var _asset:AbstractAsset;
		private var _roughcutEntryId:String = '-1';
		private var _roughcutEntryVersion:int = -1;
		private var _roughcut:Roughcut;
		private var _assetIndex:uint;
		static private var roughcutsStreamPairs:HashMap = new HashMap ();
		private var videoStreams:Array = [];
		private var audioStreams:Array = [];

		static public function disposeStreamPair (roughcut_entry_Id:String, roughcut_entry_version:int):void
		{
			var streamPairs:HashMap = NetProtocolProgressiveDUAL.roughcutsStreamPairs;
			if (streamPairs && streamPairs.containsKey(roughcut_entry_Id + "." + roughcut_entry_version.toString()))
				streamPairs.remove(roughcut_entry_Id + "." + roughcut_entry_version.toString());
		}

		public function get roughcutEntryId ():String
		{
			return _roughcutEntryId;
		}
		public function get roughcutEntryVersion ():int
		{
			return _roughcutEntryVersion;
		}
		public function get asset ():AbstractAsset
		{
			return _asset;
		}

		public function NetProtocolProgressiveDUAL (roughcut_entry_Id:String, roughcut_entry_version:int, assetIndex:int):void
		{
			super ();
			_roughcut = KalturaApplication.getInstance().getRoughcut(roughcut_entry_Id, roughcut_entry_version);
			if (_roughcut)
				_roughcutEntryVersion = _roughcut.version;
			else
				_roughcutEntryVersion = roughcut_entry_version;
			_roughcutEntryId = roughcut_entry_Id;
			var streams:Array = [];
			var streamPairs:HashMap = NetProtocolProgressiveDUAL.roughcutsStreamPairs;
			if (streamPairs.containsKey(_roughcutEntryId + "." + _roughcutEntryVersion))
				streams = streamPairs.getValue(_roughcutEntryId + "." + _roughcutEntryVersion);
			if (streams.length > 0)
			{
				videoStreams = streams[0];
				audioStreams = streams[1];
			} else {
				streams[0] = videoStreams;
				streams[1] = audioStreams;
				roughcutsStreamPairs.put (_roughcutEntryId + "." + _roughcutEntryVersion, streams);
			}
			_assetIndex = assetIndex;
		}

		/**
		 *loads a netStream with a progressive download flv.
		 * @param k		the asset to load.
		 * @return 		the ILoadStream of the loaded netStream.
		 * @see			com.kaltura.net.streaming.ExNetStream
		 */
		public function load (source_asset:AbstractAsset):IMediaSourceLoader
		{
			_asset = source_asset;
			var entryToLoad:String = "e" + _roughcutEntryId;
			var streamPart:int = (_assetIndex % 2) + 1;
			var domainHash:String = (_assetIndex % 2).toString();
			var typeToLoad:String;
			var stream:IMediaSourceLoader;
			switch (source_asset.mediaType)
			{
				case MediaTypes.AUDIO:
					typeToLoad = "-audio-";
					if (audioStreams[(_assetIndex % 2)] != null)
						stream = audioStreams[(_assetIndex % 2)];
					domainHash += 2;
					break;
				case MediaTypes.VIDEO:
					typeToLoad = "-video-";
					if (videoStreams[(_assetIndex % 2)] != null)
						stream = videoStreams[(_assetIndex % 2)];
					break;
			}

			if (!stream)
			{
				var pId:String = KalturaApplication.getInstance().partnerInfo.partnerId;
				var subpId:String = KalturaApplication.getInstance().partnerInfo.subpId;
				var partnerPart:String = URLProccessing.getPartnerPartForTracking(pId, subpId);
				var streamerUrl:String = URLProccessing.streamerServiceUrl (entryToLoad, typeToLoad, streamPart.toString(), _roughcutEntryVersion.toString(), partnerPart);
				var url2Load:String = URLProccessing.hashURLforMultipalDomains (streamerUrl, domainHash);
				source_asset.mediaURL = url2Load;
				var FLVloader:FLVstream = new FLVstream (url2Load, url2Load, "flv", source_asset.mediaType == MediaTypes.VIDEO );
				stream = new MediaSourceLoader (FLVloader.Stream, url2Load, source_asset.mediaURL);
				switch (source_asset.mediaType)
				{
					case MediaTypes.AUDIO:
						audioStreams[(_assetIndex % 2)] = stream;
						break;
					case MediaTypes.VIDEO:
						videoStreams[(_assetIndex % 2)] = stream;
						break;
				}
				trace ("load dual: " + url2Load);
			}

			_asset.mediaURL = stream.url;
			stream.addEventListener(Event.COMPLETE, dispacthFinish );
			return stream;
		}

		private function dispacthFinish (event:Event):void
		{
			dispatchEvent (new Event (Event.COMPLETE));
		}

	}
}