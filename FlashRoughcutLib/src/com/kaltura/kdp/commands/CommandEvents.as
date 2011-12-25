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
package com.kaltura.kdp.commands
{
	import flash.events.Event;
	
	public class CommandEvents extends Event
	{
		/**
		 * QPoint finished
		 */		
		static public const QPOINT_FINISHED:String = "qpointFinished";
		/**
		 * QPoint action
		 */		
		static public const QPOINT_ACTION:String = "qpointAction";
		/**
		 * pause event the kplayer shoots
		 */		
		static public const PLAYER_PAUSED:String = "playerPaused";
		/**
		 * play event the kplayer shoots
		 */		
		static public const PLAYER_PLAYED:String = "playerPlayed";
		/**
		 * stop event the kplayer shoots
		 */		
		static public const PLAYER_STOPPED:String = "playerStopped";
		/**
		 * seek event the kplayer shoots. Addition data - object that holds the seek data
		 */		
		static public const PLAYER_SEEKED:String = "playerSeeked";
		/**
		 * do stop command to the kplayer
		 */		
		static public const DO_PAUSE:String = "doPause";
		
		/**
		 * do play command to the kplayer
		 */		
		static public const DO_PLAY:String = "doPlay";
		/**
		 * do stop command to the kplayer
		 */		
		static public const DO_STOP:String = "doStop";
		/**
		 * do seek command to the kplayer. Addition data - object that holds the seek data
		 */		
		static public const DO_SEEK:String = "doSeek";
		/**
		 * new asset. Addition data - asset info 
		 */		
		static public const PLAYER_UPDATE_NEW_ASSET:String = "playerUpdateNewAsset";
		/**
		 * end of show 
		 */		
		static public const PLAYER_PLAY_END:String = "playerPlayEnd";
		/**
		 * interval event every X milisec. Addition data - the new time 
		 */		
		static public const PLAYER_UPDATE_PLAYHEAD:String = "playerUpdatePlayhead";
		/**
		 * build a popup from the XML popup. Addition data - string: name of popup
		 */		
		static public const POPUP_SERVICE:String = "popupService";
		/**
		 * build a popup from a given UIcomponent instance. Addition data - reference to instance;
		 */		
		static public const POPUP_OBJECT:String = "popupObject";
		/**
		 * call a JS function from the js in the XML. Addition data - string: name of command
		 */		
		static public const JS_INJECT:String = "jsInject";
		/**
		 * navigate to a specified URL 
		 */		
		static public const NAVIGATE:String = "navigate";
		/**
		 * call a JS function from a direct command. no arguments are being tranfered here. 
		 */		
		static public const JS_FUNCTION:String = "jsFunction";
		/**
		 * Click of button / linkButton / label  
		 */		
		static public const K_CLICK:String = "kClick";
		/**
		 * open full screen 
		 */		
		static public const  OPEN_FULL_SCREEN :String = "openFullScreen";
		/**
		 * close full screen command 
		 */		
		static public const  CLOSE_FULL_SCREEN :String = "closeFullScreen";
		/**
		 * the fullscreen has just closed 
		 */		
		static public const  HAS_CLOSED_FULL_SCREEN :String = "hasCloseFullScreen";
		/**
		 * the fullscreen was just activated 
		 */
		static public const  HAS_OPENED_FULL_SCREEN :String = "hasOpenedFullScreen";
		/**
		 *change volume. additional data - volume value (0 to 100) 
		 */
		static public const  VOLUME_CHANGE :String = "volumeChange";
		/**
		 *Change visual them addition data - theme XML (CSS class selectors, font colors) 
		 */
		static public const CHANGE_THEME:String = "changeTheme";
		/**
		 *change the current kshow to another kshow. Addition data - int
		 */		
		static public const  CHANGE_KSHOW:String = "changeKshow";
		/**
		 *enable/disable gui. Addition data - Boolean 
		 */		
		static public const  ENABLE_GUI:String = "enableGui";
		/**
		 *the scrabber is being drugged
		 */		
		static public const  START_SCRUBB:String = "startScrubb";
		/**
		 *the scrabber is being released
		 */		
		static public const  STOP_SCRUBB:String = "stopScrubb";
		/**
		 *capture the video current bitmap and send it to the server 
		 */
		static public const  CAPTURE_THUMBNAIL:String = "captureThumbnail";
		static public const  CAPTURE_THUMBNAIL_FAILED:String = "captureThumbnailFailed";
		static public const  CAPTURE_THUMBNAIL_SUCCESS:String = "captureThumbnailSuccess";
		/**
		 *gigya 
		 */
		static public const  GIGYA:String = "gigya";
		/**
		 *fast forward the player. Addition data - times X (X2, X8, X4);
		 */
		static public const  FAST_FORWARD:String = "fastForward";
		/**
		 *fast forward the player. Addition data - times X (X2, X8, X4);
		 */
		static public const  STOP_FAST_FORWARD:String = "stopFastForward";
		/**
		 *popup the Gigya swf in the popup manager 
		 */
		static public const  GIGYA_POPUP:String = "gigyaPopup";
		/**
		 *progress of player in case of image or video
		 */
		static public const  PLAYER_PROGRESS:String = "playerProgress";
		/**
		 *player rollover
		 */
		static public const  PLAYER_ROLL_OVER:String = "playerRollOver";
		/**
		 *player ready with content
		 */
		static public const  PLAYER_READY:String = "playerReady";
		/**
		 *player ready without content
		 */
		static public const  PLAYER_EMPTY:String = "playerEmpty";
		/**
		 *player rollout
		 */
		static public const  PLAYER_ROLL_OUT:String = "playerRollOut";
		/**
		 * show the pause scren. happens only when the play/pause button or the video player are clicked 
		 */
		static public const  SHOW_PAUSE_SCREEN:String = "showPauseScreen";
		/**
		 * show the pause scren. happens only when the play/pause button or the video player are clicked 
		 */
		static public const  FORCE_PAUSE_SCREEN:String = "forcePauseScreen";
		/**
		 *close current popup
		 */		
		static public const  CLOSE_POPUP:String = "closePopup";
		/**
		 *center current popup
		 */		
		static public const  CENTER_POPUP:String = "centerPopup";
		/**
		 *a banner is displayed on the bottom of the area
		 */		
		static public const  SHOW_BOTTOM_BANNER:String = "showBottomBanner";
		/**
		 *a banner was just dissapeare from the bottom of the area
		 */		
		static public const  HIDE_BOTTOM_BANNER:String = "hideBottomBanner";
		/**
		 *open Taboola during
		 */		
		static public const  SHOW_DURING_RELATED:String = "showDuringRelated";
		/**
		 *show the start screen 
		 */		
		static public const  SHOW_START_SCREEN:String = "showStartScreen";
		/**
		 *show the start screen 
		 */		
		static public const  SHOW_END_SCREEN:String = "showEndScreen";
		/**
		 *show the start screen 
		 */		
		static public const  SHOW_PLAY_SCREEN:String = "showPlayScreen";
		
		public var data:Object; 
		
		public function CommandEvents(type:String,
		 															o:Object=null,
		 															bubbles:Boolean = false ,
																	cancelable : Boolean = false) {
				super(type,bubbles,cancelable);
				data= o;
		}
	}
}