/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundLoaderContext;
	import com.yahoo.astra.fl.controls.mediaPlayerClasses.IMediaClip;
	import flash.net.URLRequest;	
	import fl.core.UIComponent;    
	import com.yahoo.astra.fl.events.MediaEvent;
	import flash.utils.Timer;
	import flash.display.DisplayObjectContainer;
	
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     * Dispatched when on an interval while the clip is playing.
     *
     * @eventType com.yahoo.astra.fl.events.MediaEvent.MEDIA_POSITION
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	*/
    [Event(name="mediaPosition", type="com.yahoo.astra.fl.events.MediaEvent")]
	
    /**
     * Dispatched when the clip is paused or played.
     * 
     * @eventType com.yahoo.astra.fl.events.MediaEvent.MEDIA_PLAY_PAUSE
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Event(name="mediaPlayPause", type="com.yahoo.astra.fl.events.MediaEvent")]
	
    /**
     * Dispatched when the volume level is changed.
     *
     * @eventType com.yahoo.astra.fl.events.MediaEvent.VOLUME_CHANGE
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Event(name="volumeChange", type="com.yahoo.astra.fl.events.MediaEvent")]
	
    /**
     * Dispatched when the id3 event is received.
     *
     * @eventType com.yahoo.astra.fl.events.MediaEvent.INFO_CHANGE
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */	
	[Event(name="infoChange", type="com.yahoo.astra.fl.events.MediaEvent")]
	
 	/**
     * Dispatched when a clip has completely loaded.
     * 
     * @eventType com.yahoo.astra.fl.events.MediaEvent.MEDIA_LOADED
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */	
	[Event(name="mediaLoaded", type="com.yahoo.astra.fl.events.MediaEvent")]
	
 	/**
     * Dispatched when a clip reaches its end point.
     * 
     * @eventType com.yahoo.astra.fl.events.MediaEvent.MEDIA_ENDED
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */	
	[Event(name="mediaEnded", type="com.yahoo.astra.fl.events.MediaEvent")]
	
	//--------------------------------------
	//  Class description
	//--------------------------------------
	
	/**	
	 * The AudioClip class extends the EventDispatcher class and wraps the 
	 * Sound, SoundChannel, SoundLoaderContext and SoundTransform classes. 
	 *
	 * @see flash.media.Sound
	 * @see flash.media.SoundChannel
	 * @see flash.media.SoundTransform
	 * @see flash.media.SoundLoaderContext
	 * @see flash.events.EventDispatcher
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	public class AudioClip extends EventDispatcher implements IMediaClip
	{

	//--------------------------------------
	//  Constructor
	//--------------------------------------		

		/**
		 * Constructor
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function AudioClip():void
		{
			super();
			_soundTransform = new SoundTransform(_volume, _panning);
			_positionTimer = new Timer(50);
			_positionTimer.addEventListener(TimerEvent.TIMER, positionUpdateHandler);
		}		
	
	//--------------------------------------
	//  Properties
	//--------------------------------------	

		/**
		 * @private (protected)
		 */
		protected var _mediaAvailable:Boolean = false;
		
		/**
		 * @private (protected)
		 */
		protected var _length:Number = 0;
		
		/**
		 * @private (protected)
		 */
		protected var  _artist:String; 

		/**
		 * @private (protected)
		 */
		protected var _title:String;
		
		/**
		 * @private (protected)
		 * The Sound object
		 */
		protected var _clip:Sound;		
		
		/**
		 * @private (protected)
		 * The SoundChannel
		 */
		protected var _channel:SoundChannel;
		
		/**
		 * @private (protected)
		 * Timer used to dispatch "mediaPosition" events.
		 */
		protected var _positionTimer:Timer;
		
		/**
		 * @private (protected)
		 * place holder for position.  
		 */
		protected var _position:Number;
		
		/**
		 * @private (protected)
		 * indicates whether the state of the clip is paused
		 */
		protected var _playing:Boolean = true;
		
		/**
		 * @private (protected)
		 * indicates whether the sound is muted
		 */
		protected var _mute:Boolean = false;
		
		/**
		 * @private (protected)
		 */
		protected var _volume:Number = 1;
		
		/**
		 * @private (protected)
		 */
		protected var _panning:Number = 0;
		
		/**
		 * @private (protected)
		 */
		protected var _soundTransform:SoundTransform;
		
		/**
		 * @private (protected)
		 */
		protected var _autoStart:Boolean = false;
		
		/**
		 * Gets the url to be used for an AudioClip (read-only)
		 */
		public function get url():String
		{
			return _clip.url;	
		}

		/**
		 * Gets or sets the position of the playhead
		 */
		public function get position():Number
		{
			return _channel.position;
		}
		
		/**
		 * @private (setter)
		 * sets the position for a clip (cues and rewinds)
		 * if the clip is paused, the _position property is set to the received value
		 * otherwise the clip is played from that position
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function set position(value:Number):void
		{	
			if(_mediaAvailable)
			{	
				_position = Math.min(value, _length);
				_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				_channel = _clip.play(_position);
				_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);				
				_channel.soundTransform = _soundTransform;
				if(!_playing) pause();
				dispatchEvent(new MediaEvent(MediaEvent.MEDIA_POSITION, false, false, _playing?Number(_channel.position.toFixed(2)):_position, _length, _soundTransform.volume, _mute));				
			}
		}
		
		/**
		 * Length of the Audio (read-only)
		 */
		public function get length():Number
		{
			return _length;	
		}	
		
		/**
		 * Boolean indicating if the audio is playing. (read-only) us pause() and play() methods to change playing
		 */
		public function get playing():Boolean
		{
			return _playing;
		}
		
		/**
		 * Gets or sets the volume, ranging from 0 (silent) to 1 (full volume).
		 */
		public function get volume():Number
		{
			return _soundTransform.volume;	
		}
		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function set volume(value:Number):void
		{
			//sets the volume property of the _soundTransform object
			//sets the _soundTransform object to the _channel
			//dispatches a VOLUME_CHANGE MediaEvent
			_soundTransform.volume = _volume = Math.max(0, Math.min(value, 1));
			_mute = false;
			if(_mediaAvailable)
			{		
				_channel.soundTransform = _soundTransform;
				dispatchEvent(new MediaEvent(MediaEvent.VOLUME_CHANGE, false, false, Number(_channel.position.toFixed(2)), _length, Number(_channel.soundTransform.volume), _mute));
			}
			else
			{
				dispatchEvent(new MediaEvent(MediaEvent.VOLUME_CHANGE, false, false, _position, 0, _soundTransform.volume, _mute));
			}
		}
		
		/** 
		 * Gets or sets the mute property of the AudioClip
		 */
		public function get mute():Boolean
		{
			return _mute;
		}			

		/**
		 * @private (setter)
		 * Sets the mute property of the audio
		 */
		public function set mute(value:Boolean):void
		{
			//sets the value of _mute
			//sets the volume of the _soundTransform object to 0 if +_mute is true and to _volume if _mute is false
			//sets the _soundTransform object to the _channel
			//dispatches a VOLUME_CHANGE MediaEvent			
			_mute = value;
			_soundTransform.volume = _mute?0:_volume;
			if(_mediaAvailable)
			{
				_channel.soundTransform = _soundTransform;
				dispatchEvent(new MediaEvent(MediaEvent.VOLUME_CHANGE, false, false, Number(_channel.position.toFixed(2)), _length, Number(_channel.soundTransform.volume), _mute));
			}
			else
			{
				dispatchEvent(new MediaEvent(MediaEvent.VOLUME_CHANGE, false, false, _position, 0, _soundTransform.volume, _mute));
			}
		}
		
		/**
		 * Gets the artist for the audio clip (read-only).  This information is available:
		 * <ul>
		 * <li>If the SWF is in the same domain as the sound file.</li>
		 * <li>If the <code>checkPolicyFile</code> property is true and there
		 * is a cross-domain policy file on the server from which the sound is 
		 * loaded that permits the domain of the loading SWF file. </li>
		 * </ul>
		 * 
		 */
		public function get artist():String
		{
			return _artist;
		}
		
		/**
		 * Gets the title of the clip (read-only).  This information is available:
		 * <ul>
		 * <li>If the SWF is in the same domain as the sound file.</li>
		 * <li>If the <code>checkPolicyFile</code> property is true and there is a cross-domain policy file on the  
		 * server from which the sound is loaded that permits the domain of the loading SWF file. </li>
		 * </ul>
		 * 
		 */
		public function get title():String
		{
			return _title;
		}
		
		/**
		 * Gets or sets the autoStart property of an AudioClip
		 */
		public function get autoStart():Boolean
		{
			return _autoStart;
		}
		
		/**
		 * @private (setter)
		 */
		public function set autoStart(value:Boolean):void
		{
			_autoStart = value;
		}
		
		/**
		 * @private (protected)
		 */
		protected var _soundLoaderContext:SoundLoaderContext;
		
		/**
		 * @private (protected)
		 */
		protected var _bufferTime:Number = 1000;
		
		/**
		 * Gets or sets buffer time. (milliseconds)
		 */
		public function get bufferTime():Number
		{
			return _bufferTime;
		}
		
		/**
		 * @private (setter)
		 */
		public function set bufferTime(value:Number):void
		{
			_bufferTime = value;
		}
		
		/**
		 * @private (protected)
		 */
		protected var _checkForPolicyFile:Boolean = true;
		
		/**
		 * Gets or sets checkForPolicyFile property of the SoundLoaderContext.  Specifies whether Flash Player should check 
		 * for the existence of a cross-domain policy file upon loading the object (true) or not.   
		 *
		 * @see flash.media.SoundLoaderContext;
		 *
		 */
		public function get checkForPolicyFile():Boolean
		{
			return _checkForPolicyFile;
		}
		
		/**
		 * @private (setter)
		 */
		public function set checkForPolicyFile(value:Boolean):void
		{
			_checkForPolicyFile = value;
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------	

		/**
		 * Loads an audio clip
		 *
		 * @param urlValue string for the location of the clip
		 * @param autoStart Boolean indicating whether the clip starts playing when it loads
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function loadMedia(urlValue:String, autoStart:Boolean = true):void
		{
			_soundLoaderContext = new SoundLoaderContext(bufferTime, checkForPolicyFile);
			_length = 0;
			_playing = autoStart;
			_mediaAvailable = true;
			_position = 0;
			var request:URLRequest = new URLRequest(urlValue);
			if(_clip != null) 
			{
				removeClipListeners(_clip);
				_positionTimer.reset();
			}
			if(_channel != null)
			{
				if(_channel.hasEventListener(Event.SOUND_COMPLETE)) _channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				_channel.stop();
			}

			_clip = new Sound();
			addClipListeners(_clip);
			
			_clip.load(request, _soundLoaderContext);				

			_channel = _clip.play();
			_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_channel.soundTransform = _soundTransform;
			_positionTimer.start();
			dispatchEvent(new MediaEvent(MediaEvent.MEDIA_POSITION, false, false, _position, _length, _channel.soundTransform.volume, _mute));
			dispatchEvent(new MediaEvent(MediaEvent.MEDIA_PLAY_PAUSE, false, false, _position, _length, _channel.soundTransform.volume, _mute));
			dispatchEvent(new MediaEvent(MediaEvent.VOLUME_CHANGE, false, false, _position, _length, _channel.soundTransform.volume, _mute));
			if(!autoStart)
			{
				pause();
				_position = 0;
			}

			//dispatchEvent(new MediaEvent(MediaEvent.MEDIA_READY));
		}
		
		/**
		 * Pauses the audio
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function pause():void
		{
			//sets pause to true
			//dispatches a MEDIA_PLAY_PAUSE event
			//calls the stop function			
			if(_mediaAvailable)
			{
				_playing = false;
				dispatchEvent(new MediaEvent(MediaEvent.MEDIA_PLAY_PAUSE, false, false, Number(_channel.position.toFixed(2)), _length, Number(_channel.soundTransform.volume), _mute));
				stop();
				_positionTimer.stop();
			}
		}	
		
		/**
		 * Plays the audio
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function play():void
		{
			//sets _playing to true
			//dispatches a MEDIA_PLAY_PAUSE event
			//set the SoundChannel object to the play method of the Sound object using the _position value
			if(_mediaAvailable)
			{
				_positionTimer.start();
				_playing = true;
				dispatchEvent(new MediaEvent(MediaEvent.MEDIA_PLAY_PAUSE, false, false, Number(_channel.position.toFixed(2)), _length, Number(_channel.soundTransform.volume), _mute));
				_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				_channel = _clip.play(_position);
				_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);	
				_channel.soundTransform = _soundTransform;			
			}

		}
						
		/**
		 * Stops the audio
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function stop():void
		{
			//sets _position to the current position of the sound object
			//calls the stop method on the SoundChannel object
			//used by pause method, to stop the playback when audio is in a paused state
			//used by the controller to stop the video while the MediaScrubber seeks			
			if(_mediaAvailable)
			{
				_position = Number(_channel.position.toFixed(2));
				_channel.stop();				
			}			
		}		
							
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------		
	
		/**
		 * @private (protected) 
		 * Dispatches a MediaEvent.MEDIA_POSITION event with the _positionTimer event
		 * @param event The TimerEvent
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function positionUpdateHandler(event:TimerEvent):void
		{
			//if paused, update with the _position value.  if not, update with the actual position of the sound channel
			dispatchEvent(new MediaEvent(MediaEvent.MEDIA_POSITION, false, false, _playing?Number(_channel.position.toFixed(2)):_position, _length, Number(_channel.soundTransform.volume), _mute));
		}

		/**
		 * @private (protected)
		 * Adds event listeners to a sound object when set clip is called.
		 * @param soundDispatcher
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function addClipListeners(soundDispatcher:Sound):void
		{
			
			soundDispatcher.addEventListener(Event.COMPLETE, completeHandler);
			soundDispatcher.addEventListener(Event.ID3, id3Handler);
			soundDispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			soundDispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

		}

		/**
		 * @private (protected)
		 * Removes listeners from the sound object before a new clip is set
		 * @param soundDispatcher
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function removeClipListeners(soundDispatcher:Sound):void
		{
			soundDispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			soundDispatcher.removeEventListener(Event.ID3, id3Handler);
			soundDispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			soundDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

		}		
		
		/**
		 * @private (protected)
		 * Resets a clip to the beginning and dispatches MediaEvent.MEDIA_POSITION and MediaEvent.MEDIA_ENDED events.
		 * @param event soundComplete event
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function soundCompleteHandler(event:Event):void
		{
			pause();
			position = 0;
			//does not always fire.  may need to add a catch in the timer to force an end
			dispatchEvent(new MediaEvent(MediaEvent.MEDIA_POSITION, false, false, _playing?Number(_channel.position.toFixed(2)):_position, _length, _soundTransform.volume, _mute));
			dispatchEvent(new MediaEvent(MediaEvent.MEDIA_ENDED, false, false, _playing?Number(_channel.position.toFixed(2)):_position, _length, _soundTransform.volume, _mute));
		}

		/**
		 * @private (protected)
		 * Dispatches a MediaEvent.MEDIA_LOADED event when the media has loaded
		 * @param event Event.COMPLETE event
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function completeHandler(event:Event):void 
		{
			_length = _clip.length;
			dispatchEvent(new MediaEvent(MediaEvent.MEDIA_LOADED));
		}

		/**
		 * @private (protected)
		 * Dispatches a MediaEvent.INFO_CHANGE event when the ID3 event is received from the Sound object
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function id3Handler(event:Event):void 
		{
			try
			{
				_title = _clip.id3.songName as String;
				_artist = _clip.id3.artist as String;
			}
			catch(e:SecurityError)
			{
				_artist = "Artist Unavailable";
				_title = "Title Unavailable";				
			}
			dispatchEvent(new MediaEvent(MediaEvent.INFO_CHANGE, false, false));
		}

		/**
		 * @private 
		 * dispatches the ProgressEvent to registered listeners
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function progressHandler(event:ProgressEvent):void 
		{
		    _length = _clip.length * (event.bytesTotal/event.bytesLoaded);
		    dispatchEvent(event);
		}
		
		/**
		 * @private 
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
				//need to reset everything here.
				_mediaAvailable = false;
				_positionTimer.stop();
				_length = 0;
				_artist = "Artist Unavailable";
				_title = "Title Unavailable";
				dispatchEvent(new MediaEvent(MediaEvent.INFO_CHANGE, false, false));			
		}
		
		public function kill():void
		{
			if(_mediaAvailable)
			{
				pause();
				dispatchEvent(new MediaEvent(MediaEvent.MEDIA_POSITION, false, false, _playing?Number(_channel.position.toFixed(2)):_position, _length, _soundTransform.volume, _mute));
				dispatchEvent(new MediaEvent(MediaEvent.MEDIA_ENDED, false, false, _playing?Number(_channel.position.toFixed(2)):_position, _length, _soundTransform.volume, _mute));				
			}				
			
		}		
	}
}



