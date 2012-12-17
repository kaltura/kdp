package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.types.KalturaMediaType;
	import com.kaltura.vo.KalturaMediaEntry;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class BitrateDetectionMediator extends Mediator
	{
		public static var NAME:String = "bitrateDetectionMediator";	
		/**
		 * Flag indicating autoPlay flashvar was true 
		 */		
		private var _wasAutoPlay:Boolean = false;
		/**
		 * Flag indicating singleAutoPlay was true 
		 */		
		private var _wasSingleAutoPlay:Boolean = false;
		/**
		 * The url loader 
		 */		
		private var _loader:Loader;
		/**
		 * average download speed 
		 */		
		private var _avgSpeed:Number = 0;
		/**
		 * counter for progress events, will be used to calculate average speed 
		 */		
		private var _progressCount:int;
		/**
		 * timer for the download process 
		 */		
		private var _downloadTimer:Timer;
		/**
		 * startTime of the download process 
		 */		
		private var _startTime:Number;
		/**
		 * Indicating if player has already played  
		 */		
		private var _playedPlayed:Boolean = false;
		
		private var _configProxy:ConfigProxy;
		
		private var _prevTime:Number;
		private var _prevBytesLoaded:int;
		private var _forceBitrate:int;
		private var _viewComp:bitrateDetectionPluginCode;
		
		private var _executed:Boolean;
		
		public function BitrateDetectionMediator(viewComponentObject:Object = null , forceBitrate:int = 0)
		{
			_forceBitrate = forceBitrate;
			_viewComp = viewComponentObject as bitrateDetectionPluginCode;
			super(NAME, viewComponentObject);
		}
		
		override public function listNotificationInterests():Array 
		{
			return [
				NotificationType.READY_TO_PLAY,
				NotificationType.PLAYER_PLAYED
				];
		}
		 
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationType.READY_TO_PLAY:
					//perform BW check once per player
					if (_executed)
						return;
					_executed = true;
					
					var mediaProxy:MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
					if (!mediaProxy.vo.entry || 
						((mediaProxy.vo.entry is KalturaMediaEntry) && (int(mediaProxy.vo.entry.mediaType)==KalturaMediaType.IMAGE)))
						return;
					
					if (_viewComp.runPreCheck)
					{
						if (mediaProxy.vo.kalturaMediaFlavorArray && mediaProxy.vo.kalturaMediaFlavorArray.length)
						{
							var highBR:int = mediaProxy.vo.kalturaMediaFlavorArray[mediaProxy.vo.kalturaMediaFlavorArray.length - 1].bitrate;
							if (0.8 * highBR <= mediaProxy.vo.preferedFlavorBR)  
							{
								trace ("--bitrate detection: no BW CHECK");
								//// if the last preferred bitrate is higher or equals (with 20% error range) to the current highest bitrate, 
								//no need to perform BW check
								return;
							}
						}
					}
					_configProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					startDownload();
					break;
				case NotificationType.PLAYER_PLAYED:
					_playedPlayed = true;
					break;
			}
		}
		
		/**
		 * Start a download process to find the preferred bitrate 
		 * 
		 */		
		public function startDownload() : void 
		{
			trace ("--bitrate detection: start download");
			if (!_viewComp.downloadUrl)
				return;

			var mediaProxy:MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			//disable autoPlay - will change it back once the bitrate detection will finish
			if (_configProxy.vo.flashvars.autoPlay == "true")
			{
				trace ("--bitrate detection: was auto play");
				_configProxy.vo.flashvars.autoPlay = "false";
				_wasAutoPlay = true;
			}
			if (mediaProxy.vo.singleAutoPlay) 
			{
				mediaProxy.vo.singleAutoPlay = false;
				_wasSingleAutoPlay = true;
			}
			_startTime = ( new Date( ) ).getTime( );	
			_progressCount = 0;
			_prevTime = _startTime;
			_prevBytesLoaded = 0;
			_loader = new Loader( );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, downloadComplete );
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			_downloadTimer = new Timer (_viewComp.downloadTimeoutMS, 1);
			_downloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			sendNotification(NotificationType.ENABLE_GUI, {guiEnabled: false, enableType: EnableType.FULL});
			sendNotification( NotificationType.SWITCHING_CHANGE_STARTED, {newIndex: -2,  newBitrate: null});  
			_loader.load( new URLRequest( _viewComp.downloadUrl + "?" + ( Math.random( ) * 100000 )) );
			_downloadTimer.start();
		}
		
		/**
		 * on download progress- calculate average speed
		 * @param event
		 * 
		 */		
		private function onProgress (event:ProgressEvent):void 
		{
			var curTime:Number = ( new Date( ) ).getTime( );
			_progressCount++;
			if (event.bytesLoaded!=0) 
			{
				var totalTime:Number =( curTime - _startTime ) / 1000;
				var totalKB:Number = event.bytesLoaded / 1024;
				_avgSpeed = totalKB / totalTime;
			}
			_prevTime = curTime;
			_prevBytesLoaded = event.bytesLoaded;
		}
		
		/**
		 *  download complete handler - set the preferred bitrate, enable GUI
		 * 
		 */		
		private function downloadComplete( e:Event = null):void
		{
			_downloadTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onProgress );
			
			var bitrateVal:int = _avgSpeed * 8;
			trace("--preferred bitrate for bitrate detection plugin:", bitrateVal);
			
			//for debugging - force a bitrate value to override the calculated one
			if(_forceBitrate > 0)
			{
				bitrateVal = _forceBitrate;
			}

			sendNotification(NotificationType.CHANGE_PREFERRED_BITRATE, {bitrate: bitrateVal});
		
			finishDownloadProcess();	
		}
		
		/**
		 * default timer time has passed, stop listening to progress event and continue the flow 
		 * @param event
		 * 
		 */		
		private function onTimerComplete (event:TimerEvent):void {
			downloadComplete();
		}
		
		/**
		 * I/O error getting the sample file, release the UI 
		 * @param event
		 * 
		 */		
		private function ioErrorHandler(event:IOErrorEvent) : void 
		{
			//Bypass: ignore #2124 error (loaded file is an unknown type)
			if (!event.text || event.text.indexOf("Error #2124")==-1)
			{
				trace ("--bitrate detection i/o error:", event.text);				
				finishDownloadProcess();
			}
		}
		
		/**
		 * enable back the GUI.
		 * call Do_Play if we were in auto play and set back relevant flashvars 
		 * 
		 */		
		private function finishDownloadProcess():void {
			//if we changed variables, set them back
			if (_wasAutoPlay || _wasSingleAutoPlay) {
				var mediaProxy:MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
				var sequenceProxy:SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
				if (_wasAutoPlay) 
				{	
					_configProxy.vo.flashvars.autoPlay = "true";	
				}
				else 
				{
					mediaProxy.vo.singleAutoPlay = true;
				}
				//play if we should have played
				if (!_playedPlayed && !mediaProxy.vo.isMediaDisabled && !sequenceProxy.vo.isInSequence) 
				{		
					sendNotification(NotificationType.DO_PLAY);	
				}
			}
		
			sendNotification(NotificationType.ENABLE_GUI, {guiEnabled: true, enableType: EnableType.FULL});
		}
		
	
	}
	
}