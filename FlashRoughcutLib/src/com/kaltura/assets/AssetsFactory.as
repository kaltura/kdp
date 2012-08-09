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
package com.kaltura.assets
{
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.assets.assets.AudioAsset;
	import com.kaltura.assets.assets.ImageAsset;
	import com.kaltura.assets.assets.PluginAsset;
	import com.kaltura.assets.assets.SWFAsset;
	import com.kaltura.assets.assets.SilenceAsset;
	import com.kaltura.assets.assets.SolidAsset;
	import com.kaltura.assets.assets.VideoAsset;
	import com.kaltura.assets.assets.VoiceAsset;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.vo.KalturaPlayableEntry;

	public class AssetsFactory
	{
		/**
		 * Factory create instance function, will create a new Asset instance of the type requested.
		 * @param asset_type				the type of the new created asset.
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
		public static function create (
								asset_type:int,
								asset_uid:String,
								entry_id:String,
								entry_name:String,
								thumb_url:String,
								media_url:String,
								asset_length:Number,
								maximum_length:Number,
								start_time:Number = 0,
								audio_balance:Number = 0,
								transition_type:String = "None",
								transition_length:Number = 0,
								is_focus:Boolean = false,
								is_selected:Boolean = false,
								media_source:* = null,
								kaltura_entry:KalturaPlayableEntry = null ):AbstractAsset
		{
			var asset:AbstractAsset;
			switch (asset_type)
			{
				case MediaTypes.VIDEO:
					asset = new VideoAsset(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance,
								transition_type, transition_length, is_focus, is_selected, media_source, kaltura_entry);
					break;

				case MediaTypes.AUDIO:
					asset = new AudioAsset(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance,
								transition_type, transition_length, is_focus, is_selected, media_source, kaltura_entry);
					break;

				case MediaTypes.IMAGE:
					asset = new ImageAsset(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance,
								transition_type, transition_length, is_focus, is_selected, media_source, kaltura_entry);
					asset.maxLength = Number.MAX_VALUE;
					break;

				case MediaTypes.SWF:
					asset = new SWFAsset(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance,
								transition_type, transition_length, is_focus, is_selected, media_source, kaltura_entry);
					asset.maxLength = Number.MAX_VALUE;
					break;

				case MediaTypes.TRANSITION:
				case MediaTypes.OVERLAY:
				case MediaTypes.EFFECT:
					asset = new PluginAsset(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance,
								transition_type, transition_length, is_focus, is_selected, media_source, kaltura_entry);
					asset.maxLength = Number.MAX_VALUE;
					break;

				case MediaTypes.SOLID:
					asset = new SolidAsset(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance,
								transition_type, transition_length, is_focus, is_selected, media_source, kaltura_entry);
					asset.maxLength = Number.MAX_VALUE;
					break;

				case MediaTypes.VOICE:
					asset = new VoiceAsset(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance,
								transition_type, transition_length, is_focus, is_selected, media_source, kaltura_entry);
					break;

				case MediaTypes.SILENCE:
					asset = new SilenceAsset(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance,
								transition_type, transition_length, is_focus, is_selected, media_source, kaltura_entry);
					asset.maxLength = Number.MAX_VALUE;
					break;

				case MediaTypes.NULL:
					asset = new SilenceAsset(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance,
								transition_type, transition_length, is_focus, is_selected, media_source, kaltura_entry);
					asset.entryId = '-1000';
					asset.maxLength = Number.MAX_VALUE;
					break;

				default:
					trace ("Requested type (" + asset_type + ") not found on AssetFactory class");
					asset = new SilenceAsset(asset_uid, entry_id, entry_name, thumb_url, media_url, asset_length, maximum_length, start_time, audio_balance,
								transition_type, transition_length, is_focus, is_selected, media_source, kaltura_entry);
					asset.entryId = '-1000';
					asset.maxLength = Number.MAX_VALUE;
					break;
			}
			asset.mediaType = asset_type;
			var transitionAsset:AbstractAsset = new PluginAsset(asset_uid, entry_id, entry_name + ".AssetTransition",
					AbstractAsset.noneTransitionThumbnail, "", transition_length, transition_length, 0, 0, transition_type, transition_length);
			transitionAsset.mediaType = MediaTypes.TRANSITION;
			asset.transitionAsset = transitionAsset;
			return asset;
		}
	}
}