package com.eyewonder.instream.parser.hardcoded {

	import flash.xml.XMLNode;
	import com.eyewonder.instream.parser.hardcoded.HardCodedParser;

	/**
	 * @author mthomas
	 */
	public dynamic class EWHardCodedParser extends HardCodedParser{
		
		/*
	 * Constructor
	 */
	public function EWHardCodedParser()
	{
		super();
		tagType = "EWHardCoded Parser";
	}
	
	protected override function parseXMLData():void
	{		
		//Parse Data Here: _adTagXML:XMLDocument is the XML Data
		// Allow comments and other XML nodes prior to instreamAd element
		var i:Number;
		for( i = 0; i < _adTagXML.childNodes.length; i++)	// Find instreamAd element
		{
			if ( _adTagXML.childNodes[i].nodeName == "instreamAd" || _adTagXML.childNodes[i].nodeName == "ewAd" /* legacy: use instreamAd instead on new tags */)
				break;
		}
		
		if (i >= _adTagXML.childNodes.length)
		{
			_sendToPanel("_loadAdXMLHandler: Expected parent element not found." );
			dispatchError(4);
			return;
		}
			
		var itr:XMLNode = _adTagXML.childNodes[i];
		
		for( i = 0; i < itr.childNodes.length; i++)
		{
		    var currentTag:XMLNode = itr.childNodes[i];
			if (currentTag.childNodes.length > 0)
			{
				var currentValue:String = currentTag.childNodes[0].nodeValue;
				if (currentTag.nodeName == "adURL")
				{
					adURL = currentValue;
				}
				else if (currentTag.nodeName == "adClickPrepend")
				{
					adTagClickPrepend = currentValue;
					/* Temporarily disabling below into a solution is found to Flash's complaints */
					// _adTagClickPrepend = InstreamFrameworkUtility.strnreplace(_adTagClickPrepend, "[clickthru]", "", 1);
					// _adTagClickPrepend = InstreamFrameworkUtility.strnreplace(_adTagClickPrepend, "[ewclickthru]", "", 1); // legacy
				}
				else if (currentTag.nodeName == "dataURL")
				{
					adTagDataURL = currentValue;			
				}				
				else if (currentTag.nodeName == "adTagVersion")
				{
					adTagVersion = currentValue;			
				}
				else if (currentTag.nodeName == "adWidth")
				{
					adTagWidth = parseInt(currentValue);			
				}
				else if (currentTag.nodeName == "adHeight")
				{
					adTagHeight = parseInt(currentValue);			
				}
				else if (currentTag.nodeName == "adInstreamType")
				{
					adTagInstreamType = currentValue;
				}				
				else if (currentTag.nodeName == "adAlignHorizontal")
				{
					adTagAlignHorizontal = currentValue;
				}				
				else if (currentTag.nodeName == "adAlignVertical")
				{
					adTagAlignVertical = currentValue;
				}
				else if (currentTag.nodeName == "adDuration")
				{
					adTagDuration = parseInt(currentValue);
				}
				else if (currentTag.nodeName == "adImpr3rdParty")
				{
					adTagImpr3rdParty = currentValue;
				}
				else if (currentTag.nodeName == "adClick3rdParty")
				{
					adTagClick3rdParty = currentValue;
				}
				else if (currentTag.nodeName == "adURLCreativeFormat")
				{
					adTagURLCreativeFormat = currentValue;
				}
				else if (currentTag.nodeName == "adComment")
				{
					_sendToPanel("Ad Comment: "+ currentValue);
				}
			}
		}
		createUIFvars();
	}
		
	}
}
