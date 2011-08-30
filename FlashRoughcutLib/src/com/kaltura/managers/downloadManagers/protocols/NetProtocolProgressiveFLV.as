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
	import com.kaltura.managers.downloadManagers.protocols.interfaces.INetProtocol;
	import com.kaltura.net.downloading.FLVstream;
	import com.kaltura.net.loaders.MediaSourceLoader;
	import com.kaltura.net.loaders.interfaces.IMediaSourceLoader;
	import com.kaltura.utils.url.URLProccessing;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class NetProtocolProgressiveFLV extends EventDispatcher implements INetProtocol
	{
		public var _asset:AbstractAsset;
		private var _roughcutEntryId:String = '-1';
		private var _roughcutEntryVersion:int = -1;

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

		public function NetProtocolProgressiveFLV (roughcut_entry_Id:String, roughcut_entry_version:int):void
		{
			super ();
			_roughcutEntryId = roughcut_entry_Id;
			_roughcutEntryVersion = roughcut_entry_version;
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
			var pId:String = KalturaApplication.getInstance().partnerInfo.partnerId;
			var subpId:String = KalturaApplication.getInstance().partnerInfo.subpId;
			var partnerPart:String = URLProccessing.getPartnerPartForTracking(pId, subpId);
			var url2Load:String = URLProccessing.hashURLforMultipalDomains (URLProccessing.clipperServiceUrl (source_asset.entryId, source_asset.startTime, source_asset.length, '0', partnerPart), source_asset.entryId);
			source_asset.mediaURL = url2Load;
        	var FLVloader:FLVstream = new FLVstream ( source_asset.assetUID, source_asset.mediaURL, "flv",
        				source_asset.mediaType == MediaTypes.VIDEO,
        				_asset.mediaType == MediaTypes.VIDEO ? _asset.kalturaEntry.width : 0,
        				_asset.mediaType == MediaTypes.VIDEO ? _asset.kalturaEntry.height : 0);
        	var stream:IMediaSourceLoader = new MediaSourceLoader (FLVloader.Stream, source_asset.assetUID, source_asset.mediaURL);
			stream.addEventListener(Event.COMPLETE, dispacthFinish );
			return stream;
		}

		private function dispacthFinish (event:Event):void
		{
			dispatchEvent (new Event (Event.COMPLETE));
		}

	}
}