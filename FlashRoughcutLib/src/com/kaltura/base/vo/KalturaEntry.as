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
package com.kaltura.base.vo
{
	import com.kaltura.base.types.MediaTypes;

	import flash.events.EventDispatcher;

	//[Bindable]
	public class KalturaEntry extends EventDispatcher
	{
		/**
		 *the id of this entry.
		 */
		public var entryId:String;
		/**
		 *the name of this entry.
		 */
		public var entryName:String;
		/**
		 *the version of this entry.
		 */
		public var entryVersion:String;
		/**
		 *the kshow id of this entry's owner.
		 */
		public var kshowId:String = '-1';
		/**
		 *the user id of this entry's owner.
		 */
		public var kuserId:String = '-1';
		/**
		 *the partner user id.
		 */
		public var puserId:String;
		/**
		 *the partner id of this entry's owner.
		 */
		public var partnerId:uint;
		/**
		 *the sub partner id of this entry's owner.
		 */
		public var subpId:uint;
		/**
		 *tags that were determined by users.
		 */
		public var tags:String;
		/**
		 *  tags that were determined by the application (partner) admin.
		 */
		public var adminTags:String;
		/**
		 * the status of this entry currently on the server.
		 * @see com.kaltura.base.types.EntryStatuses
		 */
		public var status:int;
		/**
		 * the type of this entry (server wise).
		 */
		public var entryType:int;
		/**
		 *the media type of this entry.
		 * @see  com.kaltura.base.types.MediaTypes
		 */
		public var mediaType:uint = MediaTypes.ANY_TYPE;
		/**
		 *the date when the entry was created,
		 */
		public var createdAtDate:Date;
		/**
		 *the date in int, when the entry was created.
		 */
		public var createdAtAsInt:uint;
		/**
		 *the length in seconds of the entry.
		 */
		public var duration:Number = 0;
		/**
		 *the url of this entry's thumbnail.
		 */
		public var thumbnailUrl:String;
		/**
		 *the url this entry can be downloaded from.
		 */
		public var downloadUrl:String;
		/**
		 * the name of this entry contributor.
		 */
		public var displayCredit:String;
		/**
		 *the url of this entry's mediaSource.
		 */
		public var dataUrl:String;
		/**
		 *true if this entry has thumbnail.
		 */
		public var hasThumbnail:Boolean;
		/**
		 *the number of times this entry was played in the player.
		 */
		public var plays:int;
		/**
		 * the number of times this entry was viewed in the player (not played).
		 */
		public var views:int;
		/**
		 * number of comments on this entry.
		 */
		public var numComments:int;
		/**
		 * original location in the web of that entry's original file.
		 */
		public var sourceLink:String;
		/**
		 *the width of the entry.
		 */
		public var width:Number;
		/**
		 *the height of the entry.
		 */
		public var height:Number;


		public function KalturaEntry (entryInfoXML:XML = null):void
		{
			if (entryInfoXML)
			{
				plays = entryInfoXML.plays;
				width = entryInfoXML.width;
				height = entryInfoXML.height;
				views = entryInfoXML.views;
				entryId = entryInfoXML.id;
				entryName = entryInfoXML.name;
				partnerId = int (entryInfoXML.partnerId);
				subpId = int (entryInfoXML.subpId);
				tags = entryInfoXML.tags;
				status = int (entryInfoXML.status);
				entryType = int (entryInfoXML.type);
				mediaType = MediaTypes.translateServerType (uint (entryInfoXML.mediaType));
				kshowId = entryInfoXML.kshowId;
				kuserId = entryInfoXML.kuserId;
				puserId = entryInfoXML.puserId;
				createdAtAsInt = uint (entryInfoXML.createdAtAsInt);
				createdAtDate = new Date (createdAtAsInt);
				duration = Number (entryInfoXML.duration);
				thumbnailUrl = entryInfoXML.thumbnailUrl;
				if (entryInfoXML.desiredVersion && entryInfoXML.desiredVersion != "-1")
					entryVersion = entryInfoXML.desiredVersion;
				else
					entryVersion = entryInfoXML.version;
				displayCredit = entryInfoXML.displayCredit;
				dataUrl = entryInfoXML.dataUrl;
				if (entryInfoXML.downloadUrl)
					downloadUrl = entryInfoXML.downloadUrl;
				adminTags = entryInfoXML.adminTags;
				sourceLink = entryInfoXML.sourceLink;
			}
		}
	}
}