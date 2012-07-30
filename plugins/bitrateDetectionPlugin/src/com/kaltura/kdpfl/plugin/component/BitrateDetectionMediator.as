package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.controls.KTrace;
	import com.kaltura.types.KalturaMediaType;
	import com.kaltura.vo.KalturaMediaEntry;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
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
		
		public function BitrateDetectionMediator(viewComponentObject:Object = null , forceBitrate:int = 0)
		{
			_forceBitrate = forceBitrate;
			super(NAME, viewComponentObject);
		}
		
		override public function listNotificationInterests():Array 
		{
			return [
				NotificationType.DO_SWITCH,
				NotificationType.KDP_EMPTY,
				NotificationType.KDP_READY,
				NotificationType.PLAYER_PLAYED,
				NotificationType.MEDIA_READY
				];
		}
		
		private var _bandwidth:Number = 0;
		private var _bandwidthByUser:Number = 0;
		 
		override public function handleNotification(notification:INotification):void
		{
			//check bitrate only before player played
/*			if (_playedPlayed)
			{
				return;
			}*/
			
			switch (notification.getName())
			{
				//in case the user switched the flavor manually 
				case NotificationType.DO_SWITCH:
					_bandwidthByUser = int(notification.getBody())
					break;
				case NotificationType.MEDIA_READY:
					if(_bandwidthByUser)
					{
						sendNotification(NotificationType.CHANGE_PREFERRED_BITRATE, {bitrate: _bandwidthByUser});
						return;
					}
					if(_bandwidth)
						sendNotification(NotificationType.CHANGE_PREFERRED_BITRATE, {bitrate: _bandwidth});
					break;
				case NotificationType.KDP_EMPTY:
				case NotificationType.KDP_READY:
					var mediaProxy:MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
					if (!mediaProxy.vo.entry || 
						((mediaProxy.vo.entry is KalturaMediaEntry) && (int(mediaProxy.vo.entry.mediaType)==KalturaMediaType.IMAGE)))
						break;
					trace("bitrate detection:", notification.getName());
					_configProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					if ((viewComponent as bitrateDetectionPluginCode).useFlavorCookie)
					{
						var flavorCookie : SharedObject;
						try
						{
							//Check to see if we have a cookie
							flavorCookie = SharedObject.getLocal("kaltura");
						}
						catch (e: Error)
						{
							//if not just start download
							trace ("no permissions to access partner's file system");
							startDownload();
							return;
						}
						if (flavorCookie && flavorCookie.data)
						{
							//If we are in Auto Switch or the first time we run it - do the download test
							if(!flavorCookie.data.preferedFlavorBR || (flavorCookie.data.preferedFlavorBR == -1))
							{
								startDownload();
							}
						}
					}
					//disable bitrate cookie--> start detection
					else
					{
						startDownload();
					}
					break;
				case NotificationType.PLAYER_PLAYED:
					if(_bandwidth)
						return;
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
			trace ("bitrate detection: start download");
			if (!(viewComponent as bitrateDetectionPluginCode).downloadUrl)
				return;

			var mediaProxy:MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			//disable autoPlay - will change it back once the bitrate detection will finish
			if (_configProxy.vo.flashvars.autoPlay == "true")
			{
				trace ("bitrate detection: was auto play");
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
			_downloadTimer = new Timer ((viewComponent as bitrateDetectionPluginCode).downloadTimeoutMS, 1);
			_downloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			sendNotification(NotificationType.ENABLE_GUI, {guiEnabled: false, enableType: EnableType.FULL});
			sendNotification( NotificationType.SWITCHING_CHANGE_STARTED, {newIndex: -2,  newBitrate: null});  
			_loader.load( new URLRequest( (viewComponent as bitrateDetectionPluginCode).downloadUrl + "?" + ( Math.random( ) * 100000 )) );
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
			trace("*** preferred bitrate for bitrate detection plugin:", bitrateVal);
			
			//for debugging - force a bitrate value to override the calculated one
			if(_forceBitrate > 0)
			{
				bitrateVal = _forceBitrate;
			}
			
			//for testing - expose the # via JS
			try
			{
				ExternalInterface.call('bitrateValue' , bitrateVal);
			} 
			catch(error:Error) 
			{
				
			}
			
			sendNotification(NotificationType.CHANGE_PREFERRED_BITRATE, {bitrate: bitrateVal});

			_bandwidth = bitrateVal;
			
			//write to cookie
			if (_configProxy.vo.flashvars.allowCookies=="true")
			{
				var flavorCookie : SharedObject;
				try
				{
					flavorCookie = SharedObject.getLocal("kaltura");
				}
				catch (e : Error)
				{
					trace("No access to user's file system");
				}
				if (flavorCookie && flavorCookie.data)
				{
					flavorCookie.data.preferedFlavorBR = bitrateVal;
					flavorCookie.flush();
				}
			}
			
			
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
				trace ("bitrate detection i/o error:", event.text);				
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