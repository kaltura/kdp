package com.eyewonder.instream.parser.hardcoded {

	import flash.xml.XMLDocument;
	import flash.events.Event;

	import com.eyewonder.instream.parser.base.TagParserBase;
	import com.eyewonder.instream.parser.events.ParserEvent;
	import com.eyewonder.instream.parser.IParser;

	public dynamic class HardCodedParser extends TagParserBase implements IParser {
	
	
	public function HardCodedParser(){
		super();
		tagType = "HardCoded Parser";
	}
	
	/*
	 * Override this function only.
	 */
	protected function parseXMLData():void
	{
		//Parse Data Here: _adTagXML:XMLDocument is the XML Data
		createUIFvars();
	}
	
	protected function _loadAdXMLHandler(xml:String):void
	{
		dispatchEvent(new Event(ParserEvent.XML_LOADED));
		_sendToPanel("In _loadAdXMLHandler()." );
		
		try {
			_adTagXML = XML(new XMLDocument(xml));
		} catch (e:Error){
			_sendToPanel("_loadAdXMLHandler: Malformed XML data.");
			dispatchError(5);
			return;
		}
		parseXMLData();
	}
	
	/*
	 * parse: Passed in url and handlers to base class to parse 
	 */
	public function parse(xml : String) : void 
	{
		_sendToPanel("In parse("+xml+").");
		_sendToPanel("tagType: " + tagType);
		
		_uifVars = new Object();
		
		adURL = "";
		adTagClickPrepend = "";
		adTagDataURL = "";
		adTagVersion = "";
		adTagInstreamType = "";
		adTagWidth = 0;
		adTagHeight = 0;
		adTagAlignHorizontal = "";
		adTagAlignVertical = "";
		adTagDuration = 0;
		adTagImpr3rdParty = "";
		adTagClick3rdParty = "";
		adTagURLCreativeFormat = "";
		
		_loadAdXMLHandler(xml);
	}
}
}