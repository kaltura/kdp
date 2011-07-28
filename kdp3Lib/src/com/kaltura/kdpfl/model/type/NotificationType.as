package com.kaltura.kdpfl.model.type
{
	/**
	 * Class NotificationType holds the constants representing the notifications fired within the KDP. 
	 * @author Hila
	 * 
	 */	
	public class NotificationType
	{
		/**
		 * the first command that register the main proxys and main view mediator
		 */
		public static const STARTUP					:String = "startUp";
		/**
		 * Start the init macro commands
		 */		
		public static const INITIATE_APP 			:String	= "initiatApp";
		/**
		 * Start the init of change media macro commands 
		 */		
		public static const CHANGE_MEDIA			:String	= "changeMedia";
		/**
		 * cleans the media in case of change media and entryId== -1
		 */		
		public static const CLEAN_MEDIA				:String	= "cleanMedia";
		/**
		 * Dispatched when the skin is loaded 
		 */		
		public static const SKIN_LOADED				:String = "skinLoaded";
		/**
		 * Skin load failed 
		 */		
		public static const SKIN_LOAD_FAILED		:String = "skinLoadFailed";
		/**
		 * The BaseEntry object has been retrieved successfully
		 */		
		public static const ENTRY_READY				:String = "entryReady";
		/**
		 * The BaseEntry object has failed to be retrieved
		 */		
		public static const ENTRY_FAILED			:String = "entryFailed";
		
		public static const PLUGINS_LOADED          :String = "pluginsLoaded";
		/**
		 * When the source is ready we can set the media element to the media player 
		 */	
		public static const SOURCE_READY			:String = "sourceReady";
		/**
		 * DEPRECATED
		 * Start the init macro command of the KDP 
		 */	
		public static const LOAD_MEDIA				:String	= "loadMedia";
		/**
		 * DEPRECATED
		 * The loadable media has begun loading..
		 */		
		public static const MEDIA_LOADING			:String = "mediaLoading";
		/**
		 * The loadable media element has completed construction.
		 */		
		public static const MEDIA_READY				:String = "mediaReady";
		/**
		 * The loadable media has begun unloading.
		 */		
		public static const MEDIA_UNLOADED			:String = "mediaUnloaded";
		/**
		 * The loadable media has failed to complete loading.
		 */		
		public static const MEDIA_LOAD_ERROR		:String = "mediaLoadError";
		/**
		 * The playe notify on media error 
		 */		
		public static const MEDIA_ERROR				:String = "mediaError";
		//TODO: see if we can remove this later
		public static const ROOT_RESIZE				:String	= "rootResize";
		/**
		 * Used mainlly to know when OSMF Media Playe is viewable 
		 */		
		public static const MEDIA_VIEWABLE_CHANGE	:String = "mediaViewableChange";
		
		/**
		 * This is the first event that start the pre sequence 
		 */		
		static public const PRE_1_START				:String = "pre1start";
		/**
		 * This is the first event that start the pro sequence 
		 */		
		static public const POST_1_START			:String = "post1start";
		
		/**
		 * Command the player to pause;
		 */
		static public const DO_PAUSE				:String = "doPause";
		/**
		 * Command the player to play;
		 */
		static public const DO_PLAY					:String = "doPlay";
		/**
		 * DEPRECATED IN KDP3
		 * This is the actually play command on the video player. It is an addition to the DoPlay
		 * because of the pre session mechanism (pre roll ads, bumper)
		 */
		static public const DO_PLAY_ENTRY			:String = "doPlayEntry";
		/**
		 * Do stop command to the kplayer. Pause and move the playhead to 0
		 */
		static public const DO_STOP					:String = "doStop";
		/**
		 * Do seek command to the kplayer. Addition data - number 
		 */
		static public const DO_SEEK					:String = "doSeek";
		/**
		 * Do switch command for switching manual switching between mbr streams within an rtmp dynamic stream resource 
		 */
		static public const DO_SWITCH					:String = "doSwitch";
		/**
		 * Dispahed when the KDP is Ready  
		 */		
		static public const KDP_READY 				:String = "kdpReady";		
		/**
		 * Dispahed when the KDP is Ready and has no source loaded  
		 */		
		static public const KDP_EMPTY 				:String = "kdpEmpty";
		/**
		 * Dispahed when the init macro command is done and the layout is ready  
		 */		
		static public const LAYOUT_READY 		 	:String = "layoutReady";		
		/**
		 * The player is loading or connecting.
		 */
		static public const PLAYER_STATE_CHANGE 	:String = "playerStateChange";
		/**
		 * Dispatches when player ready with content
		 */
		static public const PLAYER_READY			:String = "playerReady";
		/**
		 * When the player mediator finish to register we can reffer to the player container from anywhere 
		 */		
		static public const PLAYER_CONTAINER_READY  :String = "playerContainerReady";
		/**
		 * Was paused event the kplayer shoots
		 */
		static public const PLAYER_PAUSED			:String = "playerPaused";
		/**
		 * was played event the kplayer shoots
		 */
		static public const PLAYER_PLAYED			:String = "playerPlayed";
		/**
		 * dispatches when the player seeking property changed to true.  
		 */		
		static public const PLAYER_SEEK_START		:String = "playerSeekStart";
		/**
		 * dispatches when the player seeking property changed to false.  
		 */		
		static public const PLAYER_SEEK_END			:String = "playerSeekEnd";
		/**
		 * end of the media (when the pleayhead first reach the duration)
		 */
		static public const PLAYER_PLAY_END			:String = "playerPlayEnd";
		/**
		 * interval event every X milisec. Addition data - the new time
		 */
		static public const PLAYER_UPDATE_PLAYHEAD	:String = "playerUpdatePlayhead";
		/**
		 * dispatches when the player width and/or  height properties have changed. 
		 */		
		static public const PLAYER_DIMENSION_CHANGE :String = "playerDimensionChange";
		/**
		 * open full screen
		 */
		static public const OPEN_FULL_SCREEN		:String = "openFullScreen";
		/**
		 * close full screen command
		 */
		static public const CLOSE_FULL_SCREEN		:String = "closeFullScreen";
		/**
		 * change volume. additional data - volume value (0 to 1)
		 */
		static public const CHANGE_VOLUME			:String = "changeVolume";
		/**
		 * volume changed. additional data - volume value (0 to 1)
		 */
		static public const VOLUME_CHANGED			:String = "volumeChanged";
		/**
		 *enable/disable gui. Addition data - Boolean
		 */
		static public const ENABLE_GUI				:String = "enableGui";	
		/**
		 * Notify the current and the previous value of bytesDownloaded 
		 */
		static public const BYTES_DOWNLOADED_CHANGE :String = "bytesDownloadedChange";
		/**
		 * Dispatched by the player when the value of the property "bytesTotal" has changed. 
		 */		
		static public const BYTES_TOTAL_CHANGE		:String = "bytesTotalChange";
		/**
		 * Dispatches when progress of player in case of image or video
		 */
		static public const BUFFER_PROGRESS			:String = "bufferProgress";
		/**
		 * Dispatches when the player start or stop buffering 
		 */		
		static public const BUFFER_CHANGE			:String = "bufferChange";	
		/**
		 * The player dispatches this event when its duration property has changed 
		 */
		static public const DURATION_CHANGE			:String = "durationChange";
		/**
		 * the fullscreen has just closed
		 */
		static public const HAS_CLOSED_FULL_SCREEN :String = "hasCloseFullScreen";
		/**
		 * the fullscreen was just activated
		 */
		static public const HAS_OPENED_FULL_SCREEN :String = "hasOpenedFullScreen";
		/**
		 * Notification dispatched when the player has started switching to a different dynamic bitrate.
		 * Body of the notification - {newIndex: [the index of the bitrate the player started switching to. If auto, send -1],newBitrate: [the bitrate the player started switching to. If auto, sned null]}
		 */		
		static public const SWITCHING_CHANGE_STARTED		:String = "switchingChangeStarted";
		/**
		 *  Notification dispatched when the player has finished switching to a different dynamic bitrate.
		 * 	Body of the notification - {currentIndex:[the index of the bitrate that the player finished switching to],currentBitrate: [the bitrate the player finished switching to]}
		 */		
		static public const SWITCHING_CHANGE_COMPLETE		:String = "switchingChangeComplete";
		/**
		 *  The scrubber had started being dragged
		 */		
		static public const SCRUBBER_DRAG_START		:String = "scrubberDragStart";
		/**
		 *  The scrubber had stopped being dragged
		 */		
		static public const SCRUBBER_DRAG_END		:String = "scrubberDragEnd";
		/**
		 * Pop up an alert. arguments: message, title, buttons, callbackFunction, iconClass
	
		 *message - string containing the message to display in the alert
		 *title - string containing the title of the alert
		 *buttons - array of strings for the alert button labels
		 *callbackFunction - the function which handles an alert button being clicked.
		 *iconClass - string containing the name of the export class of the icon that the alert should display (should exist in the skin.swf file).
		 */ 
		static public const ALERT					:String = "alert";
		/**
		 * show/hide an element fron the layout. arguments: id:String, show:boolean
		 */ 
		static public const SHOW_UI_ELEMENT			:String = "showUiElement";
        /**
		 * hide Alerts at the Alerts Mediator
		 */ 
		static public const CANCEL_ALERTS			:String = "cancelAlerts";
		/**
		 * Free preview end
		 */		
		static public const FREE_PREVIEW_END		:String = "freePreviewEnd";
		/**
		 * show Alerts at the Alerts Mediator
		*/ 
		static public const ENABLE_ALERTS			:String = "enableAlerts";
		/**
		 * Call the LiveStream command which tests whether the stream is currently on air.
		 */	
		 static public const LIVE_ENTRY             :String = "liveEntry";
		 /**
		  * Signifies the end of an entry that is part of a sequence as opposed to the end of a regular entry.
		  */		 
		 static public const SEQUENCE_ITEM_PLAY_END  :String = "sequenceItemPlayEnd";	
		 /**
		  * Signifies the end of a media in the player (no idea which entry)
		  */		 
		 static public const PLAYBACK_COMPLETE       :String = "playbackComplete";
		 /**
		  * Signifies the end of the pre-sequence
		  */		 
		 static public const PRE_SEQUENCE_COMPLETE   :String = "preSequenceComplete";
		 /**
		  * Signifies the end of the post-sequence
		  */		 
		 static public const POST_SEQUENCE_COMPLETE  :String = "postSequenceComplete";
		 /**
		  * Fired when skip ad button is pressed 
		  */		 
		 static public const SEQUENCE_SKIP_NEXT      :String = "sequenceSkipNext";
		 /**
		  *Fired when the entry is of a non-playable status 
		  */		 
		 static public const ENTRY_RESTRICTED        :String = "entryRestricted";
		 /**
		  * Fired when the player started replaying the video 
		  */		 
		 static public const DO_REPLAY		         :String = "doReplay";
		 /**
		  * Fired when the player has started intelligent seeking 
		  */		 
		 static public const INTELLI_SEEK            :String = "intelligentSeek";
		 /**
		  * Fired when all alerts popped by the player need to be removed. 
		  */	
		 static public const REMOVE_ALERTS			 :String = "removeAlerts";
		 /**
		  * Fired when metadata for the entry has been received. 
		  */		 
		 static public const METADATA_RECEIVED		 :String = "metadataReceived";
		 /**
		  * Fired when the first mini-command of the ChangeMedia macro command is inited. 
		  */		 
		 static public const CHANGE_MEDIA_PROCESS_STARTED	: String = "changeMediaProcessStarted"; 
		 /**
		  * From version 3.5.0 this notification replaces the MEDIA_READY notification as the catalyst for the
		  * MediaReadyCommand. This notification is indicative that the MediaElement constructed under the MediaProxy 
		  * function prepareMediaElement is loaded into the OSMF MediaPlayer. 
		  */		 
		 static public const MEDIA_LOADED 					: String = "mediaLoaded";
		 /**
		  *  Notification added with version 3.5.0, signifies that an entry/media is ready to be
		  * played in the KDP
		  */		 
		 static public const READY_TO_PLAY					: String = "readyToPlay";
		 /**
		  * Notification added with version 3.5.0, signifies that there is no playable
		  * entry/media in the KDP, and that it is ready to load alternate media/entries.
		  */		 
		 static public const READY_TO_LOAD					: String = "readyToLoad";
		 /**
		  * Notification fired when the player has successfully loaded an entry's cue-point configuration. 
		  * cuePointMap : Object - Object mapping between start-times and arrays of the cue points found on that start-time
		  */		 
		 static public const CUE_POINTS_RECEIVED 			: String = "cuePointsReceived";
		 /**
		  * Notification fired when the player has finished adding a timeline marker event for all the cue point start times in the 
		  * cue point map of the entry. 
		  */		
		 static public const CUE_POINTS_REGISTERED			: String = "cuePointsRegistered";
		 /**
		  * Noitification fired when the player time progress reaches a code cue-point.
		  * Body - cue point object
		  * 
		  */		 
		 static public const CUE_POINT_REACHED				: String = "cuePointReached";
		 /**
		  * Notification fired when the player's time progress reaches an ad cue point.
		  * Body - 
		  * 1. context of the ad opportunity: pre,post, mid.
		  * 2. cue point object
		  */
		 static public const AD_OPPORTUNITY					: String = "adOpportunity";
		 /**
		  * Notification fired when the  midroll sequence ends.
		  */		 
		 static public const MID_SEQUENCE_COMPLETE				: String = "midSequenceComplete";
	}
}