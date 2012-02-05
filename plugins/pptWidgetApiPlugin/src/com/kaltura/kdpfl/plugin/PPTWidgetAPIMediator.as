package com.kaltura.kdpfl.plugin {
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.commands.data.DataUpdate;
	import com.kaltura.errors.KalturaError;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.util.URLProccessing;
	import com.kaltura.vo.KalturaDataEntry;
	
	import fl.data.DataProvider;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import mx.binding.utils.BindingUtils;
	import mx.utils.Base64Encoder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PPTWidgetAPIMediator extends Mediator {
		/**
		 * Flashvars container
		 */
		protected var _flashvars:Object;

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
		 * The loader that is used to load the presentation swf
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

		protected var _galleryVisible:Boolean = true;

		protected var _carouselPictureArray:Array = new Array();

		protected var _isMediaEnabled:Boolean = false;

		protected var _debugMode:Boolean;
		
		/**
		 * reference to KDP's sequence proxy. 
		 */		
		private var _sequenceProxy:SequenceProxy;


		/**
		 * True when pptWidgetClose notification should be sent after saving
		 */
		protected var _sendCloseNotification:Boolean = false;


		public function PPTWidgetAPIMediator(viewComponent:Object) {
			super("PPTWidgetAPIMediator", viewComponent);

			var mediaProxy:MediaProxy = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy);
			BindingUtils.bindProperty(this, "isAdmin", facade["bindObject"], ["mediaProxy", "entryExtraData", "isAdmin"]);
			
		}


		override public function onRegister():void {
			_flashvars = facade.retrieveProxy("configProxy")["vo"]["flashvars"];
			PPTWidgetStrings.init(_flashvars);

			if (_flashvars.editMode) {
				_flashvars.adminMode = _flashvars.editMode;
			}

			if (_flashvars.videoPresentationEntryId) {
				_flashvars.syncEntryId = _flashvars.videoPresentationEntryId
			}

			if (_flashvars.adminMode == "true" || _flashvars.adminMode == "1")
				view.adminMode = true;
			
			_debugMode = _flashvars.pptDebugMode == "true";
			
			_sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
		}


		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case "changeVideoPresentation":
					sendNotification(NotificationType.CLEAN_MEDIA);
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
				case "pptWidgetNextCarouselSlide":
					onPPTWidgetNextCarouselSlide();
					break;
				case "pptWidgetPrevCarouselSlide":
					onPPTWidgetPrevCarouselSlide();
					break;
				case "updateGalleryDataProvider":
					//updateDataProvider(_carouselPictureArray.length +1, _carouselPictureArray.length + 10);
					break;
				case "pptWidgetAddMark":
					onPPTWidgetAddMark(note);
					break;
				case "pptWidgetRemoveMark":
					onPPTWidgetRemoveMark(note);
					break;
				case "videoMarkHighlight":
					view.isMarkSelected = true;
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
				case "pptWidgetToggleVisibility":
					_galleryVisible = !_galleryVisible;
					view.toggleGallery = _galleryVisible;
					view.shouldSave = true;
					break;
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					onPlayerUpdatePlayhead(note);
					break;
				case "showOnlyPPT":
					view.showOnlyPPT = !view.showOnlyPPT;
					break;
				case "showOnlyVideo":
					view.showOnlyVideo = !view.showOnlyVideo;
					break;
				case NotificationType.DO_SEEK:
					onDoSeek(note);
					break;
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					onPPTWidgetGoToSlide(_dummyMovieContainer.currentFrame);
					break;
				case NotificationType.HAS_CLOSED_FULL_SCREEN:
					onPPTWidgetGoToSlide(_dummyMovieContainer.currentFrame);
					break;
				case NotificationType.MEDIA_LOADED:
					_isMediaEnabled = true;
					view.enablePPTControls = true;

					break;
				case NotificationType.CHANGE_MEDIA_PROCESS_STARTED:
					_isMediaEnabled = false;
					view.enablePPTControls = false;
					break;
				case PPTWidgetNotifications.SLIDES_LOADED:
					gotoSlide(view.currentFrame);
					break;
			}
		}


		override public function listNotificationInterests():Array {
			return ["pptWidgetNextSlide",
				"pptWidgetPrevSlide",
				"pptWidgetAddMark",
				"pptWidgetRemoveMark",
				"pptWidgetUpdateMark",
				"pptWidgetGoToSlide",
				"pptWidgetSave",
				"pptWidgetConfirmClose",
				NotificationType.LAYOUT_READY,
				"changeVideoPresentation",
				"pptWidgetToggleVisibility",
				"pptWidgetPrevCarouselSlide",
				"pptWidgetNextCarouselSlide",
				"showOnlyPPT",
				"showOnlyVideo",
				"updateGalleryDataProvider",
				PPTWidgetNotifications.VIDEO_MARK_HIGHLIGHT,
				NotificationType.HAS_OPENED_FULL_SCREEN,
				NotificationType.HAS_CLOSED_FULL_SCREEN,
				NotificationType.PLAYER_UPDATE_PLAYHEAD,
				NotificationType.DO_SEEK,
				PPTWidgetNotifications.SLIDES_LOADED,
				NotificationType.MEDIA_LOADED];
		}


		public function loadSyncEntry():void {
			if (!syncEntryId || syncEntryId == "-1" || syncEntryId == "") {
				sendNotification(NotificationType.CHANGE_MEDIA, {entryId: "-1"});
				return;
			}
			var kc:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;
			var baseEntryGet:BaseEntryGet = new BaseEntryGet(syncEntryId);
			baseEntryGet.addEventListener(KalturaEvent.COMPLETE, loadSyncEntryComplete);
			baseEntryGet.addEventListener(KalturaEvent.FAILED, loadSyncEntryError);
			kc.post(baseEntryGet);
		}


		protected function loadSyncEntryComplete(result:KalturaEvent):void {
			var dataEntry:KalturaDataEntry;
			if (!result.data is KalturaDataEntry) {
				if (_debugMode) {
					trace("Entry is not KalturaDataEntry");
				}
				sendNotification(PPTWidgetNotifications.NOT_DATA_ENTRY);
				return;
			}

			dataEntry = result.data as KalturaDataEntry;
			view.dataEntry = dataEntry;
			// get the xml from partner data
			var dataContentXML:XML = XML(dataEntry.dataContent);
			_videoEntryId = dataContentXML.video.entryId;

			if (dataContentXML.hasOwnProperty("showGallery")) {
				if (dataContentXML.showGallery.toString() == "true") {
					_galleryVisible = true;
					view.toggleGallery = true;
				}
				else {
					_galleryVisible = false;
					view.toggleGallery = false;
				}
			}
			else {
				_galleryVisible = true;
				view.toggleGallery = true;
			}

			if (!_videoEntryId) {
				sendNotification(PPTWidgetNotifications.PPT_WIDGET_VIDEO_SLIDE_NOT_FOUND);
				sendNotification(NotificationType.ALERT, {message: PPTWidgetStrings.getString("PPTWIDGET_VIDEO_SLIDE_NOT_FOUND_MESSAGE"), title: PPTWidgetStrings.getString("PPTWIDGET_GENERIC_ERROR_TITLE")});
				return;
			}

			sendNotification(NotificationType.CHANGE_MEDIA, {entryId: _videoEntryId});

			_slidePath = dataContentXML.slide.path;

			//add the referrer in 64 base for access control 
			var cp:Object = facade.retrieveProxy("configProxy");

			var referrer:String = "";
			if (facade.retrieveProxy("configProxy")["vo"]["flashvars"]["referrer"] && facade.retrieveProxy("configProxy")["vo"]["flashvars"]["referrer"] != "") {
				referrer = facade.retrieveProxy("configProxy")["vo"]["flashvars"]["referrer"];
				var b64:Base64Encoder = new Base64Encoder();
				b64.encode(referrer);
				referrer = "/referrer/" + b64.drain();
			}


			if (!_slidePath) {
				sendNotification(PPTWidgetNotifications.PPT_SWF_NOT_FOUND);
				sendNotification(NotificationType.ALERT, {message: PPTWidgetStrings.getString("PPT_SWF_NOT_FOUND_MESSAGE"), title: PPTWidgetStrings.getString("PPT_SWF_NOT_FOUND_TITLE")});
				return;
			}

			// if slide path is not http, then it will be the entry id
			if (_slidePath.search("http") == -1 && _slidePath.search("https") == -1) {
				var cdnURL:String = _flashvars.httpProtocol + _flashvars.cdnHost;
				_slidePath = cdnURL + URLProccessing.getPartnerPartForTracking(dataEntry.partnerId.toString()) + "/download/entry_id/" + _slidePath;
			}
			_slidePath += referrer;


			// load the swf
			_slideLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, slideLoadComplete);
			_slideLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, slideLoadIOErrorHandler);
			_slideLoader.addEventListener(Event.COMPLETE, slideLoadComplete);
			_slideLoader.addEventListener(IOErrorEvent.IO_ERROR, slideLoadIOErrorHandler);
			_slideLoader.load(new URLRequest(_slidePath), new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));



			_videoMarksArray = new Array();
			if (!dataContentXML.hasOwnProperty("times")) {
				if (_debugMode) {
					trace("No time node ");
				}
				dataContentXML.appendChild(XML("<times/>"));
			}

			var videoMarksXML:XML = XML(dataContentXML.times);

			var numberOfTimes:uint = XMLList(videoMarksXML.time).length();

			for each (var videoMark:XML in videoMarksXML.time) {
				_videoMarksArray.push({video: Math.round(Number(videoMark.video)), slide: Number(videoMark.slide)});
			}

			_videoMarksArray.sortOn("video", Array.NUMERIC);

			facade.sendNotification(PPTWidgetNotifications.VIDEO_MARKS_RECEIVED, _videoMarksArray);

			if (_debugMode) {
				if (numberOfTimes > 0) {
					trace("Got " + numberOfTimes + " video marks");
				}
				else {
					trace("Got no video marks!");
				}
			}
		}


		private function slideLoadIOErrorHandler(event:IOErrorEvent):void {
			if (_debugMode) {
				trace("slideLoadIOErrorHandler: " + event.text);
			}
			sendNotification(PPTWidgetNotifications.PPT_SWF_NOT_FOUND, event.text);
			sendNotification(NotificationType.ALERT, {message: PPTWidgetStrings.getString("PPT_SWF_NOT_FOUND_MESSAGE"), title: PPTWidgetStrings.getString("PPT_SWF_NOT_FOUND_TITLE")});
		}


		protected function slideLoadComplete(event:Event):void {
			_slideLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, slideLoadComplete);
			_slideLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, slideLoadIOErrorHandler);
			_slideLoader.removeEventListener(Event.COMPLETE, slideLoadComplete);
			_slideLoader.removeEventListener(IOErrorEvent.IO_ERROR, slideLoadIOErrorHandler);
			
			var dataProvider:DataProvider = new DataProvider();

			view.presentationMovieClip = _slideLoader.content as MovieClip;

			if (!view.adminMode) {
				for each (var syncPoint:Object in _videoMarksArray) {
					dataProvider.addItem({offset: syncPoint.video, frameNum: syncPoint.slide, source: _slideLoader.content as MovieClip});
				}
			}
			else {
				for (var index:int = 1; index <= view.presentationMovieClip.totalFrames; index++) {
					dataProvider.addItem({frameNum: index, source: _slideLoader.content as MovieClip});
				}
			}

			view.carouselDataProvider = dataProvider;

			if (dataProvider && dataProvider.length)
				view.currentFrame = dataProvider.getItemAt(0)["frameNum"];

			_dummyMovieContainer.loaderContent = _slideLoader.content as MovieClip;

			_carouselPictureArray = new Array();

			sendNotification(PPTWidgetNotifications.SLIDES_LOADED);

		}


		private function gotoSlide(slideIndex:int):void {
			view.currentFrame = slideIndex;

		}


		protected function loadSyncEntryError(event:KalturaEvent):void {
			logError("loadSyncEntryError", event.error)
			if (event.error)
				sendNotification(NotificationType.ALERT, {message: event.error.errorMsg, title: PPTWidgetStrings.getString("PPTWIDGET_GENERIC_ERROR_TITLE")});
			else
				alertGenericError();
		}


		protected function onPPTWidgetNextSlide():void {
			sendNotification(PPTWidgetNotifications.VIDEO_MARKS_REMOVE_HIGHLIGHTS);
			var nextIndex:int = (_videoMarksArray.indexOf(_currentVideoMark) < (_videoMarksArray.length - 1)) ? _videoMarksArray.indexOf(_currentVideoMark) + 1 : _videoMarksArray.indexOf(_currentVideoMark);
			var seekTime:Number = _videoMarksArray[nextIndex]["video"] / 1000;
			var nextSlide:int = _videoMarksArray[nextIndex]["slide"];
			gotoSlide(nextSlide);
			sendNotification(NotificationType.DO_SEEK, seekTime);
		}


		protected function onPPTWidgetPrevSlide():void {
			sendNotification(PPTWidgetNotifications.VIDEO_MARKS_REMOVE_HIGHLIGHTS);
			var prevIndex:int = (_videoMarksArray.indexOf(_currentVideoMark) > (0)) ? _videoMarksArray.indexOf(_currentVideoMark) - 1 : _videoMarksArray.indexOf(_currentVideoMark);
			var seekTime:Number = _videoMarksArray[prevIndex]["video"] / 1000;
			var prevSlide:int = _videoMarksArray[prevIndex]["slide"];
			gotoSlide(prevSlide);
			sendNotification(NotificationType.DO_SEEK, seekTime);
		}


		protected function onPPTWidgetNextCarouselSlide():void {
			gotoSlide(view.currentFrame + 1);
		}


		protected function onPPTWidgetPrevCarouselSlide():void {
			gotoSlide(view.currentFrame - 1);
		}


		protected function onPPTWidgetAddMark(note:INotification):void {
			var videoTime:Number;
			if (note.getBody())
				videoTime = int(note.getBody() as Number);
			else
				videoTime = int(_playHeadTime * 1000);

			var newMark:Object = {video: videoTime, slide: view.currentFrame};
			var entryDuration:Number = Number(facade.retrieveProxy("mediaProxy")["vo"]["entry"]["duration"]);
			
			if (videoTime / 1000 > entryDuration)
				return;

			// insert to the array in the right place by the video time
			if (_videoMarksArray.length) {
				var insertIndex:int = 0;
				for (var i:uint = 0; i < _videoMarksArray.length; i++) {
					var videoMark:Object = _videoMarksArray[i];
					// don't allow adding more than one point at certain time
					if (videoMark.video == videoTime) {
						return;
					}
					if (videoMark.video < videoTime) {
						insertIndex = i + 1;
					}
					else {
						// marks are sorted by in time, so we can stop looking here.
						break;
					}
				}
				_videoMarksArray.splice(insertIndex, 0, newMark);
			}
			else {
				_videoMarksArray.push(newMark);
			}
			
			// notify
			if (_debugMode) {
				trace("Sync added: slide ", newMark.slide, " on ", videoTime);
			}
			sendNotification(PPTWidgetNotifications.VIDEO_MARK_ADDED, newMark);
			view.shouldSave = true;

		}


		protected function onPPTWidgetRemoveMark(note:INotification):void {
			var time:Number;
			if (note.getBody())
				time = note.getBody() as Number;
			else
				time = _currentVideoMark.video;

			var markToRemove:Object;
			for (var i:uint = 0; i < _videoMarksArray.length; i++) {
				markToRemove = _videoMarksArray[i];
				if (markToRemove.video == time) {
					_videoMarksArray.splice(i, 1);
					if (_debugMode) {
						trace("Sync removed");
					}
					sendNotification(PPTWidgetNotifications.VIDEO_MARK_REMOVED, markToRemove);
					break;
				}
			}
			view.isMarkSelected = false;
			view.shouldSave = true;
		}


		protected function onPPTWidgetUpdateMark(note:INotification):void {
			var obj:Object = note.getBody();
			var oldTime:Number = obj.oldTime;
			var newTime:Number = obj.newTime;

			// update the time in the array
			for (var i:uint; i < _videoMarksArray.length; i++) {
				var videoMark:Object = _videoMarksArray[i];
				if (videoMark.video == oldTime) {
					videoMark.video = newTime;
					break;
				}
			}

			// and sort
			_videoMarksArray.sortOn("video", Array.NUMERIC);

			view.shouldSave = true;
		}


		protected function onPPTWidgetGoToSlide(slideNumber:int):void {
			//var slideNumber:Number = note.getBody() as Number;
			gotoSlide(slideNumber);
		}


		protected function onPPTWidgetSave():void {
			view.shouldSave = false;
			_sendCloseNotification = false;
			saveDataEntry();
		}


		protected function onPPTWidgetConfirmClose():void {
			if (_flashvars.closeFunctionName) {
				var externalInterface:Object = facade.retrieveProxy("externalInterfaceProxy");
				if (externalInterface["vo"]["enabled"]) {
					//externalInterface["call"](_flashvars.closeFunctionName, !_shouldSave);
					var javascriptReq:URLRequest = new URLRequest("javascript:" + _flashvars.closeFunctionName + "(" + view.shouldSave + ")");
					navigateToURL(javascriptReq, "_self");
				}
			}
		}


		protected function onAlertClick(event:MouseEvent):void {
			if (event.currentTarget) {
				switch (event.currentTarget.label) {
					case PPTWidgetStrings.getString("PPTWIDGET_ALERT_BUTTON_LABEL_YES"):
						_sendCloseNotification = true;
						saveDataEntry();
						break;
					case PPTWidgetStrings.getString("PPTWIDGET_ALERT_BUTTON_LABEL_NO"):
						sendNotification(PPTWidgetNotifications.PPT_WIDGET_CLOSE);
						break;
				}
			}
		}

		
		protected function onPlayerUpdatePlayhead(note:INotification):void {
			if (_sequenceProxy.vo.isInSequence) {
				return;
			}

			_playHeadTime = note.getBody() as Number;

			if (!_isMediaEnabled) {
				return;
			}
			
			var newCurrentVideoMark:Object;

			// find the last mark that its time is before the playhead time
			view.enableAddMark = true;
			for each (var videoMark:Object in _videoMarksArray) {
				var markTime:Number = videoMark.video / 1000;
				if (markTime <= _playHeadTime) {
					newCurrentVideoMark = videoMark;
				}
				else {
					if (videoMark.video == _playHeadTime * 1000) {
						view.enableAddMark = false;
					}
					break;
				}
			}
			if (!newCurrentVideoMark)
				return;
			
			if (_currentVideoMark != newCurrentVideoMark) {
				_currentVideoMark = newCurrentVideoMark;
				gotoSlide(_currentVideoMark.slide);
				sendNotification(PPTWidgetNotifications.VIDEO_MARK_HIGHLIGHT, Number(_currentVideoMark.video));
			}
		}


		protected function onDoSeek(note:INotification):void {
			onPlayerUpdatePlayhead(note);
		}


		protected function saveDataEntry():void {
			var videoMarksXML:XML = new XML("<sync></sync>");
			videoMarksXML.appendChild(XML("<video><entryId>" + _videoEntryId + "</entryId></video>"));
			videoMarksXML.appendChild(XML("<slide><path>" + _slidePath + "</path></slide>"));
			videoMarksXML.appendChild(XML("<showGallery>" + _galleryVisible + "</showGallery>"));

			var slidesXML:XML = new XML("<times></times>");
			for each (var videoMark:Object in _videoMarksArray) {
				slidesXML.appendChild(XML("<time><video>" + videoMark.video + "</video><slide>" + videoMark.slide + "</slide></time>"));
			}
			videoMarksXML.appendChild(slidesXML);

			var entry:KalturaDataEntry = new KalturaDataEntry();
			entry.dataContent = videoMarksXML.toXMLString();
			entry.retrieveDataContentByGet = view.dataEntry.retrieveDataContentByGet;
			var entryUpdate:DataUpdate = new DataUpdate(syncEntryId, entry);
			entryUpdate.addEventListener(KalturaEvent.COMPLETE, saveDataEntryComplete);
			entryUpdate.addEventListener(KalturaEvent.FAILED, saveDataEntryError);

			var kc:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;
			kc.post(entryUpdate);
		}


		protected function saveDataEntryComplete(event:KalturaEvent):void {
			if (_sendCloseNotification)
				sendNotification(PPTWidgetNotifications.PPT_WIDGET_CLOSE);
			else
				sendNotification(NotificationType.ALERT, {message: PPTWidgetStrings.getString("PPTWIDGET_SAVED_SUCCESSFULLY_MESSAGE"), title: PPTWidgetStrings.getString("PPTWIDGET_GENERIC_TITLE")});

			view.shouldSave = false;
			_sendCloseNotification = false;
		}


		protected function saveDataEntryError(event:KalturaEvent):void {
			logError("saveDataEntryError", event.error);
			view.shouldSave = true;
			alertGenericError();
		}


		protected function alertGenericError():void {
			sendNotification(NotificationType.ALERT, {message: PPTWidgetStrings.getString("PPTWIDGET_GENERIC_ERROR_MESSAGE"), title: PPTWidgetStrings.getString("PPTWIDGET_GENERIC_ERROR_TITLE")});
		}



		protected function get syncEntryId():String {
			return _flashvars.syncEntryId ? _flashvars.syncEntryId : _flashvars.pd_sync_entry;
		}


		protected function set syncEntryId(newEntry:String):void {
			_flashvars.syncEntryId = newEntry;
			_flashvars.pd_sync_entry = newEntry;
			//return _flashvars.syncEntryId ? _flashvars.syncEntryId : _flashvars.pd_sync_entry;
		}


		[Bindable]
		public function get isAdmin():Boolean {
			return false; // we just want to receive the change of isAdmin property on the entryExtraData object
		}


		public function set isAdmin(v:Boolean):void {
			if (v == true)
				view.adminMode = true;
		}


		protected function logError(method:String, error:KalturaError):void {
			trace(method + ": " + error.errorCode + " (" + error.errorMsg + ")");
		}
		
		private function get view():PPTWidgetAPIPluginCode {
			return viewComponent as PPTWidgetAPIPluginCode;
		} 
	}
}