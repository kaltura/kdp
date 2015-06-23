package com.kaltura.kdpfl.plugin.component {
	//import com.kaltura.kdpfl.component.IComponent;
	
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.types.KalturaCaptionType;
	
	import fl.controls.ScrollPolicy;
	import fl.events.ComponentEvent;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import org.osmf.layout.HorizontalAlign;
	
	
	
	public class ClosedCaptions extends KHBox //implements IComponent
	{
		public static const ERROR_PARSING_SRT:String = "errorParsingSRT";
		
		public static const ERROR_PARSING_TT:String = "errorParsingTT";
		
		public static const HEIGHT_MARGIN:Number = 10;
		
		public static const WIDTH_MARGIN:Number = 10;
		
		
		public var defaultBGColor:Number = 0x000000;
		
		public var defaultFontColor:Number = 0xFFFFFF;
		
		public var defaultFontSize:int = 12;
		
		public var defaultFontFamily:String = "Arial";
		
		public var defaultGlowFilter:BitmapFilter;
		
		
		private var xmlns:Namespace;
		private var xmlns_tts:Namespace;
		private var xmlns_xml:Namespace;
		
		private var _isInFullScreen:Boolean = false;
		
		private var _label:TextField;
		private var _captionsURLLoader:URLLoader;
		/**
		 * map between captions URL and the parsed lines array of the file
		 * */
		private var _currentCCFile:Array;
		/**
		 * array of arrays of captions lines.
		 * */
		private var _availableCCArray:Object;
		private var _isActive:Boolean = true;
		private var _widthBeforeResize:Number;
		private var _heightBeforeResize:Number;
		private var _fontBeforeResize:int;
		
		private var _fullScreenRatio:Number;
		
		//How ID key will look like in case it was passed as "xml:id"
		private const defaultIdIdentifier:String = 'aaa:id="';
		
		public function ClosedCaptions() {
			this.addEventListener(ComponentEvent.RESIZE, setLabelSize);
			_currentCCFile = new Array();
			_availableCCArray = new Object();
			_isActive = true;
			
			_label = new TextField();
			_label.type = TextFieldType.DYNAMIC;
			_label.multiline = true;
			_label.height = 0;
			_label.text = "";
			_label.selectable = false;
			_label.mouseWheelEnabled = false;
			addChild(_label);
			
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			
			setText("");
			this.horizontalAlign = HorizontalAlign.CENTER;
		}
		
		
		override public function initialize():void {
			
		}
		
		
		
		public function setDimensions(w:Number, h:Number):void {
			if (w && h) {
				this.width = w;
				this.height = h;
				_label.height = h;
			}
		}
		
		
		public function get fullScreenRatio():Number {
			return _fullScreenRatio;
		}
		
		
		public function set fullScreenRatio(value:Number):void {
			_fullScreenRatio = value;
		}
		
		
		public function setFullScreen(value:Boolean):void {
			_isInFullScreen = value;
			var tf:TextFormat = _label.getTextFormat();
			if (value) {
				tf.size = Number(tf.size) * fullScreenRatio;
			}
			else {
				tf.size = Number(tf.size) / fullScreenRatio;
			}
			
			_label.setTextFormat(tf);
			setLabelSize();
			//                   setText("");
		}
		
		
		public function closedCaptionsClicked():void {
			_isActive = !_isActive;
			_label.visible = _isActive;
		}
		
		
		
		
		private function translateToColor(c:String):String
		{
			
			switch(c){
				
				case "black" : return "0x000000";
				case "silver" : return "0xc0c0c0";
				case "gray" : return "0x808080";
				case "white" : return "0xffffff";
				case "maroon" : return "0x800000";
				case "red" : return "0xff0000";
				case "purple" : return "0x800080";
				case "fuchsia" : return "0xff00ff";
				case "magenta" : return "0xff00ff";
				case "green" : return "0x008000";
				case "lime" : return "0x00ff00";
				case "olive" : return "0x808000";
				case "yellow" : return "0xffff00";
				case "navy" : return "0x000080";
				case "blue" : return "0x0000ff";
				case "teal" : return "0x008080";
				case "aqua" : return "0x00ffff";
				case "cyan" : return "0x00ffff";
			}
			return c;
		}
		
		
		public function loadCaptions(fileUrl:String, fileType:String):void {
			if (!_availableCCArray[fileUrl]) {
				var myURLReq:URLRequest = new URLRequest(fileUrl);
				
				_captionsURLLoader = new URLLoader();
				_captionsURLLoader.dataFormat = URLLoaderDataFormat.TEXT;
				_captionsURLLoader.addEventListener(Event.COMPLETE, (fileType == "tt" || fileType == KalturaCaptionType.DFXP) ? parseTimedText : parseSRT);
				
				_captionsURLLoader.addEventListener(ErrorEvent.ERROR, onError)
				_captionsURLLoader.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
				_captionsURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				_captionsURLLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				
				
				try {
					_captionsURLLoader.load(myURLReq);
				}
				catch (e:Error) {
					trace("ClosedCaptionsPlugin: ", e);
				}
			}
			else {
				_currentCCFile = _availableCCArray[fileUrl]
			}
			
			function parseSRT(e:Event):void {
				try {
					if (_captionsURLLoader.data) {
						var loadedText:String = _captionsURLLoader.data;
						// unify CRs (\n) and CRLFs (\r\n) - replace with CR
						loadedText = loadedText.replace(/(\r)?\n/g, "\r");
						// split on CRs
						var lines:Array = loadedText.split("\r");
						var currLine:CCLine = null;
						_currentCCFile = new Array();
						var ccLineInd:int = 0;
						var tempCCLines:Array = new Array();
						for (var i:int = 0; i < lines.length; i++) {
							var str:String = lines[i].replace(/^\s+|\s+$/g, "");
							if (str == "") {
								if (currLine != null) {
									tempCCLines.push(currLine);
									currLine = null;
								}
								
								ccLineInd = 0;
								continue;
							}
							
							if (ccLineInd == 0) {
								currLine = new CCLine();
							}
							else if (ccLineInd == 1) {
								var times:Array = str.split(" --> ");
								currLine.start = parseStrSRTTime(times[0]);
								currLine.end = parseStrSRTTime(times[1]);
							}
							else {
								if (currLine.text != "") {
									currLine.text += "<br>";
								}
								
								currLine.text += str;
								
								if (!defaultGlowFilter && !currLine.backgroundColor) {
									currLine.backgroundColor = defaultBGColor;
								}
								else if (defaultGlowFilter) {
									currLine.showBGColor = false;
								}
								
							}
							
							ccLineInd++;
						}
						
						//if we parsed another line but didn't push it, because of a missing enter at the end of the file
						if (ccLineInd > 2 && currLine)
						{
							tempCCLines.push(currLine);
						}
						
						_currentCCFile = _currentCCFile.concat(tempCCLines);
						_availableCCArray[fileUrl] = new Array().concat(tempCCLines);
					}
				}
				catch (e:Error) {
					dispatchEvent(new ErrorEvent(ERROR_PARSING_SRT));
				}
			}
			
			
			
			
			
			function parseTimedText(e:Event):void {
				
				
				
				try {
					if (!_captionsURLLoader.data)
						return;
					
					var tt:XML = new XML(_captionsURLLoader.data);
					xmlns = tt.namespace();
					xmlns_tts = tt.namespace("tts");
					xmlns_xml = tt.namespace("xml");
					
					var body:XML = tt.xmlns::body[0];
					var head:XML = tt.xmlns::head[0];
					var styling:XML;
					var styles:XMLList;
					var stylingObject:Object;
					
					// parse styles
					if (head) {
						styling = head.xmlns::styling[0];
						styles = styling.xmlns::style;
						stylingObject = new Object();
						
						for each (var style:XML in styles) {
							var sname:String = style.@id.toString(); 
							if (!sname && xmlns_xml) {
								sname = style.@xmlns_xml::id.toString();
							}
							//in case id was passed as "xml:id" flash will turn it to "aaa:id". extract id value:
							if (!sname) {
								//string represantation of the current style node
								var styleSt:String = style.toXMLString();
								//starting index of style id value
								var startIndex:int = styleSt.indexOf(defaultIdIdentifier);
								if (startIndex!=-1)
								{
									var styleSubSt:String = styleSt.substr(startIndex + defaultIdIdentifier.length);
									sname = styleSubSt.substring(0, styleSubSt.indexOf('"'));         
								}
							}
							
							
							stylingObject[sname] = {tf: xmlToTextFormat(style), backgroundColor: xmlToBGColor(style), showBGColor: shouldShowBGColor(style)};
						}
					}
					
					// parse lines
					var div:XML = body.xmlns::div[0];
					var p:XMLList = div.xmlns::p;     // all text lines
					var numOfLines:int = p.length();
					_currentCCFile = new Array();
					var tempCCLines:Array = new Array();
					var resultElem:XML;        // line element in xml
					var currLine:CCLine; // line object
					for (var i:int = 0; i < numOfLines; i++) {
						resultElem = p[i];
						currLine = new CCLine();
						
						// show / hide line
						currLine.start = parseStrTTTime(resultElem.attribute("begin")[0].toString());
						if (resultElem.attribute("end").length()) {
							currLine.end = parseStrTTTime(resultElem.attribute("end")[0].toString());
						}
						else if (resultElem.attribute("dur").length()) {
							currLine.end = currLine.start + parseStrTTTime(resultElem.attribute("dur")[0].toString());
						}
						currLine.text = "";
						currLine.innerTextFormats = new Array();
						
						for each (var innerChild:XML in resultElem.children())
						{
							var textToAdd:String;
							
							if (innerChild.localName() == "span" && innerChild.children().length())
							{
								var innerTextFormat:InnerTextFormat = new InnerTextFormat(currLine.text.length, currLine.text.length + innerChild.toString().length + 1, xmlToTextFormat(innerChild));
								currLine.innerTextFormats.push(innerTextFormat);
								textToAdd = innerChild.toString();
							}
							else
							{
								textToAdd = innerChild.toXMLString();
								if (innerChild.localName() == "em")
								{
									textToAdd = textToAdd.replace("<em", "<i");
									textToAdd = textToAdd.replace("</em", "</i");
								}
								else if (innerChild.localName() == "strong")
								{
									textToAdd = textToAdd.replace("<strong", "<b");
									textToAdd = textToAdd.replace("</strong", "</b");
								}
							}
							
							currLine.text += " " + textToAdd;
						}
						if ( !resultElem.attribute("style").length() && body.attribute("style").length() ) {
							resultElem.@["style"] = body.attribute("style")[0].toString();
						}
						// line text
						//     currLine.text = resultElem.text().toXMLString();
						// line style
						if (stylingObject && resultElem.attribute("style").length()) {
							var curStyle:Object = stylingObject[resultElem.attribute("style")[0].toString()];
							if (curStyle) {
								currLine.textFormat = curStyle.tf;
								currLine.backgroundColor = curStyle.backgroundColor;
								currLine.showBGColor = curStyle.showBGColor;
							}
							else {
								currLine.textFormat = new TextFormat(defaultFontFamily, defaultFontSize, defaultFontColor, null, null, null, null, null, "center");
								currLine.showBGColor = false;     
							}
						} 
						else {
							currLine.textFormat = new TextFormat(defaultFontFamily, defaultFontSize, defaultFontColor, null, null, null, null, null, "center");
							currLine.showBGColor = false;
						}
						
						tempCCLines.push(currLine);
					}
					_availableCCArray[fileUrl] = new Array().concat(tempCCLines);
					_currentCCFile = _currentCCFile.concat(tempCCLines);
				}
				catch (err:Error) {
					dispatchEvent(new ErrorEvent(ERROR_PARSING_TT));
				}
			}
			
		}
		
		
		private function xmlToTextFormat(style:XML):TextFormat {
			var tf:TextFormat = new TextFormat();
			
			tf.align = style.@xmlns_tts::textAlign.length() ? style.@xmlns_tts::textAlign[0].toString() : "center";
			tf.bold = (style.@xmlns_tts::fontWeight.length() && style.@xmlns_tts::fontWeight[0].toString() == "bold") ? true : false;
			tf.italic = (style.@xmlns_tts::fontStyle.length() && style.@xmlns_tts::fontStyle[0].toString() == "italic") ? true : false;
			//fix color names value 
			
			var colorString:String;
			if (style.@xmlns_tts::color.length()) {
				colorString = style.@xmlns_tts::color[0].toString().replace("#", "0x");
				colorString = translateToColor(colorString);
			}
			else {
				colorString = "0xFFFFFF";
			}
			
			tf.color = Number(colorString);
			tf.font = style.@xmlns_tts::fontFamily.length() ? style.@xmlns_tts::fontFamily[0].toString() : defaultFontFamily;
			tf.size = style.@xmlns_tts::fontSize.length() ? String(style.@xmlns_tts::fontSize[0].toString()).replace("px","") : defaultFontSize;
			
			return tf;
			
		}
		
		
		private function xmlToBGColor(style:XML):Number {
			var bgColor:String;
			if(style.@xmlns_tts::backgroundColor.length())
			{
				bgColor = style.@xmlns_tts::backgroundColor[0].toString().replace("#", "0x");
				//fix color names value 
				bgColor = translateToColor(bgColor);
			} else
				bgColor = "0";
			return Number(bgColor);
		}
		
		
		private function shouldShowBGColor(style:XML):Boolean {
			var shouldShowBGColor:Boolean = style.@xmlns_tts::backgroundColor.length() ? true : false;
			return shouldShowBGColor;
		}
		
		
		private function onError(event:Event):void {
			this.dispatchEvent(event.clone());
		}
		
		
		public function updatePlayhead(pos:Number):void {
			var line:CCLine;
			// see if we are past the last line
			if (_currentCCFile && _currentCCFile.length) {
				line = _currentCCFile[_currentCCFile.length - 1];
			}
			if (line && pos && pos > line.start && pos > line.end) {
				setText("");
				return;
			}
			// find the line that should be displayed
			for (var i:int = 0; i < _currentCCFile.length; i++) {
				line = _currentCCFile[i];
				if (pos <= line.end) {
					if (pos >= line.start) {
						setText(line.text, line.textFormat, line.backgroundColor, line.showBGColor, line.innerTextFormats);
					}
					else {
						setText("");
					}
					
					break;
				}
			}
		}
		
		
		private function parseStrTTTime(timeStr:String):Number {
			var time:Number = 0;
			if (timeStr.indexOf("s") != -1) {
				time = Number(timeStr.replace("s", ""));
			}
			else {
				var timeArr:Array = timeStr.split(":");
				timeArr.reverse();
				for (var i:int = 0; i < timeArr.length; i++) {
					time += Number(timeArr[i]) * Math.pow(60, i);
				}
			}
			return time;
		}
		
		
		private function parseStrSRTTime(timeStr:String):Number {
			var hour:Number = parseInt(timeStr.substr(0, 2), 10);
			var minute:Number = parseInt(timeStr.substr(3, 2), 10);
			var second:Number = parseInt(timeStr.substr(6, 2), 10);
			var milli:Number = parseInt(timeStr.substr(9, 3), 10);
			
			return hour * 3600 + minute * 60 + second + milli / 1000;
		}
		
		
		public function setBitmapFilter(glowColor:Number, glowBlur:int):void {
			var color:Number = glowColor;
			var alpha:Number = 0.8;
			var blurX:Number = glowBlur;
			var blurY:Number = glowBlur;
			var strength:Number = 2;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.LOW;
			
			defaultGlowFilter = new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
		
		
		
		public function setText(text:String, textFormat:TextFormat = null, bgColor:Number = 0, showBGColor:Boolean = true, inneTextFormats:Array = null):void {
			var tf:TextFormat;
			if (textFormat) {
				tf = new TextFormat(textFormat.font, textFormat.size, textFormat.color, textFormat.bold, textFormat.italic, textFormat.underline, textFormat.url, textFormat.target, textFormat.align, textFormat.leftMargin,
					textFormat.rightMargin, textFormat.indent, textFormat.leading);
			}
			else {
				tf = new TextFormat(defaultFontFamily, defaultFontSize, defaultFontColor, null, null, null, null, null, "center");
			}
			if (_label.htmlText == text) {
				return;
			}
			
			if (text != null) {
				_label.htmlText = text;
			}
			
			if (_isInFullScreen) {
				tf.size = Number(tf.size) * fullScreenRatio;
			}
			
			_label.setTextFormat(tf);
			//if inner text formats were defined (using "span")
			if (inneTextFormats)
			{
				for each (var innerText:InnerTextFormat in inneTextFormats)
				{
					var curTF:TextFormat = new TextFormat(innerText.textFormat.font, innerText.textFormat.size, innerText.textFormat.color, innerText.textFormat.bold, innerText.textFormat.italic, innerText.textFormat.underline, innerText.textFormat.url, innerText.textFormat.target, innerText.textFormat.align, innerText.textFormat.leftMargin, innerText.textFormat.rightMargin, innerText.textFormat.indent, innerText.textFormat.leading);
					if (_isInFullScreen)
					{
						curTF.size = Number(curTF.size)*fullScreenRatio;
					}
					
					var tempTf:TextField = new TextField();
					tempTf.htmlText = text.substring(innerText.startIndex, innerText.endIndex);
					_label.setTextFormat(curTF, _label.text.indexOf(tempTf.text), tempTf.text.length + _label.text.indexOf(tempTf.text));
				}
			}      
			
			if (text != "") {
				if (defaultGlowFilter && !showBGColor) {
					_label.filters = [defaultGlowFilter];
					_label.background = false;
				}
				else {
					_label.filters = [];
					_label.background = true;
					_label.backgroundColor = bgColor;
				}
			}
			else {
				_label.background = false;
			}
			setLabelSize();
		}
		
		
		
		private function setLabelSize(event:Event = null):void {
			_label.width = _label.textWidth + WIDTH_MARGIN;
			_label.height = _label.textHeight + HEIGHT_MARGIN;
			_label.x = (this.width - _label.width) / 2;
			_label.y = 0;
		}
		
		
		public function get currentCCFile():Array {
			return _currentCCFile;
		}
		
		
		public function set currentCCFile(value:Array):void {
			_currentCCFile = value;
		}
		
		
		public function resetAll():void {
			_availableCCArray = new Array();
			_currentCCFile = new Array();
			setText("");
		}
		
	}
}
