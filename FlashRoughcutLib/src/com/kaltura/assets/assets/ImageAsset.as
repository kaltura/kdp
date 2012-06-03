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
package com.kaltura.assets.assets
{
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.vo.KalturaPlayableEntry;

	final public class ImageAsset extends AbstractAsset
	{
		/**
		 * Constructor.
		 * @param asset_uid					the uid of the asset, a unique identifier.
		 * @param entry_id					the entry id, as defined by the server.
		 * @param entry_name				the entry name.
		 * @param thumb_url					the thumbnail url.
		 * @param media_url					the source url of the media object.
		 * @param asset_length				the duration.
		 * @param maximum_length			the maximum duration.
		 * @param start_time				the time stamp to start at.
		 * @param audio_balance				the pan (balance of the asset's audio).
		 * @param transition_type			the type of transition used in the asset.
		 * @param transition_length			the duration of the transition attached to the client.
		 * @param is_focus					is this asset is currently on application focus?.
		 * @param is_selected				is this asset is currently seleceted?.
		 * @param media_source				the media object the asset holds (NetStream, BitmapData, Sound).
		 *
		 */
		public function ImageAsset( asset_uid:String,
								entry_id:String,
								entry_name:String,
								thumb_url:String,
								media_url:String,
								asset_length:Number,
								maximum_length:Number,
								start_time:Number,
								audio_balance:Number,
								transition_type:String,
								transition_length:Number,
								is_focus:Boolean = false,
								is_selected:Boolean = false,
								media_source:* = null,
								kaltura_entry:KalturaPlayableEntry = null ):void
		{
			super(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance, transition_type,
					transition_length, is_focus, is_selected, media_source, kaltura_entry );
		}
	}
}