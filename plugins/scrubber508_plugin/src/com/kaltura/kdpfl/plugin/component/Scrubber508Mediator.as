package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.view.controls.KButton;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class Scrubber508Mediator extends Mediator
	{
		public static const NAME:String = "scrubber508Mediator";
		private var _entryId:String = "";
		private var _totalBytes:Number = 0;
		private var _backbtn:KButton;
		private var _fwdbtn:KButton;
		private var _skip:String = "";
		private var _isPlaying:Boolean = false;

		public function Scrubber508Mediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
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
						"hasOpenedFullScreen",
						"hasCloseFullScreen",
						"bytesDownloadedChange",
						"bytesTotalChange",
						"shortcutSkipForward",
						"shortcutSkipBackwards",
						"shortcutPlay",
						"playerPaused",
						"playerPlayed",
						"shortcutFullScreen"
					];
		}
		
		override public function handleNotification(note:INotification):void
		{
			var eventName:String = note.getName();
			var data:Object = note.getBody();
			var media : Object = facade.retrieveProxy("mediaProxy");
			var entry:String = media["vo"]["entry"]["id"];			

			switch (eventName)
			{
				// this means that the main container will be 100% X 100% always
				case "changeMedia":
				case "mediaReady":
				case "durationChange":
				case "playerReady":
				case "entryReady":
				case "loadMedia":
				{
					var config: Object =  facade.retrieveProxy("configProxy");
					var flashvars:Object = config.getData().flashvars;

					if (_entryId != entry && media["vo"]["entry"]["duration"] != null && media["vo"]["entry"]["duration"] > 0)
					{
						_entryId = entry;
						(view as Scrubber508).mediaLoaded(media["vo"]["entry"]["duration"]);
					}
				}
				break;
				
				case "playerUpdatePlayhead":
					(view as Scrubber508).updatePlayhead (data as Number);
					
					if (_skip == "back")
					{
						onBackBtnDown (null);
					}
					else if (_skip == "fwd")
					{
						onFwdBtnDown (null);
					}
				break;
				
				case "bytesTotalChange":
					_totalBytes = data.newValue;
				break;
				
				case "bytesDownloadedChange":
					(view as Scrubber508).bufferProgress (data.newValue as Number, _totalBytes);
				break;
				
				case "rootResize":
					setScreenSize(data.width, data.height);
				break;

				case "hasOpenedFullScreen":
//					(view as ClosedCaptions).enterFullScreen ();
				break;

				case "hasCloseFullScreen":
//					(view as ClosedCaptions).exitFullScreen ();
				break;
				
				case "shortcutPlay":
					facade.sendNotification(_isPlaying ? "doPause" : "doPlay");
				break;
				
				case "shortcutSkipBackwards":
					onBackBtnDown (null);
					onBackBtnUp (null);
				break;
				
				case "shortcutSkipForward":
					onFwdBtnDown (null);
					onFwdBtnUp (null);
				break;
				
				case "playerPlayed":
					_isPlaying = true;
				break;
				
				case "playerPaused":
					_isPlaying = false;
				break;
				
				case "shortcutFullScreen":
					facade.sendNotification("openFullScreen");
				break;
			}
		}
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		public function setScreenSize( w:Number, h:Number) : void  
		{
			// Call when video player window changes size (example fullscreen)
			(view as Scrubber508).setSize(w,h);
		}

		public function set backbtn(value:KButton):void
		{
			_backbtn = value;
			_backbtn.addEventListener(MouseEvent.MOUSE_DOWN, onBackBtnDown);
			_backbtn.addEventListener(MouseEvent.MOUSE_UP, onBackBtnUp);
		}

		public function set fwdbtn(value:KButton):void
		{
			_fwdbtn = value;
			_fwdbtn.addEventListener(MouseEvent.MOUSE_DOWN, onFwdBtnDown);
			_fwdbtn.addEventListener(MouseEvent.MOUSE_UP, onFwdBtnUp);
		}
		
		private function onBackBtnDown (event:MouseEvent):void
		{
			_skip = "back";
			facade.sendNotification("seekBackwards", 5);
		}
		
		private function onBackBtnUp (event:MouseEvent):void
		{
			_skip = "";
		}
		
		private function onFwdBtnDown (event:MouseEvent):void
		{
			_skip = "fwd";
			facade.sendNotification("seekForward", 5);
		}
		
		private function onFwdBtnUp (event:MouseEvent):void
		{
			_skip = "";
		}
	}
}