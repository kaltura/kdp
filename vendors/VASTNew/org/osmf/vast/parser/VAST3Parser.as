package org.osmf.vast.parser
{
	import com.kaltura.utils.ObjectUtil;
	
	import flash.events.Event;
	
	import org.osmf.vast.parser.base.Parser;
	import org.osmf.vast.parser.base.VAST2InLineElement;
	import org.osmf.vast.parser.base.VAST2TrackingData;
	import org.osmf.vast.parser.base.VAST2WrapperElement;
	import org.osmf.vast.parser.base.events.ParserErrorEvent;
	import org.osmf.vast.parser.base.events.ParserEvent;
	
	public class VAST3Parser extends Parser
	{
		public var totalAds:int;
		private var _trackingData:VAST2TrackingData;
		
		public function VAST3Parser(trackingData:VAST2TrackingData = null) {
			super();
			tagType = "VAST3";
			if (trackingData != null)
				_trackingData = trackingData;
			else
				_trackingData = new VAST2TrackingData();
			
		}
		
		override protected function parseXMLData() : void {
			totalAds = mainXML.children().length();
			
			for each (var ad:XML in mainXML.children())
			{
				var curTracking:VAST2TrackingData = new VAST2TrackingData;
				ObjectUtil.copyObject(_trackingData, curTracking);
				var vast2Parser:VAST2Parser = new VAST2Parser(curTracking);
				vast2Parser.addEventListener(ParserEvent.XML_PARSED, onParserEvent);
				vast2Parser.addEventListener(ParserErrorEvent.XML_ERROR, onParserEvent);
				
				if(ad.@id)
					vast2Parser._adTagID = ad.@id;
				
				if (ad.@sequence)
					vast2Parser.sequence = ad.@sequence;
				
				
				if(ad.Wrapper.AdSystem != undefined) {
					vast2Parser._isVASTXMLWrapper = true;
					dispatchEvent(new Event(VAST2Parser.TOGGLE_VAST_WRAPPER_CALLED));
					vast2Parser._Wrapper = new VAST2WrapperElement( ad.Wrapper, curTracking);
					vast2Parser._Wrapper.parseXMLData();
					
				} else {
					vast2Parser._isVASTXML = true;
					vast2Parser._isVASTXMLWrapper = false;
					vast2Parser._InLine = new VAST2InLineElement(ad.InLine, curTracking);
					vast2Parser._InLine.parseXMLData();
				}
				
				vast2Parser.createVASTvars();
				vast2Parser.createCreativesArrays();
			}
			
			
		}
		
		private function onParserEvent(e:ParserEvent):void
		{
			e.target.removeEventListener(ParserEvent.XML_PARSED, onParserEvent);
			e.target.removeEventListener(ParserErrorEvent.XML_ERROR, onParserEvent);
			this.dispatchEvent(new ParserEvent(e.type, e.uifVars));
		}
		
	}
}