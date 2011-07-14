package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.commands.captionAsset.CaptionAssetGetDownloadUrl;
	import com.kaltura.commands.captionAsset.CaptionAssetList;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.controller.media.GetMediaCommand;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.kdpfl.view.controls.VolumeMediator;
	import com.kaltura.vo.KalturaCaptionAsset;
	import com.kaltura.vo.KalturaCaptionAssetFilter;
	import com.kaltura.vo.KalturaCaptionAssetListResponse;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.type.ClosedCaptionsNotifications;
	
	import flash.display.DisplayObject;
	import flash.errors.IOError;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.SharedObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.Notification;

	public class ClosedCaptionsMediator extends Mediator
	{
		public static const NAME:String = "closedCaptionsMediator";
		private var _entryId:String = "";
		private var _flashvars:Object = null;
		private var _defaultFound : Boolean = false;
		private var _closedCaptionsDefs : ClosedCaptionsPluginCode;
		//new Boolean flag indicating that the entry is currently showing embedded rather than external captions.
		private var _showingEmbeddedCaptions : Boolean = false;
		private var _embeddedCaptionsId : String;
		
		private var _mediaProxy : MediaProxy;

		public function ClosedCaptionsMediator (closedCaptionsDefs:ClosedCaptionsPluginCode , viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_closedCaptionsDefs = closedCaptionsDefs;
		}
		
		override public function listNotificationInterests():Array
		{
			return  [
						"mediaReady",
						"mediaLoaded",
						"entryReady",
						"loadMedia",
						"playerUpdatePlayhead",
						"rootResize",
						"closedCaptionsClicked",
						"changedClosedCaptions",
						"layoutReady",
						"showHideClosedCaptions",
						"closedCaptionsSelected",
						"closedCaptionsSwitched",
						"newClosedCaptionsData",
						"playerPlayEnd",
						NotificationType.HAS_OPENED_FULL_SCREEN,
						NotificationType.HAS_CLOSED_FULL_SCREEN
					]; 
		}
		
		override public function handleNotification(note:INotification):void
		{
			var eventName:String = note.getName();
			var data:Object = note.getBody();
			_mediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			var entry:String = _mediaProxy["vo"]["entry"]["id"];
			
			var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			
			//If the player is currently playing an advertisement, no need to do anything related to captions.
			if(sequenceProxy.vo.isInSequence)
			{
				return;
			}

			switch (eventName)
			{
				case "entryReady":
					loadEntryCCData ();
					break;
				case "mediaLoaded":
					addTextHandler();
					
					break;
				case "mediaReady":
				case "changedClosedCaptions":
				{
					
					(view as ClosedCaptions).visible=true
					var config: Object =  facade.retrieveProxy("configProxy");
					var flashvars:Object = config.getData().flashvars;
					
					if (_mediaProxy["vo"]["media"] != null )
					{
						_entryId = entry;
						_flashvars = flashvars;
						
						
						if (_closedCaptionsDefs["type"] == null || _closedCaptionsDefs["type"] == "")
						{
							_closedCaptionsDefs["type"] = "srt";
						}

						if (_closedCaptionsDefs["ccUrl"] != null && _closedCaptionsDefs["ccUrl"] != "")
						{
							(view as ClosedCaptions).loadCaptions(_closedCaptionsDefs["ccUrl"], _closedCaptionsDefs["type"]);
						}
						else if (_closedCaptionsDefs["entryID"] != null && _closedCaptionsDefs["entryID"] != "")
						{
							var kc:KalturaClient =  facade.retrieveProxy("servicesProxy")["kalturaClient"];
							var getEntry:BaseEntryGet = new BaseEntryGet (_closedCaptionsDefs["entryID"]);

							getEntry.addEventListener (KalturaEvent.COMPLETE, onGetEntryResult);
							getEntry.addEventListener (KalturaEvent.FAILED, onGetEntryError);
							kc.post (getEntry);
						}
						else
						{
							(view as ClosedCaptions).visible = false;
						}
					}
				}
				break;
				
				case "layoutReady":
					this.setStyleName(_closedCaptionsDefs["skin"]);
					this.setBGColor(_closedCaptionsDefs["bg"]);
					this.setOpacity(_closedCaptionsDefs["opacity"]);
					this.setFontFamily(_closedCaptionsDefs["fontFamily"]);
					(viewComponent as ClosedCaptions).setFontSize(_closedCaptionsDefs["fontsize"]);
					if (!_closedCaptionsDefs["fullscreenRatio"])
					{
						_closedCaptionsDefs["fullscreenRatio"] = (viewComponent as ClosedCaptions).stage.fullScreenHeight / (viewComponent as ClosedCaptions).stage.stageHeight;
					}
					(viewComponent as ClosedCaptions).fullScreenRatio = _closedCaptionsDefs["fullscreenRatio"];
					(view as ClosedCaptions).addEventListener(IOErrorEvent.IO_ERROR, onCCIOError);
					(view as ClosedCaptions).addEventListener(ErrorEvent.ERROR, onCCGeneralError);
					(view as ClosedCaptions).addEventListener(AsyncErrorEvent.ASYNC_ERROR, onCCGeneralError);
					(view as ClosedCaptions).addEventListener(SecurityErrorEvent.SECURITY_ERROR, onCCGeneralError);
					(view as ClosedCaptions).addEventListener( ClosedCaptions.ERROR_PARSING_SRT, onErrorParsingCC );
					(view as ClosedCaptions).addEventListener( ClosedCaptions.ERROR_PARSING_TT, onErrorParsingCC );
					
					break;
				
				case "playerUpdatePlayhead":
					(view as ClosedCaptions).updatePlayhead (data as Number);
				break;
				
				case "rootResize":
					setScreenSize(data.width, data.height);
				break;

				case "closedCaptionsClicked":
					(view as ClosedCaptions).closedCaptionsClicked ();
				break;
				
				case ClosedCaptionsNotifications.SHOW_HIDE_CLOSED_CAPTIONS:
					(view as ClosedCaptions).visible = !(view as ClosedCaptions).visible;
					break;
				case "closedCaptionsSelected":
					var currentLabel : String = note.getBody().label;
					for each (var ccObj : KalturaCaptionAsset in _closedCaptionsDefs.availableCCFiles)
					{
						if (currentLabel == ccObj.label)
						{
							if (ccObj.type == "tx3g")
							{
								switchEmbeddedTrack( ccObj.trackId );
							}
							else
							{
								switchActiveCCFile( ccObj );
							}
							
							if ( ccObj.language )
							{
								try
								{
									var sharedObj : SharedObject = SharedObject.getLocal("Kaltura_CC_SO");
									sharedObj.data.language = ccObj.language;
									sharedObj.flush();
								}
								catch (e : Error)
								{
									sendNotification( NotificationType.ALERT, {message: "Application is unable to access your file system.", title: "Error saving localized settings"} );
								}
							}
							
							break;
						}
					
					}
					
					break;
				case "closedCaptionsSwitched":
					break;
				case "newClosedCaptionsData":
					
					parseEntryCCData();
					
					break;
				case "playerPlayEnd":
					(viewComponent as ClosedCaptions).setText("");
					break;
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					(viewComponent as ClosedCaptions).isInFullScreen = true;
					break;
				case NotificationType.HAS_CLOSED_FULL_SCREEN:
					(viewComponent as ClosedCaptions).isInFullScreen = false;
					break;
			}
		}
		
		private function addTextHandler () : void
		{
			_mediaProxy.videoElement.client.addHandler( "onTextData" , onTextData );
		}
		
		private function onTextData (info : Object) : void
		{
			if (_showingEmbeddedCaptions)
				(viewComponent as ClosedCaptions).setText(info.text);
		}
		
		private function onCCIOError (e : Event) : void
		{
			sendNotification( ClosedCaptionsNotifications.CC_IO_ERROR );
		}
		
		private function onCCGeneralError (e : Event) : void
		{
			sendNotification( ClosedCaptionsNotifications.CC_ERROR );
		}
		
		private function onErrorParsingCC (e : ErrorEvent) : void
		{
			sendNotification( ClosedCaptionsNotifications.CC_FAILED_TO_VALIDATE );
		}
		
		private function onGetEntryResult(evt:Object):void
		{
			var me:KalturaMediaEntry = evt["data"] as KalturaMediaEntry;
			(view as ClosedCaptions).loadCaptions(me.downloadUrl, _flashvars.captions.type);
		}
		
		private function onGetEntryError(evt:Object):void
		{
			trace ("Failed to retrieve media");
		}
		
		private function loadEntryCCData () : void
		{
			var entryCCDataFilter : KalturaCaptionAssetFilter = new KalturaCaptionAssetFilter();
			
			entryCCDataFilter.entryIdEqual = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entry.id;

			var entryCCDataList : CaptionAssetList = new CaptionAssetList( entryCCDataFilter );
			
			var kalturaClient : KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).vo.kalturaClient;
			
			entryCCDataList.addEventListener( KalturaEvent.COMPLETE, captionsListSuccess );
			entryCCDataList.addEventListener( KalturaEvent.FAILED, captionsListFault );
			
			kalturaClient.post( entryCCDataList );
		}
		
		private function captionsListSuccess (e : KalturaEvent=null) : void
		{
			var listResponse : KalturaCaptionAssetListResponse = e.data as KalturaCaptionAssetListResponse;
			
			for each (var ccItem : KalturaCaptionAsset in listResponse.objects )
			{
				_closedCaptionsDefs.availableCCFiles.push( ccItem );
			}
			
			sendNotification( ClosedCaptionsNotifications.CC_DATA_LOADED );
			
			parseEntryCCData();
		}
		
		private function captionsListFault (e : KalturaEvent=null) : void
		{
			sendNotification( ClosedCaptionsNotifications.CC_DATA_LOAD_FAILED );
		}
		
		private function parseEntryCCData () : void
		{
			_defaultFound = false;
			
			var preferredLang : String;
			try
			{
				var sharedObj : SharedObject =  SharedObject.getLocal( "Kaltura_CC_SO" );
				preferredLang = sharedObj.data.language;
			}
			catch (e : Error)
			{
				sendNotification( NotificationType.ALERT, {message: "Application is unable to access your file system.", title: "Error saving localized settings"} );
			}
			
			var ccFileToLoad : KalturaCaptionAsset;
			for each (var ccObj : KalturaCaptionAsset in _closedCaptionsDefs.availableCCFiles)
			{
				var ccLabelObject : Object = {label: ccObj.label};
				
				_closedCaptionsDefs.availableCCFilesLabels.addItem( ccLabelObject );
				if (ccObj.isDefault)
				{
					_defaultFound = true;
					ccFileToLoad = ccObj;
					
				}
				else if (ccObj.language && ccObj.language == preferredLang)
				{
					ccFileToLoad = ccObj;
				}
			}

			
			if (ccFileToLoad)
			{
				if (ccFileToLoad.format == "tx3g")
				{
					switchEmbeddedTrack( ccFileToLoad.trackId );
				}
				else
				{ 
					switchActiveCCFile ( ccFileToLoad )
				}
			}
		}
		
		private function switchEmbeddedTrack  (id: String) : void
		{
			(viewComponent as ClosedCaptions).currentCCFile = new Array();
			(viewComponent as ClosedCaptions).setText("");
			_embeddedCaptionsId = id;
			_showingEmbeddedCaptions = true;
			
		}
		
		private function switchActiveCCFile ( ccFileAsset : KalturaCaptionAsset) : void
		{
			_showingEmbeddedCaptions = false;
			
			var kalturaClient : KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).vo.kalturaClient;
			
			var getCaptionsUrl : CaptionAssetGetDownloadUrl = new CaptionAssetGetDownloadUrl(ccFileAsset.id );
			
			getCaptionsUrl.addEventListener( KalturaEvent.COMPLETE, loadActiveCCFile );
			
			getCaptionsUrl.addEventListener( KalturaEvent.FAILED, getURLFailed );
			
			kalturaClient.post(getCaptionsUrl);
			
			function loadActiveCCFile ( e : KalturaEvent) : void
			{
				(viewComponent as ClosedCaptions).loadCaptions(e.data as String, ccFileAsset.format);
			}
			
			function getURLFailed ( e : KalturaEvent) : void
			{
				
			}
		}
		
		
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}

		public function setScreenSize( w:Number, h:Number) : void  
		{
			// Call when video player window changes size (example fullscreen)
			(view as ClosedCaptions).setDimensions(w,h);
		}
		
		public function setBGColor (val : String) : void
		{
			(view as ClosedCaptions).bgColor = Number(val);
		}
		
		public function setStyleName ( val : String ) : void
		{
			(view as ClosedCaptions).setSkin(val); 
		}
		
		public function setOpacity ( val : String ) : void
		{
			(view as ClosedCaptions).bgAlpha = val;
		}
		public function setFontFamily (val : String) : void
		{
			(view as ClosedCaptions).fontFamily = val;
		}

	}
}