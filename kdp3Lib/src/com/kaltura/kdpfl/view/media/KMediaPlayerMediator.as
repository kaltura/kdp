package com.kaltura.kdpfl.view.media
{
	import com.kaltura.kdpfl.controller.media.LiveStreamCommand;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.PlayerStatusProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.strings.MessageStrings;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SourceType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.kdpfl.view.controls.BufferAnimation;
	import com.kaltura.kdpfl.view.controls.BufferAnimationMediator;
	import com.kaltura.kdpfl.view.controls.KTrace;
	import com.kaltura.types.KalturaMediaType;
	import com.kaltura.vo.KalturaLiveStreamEntry;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.vo.KalturaMixEntry;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.osmf.elements.ParallelElement;
	import org.osmf.events.AudioEvent;
	import org.osmf.events.BufferEvent;
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.events.DynamicStreamEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.traits.DynamicStreamTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.TimeTrait;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * Mediator for the KMediaPlayer component 
	 * 
	 */	
	public class KMediaPlayerMediator extends Mediator
	{
		public static const NAME:String = "kMediaPlayerMediator";
		public var isInSequence : Boolean = false;
		
		private const PLAYING:String = "playing";
		private const PAUSED:String = "paused";
		
		private var _bytesLoaded:Number;//keeps loaded bytes for intelligent seeking
		private var _bytesTotal:Number;//keeps total bytes for intelligent seeking
		private var _duration:Number;//keeps duration for intelligent seeking
		private var _blockThumb : Boolean = false;
		private var _mediaProxy : MediaProxy; 
		private var _sequenceProxy : SequenceProxy;
		/**
		 * intelli seek offset 
		 */		
		private var _offset:Number=0
		private var _loadedTime:Number;
		private var _flashvars:Object;
		private var _seekUrl:String;
		private var _autoMute:Boolean=false;
		private var _isIntelliSeeking :Boolean=false;
		private var _intelliSeekStart:Number=0;
		private var _currentTime:Number;
		private var _lastCurrentTime:Number = 0;
		private var _newdDuration:Number;
		private var _kdp3Preloader : BufferAnimation;
		private var _autoPlay : Boolean;
		/**
		 * indicates if first "playing" state for playing the current media was called 
		 */		
		private var _hasPlayed : Boolean = false;
		private var _playerReadyOrEmptyFlag : Boolean = false;
		private var _alertCalled: Boolean = false;
		public var playBeforeMixReady : Boolean = true;
		private var _mixLoaded : Boolean = false;
		private var _prevState : String;
		/**
		 * the previous player volume 
		 */		
		private var _prevVolume:Number = 1;
		/**
		* in intelli seek - if we should pause after player goes to "playing state" 
		 */
		private var _pausedPending:Boolean = false;
		/**
		 * This flag fix OSMF issue that on playend you get somtimes MediaPlayerReady
		 * so to fix this I added this flag 
		 */        
		private var _loadMediaOnPlay : Boolean = false;
		
		/**
		 * Flag indicating if do_switch was explicity call, this means we should set autoDynamicStreamSwitch to false 
		 */		
		private var _doSwitchSent:Boolean = false;
		
		/**
		 * indicates if the media is parallel element and we should access the play trait directly 
		 */		
		private var _useParallelElement:Boolean = false;
		
		/**
		 * timer to get video metadata 
		 */		
		private var _metadataTimer:Timer;

		/**
		 * indicates if the "doSeek" was sent before "doPlay" and KDP intiate the "doPlay" in order to load the entry. 
		 */		
		private var _isPrePlaySeek:Boolean = false;
		/**
		 * indicates if we are in the middle of "pre play seek"
		 * to solve issues with pre sequence two flags were required (_isPrePlaySeek and _isPrePlaySeekInProgress) 
		 */		
		private var _isPrePlaySeekInProgress:Boolean = false;
		/**
		 * last entry duration recieved from durationChanged, will be used in intelliseek 
		 */		
		private var _entryDuration:Number;
		/**
		 * where to start play of current media. Will be used when we performed "doSeek" before first play and we had a preroll - this
		 * field will remember where we requested to seek to .
		 * This field is "stronger" than _medixProxy.vo.mediaPlayFrom
		 */		
		private var _mediaStartPlayFrom:Number = -1;
		/**
		 * indicates if we are in the process of re-loading live stream entry 
		 */		
		private var _reloadingLiveStream:Boolean = false;
		
		/**
		 * Constructor 
		 * @param name
		 * @param viewComponent
		 * 
		 */		
		public function KMediaPlayerMediator(name:String=null, viewComponent:Object=null)
		{
			name = name ? name : NAME;
			super(name, viewComponent);
			
			var configProxy : ConfigProxy = facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;
			_flashvars = configProxy.vo.flashvars;
			kMediaPlayer.isFileSystemMode = _flashvars.fileSystemMode;
		}
		
		/**
		 * Hadnler for the mediator registration; defines the _mediaProxy and _flashvars for the mediator.
		 * Also sets the bg color of the player, adds the event listeners for the events fired from the OSMF to be translated into notifications.
		 * and will listen to all the required events 
		 * 
		 */		
		override public function onRegister():void
		{	
			_mediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
			_sequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			var configProxy : ConfigProxy = facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;
			_flashvars = configProxy.vo.flashvars;
			
			//if we got a player bg color from flashvars we will color the back screen
			if(_flashvars.playerBgColor != null)
			{
				var bgColor : uint = uint(_flashvars.playerBgColor);
				var alpha : Number = _flashvars.playerBgAlpha ? _flashvars.playerBgAlpha : 1;
				kMediaPlayer.drawBg( bgColor , alpha );
			}
			
			//set autoPlay,loop,and autoRewind from flashvars
			
			//autoPlay Indicates whether the MediaPlayer starts playing the media as soon as its load operation has successfully completed.
			if(_flashvars.autoPlay == "true") _autoPlay = true;
			
			//loop Indicates whether the media should play again after playback has completed
			if(_flashvars.loop == "true") player.loop =  true;
			
			//autoRewind Indicates which frame of a video the MediaPlayer displays after playback completes. 
			if(_flashvars.autoRewind == "true") player.autoRewind =  true;
			
			//if an autoMute flashvar passed as true mute the volume 
			if(_flashvars.autoMute == "true") _autoMute=true;
		
			//add all the event listeners needed from video component to make the KDP works
			player.addEventListener( DisplayObjectEvent.DISPLAY_OBJECT_CHANGE , onViewableChange );
			player.addEventListener( DisplayObjectEvent.MEDIA_SIZE_CHANGE , onMediaSizeChange );		
			
			player.addEventListener( MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE , onPlayerStateChange );
			
			player.addEventListener( TimeEvent.CURRENT_TIME_CHANGE , onPlayHeadChange , false, int.MAX_VALUE);
			player.addEventListener( AudioEvent.VOLUME_CHANGE , onVolumeChangeEvent );
			player.addEventListener( BufferEvent.BUFFER_TIME_CHANGE , onBufferTimeChange );
			player.addEventListener( BufferEvent.BUFFERING_CHANGE , onBufferingChange );
			player.addEventListener( MediaErrorEvent.MEDIA_ERROR , onMediaError );
			
			player.addEventListener( LoadEvent.BYTES_TOTAL_CHANGE , onBytesTotalChange );
			player.addEventListener( LoadEvent.BYTES_LOADED_CHANGE , onBytesDownloadedChange );
			player.addEventListener( TimeEvent.DURATION_CHANGE , onDurationChange );
			player.addEventListener( DynamicStreamEvent.SWITCHING_CHANGE , onSwitchingChange );
			
			
			if(_flashvars.disableOnScreenClick)
			{
				disableOnScreenClick();
			}
		}
		
		public function centerMediator () : void 
		{
			var size : Object = {width : playerContainer.width, height : playerContainer.height};
			
			_kdp3Preloader.height = size.height;
			_kdp3Preloader.width = size.width;
		}
		
		
		/**
		 * Enables play/pause on clicking the video.
		 * 
		 */		
		public function enableOnScreenClick() : void
		{
			if(kMediaPlayer && !kMediaPlayer.hasEventListener(MouseEvent.CLICK))
				kMediaPlayer.addEventListener( MouseEvent.CLICK , onMClick );
		}
		/**
		 * Disables play/pause on clicking the screen. 
		 * 
		 */		
		public function disableOnScreenClick() : void
		{
			if(kMediaPlayer && kMediaPlayer.hasEventListener(MouseEvent.CLICK))
				kMediaPlayer.removeEventListener( MouseEvent.CLICK , onMClick );
		}
		/**
		 * Hnadler for on-screen click 
		 * @param event
		 * 
		 */		
		private function onMClick( event : MouseEvent ) : void 
		{
			if( player.canPlay && !player.playing )
				sendNotification(NotificationType.DO_PLAY);
			else if( player.canPause && player.playing) 
				sendNotification(NotificationType.DO_PAUSE);
		}
		
		/**
		 * List of the notifications that interest the player
		 * @return 
		 * 
		 */	    
		override public function listNotificationInterests():Array
		{
			return [
				NotificationType.SOURCE_READY,
				NotificationType.DO_PLAY,
				NotificationType.ENTRY_READY,
				NotificationType.DO_STOP,
				NotificationType.CHANGE_MEDIA_PROCESS_STARTED,
				NotificationType.DO_PAUSE,
				NotificationType.DO_SEEK,
				NotificationType.DO_SWITCH,
				NotificationType.CLEAN_MEDIA,
				NotificationType.CHANGE_VOLUME,
				NotificationType.VOLUME_CHANGED_END,
				NotificationType.MEDIA_READY,
				NotificationType.KDP_EMPTY,
				NotificationType.KDP_READY,
				LiveStreamCommand.LIVE_STREAM_READY,
				NotificationType.LIVE_ENTRY,
				NotificationType.PLAYER_SEEK_START,
				NotificationType.PLAYER_PLAYED,
				NotificationType.OPEN_FULL_SCREEN,
				NotificationType.HAS_OPENED_FULL_SCREEN,
				NotificationType.HAS_CLOSED_FULL_SCREEN,
				NotificationType.CHANGE_PREFERRED_BITRATE,
				NotificationType.VIDEO_METADATA_RECEIVED
			];
		}
		
		/**
		 * Notification handler of the KMediaPlayerMediator
		 * @param note
		 * 
		 */		
		override public function handleNotification(note:INotification):void
		{ 
			switch(note.getName())
			{
				case NotificationType.ENTRY_READY:
					
					if(_mediaProxy.vo)
					{
						if( !_sequenceProxy.vo.isInSequence && !_flashvars.noThumbnail)
						{
							if (_flashvars.loadThumbnailWithKs)
							{
								kMediaPlayer.loadThumbnail( _mediaProxy.vo.entry.thumbnailUrl,_mediaProxy.vo.entry.width,_mediaProxy.vo.entry.height , (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).vo.kalturaClient.ks ); //load the thumnail of this media
							}
							else
							{
								kMediaPlayer.loadThumbnail( _mediaProxy.vo.entry.thumbnailUrl,_mediaProxy.vo.entry.width,_mediaProxy.vo.entry.height );
							}
						}
					}
					if (_flashvars.autoPlay !="true" && !_mediaProxy.vo.singleAutoPlay)
					{
						kMediaPlayer.showThumbnail();
					}
					else
					{
						kMediaPlayer.hideThumbnail();
					}
					break;
				case NotificationType.SOURCE_READY: //when the source is ready for the media element
					
					cleanMedia(); //clean the media element if exist
					
					setSource(); //set the source to the player
	
					break;
				case NotificationType.CHANGE_MEDIA_PROCESS_STARTED:
					//when we change the media we can reset the loadMediaOnPlay flag
					var designatedEntryId : String = String(note.getBody().entryId);
					
					_loadMediaOnPlay = false;
					_alertCalled = false;
					player.removeEventListener( TimeEvent.COMPLETE , onTimeComplete );
					_isIntelliSeeking = false;
					_doSwitchSent = false;
					_hasPlayed = false;
					//Fixed weird issue, where the CHANGE_MEDIA would be caught by the mediator 
					// AFTER the new media has already loaded. Caused media never to be loaded.
					if (designatedEntryId != _mediaProxy.vo.entry.id)
					{
						kMediaPlayer.unloadThumbnail()
						cleanMedia();
					}
					break;
				case NotificationType.DO_PLAY: //when the player asked to play	
					if (_mediaProxy.vo.entry is KalturaLiveStreamEntry || _mediaProxy.vo.deliveryType == StreamerType.LIVE)
					{
						if (_mediaProxy.vo.isOffline)
						{
							return;
						}
					}
					//hide the thumbnail 
					//if this is Audio and not blocked entry countinue to show the Thumbnail
					if(_mediaProxy.vo.entry.mediaType==KalturaMediaType.AUDIO && !_blockThumb &&!_sequenceProxy.vo.isInSequence)
					{
						kMediaPlayer.showThumbnail();
					}
					else //else hide the thumbnail
					{
						kMediaPlayer.hideThumbnail();
					}
					if(!_sequenceProxy.vo.isInSequence && _mediaProxy.vo.entry.id &&
						_mediaProxy.vo.entry.id!= "-1" && _sequenceProxy.hasSequenceToPlay() && !_isPrePlaySeekInProgress)
					{
						_sequenceProxy.vo.isInSequence = true;
						_sequenceProxy.playNextInSequence();
						return;
					}
					else if (!_mediaProxy.vo.media || player.media != _mediaProxy.vo.media)
					{
						//_mediaProxy.prepareMediaElement();
						if (_mediaProxy.vo.preferedFlavorBR && _mediaProxy.vo.deliveryType!=StreamerType.HDNETWORK)
						{
							_mediaProxy.vo.switchDue = true; //TODO: CHECK do we still need it?
						}
						_mediaProxy.loadWithMediaReady();
						return;
					}
					else if(_mediaProxy.vo.entry is KalturaMixEntry && 
						player.media.getTrait(MediaTraitType.DISPLAY_OBJECT)["isReadyForLoad"] &&
						!player.media.getTrait(MediaTraitType.DISPLAY_OBJECT)["isSpriteLoaded"])
					{
						player.media.getTrait(MediaTraitType.DISPLAY_OBJECT)["loadAssets"]();
						_mixLoaded = true;
						
						/////////////////////////////////////////////
						//TODO: why we need to send play again ? we should change thos if else statment and use return if needed, 
						//but to send DO_PLAY again it's a bug 
						sendNotification(NotificationType.DO_PLAY); 
						/////////////////////////////////////////////
					}
					else if(player.canPlay) 
					{
						var timeTrait : TimeTrait = _mediaProxy.vo.media.getTrait(MediaTraitType.TIME) as TimeTrait;
						
						if( _mediaProxy.vo.entryExtraData && !_mediaProxy.vo.entryExtraData.isAdmin && 
							(_mediaProxy.vo.entryExtraData.isCountryRestricted ||
								!_mediaProxy.vo.entryExtraData.isScheduledNow ||
								_mediaProxy.vo.entryExtraData.isSiteRestricted ||
								(_mediaProxy.vo.entryExtraData.isSessionRestricted && _mediaProxy.vo.entryExtraData.previewLength <= 0)))
						{
							return;
						}
						
						//if it's Entry and the entry id empty or equal -1 don't play
						if( _flashvars.sourceType == SourceType.ENTRY_ID &&
							(_mediaProxy.vo.entry.id == null || _mediaProxy.vo.entry.id == "-1"))
						{
							KTrace.getInstance().log("invalid entry id", _mediaProxy.vo.entry.id);
							return;
						} 
						
						if(player.currentTime >= _duration){
							sendNotification(NotificationType.DO_REPLAY);
							//sendNotification(NotificationType.DO_SEEK,0);
							player.addEventListener(TimeEvent.COMPLETE, onTimeComplete);
							
						}
						
						//if we did intelligent seek and reach the end of the movie we must load the new url
						//back form 0 before we can play
						if(_loadMediaOnPlay)
						{
							_loadMediaOnPlay = false;
							_mediaProxy.prepareMediaElement(0);
							_mediaProxy.vo.singleAutoPlay = true;
							return;		
						}
						playContent();
					}
					else //not playable
					{
						//if we play image that not support duration we should act like we play somthing static
						if(	_mediaProxy.vo.entry is KalturaMediaEntry && _mediaProxy.vo.entry.mediaType==KalturaMediaType.IMAGE)				
							sendNotification( NotificationType.PLAYER_PLAYED);	
					}
					
					break;
				
				case LiveStreamCommand.LIVE_STREAM_READY: 
					//this means that this is a live stream and it is broadcasting now
					cleanMedia();
					_mediaProxy.vo.isOffline = false;
					if (_flashvars.autoPlay=="true" ||  _mediaProxy.vo.singleAutoPlay) {
						sendNotification(NotificationType.DO_PLAY);
						_mediaProxy.vo.singleAutoPlay = false;
					}
					break;
				case NotificationType.CLEAN_MEDIA:
					cleanMedia();
					break;
				case NotificationType.DO_SWITCH:
					var preferedFlavorBR:int = int(note.getBody());
					
					if(player.isDynamicStream) // rtmp adaptive mbr
					{
						//we need to set the mediaProxy prefered 
						
						//i have added it only here because it happen in CHANGE_MEDIA as well
						var dynamicStreamTrait : DynamicStreamTrait;
						if (player.media.hasTrait(MediaTraitType.DYNAMIC_STREAM))
						{
							dynamicStreamTrait = player.media.getTrait(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait;
						}
						if (dynamicStreamTrait && !dynamicStreamTrait.switching)
						{		
							if (preferedFlavorBR == -1)
							{
								//If we switch to Auto Mode just enable it							
								KTrace.getInstance().log("Enable Auto Switch");
								_mediaProxy.vo.autoSwitchFlavors = player.autoDynamicStreamSwitch = true;
							}
							else 
							{
								_mediaProxy.vo.autoSwitchFlavors = player.autoDynamicStreamSwitch = false;
								KTrace.getInstance().log("Disable Auto Switch");
								KTrace.getInstance().log("Found stream index:", foundStreamIndex);
								KTrace.getInstance().log("Current stream index: ", player.currentDynamicStreamIndex);
								
								var foundStreamIndex:int = kMediaPlayer.findStreamByBitrate(preferedFlavorBR);
								if (foundStreamIndex != player.currentDynamicStreamIndex)
								{				
									_doSwitchSent = true;
									if (player.currentDynamicStreamIndex != foundStreamIndex)
									{
										player.switchDynamicStreamIndex(foundStreamIndex);
									}
									sendNotification( NotificationType.SWITCHING_CHANGE_STARTED, {newIndex: foundStreamIndex, newBitrate: foundStreamIndex != -1 ? player.getBitrateForDynamicStreamIndex(foundStreamIndex): null} );
								}
							}
	
						}
					}
					else // change media
					{
						_mediaProxy.vo.singleAutoPlay = true;
						_mediaProxy.vo.isFlavorSwitching = true;
						sendNotification( NotificationType.CHANGE_MEDIA, {entryId: _mediaProxy.vo.entry.id, flavorId: null, preferedFlavorBR: preferedFlavorBR });
					}
					break;
				case NotificationType.DO_STOP: //when the player asked to stop
					sendNotification( NotificationType.DO_PAUSE );
					sendNotification( NotificationType.DO_SEEK , 0 );
					break;
				case NotificationType.DO_PAUSE: //when the player asked to pause
					_prevState = PAUSED;
					if(player && player.media && player.media.hasTrait(MediaTraitType.PLAY) )
					{
						if (player.canPause)
						{
							player.pause();
						}
						if (_mediaProxy.vo.entry is KalturaLiveStreamEntry || _mediaProxy.vo.deliveryType == StreamerType.LIVE)
						{
							//requires to stop the playTrait directly
							if (player.media is ParallelElement)
							{
								var mainMedia:MediaElement = (player.media as ParallelElement).getChildAt(0) as MediaElement;
								var playTrait:PlayTrait = mainMedia.getTrait(MediaTraitType.PLAY) as PlayTrait;
								if (playTrait)
								{
									playTrait.stop();
									_useParallelElement = true;
								}
							}
							else
							{
								player.stop();
							}
						}
					}
					break;
				case NotificationType.DO_SEEK: //when the player asked to seek
					
					if (player.state != MediaPlayerState.PAUSED && player.currentTime < _duration)
					{
						_mediaProxy.vo.singleAutoPlay = true;
						_prevState = PLAYING;
					}
					else
					{
						_mediaProxy.vo.singleAutoPlay = false;
						_prevState = PAUSED;
					}
					
					var seekTo : Number = Number(note.getBody());
					//check if we have free preview and we ask to seek to later time
					//we should not allow the seek. 
					if( _mediaProxy.vo.entryExtraData && 
						!_mediaProxy.vo.entryExtraData.isAdmin && 
						_mediaProxy.vo.entryExtraData.isSessionRestricted &&
						_mediaProxy.vo.entryExtraData.previewLength != -1 &&
						_mediaProxy.vo.entryExtraData.previewLength <= Number(note.getBody()))
					{
						return;
					}
					if (!player.canSeek) 
					{
						//if doSeek was sent before first play, we should initiate the play
						if (!_hasPlayed && _mediaProxy.vo.mediaPlayFrom == -1)
						{
							_offset = seekTo;
							_isPrePlaySeek = true;
							_isPrePlaySeekInProgress = true;
							_pausedPending = true;
							sendNotification(NotificationType.DO_PLAY);
						}
						return;
					}
					
					if(_mediaProxy.vo.deliveryType!=StreamerType.HTTP || (_flashvars.ignoreStreamerTypeForSeek && _flashvars.ignoreStreamerTypeForSeek == "true"))
					{
						
						if(player.canSeek) player.seek( Number(note.getBody())  );
						return;	
					}
						
					if ( (_mediaProxy.vo.entry is KalturaMixEntry) ||
						(seekTo <= _loadedTime  && !_isIntelliSeeking))
					{
						if(player.canSeek) player.seek(seekTo); 
						
					}
					else //do intlliseek
					{	
						//cannot intelliseek in this case
						if(!_mediaProxy.vo.keyframeValuesArray) return;
						
						
						//on a new seek we can reset the load media on play flag
						_loadMediaOnPlay = false;
						//if we should pause immediately after we get into "playing" state
						if (_prevState == PAUSED)
						{
							_pausedPending = true;
						}
						else
						{
							_pausedPending = false;
						}
						doIntelliSeek(seekTo);
					}
					
					break;
				
				case NotificationType.CHANGE_VOLUME:  //when the player asked to set new volume point
					kMediaPlayer.volume = ( Number(note.getBody()) ); 
					break;
				
				case NotificationType.VOLUME_CHANGED_END: //change volume process ended, save to cookie if possible
					var volumeCookie : SharedObject;
					try
					{
						volumeCookie= SharedObject.getLocal("KalturaVolume");
					}
					catch (e : Error)
					{
						KTrace.getInstance().log("No access to user's file system");
					}
					if (volumeCookie)
					{
						volumeCookie.data.volume = kMediaPlayer.volume;
						volumeCookie.flush();
					}
					break;
				
				case NotificationType.KDP_READY:
				case NotificationType.KDP_EMPTY:
					var preloaderMediator : BufferAnimationMediator = facade.retrieveMediator( BufferAnimationMediator.NAME ) as BufferAnimationMediator;
					kMediaPlayer.bufferSprite = preloaderMediator.spinner; 
					if(_autoMute)
					{
						sendNotification(NotificationType.CHANGE_VOLUME, 0);	
					}
					break;
				
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					if (_flashvars.maxAllowedFSBitrate && player.isDynamicStream) player.maxAllowedDynamicStreamIndex = kMediaPlayer.findStreamByBitrate( _flashvars.maxAllowedFSBitrate );
					break;
				
				case NotificationType.HAS_CLOSED_FULL_SCREEN:
					if (_flashvars.maxAllowedRegularBitrate && player.isDynamicStream) player.maxAllowedDynamicStreamIndex = kMediaPlayer.findStreamByBitrate( _flashvars.maxAllowedRegularBitrate );
					break;
				
				case NotificationType.OPEN_FULL_SCREEN:
					
					if (_mediaProxy.vo.entry.mediaType == KalturaMediaType.IMAGE)
					{
						_mediaProxy.vo.entry.width=0;
						_mediaProxy.vo.entry.height=0;
						_mediaProxy.prepareMediaElement();
						kMediaPlayer.hideThumbnail();
						player.media = _mediaProxy.vo.media;
					}
					
					break;
				
				case NotificationType.VIDEO_METADATA_RECEIVED:
					//try to pre play seek only after we received video metadata and know if we can intelli seek
					if (!_sequenceProxy.vo.isInSequence &&_isPrePlaySeek)
					{
						//for rtmp the seek will be performed after player is in "playing" state
						if (_mediaProxy.vo.deliveryType == StreamerType.HTTP && _mediaProxy.vo.keyframeValuesArray)
						{
							doIntelliSeek(_offset);
						}		
						_isPrePlaySeek = false;
					}
					break;

			}
		}
		
		/**
		 * intelli seek to the given value
		 * set the given value as _offset 
		 * @param value
		 * 
		 */		
		private function doIntelliSeek(value:Number):void
		{	
			_isIntelliSeeking = true;
			_offset = value;
			//_seekUrl=_mediaProxy.convertToIntSeek(_url,_offset)
			//_mediaProxy.vo.entry.dataUrl=_seekUrl;
			_mediaProxy.prepareMediaElement( _offset);
			_mediaProxy.loadWithMediaReady();
			_intelliSeekStart = _offset;
			sendNotification( NotificationType.INTELLI_SEEK,{intelliseekTo: _offset} );
		}
		
		/**
		 * Get a reference to the kMediaPlayer
		 * @return 
		 * 
		 */	
		public function get kMediaPlayer():KMediaPlayer
		{
			return (viewComponent as KMediaPlayer);	
		}
		
		/**
		 * Get a reference to the OSMF player (inner event dispatcher of the KMediaPlayer)
		 * @return 
		 * 
		 */		
		public function get player():MediaPlayer
		{
			return (viewComponent as KMediaPlayer).player;	
		}
		
		/**
		 * Play the media in the player. 
		 * 
		 */		
		public function playContent() : void
		{
			if (player.canPlay)
			{
				//fixes a bug with Wowza and live stream: resume doesn't work, we should re-load the media
				if ( (_mediaProxy.vo.entry is KalturaLiveStreamEntry || _mediaProxy.vo.deliveryType == StreamerType.LIVE)
					&& (_flashvars.reloadOnPlayLS && _flashvars.reloadOnPlayLS == "true")
					&& _prevState == PAUSED
					&& !_reloadingLiveStream)
				{
					_reloadingLiveStream = true;
					_mediaProxy.prepareMediaElement();
					_mediaProxy.loadWithMediaReady();			
				}
				else if (_useParallelElement && (player.media is ParallelElement))
				{
					var mainMedia:MediaElement = (player.media as ParallelElement).getChildAt(0) as MediaElement;
					var playTrait:PlayTrait = mainMedia.getTrait(MediaTraitType.PLAY) as PlayTrait;
					if (playTrait)
						playTrait.play();
					
					_useParallelElement = false;
				}
				else
				{
					player.play();
				}
			}
		}
		
		/**
		 * Sets the  MediaElement of the player.
		 * 
		 */		
		public function setSource() : void
		{
			if(_mediaProxy.vo && _mediaProxy.vo.media)
			{
				player.media = _mediaProxy.vo.media; //set the current media to the player	
			}	
			
			
			if(player.state != MediaPlayerState.PLAYING)
			{
				if( _mediaProxy.vo.entryExtraData && !_mediaProxy.vo.entryExtraData.isAdmin && 
					(_mediaProxy.vo.entryExtraData.isCountryRestricted ||
						!_mediaProxy.vo.entryExtraData.isScheduledNow ||
						_mediaProxy.vo.entryExtraData.isSiteRestricted ||
						(_mediaProxy.vo.entryExtraData.isSessionRestricted && _mediaProxy.vo.entryExtraData.previewLength <= 0)))
				{
					_blockThumb = true;
				}
				else
				{
					_blockThumb = false;
				}
			}
			
		}
		
		
		//private functions
		////////////////////////////////////////////
		
		/**
		 * describe the current state of the Media Player. 
		 * @param event
		 * 
		 */		
		private function onPlayerStateChange( event : MediaPlayerStateChangeEvent ) : void
		{	
			sendNotification( NotificationType.PLAYER_STATE_CHANGE , event.state );

			switch( event.state )
			{
				case MediaPlayerState.LOADING:
					
					// The following if-statement provides a work-around for using the mediaPlayFrom parameter for http-streaming content. Currently
					//  a bug exists in the Akamai Advanced Streaming plugin which prevents a more straight-forward implementation.
					if ( !_sequenceProxy.vo.isInSequence && _mediaProxy.vo.deliveryType == StreamerType.HDNETWORK)
					{
						
						if (_mediaProxy.vo.mediaPlayFrom)
						{
							player.addEventListener(MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE, onCanSeekChange);
						}
						
					}
					break;
				case MediaPlayerState.READY: 
					if(! player.hasEventListener(TimeEvent.COMPLETE))
						player.addEventListener( TimeEvent.COMPLETE , onTimeComplete );
					
					if(!_playerReadyOrEmptyFlag)
					{
						_playerReadyOrEmptyFlag = true;
						var playerStatusProxy : PlayerStatusProxy = facade.retrieveProxy(PlayerStatusProxy.NAME) as PlayerStatusProxy;	
					}
					else
					{
						sendNotification( NotificationType.PLAYER_READY ); 
					}
					
					_mediaProxy.loadComplete();
					//sendNotification(NotificationType.MEDIA_READY, {entryId: _mediaProxy.vo.entry.id});
					break;
				case MediaPlayerState.PAUSED:
					sendNotification( NotificationType.PLAYER_PAUSED );	
					break;
				
				case MediaPlayerState.PLAYING: 
					if(!_hasPlayed){
						_hasPlayed = true;
						if (_flashvars.maxAllowedRegularBitrate && player.isDynamicStream) player.maxAllowedDynamicStreamIndex = kMediaPlayer.findStreamByBitrate( _flashvars.maxAllowedRegularBitrate );
					}
					
					if (player.media != null && !_sequenceProxy.vo.isInSequence)
					{	
						if (_mediaStartPlayFrom != -1)
						{
							if (canStartClip( _mediaStartPlayFrom )) 
							{
								if (_mediaProxy.vo.deliveryType == StreamerType.HDNETWORK)
								{
									setTimeout(seekToOffset, 1, _mediaStartPlayFrom);
								}
								else
								{
									player.seek(_mediaStartPlayFrom);
								}
								_mediaStartPlayFrom = -1;
							}
						}
						else if (_mediaProxy.vo.mediaPlayFrom != -1)
						{
							//special cases in plugins that handle the playback their own: hd akamai, uplynk
							if (_mediaProxy.vo.deliveryType != StreamerType.HDNETWORK &&
								!(_mediaProxy.vo.deliveryType == StreamerType.HTTP && (_flashvars.ignoreStreamerTypeForSeek && _flashvars.ignoreStreamerTypeForSeek == "true")))
							{
								if ( canStartClip( _mediaProxy.vo.mediaPlayFrom ) )
								{
									startClip();
									break;
								}
								//handle bug where the video metadata arrives after video starts to play
								else if (!_mediaProxy.vo.keyframeValuesArray && _mediaProxy.vo.deliveryType == StreamerType.HTTP)
								{
									_metadataTimer = new Timer(100);
									_metadataTimer.addEventListener(TimerEvent.TIMER, onMetadataTimer);
									_metadataTimer.start();
									break;
								}
							}
							else if (player.canSeek)
							{
								setTimeout(startClip, 1);
								break;
							}
						}
					}

					if(player.isDynamicStream && !_sequenceProxy.vo.isInSequence && !_doSwitchSent)
					{
						//If the player is playing RTMP content and the user switched bitrates before the entry started playing
						// it causes a OSMF bug.  the bug is fixed by saving the switch until the play button is pressed
						/*if(_mediaProxy.vo.switchDue)
						{
							_mediaProxy.vo.switchDue = false;
							sendNotification(NotificationType.DO_SWITCH, _mediaProxy.vo.preferedFlavorBR);
						}*/
						
						_mediaProxy.vo.autoSwitchFlavors = player.autoDynamicStreamSwitch = true;
					}

					KTrace.getInstance().log("current index:",player.currentDynamicStreamIndex);
					sendNotification( NotificationType.PLAYER_PLAYED );
					
					if (_pausedPending)
					{
						sendNotification(NotificationType.DO_PAUSE);
						_pausedPending = false;
						_prevState = "";
					}
				
					//the movie started, pre play seek has now ended.
					if (_isPrePlaySeekInProgress)
					{
						
						if (_mediaProxy.vo.deliveryType != StreamerType.HTTP && player.canSeek)
						{
							//fix a bug with akamai HD plugin, we can't call player.seek immediately
							if (_mediaProxy.vo.deliveryType == StreamerType.HDNETWORK)
								setTimeout(seekToOffset, 1, _offset);
							
							else
								player.seek(_offset);

							//in case we will have preroll this will save the starting point
							_mediaStartPlayFrom = _offset;
						}
						_isPrePlaySeekInProgress = false;
					}
				
					if (_reloadingLiveStream)
						_reloadingLiveStream = false;
					
					break;
				case MediaPlayerState.PLAYBACK_ERROR:
					if (_flashvars.debugMode == "true")
					{
						KTrace.getInstance().log("KMediaPlayerMediator :: onPlayerStateChange >> osmf mediaplayer playback error.");
					}
					break;
			}
		}
		
		/**
		 * will call player.seek to  _mediaStartPlayFrom value
		 * Fixes a bug with seek and HDNetwork - we have to call seek with setTimout
		 * 
		 */		
		private function seekToOffset(value:Number):void {
			player.seek(value);
		}
		
		private function onMetadataTimer(event:TimerEvent):void {
			if (_mediaProxy.vo.keyframeValuesArray)
			{
				_metadataTimer.stop();
				_metadataTimer.removeEventListener(TimerEvent.TIMER, onMetadataTimer);
				startClip();
			}
		}
		
		
		private function canStartClip(startTime : Number) : Boolean
		{			
			if(_mediaProxy.vo.deliveryType!=StreamerType.HTTP)
			{
				
				if(player.canSeek)
				{
					return true;	
				}
			}
			
			
			if ( (_mediaProxy.vo.entry is KalturaMixEntry) ||
				(startTime <= _loadedTime  && !_isIntelliSeeking))
			{
				if(player.canSeek) 
				{
					return true;
				}
				
			}
			else //check if intelliseek is possible
			{		 
				if(_mediaProxy.vo.keyframeValuesArray)
				{
					return true;
				}
			}
			
			return false;
		}
		
		//////////////////////////////////////////////////////////
		/* The following block of code is a work-around for */
		/* using the mediaPlayFrom parameter for http-streaming
		* content. It will be removed when the Akamai Advanced
		* streaming plugin will be fixed to support this scenario.*/
		
		private function onCanSeekChange(event:MediaPlayerCapabilityChangeEvent):void
		{	
			//player.removeEventListener (MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE, onCanSeekChange);
			if (player.media != null && _mediaProxy.vo.mediaPlayFrom!=-1 && player.canSeek)
			{		
				if (_mediaProxy.vo.deliveryType == StreamerType.HDNETWORK)
				{
					
					setTimeout(startClip, 100 );
				}
			}
			
		}
		
		private function onDynamicStreamChange (e : MediaPlayerCapabilityChangeEvent): void
		{
			if(_mediaProxy.vo.switchDue && e.enabled)
			{
				_mediaProxy.vo.switchDue = false;
				sendNotification(NotificationType.DO_SWITCH, _mediaProxy.vo.preferedFlavorBR);
			}
		}
		
		private function startClip () : void
		{
			if (_mediaProxy.vo.mediaPlayFrom != -1)
			{
				var temp : Number = _mediaProxy.vo.mediaPlayFrom;
				_mediaProxy.vo.mediaPlayFrom = -1;
				sendNotification( NotificationType.DO_SEEK, temp );
				
			}
		}
		//////////////////////////////////////////////////////////////////////
		
		
		
		/**
		 * Dispatched when a MediaPlayer's ability to expose its media as a DisplayObject has changed
		 * @param event
		 * 
		 */		
		private function onViewableChange( event : DisplayObjectEvent ) : void
		{
			sendNotification( NotificationType.MEDIA_VIEWABLE_CHANGE );
		}
		
		/**
		 * dispatches when the player width and/or  height properties have changed. 
		 * @param event
		 * 
		 */		
		private function  onMediaSizeChange( event : DisplayObjectEvent ) :void
		{
			//deprecated
			//	if(_flashvars.sourceType==SourceType.URL)
			//		kMediaPlayer.setContentDimension(event.newWidth, event.newHeight);
			
			kMediaPlayer.validateNow();
		}
		
		/**
		 * A MediaPlayer dispatches this event when its playhead property has changed. 
		 * This value is updated at the interval set by the MediaPlayer's playheadUpdateInterval property.  
		 * @param event
		 * 
		 */		
		private function onPlayHeadChange( event : TimeEvent ) : void
		{
			
			if (player.temporal && !isNaN(event.time))
			{
				sendNotification( NotificationType.PLAYER_UPDATE_PLAYHEAD , event.time );
			
				if (_sequenceProxy.vo.isInSequence)
				{
					var duration : Number = (player.media.getTrait(MediaTraitType.TIME) as TimeTrait).duration;
					_sequenceProxy.vo.timeRemaining = (!isNaN(event.time) && Math.round(duration - event.time) > 0) ? Math.round(duration - event.time) : 0;	
				}
				if( !isNaN(event.time) )
				{
					_currentTime=event.time;
				}
				
				if (_mediaProxy.vo.mediaPlayTo != -1)
				{
					if (_mediaProxy.vo.mediaPlayTo <= event.time)
					{
						_mediaProxy.vo.mediaPlayTo = -1;
						sendNotification(NotificationType.DO_PAUSE );
					}
				}
				
				if( _mediaProxy.vo.entryExtraData && 
					!_mediaProxy.vo.entryExtraData.isAdmin && 
					_mediaProxy.vo.entryExtraData.isSessionRestricted && 
					_mediaProxy.vo.entryExtraData.previewLength != -1 &&
					(_mediaProxy.vo.entryExtraData.previewLength-0.2) <= event.time &&
					!_sequenceProxy.vo.isInSequence &&
					!_alertCalled)
				{
					_alertCalled = true;
					//pause the player
					sendNotification( NotificationType.DO_PAUSE );
					
					//show alert
					sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('FREE_PREVIEW_END'), title: MessageStrings.getString('FREE_PREVIEW_END_TITLE')} );
					//call the page with the entry is in sig
					//var extProxy : ExternalInterfaceProxy = facade.retrieveProxy( ExternalInterfaceProxy.NAME ) as ExternalInterfaceProxy;
					sendNotification( NotificationType.FREE_PREVIEW_END , _mediaProxy.vo.entry.id );
					//disable GUI
					sendNotification( NotificationType.ENABLE_GUI , {guiEnabled : false , enableType : EnableType.CONTROLS} );
					
				}
			}
		}
		
		
		/**
		 * A trait that implements the IAudible interface dispatches this event when its volume property has changed.  
		 * @param event
		 * 
		 */		
		private function onVolumeChangeEvent( event : AudioEvent ) : void
		{
			sendNotification( NotificationType.VOLUME_CHANGED , {newVolume:event.volume});
			if (event.volume==0 && _prevVolume!=0)
				sendNotification(NotificationType.MUTE);
			else if (event.volume!=0 && _prevVolume==0)
				sendNotification(NotificationType.UNMUTE);
			
			_prevVolume = event.volume;
			
		}
		
		/**
		 * Dispatch the old time and the new time of the buffering 
		 * @param event
		 * 
		 */		
		private function onBufferTimeChange( event : BufferEvent ) : void
		{
			sendNotification( NotificationType.BUFFER_PROGRESS , {newTime:event.bufferTime} );
		}
		
		/**
		 * When the player start or stop the buffering 
		 * @param event
		 * 
		 */		
		private function onBufferingChange( event : BufferEvent ) : void
		{
			sendNotification( NotificationType.BUFFER_CHANGE , event.buffering );
		}
		/**
		 * The current and previous value of bytesDownloaded dispatches this event when bytes currently downloaded change 
		 * @param event
		 * 
		 */		
		private function onBytesDownloadedChange( event : LoadEvent ) : void
		{
			_bytesLoaded=event.bytes;
			_loadedTime=(_bytesLoaded/_bytesTotal)*_duration;
			sendNotification( NotificationType.BYTES_DOWNLOADED_CHANGE , {newValue:event.bytes} );
		}
		
		/**
		 * dispatched by a concrete implementation of IDownloadable when the value of the property "bytesTotal" has changed. 
		 * @param event
		 * 
		 */		
		private function onBytesTotalChange( event : LoadEvent ) : void
		{
			_bytesTotal=event.bytes;
			sendNotification( NotificationType.BYTES_TOTAL_CHANGE , {newValue:event.bytes} );
		}
		
		/**
		 * A trait that implements the ITemporal interface dispatches this event when its duration property has changed
		 * @param event
		 * 
		 */		
		private function onDurationChange( event : TimeEvent ) : void
		{
			//don't change duration on intelliseek, only if we are playing an ad
			if (_isIntelliSeeking)
			{
				if (_sequenceProxy.vo.isInSequence)
				{
					sendNotification( NotificationType.DURATION_CHANGE , {newValue:event.time});
				}
				else
				{
					sendNotification( NotificationType.DURATION_CHANGE , {newValue:_entryDuration});
				}
			}
			else if(event.time)
			{
				_duration=event.time
				sendNotification( NotificationType.DURATION_CHANGE , {newValue:_duration});
				//save entryDuration in case we will go into intelliseek and need to use it.
				if (!_sequenceProxy.vo.isInSequence)
					_entryDuration = _duration;
			}
			
			
		}
		/**
		 * Dispatched when the position  of a trait that implements the ITemporal interface first matches its duration. 
		 * @param event
		 * 
		 */		
		private function onTimeComplete( event : TimeEvent ) : void
		{
			if(event.type == TimeEvent.COMPLETE)
			{
				player.removeEventListener(TimeEvent.COMPLETE, onTimeComplete);
				if( _isIntelliSeeking && !_sequenceProxy.vo.isInSequence ){
					_isIntelliSeeking = false;
					_loadedTime=0;
					_loadMediaOnPlay = true;
				}	
				
				sendNotification(NotificationType.PLAYBACK_COMPLETE);
						
			}

		}
		/**
		 * A MediaElement dispatches a MediaErrorEvent when it encounters an error.  
		 * @param event
		 * 
		 */		
		private function onMediaError( event : MediaErrorEvent ) : void
		{
			sendNotification( NotificationType.MEDIA_ERROR , {errorEvent: event} );
		}
	
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onSwitchingChange( event : DynamicStreamEvent ) : void
		{
			KTrace.getInstance().log("DynamicStreamEvent ===> " , event.type , player.currentDynamicStreamIndex);

			if (!event.switching)
			{
				sendNotification( NotificationType.SWITCHING_CHANGE_COMPLETE, {newIndex : player.currentDynamicStreamIndex, newBitrate: player.getBitrateForDynamicStreamIndex(player.currentDynamicStreamIndex)}  );
			}
			else if (player.autoDynamicStreamSwitch)
			{
				sendNotification( NotificationType.SWITCHING_CHANGE_STARTED, {currentIndex : player.currentDynamicStreamIndex, currentBitrate: player.getBitrateForDynamicStreamIndex(player.currentDynamicStreamIndex)});
			}
		}
		
		/**
		 * Function which removed the current media element from the 
		 * OSMF media player.
		 * 
		 */		
		public function cleanMedia():void
		{
			//we don't need to clean the media if it's empty	
			if(!player.media) return;
			
			if (player.media.hasOwnProperty("cleanMedia"))
				sendNotification( NotificationType.DO_STOP );
			
			if(player.displayObject)
			{
				player.displayObject.height=0;////this is for clear the former clip...
				player.displayObject.width=0;///this is for clear the former clip...
			}
			
			
			player.media = null;
		}
		
		/**
		 * reference to the player container 
		 * @return 
		 * 
		 */		
		public function get playerContainer () : DisplayObjectContainer
		{
			return viewComponent as DisplayObjectContainer;	
		}
		
		
		public function get isIntelliSeeking():Boolean
		{
			return _isIntelliSeeking;
		}
		
	
	}
}