package com.kaltura.kdpfl.view {

	import com.kaltura.KalturaClient;
	import com.kaltura.commands.MultiRequest;
	import com.kaltura.commands.annotation.AnnotationAdd;
	import com.kaltura.commands.annotation.AnnotationGet;
	import com.kaltura.commands.annotation.AnnotationList;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.strings.MessageStrings;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.vo.MediaVO;
	import com.kaltura.kdpfl.util.KAstraAdvancedLayoutUtil;
	import com.kaltura.kdpfl.view.events.AnnotationEvent;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.kdpfl.view.strings.AnnotationStrings;
	import com.kaltura.kdpfl.view.strings.Notifications;
	import com.kaltura.vo.KalturaAnnotation;
	import com.kaltura.vo.KalturaAnnotationFilter;
	import com.yahoo.astra.fl.controls.containerClasses.AutoSizeButton;
	
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import org.osmf.events.TimelineMetadataEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.metadata.TimelineMarker;
	import org.osmf.metadata.TimelineMetadata;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AnnotationBoxMediator extends Mediator {
		public static const NAME:String = "annotationBoxMediator";

		protected var _unsavedAnnotationSO:Array;
		protected var _player:MediaPlayer;
		protected var _playerMediaMediator:KMediaPlayerMediator;
		protected var _timelineMetadata:TimelineMetadata;
		protected var _entryId:String = "0";
		protected var _sessionId:String = "";
		protected var _userModeBeforeFS:String;
		protected var _partnerId:int;
		
		/**
		 * "true" if already received at least one "playerPlayed" notification.
		 */		
		protected var _playerPlayedOnce:Boolean = false;
		
		/**
		 * "true" if when receiving "playerPlayed" should dispatch "doPause". 
		 */
		protected var _shouldPause:Boolean = false;

		private var _annotationToDelete:Annotation;
		
		private var _flashvars:Object;

		/**
		 * Saved annotations shared object prefix.
		 */
		public static const ANNOTATIONS_SO_PREFIX:String = "KalturaSavedAnnotations_";
		
		/**
		 * Saves current displaying annotations, they will be removed before editing, and added back afterwards
		 * */
		private var _annotationsArr:Array;
		
		private var _pluginCode:annotationsPluginCode;


		public function AnnotationBoxMediator(viewComponent:Object = null) {
			_pluginCode = viewComponent as annotationsPluginCode;
			super(NAME, viewComponent);
			createListeners();
		}

		override public function onRegister():void
		{
			_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
		}

		protected function createListeners():void {
			var box:AnnotationsBox = _pluginCode.annotationsBox; 
			box.addEventListener(AnnotationEvent.DELETE_ANNOTATION, onAnnotationDeleted);
			box.addEventListener(AnnotationEvent.EDIT_ANNOTATION, onAnnotationEdit);
			box.addEventListener(AnnotationEvent.SEEK_TO_ANNOTATION, onAnnotationClick);

			var form:EditAnnotationForm = _pluginCode.annotationEditForm; 
			form.addEventListener(AnnotationEvent.MAX_LENGTH_REACHED, handleAnnotationMaxLength);
			form.addEventListener(AnnotationEvent.MAX_LENGTH_FIXED, handleAnnotationMaxLength);
		}


		override public function listNotificationInterests():Array {
			var interests:Array = [Notifications.ADD_ANNOTATION, Notifications.CANCEL_ANNOTATION,
				Notifications.ANNOTATION_DELETED, Notifications.SAVE_ANNOTATION, Notifications.LOAD_FEEDBACK_SESSION, Notifications.LOAD_LOCAL_SAVED_ANNOTATIONS, Notifications.RESET_ANNOTATIONS_COMPONENT,
				NotificationType.LAYOUT_READY, NotificationType.MEDIA_LOADED, NotificationType.ENTRY_READY, Notifications.SUBMIT_FEEDBACK_SESSION, NotificationType.HAS_OPENED_FULL_SCREEN,
				NotificationType.HAS_CLOSED_FULL_SCREEN, NotificationType.PLAYER_PLAY_END, Notifications.SAVE_AS_DRAFT, NotificationType.PLAYER_PLAYED,
				Notifications.PERSIST_ANNOTATION];
			return interests;
		}


		override public function handleNotification(notification:INotification):void {

			var name:String = notification.getName();
			var index:int;
			var currentTime:Number;
			var currEntryId:String = facade.retrieveProxy("mediaProxy")["vo"]["entry"]["id"];

			_partnerId = _flashvars.partnerId;
			switch (name) {
				case NotificationType.PLAYER_PLAYED:
					// if this is the first time the player played and it was because of a click
					// on an annotation, pause it. 
					_playerPlayedOnce = true;
					if (_shouldPause) {
						_shouldPause = false;
						sendNotification(NotificationType.DO_PAUSE);
					}
					break;
				case NotificationType.LAYOUT_READY:
					_playerMediaMediator = facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator;
					_player = _playerMediaMediator.player;
					break;
				case NotificationType.ENTRY_READY:

					if (currEntryId != _entryId) {
						_entryId = currEntryId;
					}
					if (_pluginCode.userMode == AnnotationStrings.REVIEWER && _pluginCode.useSharedObject) {
						configureLocalSavedAnnotations();
					}
					else {
						if (_sessionId && _sessionId != "")
							loadFeedbackSession();
						_pluginCode.removeEventListener(AnnotationStrings.ANNOTATIONS_LIST_CHANGED_EVENT, saveAnnotationsToLocalObject)
					}


					break;
				case NotificationType.MEDIA_LOADED:
					var currMedia:MediaElement = facade.retrieveProxy("mediaProxy")["vo"]["media"];
					if (currMedia && currEntryId == _entryId) {
						initTimelineMetadata();
					}
					if (_pluginCode.annotationsBox.dataProvider.toArray().length) {
						var dpArray:Array = _pluginCode.annotationsBox.dataProvider.toArray();
						for (var i:int = 0; i < dpArray.length; i++) {
							addTimelineMarker((dpArray[i]["annotation"] as Annotation).inTime);
						}
					}
					break;

				case Notifications.SUBMIT_FEEDBACK_SESSION:

					var kAnnotationArray:Array = _pluginCode.annotationsBox.annotationsAsKalturaAnnotationArray;

					if (kAnnotationArray && kAnnotationArray.length != 0 && _entryId && _entryId != "" && _entryId != "-1") {
						submitFeedbackSession(kAnnotationArray);
					}


					break;

				case Notifications.LOAD_LOCAL_SAVED_ANNOTATIONS:

					if (!_pluginCode.showAnnotationsPlugin) {
						_pluginCode.showAnnotationsPlugin = true;
					}

					for (index = 0; index < _unsavedAnnotationSO.length; index++) {
						var annotationObj:Object = _unsavedAnnotationSO[index];

						var unsavedAnnotation:Annotation = new Annotation(AnnotationStrings.VIEW_MODE, annotationObj["inTime"], annotationObj["annotationText"], annotationObj["entryId"], null, _pluginCode.annotationsBox.initialTabIndex);
						_pluginCode.annotationsBox.addAnnotation(unsavedAnnotation);

						addTimelineMarker(unsavedAnnotation.inTime);
					}

					sendNotification("receivedCuePoints", _pluginCode.annotationsBox.millisecTimesArray);

					_pluginCode.addEventListener(AnnotationStrings.ANNOTATIONS_LIST_CHANGED_EVENT, saveAnnotationsToLocalObject);

					break;


				case Notifications.ADD_ANNOTATION:

					if (_entryId && _entryId != "" && _entryId != "-1") {

						sendNotification(NotificationType.DO_PAUSE);

						if (!_pluginCode.showAnnotationsPlugin) {
							_pluginCode.showAnnotationsPlugin = true;
						}
						var n_annotation:Annotation = new Annotation(AnnotationStrings.EDIT_MODE, -1, Annotation.ANNOTATION_PROMPT, _entryId);
						removeAnnotationsFromLayout();
						_pluginCode.gotoEditMode();
						_pluginCode.annotationEditForm.openAnnotationForEditing(n_annotation);
					}

					break;

				case Notifications.LOAD_FEEDBACK_SESSION:
					_pluginCode.annotationsBox.reset();
					if (_pluginCode.submissionTarget == AnnotationStrings.KALTURA) {

						_pluginCode.userMode = AnnotationStrings.CANDIDATE;

						_sessionId = notification.getBody().sessionId;

						var kc:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;

						var sessionParentRequest:AnnotationGet = new AnnotationGet(_sessionId);

						sessionParentRequest.addEventListener(KalturaEvent.COMPLETE, onParentAcquired);
						sessionParentRequest.addEventListener(KalturaEvent.FAILED, onParentFeedbackFailed);
						kc.post(sessionParentRequest);
					}
					else {
						var annotationsXML:XML = new XML(notification.getBody().feedbackSession);
						onParentAcquired(annotationsXML);

					}
					break;
				case Notifications.PERSIST_ANNOTATION:
					storeAnnotation(true);
					break;
				case Notifications.SAVE_ANNOTATION:
					storeAnnotation();
					/*
					sendNotification(NotificationType.DO_PAUSE);
					currentTime = Math.floor(_playerMediaMediator.getCurrentTime());
					var currTimeIndex:int = _pluginCode.annotationsBox.findIndexByInTime(currentTime);

					if (currTimeIndex != -1 && _pluginCode.annotationsBox.findIndexByAnnotation(_pluginCode.annotationEditForm.annotation) == -1) {
						_pluginCode.annotationsBox.dispatchEvent(new Event(AnnotationStrings.INVALID_ANNOTATION_INTIME_EVENT, true));
						return;
					}
					restoreAnnotationsInLayout();
					var savedAnnotation:Annotation = _pluginCode.annotationEditForm.returnValidAnnotation(currentTime);
					if (savedAnnotation) {
						index = _pluginCode.annotationsBox.findIndexByAnnotation(savedAnnotation);
						if (index != -1) {
							KAstraAdvancedLayoutUtil.appendToLayoutAt(_pluginCode.annotationsBox, savedAnnotation, index, 100, 100);
							saveAnnotationsToLocalObject();
						}
						else {
							
							addTimelineMarker(savedAnnotation.inTime);
							_pluginCode.annotationsBox.addAnnotation(savedAnnotation);
						}
						_pluginCode.gotoViewMode();

					}
					sendNotification("receivedCuePoints", _pluginCode.annotationsBox.millisecTimesArray);
					if (_pluginCode.submissionTarget == AnnotationStrings.LOCAL_DB) {
						var feedbackSessionXml:XML = _pluginCode.annotationsBox.annotationsXML(AnnotationStrings.DRAFT, _entryId, _partnerId);
						sendNotification(Notifications.ANNOTATION_SAVED, {feedbackSessionXML: feedbackSessionXml.toXMLString()});
					}
					*/
					break;
				case Notifications.CANCEL_ANNOTATION:
					restoreAnnotationsInLayout();
					var returnedAnnotation:Annotation = _pluginCode.annotationEditForm.canceledAnnotation();
					if (returnedAnnotation) {
						index = _pluginCode.annotationsBox.findIndexByAnnotation(returnedAnnotation);
						if (index != -1) {
							KAstraAdvancedLayoutUtil.appendToLayoutAt(_pluginCode.annotationsBox, returnedAnnotation, index, 100, 100);
						}
						_pluginCode.gotoViewMode();
					}

					if (_pluginCode.annotationsBox.dataProvider.length == 0) {
						_pluginCode.showAnnotationsPlugin = false;
						restoreFocus();
					}
					break;

				case Notifications.ANNOTATION_DELETED:
					var removedAnnotation:Annotation = notification.getBody().annotation as Annotation;
					removeTimelineMarker(removedAnnotation.inTime);
					if (_pluginCode.annotationsBox.dataProvider.length == 0) {
						_pluginCode.showAnnotationsPlugin = false;
						restoreFocus();
					}
					sendNotification("receivedCuePoints", _pluginCode.annotationsBox.millisecTimesArray);
					break;
				case NotificationType.HAS_OPENED_FULL_SCREEN:

					_userModeBeforeFS = _pluginCode.userMode;
					_pluginCode.userMode = AnnotationStrings.CANDIDATE;

					break;
				case NotificationType.HAS_CLOSED_FULL_SCREEN:

					_pluginCode.userMode = _userModeBeforeFS;
					trace(_userModeBeforeFS);

					break;
				case Notifications.RESET_ANNOTATIONS_COMPONENT:
					resetAnnotationComponent();
					break;
				case NotificationType.PLAYER_PLAY_END:
					if (_pluginCode.annotationsBox.dataProvider && _pluginCode.annotationsBox.dataProvider.length)
						_pluginCode.annotationsBox.scrollToInTime(_pluginCode.annotationsBox.dataProvider.getItemAt(0).inTime);
					break;
				case Notifications.SAVE_AS_DRAFT:
					if (_pluginCode.submissionTarget == AnnotationStrings.LOCAL_DB) {
						var feedbackSessionXml2:XML = _pluginCode.annotationsBox.annotationsXML(AnnotationStrings.DRAFT, _entryId, _partnerId);
						sendNotification(Notifications.FEEDBACK_SESSION_SUBMITTED, {feedbackSessionXML: feedbackSessionXml2.toXMLString()});
					}
					break;
			}


		}
		
		private function switchToEditMode(annot:Annotation):void{
			annot.viewMode	= AnnotationStrings.EDIT_MODE;
			var ae:AnnotationEvent	= new AnnotationEvent(AnnotationEvent.EDIT_ANNOTATION, annot);
			
			onAnnotationEdit(ae);
		}

		protected function storeAnnotation(persistMode:Boolean	= false):void{
			if(!(viewComponent as annotationsPluginCode).inEditMode){
				var responseXML:XML = (viewComponent as annotationsPluginCode).annotationsBox.annotationsXML(AnnotationStrings.DRAFT, _entryId, _partnerId);
				sendNotification(Notifications.NOT_IN_EDIT_MODE, {feedbackSessionXML: responseXML.toXMLString()});
				(viewComponent as annotationsPluginCode).messageText	= AnnotationStrings.NOT_IN_EDIT_MODE;
				return;
			}
			
			sendNotification(NotificationType.DO_PAUSE);
			var index:int;
			var currentTime = Math.floor(_playerMediaMediator.getCurrentTime());
			var currTimeIndex:int = _pluginCode.annotationsBox.findIndexByInTime(currentTime);
			
			if (currTimeIndex != -1 && _pluginCode.annotationsBox.findIndexByAnnotation(_pluginCode.annotationEditForm.annotation) == -1) {
				_pluginCode.annotationsBox.dispatchEvent(new Event(AnnotationStrings.INVALID_ANNOTATION_INTIME_EVENT, true));
				return;
			}
			restoreAnnotationsInLayout();
			var savedAnnotation:Annotation = _pluginCode.annotationEditForm.returnValidAnnotation(currentTime);
			if (savedAnnotation) {
				index = _pluginCode.annotationsBox.findIndexByAnnotation(savedAnnotation);
				if (index != -1) {
					KAstraAdvancedLayoutUtil.appendToLayoutAt(_pluginCode.annotationsBox, savedAnnotation, index, 100, 100);
					saveAnnotationsToLocalObject();
				}
				else {
					
					addTimelineMarker(savedAnnotation.inTime);
					_pluginCode.annotationsBox.addAnnotation(savedAnnotation);
				}
				_pluginCode.gotoViewMode();
				
			}
			sendNotification("receivedCuePoints", _pluginCode.annotationsBox.millisecTimesArray);
			if (_pluginCode.submissionTarget == AnnotationStrings.LOCAL_DB) {
				var feedbackSessionXml:XML = _pluginCode.annotationsBox.annotationsXML(AnnotationStrings.DRAFT, _entryId, _partnerId);
				sendNotification(Notifications.ANNOTATION_SAVED, {feedbackSessionXML: feedbackSessionXml.toXMLString()});
			}
			
			(viewComponent as annotationsPluginCode).messageText	= AnnotationStrings.ANNOTATION_SAVED;
			
			if(persistMode)
				switchToEditMode(savedAnnotation);
		}
		
		/**
		 * Function is in charge of loading the entry associated with the loaded feedback session.
		 * @param e - KalturaEvent
		 *
		 */
		protected function onParentAcquired(data:Object):void {
			if ((data is KalturaEvent) && _entryId != (data.data as KalturaAnnotation).entryId) {
				sendNotification(NotificationType.CHANGE_MEDIA, {entryId: (data.data as KalturaAnnotation).entryId});
			}
			else if ((data is XML) && _entryId != data.@status[0].toString()) {
				var feedbackSessionStatus:String = data.@status[0].toString();
				_pluginCode.userMode = (feedbackSessionStatus == AnnotationStrings.FINAL) ? AnnotationStrings.CANDIDATE : AnnotationStrings.REVIEWER;
				_pluginCode.annotationsBox.xmlToAnnotations(data as XML);
				sendNotification("receivedCuePoints", _pluginCode.annotationsBox.millisecTimesArray);
				if (!_pluginCode.showAnnotationsPlugin) {
					_pluginCode.showAnnotationsPlugin = true;
				}
			}
			else {
				loadFeedbackSession();
			}
		}


		/**
		 * Handler for a failed
		 * @param e
		 *
		 */
		protected function onParentFeedbackFailed(e:KalturaEvent):void {
			trace("feedback session load failed");
			sendNotification(NotificationType.ALERT, {message: AnnotationStrings.INVALID_FEEDBACK_SESSION_MESSAGE, title: AnnotationStrings.INVALID_FEEDBACK_SESSION_TITLE});
		}


		/**
		 *
		 * @param e
		 *
		 */
		protected function onAnnotationDeleted(e:AnnotationEvent):void {
			_annotationToDelete = e.annotation;
			sendNotification(NotificationType.ALERT, {message: "Are you sure you want to delete the annotation?", title: "Attention!", buttons: ["Yes", "No"], callbackFunction: annotationDeleteClicked});
		/*_pluginCode.annotationsBox.removeAnnotation(e.annotation);
		 sendNotification(Notifications.ANNOTATION_DELETED, {annotation: e.annotation});*/
		}


		private function annotationDeleteClicked(e:Event = null):void {
			if (e.currentTarget is AutoSizeButton) {
				if ((e.currentTarget as AutoSizeButton).label == "Yes" && _annotationToDelete) {
					_pluginCode.annotationsBox.removeAnnotation(_annotationToDelete);
					if (_pluginCode.submissionTarget == AnnotationStrings.KALTURA) {
						sendNotification(Notifications.ANNOTATION_DELETED, {annotation: _annotationToDelete});
					}
					else {
						var feedbackSessionXml:XML = _pluginCode.annotationsBox.annotationsXML(AnnotationStrings.DRAFT, _entryId, _partnerId);
						sendNotification(Notifications.ANNOTATION_DELETED, {annotation: _annotationToDelete, feedbackSessionXML: feedbackSessionXml.toXMLString()});
					}
				}
				_annotationToDelete = null;

			}
		}


		/**
		 *
		 * @param e
		 *
		 */
		protected function onAnnotationEdit(e:AnnotationEvent):void {
			//fix bug: we cannot pass current edited annotation to externalInterface, so we create a copy
			//////////////////////////////////////////////////////////////////////////
			var annotationCopy:Annotation = new Annotation(e.annotation.viewMode,e.annotation.inTime, e.annotation.annotationText, e.annotation.entryId, e.annotation.kalturaAnnotation);
			sendNotification(Notifications.EDIT_ANNOTATION, {annotation: annotationCopy});
			//////////////////////////////////////////////////////////////////////////
			
			var editAnnotation:Annotation = e.annotation;
			KAstraAdvancedLayoutUtil.removeFromLayout(_pluginCode.annotationsBox, editAnnotation);
			removeAnnotationsFromLayout();
			_pluginCode.gotoEditMode();
			_pluginCode.annotationEditForm.openAnnotationForEditing(editAnnotation);
		}


		protected function onAnnotationClick(e:AnnotationEvent):void {
			sendNotification(Notifications.SKIP_TO_ANNOTATION_TIME, {time: e.annotation.inTime})
			if (_playerPlayedOnce) {
				sendNotification(NotificationType.DO_SEEK, e.annotation.inTime);
			}
			else {
				var vo:MediaVO = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo;
				vo.mediaPlayFrom = e.annotation.inTime;
				_shouldPause = true;
				sendNotification(NotificationType.DO_PLAY);
			}
		}
		
		/**
		 * temporaly remove annotations from layout to fix tabIndex issues
		 * */
		private function removeAnnotationsFromLayout(): void {
			_annotationsArr = new Array();
			for (var i:int = 0; i < _pluginCode.annotationsBox.numChildren; i++) {
				//save to append back later on
				_annotationsArr.push(_pluginCode.annotationsBox.getChildAt(i));
			}
			for (var j:int = 0; j < _annotationsArr.length; j++) {
				KAstraAdvancedLayoutUtil.removeFromLayout(_pluginCode.annotationsBox, _annotationsArr[j]);
			}
		}
		
		/**
		 * restore annotations in view mode
		 * */
		private function restoreAnnotationsInLayout(): void {
			if (!_annotationsArr)
				return;
			
			for (var i:int = 0; i < _annotationsArr.length; i++) {
				KAstraAdvancedLayoutUtil.appendToLayoutAt(_pluginCode.annotationsBox, _annotationsArr[i], i, 100, 100);
			}
			_annotationsArr = null;
		}

		
		protected function initTimelineMetadata():void {
			_timelineMetadata = new TimelineMetadata(_player.media);
			_timelineMetadata.addEventListener(TimelineMetadataEvent.MARKER_TIME_REACHED, onMarkerReached);
		}


		protected function addTimelineMarker(inTime:Number):void {
			if (_timelineMetadata) {
				_timelineMetadata.addMarker(new TimelineMarker(inTime));
			}
		}


		protected function removeTimelineMarker(inTime:Number):void {
			if (_timelineMetadata) {
				_timelineMetadata.removeMarker(new TimelineMarker(inTime));
			}
		}


		protected function onMarkerReached(e:TimelineMetadataEvent):void {

			_pluginCode.annotationsBox.scrollToInTime(e.marker.time);
		}


		/**
		 * Function responsible for loading the saved annotations from the user's local SharedObject into
		 * the annotations tool.
		 *
		 */
		protected function configureLocalSavedAnnotations():void {
			if (_pluginCode.hasEventListener(AnnotationStrings.ANNOTATIONS_LIST_CHANGED_EVENT)) {
				_pluginCode.removeEventListener(AnnotationStrings.ANNOTATIONS_LIST_CHANGED_EVENT, saveAnnotationsToLocalObject)
			}

			_pluginCode.annotationsBox.reset();
			try {
				var so:SharedObject = SharedObject.getLocal(ANNOTATIONS_SO_PREFIX + _entryId);
			}
			catch (e:Error) {

			}
			_unsavedAnnotationSO = so ? so.data.savedAnnotations as Array : new Array();

			if (_unsavedAnnotationSO && _unsavedAnnotationSO.length != 0) {
				sendNotification(Notifications.LOAD_LOCAL_SAVED_ANNOTATIONS);
			}
			else {
				_unsavedAnnotationSO = new Array();

				sendNotification("receivedCuePoints", new Array());

				_pluginCode.showAnnotationsPlugin = false;

				_pluginCode.addEventListener(AnnotationStrings.ANNOTATIONS_LIST_CHANGED_EVENT, saveAnnotationsToLocalObject);
			}
		}


		/**
		 * Function responsible for saving the user's unsubmitted annotations to a local SharedObject.
		 * @param e
		 *
		 */
		protected function saveAnnotationsToLocalObject(e:Event = null):void {
			if (_flashvars.allowCookies=="true" && _pluginCode.useSharedObject) {
				_unsavedAnnotationSO = _pluginCode.annotationsBox.getAllObjectsInFieldAsArray("annotation");
				try {
					SharedObject.getLocal(ANNOTATIONS_SO_PREFIX + _entryId).data.savedAnnotations = _unsavedAnnotationSO;
					SharedObject.getLocal(ANNOTATIONS_SO_PREFIX + _entryId).flush();
				}
				catch (e:Error) {
					trace ("Could not save annotation to cookie: No access to user's file system");
				}
			}
		}


		/**
		 * Function contains the logic which submits the annotations currently found in the
		 * annotations box and submits it to the server as a feedback session.
		 * @param kalturaAnnotationsArray - the array of the annotations currently found in the annotations box.
		 *
		 */
		protected function submitFeedbackSession(kalturaAnnotationsArray:Array):void {
			if (_pluginCode.submissionTarget == AnnotationStrings.KALTURA) {
				var kalturaClient:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;

				var parentAnnotation:KalturaAnnotation = new KalturaAnnotation();
				parentAnnotation.entryId = _entryId;

				var createParentAnnotation:AnnotationAdd = new AnnotationAdd(parentAnnotation);

				createParentAnnotation.addEventListener(KalturaEvent.COMPLETE, onParentAnnotationCreated);
				createParentAnnotation.addEventListener(KalturaEvent.FAILED, onCreateParentAnnotationFailed);
				kalturaClient.post(createParentAnnotation);
			}
			else {
				onFeedbackSaved(null);
			}

			function onParentAnnotationCreated(e:KalturaEvent):void {
				var parentId:String = (e.data as KalturaAnnotation).id;
				var submitAnnotationsMultiRequest:MultiRequest = new MultiRequest();
				var addAnnotationToParent:AnnotationAdd;

				for (var i:int = 0; i < kalturaAnnotationsArray.length; i++) {
					var currentAnnotationToAdd:KalturaAnnotation = kalturaAnnotationsArray[i];
					currentAnnotationToAdd.parentId = parentId;
					addAnnotationToParent = new AnnotationAdd(currentAnnotationToAdd);
					submitAnnotationsMultiRequest.addAction(addAnnotationToParent);
				}
				submitAnnotationsMultiRequest.addEventListener(KalturaEvent.COMPLETE, onFeedbackSaved);
				submitAnnotationsMultiRequest.addEventListener(KalturaEvent.FAILED, onFeedbackSaveFailed);
				kalturaClient.post(submitAnnotationsMultiRequest);
			}

			function onCreateParentAnnotationFailed(e:KalturaEvent):void {
				sendNotification(Notifications.FEEDBACK_SESSION_SUBMITTED, {error: e.error.errorMsg});
				trace("failed");
			}

			function onFeedbackSaved(e:KalturaEvent = null):void {
				trace("Feedback saved successfully");
				if (e) {
					sendNotification(Notifications.FEEDBACK_SESSION_SUBMITTED, {notificationId: e.data[0].parentId});
				}
				else {

					var feedbackSessionXml:XML = _pluginCode.annotationsBox.annotationsXML(AnnotationStrings.FINAL, _entryId, _partnerId);
					sendNotification(Notifications.FEEDBACK_SESSION_SUBMITTED, {feedbackSessionXML: feedbackSessionXml.toXMLString()});

				}
				//resetAnnotationComponent();
				resetCookieForSessionId();
				_pluginCode.userMode = AnnotationStrings.CANDIDATE;

			}

			function onFeedbackSaveFailed(e:KalturaEvent):void {
				sendNotification(Notifications.FEEDBACK_SESSION_SUBMITTED, {error: e.error.errorMsg});
				trace("Feedback not saved");
			}
		}


		protected function resetAnnotationComponent():void {
			_pluginCode.annotationsBox.reset();
			resetCookieForSessionId();
			_pluginCode.showAnnotationsPlugin = false;
			sendNotification("receivedCuePoints", _pluginCode.annotationsBox.millisecTimesArray);
		}


		protected function resetCookieForSessionId():void {
			if (_flashvars.allowCookies=="true")
			{
				try {
					SharedObject.getLocal(ANNOTATIONS_SO_PREFIX + _entryId).data.savedAnnotations = null;
					SharedObject.getLocal(ANNOTATIONS_SO_PREFIX + _entryId).flush();
				}
				catch (e:Error) {
					trace ("Could not save annotation to cookie: No access to user's file system");
				}
			}
		}


		protected function loadFeedbackSession():void {
			var kc:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;

			var filterAnnotationsList:KalturaAnnotationFilter = new KalturaAnnotationFilter();
			filterAnnotationsList.parentIdEqual = _sessionId;
			var getAnnotationsList:AnnotationList = new AnnotationList(filterAnnotationsList);

			getAnnotationsList.addEventListener(KalturaEvent.COMPLETE, onSessionsAnnotationsLoaded);
			getAnnotationsList.addEventListener(KalturaEvent.FAILED, onSessionAnnotationsFailed);

			kc.post(getAnnotationsList);
		}


		protected function onSessionsAnnotationsLoaded(e:KalturaEvent):void {
			if (!_pluginCode.showAnnotationsPlugin) {
				_pluginCode.showAnnotationsPlugin = true;
			}
			var kalturaAnnotationList:Array = e.data.objects as Array;
			if (kalturaAnnotationList && kalturaAnnotationList.length) {
				for (var i:int = 0; i < kalturaAnnotationList.length; i++) {
					var annotations2Add:Annotation = new Annotation(AnnotationStrings.VIEW_MODE, -1, "", "", kalturaAnnotationList[i] as KalturaAnnotation, _pluginCode.annotationsBox.initialTabIndex);
					_pluginCode.annotationsBox.addAnnotation(annotations2Add);
				}

				sendNotification("receivedCuePoints", _pluginCode.annotationsBox.millisecTimesArray);
			}
		}


		protected function onSessionAnnotationsFailed(e:KalturaEvent):void {

		}

		
		/**
		 * show/hide "too many characters" message 
		 * @param e
		 * 
		 */
		protected function handleAnnotationMaxLength(e:AnnotationEvent):void {
			switch (e.type) {
				case AnnotationEvent.MAX_LENGTH_REACHED:
					_pluginCode.messageText = MessageStrings.getString("INVALID_ANNOTATION_LENGTH_MESSAGE");
					break;
				case AnnotationEvent.MAX_LENGTH_FIXED:
					_pluginCode.messageText = '';
					break;
			
			}
		}
		
		/**
		 * return the focus to "addAnnotation" button, if exists 
		 * 
		 */		
		public function restoreFocus():void 
		{
			if (facade["bindObject"]["addAnnotationBtn"])
				( facade["bindObject"]["addAnnotationBtn"] as UIComponent).setFocus();
			
		}
	}
}