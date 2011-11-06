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
package com.kaltura.components.players.eplayer
{
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.components.players.events.PlayerBufferEvent;
	import com.kaltura.components.players.events.PlayerEvent;
	import com.kaltura.components.players.events.PlayerStateEvent;
	import com.kaltura.components.players.states.BufferStatuses;
	import com.kaltura.components.players.states.VideoStates;
	import com.kaltura.components.players.vo.DelayedInsertVO;
	import com.kaltura.managers.downloadManagers.types.StreamingModes;
	import com.kaltura.net.downloading.LoadingStatus;
	import com.kaltura.net.interfaces.IMediaSource;
	import com.kaltura.net.nonStreaming.SWFLoaderMediaSource;
	import com.kaltura.net.streaming.ExNetStream;
	import com.kaltura.net.streaming.events.ExNetStreamEvent;
	import com.kaltura.plugin.layer.LayersContainer;
	import com.kaltura.plugin.logic.Plugin;
	import com.kaltura.plugin.logic.effects.KEffect;
	import com.kaltura.plugin.logic.overlays.Overlay;
	import com.kaltura.plugin.logic.transitions.KTransition;
	import com.kaltura.roughcut.Roughcut;
	import com.kaltura.roughcut.soundtrack.AudioPlayPolicy;
	import com.kaltura.plugin.utils.fonts.*;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;

/* 	import mx.events.DragEvent;
	import mx.graphics.codec.IImageEncoder;
	import mx.graphics.codec.JPEGEncoder;
	import mx.managers.DragManager;
 */
 
	/**
	* Dispatched when the roughcut is set so it can be listened from outside
	*/ 	
 	[Event(name="roughcutReady", type="flash.events.Event")]
	/**
	* Dispatched when the player is playing a roughcut (dispatched approx. every 40ms when in playing state only).
	* @eventType com.kaltura.components.players.events.PlayerEvent.ROUGHCUT_UPDATE_PLAYHEAD
	*/
	[Event(name="roughcutUpdatePlayhead", type="com.kaltura.components.players.events.PlayerEvent")]
	/**
	* Dispatched when the player is playing a roughuct (dispatched every change in visual assets),
	* whenever a new video / image / solidColor is added to the visual layers.
	* @eventType com.kaltura.components.players.events.PlayerEvent.UPDATE_PLAYHEAD_NEW_ASSET
	*/
	[Event(name="updatePlayheadNewAsset", type="com.kaltura.components.players.events.PlayerEvent")]
	/**
	* Dispatched when roughcut play finished.
	* @eventType com.kaltura.components.players.events.PlayerEvent.ROUGHCUT_PLAY_END
	*/
	[Event(name="roughcutPlayEnd", type="com.kaltura.components.players.events.PlayerEvent")]
	/**
	* Dispatched when player entered pause state.
	* @eventType com.kaltura.components.players.events.PlayerEvent.ROUGHCUT_PAUSE
	*/
	[Event(name="roughcutPause", type="com.kaltura.components.players.events.PlayerEvent")]
	/**
	* Dispatched when the player is playing single media clip (dispatched approx. every 40ms when in playing state only).
	* @eventType com.kaltura.components.players.events.PlayerEvent.SINGLE_VIDEO_UPDATE_PLAYHEAD
	*/
	[Event(name="singleVideoUpdatePlayhead", type="com.kaltura.components.players.events.PlayerEvent")]
	/**
	* Dispatched when player finished playing single media clip.
	* @eventType com.kaltura.components.players.events.PlayerEvent.ROUGHCUT_PAUSE
	*/
	[Event(name="singleVideoPlayEnd", type="com.kaltura.components.players.events.PlayerEvent")]
	/**
	* dispatched to notify a change in the buffering state of the player.
	* @eventType com.kaltura.components.players.events.PlayerBufferEvent.PLAYER_BUFFER_STATUS
	*/
	[Event(name="playerBufferStatus", type="com.kaltura.components.players.events.PlayerBufferEvent")]
	/**
	* dispatched whenever the player state is changed (play / pause / stop / etc).
	* @eventType com.kaltura.components.players.events.PlayerStateEvent.CHANGE_PLAYER_STATE
	*/
	[Event(name="changePlayerState", type="com.kaltura.components.players.events.PlayerStateEvent")]

	/**
	 *the editing player is the final component in the kaltura hierarchy, this component is responisble for rendering and
	 * synchronizing the final roughcut (audio/visual).
	 */
	public class Eplayer extends Sprite
	{
		/**
		* styling for message texts.
		*/
		private static var txtFormat:TextFormat = new TextFormat("Arial", 14, 0xFFFFFF, true);
		private static var PreviewtxtFormat:TextFormat = new TextFormat("Arial", 34, 0xffffff, true);
		private static var PreviewBuffertxtFormat:TextFormat = new TextFormat("Arial", 16, 0xffffff, true);
		/**
		*the default width of the player conponent.
		*/
		public static const PLAYER_WIDTH:Number = 640;
		/**
		*the default height of the player conponent.
		*/
		public static const PLAYER_HEIGHT:Number = 480;
		/**
		* the computed width of the player, after constrain of aspect ratio.
		*/
		private var compWidth:Number = Eplayer.PLAYER_WIDTH;
		/**
		* the computed height of the player, after constrain of aspect ratio.
		*/
		private var compHeight:Number = Eplayer.PLAYER_HEIGHT;
		private var _stretchContent:Boolean = true;
		//xxx [Bindable]
		/**
		 * determine whether or not to stretch the visual layers of the player or maintain aspect ratio.
		 * @see #aspectRatio
		 */
		public function get stretchContent ():Boolean {
			return _stretchContent;
		}
		public function set stretchContent (value:Boolean):void {
			_stretchContent = value;
			//xxx invalidateDisplayList();
		}
		private var _aspectRatio:Number = 0.75;
		public function get aspectRatio ():Number {
			return _aspectRatio;
		}
		public function set aspectRatio (value:Number):void {
			_aspectRatio = value;
			//xxx invalidateDisplayList();
		}
		/**
		* the x coordinate of the current layer.
		*/
		private var nXcurrent:Number = 0;
		/**
		* the y coordinate of the current layer.
		*/
		private var nYcurrent:Number = 0;
		/**
		* the x coordinate of the next layer.
		*/
		private var nXnext:Number = 0;
		/**
		* the y coordinate of the next layer.
		*/
		private var nYnext:Number = 0;
		/**
		* the width of the player before resizing, used to compute the scale factor for player container.
		*/
		private var lastW:Number = compWidth;
		/**
		* the height of the player before resizing, used to compute the scale factor for player container.
		*/
		private var lastH:Number = compHeight;
		/**
		* play the roughcut till it reaches this sequence time (in seconds).
		*/
		private var playSingleSegmentStopTime:Number = -1;
		/**
		* a container to hold the on player UI of plugins.
		*/
		//public var pluginUIContainer:Canvas = new Canvas ();
		/**
		* text to hold error messages
		*/
		//xxx private var txtErrorMessage:TextField = new TextField ();
		/**
		*holds the error text for layout
		*/
		//xxx private var errMsgContainer:UIComponent = new UIComponent();

		private var _overAllVolumeControl:Number = 1;
		/**
		* a number between 0 - 1 to control the master volume in which all the assets volume will relatively play.
		*/
		//xxx [Bindable]
		//xxx [Inspectable]
		public function get overAllVolumeControl ():Number
		{
			return _overAllVolumeControl;
		}
		public function set overAllVolumeControl (value:Number):void
		{
			if (_overAllVolumeControl != value)
			{
/*xxx 				if (initialized)
					setOverAllVolume(value);
				else
					_overAllVolumeControl = value;
 */			}
		}
		/**
		* the volume control for soundtrack.
		*/
		//xxx [Bindable]
		public var audioVolume:Number = 1;
		/**
		* the background.
		*/
		private var backgroundSprite:Sprite = new Sprite();
		/**
		* holds the background.
		*/
		private var backgroundContainer:UIComponent = new UIComponent ();
		/**
		* mask the children of this component.
		* to have movement transitions that exceeds the Player dimentions look good we need to mask the whole player.
		*/
		private var playerMask:UIComponent = new UIComponent ();
		/**
		* the collection that holds the assets to of the roughcut to be played.
		*/
		private var timelineAssets:ArrayCollection = new ArrayCollection();
		/**
		* the collection that holds the assets that currently should play.
		*/
		private var activeAssetsToPlay:ArrayCollection = new ArrayCollection();
		/**
		* the current playing rounghcut.
		*/
		//xxx [Bindable]
		public function set roughcut (roughcut2play:Roughcut):void
		{
			_roughcut = roughcut2play;
			preSequencePlay();
			dispatchEvent( new Event( "roughcutReady" ) );
		}
		public function get roughcut ():Roughcut
		{
			return _roughcut;
		}
		protected var _roughcut:Roughcut;
		/**
		* the sequence synch timer, this is used to synch assets and create a playing Kaltura roughcut.
		*/
		private var sequenceSynchTimer:Timer = new Timer(40);
		/**
		 * a timer for synching with a single preview stream (for preview or trimming modes).
		 */
		private var singleStreamSynchTimer:Timer = new Timer(100);
		/**
		* in ms, the time at which we started playing the roughcut, used to calculate dTimeSec.
		*/
		private var seqPlayStartTime:uint = 0;
		/**
		* the current state of the player.
		* @see com.kaltura.components.players.states.VideoStates
		*/
		private var _playState:uint = VideoStates.EMPTY;
		//xxx [Inspectable]
		//xxx [Bindable(event="changePlayerState")]
		public function get playState():uint
		{
			return _playState;
		}
		public function set playState (newState:uint):void
		{
			if (_playState == newState)
				return;

			switch (newState)
			{
				case VideoStates.STOP:
					pauseSequence();
					seekSequence(0);
					break;

				case VideoStates.PAUSE:
					pauseSequence();
					break;

				case VideoStates.PLAY:
					resumePlaySequence();
					break;

				default:
					changeState ( newState );
					break;
			}
		}
		private function changeState (newState:uint):void
		{
			_playState = newState;
			dispatchEvent(new PlayerStateEvent (PlayerStateEvent.CHANGE_PLAYER_STATE, newState));
		}
		/**
		*duration of the roughcut being played.
		*/
		//xxx [Bindable]
		public var roughcutDuration:Number = 0;
		/**
		* this container holds all display of the playing roughcut in the current time.
		* use this to apply and perform actions on the playing display list.
		*/
		private var playerAssetsContainer:UIComponent = new UIComponent();
		/**
		* the container that holds the visual layers - video timeline (video, image, solid).
		*/
		private var videoHolder:LayersContainer;
		/**
		* the container that holds the overlays.
		*/
		private var overlaysHolder:LayersContainer;
		/**
		* the audio timeline.
		*/
		private var audioArray:Array = [null, null];
		/**
		* the current playing audio layer.
		*/
		private var audioLayerOnTop:int = 0;
		/**
		* the voice timeline.
		*/
		private var voiceArray:Array = [null, null];
		/**
		* the current playing voice layer.
		*/
		//xxx private var voiceLayerOnTop:int = 0;
		/**
		* temporary transitions timeline.
		* for preview of transition assets.
		*/
		/**
		* holds the preview image and video.
		*/
		//xxx private var previewContainer:UIComponent = new UIComponent ();
		/**
		* preview image for preview of images.
		*/
		//xxx private var singleImage:Image = new Image();
		/**
		* preview video for preview of streams.
		*/
		//xxx private var previewVideo:Video = new Video(Eplayer.PLAYER_WIDTH, Eplayer.PLAYER_HEIGHT);
		/**
		* preview NetConnection for preview stream.
		*/
		//xxx private var previewNC:NetConnection = new NetConnection ();
		/**
		* preview NetStream for preview of streams.
		*/
		//xxx private var singleNetStream:ExNetStream;
		/**
		* used to notify about previewing mode.
		*/
		//xxx private var txtPreviewMessage:TextField = new TextField ();
		/**
		* used to notify about buffering in previewing mode.
		*/
		//xxx private var txtPreviewBufferingMessage:TextField = new TextField ();
		/**
		 *if true, player will monitor buffer and will not play untill there is enough data, if false, player will play even if no data is available.
		 */
		public var monitorBuffer:Boolean = false;
		/**
		 * indicates if the player is buffering now.
		 */
		//xxx [Bindable (event="playerBufferStatus")]
		public var nowBuffering:Boolean = false;
		/**
		 * the clock time when the player started buffering (in milliseconds).
		 */
		public var startBufferingClockTime:uint = 0;
		/**
		 * the minimum time it should take to do buffering (in milliseconds).
		 */
		public var minimumBufferingTimeMs:uint = 1000;
		/**
		* contains the preview message.
		*/
		//xxx private var previewMsgContainer:UIComponent = new UIComponent ();
		/**
		* blink preview msg using this timer.
		*/
		//xxx private var PreviewMsgTimer:Timer = new Timer (750);
		/**
		* the background color of the player.
		*/
		private var _backgroundColor:uint = 0;
		/**
		* indicates if player is currently in preview mode.
		*/
		//xxx [Inspectable]
		//xxx [Bindable]
		public var isPreviewing:Boolean = false;
		/**
		* save the position of the playhead before preview mode.
		*/
		private var dTimeSecBeforePreview:Number = 0;
		/**
		* audio clip icon (displayed when a sound is played to indicate that no video is playing)
		*/
		//TODO: make the soundclip icon a style
		//xxx [Embed (source="/resources/SoundIcon.png")]
		//xxx private var soundImageClass:Class;
		/**
		* for debugging puposes, we can delay the render of video frame.
		*/
		private var delayVideoHolderRender:Boolean = false;
		/**
		* hold the id of the last timeout carried out by fixSeek.
		*/
		private var clearFixSeekTimeout:uint;
		/**
		* if true, player will preform an extra seekSequence call to fix the image rendered from the video.
		*/
		private var preformFixSeek:Boolean = true;
		/**
		* for debugging, save the start time before setting it to the new one, when preforming seekSequence.
		*/
		static private var debugStartTime:uint;
		/**
		* for debugging, save the seek time before setting it to the new one, when preforming seekSequence.
		*/
		static private var debugTime2Seek:uint;
		/**
		* for debugging, save the last playhead time before setting it to the new one, when preforming seekSequence.
		*/
		static private var debugLastTimeStamp:uint;
		/**
		* for debugging, save the playhead time before setting it to the new one, when preforming seekSequence.
		*/
		static private var debugdTimeSec:Number;
		/**
		* deprecated, was used to set a timeout for seek operation when reaching a state of endless seeks between transition and two video streams.
		*/
		[Deprecated]
		private var seekTimeout:int;
		/**
		* preform a pause after calling sequenceSynch when calling it from seekSequence function.
		*/
		private var pauseAfterSeek:Boolean = false;
		/**
		 * fix dTimeSec when invalid seek time is set.
		 */
		private var dTimeBeforeInvalidSeek:Number;
		/**
		* when fixing a seek, this will count the times the seek was carried out.
		*/
		private var seekFixCounter:uint = 0;
		/**
		* when fixing a seek, this will set the maximum tryouts the seek should be carried out.
		*/
		private var seekFixMaxTryouts:uint = 1;
		/**
		* deprecated, save when was the last seek operation preformed.
		*/
		private var lastSeekTime:uint = 0;
		/**
		* the id of the timeout for fix seek.
		*/
		private var lastSeekFix:uint;
		/**
		* true if the seek operation should be on the single stream in the current layer.
		*/
		private var seekingCurrent:Boolean = false;
		
		private var wasSeekInvalid : Boolean = false;
		/**
		 * determine if when setting playheadTime property player should also preform seek.
		 */
		//xxx [Inspectable]
		//xxx [Bindable]
		public var liveSeek:Boolean = false;
		/**
		 * @return the currently play head time value
		 *
		 */
		//xxx [Inspectable]
		//xxx [Bindable (event="roughcutUpdatePlayhead")]
		public function get playheadTime ():Number
		{
			return dTimeSec;
		}
		public function set playheadTime (val:Number):void
		{
			if (dTimeSec == val && !forceBindingUpdate)
				return;
			if (!liveSeek)
			{
				dTimeSec = val;
			} else {
				seekSequence(val, false, true);
			}
		}
		/**
		 * when playheadTime is updated with the same value, the function exit without update,
		 * in some cases there's a need to update the screen even if it's already on the same time,
		 * use this to force update even if the playheadTime value is the same.
		 */
		//xxx [Inspectable]
		//xxx [Bindable]
		public var forceBindingUpdate:Boolean = false;
		/**
		 *internal static function to return a timing number value in ms long enough for accurate calculations and timing.
		 * needs to be revised... (06/08/2008).
		 * @return  time in ms since application started (add 1000000).
		 */
		static protected function my_getTimer ():uint
		{
			return getTimer() + 100000000;
		}
		/**
		 *the playhead time of the current single stream (preview or trimming mode).
		 */
		protected var singleStreamTime:Number;
		/**
		 * the time of the single video in the current layer (for use with trimming or preview single video / audio stream).
		 * @return 		time in seconds of the current layer's stream's playhead.
		 */
		//xxx [Inspectable]
		//xxx [Bindable (event="singleVideoUpdatePlayhead")]
		public function get singleVideoTime ():Number
		{
			if (videoHolder.current.stream)
				return singleStreamTime;
			else
				return 0;
		}
		public function set singleVideoTime (val:Number):void
		{
			if (singleStreamTime == val)
				return;
			seekOnSingleVideoAsset (val, singleVideoAsset.clipedStreamStart);
		}

		/**
	    * Constructor.
	    */
        public function Eplayer():void
        {
			super();
/*xxx
			previewNC.connect(null);
			var style:StyleSheet = new StyleSheet();
			var textS:Object = new Object ();
			textS.fontSize = 34;
			textS.textAlign = "center";
			textS.fontWeight = "bold";
			textS.color = "#ffffff";
			style.setStyle(".textdiv", textS);

			txtPreviewBufferingMessage.defaultTextFormat = PreviewBuffertxtFormat;
			txtPreviewBufferingMessage.setTextFormat(PreviewBuffertxtFormat);
			txtPreviewBufferingMessage.selectable = false;
			txtPreviewBufferingMessage.tabEnabled = false;
			txtPreviewBufferingMessage.antiAliasType = AntiAliasType.ADVANCED;
			txtPreviewBufferingMessage.thickness = 50;

			txtPreviewMessage.defaultTextFormat = PreviewtxtFormat;
			txtPreviewMessage.setTextFormat(PreviewtxtFormat);
			txtPreviewMessage.styleSheet = style;
			txtPreviewMessage.htmlText = "<body><span class='textdiv'>PREVIEW MODE</span></body>";
			PreviewMsgTimer.addEventListener(TimerEvent.TIMER, previewAnimate, false, 0, true);
			txtPreviewMessage.selectable = false;
			txtPreviewMessage.tabEnabled = false;
			txtPreviewMessage.antiAliasType = AntiAliasType.ADVANCED;
			txtPreviewMessage.thickness = 100;
			previewMsgContainer.blendMode = BlendMode.INVERT;
xxx*/

			backgroundContainer.addChildAt(backgroundSprite, 0);
			addChild(backgroundContainer);
			backgroundSprite.x = 0;
			backgroundSprite.y = 0;
			backgroundContainer.x = 0;
			backgroundContainer.y = 0;
			backgroundContainer.width = width;
			backgroundContainer.height = height;
			backgroundColor = 0;
			videoHolder = new LayersContainer(Eplayer.PLAYER_WIDTH, Eplayer.PLAYER_HEIGHT);
			overlaysHolder = new LayersContainer(Eplayer.PLAYER_WIDTH, Eplayer.PLAYER_HEIGHT);
			var larger:Boolean = width > height;

			videoHolder.y = 0;
			videoHolder.x = 0;
			overlaysHolder.x = 0;
			overlaysHolder.y = 0;
			playerAssetsContainer.addChild(videoHolder);
			playerAssetsContainer.addChild(overlaysHolder);
			addChild(playerAssetsContainer);

			//xxx txtErrorMessage.text = "This Asset isn't ready to play yet...";
			//xxx txtErrorMessage.defaultTextFormat = txtFormat;
			//xxx txtErrorMessage.setTextFormat(txtFormat);
			//xxx txtErrorMessage.background = true;
			//xxx txtErrorMessage.backgroundColor = 0;
			//xxx txtErrorMessage.antiAliasType = AntiAliasType.NORMAL;
			//xxx txtErrorMessage.autoSize = TextFieldAutoSize.RIGHT;
			//xxx txtErrorMessage.selectable = false;
			//xxx txtErrorMessage.multiline = true;
			//xxx txtErrorMessage.wordWrap = true;
			//xxx txtErrorMessage.visible = false;

			//xxx errMsgContainer.addChild (txtErrorMessage);
			//xxx addChild(errMsgContainer);

			// Set the player visible area (Mask)
			drawMask ();
			addChild(playerMask);
			mask = playerMask;

/*xxx
			horizontalScrollPolicy = ScrollPolicy.OFF;
        	verticalScrollPolicy = ScrollPolicy.OFF;
        	clipContent = true;

        	pluginUIContainer.width = Eplayer.PLAYER_WIDTH;
        	pluginUIContainer.height = Eplayer.PLAYER_HEIGHT;
xxx*/
        	overlaysHolder.width = Eplayer.PLAYER_WIDTH;
        	overlaysHolder.height = Eplayer.PLAYER_HEIGHT;
  			videoHolder.width = Eplayer.PLAYER_WIDTH;
  			videoHolder.height = Eplayer.PLAYER_HEIGHT;
  			videoHolder.current.width = Eplayer.PLAYER_WIDTH;
			videoHolder.current.height = Eplayer.PLAYER_HEIGHT;
			videoHolder.next.width = Eplayer.PLAYER_WIDTH;
			videoHolder.next.height = Eplayer.PLAYER_HEIGHT;
/*xxx
  			previewContainer.width = Eplayer.PLAYER_WIDTH;
  			previewContainer.height = Eplayer.PLAYER_HEIGHT;
  			previewVideo.width = Eplayer.PLAYER_WIDTH;
			previewVideo.height = Eplayer.PLAYER_HEIGHT;
			previewVideo.smoothing = false;

 			singleImage.width = Eplayer.PLAYER_WIDTH;
			singleImage.height = Eplayer.PLAYER_HEIGHT;
			singleImage.autoLoad = true;
			singleImage.maintainAspectRatio = true;
			singleImage.setStyle("horizontalAlign", "center");
			singleImage.setStyle("verticalAlign", "center");

  			pluginUIContainer.setStyle ("styleName", "innerCanvas");
        	pluginUIContainer.mouseChildren = true;
        	pluginUIContainer.mouseEnabled = true;
        	pluginUIContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
        	pluginUIContainer.verticalScrollPolicy= ScrollPolicy.OFF;
        	pluginUIContainer.clipContent = false;

        	previewContainer.addChild(previewVideo);
			previewContainer.addChild(singleImage);

			var g:Graphics = previewContainer.graphics;
			g.beginFill(0,1);
			g.drawRect(0,0,Eplayer.PLAYER_WIDTH, Eplayer.PLAYER_HEIGHT);
			g.endFill();
			
			previewMsgContainer.addChild(txtPreviewMessage);
			previewMsgContainer.addChild(txtPreviewBufferingMessage);
xxx*/
		}

		private var _previewAsset:AbstractAsset = null;
		/**
		 * preview an asset from roughcut's mediaClips (asset with null mediaSource)
		 * @param asset		the asset to preview.
		 * @see com.kaltura.assets.interfaces.IAssetable
		 */
		//xxx [Inspectable]
		//xxx [Bindable]
		public function set previewAsset (asset:AbstractAsset):void
		{
/* 			if (asset == _previewAsset)
				return;
			if (!asset)
			{
				_previewAsset = asset;
				playState = VideoStates.STOP;
				return;
			}
			_previewAsset = asset;
			dTimeSecBeforePreview = dTimeSec;
			pauseSequence (false, false, false);
			stopPreviewMode ();
			videoHolder.clearVideo();
			resetPlayer();
			var pId:String = KalturaApplication.getInstance().partnerInfo.partnerId;
			var subpId:String = KalturaApplication.getInstance().partnerInfo.subpId;
			var partnerPart:String = URLProccessing.getPartnerPartForTracking(pId, subpId);
			var nsSource:String = URLProccessing.clipperServiceUrl(asset.entryId, -1, -1, '1', partnerPart);
			switch (asset.mediaType)
			{
				case MediaTypes.VIDEO:
					previewVideo.visible = true;
				case MediaTypes.AUDIO:
					if (!asset.mediaSource)
					{
						singleNetStream = new ExNetStream (previewNC, nsSource, nsSource, true, true, 0, -1, false);
						singleNetStream.addEventListener("Buffer.Empty", previewBuffering);
						singleNetStream.addEventListener("Buffer.Full", previewBufferFull);
						singleNetStream.setBufferlength (2, 25);
					} else {
						singleNetStream = asset.mediaSource;
					}
					previewVideo.attachNetStream( singleNetStream );
					singleNetStream.playMedia();
					break;

				case MediaTypes.IMAGE:
				case MediaTypes.SOLID:
				case MediaTypes.SWF:
					singleImage.source = nsSource;
					singleImage.visible = true;
					break;

				default:
					playState = VideoStates.PAUSE;
					return;
			}
			playState = VideoStates.PREVIEW_ASSET;
			isPreviewing = true;
			if (!contains(previewContainer)) addChild(previewContainer);
			if (!contains(previewMsgContainer)) addChild(previewMsgContainer);
			if (asset.mediaType == MediaTypes.AUDIO) addSoundClipIcon ();
			PreviewMsgTimer.start ();
 */		}
		public function get previewAsset ():AbstractAsset
		{
			return _previewAsset;
		}

		/**
		 *show preview is buffering msg.
		 */
		 /*
		private function previewBuffering (e:Event):void
		{
			txtPreviewBufferingMessage.text = "Buffering...";
		}
		*/
		/**
		 *remove the preview buffering msg.
		 */
/*xxx		 
		private function previewBufferFull (e:Event):void
		{
			txtPreviewBufferingMessage.text = "";
		}
xxx*/
		/**
		* blinks the preview msg.
		*/
/*xxx
		private var lastA:Number = 1;
		private function previewAnimate (te:TimerEvent):void
		{
			previewMsgContainer.visible = Boolean(lastA);
			lastA = 1 - lastA;
		}
xxx*/

		/**
		 *stop preview mode.
		 */
		private function stopPreviewMode ():void
		{
/* 			if (isPreviewing)
			{
				isPreviewing = false;
				if (singleNetStream != null)
					singleNetStream.dispose();
				singleImage.source = null;
				previewVideo.attachNetStream(null);
				previewVideo.clear();
				PreviewMsgTimer.stop();
				if (contains(previewMsgContainer)) removeChild(previewMsgContainer);
				if (contains(previewContainer)) removeChild(previewContainer);
				previewVideo.visible = false;
				singleImage.visible = false;
				singleImage.scaleContent = true;
			}
 */		}

		/**
		 * adds a icon of a speaker for indication of previewing sound asset.
		 */
		public function addSoundClipIcon ():void
		{
/* 			singleImage.visible = true;
			singleImage.source = soundImageClass;
			singleImage.scaleContent = false;
 */		}

		/**
		 * enable or disable deblocking filtering & smoothing on the video.
		 * @param val		true for enable.
		 * @see flash.media.Video#deblocking
		 * @see flash.media.Video#smoothing
		 */
		public function set videoSmoothing (val:Boolean):void
		{
			if (val)
			{
				videoHolder.current.video.deblocking = 0;
				videoHolder.next.video.deblocking = 0;
			} else {
				videoHolder.current.video.deblocking = 1;
				videoHolder.next.video.deblocking = 1;
			}
			videoHolder.current.video.smoothing = val;
			videoHolder.next.video.smoothing = val;
		}


		/**
		 *create a debugging string that contains the contents of the requested elements.
		 * @param what2print		the element to print (currently only "ActiveArray" is available).
		 * @return 					a debug print string.
		 */
		public function printDebug (what2print:String):String
		{
			var retStr:String = "";
			switch (what2print)
			{
				case "ActiveArray":
					//retStr = ObjectUtil.toString (ActiveAssets2Play);
					var i:int = 0;
					for each (var k:AbstractAsset in activeAssetsToPlay)
					{
						retStr += "\n Idx: " + i++ + ") " + k.toString() + "\n";
					}
					break;
			}
			if (retStr == "") retStr = "EMPTY";
			return retStr;
		}

		/**
		 * capture an image of the current state of this player.
		 * @param encoder		the encoding to use (either JPENEncoder ot PNGEncoder).
		 * @return 				the image snapshot of the current player state.
		 * @see mx.graphics.codec.IImageEncoder
		 * @see mx.graphics.codec.JPEGEncoder
		 * @see mx.graphics.codec.PNGEncoder
		 */
/* 		public function getSnapshotImage (encoder:IImageEncoder = null, imageWidth:Number = 640, imageHeight:Number = 480, qScale:uint = 0):ByteArray
		{
			if (!encoder)
				encoder = new JPEGEncoder (qScale > 0 ? qScale : 85);
			var sx:Number = imageWidth / this.unscaledWidth;
			var sy:Number = imageHeight / this.unscaledHeight;
			var matrix:Matrix = new Matrix();
			matrix.scale(sx, sy);
			var data:BitmapData = new BitmapData (imageWidth, imageHeight, true, 0x00000000);
	        data.draw(this, matrix, null, null, null, true);
	        var pixels:ByteArray = data.getPixels(new Rectangle (0, 0, data.width, data.height));
	        pixels.position = 0;
			var bytes:ByteArray = encoder.encodeByteArray(pixels, imageWidth, imageHeight);
			return bytes;
		}
 */
        /**
         * Sets the background color of the background to BGColor
         * @param BGColor new BACKGROUND COLOR
         */
	    //xxx [Inspectable (category="Styles", defaultValue=0, format="Color", type="Color")]
	    //xxx [Bindable]
        public function set backgroundColor (background_color:uint):void
        {
        	//A reference tgo the graphics object of the background. only made for convenient of use.
        	_backgroundColor = background_color;
        	var g:Graphics = backgroundSprite.graphics;
        	g.clear();
        	g.beginFill(_backgroundColor, 1);
        	g.drawRect(0, 0, width, height);
        	g.endFill();
        }
        public function get backgroundColor ():uint
        {
        	return _backgroundColor;
        }

        /**
         * creates a mask over the component (this is just like using clipContent=true on a canvas, though here we have more control).
         */
        private function drawMask ():void
		{
			var g:Graphics = playerMask.graphics;
			g.clear();
			g.beginFill(0);
			g.drawRect(0, 0, compWidth, compHeight);
			g.endFill();
		}

		private var _currentEditedPluginUi:DisplayObject;
		/**
		 *use this to add dynamic ui on top of the player.
		 * usually used for plugin editing ui.
		 */
		//xxx [Inspectable]
		//xxx [Bindable]
		public function get currentEditedPluginUi ():DisplayObject
		{
			return _currentEditedPluginUi;
		}
		public function set currentEditedPluginUi (value:DisplayObject):void
		{
			_currentEditedPluginUi = value;
			if (_currentEditedPluginUi)
				addPlayerEditUI (_currentEditedPluginUi);
			else
				clearPlayerEditUI ();
		}

		/**
		 *adds an edit UI on the player (use to add plugins on-player UI).
		 * @param child		the UI to add.
		 */
		public function addPlayerEditUI (child:DisplayObject):void
		{
/* 			if (!playerAssetsContainer.contains(pluginUIContainer))
				playerAssetsContainer.addChild (pluginUIContainer);
			if (!pluginUIContainer.contains(child))
				pluginUIContainer.addChild(child);
 */		}

		/**
		 *clear the on-player edit UI.
		 */
		public function clearPlayerEditUI ():void
		{
/* 			var N:int = pluginUIContainer.numChildren;
			for (var i:int = 0; i < N; ++i)
			{
				pluginUIContainer.removeChildAt (i);
			}
			if (playerAssetsContainer.contains(pluginUIContainer))
				playerAssetsContainer.removeChild (pluginUIContainer);
 */		}

		/**
		 *present on player text message.
		 * @param error_message		the message to show.
		 */
		public function showErrorMessage (error_message:String = "This Asset isn't ready to play yet..."):void
		{
			//xxx txtErrorMessage.text = error_message;
			//xxx txtErrorMessage.visible = true;
		}

		/**
		 *hides the on-player text error message that is set by showErrorMessage.
		 * @see com.kaltura.components.players.eplayer.Eplayer#showErrorMessage
		 */
		public function hideErrorMsg ():void
		{
			//xxx txtErrorMessage.visible = false;
		}

		/**
		 * switch the current active audio "layer".
		 */
		private function switchAudioLayers():void
		{
			audioLayerOnTop = 1 - audioLayerOnTop;
		}

		/**
		 *adds a new asset to the active array of playing audio streams.
		 * @param stream		the stream to add.
		 * @param audio_layer	the layer to add this stream to.
		 *
		 */
		public function insertAudioStream (stream:ExNetStream, audio_layer:int):void
		{
			audioArray[audio_layer] = stream;
		}

		/**
		 *pause the stream on the specified audio layer.
		 * @param audio_layer		the layer holding the stream to pause.
		 */
		public function removeAudioStream (audio_layer:int):void
		{
			if (audioArray[audio_layer] != null)
				ExNetStream(audioArray[audio_layer]).pauseMedia();
		}

		/**
		 * play a segment of an audio stream on a specific layer.
		 * @param start		a second to play from.
		 * @param len		duration to play.
		 * @param layer		the layer holding the stream to be played.
		 */
		public function playPartOfAudioStream (start:Number, len:Number, layer:int):void
		{
			ExNetStream(audioArray[layer]).playPartOfStream(start);
		}

		/**
		 *sets the playback volume of the player.
		 * @param vol		a volume between 0 - 1.
		 */
		public function setOverAllVolume (vol:Number):void
		{
			if (!roughcut) // return in case we are not initialize 
				return;
				
			_overAllVolumeControl = vol;
			var N:int = activeAssetsToPlay.length;
			var k:AbstractAsset;
			if (roughcut.soundtrackAsset && roughcut.soundtrackAsset.mediaSource)
				setStreamSoundTransform (roughcut.soundtrackAsset.audioGraph.getVolumeAtTime(dTimeSec - roughcut.soundtrackAsset.seqStartPlayTime), roughcut.soundtrackAsset.audioBalance, roughcut.soundtrackAsset);
			if (roughcut.soundtrackVolumePlayPolicy != AudioPlayPolicy.CROSS_SOUNDTRACK_ONLY)
			{
				for (var i:int = 0; i < N; ++i)
				{
					k = AbstractAsset(activeAssetsToPlay.getItemAt(i));
					switch (k.mediaType)
					{
						case MediaTypes.VIDEO:
						case MediaTypes.VOICE:
						case MediaTypes.AUDIO:
						case MediaTypes.SWF:
							setStreamSoundTransform (k.audioGraph.getVolumeAtTime(dTimeSec - k.seqStartPlayTime), k.audioBalance, k);
							break;
					}
				}
			}
		}

		/**
		 *sets a sound transform of a given asset audio / video stream.
		 * @param vol		the volume to set.
		 * @param pan		the balance to set.
		 * @param asset		the asset holding the stream.
		 * @see com.kaltura.assets.abstracts.AbstractAsset
		 */
		public function setStreamSoundTransform (vol:Number, pan:Number, asset:AbstractAsset):void
		{
			var stream:ExNetStream = asset.mediaSource as ExNetStream;
			if (stream != null)
			{
				if (asset.mediaType == MediaTypes.AUDIO)
					stream.soundTransform = new SoundTransform(_overAllVolumeControl * audioVolume * vol, pan);
				else
					stream.soundTransform = new SoundTransform(_overAllVolumeControl * vol, pan);
			}
			if (asset.mediaType == MediaTypes.SWF) {
				SWFLoaderMediaSource(asset.mediaSource).soundTransform = new SoundTransform (_overAllVolumeControl * vol, pan);
			}
		}

		/**
		 *set a video stream to a specific layer.
		 * @param stream		the stream to add.
		 * @param current		true for current layer, false for next.
		 * @see com.kaltura.plugin.layer.VSPair#stream
		 */
		public function insertVideoStream(stream:ExNetStream, current:Boolean = false):void
		{
			if (!current)
			{
				videoHolder.next.stream = stream;
			} else {
				videoHolder.current.stream = stream;
			}
		}

		/**
		 *set a video stream to a specific layer, and set its dimentions according to its asset.
		 * When using dual progressive download this is the last place in the chain where the original entry dimensions are available,
		 * so we must set dimensions here.
		 * @param stream		the stream to add.
		 * @param current		true for current layer, false for next.
		 * @param vidwidth		the original video width.
		 * @param vidheight		the original video height.
		 * @see com.kaltura.plugin.layer.VSPair#stream
		 */
		public function insertVideoStreamSet(stream:ExNetStream, current:Boolean = false, vidwidth:Number = 640, vidheight:Number = 480):void
		{
			stream.streamVideo.width = vidwidth;
			stream.streamVideo.height = vidheight;
			if (!current)
			{
				videoHolder.next.stream = stream;
			} else {
				videoHolder.current.stream = stream;
			}
		}

		/**
		 *clears the current layer from video image data.
		 */
		public function removeSingleVideo ():void
		{
			videoHolder.current.clearVideo();
		}

		/**
		 *swap current active video layer.
		 */
		private function switchVideoLayers():void
		{
			videoHolder.switchChildren ();
			
		}

		/**
		 *clears both layers of video.
		 */
		public function clearVideos ():void
		{
			videoHolder.current.clearVideo();
			videoHolder.next.clearVideo();
		}

		 private var _singleVideoAsset:AbstractAsset;
		/**
		 * set a single stream to be played, this is a binding wrapper for setSingleVideo method.
		 * if the given asset is not of media type <code>MediaTypes.AUDIO</code> or <code>MediaTypes.VIDEO</code>
		 * the singleVideoAsset will be set to null.
		 */
		//xxx [Inspectable]
		//xxx [Bindable]
		public function set singleVideoAsset (asset:AbstractAsset):void
		{
			if (_singleVideoAsset == asset)
				return;

			resetPlayer();
			if (asset && asset.mediaType & (MediaTypes.AUDIO | MediaTypes.VIDEO))
			{
//				videoHolder.current.dontRenderOnSet = (asset.mediaType != MediaTypes.VIDEO);
				setSingleVideo (asset.mediaSource);
				if (asset.mediaType == MediaTypes.AUDIO) addSoundClipIcon ();
				_singleVideoAsset = asset;
			} else {
				_singleVideoAsset = null;
			}
		}
		public function get singleVideoAsset ():AbstractAsset
		{
			return _singleVideoAsset;
		}

		/**
		 *sets a single video to process, this is used to show a single video stream without a roughcut.
		 * @param stream	the video stream to add.
		 */
		public function setSingleVideo (stream:ExNetStream):void
		{
			if (videoHolder.current.stream != stream)
			{
				videoHolder.resetProperties ();								// b4 inserting make sure the layers are rested to default
				//stream.removeEventListener (ExNetStreamEvent.FIXED_SEEK_TIME_TO_KEYFRAME, fixPlayheadToKeyframeTime);
				insertVideoStream (stream, true);							// attach the stream to a displaylist layer
			}
		}

		/**
		 *sets the volume for the currently playing single video / audio stream.
		 * @param volume	the new volume to set, a number 0 - 1.
		 * @param balance	the new balance to set, a number (R)-1 - (Middle)0 - (L)1.
		 */
		public function setSingleVideoVolume (volume:Number, balance:Number = 0):void
		{
			if (videoHolder.current.stream)
			{
				videoHolder.current.stream.soundTransform = new SoundTransform(volume, balance);
			}
		}

		/**
		 * seek on the stream added using the setSingleVideo function.
		 * @param seek_time						the time in seconds to seek on the stream.
		 * @param original_start_offset			if the stream was loaded using clipper service, pass it's cut start offset from original video stream.
		 * @param nearest_next					preform the seek to the nearest next keyframe or the nearest previous keyframe.
		 * @see com.kaltura.net.streaming.ExNetStream#seekMedia
		 */
		public function seekOnSingleVideoAsset (seek_time:Number, original_start_offset:Number, nearest_next:Boolean = false):void
		{
			pauseSingleVideo ();
			if (videoHolder.current.stream != null)
			{
				singleStreamTime = seek_time;
				if (_singleVideoAsset.mediaType == MediaTypes.VIDEO)
				{
					videoHolder.current.stream.seekMedia (seek_time, original_start_offset, nearest_next);
					//videoHolder.renderVideo(true);
				}
				dispatchEvent(new PlayerEvent (PlayerEvent.SINGLE_VIDEO_UPDATE_PLAYHEAD, seek_time, -1));
			}
		}

		/**
		 * play the current single video.
		 */
		public function playSingleVideo ():void
		{
			if (videoHolder.current.stream != null)
			{
				videoHolder.current.stream.playMedia();
				videoHolder.current.stream.addEventListener(ExNetStreamEvent.ON_STREAM_END, onSingleStreamEnd);
				singleStreamSynchTimer.addEventListener(TimerEvent.TIMER, synchSingleVideoPlayhead);
				singleStreamSynchTimer.start();
			}
		}

		/**
		 * when the single stream finish playing dispatch a notice.
		 */
		public function onSingleStreamEnd (event:ExNetStreamEvent):void
		{
			pauseSingleVideo();
			removeEventListener(ExNetStreamEvent.ON_STREAM_END, onSingleStreamEnd);
			dispatchEvent(new PlayerEvent (PlayerEvent.SINGLE_VIDEO_PLAY_END, singleStreamTime, -1));
		}

		/**
		 * synchronize the playhead of the currently playing single stream (on preview or trimming mode).
		 */
		private function synchSingleVideoPlayhead (event:TimerEvent):void
		{
			/* if (_singleVideoAsset.mediaType == MediaTypes.VIDEO)
				videoHolder.renderVideo(); */
			singleStreamTime = videoHolder.current.stream.time;
			dispatchEvent(new PlayerEvent (PlayerEvent.SINGLE_VIDEO_UPDATE_PLAYHEAD, singleStreamTime, -1));
		}

		/**
		 * pause the playing current single stream.
		 */
		public function pauseSingleVideo ():void
		{
			singleStreamSynchTimer.removeEventListener(TimerEvent.TIMER, synchSingleVideoPlayhead);
			/* if (!_singleVideoAsset || (_singleVideoAsset && _singleVideoAsset.mediaType == MediaTypes.VIDEO))
				videoHolder.renderVideo(true); */
			singleStreamSynchTimer.stop();
			if (videoHolder.current.stream != null)
			{
				videoHolder.current.stream.pauseMedia();
			}
		}

		/**
		 * seeks a stream, then dispatches an event to fix the playhead in case that the seek was not precise (on a keyframe)
		 * @param stream					the stream to seek on
		 * @param time2seek					the time to seek to
		 * @param originalStartOffset		the start offset of the clipped stream on the original stream
		 *
		 */
		public function seekExNetStream (stream:ExNetStream, time2seek:Number, originalStartOffset:Number, nearestNext:Boolean = false, delayRender:Boolean = false, dispatchFixEvent:Boolean = true):void
		{
			preformFixSeek = dispatchFixEvent;
			//stream.addEventListener(ExNetStreamEvent.FIXED_SEEK_TIME_TO_KEYFRAME, fixPlayheadToKeyframeTime, false, 0, true);
			delayVideoHolderRender = delayRender;
			stream.addEventListener(ExNetStreamEvent.INVALID_SEEK_TIME, onInvalidSeekTime );
			stream.seekMedia (time2seek, originalStartOffset, nearestNext);
		}
		
		private function onInvalidSeekTime (e : ExNetStreamEvent) : void
		{
			wasSeekInvalid = true;
		}

		//private var jj:uint = 0;
		/**
		 * fix the seek done using seekExNetStream function.
		 */
		private function fixPlayheadToKeyframeTime (e:ExNetStreamEvent):void
		{
			if ( preformFixSeek )
			{
				//trace ((++jj).toString() + ":: " + ExNetStreamEvent.FIXED_SEEK_TIME2KEYFRAME);
				var deltaSeek:Number = e.originalSeekTime - e.playHeadTime;						//this is the dealta from the original seek request
																								//to the actual keyframed seeked
				dTimeSec -= deltaSeek;															//fix the dTimeSec (fix the sequence to the right time)
				dispatchUpdatePlayhead ();
				e.target.removeEventListener (ExNetStreamEvent.FIXED_SEEK_TIME_TO_KEYFRAME, fixPlayheadToKeyframeTime);
			}
			//videoHolder.renderVideo();
			/* if (delayVideoHolderRender)
			{
				clearID = setTimeout(renderVideoDelayed, 80);
				delayVideoHolderRender = false;
			} */
		}

		/**
		 * clears the timeout set by fixSeek operation.
		 */
		public function renderVideoDelayed ():void
		{
			/* try { clearTimeout(clearFixSeekTimeout); } catch (e:Error) {}
			videoHolder.renderVideo(); */
		}

		/**
		 *set an image bitmapData to a specific layer.
		 * @param bd_image		the bitmapData of the image to add.
		 * @param current		true for current layer, false for next.
		 * @see com.kaltura.plugin.layer.VSPair#imageBD
		 */
		public function insertSingleImage (bd_image:BitmapData, current:Boolean = false):void
		{
			try
			{
				trace("in insert image");
				
				var bd:BitmapData = bd_image.clone();			//Check if it's a valid bitmapData
				if (current == true && bd != null)
				{
					videoHolder.current.imageBD = bd;
				} else {
					videoHolder.next.imageBD = bd;
				}
			} catch (e:Error) {}								//if not, ignore silently
		}

		/**
		 *clears the next layer from image data.
		 */
		public function removeSingleImage ():void
		{
			videoHolder.next.imageBD = null;
		}

		/**
		 * reset the player.
		 * @param pause			should call preSequence before next play ?
		 * @param forceReset	should we reset effects on the playerAssetsContainer too ?
		 */
		public function resetPlayer(pause:Boolean = false, forceReset:Boolean = false):void
		{
			if (roughcut && roughcut.soundtrackAsset && roughcut.soundtrackAsset.mediaSource)
				roughcut.soundtrackAsset.mediaSource.pauseMedia();

			for (var item:Object in delayedInserts)
			{
				item.dispose ();
				delete delayedInserts[item];
			}

			pauseSingleVideo ();

			stopPreviewMode ();

			hideErrorMsg ();

			var N:int = activeAssetsToPlay.length - 1;
			var k:AbstractAsset;
			for (var j:int = N; j >= 0; --j)
			{
				k = activeAssetsToPlay.getItemAt(j) as AbstractAsset;
				if (k.mediaSource is Plugin)
					k.mediaSource.detach(compWidth, compHeight, nXcurrent, nYcurrent);
			}

			playerAssetsContainer.filters = null;

			//if the following streams are playing, stop them
			if (audioArray[1] != null) ExNetStream(audioArray[1]).pauseMedia();
			if (audioArray[0] != null) ExNetStream(audioArray[0]).pauseMedia();

			videoHolder.resetProperties ();
			overlaysHolder.resetProperties ();

			videoHolder.resetLayers ();
			overlaysHolder.resetLayers ();

			if (currentTransition != null) currentTransition.detach(compWidth, compHeight, nXcurrent, nYcurrent);
			currentTransition = null;

			//Resets the sequence (returns to the beginning of the sequence)
			activeAssetsToPlay = new ArrayCollection ();
			lastAddedAssetIdx = 0;
			currentAudioLayer = 0;
			audioLayerOnTop = 0;
			// If we are in play mode, don't reset the TimelineAssets array, so preSequence won't be needed again.
			if (pause == false) timelineAssets = new ArrayCollection ();
			currentImage = null;

			isFirstAssetToAdd = true;

			clearVideos();
		}

		/**
		 *before playing, seeking or resuming, make sure the roughcut is not dirty and if it is, rebuild it.
		 * @return 		true if rebuild was preformed.
		 */
		private function preSequencePlay ():Boolean
		{
//			videoHolder.current.dontRenderOnSet = true;
//			videoHolder.next.dontRenderOnSet = true;

			if (_roughcut && _roughcut.roughcutTimelines)
			{
				var wasDirty:Boolean = roughcut.dirty;
				if (roughcut.dirty)
				{
					_roughcut.buildRoughcutAssets ();
					roughcut.dirty = false;
				}
				timelineAssets = _roughcut.roughcutTimelines.roughtcutAssets;
				roughcutDuration = _roughcut.roughcutDuration;
				return wasDirty;
			} else {
				timelineAssets = null;
				roughcutDuration = 0;
				return false;
			}
		}

		/**
		 *pause the playing roughcut on current time.
		 * @param stop_state			set stop state after pausing.
		 * @param dispatch_pause		if true dispatchs a ROUGHCUT_PAUSE event.
		 * @param fix_seek				preform fixSeek on current pause time.
		 * @see com.kaltura.components.players.events.PlayerEvent#ROUGHCUT_PAUSE
		 */
		public function pauseSequence(stop_state:Boolean = false, dispatch_pause:Boolean = true, fix_seek:Boolean = false):void
		{
			//traceAction ("pause");
			if (stop_state == true)
				changeState ( VideoStates.STOP );

			stopInternalTimer();

			pauseMediaSources ();


			if (fix_seek)
				seekSequence(-1, isPreviewMode, true);

			if (!stop_state)
				dispatchPauseEvent (dispatch_pause);
		}

		/**
		 * pause the current playing assets.
		 */
		private function pauseMediaSources ():void
		{
			if (videoHolder.next.stream != null) videoHolder.next.stream.pauseMedia();
			if (videoHolder.current.stream != null) videoHolder.current.stream.pauseMedia();
			if (audioArray[1] != null) ExNetStream(audioArray[1]).pauseMedia();
			if (audioArray[0] != null) ExNetStream(audioArray[0]).pauseMedia();
			if (roughcut && roughcut.soundtrackAsset && roughcut.soundtrackAsset.mediaSource) ExNetStream(roughcut.soundtrackAsset.mediaSource).pauseMedia();
			var N:int = activeAssetsToPlay.length;
			var mediaSource:IMediaSource;
			var asset:AbstractAsset;
			for (var i:int = 0; i < N; ++i)
			{
				asset = activeAssetsToPlay.getItemAt(i) as AbstractAsset;
				if (asset)
				{
					mediaSource = asset.mediaSource as IMediaSource;
					if (mediaSource)
						mediaSource.pauseMedia();
				}
			}
		}

		/**
		 *dispatchs a ROUGHCUT_PAUSE event.
		 * @param do_dispatch		true to preform the dispatch.
		 * @see com.kaltura.components.players.events.PlayerEvent#ROUGHCUT_PAUSE
		 */
		private function dispatchPauseEvent (do_dispatch:Boolean = true):void
		{
			if (do_dispatch)
			{
				dispatchEvent (new PlayerEvent (PlayerEvent.ROUGHCUT_PAUSE, dTimeSec));
				changeState ( VideoStates.PAUSE );
			}
		}

		/**
		 * adjust start time relative to a given seek time, use this to fix playhead time without preforming an actual seekSequence.
		 * @param cTime		the time in seconds to move playhead to.
		 */
		public function adjustTime (cTime:Number):void
		{
			lastTimeStamp = my_getTimer();
			seqPlayStartTime = lastTimeStamp - cTime * 1000; // adjust start time relative to the given seek time
			dTimeSec = cTime;
		}

		/**
		 *plays a given asset time in the roughcut sequence.
		 * @param timeline		the timeline of the asset.
		 * @param asset_index	the index of the asset to play.
		 */
		public function playSingleAsset (timeline:uint, asset_index:uint):void
		{
			preSequencePlay();
			var asset:AbstractAsset = roughcut.getAssetAt(timeline, asset_index);
			pauseSequence();
			seekSequence(asset.seqStartPlayTime, false, false);
			resumePlaySequence(asset.seqEndPlayTime);
		}

		/**
		 *resume play of current roughcut at the time of the playhead.
		 * @param stop_time				stop when playhead reaches this sequence time (in seconds).
		 * @param is_preview_mode		true if we play in asset preview mode (ie transition).
		 */
		public function resumePlaySequence(stop_time:Number = -1, is_preview_mode:Boolean = false):void
		{
			//traceAction ("resume");
//			videoHolder.current.dontRenderOnSet = true;
//			videoHolder.next.dontRenderOnSet = true;
			if (preSequencePlay())
			{
				//roughcut was dirty...
			}

			// preview mode
			if ( ! is_preview_mode) {
				if (dTimeSec >= roughcutDuration || dTimeSec <= 0)
				{
					playSequence(is_preview_mode);
					return;
				}
			} else {
				// preview plugin mode
				if (dTimeSec >= 3.99)
				{
					playSequence(is_preview_mode);
					return;
				}
			}

			if ( ! is_preview_mode)
			{
				isPreviewMode = false;
				currentPlayingAssets = timelineAssets;
			} else {
				isPreviewMode = true;
				//xxx currentPlayingAssets = transitionPreviewArray;
			}
			if (currentPlayingAssets)
			{
				sequenceAssetsLength = currentPlayingAssets.length;								// number of assets in the sequence
			} else {
				// roughcut is invalid
				return;
			}
			playSingleSegmentStopTime = stop_time;

			/* var now:uint = my_getTimer ();				//get the "now" - current time stamp
			var delta:uint = now - lastTimeStamp;		//the time passed since we paused
			seqPlayStartTime += delta;					//fix the start time
			if (nowBuffering)
				seqPlayStartTime = now - (dTimeSecBeforeBuffering * 1000);
			lastTimeStamp = now;						//fix the last time we stampped time (which is now)
			if (nowBuffering)							//if we're on buffering mode, do fix the relative time so we can seek
				dTimeSec = (lastTimeStamp - seqPlayStartTime) / 1000; */
			adjustTime (dTimeSec);
			changeState (VideoStates.PLAY);

			if (currentAsset && currentAsset.mediaType & (MediaTypes.VIDEO | MediaTypes.SWF))
			{
				setSoundtrackVolume (true);				// set the soundtrack volume to be as soundtrackVolumePolicy decide
			} else {
				setSoundtrackVolume (false);			// set the soundtrack volume to be as soundtrackVolumePolicy decide
			}
			resumeExNetStreamLayers ();
			playSoundtrackAsset ();
			startInternalTimer();
		}

		/**
		 *resume play of current playing streams.
		 */
		private function resumeExNetStreamLayers ():void
		{
			var asset:AbstractAsset;
			if (!activeAssetsToPlay)
				return;
			var N:int = activeAssetsToPlay.length;
			for (var i:int = 0; i < N; ++i)
			{
				asset = activeAssetsToPlay.getItemAt(i) as AbstractAsset;
				if (asset && (asset.mediaType & (MediaTypes.VIDEO | MediaTypes.AUDIO | MediaTypes.VOICE)))
				{
					if (asset.mediaSource != null && asset.mediaSource is ExNetStream)
					{
						if (roughcut.soundtrackVolumePlayPolicy == AudioPlayPolicy.CROSS_SOUNDTRACK_ONLY)
							setStreamSoundTransform (0, 0, asset);
						if ((nowBuffering && preformedSeekBeforeBuffer) || _playState != VideoStates.PLAY)
							seekExNetStream (asset.mediaSource, seekStreamInSequence (asset), asset.clipedStreamStart, false, false, false);
						ExNetStream(asset.mediaSource).playMedia();
					}
				} else {
					if (asset)
						//this is done on resume only, so there's no preformance issue with this,
						//we have to use try/catch here to overcome binding errors.
						if (asset.mediaSource)
						{
							try{
								asset.mediaSource.playMedia();
							}catch (e:Error){}
						}
				}
			}
			playSoundtrackAsset ();
		}

		/**
		 *use to rebuild the roughcut and reset the display accordingly.
		 * @param event		can be used for binding.
		 */
		public function refreshCurrentDisplay (event:Object = null):void
		{
			var lastSeek:Number = dTimeSec;
			resetPlayer ();
			if (_roughcut && _roughcut.roughcutTimelines)
			{
				_roughcut.buildRoughcutAssets ();
				roughcut.dirty = false;
				dTimeSec = lastSeek;
				seekSequence();
			} else {
				//videoHolder.renderVideo(true);
			}
		}

		private var lastActinoTrace:uint;
		private function traceAction (action:String):void
		{
			var diff:uint = getTimer() - lastActinoTrace;
			if (diff > 4000)
				trace ("Zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
			lastActinoTrace = getTimer();
			trace (lastActinoTrace, action);
		}

		/**
		 *seek the playhead to a specified position in roughcut and render the new image.
		 * @param time_to_seek			the time in seconds to seek to.
		 * @param is_preview_mode		true if currently seeking in preview mode.
		 * @param preform_seek_fix		true if should fix this seek operation.
		 * @param from_fix				indicates the function caller was the fix seek timer, don't set this directly.
		 */
		public function seekSequence (time_to_seek:Number = -1, is_preview_mode:Boolean = false, preform_seek_fix:Boolean = false, from_fix:Boolean = false):void
		{
			//traceAction ("seek");
//			videoHolder.current.dontRenderOnSet = true;
//			videoHolder.next.dontRenderOnSet = true;

			if (!roughcut)
				return;

			preSequencePlay();

			var doReSeekToFixVideo:Boolean = false;

			if (isPreviewing)
				stopPreviewMode ();

			if ( ! is_preview_mode )
			{
				isPreviewMode = false;
				currentPlayingAssets = timelineAssets;
			} else {
				isPreviewMode = true;
				//xxx currentPlayingAssets = transitionPreviewArray;
			}

			if (currentPlayingAssets)
			{
				sequenceAssetsLength = currentPlayingAssets.length;								// number of assets in the sequence
			} else {
				// roughcut is invalid
				return;
			}

			if (time_to_seek == -1)
				time_to_seek = dTimeSec;

			time_to_seek = ((time_to_seek * 1000)>>>0)/1000;

			pauseSequence (false, false, false);

			cancelBufferingMode();

			//dTimeBeforeInvalidSeek = dTimeSec;
			//lastTimeStamp = my_getTimer();
			//seqPlayStartTime = lastTimeStamp - uint((time_to_seek * 1000) >> 0); // adjust start time relative to the given seek time
			//dTimeSec = time_to_seek;
			dTimeBeforeInvalidSeek = dTimeSec;
			preformedSeekBeforeBuffer = true;
			adjustTime (time_to_seek);

			//set seek position for buffering state:
			if (!from_fix)
				dTimeSecBeforeBuffering = dTimeSec;

			//trace (dTimeSec);
			//DEBUGGING TIME:
			debugLastTimeStamp = lastTimeStamp;
			debugStartTime = seqPlayStartTime;
			debugTime2Seek = (dTimeSec * 1000) >> 0;
			debugdTimeSec = dTimeSec;

/* 			if (dTimeSec > sequenceLength || dTimeSec < 0)
				throw (ArgumentError("dTimeSec is invalid: " + dTimeSec.toString())); */
			//trace ("time_to_seek ", time_to_seek);

			// populate temporary array with active assets at the given seek time
			var SeqLen:int = timelineAssets.length;

			var tempAssets2Play:ArrayCollection = new ArrayCollection ();
			var asset:AbstractAsset;
			for (var i:int = 0; i < SeqLen; ++i)
			{
				asset = AbstractAsset (timelineAssets.getItemAt(i));
				if (asset.seqStartPlayTime <= dTimeSec)
				{
					if (asset.seqEndPlayTime > dTimeSec)
						tempAssets2Play.addItem (asset);
				}
				else
					break;
			}

			// check if the temporary array is different than last played array, if so reset player
			var tempSeqLen:int = tempAssets2Play.length;
			var activeSeqLen:int = activeAssetsToPlay.length;
			var shouldReset:Boolean = false;
			var a:AbstractAsset;
			var b:AbstractAsset;
			if (tempSeqLen > 0 && tempSeqLen == activeSeqLen)
			{
				for (i = 0; i < tempSeqLen; ++i)
				{
					a = tempAssets2Play.getItemAt(i) as AbstractAsset;
					b = activeAssetsToPlay.getItemAt(i) as AbstractAsset;
					if (a != b)
					{
						shouldReset = true;
						break;
					}
				}
			}
			else {
				shouldReset = true;
			}

			if (shouldReset || seekingCurrent)
			{
				if (seekingCurrent)
				{
					seekingCurrent = false;
					pauseAfterSeek = true;
					resetPlayer ();
					preSequencePlay();
					seekSequence(dTimeSec);
				} else {
					isPreviewMode = false;
					resetPlayer (true);
					pauseAfterSeek = true;
					sequenceSynch (null);
					doReSeekToFixVideo = preform_seek_fix;
				}
			} 
				var seekVal:Number;
				// assets array didnt change, so we just need to seek each asset to the given seek time
				for (i = 0; i < activeSeqLen; ++i)
				{
					asset = AbstractAsset (activeAssetsToPlay.getItemAt(i));
					
					if(asset)
					{
						switch (asset.mediaType)
						{
							case MediaTypes.VIDEO:
								if (asset.mediaSource != null)
								{
									if (videoHolder.current.stream == asset.mediaSource) //only if it's the current layer dispatch the fix seek
									{
										seekExNetStream (asset.mediaSource, seekStreamInSequence (asset), asset.clipedStreamStart, false, true, preform_seek_fix);
										
									} else {
										seekExNetStream (asset.mediaSource, seekStreamInSequence (asset), asset.clipedStreamStart, false, false, preform_seek_fix);
									}
									doReSeekToFixVideo = true;
								}
								break;
	
							case MediaTypes.IMAGE:
								if (currentImage != asset.mediaSource)
								{
									insertSingleImage (asset.mediaSource as BitmapData);
									currentImage = asset.mediaSource as BitmapData;
								}
								break;
	
							case MediaTypes.SOLID:
								if (currentImage == null)
								{
									insertSingleImage (asset.mediaSource as BitmapData);
									currentImage = asset.mediaSource as BitmapData;
								}
								break;
	
							case MediaTypes.TRANSITION:
								seekVal = (dTimeSec - asset.seqStartPlayTime) / asset.transitionLength;
								if (seekVal < 0) seekVal = 0;
								if (asset.mediaSource != null)
									KTransition(asset.mediaSource).seekMedia (seekVal);
								break;
	
							case MediaTypes.SWF:
								seekVal = (dTimeSec - asset.seqStartPlayTime) / asset.transitionLength;
								if (seekVal < 0) seekVal = 0;
								if (asset.mediaSource != null)
									SWFLoaderMediaSource(asset.mediaSource).seekMedia (seekVal);
								break;
	
							case MediaTypes.OVERLAY:
							case MediaTypes.EFFECT:
								seekVal = (dTimeSec - asset.seqStartPlayTime) / asset.length;
								if (seekVal < 0) seekVal = 0;
								if (asset.mediaSource != null)
									(asset.mediaSource as Plugin).seekMedia (seekVal, dTimeSec - asset.seqStartPlayTime);
								break;
	
							case MediaTypes.AUDIO:
								if (asset.mediaSource != null)
								{
									seekExNetStream (asset.mediaSource, seekStreamInSequence (asset), asset.clipedStreamStart, false, true, false);
								}
								break;
						}
					}
				}
			

			/* if (!from_fix && ((seekFixCounter < seekFixMaxTryouts && doReSeekToFixVideo) || preform_seek_fix))
			{
				++seekFixCounter;
				clearTimeout (lastSeekFix);
				lastSeekFix = setTimeout(seekSequence, 30, -1, false, false, true);
				videoHolder.renderVideo();
			} else {
				preformFixSeek = false;
				seekFixCounter = 0;
				if (preform_seek_fix)
					dispatchUpdatePlayhead ();
			} */
			if (preform_seek_fix)
				dispatchUpdatePlayhead ();

			pauseSequence (false, true, false);
			pauseAfterSeek = false;
			
			if (wasSeekInvalid)
			{
				wasSeekInvalid=false;
				seekSequence(dTimeBeforeInvalidSeek);
			}
		}

		private function countRoughcutVisualAssets ():int
		{
			var visualAssetsNumber:int = 0;
			var visualAssets:ArrayCollection = roughcut.roughcutTimelines.videoAssets;
			var N:int = visualAssets.length;
			var asset:AbstractAsset;
			for (var i:int = 0; i < N; ++i)
			{
				asset = visualAssets.getItemAt(i) as AbstractAsset;
				if (asset.mediaType & (MediaTypes.VIDEO | MediaTypes.IMAGE | MediaTypes.SOLID | MediaTypes.SWF))
				{
					++visualAssetsNumber;
				}
			}
			return visualAssetsNumber;
		}

		/**
		 *play the roughcut (or preview).
		 * @param is_preview_mode		true for playing in preview mode (ie transition preview).
		 * @param stop_time				play untill playhead reachs this time (in seconds).
		 */
		public function playSequence (is_preview_mode:Boolean = false, stop_time:Number = -1):void
		{
			//traceAction ("pause");
//			videoHolder.current.dontRenderOnSet = true;
//			videoHolder.next.dontRenderOnSet = true;

			pauseAfterSeek = false;
			pauseSequence (false, false, false);
			resetPlayer ();
			preSequencePlay ();

			if ( ! is_preview_mode)
			{
				isPreviewMode = false;
				currentPlayingAssets = timelineAssets;
			} else {
				isPreviewMode = true;
				//xxx currentPlayingAssets = transitionPreviewArray;
			}

			//seekSequence(0);

			//setTimeout(delayPlay, 500, stop_time);
			delayPlay (stop_time);
		}

		private function delayPlay (stop_time:Number):void
		{
			if (!currentPlayingAssets || !roughcut)
				return;
			dTimeSec = 0;
			currentAsset = null;
			sequenceAssetsLength = currentPlayingAssets.length;								// number of assets in the sequence
			sequenceVisualAssetsLength = countRoughcutVisualAssets ();						// number of visual assets in the sequence

			playSingleSegmentStopTime = stop_time;
			lastTimeStamp = seqPlayStartTime = my_getTimer();
			startInternalTimer ();
			playSoundtrackAsset ();
			changeState ( VideoStates.PLAY );
		}

		/// =======================================================================================================================================
		/// Sequence Synchronization Here is where the Magic is done... :-)
		// some of the following variables are defined here just to avoid redefinition every timer tick.
		/**
		* the length of the visual sequence	(# of all visual assets in sequence).
		*/
		private var sequenceVisualAssetsLength:int;
		/**
		* the last added index, so we start from it the next cycle.
		*/
		private var lastAddedAssetIdx:int = 0;
		/**
		* the time that passed since the last cycle.
		*/
		private var dTimeSec:Number = 0;
		/**
		* last cycle time.
		*/
		private var lastTimeStamp:uint = 0;
		/**
		* the next audio will be inserted to this layer.
		*/
		private var currentAudioLayer:int = 0;
		/**
		* To check if the current image should be readded in case it was still loading when added.
		*/
		private var currentImage:BitmapData = null;
		/**
		* the currently applied transition.
		*/
		private var currentTransition:KTransition = null;
		/**
		* the array to play (to concider previews).
		*/
		private var currentPlayingAssets:ArrayCollection;
		/**
		* true if playing in preview mode (ie previewing transition).
		*/
		private var isPreviewMode:Boolean = false;
		/**
		* we are adding the first visual asset to display-list.
		*/
		private var isFirstAssetToAdd:Boolean = true;
		/**
		* there was a change in the sequence.
		*/
		private var activeAssetsChanged:Boolean = false;
		/**
		* the length of the sequence	(# of all assets in sequence).
		*/
		private var sequenceAssetsLength:int = timelineAssets.length;
		/**
		* the length of the active array (# of now playing assets).
		*/
		private var activeAssetsLength:int = activeAssetsToPlay.length - 1;
		/**
		* the time to seek to.
		*/
		private var seekVal:Number;
		/**
		* currently selected visual asset.
		*/
		//xxx [Inspectable]
		//xxx [Bindable]
		public var currentAsset:AbstractAsset = null;
		/**
		* used to determine to which layer to insert the audio.
		*/
		private var newAudioLayer:int = 0;
		/**
		* run synch untill you reach the end time of the single asset.
		*/
		private var singleSegmentPause:Boolean;
		/**
		* was a change (insert or remove) in the displaylist.
		*/
		private var activeAssetChange:Boolean = false;
		/**
		* there was a change in the thumbnails (audio or displaylist).
		*/
		private var thumbnailChange:Boolean = false;
		/**
		* only update playhead every 500ms.
		*/
		private var lastDispachedUpdatePlayHead:uint;
		/**
		 * the time in seconds the buffer should check ahead
		 */
		private var bufferTime:int = 2;
		/**
		 * last buffering time that was checked
		 */
		private var lastBufferingTime:uint = 0;
		/**
		 * did we overrun the buffer ? should we increase it ?
		 */
		private var wasBufferUnderrun:Boolean = false;
		/**
		 * if we get in to buffering mode, save the time we paused and continue from that timestamp when buffer is full again.
		 */
		private var dTimeSecBeforeBuffering:Number = 0;
		/**
		 * when inserting assets that are not yet loaded, push
		 */
		private var delayedInserts:Dictionary = new Dictionary (false);
		/**
		 *in order to prevent frames of next video/image to pop before the current added one, we delay the next insert to next iteration.
		 */
		private var insertNextAsset:Boolean = false;
		/**
		 * Synchronizes the sequence, each cycle happens approx. every 40ms.
		 * Synchronizing model:
		 * 		1) Insert First Asset => Current Layer
		 * 		2) Insert Second Asset => Next Layer
		 * 		3) Play First Asset
		 * 		*) Wait for current to finish play
		 * 			{
		 * 				1)	Play Next Asset
		 * 				2)	Switch Layers		(Next becomes Current)
		 * 				3)	Insert n'th Asset => Next
		 * 			}
		 */
		private var olddTimeSec:uint = 986;
		private var preformedSeekBeforeBuffer:Boolean = false;
		private function sequenceSynch (tEvent:Event):void
		{
			if (!roughcut)
			{
				pauseSequence (true, false, false);					// stop the sequence
				resetPlayer();
				return;
			}
			
			var i:int;
			var asset:AbstractAsset;
			activeAssetChange = false;														// there was a change in the display-list
			activeAssetsChanged = false;													// there was a change in the sequence (includes plugins and other non-visual assets)
			activeAssetsLength = activeAssetsToPlay.length - 1;								// number of currently playing assets

			if (tEvent != null)
			{
				// Synchronize time:
				lastTimeStamp = my_getTimer(); 									// get system time from the application start
				if ( !monitorBuffer || (monitorBuffer && !nowBuffering) )
				{
					dTimeSec = (lastTimeStamp - seqPlayStartTime) / 1000;			// calculate real-time passed since last synch cycle
				}
				if (dTimeSec > roughcutDuration)									//in case the timer missed and we got an invalid time, fix it.
					dTimeSec = roughcutDuration;
			}

			if (sequenceAssetsLength == 0) 												//There's nothing to play:
			{
				callSequenceEnd ();
				return;
			}

			// buffer control:
			if (monitorBuffer)
			{
				//check the roughcut only if we are buffering OR our play time is after the last buffered time
				/* var bufferFull:Boolean = (!nowBuffering && dTimeSec < bufferedTimeBeforeBuffering) ||
					roughcut.bufferMonitor.checkBufferTime ((dTimeSec >>> 0), bufferTime); */	//Check buffer time
				var check:uint = ((dTimeSec >>> 0) + bufferTime);
				var intDuration:uint = roughcutDuration >>> 0;
				var dTimeAndbuffer:uint = Math.min(check, intDuration);
				var bufferFull:Boolean = (!nowBuffering && dTimeSec < roughcut.bufferMonitor.bufferedTime) ||
											dTimeAndbuffer <= roughcut.bufferMonitor.bufferedTime;

				/* if (tEvent && olddTimeSec != ((getTimer() / 100) >>>0))
				{
					trace (getTimer(), dTimeAndbuffer, bufferFull, roughcut.bufferMonitor.bufferedTime, dTimeSec, bufferTime);
					olddTimeSec = (getTimer() / 100) >>>0;
				}  */

				if ( ! bufferFull )														//Buffer underrun
				{
					if (!nowBuffering)
					{
						//we are now in buffering mode
						if (tEvent)
						{
							// if this is the start of the clip or the user caused a seek event dont increase the requested buffer time
							if (dTimeSec>>>0 != 0)
								bufferTime = 5;
							dTimeSecBeforeBuffering = dTimeSec;
							startBufferingClockTime = my_getTimer();
						}
						pauseMediaSources ();
						wasBufferUnderrun = true;
						setBufferingMode();

					}
					/* if (!tEvent)
					{
						//if we got here while seeking (not playing):
						dTimeSec = dTimeBeforeInvalidSeek;
						lastTimeStamp = my_getTimer();
						seqPlayStartTime = lastTimeStamp - ((dTimeSec * 1000) >> 0);
					} */
					return;
				} else {
					//buffer is full.
					if (nowBuffering)
					{
						// if this is the start of the clip wait at least minimumBufferingTimeMs before exiting buffering mode
						if ((dTimeSec>>>0 == 0) || startBufferingClockTime + minimumBufferingTimeMs < my_getTimer())
						{
							bufferTime = 2;
							dTimeSec = dTimeSecBeforeBuffering;
							resumePlaySequence();
							cancelBufferingMode();
							preformedSeekBeforeBuffer = false;
						}
					}
				}
			}

			//Process the timeline for new assets to add to the active layers:
			processTimelineAssets ();

			//Render the layers (update the display to the current bitmap to process):
			//videoHolder.renderVideo();

			//add any delayed assets.
			parseDelyaedInserts ();

			//Process the activeAssets and remove unneeded ones:
			var assetRemoved:Boolean = processActiveAssets ();
			// Add next asset to next layer: (Only if next layer is avileable)
			if (insertNextAsset)
			{
				// search for the next visual asset (image || video || solid) :
				for (i = lastAddedAssetIdx; i < sequenceAssetsLength; ++i)
				{
					asset = currentPlayingAssets.getItemAt(i) as AbstractAsset;
					if (asset.mediaType & (MediaTypes.VIDEO | MediaTypes.IMAGE | MediaTypes.SOLID | MediaTypes.SWF))
					{
						insertAsset (asset);				// insert the next asset to the next layer
						break;
					}
				 }
				 assetRemoved = false;
			}
			//have to be AFTER the loop so it will happen only in the next iteration.
			insertNextAsset = assetRemoved;

			asset = currentPlayingAssets.getItemAt(sequenceAssetsLength - 1) as AbstractAsset;			// get the last asset to play
			singleSegmentPause = playSingleSegmentStopTime <= dTimeSec && playSingleSegmentStopTime > -1; 	// is it pause seek ?
			if (singleSegmentPause == true)				// if it's only seek while pausing:
			{
				dTimeSec = playSingleSegmentStopTime;
				dispatchUpdatePlayhead();
				pauseSequence (false, tEvent != null, false);					// pause the sequence
				return;
			}

			// check the end of the sequence:
			var EndPlay:Boolean = false;
			if (isPreviewMode == false)
			{
				if (roughcutDuration <= dTimeSec) {
					EndPlay = true;
				}
			} else {
				if (4 <= dTimeSec) {
					EndPlay = true;
				}
			}
			if (EndPlay && tEvent != null) {
				callSequenceEnd ();			// if it's the end of the sequence, stop.
			} else if (tEvent != null)
			{
				if (lastTimeStamp - lastDispachedUpdatePlayHead >= 50)
				{
					dispatchUpdatePlayhead ();
					lastDispachedUpdatePlayHead = lastTimeStamp;
				}
			}
		}

		/**
		 * parse delayed inserts and if the assets are loaded now, insert to the right layer.
		 */
		private var blackBd:BitmapData = new BitmapData (PLAYER_WIDTH, PLAYER_HEIGHT, false, 0);
		private function parseDelyaedInserts ():void
		{
			var asset:AbstractAsset;
			for (var item:Object in delayedInserts)
			{
				asset = item.asset;
				if (asset && item.formerStartTime <= dTimeSec &&
					asset.seqEndPlayTime > dTimeSec)
				{
					
					if (asset.mediaSourceLoader != null && asset.mediaSourceLoader.status == LoadingStatus.COMPLETE)
					{
						 
						if (asset.mediaType == MediaTypes.IMAGE)
						{
							
							var bd:BitmapData = (asset.mediaSource as IMediaSource).mediaBitmapData as BitmapData;
							if (bd && blackBd.compare(bd) != 0 && bd != currentImage)
							{

								
								trace ("insert delayed: ", dTimeSec, asset.entryId);
								insertSingleImage(bd, asset.seqStartPlayTime <= dTimeSec ? true : false);
								item.dispose ();
								delete delayedInserts[item];
							}
						}
					} else {
						if (asset.mediaSourceLoader == null || asset.mediaSourceLoader.status == LoadingStatus.ERROR)
						{
							
							item.dispose ();
							delete delayedInserts[item];
						}
					}
				} else {
					
					if (asset.seqEndPlayTime < dTimeSec){
					
						item.dispose ();
						delete delayedInserts[item];
					}
					else
					{
						
					}
				}
			}
		}

		/**
		 *dispatchs ROUGHCUT_UPDATE_PLAYHEAD event.
		 */
		private function dispatchUpdatePlayhead ():void
		{
			dispatchEvent (new PlayerEvent (PlayerEvent.ROUGHCUT_UPDATE_PLAYHEAD, dTimeSec));		//dispatch update with the right timestampfle
		}

		/**
		 * run thorough the timeline assets to see if we have assets that should be added and played,
		 * this will add new assets (except plugin assets) to the next appropriated layer.
		 */
		private function processTimelineAssets ():void
		{
			newAudioLayer = 0;
			var asset:AbstractAsset;
			thumbnailChange = false;
			// Add current playing Assets (assets that dTimeSec is their time frame):
			for (var i:int = lastAddedAssetIdx; i < sequenceAssetsLength; ++i)
			{
				asset = currentPlayingAssets.getItemAt(i) as AbstractAsset;
				// Check start play time:
				if (asset.seqStartPlayTime <= dTimeSec)
				{
					// Check End play Time:
					if  (asset.seqEndPlayTime > dTimeSec)
					{
						activeAssetsToPlay.addItem (asset); 	// push the asset to Active so we won't do it again
						newAudioLayer = currentAudioLayer; 	// for debugging purposes (allows to print the changed layer index after the code finished)
						// if it's a visual asset (image || video || solid) :
						if (asset.mediaType & (MediaTypes.VIDEO | MediaTypes.IMAGE | MediaTypes.SOLID | MediaTypes.SWF))
						{
							thumbnailChange = true;			// there was a change in the thumbnails (audio or displaylist)
							if (!isPreviewMode)				// dispatch a change in the sequence thumbnails (if there was any):
							{
								currentAsset = asset;
								dispatchEvent (new PlayerEvent (PlayerEvent.UPDATE_PLAYHEAD_NEW_ASSET, dTimeSec, asset.originalIndex, asset));
							}
							if (isFirstAssetToAdd) 			//if its the first asset, add it to current layer
							{
								insertAsset (asset);				// process the asset, what to do with it, how to present it...
								isFirstAssetToAdd = false;
								var knext:AbstractAsset;
								for (var j:int = i+1; j < sequenceAssetsLength; ++j)
								// Add next asset to next layer: (Only if next layer is avileable - ON THE FIRST ASSET TO ADD)
								{
									knext = currentPlayingAssets.getItemAt(j) as AbstractAsset;
									// search for the next visual asset (image || video || solid) :
									if (knext.mediaType & (MediaTypes.VIDEO | MediaTypes.IMAGE | MediaTypes.SOLID | MediaTypes.SWF))
									{
										insertAsset (knext);				// insert the next asset to the next layer
										break;
									}
								}
								if (asset.mediaType & (MediaTypes.VIDEO | MediaTypes.SWF))
								{
									playAsset (asset);					// play the asset. (it's already in the display list)
									setSoundtrackVolume (true);		// set the soundtrack volume to be as soundtrackVolumePolicy decide
								} else {
									setSoundtrackVolume (false);		// set the soundtrack volume to be as soundtrackVolumePolicy decide
								}
							} else {
								if (asset.mediaType & (MediaTypes.VIDEO | MediaTypes.SWF))
								{
									playAsset (asset);					// play the asset. (it's already in the display list)
									setSoundtrackVolume (true);		// set the soundtrack volume to be as soundtrackVolumePolicy decide
								} else {
									setSoundtrackVolume (false);		// set the soundtrack volume to be as soundtrackVolumePolicy decide
								}
								if (asset.mediaType == MediaTypes.IMAGE)
									currentImage = asset.mediaSource as BitmapData;
								if (asset.originalIndex == sequenceVisualAssetsLength - 1)
								{
									// if this is the last visual element to play, clear the underlaying layer so
									// ending transition will always transition to the background color.
									videoHolder.current.clearVideo();
								}
							}
						} else {
							insertAsset (asset);				// process the asset, what to do with it, how to present it...
						}
						currentAudioLayer = newAudioLayer;
						activeAssetsChanged = true;			// in order to dispatch if there was a change in the sequence
					}
					lastAddedAssetIdx = i + 1;			// increase lastAddedAssetIdx so we'll start this loop from it next time
				} else {
					break; 								// there are no more asset to process in this time stamp
				}
			}
		}

		/**
		 * control the play of the soundtrack asset.
		 */
		private function playSoundtrackAsset ():void
		{
			if (roughcut.soundtrackAsset)
			{
				if (roughcut.soundtrackAudioPolicy == AudioPlayPolicy.AUDIO_PLAY_POLICY_REPEAT ||
					dTimeSec < roughcut.soundtrackAsset.length)
				{
					var ns:ExNetStream = roughcut.soundtrackAsset.mediaSource as ExNetStream;
					if (ns)
					{
						roughcut.soundtrackAsset.cacheIsSilenceCheck = roughcut.soundtrackAsset.audioGraph.isSilent();
						if (roughcut.soundtrackAsset.cacheIsSilenceCheck)
						{
							setStreamSoundTransform (0, roughcut.soundtrackAsset.audioBalance, roughcut.soundtrackAsset);
						} else {
							if (currentAsset && currentAsset.mediaType == MediaTypes.VIDEO)
							{
								setSoundtrackVolume (true);		// set the soundtrack volume to be as soundtrackVolumePolicy decide
							} else {
								setSoundtrackVolume (false);		// set the soundtrack volume to be as soundtrackVolumePolicy decide
							}
						}
						var soundTrackSeekTime:Number = ((dTimeSec * 1000)>>0) % ((roughcut.soundtrackAsset.length * 1000)>>0) / 1000;
						ns.playPartOfStream (soundTrackSeekTime);
						if (roughcut.soundtrackAudioPolicy == AudioPlayPolicy.AUDIO_PLAY_POLICY_REPEAT)
							ns.replayStream = true;
						else
							ns.replayStream = false;
					}
				}
			}
		}

		/**
		 *control the volume of the soundtrack asset.
		 * @param silent	if silent, soundtrack volume will be dropped according to the roughcut soundtrackVolumePlayPolicy.
		 * @see com.kaltura.roughcut.Roughcut#soundtrackVolumePlayPolicy
		 * @see com.kaltura.roughcut.soundtrack.AudioPlayPolicy
		 */
		private function setSoundtrackVolume (silent:Boolean):void
		{
			if (silent)
			{
				switch (roughcut.soundtrackVolumePlayPolicy)
				{
					case AudioPlayPolicy.CROSS_VIDEO_SILENT:
						audioVolume = roughcut.soundtrackSilentVolume;
						break;

					case AudioPlayPolicy.CROSS_VIDEO_MUTE:
						audioVolume = 0;
						break;

					case AudioPlayPolicy.CROSS_VIDEO_NO_ACTION:
					case AudioPlayPolicy.CROSS_SOUNDTRACK_ONLY:
						audioVolume = roughcut.soundtrackVolume;
						break;
				}
			} else {
				audioVolume = _overAllVolumeControl;
			}
			setOverAllVolume (_overAllVolumeControl);
		}

		/**
		 * run thorough the active assets array, process the assets and remove the no longer active assets.
		 * @return 		true if non plugin assets were removed.
		 */
		private function processActiveAssets ():Boolean
		{
			var assetRemoved:Boolean = false;
			var asset:AbstractAsset;
			// Process active assets :
			for (var i:int = activeAssetsLength; i >= 0; --i)
			{
				asset = activeAssetsToPlay.getItemAt(i) as AbstractAsset;
				switch (asset.mediaType)
				{
					case MediaTypes.TRANSITION:			// seekMedia Transitions:
					 	seekVal = (dTimeSec - asset.seqStartPlayTime) / asset.transitionLength;
					 	if (seekVal < 0) seekVal = 0;
						if (asset.mediaSource != null)
							try {
								KTransition(asset.mediaSource).seekMedia (seekVal);						//seekMedia the transition to the displaylist
							} catch (err:Error) { trace ('non-valid transition tried to seek'); }
					 	break;

					case MediaTypes.OVERLAY:				// seekMedia Overlays and Effects:
					case MediaTypes.EFFECT:
						seekVal = (dTimeSec - asset.seqStartPlayTime) / asset.length;
						if (seekVal < 0) seekVal = 0;
						if (asset.mediaSource != null)
							asset.mediaSource.seekMedia (seekVal);
						break;

					case MediaTypes.AUDIO:
					case MediaTypes.VIDEO:
					case MediaTypes.VOICE:
					case MediaTypes.SWF:
						//ExNetStream(k.mediaSource).playMedia ();		//in case we missed for some reson.. replay?
						if (!asset.cacheIsSilenceCheck && (roughcut.soundtrackVolumePlayPolicy != AudioPlayPolicy.CROSS_SOUNDTRACK_ONLY)) 						//if the asset is not silent, seekMedia sound transform
							setStreamSoundTransform (asset.audioGraph.getVolumeAtTime(dTimeSec - asset.seqStartPlayTime), asset.audioBalance, asset);
						break;
				}
				// If the asset time frame is beyond this time stamp, remove the asset (and switch layers)
				if (asset.seqEndPlayTime <= dTimeSec || dTimeSec < asset.seqStartPlayTime)
				{
					switch (asset.mediaType)
					{
						case MediaTypes.VIDEO:
							removeSingleVideo ();			// for video, stop the stream and clear the video
						case MediaTypes.IMAGE:
						case MediaTypes.SOLID:
						case MediaTypes.SWF:
							switchVideoLayers ();				// for visual assets, switch layers
							assetRemoved = true;			// if asset was removed, than mark next layer as avilable
							thumbnailChange = true;			// there was a change in the thumbnails
							break;

															// for plugins do detach:
						case MediaTypes.TRANSITION:
							if (asset.mediaSource != null) {
								if (currentTransition)//xxx
								{
									currentTransition = null;
									KTransition(asset.mediaSource).detach (compWidth, compHeight, nXnext, nYnext);
								}
							}
							break;

						case MediaTypes.OVERLAY:
							if (asset.mediaSource != null)
								asset.mediaSource.detach (compWidth, compHeight, nXnext, nYnext);
							break;

						case MediaTypes.EFFECT:
							if (asset.mediaSource != null) // && isEffectAppliedNow (asset) == false)
								asset.mediaSource.detach (compWidth, compHeight, nXnext, nYnext);
							break;

						case MediaTypes.AUDIO:
							switchAudioLayers ();				// for audio and voice, switch logical layers and stop the audio
							removeAudioStream (1 - audioLayerOnTop);
							thumbnailChange = true;			// there was a change in the thumbnails
							break;
					}

					activeAssetsToPlay.source.splice (i, 1);		// remove the asset from active playing assets list
					//xxx activeAssetsToPlay.refresh();
					activeAssetsChanged = true;					// in order to dispatch if there was a change in the sequence
				}
			}
			return assetRemoved;
		}

		/**
		 * plays video asset.
		 * @param asset		the asset to play
		 */
		private function playAsset (asset:AbstractAsset):void
		{
			if (roughcut.soundtrackVolumePlayPolicy != AudioPlayPolicy.CROSS_SOUNDTRACK_ONLY)
				setStreamSoundTransform (asset.cacheIsSilenceCheck ? 0 : asset.audioGraph.getVolumeAtTime(0), asset.audioBalance, asset);	//set the stream soundTransform
			else
				setStreamSoundTransform (0, 0, asset);
			if (_playState == VideoStates.PLAY) {
				if (asset.mediaSource)
					asset.mediaSource.playMedia();
			}
			currentAsset = asset;
			if (currentAsset && (currentAsset.mediaType & (MediaTypes.VIDEO | MediaTypes.SWF)))
			{
				setSoundtrackVolume (true);		// set the soundtrack volume to be as soundtrackVolumePolicy decide
			} else {
				setSoundtrackVolume (false);		// set the soundtrack volume to be as soundtrackVolumePolicy decide
			}
			//(dTimeSec - k.seqStartPlayTime) +
		}

		/**
		 * Set the asset and prepare to play
		 * @param k		the asset to be inserted
		 *
		 */
		private function insertAsset (asset:AbstractAsset):void
		{
			switch (asset.mediaType)
			{
				 case MediaTypes.VIDEO:
				 	asset.cacheIsSilenceCheck = asset.audioGraph.isSilent();
					videoHolder.resetProperties();												// b4 inserting make sure the layers are rested to default
					var vidW:Number = asset.kalturaEntry ? asset.kalturaEntry.width : Eplayer.PLAYER_WIDTH;
					var vidH:Number = asset.kalturaEntry ? asset.kalturaEntry.height : Eplayer.PLAYER_HEIGHT;
					insertVideoStreamSet (ExNetStream(asset.mediaSource), isFirstAssetToAdd, vidW, vidH);					//attach the stream to a displaylist layer
					var seekToStartAsset:Boolean = (dTimeSec > asset.seqStartPlayTime && _playState != VideoStates.PLAY) ? true : false;
					seekStreamingMedia (asset, seekToStartAsset);
					//asset.mediaSource.seekMedia (seekStreamInSequence (asset, _playState == VideoStates.PLAY), asset.clipedStreamStart);
					//(dTimeSec <= asset.seqStartPlayTime)
					if (asset.cacheIsSilenceCheck || (roughcut.soundtrackVolumePlayPolicy == AudioPlayPolicy.CROSS_SOUNDTRACK_ONLY))
						setStreamSoundTransform (0, 0, asset);									//silent stream
					activeAssetChange = true;													// there was a change in the active assets in displaylist (asset was added)
					break;

				case MediaTypes.IMAGE:
					videoHolder.resetProperties();
					var tempBD:BitmapData = (asset.mediaSource as IMediaSource).mediaBitmapData;
					insertSingleImage (tempBD, isFirstAssetToAdd);
					if (asset.mediaSourceLoader == null || asset.mediaSourceLoader.status == LoadingStatus.PROGRESS)
					{
						trace ("delay insert: ", dTimeSec, asset.entryName);
						delayedInserts[new DelayedInsertVO (dTimeSec, asset)] = getTimer();
			
					}
					if (isFirstAssetToAdd)
					{
						currentImage = tempBD;
						isFirstAssetToAdd = false;
					}
					activeAssetChange = true;
					break;

				case MediaTypes.SOLID:
					videoHolder.resetProperties();
					insertSingleImage (asset.mediaSource as BitmapData, isFirstAssetToAdd);
					if (isFirstAssetToAdd)
					{
						currentImage = asset.mediaSource as BitmapData;
						isFirstAssetToAdd = false;
					}
					activeAssetChange = true;
					break;

				case MediaTypes.SWF:
					videoHolder.resetProperties();
					if (asset.mediaSource != null) {
						if (isFirstAssetToAdd == true)
						{
							videoHolder.current.SWF = asset.mediaSource as SWFLoaderMediaSource;
						} else {
							videoHolder.next.SWF = asset.mediaSource as SWFLoaderMediaSource;
						}
					}
					if (isFirstAssetToAdd)
						isFirstAssetToAdd = false;
					activeAssetChange = true;
					break;

				case MediaTypes.TRANSITION:
					videoHolder.resetProperties();
					if (asset.mediaSource != null)
					{
						currentTransition = asset.mediaSource;									//save what transition is now applied
						KTransition(asset.mediaSource).setTargets(videoHolder);				//set the displaylist to be effected by this transition
						seekVal = (dTimeSec - asset.seqStartPlayTime) / asset.transitionLength;		//calculate transition time position (0-1)
						try {
							KTransition(asset.mediaSource).seekMedia (seekVal);						//seekMedia the transition to the displaylist
						} catch (err:Error) { trace ('non-valid transition tried to seek'); }
					}
					break;

				case MediaTypes.OVERLAY:
					if (asset.mediaSource != null)
					{
						Overlay(asset.mediaSource).setTargets(overlaysHolder);					//add the overlay to the displaylist
						seekVal = (dTimeSec - asset.seqStartPlayTime) / asset.length;				//calculate overlay time position (0-1)
						Overlay(asset.mediaSource).seekMedia (seekVal, dTimeSec - asset.seqStartPlayTime);							//seekMedia the overlay on the displaylist
						if (playState == VideoStates.PLAY)
							Overlay(asset.mediaSource).playMedia();
					}
					break;

				case MediaTypes.EFFECT:
					if (asset.mediaSource != null)
					{
						KEffect(asset.mediaSource).setTargets(playerAssetsContainer);			//add the effect to the displaylist
						seekVal = (dTimeSec - asset.seqStartPlayTime) / asset.length;				//calculate effect time position (0-1)
						KEffect(asset.mediaSource).seekMedia (seekVal);							//seekMedia the effect on the displaylist
					}
					break;

				case MediaTypes.AUDIO:
					asset.cacheIsSilenceCheck = asset.audioGraph.isSilent();
					insertAudioStream (ExNetStream(asset.mediaSource), currentAudioLayer);			//activate the audio and set it to active layer
					//why? : || (roughcut.soundtrackVolumePlayPolicy == AudioPlayPolicy.CROSS_SOUNDTRACK_ONLY)
					if (asset.cacheIsSilenceCheck)
						setStreamSoundTransform (0, 0, asset);										//silent stream
					playPartOfAudioStream (seekStreamInSequence(asset, (dTimeSec <= asset.seqStartPlayTime)), asset.length, currentAudioLayer);	//start playing the stream from start time
					//playPartOfAudioStream (seekStreamInSequence (asset), asset.length, currentAudioLayer);	//start playing the stream from start time
					newAudioLayer = 1 - currentAudioLayer;											//switch layers so the next one won't delete the current
					break;
			}
		}

		/**
		 * Checks if a specified effect asset is applied and active right now
		 * @param CurrentK		the effect asset to check
		 * @return 				true if the effect is currently effecting the displaylist
		 *
		 */
		private function isEffectAppliedNow (asset:AbstractAsset):Boolean
		{
			var j:int;
			var N:int = activeAssetsToPlay.length;
			var effectAsset:AbstractAsset;
			for (j = N-1; j >= 0; --j)
			{
				effectAsset = activeAssetsToPlay.getItemAt(j) as AbstractAsset;
				if (effectAsset.mediaType == MediaTypes.EFFECT && asset != effectAsset)
					return true;
			}
			return false;
		}

		/**
		 * set end of sequence state and dispatch ROUGHCUT_PLAY_END event.
		 */
		private function callSequenceEnd ():void
		{
			if (roughcut.soundtrackAsset && roughcut.soundtrackAsset.mediaSource)
				ExNetStream(roughcut.soundtrackAsset.mediaSource).pauseMedia();
			dispatchUpdatePlayhead ();
			stopInternalTimer ();
			pauseSequence(true);																				//pause the sequence (streams and all..)
			dispatchEvent (new PlayerEvent (PlayerEvent.ROUGHCUT_PLAY_END, roughcutDuration));					//dispatch pasue notice
			changeState ( VideoStates.PAUSE );
		}

		/**
		 * stop internal time synch of sequenceSynch.
		 * @see #sequenceSynch.
		 */
		private function stopInternalTimer ():void
		{
			//stage.addEventListener(Event.ENTER_FRAME, sequenceSynch);
			sequenceSynchTimer.stop();
			sequenceSynchTimer.removeEventListener (TimerEvent.TIMER, sequenceSynch);
		}

		/**
		 * start internal time synch for sequenceSynch.
		 * @see #sequenceSynch.
		 */
		private function startInternalTimer ():void
		{
			//stage.removeEventListener(Event.ENTER_FRAME, sequenceSynch);
			sequenceSynchTimer.addEventListener (TimerEvent.TIMER, sequenceSynch);
			sequenceSynchTimer.start();
		}


		/**
		 * Seek to a specified time on the given layer stream.
		 * @param seek_value		time to seek to in sec
		 * @param handler			a function to dispatch when seek completed
		 * @param current			true if should seek the current layer's stream.
		 */
		public function seekSingleStream (seek_value:Number, handler:Function = null, current:Boolean = false):void
		{
			seekingCurrent = current;
			if (!current)
			{
				videoHolder.next.stream.seek(seek_value);
			} else {
				videoHolder.current.stream.seek(seek_value);
			}

			if (handler != null)
				videoHolder.next.stream.addEventListener (NetStatusEvent.NET_STATUS, handler);
		}

		/**
		 *seeks the video/audio mediaSource of an asset according to the current sequence time.
		 * @param asset					the asset that holds the stream to seek.
		 * @param useSeqTime			should we ignore the sequence time and just seek to the start of the asset ?
		 * @return								the valid sequence seek time.
		 */
		private function seekStreamInSequence (asset:AbstractAsset, useSeqTime:Boolean = true):Number
		{
			switch (roughcut.streamingMode)
			{
				case StreamingModes.PROGRESSIVE_STREAM_DUAL:
					return ((useSeqTime ? (dTimeSec - asset.seqStartPlayTime) : 0) + asset.realSeqStreamSeekTime);
					break;

				default:
					return ((useSeqTime ? (dTimeSec - asset.seqStartPlayTime) : 0) + asset.startTime);
					break;
			}
		}

		/**
		 *seeks the video/audio mediaSource of an asset according to the current sequence time.
		 * @param asset					the asset that holds the stream to seek.
		 * @param useSeqTime			should we ignore the sequence time and just seek to the start of the asset ?
		 */
		private function seekStreamingMedia (asset:AbstractAsset, useSeqTime:Boolean = true):void
		{
			var seekValue:Number;
			switch (roughcut.streamingMode)
			{
				case StreamingModes.PROGRESSIVE_STREAM_DUAL:
					seekValue = (useSeqTime ? (dTimeSec - asset.seqStartPlayTime + asset.realSeqStreamSeekTime) : asset.realSeqStreamSeekTime );
					asset.mediaSource.seekMedia (seekValue, 0);
					break;

				default:
					seekValue = (useSeqTime ? (dTimeSec - asset.seqStartPlayTime + asset.startTime) : asset.startTime);
					asset.mediaSource.seekMedia (seekValue, asset.clipedStreamStart);
					break;
			}
		}

		/**
		 *sets the player into buffering mode and dispatch event to indicate.
		 */
		public function setBufferingMode ():void
		{
			nowBuffering = true;
			dispatchEvent(new PlayerBufferEvent (PlayerBufferEvent.PLAYER_BUFFER_STATUS, BufferStatuses.BUFFERING, dTimeSec));
		}

		/**
		 *cancel the buffering mode and dispatch event to indicate.
		 */
		private function cancelBufferingMode ():void
		{
			nowBuffering = false;
			dispatchEvent(new PlayerBufferEvent (PlayerBufferEvent.PLAYER_BUFFER_STATUS, BufferStatuses.FULL, dTimeSec));
		}

		/**
		 * Accept drag and drop and decide what to do with it.
		 * @param e				event object
		 * @param dragAction	the action to be preformed ('copy', 'move' or 'preview')
		 */
/* 		public function allowDrag(e:DragEvent, dragAction:String = "preview"):void
		{
	    	DragManager.acceptDragDrop(this);
			DragManager.showFeedback('preview');
		}
 */

	/// ================================================================================================================================
	/// overrided:

		/**
		 *when component loads, set initial size and constrain aspect ratio for the player assets container.
		 */
/* 		override protected function measure():void
		{
            super.measure();

            if (!_stretchContent)
			{
				if (compWidth * aspectRatio > compHeight)
				{
					compWidth = compHeight / aspectRatio;
				} else {
					compHeight = compWidth * aspectRatio;
				}
			}

            measuredWidth = compWidth;
            measuredMinWidth = 5;
            measuredHeight = compHeight;
            measuredMinHeight = 5;
        }
 */
		/**
		 *when resizing the player component, compute a new scale factor, rescale and reposition the player assets containers accordingly.
		 * @param unscaledWidth			the new width of the component.
		 * @param unscaledHeight		the new height of the component.
		 * @see mx.core.UIComponent#updateDisplayList
		 */
		public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			//xxx super.updateDisplayList (unscaledWidth, unscaledHeight);
			compWidth = unscaledWidth;
			compHeight = unscaledHeight;

			backgroundSprite.x = 0;
			backgroundSprite.y = 0;
			backgroundContainer.x = 0;
			backgroundContainer.y = 0;
			backgroundContainer.width = compWidth;
			backgroundContainer.height = compHeight;
			backgroundColor = _backgroundColor;

			if (!_stretchContent)
			{
				if (compWidth * _aspectRatio > compHeight)
				{
					compWidth = compHeight / aspectRatio;
				} else {
					compHeight = compWidth * aspectRatio;
				}
			}

			playerMask.height = compHeight;									//Mask the player
			playerMask.width = compWidth;
			playerMask.y = (unscaledHeight - compHeight) / 2;
			playerMask.x = (unscaledWidth - compWidth) / 2;

			drawMask ();

			var scaleFactorX:Number;
			var scaleFactorY:Number;

			// Rescaling:
			if (unscaledHeight != lastH || unscaledWidth != lastW)
			{
				scaleFactorX = compWidth / lastW;
				scaleFactorY = compHeight / lastH;
				playerAssetsContainer.scaleX *= scaleFactorX;
				playerAssetsContainer.scaleY *= scaleFactorY;
				//xxx previewContainer.scaleX *= scaleFactorX;
				//xxx previewContainer.scaleY *= scaleFactorY;
			}
			playerAssetsContainer.x = (unscaledWidth - compWidth) / 2;
			playerAssetsContainer.y = 0;
			//xxx previewContainer.x = (unscaledWidth - compWidth) / 2;
			//xxx previewContainer.y = 0;
			lastH = compHeight;
			lastW = compWidth;

			//xxx errMsgContainer.x = (unscaledWidth - compWidth) / 2;
			//xxx errMsgContainer.y = (compHeight - txtErrorMessage.height) / 2;
			//xxx txtErrorMessage.width = compWidth;
			//xxx txtErrorMessage.y = (compHeight / 2) - txtErrorMessage.height;
			//xxx txtErrorMessage.x = (compWidth / 2) - txtErrorMessage.width / 2;

			//xxx previewMsgContainer.x = (unscaledWidth - compWidth) / 2;
			//xxx previewMsgContainer.y = (compHeight - txtPreviewMessage.height) / 2;
			//xxx txtPreviewMessage.width = compWidth;
			//xxx txtPreviewMessage.x = (compWidth - txtPreviewMessage.width) / 2;
			//xxx txtPreviewMessage.y = (compHeight / 1.5) - txtPreviewMessage.height;
			//xxx txtPreviewBufferingMessage.x = (compWidth - txtPreviewBufferingMessage.width) / 2;
			//xxx txtPreviewBufferingMessage.y = 0;
		}
	}
}