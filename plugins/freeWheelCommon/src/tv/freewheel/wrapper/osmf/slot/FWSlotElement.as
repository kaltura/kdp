package tv.freewheel.wrapper.osmf.slot
{
	import flash.geom.Rectangle;
	
	import org.osmf.events.PlayEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.layout.LayoutMetadata;
	import org.osmf.layout.ScaleMode;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.TimeTrait;
	
	import tv.freewheel.ad.behavior.IAdManager;
	import tv.freewheel.ad.behavior.IConstants;
	import tv.freewheel.ad.behavior.ISlot;
	import tv.freewheel.logging.Logger;
	import tv.freewheel.wrapper.osmf.events.FWSlotEvent;
	
	public class FWSlotElement extends MediaElement
	{
		private var am:IAdManager;
		private var _slot:ISlot;
		private var slotBounds:Object;
		private var logger:Logger;
		
		/**
		 * Dispatched when a new FreeWheel slot starts.
		 *
		 * @eventType tv.freewheel.wrapper.osmf.events.FWSlotEvent
		 *  
		 */
		[Event(name="slotStart",type="tv.freewheel.wrapper.osmf.events.FWSlotEvent")]
		
		/**
		 * Dispatched when a new FreeWheel slot ends.
		 *
		 * @eventType tv.freewheel.wrapper.osmf.events.FWSlotEvent
		 *  
		 */
		[Event(name="slotEnd",type="tv.freewheel.wrapper.osmf.events.FWSlotEvent")]

		
		public function FWSlotElement(am:IAdManager, slot:ISlot, slotBounds:Object)
		{
			super();
			this.am = am;
			this._slot = slot;
			this.slotBounds = slotBounds;
			this.logger = Logger.getSimpleLogger("FWSlotElement ");
			var playTrait:PlayTrait = new FWSlotPlayTrait(am, slot as ISlot);
			addTrait(MediaTraitType.PLAY, playTrait);
			if(slot.getPhysicalLocation() == am.getConstants().SLOT_LOCATION_PLAYER) {
				var displayTrait:DisplayObjectTrait = new FWSlotDisplayObjectTrait(slot as ISlot, slotBounds);
				addTrait(MediaTraitType.DISPLAY_OBJECT, displayTrait);
				
				var layoutMeta:LayoutMetadata = new LayoutMetadata();
				layoutMeta.scaleMode = ScaleMode.STRETCH;
				this.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, layoutMeta);
				
				playTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
			}
			if (this.supportTimeTrait){
				var timeTrait:TimeTrait = new FWSlotTimeTrait(this.am, this.slot as ISlot);
				timeTrait.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onPlayheadTimeChange, false, 0, true);
				addTrait(MediaTraitType.TIME, timeTrait);
			}

		}
		
		
		
		private function get supportTimeTrait():Boolean{
			if (this.am){
				var c:IConstants = this.am.getConstants();
				return [c.TIME_POSITION_CLASS_PREROLL, c.TIME_POSITION_CLASS_MIDROLL, c.TIME_POSITION_CLASS_POSTROLL].indexOf(this.slot.getTimePositionClass()) > -1;
			}
			return false;
		}
		
		public function get slot():Object {
			return this._slot;
		}
		
		public function get customId():String {
			return this._slot.getCustomId();
		}
		
		/**
		 * This could be one of the following values:
		 *  * preroll
		 *  * midroll
		 *  * postroll
		 *  * overlay
		 *  * display
		 */
		public function get timePositionClass():String {
			return this._slot.getTimePositionClass();
		}
		
		public function get timePosition():Number {
			return this._slot.getTimePosition();
		}
		
		public function setBounds(rect:Rectangle):void{
			this._slot.setBounds(rect.x, rect.y, rect.width, rect.height);
		}
		
		public function preload():void {
			this._slot.preload();
		}
		
		public function play():void {
			var playTrait:PlayTrait = this.getTrait(MediaTraitType.PLAY) as FWSlotPlayTrait;
			if (playTrait)
				playTrait.play();
		}
		
		public function stop():void{
			var playTrait:PlayTrait = this.getTrait(MediaTraitType.PLAY) as FWSlotPlayTrait;
			if (playTrait)
				playTrait.stop();
			var timeTrait:FWSlotTimeTrait = this.getTrait(MediaTraitType.TIME) as FWSlotTimeTrait;
			if (timeTrait)
				timeTrait.stop();
		}
		
		public function pause():void{
			var playTrait:PlayTrait = this.getTrait(MediaTraitType.PLAY) as FWSlotPlayTrait;
			if (playTrait)
				playTrait.pause();
		}

		public function get duration():Number {
			var timeTrait:TimeTrait = this.getTrait(MediaTraitType.TIME) as TimeTrait;
			if(timeTrait) return timeTrait.duration;
			else return NaN;
		}
		
		public function get currentTime():Number {
			var timeTrait:TimeTrait = this.getTrait(MediaTraitType.TIME) as TimeTrait;
			if(timeTrait) return timeTrait.currentTime;
			else return NaN;
		}
		
		protected function onPlayStateChange(e:PlayEvent):void {
			this.logger.debug("onPlayStateChange(" + e.playState + ")");
			switch(e.playState) {
				case PlayState.PLAYING:
					dispatchEvent(new FWSlotEvent(FWSlotEvent.SLOT_START, false, false, this));
					break;
				case PlayState.STOPPED:
					dispatchEvent(new FWSlotEvent(FWSlotEvent.SLOT_END, false, false, this));
					break;
			}
		}
		
		protected function onPlayheadTimeChange(e:TimeEvent):void {
			this.logger.debug("onPlayheadTimeChange(" + e.time + ")");
		}
		
		public function get numAds():int{
			if (this._slot)
				return this._slot.getAdInstances().length;
			else
				return 0;
		}
	}
}
