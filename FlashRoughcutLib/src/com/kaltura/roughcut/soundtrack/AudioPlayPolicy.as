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
package com.kaltura.roughcut.soundtrack
{
	public class AudioPlayPolicy
	{
		// Audio Assets behaviour
		/**
		* describe a soundtrack that only it's first asset is used and it will be repeated for the whole duration of the video timeline.
		* "playFirstRepeat"
		*/
		static public const AUDIO_PLAY_POLICY_REPEAT:uint = 0x2;
		/**
		* describe a soundtrack that only it's first asset is used and it will be played only once.
		* "playFirstOnce"
		*/
		static public const AUDIO_PLAY_POLICY_ONCE:uint = 0x4;
		/**
		* describe a soundtrack as a noraml audio timeline.
		* "playAllAssets"
		*/
		static public const AUDIO_PLAY_POLICY_ALL:uint = 0x8;

		//Audio Volume behaviour
		/**
		* describe a soundtrack that will play silently when crossing with video assets.
		*/
		static public const CROSS_VIDEO_SILENT:uint = 0x1000;
		/**
		* describe a soundtrack that will mute when crossing with video assets.
		*/
		static public const CROSS_VIDEO_MUTE:uint = 0x2000;
		/**
		* will not take any action when crossing with video (soundtrack will play normally).
		*/
		static public const CROSS_VIDEO_NO_ACTION:uint = 0x4000;
		/**
		 * describe a soundtrack that will mute the video and play only the soundtrack when crossing video assets.
		 */
		static public const CROSS_SOUNDTRACK_ONLY:uint = 0x8000;

		//volumes
		/**
		 *the default volume for the soundtrack to play when it's policy set to silent.
		 */
		static public const DEFAULT_SOUNDTRACK_SILENT_VOLUME:Number = 0.4;
	}
}