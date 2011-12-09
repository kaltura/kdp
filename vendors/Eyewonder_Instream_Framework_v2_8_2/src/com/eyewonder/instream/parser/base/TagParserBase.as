/*
TagParserBase.as

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

Base class for the parser class.

*/
package com.eyewonder.instream.parser.base {

import com.eyewonder.instream.parser.errors.ParserErrors;
import com.eyewonder.instream.parser.events.ParserEvent;
import com.eyewonder.instream.debugger.*;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.StatusEvent;
import flash.net.LocalConnection;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.xml.XMLDocument;


	public dynamic class TagParserBase extends EventDispatcher implements ITagParserBase {

	//PRIVATE VARS: Accessible only to this class
	public var _adTagDataURL:String;
	public var _adTagClickPrepend:String;
	public var _adTagVersion:String;
	public var _adTagInstreamType:String;
	public var _adTagWidth:Number;
	public var _adTagHeight:Number;
	public var _adTagAlignHorizontal:String;
	public var _adTagAlignVertical:String;
	public var _adURL:String;
	public var _adTagDuration:Number;
	public var _adTagImpr3rdParty:String;
	public var _adTagClick3rdParty:String;
	public var _adTagURLCreativeFormat:String;
	public var _debugMessages:Number;
	
	public var _parserErrors:ParserErrors;
	
	
	//PROTECTED VARS: Accessible for sub classes and this class
	protected var _urlLoader:URLLoader;
	protected var _urlRequest:URLRequest;
	protected var _adTagXML:XML;
	protected var _uifVars:Object = new Object();
	public var _tagType:String;
	
	/*
	 * Constructor
	 */
	public function TagParserBase() 
	{
		UIFDebugMessage.getInstance()._debugMessage(3, "In TagParserBase() ", "VAST", "TagParserBase");
		_parserErrors = new ParserErrors();
	}
	
	/*
	 * parseBase: Starts the loading and parsing of the tag url
	 */
	protected function parseBase(url : String, successFunction: Function, errorFunction: Function) : void
	{
		UIFSendToPanel.getInstance()._sendToPanel("In parse("+url+").");
		UIFSendToPanel.getInstance()._sendToPanel("tagType: " + tagType);
		
		
		
		//_adTagXML = new XMLDocument();
		_urlLoader = new URLLoader();
		_uifVars = new Object();
		
		_adURL = "";
		_adTagClickPrepend = "";
		_adTagDataURL = "";
		_adTagVersion = "";
		_adTagInstreamType = "";
		_adTagWidth = 0;
		_adTagHeight = 0;
		_adTagAlignHorizontal = "";
		_adTagAlignVertical = "";
		_adTagDuration = 0;
		_adTagImpr3rdParty = "";
		_adTagClick3rdParty = "";
		_adTagURLCreativeFormat = "";	
		
		_urlLoader.addEventListener(Event.COMPLETE, successFunction);
		_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorFunction);
		
		getXMLFromServer(url);
	}
	
	/*
	 * getXMLFromServer: Loads in the XML from the url string
	 */
	public function getXMLFromServer(url:String) : void
	{
		UIFDebugMessage.getInstance()._debugMessage(3, "In getXMLFromServer() ", "VAST", "TagParserBase");
		
		_urlRequest = new URLRequest(url);
		_adTagXML = new XML();
		_adTagXML.ignoreWhite = true;
		_urlLoader.load(_urlRequest);
		dispatchEvent(new Event(ParserEvent.XML_LOAD_START));
	}
	
	/*
	 * createUIFVars: Assigned the parsed data to correct variable names to be
	 * used in UIF. Called after XML data is parsed into this classes variables.
	 * 
	 * Assign additional variables to _uifVars before calling createUIFVars()
	 */
	
	/*
	 * Error Handling Methods
	 */
	protected function dispatchError(id:Number) : void
	{
		dispatchEvent(_parserErrors.getErrorEvent(id));
	}
	    
    public function setDebugLevel(level:Number) : void
	{
		if (level != 0)
			UIFDebugMessage.getInstance()._debugMessage(0,"In setDebugLevel("+level+").", "VAST", "TagParserBase");

		if (level > 2)
			level = 2;
		if (level < 0)
			level = 0;
		_debugMessages = level;
	}
	
	//getters and setters
	
    public function get uifVars() : Object
    {
    	return _uifVars;
    }
    
    public function get tagType() : String
    {
    	return _tagType;
    }
    
    public function set tagType(type:String) : void
    {
    	_tagType = type;
    }
	
}

/* End package */
}