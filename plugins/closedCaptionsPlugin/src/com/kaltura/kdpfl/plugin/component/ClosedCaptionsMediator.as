package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.type.ClosedCaptionsNotifications;
	
	import flash.display.DisplayObject;
	import flash.errors.IOError;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.Notification;

	public class ClosedCaptionsMediator extends Mediator
	{
		public static const NAME:String = "closedCaptionsMediator";
		private var _entryId:String = "";
		private var _flashvars:Object = null;
		private var _closedCaptionsDefs : Object;

		public function ClosedCaptionsMediator (closedCaptionsDefs:Object , viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_closedCaptionsDefs = closedCaptionsDefs;
		}
		
		override public function listNotificationInterests():Array
		{
			return  [
						"changeMedia",
						"mediaReady",
						"durationChange",
						"playerReady",
						"entryReady",
						"loadMedia",
						"playerUpdatePlayhead",
						"rootResize",
						"playerPlayed",
						"hasOpenedFullScreen",
						"hasCloseFullScreen",
						"closedCaptionsClicked",
						"changedClosedCaptions",
						"layoutReady",
						"showHideClosedCaptions"
					];
		}
		
		override public function handleNotification(note:INotification):void
		{
			var eventName:String = note.getName();
			var data:Object = note.getBody();
			var media : Object = facade.retrieveProxy("mediaProxy");
			var entry:String = media["vo"]["entry"]["id"];
			
			var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			
			//If the player is currently playing an advertisement, no need to do anything related to captions.
			if(sequenceProxy.vo.isInSequence)
			{
				return;
			}

			switch (eventName)
			{
				// this means that the main container will be 100% X 100% always
				case "mediaReady":
				case "changedClosedCaptions":
				{
					(view as ClosedCaptions).visible=true
					var config: Object =  facade.retrieveProxy("configProxy");
					var flashvars:Object = config.getData().flashvars;
					
					if (media["vo"]["entry"]["duration"] != null)
					{
						_entryId = entry;
						_flashvars = flashvars;
						
						if (_closedCaptionsDefs["fontsize"] != null && _closedCaptionsDefs["fontsize"] != "")
						{
							var fontSize:int = int(_closedCaptionsDefs["fontsize"]);
							(view as ClosedCaptions).setFontSize (fontSize);
							//_ccScreen.height = Math.round(fontSize * 2.8);
							//trace ("ccScreen set to " + _ccScreen.height);
						}
						
						if (_closedCaptionsDefs["type"] == null || _closedCaptionsDefs["type"] == "")
						{
							_closedCaptionsDefs["type"] = "srt";
						}

						if (_closedCaptionsDefs["ccUrl"] != null && _closedCaptionsDefs["ccUrl"] != "")
						{
							(view as ClosedCaptions).addEventListener(IOErrorEvent.IO_ERROR, onCCIOError);
							(view as ClosedCaptions).addEventListener(ErrorEvent.ERROR, onCCGeneralError);
							(view as ClosedCaptions).addEventListener(AsyncErrorEvent.ASYNC_ERROR, onCCGeneralError);
							(view as ClosedCaptions).addEventListener(SecurityErrorEvent.SECURITY_ERROR, onCCGeneralError);
							(view as ClosedCaptions).addEventListener( ClosedCaptions.ERROR_PARSING_SRT, onErrorParsingCC );
							(view as ClosedCaptions).addEventListener( ClosedCaptions.ERROR_PARSING_TT, onErrorParsingCC );
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
					break;
				
				case "playerUpdatePlayhead":
					(view as ClosedCaptions).updatePlayhead (data as Number);
				break;
				
				case "rootResize":
					setScreenSize(data.width, data.height);
				break;

				case "hasOpenedFullScreen":
					(view as ClosedCaptions).enterFullScreen ();
				break;

				case "hasCloseFullScreen":
					(view as ClosedCaptions).exitFullScreen ();
				break;

				case "closedCaptionsClicked":
					(view as ClosedCaptions).closedCaptionsClicked ();
				break;
				
				case ClosedCaptionsNotifications.SHOW_HIDE_CLOSED_CAPTIONS:
					(view as ClosedCaptions).visible = !(view as ClosedCaptions).visible;
					break;
					
			}
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