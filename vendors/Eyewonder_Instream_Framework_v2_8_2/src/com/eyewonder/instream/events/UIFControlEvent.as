/*
UIFControlEvent.as

Universal Instream Framework
Copyright (c) 2006-2009, Eyewonder, Inc
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
 * Neither the name of Eyewonder, Inc nor the
 names of contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Eyewonder, Inc ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Eyewonder, Inc BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This file should be accompanied with supporting documentation and source code.
If you believe you are missing files or information, please
contact Eyewonder, Inc (http://www.eyewonder.com)



Description
-----------


*/
package com.eyewonder.instream.events {
	import flash.events.Event;

	public class UIFControlEvent extends UIFEvent {
		// Player Status Events
		public static const ON_AD_LOAD_COMPLETE:String 				= "sOnAdLoadComplete";
		public static const ON_START_PLAY_AD:String 				= "sOnStartPlayAd";
		public static const ON_START_REQUEST_AD:String 				= "sOnStartRequestAd";
		public static const ON_START_LINEAR:String 					= "sOnStartLinear";
		public static const ON_START_LINEAR_INTERACTIVE:String 		= "sOnStartLinearInteractive";
		public static const ON_START_OVERLAY:String 				= "sOnStartOverlay";
		public static const ON_END_AD:String 						= "sOnEndAd";
		public static const ON_REMINDER_OVERRIDE:String 			= "sOnReminderOverride";
		public static const ON_REMINDER_DETECTED:String 			= "sOnReminderDetected";
		public static const ON_RESIZE_NOTIFY:String 				= "sOnResizeNotify";

		// Ad Interaction Events
		public static const AD_VID_PLAY:String 						= "adVidPlay";
		public static const AD_VID_PAUSE:String 					= "adVidPause";
		public static const AD_VID_SEEK:String 						= "adVidSeek";
		public static const AD_REMAINING_TIME:String				= "remainingTime";
		public static const AD_INFORMATION_DATA:String 				= "adInformationData";
		public static const AD_VOLUME_CHANGED:String				= "audioVolumeChanged";

		// State handlers
		public static const CONTENT_VID_PLAY:String					= "contentVidPlay";
		public static const CONTENT_VID_PAUSE:String				= "contentVidPause";
		public static const CONTENT_VID_STOP:String					= "contentVidStop";

		// MISC
		public static const HIDE_CONTROLS:String					= "hideControls";
		public static const SHOW_CONTROLS:String					= "showControls";

		// Legacy Events
		public static const ON_START_FIXEDROLL:String 				= "sOnStartFixedroll";
		public static const RESIZE_NOTIFY:String 					= "resizeNotify";

		public function UIFControlEvent(type:String, info:Object) {
			super(type, info);
		}
	}

}