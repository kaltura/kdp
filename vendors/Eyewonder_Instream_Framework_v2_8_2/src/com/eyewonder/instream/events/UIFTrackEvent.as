/*
UIFTrackEvent.as

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
	
	public class UIFTrackEvent extends UIFEvent {
		// Player Tracking Events
		public static const TRACK_LOAD:String 						= "trackLoad";
		public static const TRACK_EXPAND:String 					= "trackExpand";
		public static const TRACK_CONTRACT:String 					= "trackContract";
		public static const TRACK_CLOSE:String 						= "trackClose";
		public static const TRACK_INTERACTION:String 				= "trackInteraction";
		public static const TRACK_CLICKTHRU:String 					= "trackClickthru";
		public static const TRACK_START_OF_VIDEO:String 			= "trackStartOfVideo";
		public static const TRACK_FIRST_QUARTILE_OF_VIDEO:String 	= "trackFirstQuartileOfVideo";
		public static const TRACK_MID_OF_VIDEO:String 				= "trackMidOfVideo";
		public static const TRACK_THIRD_QUARTILE_OF_VIDEO:String 	= "trackThirdQuartileOfVideo";
		public static const TRACK_END_OF_VIDEO:String 				= "trackEndOfVideo";
		public static const TRACK_GO_INTERACTIVE:String				= "trackGoInteractive";
		public static const TRACK_LEAVE_INTERACTIVE:String			= "trackLeaveInteractive";
		public static const TRACK_ENTER_FULLSCREEN:String			= "trackEnterFullscreen";
		public static const TRACK_MUTE:String						= "trackMute";
		
		public function UIFTrackEvent(type:String, info:Object) { 
			super(type, info);			
		}	
	}
	
}