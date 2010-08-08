package com.kaltura.kdpfl.plugin
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.commands.baseEntry.BaseEntryUpdate;
	import com.kaltura.errors.KalturaError;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.ApplicationFacade;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.util.URLProccessing;
	import com.kaltura.vo.KalturaDataEntry;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	import mx.binding.utils.BindingUtils;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PPTWidgetAPIMediator extends Mediator
	{
		/**
		 * Flashvars container
		 */
		protected var _flashvars:Object;
		
		/**
		 * Indicated whether the slides swf was loaded
		 */
		protected var _slideSwfLoaded:Boolean = false;
		
		/**
		 * The video marks array
		 */
		protected var _videoMarksArray:Array = new Array();
		
		/**
		 * The video entry id
		 */
		protected var _videoEntryId:String;
		
		/**
		 * The slide path (url) of the swf
		 */
		protected var _slidePath:String;
		
		/**
		 * The current play head time
		 **/
		private var _playHeadTime:Number = 0;
		
		/**
		 * Loader for the slides to load older flash swf files
		 */
		protected var _fLoader:ForcibleLoader;
		
		/**
		 * The loader that is used by fLoader
		 */
		protected var _slideLoader:Loader = new Loader();
		
		/**
		 * Dummy container to play the slides in the movie clip
		 */
		protected var _dummyMovieContainer:MovieClipUIContainer = new MovieClipUIContainer();
		
		/**
		 * The video mark that is currently in range
		 */
		protected var _currentVideoMark:Object;
		
		/**
		 * Indicated whether the video marks were edited
		 */
		protected var _shouldSave:Boolean = false;
		
		/**
		 * Indicates when the slides swf is loaded, and controls can become enabled.
		 */		
		protected var _enablePPTControls:Boolean = false;
		
		
		public static const SLIDES_LOADED : String = "slidesLoaded";
		
		/**
		 * True when pptWidgetClose notification should be sent after saving
		 */
		protected var _sendCloseNotification:Boolean = false;
		
		public function PPTWidgetAPIMediator(viewComponent:Object)
		{
			super("PPTWidgetAPIMediator", viewComponent);
			_flashvars = facade.retrieveProxy("configProxy")["vo"]["flashvars"];
			if (_flashvars.adminMode == "true" || _flashvars.adminMode == "1")
				viewComponent.adminMode = true;
			
			var mediaProxy:MediaProxy = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy);
			BindingUtils.bindProperty(this, "isAdmin", facade["bindObject"], ["mediaProxy", "entryExtraData", "isAdmin"]);
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case "switchPPTEntry":
					syncEntryId = note.getBody().entryId;
					loadSyncEntry();
					break;
				case "layoutReady":
					loadSyncEntry();
					break;
				case "pptWidgetNextSlide":
					onPPTWidgetNextSlide();
					break;
				case "pptWidgetPrevSlide":
					onPPTWidgetPrevSlide();
					break;
				case "pptWidgetAddMark":
					onPPTWidgetAddMark(note);
					break;
				case "pptWidgetRemoveMark":
					onPPTWidgetRemoveMark(note);
					break;
				case "pptWidgetUpdateMark":
					onPPTWidgetUpdateMark(note);
					break;
				case "pptWidgetGoToSlide":
					onPPTWidgetGoToSlide(note.getBody() as Number);
					break;
				case "pptWidgetSave":
					onPPTWidgetSave();
					break;
				case "pptWidgetConfirmClose":
					onPPTWidgetConfirmClose();
					break;
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					onPlayerUpdatePlayhead(note);
					break;
				case NotificationType.DO_SEEK:
					onDoSeek(note);
					break;
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					trace("opened full screen");
					onPPTWidgetGoToSlide(_dummyMovieContainer.currentFrame);
					break;
				case NotificationType.HAS_CLOSED_FULL_SCREEN:
					trace("closedFullScreen");
					onPPTWidgetGoToSlide(_dummyMovieContainer.currentFrame);
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				"pptWidgetNextSlide",
				"pptWidgetPrevSlide",
				"pptWidgetAddMark",
				"pptWidgetRemoveMark",
				"pptWidgetUpdateMark",
				"pptWidgetGoToSlide",
				"pptWidgetSave",
				"pptWidgetConfirmClose",
				"layoutReady",
				"switchPPTEntry",
				NotificationType.HAS_OPENED_FULL_SCREEN,
				NotificationType.HAS_CLOSED_FULL_SCREEN,
				NotificationType.PLAYER_UPDATE_PLAYHEAD,
				NotificationType.DO_SEEK
			];
		}
		
		public function loadSyncEntry():void
		{
			if (!syncEntryId)
			{
				sendNotification(NotificationType.ALERT, { message: PPTWidgetStrings.PPTWIDGET_SYNC_ENTRY_NOT_FOUND_MESSAGE, title: PPTWidgetStrings.PPTWIDGET_GENERIC_ERROR_TITLE });
				return;
			}
			
			var kc:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;
			var baseEntryGet:BaseEntryGet = new BaseEntryGet(syncEntryId);
			baseEntryGet.addEventListener(KalturaEvent.COMPLETE, loadSyncEntryComplete);
			baseEntryGet.addEventListener(KalturaEvent.FAILED, loadSyncEntryError);
			kc.post(baseEntryGet);
		}
		
		protected function loadSyncEntryComplete(result:KalturaEvent):void
		{
			var dataEntry:KalturaDataEntry;
			if (!result.data is KalturaDataEntry)
			{
				trace("Entry is not KalturaDataEntry");
				return;
			}
			
			dataEntry = result.data as KalturaDataEntry;
			
			// get the xml from partner data
			var dataContentXML:XML = XML(dataEntry.dataContent);
			_videoEntryId = dataContentXML.video.entryId;
			
			if (!_videoEntryId)
			{
				sendNotification(NotificationType.ALERT, { message: PPTWidgetStrings.PPTWIDGET_VIDEO_ENTRY_NOT_FOUND_MESSAGE, title: PPTWidgetStrings.PPTWIDGET_GENERIC_ERROR_TITLE });
				return;
			}
			
			sendNotification(NotificationType.CHANGE_MEDIA, { entryId: _videoEntryId });
			
			// TODO: Check this
			// http://cdn.kaltura.com/content/entry/download/3/53/i9dpgp8sk0_100000.swf
			// http://www.kaltura.com/content/entry/download/4/112/knn9gx1n7s_100000.swf
			_slidePath = dataContentXML.slide.path;
			if (!_slidePath)
			{
				sendNotification(NotificationType.ALERT, { message: PPTWidgetStrings.PPTWIDGET_VIDEO_SLIDE_NOT_FOUND_MESSAGE, title: PPTWidgetStrings.PPTWIDGET_GENERIC_ERROR_TITLE });
				return;
			}
			
			// if slide path is not http, then it will be the entry id
			if (_slidePath.search("http") == -1 && _slidePath.search("https") == -1) 
			{
				var cdnURL:String= _flashvars.httpProtocol + _flashvars.cdnHost;
				_slidePath = cdnURL + URLProccessing.getPartnerPartForTracking(dataEntry.partnerId.toString()) + "/download/entry_id/" + _slidePath;
			}
			
			// load the swf
			_slideLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, slideLoadComplete);
			_slideLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, slideLoadIOErrorHandler);
			_fLoader = new ForcibleLoader(_slideLoader);
			_fLoader.load(new URLRequest(_slidePath));
			
			/** Handle the video marks **/
			
			_videoMarksArray = new Array();
			if (!dataContentXML.hasOwnProperty("times")) 
			{
				trace("No time node");
				dataContentXML.appendChild(XML("<times/>"));
			}

			var videoMarksXML:XML = XML(dataContentXML.times);
			
			var numberOfTimes:uint = XMLList(videoMarksXML.time).length();
			
			for each (var videoMark:XML in videoMarksXML.time) 
			{
				_videoMarksArray.push({video: Math.round(Number(videoMark.video)), slide: Number(videoMark.slide)});
			}
			
			_videoMarksArray.sortOn("video", Array.NUMERIC);
			
			if (numberOfTimes > 0) 
			{
				trace("Got " + numberOfTimes + " video marks");
				facade.sendNotification("videoMarksReceived", _videoMarksArray);
			}
			else 
			{
				trace("Got no video marks!");
			} 
		}
		
		private function slideLoadIOErrorHandler(event:IOErrorEvent):void 
		{
			trace("slideLoadIOErrorHandler: " + event.text);
			alertGenericError();
		}
		
		protected function slideLoadComplete(event:Event):void
		{
			_slideSwfLoaded = true;
			_enablePPTControls = true;
			viewComponent.enablePPTControls = true;
			// Set the movie containers
			_dummyMovieContainer.loaderContent = _fLoader.loader1.content as MovieClip;
			
			var ratio:Number = _fLoader.loader1.content.width / _fLoader.loader1.content.height;
			
			// This is the converted slide movie dimention
			_dummyMovieContainer.width = _fLoader.loader1.content.width;
			_dummyMovieContainer.height = _fLoader.loader1.content.height;
			getSlidePictures();
			
			sendNotification(SLIDES_LOADED);
			
			// goto the first frame
			gotoSlide(1);	
		}
		
		protected function getSlidePictures():void 
		{
			var carouselPicturesArray:Array = new Array();
			var numberOfSlidesInCarousel:uint = _dummyMovieContainer.numberOfSlides;
			
			// Go over all the dummy slide and "take pictures"
			for (var index:uint = 1; index <= numberOfSlidesInCarousel; index++) 
			{
				// Get the slide bitmap
				var bitmap:Bitmap = getSlideBitmap(index, true);
				
				// Add to array
				carouselPicturesArray.push(bitmap);
			}
			
			this.viewComponent.carouselPicturesDataProvider = new DataProvider(carouselPicturesArray);
		}
		
		private function gotoSlide(slideIndex:int):void 
		{
			// Get the slide bitmap
			if (_slideSwfLoaded)
			{
				var bitmap:Bitmap = getSlideBitmap(slideIndex);
				viewComponent.bitmapDataProvider = bitmap.bitmapData;
				viewComponent.displayNextButton = (_dummyMovieContainer.numberOfSlides  != slideIndex);
				viewComponent.displayPrevButton = (slideIndex != 1);
				
				if (_videoMarksArray[slideIndex] != _videoMarksArray.indexOf(_currentVideoMark))
				{
					var seekTime : Number = (_videoMarksArray[slideIndex]["video"] as Number) /1000;
					sendNotification(NotificationType.DO_SEEK, seekTime );
				}
			}
		}
		
		protected function getSlideBitmap(slideIndex:uint, drawFrame:Boolean = false):Bitmap 
		{
			// Go to the relevant slide
			_dummyMovieContainer.gotoSlide(slideIndex);
			
			// "Take picture"
			var bitmapData:BitmapData = getUIComponentBitmapData(_dummyMovieContainer as UIComponent);
			
			// Draw the frame. I use very big line size (15) because when scaled down it looks normal
			if (drawFrame) 
			{
				var sprite:Sprite = new Sprite(  );
				sprite.graphics.lineStyle(15, 0x4e4e4e);
				sprite.graphics.moveTo(0, 0);
				sprite.graphics.lineTo(_dummyMovieContainer.width, 0);
				sprite.graphics.lineTo(_dummyMovieContainer.width, _dummyMovieContainer.height);
				sprite.graphics.lineTo(0, _dummyMovieContainer.height);
				sprite.graphics.lineTo(0, 0);
				bitmapData.draw(sprite);
			}
			
			var bitmap:Bitmap = new Bitmap(bitmapData, "auto", true);
			bitmap.smoothing = true;
			
			return bitmap;
		}
		
		protected function getUIComponentBitmapData( target : UIComponent ) : BitmapData
		{
			var bd : BitmapData = new BitmapData( target.width, target.height );
			var m : Matrix = new Matrix();
			bd.draw( target, m );
			return bd;
		}
		
		
		protected function loadSyncEntryError(event:KalturaEvent):void
		{
			logError("loadSyncEntryError", event.error)
			if (event.error)
				sendNotification(NotificationType.ALERT, { message: event.error.errorMsg, title: PPTWidgetStrings.PPTWIDGET_GENERIC_ERROR_TITLE });
			else
				alertGenericError();
		}
		
		protected function onPPTWidgetNextSlide():void
		{
			sendNotification("videoMarksRemoveHighlights");
			gotoSlide(_dummyMovieContainer.currentFrame + 1);
		}
		
		protected function onPPTWidgetPrevSlide():void
		{
			sendNotification("videoMarksRemoveHighlights");
			gotoSlide(_dummyMovieContainer.currentFrame - 1);
		}
		
		protected function onPPTWidgetAddMark(note:INotification):void
		{
			var videoTime:Number;
			if (note.getBody())
				videoTime = note.getBody() as Number;
			else
				videoTime = _playHeadTime * 1000;
			
			_currentVideoMark = { video: videoTime, slide: _dummyMovieContainer.currentFrame };
			
			// insert to the array in the right place by the video time
			for (var i:uint; i < _videoMarksArray.length; i++) 
			{
				var videoMark:Object = _videoMarksArray[i];
				if (videoMark.video > videoTime)
				{
					_videoMarksArray.splice(i, 0, _currentVideoMark);
					break;
				}
			}
			trace("Sync added");
			sendNotification("videoMarkAdded", _currentVideoMark);
			shouldSave = true;
		}
			
		protected function onPPTWidgetRemoveMark(note:INotification):void
		{
			var time:Number;
			if (note.getBody())
				time = note.getBody() as Number;
			else
				time = _currentVideoMark.video;
			
			var markToRemove:Object;
			for (var i:uint = 0; i < _videoMarksArray.length; i++) 
			{
				markToRemove = _videoMarksArray[i];
				if (markToRemove.video == time)
				{
					_videoMarksArray.splice(i, 1);
					trace("Sync removed");
					sendNotification("videoMarkRemoved", markToRemove); 
					break;
				}
			}
			shouldSave = true;
		}
		
		protected function onPPTWidgetUpdateMark(note:INotification):void
		{
			var obj:Object = note.getBody();
			var oldTime:Number = obj.oldTime;
			var newTime:Number = obj.newTime;
			
			// update the time in the array
			for (var i:uint; i < _videoMarksArray.length; i++) 
			{
				var videoMark:Object = _videoMarksArray[i];
				if (videoMark.video == oldTime) 
				{
					videoMark.video = newTime;
					break;
				}
			}
			
			// and sort
			_videoMarksArray.sortOn("video", Array.NUMERIC);
			
			shouldSave = true;
		}
		
		protected function onPPTWidgetGoToSlide(slideNumber : int):void
		{
			//var slideNumber:Number = note.getBody() as Number;
			gotoSlide(slideNumber);
		}
		
		protected function onPPTWidgetSave():void
		{
			_sendCloseNotification = false;
			saveDataEntry();
		}
		
		protected function onPPTWidgetConfirmClose():void
		{
			if (_shouldSave)
			{
				var alertOptions:Object = {
					title: PPTWidgetStrings.PPTWIDGET_SAVE_CHANGES_TITLE,
					message: PPTWidgetStrings.PPTWIDGET_SAVE_CHANGES_TEXT,
					buttons: [PPTWidgetStrings.PPTWIDGET_ALERT_BUTTON_LABEL_YES, PPTWidgetStrings.PPTWIDGET_ALERT_BUTTON_LABEL_NO],
					callBackFunction: onAlertClick
				}
				
				sendNotification(NotificationType.ALERT,  alertOptions);
			}
			else
			{
				sendNotification('pptWidgetClose');
			}
		}
		
		protected function onAlertClick(event:MouseEvent):void
		{
			if (event.currentTarget)
			{
				switch(event.currentTarget.label)
				{
					case PPTWidgetStrings.PPTWIDGET_ALERT_BUTTON_LABEL_YES:
						_sendCloseNotification = true;
						saveDataEntry();
						break;
					case PPTWidgetStrings.PPTWIDGET_ALERT_BUTTON_LABEL_NO:
						sendNotification('pptWidgetClose');
						break;
				}
			}
		}
		
		protected function onPlayerUpdatePlayhead(note:INotification):void
		{
			_playHeadTime = note.getBody() as Number;
			
			var newCurrentVideoMark:Object;
			
			// find the last mark that its time is before the play head time
			if (_slideSwfLoaded)
			{
				for each (var videoMark:Object in _videoMarksArray) 
				{
					var markTime:Number = videoMark.video / 1000; 
					if (markTime <= _playHeadTime)
						newCurrentVideoMark = videoMark;
					else
						break;
				}
				if (!newCurrentVideoMark)
					return;
				
				_currentVideoMark = newCurrentVideoMark;
				gotoSlide(_currentVideoMark.slide);
				sendNotification("videoMarkHighlight", Number(_currentVideoMark.video));
			}
			
			
		}
		
		protected function onDoSeek(note:INotification):void
		{
			onPlayerUpdatePlayhead(note);
			trace(note.getBody() as Number);
		}
		
		protected function saveDataEntry():void
		{
			var videoMarksXML:XML = new XML("<sync></sync>");
			videoMarksXML.appendChild(XML("<video><entryId>"+ _videoEntryId + "</entryId></video>"));
			videoMarksXML.appendChild(XML("<slide><path>"+ _slidePath + "</path></slide>"));
			
			var slidesXML:XML = new XML("<times></times>");
			for each(var videoMark:Object in _videoMarksArray)
			{
				slidesXML.appendChild(XML("<time><video>"+ videoMark.video + "</video><slide>" + videoMark.slide + "</slide></time>"));
			}
			videoMarksXML.appendChild(slidesXML);
			
			var entry:KalturaDataEntry = new KalturaDataEntry();
			entry.dataContent = videoMarksXML.toXMLString();
			
			var entryUpdate:BaseEntryUpdate = new BaseEntryUpdate(syncEntryId, entry);
			entryUpdate.addEventListener(KalturaEvent.COMPLETE, saveDataEntryComplete);
			entryUpdate.addEventListener(KalturaEvent.FAILED, saveDataEntryError);
			
			var kc:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;
			kc.post(entryUpdate);
		}
		
		protected function saveDataEntryComplete(event:KalturaEvent):void
		{
			if (_sendCloseNotification)
				sendNotification('pptWidgetClose');
			else
				sendNotification(NotificationType.ALERT, { message: PPTWidgetStrings.PPTWIDGET_SAVED_SUCCESSFULLY_MESSAGE, title: PPTWidgetStrings.PPTWIDGET_GENERIC_TITLE });
			
			shouldSave = false;
			_sendCloseNotification = false;
		}
		
		protected function saveDataEntryError(event:KalturaEvent):void
		{
			logError("saveDataEntryError", event.error);
			alertGenericError();
		}
		
		protected function alertGenericError():void
		{
			sendNotification(NotificationType.ALERT, { message: PPTWidgetStrings.PPTWIDGET_GENERIC_ERROR_MESSAGE, title: PPTWidgetStrings.PPT_SWF_NOT_FOUND_MESSAGE});
		}
		
		protected function set shouldSave(v:Boolean):void
		{
			
			_shouldSave = v;
			viewComponent.shouldSave = _shouldSave;
		}
		
		protected function get syncEntryId():String
		{
			return _flashvars.syncEntryId ? _flashvars.syncEntryId : _flashvars.pd_sync_entry;
		}
		
		protected function set syncEntryId(newEntry : String):void
		{
			_flashvars.syncEntryId = newEntry;
			_flashvars.pd_sync_entry = newEntry;
			//return _flashvars.syncEntryId ? _flashvars.syncEntryId : _flashvars.pd_sync_entry;
		}
		
		[Bindable]
		public function get isAdmin():Boolean
		{
			return false; // we just want to receive the change of isAdmin property on the entryExtraData object
		}
		
		public function set isAdmin(v:Boolean):void
		{
			if (v == true)
				viewComponent.adminMode = true;
		}
		
		protected function logError(method:String, error:KalturaError):void
		{
			trace(method + ": " + error.errorCode + " (" + error.errorMsg + ")");
		}
	}
}