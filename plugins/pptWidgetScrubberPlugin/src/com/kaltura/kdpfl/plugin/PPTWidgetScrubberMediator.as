package com.kaltura.kdpfl.plugin
{
	import com.kaltura.kdpfl.ApplicationFacade;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.controls.ScrubberMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	
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

	
	import mx.binding.utils.BindingUtils;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * Class PPTWidgetScrubberMediator manages the interaction of other classes with 
	 * the custom ppt widget scrubber. 
	 * @author Hila
	 * 
	 */	
	public class PPTWidgetScrubberMediator extends ScrubberMediator
	{
		protected var _videoMarks:Array;
		protected var _gotEntry:Boolean = false;
		protected var _gotMarkers:Boolean = false;
		protected var _videoMarksContainer:PPTWidgetVideoMarksContainer = null;
		protected var _pptScrubber : PPTWidgetScrubber;
		
		/**
		 *constructor. 
		 * @param viewComponent
		 * 
		 */		
		public function PPTWidgetScrubberMediator(viewComponent:Object = null)
		{
			super(viewComponent);
			_videoMarksContainer = viewComponent.videoMarksContainer as PPTWidgetVideoMarksContainer;
			_pptScrubber = viewComponent as PPTWidgetScrubber;
			
		}
		
		override public function handleNotification( note:INotification ):void
		{
			super.handleNotification(note);
			switch( note.getName() )
			{
				case "videoMarksReceived":
					onVideoMarksReceived(note);
					break;
				case "videoMarkAdded":
					onVideoMarkAdded(note);
					break;
				case "videoMarkRemoved":
					onVideoMarkRemoved(note);
					break;
				case "videoMarkHighlight":
					onVideoMarkHighlight(note);
					break;
				case "videoMarksRemoveHighlights":
					onVideoMarksRemoveHighlights(note);
					break;
				case NotificationType.ENTRY_READY:
					onEntryReady(note);
					break;
				case "slidesLoaded":
					enableVideoMarks();
					_videoMarksContainer.enableAllMarks();
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			var notifications:Array = super.listNotificationInterests();
			notifications.push("videoMarksReceived");
			notifications.push("videoMarkHighlight");
			notifications.push("videoMarksRemoveHighlights");
			notifications.push("videoMarkAdded");
			notifications.push("videoMarkRemoved");
			notifications.push(NotificationType.ENTRY_READY);
			notifications.push("slidesLoaded");
			return notifications;
		}
		
		/**
		 * Function activated when the sync-points between the video and the swf are
		 * loaded into the player.  
		 * @param note notification fired by the PPTWidgetAPIPlugin.
		 * 
		 */		
		protected function onVideoMarksReceived(note:INotification):void 
		{
			_gotMarkers = true;
			_videoMarks = note.getBody() as Array;
			if (_gotEntry)
				drawMarks();
		}
		/**
		 * Function activated when the entry (the video) is loaded. 
		 * @param note notification thrown by the PPTWidgetAPIPlugin.
		 * 
		 */		
		protected function onEntryReady(note:INotification):void
		{
			_gotEntry = true;
			
			var mediaProxy:MediaProxy = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy);
			viewComponent.videoMarksContainer.totalTime = mediaProxy.vo.entry.duration * 1000;
			var flashvars:Object = facade.retrieveProxy("configProxy")["vo"]["flashvars"];
			if (mediaProxy.vo.entryExtraData.isAdmin == true || flashvars.adminMode == "true" || flashvars.adminMode == "1")
				viewComponent.videoMarksContainer.adminMode = true;
			
			if (_gotMarkers)
				drawMarks();
		}
		/**
		 * Function activated when a new sync point marker is added to the timeline. 
		 * @param note notification thrown by the PPTWidgetAPIPlugin.
		 * 
		 */		
		protected function onVideoMarkAdded(note:INotification):void
		{
			viewComponent.videoMarksContainer.addMark(note.getBody());
		}
		/**
		 * Function activated when a sync point marker is removed from the timeline. 
		 * @param note notification fired by the PPTWidgetAPIPlugin.
		 * 
		 */		
		protected function onVideoMarkRemoved(note:INotification):void
		{
			viewComponent.videoMarksContainer.removedMark(note.getBody());
			_pptScrubber.hasSelectedMarker = false;
		}
		/**
		 * Function activated when a new sync point marker has been reached and needs to be high-lighted. 
		 * @param note notification fired by the PPTWidgetAPIPlugin.
		 * 
		 */		
		protected function onVideoMarkHighlight(note:INotification):void
		{
			viewComponent.videoMarksContainer.highlightMarker(note.getBody());
			_pptScrubber.hasSelectedMarker = true;
		}
		/**
		 * Function meant to remove high-lighting from all sync-point markers. 
		 * @param note notification fired by the PPTWidgetAPIPlugin.
		 * 
		 */		
		protected function onVideoMarksRemoveHighlights(note:INotification):void
		{
			viewComponent.videoMarksContainer.removeHighlights();
		}
		/**
		 *Function initiates the process of visually adding the sync-point markers to the stage. 
		 * 
		 */		
		protected function drawMarks():void
		{
			trace('drawMarks');
			viewComponent.videoMarksContainer.videoMarks = _videoMarks;
		}
		/**
		 * Activated when a sync-point marker has been clicked. 
		 * @param event event of type PPTWidgetVideoMarkClickedEvent.
		 * 
		 */		
		protected function onVideoMarkClicked(event:PPTWidgetVideoMarkClickedEvent):void 
		{
			// Set the video to the time of the mark
			sendNotification(NotificationType.DO_SEEK, event.videoMarkTime / 1000);
			
			sendNotification("pptWidgetGoToSlide", event.slideIndex);
		}
		/**
		 *  Activated when a marker needs to be updated (the sync-point has been moved to a different point
		 * on the timeline).
		 * @param event
		 * 
		 */		
		protected function onVideoMarkUpdate(event:PPTWidgetVideoMarkUpdateEvent):void
		{
			sendNotification("pptWidgetGoToSlide", event.slideIndex);
			
			if (event.oldTime != event.newTime) 
			{
				sendNotification(NotificationType.DO_SEEK, event.newTime / 1000);
				sendNotification("pptWidgetUpdateMark", {oldTime: event.oldTime, newTime: event.newTime});
			}
		}
		/**
		 * Function which adds the event listeners for marker click/update. Not activated until the actual swf of the slides
		 * has been loaded. 
		 * 
		 */		
		protected function enableVideoMarks () : void
		{
			_videoMarksContainer.addEventListener(PPTWidgetVideoMarkClickedEvent.EVENT_VIDEO_MARK_CLICKED, onVideoMarkClicked);
			_videoMarksContainer.addEventListener(PPTWidgetVideoMarkUpdateEvent.EVENT_VIDEO_MARK_UPDATE, onVideoMarkUpdate);
		}
	}
}