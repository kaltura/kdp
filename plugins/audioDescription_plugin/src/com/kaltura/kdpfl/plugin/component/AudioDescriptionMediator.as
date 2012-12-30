package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.vo.KalturaMediaEntry;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AudioDescriptionMediator extends Mediator
	{
		public static const NAME:String = "audioDescriptionMediator";
		private var _entryId:String = "";
		private var _file:String = "";
		public var audioDescriptionPluginCode:AudioDescriptionPluginCode;

		public function AudioDescriptionMediator(viewComponent:Object=null)
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
						"playerPlayed",
						"playerPlayEnd",
						"playerPaused",
						"audioDescriptionClicked"
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
					if (_entryId != entry)
					{
						var config: Object =  facade.retrieveProxy("configProxy");
						var flashvars:Object = config.getData().flashvars;
						_entryId = entry;

						var volume:Number = audioDescriptionPluginCode.volume;
						//to keep backward competability
						if (flashvars.audiodescription && flashvars.audiodescription.volume)
						{
							volume = parseFloat (flashvars.audiodescription.volume);
							
						}
						(view as AudioDescription).setVolume (volume);

						var state:Boolean = audioDescriptionPluginCode.state;
						//to keep backward competability
						if (flashvars.audiodescription && flashvars.audiodescription.state && flashvars.audiodescription.state == "false")
						{
							state = false;
						}
						if (!state)
						{
							facade.sendNotification ("setAudioDescriptionToOff");
						}

						
						if (_file == null || _file == "")
						{
							//to keep backward competability
							if (flashvars.audiodescription && flashvars.audiodescription.file) 
								loadFile(flashvars.audiodescription.file);
						}
						else
						{
							var kc:KalturaClient =  facade.retrieveProxy("servicesProxy")["kalturaClient"];
							var getEntry:BaseEntryGet = new BaseEntryGet (flashvars.captions.entryID);

							getEntry.addEventListener (KalturaEvent.COMPLETE, onGetEntryResult);
							getEntry.addEventListener (KalturaEvent.FAILED, onGetEntryError);
							kc.post (getEntry);
						}
					}
				}
				break;

				case "playerPlayed":
				{
					(view as AudioDescription).play();
				}
				break;

				case "playerPlayEnd":
				{
					(view as AudioDescription).setSeek(0);
				}
				break;

				case "playerPaused":
				{
					(view as AudioDescription).pause();
				}
				break;

				case "audioDescriptionClicked":
				{
					(view as AudioDescription).audioDescriptionClicked();
				}
				break;
			}
		}
		
		/**
		 * load the given fileUrl and saves it as _file 
		 * @param fileUrl
		 * 
		 */		
		public function loadFile(fileUrl:String):void 
		{
			_file = fileUrl;
			(view as AudioDescription).addEventListener(IOErrorEvent.IO_ERROR, onAudioFileError );
			(view as AudioDescription).loadFile(_file);
		}
		
		private function onGetEntryResult(evt:Object):void
		{
			var me:KalturaMediaEntry = evt["data"] as KalturaMediaEntry;
			loadFile(me.downloadUrl);
		}
		
		private function onGetEntryError(evt:Object):void
		{
			trace ("Failed to retrieve media");
		}
		
		private function onAudioFileError (evt : IOErrorEvent) : void
		{
			trace ("Failed to create audio file");
		}

		public function set file(value:String) : void
		{
			_file = value;
		}
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}

		public function setScreenSize( w:Number, h:Number) : void  
		{
			// Call when video player window changes size (example fullscreen)
			(view as AudioDescription).setSize(w,h);
		}
	}
}