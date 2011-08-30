/*
EWParser.as

Universal Instream Framework
Copyright (c) 2006-2009, Eyewonder, Inc
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
 * Neither the name of Eyewonder, Inc nor the
 names of contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Eyewonder, Inc ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Eyewonder, Inc BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This file should be accompanied with supporting documentation and source code.
If you believe you are missing files or information, please 
contact Eyewonder, Inc (http://www.eyewonder.com)



Description
-----------

Parses EW formatted XML ad tags.

*/
package com.eyewonder.instream.parser {

import com.eyewonder.instream.parser.events.ParserEvent;
import com.eyewonder.instream.debugger.*;

public dynamic class EWParser extends Parser {
	
	/*
	 * Constructor
	 */
	 
	// Ad tag variables
	public var __adURL:String;					
	public var __adTagDataURL:String;
	public var __adTagClickPrepend:String;
	public var __adTagVersion:String;
	public var __adTagInstreamType:String;
	public var __adTagWidth:Number;
	public var __adTagHeight:Number;
	public var __adTagAlignHorizontal:String;
	public var __adTagAlignVertical:String; 
	
	// Fixedroll specific
	public var __adTagDuration:Number;
	public var __adTagImpr3rdParty:String;
	public var __adTagClick3rdParty:String;
	public var __adTagURLCreativeFormat:String;
	public var __adTagReminderUnit:String;
	public var __adTagCustomPubData:String;
	
	public var _redirectNeeded:Boolean;
	 
	public function EWParser()
	{
		super();
		tagType = "EW Parser";
	}
	//performs a check to see if the xml passed to it is EW
	public override function checkFormat(data:XML):Boolean
	{	
		UIFDebugMessage.getInstance()._debugMessage(3, "In checkFormat() ","INSTREAM","EWParser");
		if(data.name() == "instreamAd")
		{
			
			return true;
		}
		else
		{ 
			return false;
		}
		
	}

	protected function createUIFvars():void
	{
		_uifVars["adURL"] = adURL;
		_uifVars["adTagClickPrepend"] = adTagClickPrepend;
		_uifVars["adTagDataURL"] = adTagDataURL;
		_uifVars["adTagVersion"] = adTagVersion;
		_uifVars["adTagInstreamType"] = adTagInstreamType;
		_uifVars["adTagWidth"] = adTagWidth;
		_uifVars["adTagHeight"] = adTagHeight;
		_uifVars["adTagAlignHorizontal"] = adTagAlignHorizontal;
		_uifVars["adTagAlignVertical"] = adTagAlignVertical;
		_uifVars["adTagDuration"] = adTagDuration;
		_uifVars["adTagImpr3rdParty"] = adTagImpr3rdParty;
		_uifVars["adTagClick3rdParty"] = adTagClick3rdParty;
		_uifVars["adTagURLCreativeFormat"] = adTagURLCreativeFormat;
		_uifVars["adTagReminderUnit"] = adTagReminderUnit;
		_uifVars["adCustomPubData"] = adTagCustomPubData;
				
		UIFDebugMessage.getInstance()._debugMessage(2, "In createUIFvars() :", "VAST", "EWParser" );
		var output:String = "UIF Variables:: ";
		for(var variableName in _uifVars)
		{
			output += variableName +": "+_uifVars[variableName]+", ";
		}
		

		dispatchEvent(new ParserEvent(ParserEvent.XML_PARSED, _uifVars));
	}
	
	protected override function parseXMLData():void
	{	
		UIFDebugMessage.getInstance()._debugMessage(3, "In parseXMLData() ","INSTREAM","EWParser");	
		//Parse Data Here: _adTagXML:XMLDocument is the XML Data
		// Allow comments and other XML nodes prior to instreamAd element
		var i:Number;
		for( i = 0; i < mainXML.children().length(); i++)	// Find instreamAd element
		{
			if (  mainXML.name() == "instreamAd" || mainXML.name()  == "ewAd" /* legacy: use instreamAd instead on new tags */)
				break;
		}
		
		if (i >= mainXML.children().length())
		{
			UIFSendToPanel.getInstance()._sendToPanel("parseXMLData: Expected parent element not found." );
			dispatchError(4);
			return;
		}
			
		
		for each( var item:XML in mainXML.children())
		{
				
				
				if (item.name() == "adURL" )
				{
					 __adURL = item.toString()
				}
				else if (item.name()== "adClickPrepend")
				{
					__adTagClickPrepend = item.toString();
					/* Temporarily disabling below into a solution is found to Flash's complaints */
					// __adTagClickPrepend = InstreamFrameworkUtility.strnreplace(__adTagClickPrepend, "[clickthru]", "", 1);
					// __adTagClickPrepend = InstreamFrameworkUtility.strnreplace(__adTagClickPrepend, "[ewclickthru]", "", 1); // legacy
				}
				else if (item.name() == "dataURL")
				{
					__adTagDataURL = item.toString();			
				}				
				else if (item.name() == "adTagVersion")
				{
					__adTagVersion = item.toString();			
				}
				else if (item.name() == "adWidth")
				{
					__adTagWidth = parseInt(item.toString());			
				}
				else if (item.name() == "adHeight")
				{
					__adTagHeight = parseInt(item.toString());			
				}
				else if (item.name() == "adInstreamType")
				{
					__adTagInstreamType = item.toString();
					
				}				
				else if (item.name() == "adAlignHorizontal")
				{
					__adTagAlignHorizontal = item.toString();
				}				
				else if (item.name() == "adAlignVertical")
				{
					__adTagAlignVertical = item.toString();
				}
				else if (item.name() == "adDuration")
				{
					__adTagDuration = parseInt(item.toString());
				}
				else if (item.name() == "adImpr3rdParty")
				{
					__adTagImpr3rdParty = item.toString();
				}
				else if (item.name() == "adClick3rdParty")
				{
					__adTagClick3rdParty = item.toString();
				}
				else if (item.name() == "adURLCreativeFormat")
				{
					__adTagURLCreativeFormat = item.toString();
				}
				else if (item.name() == "adComment")
				{
					UIFSendToPanel.getInstance()._sendToPanel("Ad Comment: "+ item.toString());
				}
				else if (item.name() == "reminderAdURL")
				{
					__adTagReminderUnit = item.toString();
					UIFDebugMessage.getInstance()._debugMessage(2, "Found a URL-based reminder unit for later use.","INSTREAM","EWParser");	
				}
				else if (item.name() == "reminderAdInLine")
				{
					__adTagReminderUnit = item.toString();
					UIFDebugMessage.getInstance()._debugMessage(2, "Found an inline reminder unit for later use.", "INSTREAM", "EWParser");
				}
				else if (item.name() == "adCustomPubData")
				{
					__adTagCustomPubData = item.toString();
				}
			}
		
		
		createUIFvars();
		
	}

	
	public function get adTagDataURL() : String
	{
		return __adTagDataURL;
	}
	
	public function set adTagDataURL(tagURL:String) : void
	{
		__adTagDataURL = tagURL;
	}
	
	public function get adTagClickPrepend() : String
	{
		return __adTagClickPrepend;
	}
	
	public function set adTagClickPrepend(tagPrepend:String) : void
	{
		__adTagClickPrepend = tagPrepend;
	}
	
	public function get adTagVersion() : String
	{
		return __adTagVersion;
	}
	
	public function set adTagVersion(tagVersion:String) : void
	{
		__adTagVersion = tagVersion;
	}
	
	public function get adTagInstreamType() : String
	{
		return __adTagInstreamType;
	}
	
	public function set adTagInstreamType(tagType:String) : void
	{
		__adTagInstreamType = tagType;
	}
	
	public function get adTagWidth() : Number
	{
		return __adTagWidth;
	}
	
	public function set adTagWidth(tagWidth:Number) : void
	{
		__adTagWidth = tagWidth;
	}
	
	public function get adTagHeight() : Number
	{
		return __adTagHeight;
	}
	
	public function set adTagHeight(tagHeight:Number) : void
	{
		__adTagHeight = tagHeight;
	}
	
	public function get adTagAlignHorizontal() : String
	{
		return __adTagAlignHorizontal;
	}
	
	public function set adTagAlignHorizontal(tagHorizontal:String) : void
	{
		__adTagAlignHorizontal = tagHorizontal;
	}
	
	public function get adTagAlignVertical() : String
	{
		return __adTagAlignVertical;
	}
	
	public function set adTagAlignVertical(tagVertical:String) : void
	{
		__adTagAlignVertical = tagVertical;
	}
	
	public function get adURL() : String
	{
		return __adURL;
	}
	
	public function set adURL(url:String) : void
	{
		__adURL = url;
	}
	
	public function get adTagDuration() : Number
	{
		return __adTagDuration;
	}
	
	public function set adTagDuration(tagDuration:Number) : void
	{
		__adTagDuration = tagDuration;
	}
	
	public function get adTagImpr3rdParty() : String
	{
		return __adTagImpr3rdParty;
	}
	
	public function set adTagImpr3rdParty(thirdImpression:String) : void
	{
		__adTagImpr3rdParty = thirdImpression;
	}
	
	public function get adTagClick3rdParty() : String
	{
		return __adTagClick3rdParty;
	}
	
	public function set adTagClick3rdParty(thirdClick:String) : void
	{
		__adTagClick3rdParty = thirdClick;
	}
	
	public function get adTagURLCreativeFormat() : String
	{
		return __adTagURLCreativeFormat;
	}
	
	public function set adTagURLCreativeFormat(creativeFormat:String) : void
	{
		__adTagURLCreativeFormat = creativeFormat;
	}
	
	// Note: adTagReminderUnit can be a reminderAdURL or a reminderAdInLine-Tag
	public function get adTagReminderUnit() : String
	{
		return __adTagReminderUnit;
	}
	
	public function set adTagReminderUnit(reminderUnit:String) : void
	{
		__adTagReminderUnit = reminderUnit;
	}
	
	public function get adTagCustomPubData() : String
	{
		return __adTagCustomPubData;
	}
	
	public function set adTagCustomPubData(xmlNodesAsString:String) : void
	{
		__adTagCustomPubData = xmlNodesAsString;
	}
	
	}

/* End package */
}