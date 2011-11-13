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
package com.kaltura.base.types
{
	//xxx import mx.resources.ResourceManager;

	/**
	 * This is defined in the kaltura server as all media types avilable:
	*/
	public class MediaTypes
	{
		static public var localeBundleName:String = "kalturacvf";
		static public const ANY_TYPE:uint = 0xffffffff;
		static public const VIDEO:uint = 0x2;
		static public const IMAGE:uint = 0x4;
		static public const TEXT:uint = 0x8;
		static public const HTML:uint = 0x10;
		static public const AUDIO:uint = 0x20;
		static public const ROUGHCUT:uint = 0x40;
		static public const ROUGHCUT_XML:uint = 0x80;
		//from here, assets the server doesn't know of:
		//plugins
		static public const OVERLAY:uint = 0x1000;
		static public const TEXT_OVERLAY:uint = 0x2000;
		static public const TRANSITION:uint = 0x4000;
		static public const EFFECT:uint = 0x8000;
		//extra assets
		static public const SOLID:uint = 0x10000;
		static public const SILENCE:uint = 0x20000;
		static public const VOICE:uint = 0x40000;
		static public const NULL:uint = 0x80000;
		static public const BITMAP_SOCKET:uint = 0x100000;
		static public const SWF:uint = 0x200000;
		static public const DOCUMENT:uint = 0x400000;

		static public const STRING_TYPE_ANY_TYPE:String = "ANY_TYPE";
		static public const STRING_TYPE_VIDEO:String = "VIDEO";
		static public const STRING_TYPE_IMAGE:String = "IMAGE";
		static public const STRING_TYPE_TEXT:String = "TEXT";
		static public const STRING_TYPE_HTML:String = "HTML";
		static public const STRING_TYPE_AUDIO:String = "AUDIO";
		static public const STRING_TYPE_ROUGHCUT:String = "ROUGHCUT";
		static public const STRING_TYPE_ROUGHCUT_XML:String = "ROUGHCUT_XML";
		static public const STRING_TYPE_OVERLAY:String = "OVERLAY";
		static public const STRING_TYPE_TEXT_OVERLAY:String = "TEXT_OVERLAY";
		static public const STRING_TYPE_TRANSITION:String = "TRANSITION";
		static public const STRING_TYPE_EFFECT:String = "EFFECT";
		static public const STRING_TYPE_SOLID:String = "SOLID";
		static public const STRING_TYPE_SILENCE:String = "SILENCE";
		static public const STRING_TYPE_VOICE:String = "VOICE";
		static public const STRING_TYPE_NULL:String = "NULL";
		static public const STRING_TYPE_BITMAP_SOCKET:String = "BITMAP_SOCKET";
		static public const UNKNOWN:String = "UNKNOWN";
		static public const STRING_TYPE_SWF:String = "SWF";
		static public const STRING_TYPE_DOCUMENT:String = "DOCUMENT";

		/**
		 *get the given media type possible timeline types.
		 * ie. MediaTypes.IMAGE can only be added to TimelineTypes.VIDEO, and MediaTypes.VIDEO can be added to
		 * either TimelineTypes.VIDEO or TimelineTypes.AUDIO.
		 * @param media_type	the media type to check.
		 * @return 				the possible hosting timeline types.
		 * @see
		 */
		static public function getMediaTypeTimelineTypes (media_type:uint):uint
		{
			var timeline:uint;
			switch (media_type)
			{
				case IMAGE:
				case SWF:
				case SOLID:
				case TRANSITION:
				case OVERLAY:
				case TEXT_OVERLAY:
				case EFFECT:
				case BITMAP_SOCKET:
					timeline = TimelineTypes.VIDEO;
				break;

				case AUDIO:
				case SILENCE:
				case VOICE:
					timeline = TimelineTypes.AUDIO;
				break;

				case VIDEO:
					timeline = (TimelineTypes.VIDEO | TimelineTypes.AUDIO);
				break;

				default:
					timeline =TimelineTypes.ANY_TIMELINE;
				break;
			}
			return timeline;
		}

		/**
		 *translate server media type to MediaTypes type, our values are organized to be used as bit mask.
		 * @param int_type		the media type given by the server on getAllEntries method.
		 * @param to_server		reverse the method to return server type given a mediaType.
		 * @return 				the local MediaType.
		 */
		static public function translateServerType (int_type:uint, to_server:Boolean = false):uint
		{
			var intType:uint;
			if (!to_server)
			{
				switch (int_type)
				{
					case 1:
						intType = MediaTypes.VIDEO;
						break;

					case 2:
						intType = MediaTypes.IMAGE;
						break;

					case 3:
						intType = MediaTypes.TEXT;
						break;

					case 4:
						intType = MediaTypes.HTML;
						break;

					case 5:
						intType = MediaTypes.AUDIO;
						break;

					case 6:
						intType = MediaTypes.ROUGHCUT;
						break;

					case 7:
						intType = MediaTypes.ROUGHCUT_XML;
						break;

					case 11:
						intType = MediaTypes.DOCUMENT;
						break;

					case 12:
						intType = MediaTypes.SWF;
						break;
				}
			} else {
				switch (int_type)
				{
					case MediaTypes.VIDEO:
						intType = 1;
						break;

					case MediaTypes.IMAGE:
						intType = 2;
						break;

					case MediaTypes.TEXT:
						intType = 3;
						break;

					case MediaTypes.HTML:
						intType = 4;
						break;

					case MediaTypes.AUDIO:
						intType = 5;
						break;

					case MediaTypes.ROUGHCUT:
						intType = 6;
						break;

					case MediaTypes.ROUGHCUT_XML:
						intType = 7;
						break;

					case MediaTypes.SWF:
						intType = 12;
						break;

					case MediaTypes.DOCUMENT:
						intType = 11;
						break;
				}
			}
			return intType;
		}

		/**
		 *translates string type to uint type to be used in the sdk.
		 *<p>SDL uses string types to be maintain readability, so we need to convert it when parsing the sdl to roughcut timelines.</p>
		 * @param strType		the string type as it is defined in the SDL.
		 * @return 				uint type.
		 * @see com.kaltura.common.types.MediaTypes#translateIntTypeToString
		 */
		static public function translateStringTypeToInt (str_type:String):uint
		{
			var intType:uint;
			switch (str_type)
			{
				case MediaTypes.STRING_TYPE_VIDEO:
					intType = MediaTypes.VIDEO;
					break;

				case MediaTypes.STRING_TYPE_AUDIO:
					intType = MediaTypes.AUDIO;
					break;

				case MediaTypes.STRING_TYPE_IMAGE:
					intType = MediaTypes.IMAGE;
					break;

				case MediaTypes.STRING_TYPE_SOLID:
					intType = MediaTypes.SOLID;
					break;

				case MediaTypes.STRING_TYPE_SILENCE:
					intType = MediaTypes.SILENCE;
					break;

				case MediaTypes.STRING_TYPE_VOICE:
					intType = MediaTypes.VOICE;
					break;

				case MediaTypes.STRING_TYPE_TRANSITION:
					intType = MediaTypes.TRANSITION;
					break;

				case MediaTypes.STRING_TYPE_ROUGHCUT:
					intType = MediaTypes.ROUGHCUT;
					break;

				case MediaTypes.STRING_TYPE_OVERLAY:
					intType = MediaTypes.OVERLAY;
					break;

				case MediaTypes.STRING_TYPE_EFFECT:
					intType = MediaTypes.EFFECT;
					break;

				case MediaTypes.STRING_TYPE_TEXT_OVERLAY:
					intType = MediaTypes.TEXT_OVERLAY;
					break;

				case MediaTypes.STRING_TYPE_TEXT:
					intType = MediaTypes.TEXT;
					break;

				case MediaTypes.STRING_TYPE_SWF:
					intType = MediaTypes.SWF;
					break;

				case MediaTypes.STRING_TYPE_DOCUMENT:
					intType = MediaTypes.DOCUMENT;
					break;

				default:
					intType = MediaTypes.ANY_TYPE;
			}
			return intType;
		}

		/**
		 *translates uint type to string type to be used in the SDL.
		 * @param intType		uint type to be converted.
		 * @return 				string type to be used in the sdl.
		 * @see com.kaltura.common.types.MediaTypes#translateStringTypeToInt
		 */
		static public function translateIntTypeToString (int_type:uint):String
		{
			var strType:String;
			switch (int_type)
			{
				case MediaTypes.VIDEO:
					strType = MediaTypes.STRING_TYPE_VIDEO;
					break;

				case MediaTypes.AUDIO:
					strType = MediaTypes.STRING_TYPE_AUDIO;
					break;

				case MediaTypes.IMAGE:
					strType = MediaTypes.STRING_TYPE_IMAGE;
					break;

				case MediaTypes.SOLID:
					strType = MediaTypes.STRING_TYPE_SOLID;
					break;

				case MediaTypes.SILENCE:
					strType = MediaTypes.STRING_TYPE_SILENCE;
					break;

				case MediaTypes.VOICE:
					strType = MediaTypes.STRING_TYPE_VOICE;
					break;

				case MediaTypes.ROUGHCUT:
					strType = MediaTypes.STRING_TYPE_ROUGHCUT;
					break;

				case MediaTypes.OVERLAY:
					strType = MediaTypes.STRING_TYPE_OVERLAY;
					break;

				case MediaTypes.EFFECT:
					strType = MediaTypes.STRING_TYPE_EFFECT;
					break;

				case MediaTypes.TRANSITION:
					strType = MediaTypes.STRING_TYPE_TRANSITION;
					break;

				case MediaTypes.TEXT_OVERLAY:
					strType = MediaTypes.STRING_TYPE_TEXT_OVERLAY;
					break;

				case MediaTypes.TEXT:
					strType = MediaTypes.STRING_TYPE_TEXT;
					break;

				case MediaTypes.SWF:
					strType = MediaTypes.STRING_TYPE_SWF;
					break;

				case MediaTypes.DOCUMENT:
					strType = MediaTypes.STRING_TYPE_DOCUMENT;
					break;

				default:
					strType = MediaTypes.UNKNOWN;
			}
			return strType;
		}

		/**
		 * return the localed name of the media type given.
		 * @param intType		the int value of the media type.
		 * @return 				the localed name.
		 */
		static public function getLocaleMediaType (int_type:uint):String
		{
			var mediaTypeStr:String = MediaTypes.translateIntTypeToString(int_type);
			var localedType:String = mediaTypeStr;//xxx mediaTypeStrResourceManager.getInstance().getString(localeBundleName, mediaTypeStr);
			return localedType == "" || localedType === null ? mediaTypeStr : localedType;
		}
	}
}