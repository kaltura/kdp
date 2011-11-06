package  {
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.system.Security;
	
	import tv.freewheel.ad.behavior.IConstants;
	import tv.freewheel.logging.Logger;
	import tv.freewheel.playerextension.kdpanalytics.AdInfo;
	import tv.freewheel.playerextension.kdpanalytics.CustomEvent;
	import tv.freewheel.renderer.util.ParameterParserUtil;
	
	
	public class freeWheelAnalyticsExtension extends Sprite implements IEventDispatcher{
		
		//private static const VERSION:String = BUILD::Version;
		//private static const RDK_VERSION:String = BUILD::RDK_Version;
		
		public static const PARAM_NAMESPACE:String = "extension.kdpanalytics";
		public static const PARAM_LEGACY_NAMESPACE:String = "extension.foxanalytics";
		public static const PARAM_CUSTOM_DATA:String = "customData";
		
		private var logger:Logger;
		private var am:Object;
		private var constants:IConstants;
		
		private var dispatcher:Sprite;
		private var adInfos:Object;
		private var customData:String = "";
		private var slots:Array;
		
		public function freeWheelAnalyticsExtension(){			
			Security.allowDomain("*");
			//trace("new KDPAnalyticsExtension() - Version: " + VERSION + " RDK Version: " + RDK_VERSION);
		}
		
		public function init(am:Object):void {
			if (!am)
				return;
			this.slots = new Array();
			this.am = am;
			this.constants = am.getConstants();
			this.logger = Logger.getLogger(am, this.constants, "KDPAnalyticsExtension ");
			this.logger.debug("init()");
			
			this.am.addEventListener(this.constants.EVENT_RENDERER, onRendererEvent);
			this.am.addEventListener(this.constants.EVENT_SLOT_STARTED, onSlotStarted);
			this.am.addEventListener(this.constants.EVENT_SLOT_ENDED, onSlotEnded);
			
			this.adInfos = new Object();
			
			this.dispatcher = this.am.getVideoDisplay();
			
			this.customData = ParameterParserUtil.parseString(this.am.getParameter(PARAM_NAMESPACE + '.' + PARAM_CUSTOM_DATA), null, 0, -1, true)
				|| ParameterParserUtil.parseString(this.am.getParameter(PARAM_CUSTOM_DATA), null, 0, -1, true)
				|| this.customData;
		}
		
		public function dispose():void {
			this.logger.debug("dispose()");
			if (this.am){
				this.am.removeEventListener(this.constants.EVENT_RENDERER, onRendererEvent);
				this.am.removeEventListener(this.constants.EVENT_SLOT_STARTED, onSlotStarted);
				this.am.removeEventListener(this.constants.EVENT_SLOT_ENDED, onSlotEnded);
			}
		}
		
		private function onSlotStarted(evt:Object):void{
			this.logger.debug("onSlotStarted()");
			var slot:Object = this.am.getSlotByCustomId(evt.slotCustomId);
			if (this.shouldDispatchPodEvents(slot) && this.dispatcher){
				var customId:String = slot.getCustomId();
				this.slots.push(customId);
				this.dispatcher.dispatchEvent(CustomEvent.newPodStartEvent(this.slots.indexOf(customId), this.customData));
			}
		}
		
		private function onSlotEnded(evt:Object):void{
			this.logger.debug("onSlotEnded()");
			this.endAdInSlot(evt.slotCustomId);
			this.endSlot(evt.slotCustomId);
		}
		
		private function endSlot(slotCustomId:String):void{
			this.logger.debug("endSlot(): " + slotCustomId);
			var slot:Object = this.am.getSlotByCustomId(slotCustomId);
			if (this.shouldDispatchPodEvents(slot) && this.dispatcher){
				this.dispatcher.dispatchEvent(CustomEvent.newPodCompleteEvent(this.slots.indexOf(slotCustomId), slot.getTotalDuration(), this.customData));
			}
		}
		
		private function shouldDispatchPodEvents(slot:Object):Boolean{
			this.logger.debug("shouldDispatchPodCompleteEvent(), slot: " + slot.getCustomId() + ", tpc: " + slot.getTimePositionClass());
			var should:Boolean = false;
			switch (slot.getTimePositionClass()){
				case this.constants.TIME_POSITION_CLASS_PREROLL:
				case this.constants.TIME_POSITION_CLASS_POSTROLL:
					should = true;
					break;
				case this.constants.TIME_POSITION_CLASS_MIDROLL:
					if (slot.getTimePosition() != -1){
						should = true;
					}
					break;
			}
			if (slot.getEventCallbackURLs().length == 0)
				should  = false;
			return should;
		}
		
		private function onRendererEvent(evt:Object):void{
			this.logger.debug("onRendererEvent");
			switch (int(evt.subType)){
				case this.constants.RENDERER_EVENT_CLICK:
					this.handleRendererClick(evt);
					break;
				case this.constants.RENDERER_EVENT_IMPRESSION:
					this.handleRendererImpression(evt);
					break;
				case this.constants.RENDERER_EVENT_PAUSE:
					this.handleRendererPause(evt, true);
					break;
				case this.constants.RENDERER_EVENT_RESUME:
					this.handleRendererPause(evt, false);
					break;
				default:
					break;
			}
		}
		
		private function handleRendererClick(evt:Object):void{
			this.logger.debug("handleRendererClick()");
			if (this.adInfos[evt.slotCustomId]){
				var currentAdInfo:AdInfo = this.adInfos[evt.slotCustomId];
				currentAdInfo.click();
			}
		}
		
		private function handleRendererImpression(evt:Object):void{
			this.logger.debug("handleRendererImpression()");
			var slot:Object = this.am.getSlotByCustomId(evt.slotCustomId);
			
			if (slot.getType() != this.constants.SLOT_TYPE_TEMPORAL){
				this.logger.debug("Not a temporal slot, ignore.");
				return;
			}
			
			if (!this.dispatcher){
				throw new Error("ERROR: stage is unavailable.");
				return;
			}
			
			this.addNewAdInfo(slot, evt.adId, evt.creativeId);
		}
		
		private function addNewAdInfo(slot:Object, adId:int, creativeId:int):void{
			this.logger.debug("addNewAdInfo()");
			var slotCustomId:String = slot.getCustomId();
			this.endAdInSlot(slotCustomId);
			var currentAdInfo:AdInfo = new AdInfo(this.dispatcher, slot, adId, creativeId, this.constants, this.customData);
			this.adInfos[slotCustomId] = currentAdInfo;
			this.dispatcher.dispatchEvent(new CustomEvent(CustomEvent.AD_INFO_ADDED, currentAdInfo));
		}
		
		private function endAdInSlot(slotCustomId:String):void{
			this.logger.debug("endAdInSlot(): " + slotCustomId);
			if (this.adInfos[slotCustomId]){
				this.logger.debug("End previous ad in this slot");
				var previousAd:AdInfo = this.adInfos[slotCustomId];
				previousAd.complete();
				this.adInfos[slotCustomId] = null;
			}
		}
		
		private function handleRendererPause(evt:Object, pause:Boolean):void{
			this.logger.debug("handleRendererPause(): " + pause);
			if (this.adInfos[evt.slotCustomId]){
				var currentAdInfo:AdInfo = this.adInfos[evt.slotCustomId];
				if (pause)
					currentAdInfo.pause();
				else
					currentAdInfo.resume();
			}
		}
	}
}
