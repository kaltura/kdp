package tv.freewheel.wrapper.osmf
{
	import flash.events.EventDispatcher;
	
	import org.osmf.events.TimelineMetadataEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.CuePoint;
	import org.osmf.metadata.CuePointType;
	import org.osmf.metadata.TimelineMetadata;
	
	import tv.freewheel.ad.behavior.ISlot;
	import tv.freewheel.logging.Logger;
	import tv.freewheel.renderer.util.StringUtil;
	import tv.freewheel.wrapper.osmf.events.FWCuePointEvent;

	public class FWTimeline extends EventDispatcher
	{
		private var timeline:TimelineMetadata;
		private var cuePoints:Object;
		private var media:MediaElement;
		
		public function FWTimeline(media:MediaElement)
		{
			this.media = media;
			this.timeline = new TimelineMetadata(media);
			this.timeline.addEventListener(TimelineMetadataEvent.MARKER_TIME_REACHED, onCuePoint);
			media.addMetadata(CuePoint.DYNAMIC_CUEPOINTS_NAMESPACE, this.timeline);
			this.cuePoints = new Object();
		}
		
		public function addSlotAsCuepoint(slot:ISlot, time:String):void{
			var tp:Number = Number(time);
			if (isNaN(tp) || tp < 0)
				return;
			var customId:String = slot.getCustomId();
			this.timeline.addMarker(new CuePoint(CuePointType.ACTIONSCRIPT, tp, customId, slot, slot.getTotalDuration()));
			this.cuePoints[tp] = {'customId': customId, 'enabled': true};
		}
		
		public override function toString():String{
			return StringUtil.objectToString(this.cuePoints);
		}
		
		public function removeSlotFromTimeline(customId:String):void{
			Logger.current.debug('removeSlotFromTimeline(' + customId + ')');
			for (var tp:String in this.cuePoints){
				if (this.cuePoints[tp]['customId'] == customId){
					this.cuePoints[tp]['enabled'] = false;
					return;
				}
			}
		}
		
		public function clear(media:MediaElement = null):void{
			this.media.removeMetadata(CuePoint.DYNAMIC_CUEPOINTS_NAMESPACE);
			this.timeline.removeEventListener(TimelineMetadataEvent.MARKER_TIME_REACHED, onCuePoint);
			if (media){
				this.media = media;
			}
			this.timeline = new TimelineMetadata(this.media);
			this.timeline.addEventListener(TimelineMetadataEvent.MARKER_TIME_REACHED, onCuePoint);
			this.media.addMetadata(CuePoint.DYNAMIC_CUEPOINTS_NAMESPACE, this.timeline);
			this.cuePoints = new Object();
		}
		
		private function onCuePoint(evt:TimelineMetadataEvent):void{
			var cuePoint:Object = this.cuePoints[evt.marker.time];
			if (cuePoint && cuePoint.enabled){
				this.dispatchEvent(new FWCuePointEvent(
					FWCuePointEvent.CUE_POINT_REACHED,
					evt.bubbles,
					evt.cancelable,
					cuePoint.customId,
					evt.marker.time
				));
			}
		}
	}
}