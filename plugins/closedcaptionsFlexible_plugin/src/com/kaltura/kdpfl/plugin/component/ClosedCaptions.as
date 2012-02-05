package com.kaltura.kdpfl.plugin.component
{
	//import com.kaltura.kdpfl.component.IComponent;
	
	import com.kaltura.types.KalturaCaptionType;
	
	import fl.core.UIComponent;
	
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
	
	
	
	public class ClosedCaptions extends UIComponent //implements IComponent
	{
		public static const ERROR_PARSING_SRT : String = "errorParsingSRT";
		
		public static const ERROR_PARSING_TT : String = "errorParsingTT";
		
		public static const HEIGHT_MARGIN : Number = 10;
		
		public static const WIDTH_MARGIN : Number = 10;
		
		private var _isInFullScreen : Boolean = false;
		
		public var defaultBGColor : Number = 0x000000;
		
		public var defaultFontColor : Number = 0xFFFFFF;
		
		public var defaultFontSize : int =12;
		
		public var defaultFontFamily : String = "Arial";
		
		public var defaultGlowFilter : BitmapFilter;
		
		private var xmlns : Namespace;
		private var xmlns_tts :Namespace;
		private var xmlns_xml:Namespace;
		
		private var _label:TextField;
		private var _captionsURLLoader:URLLoader;
		//map between captions URL and the parsed lines array of the file
		private var _currentCCFile:Array;
		//array of arrays of captions lines.
		private var _availableCCArray : Object;
		private var _isActive:Boolean = true;
		private var _fontSize:int = 12; 
		
		private var _widthBeforeResize : Number;
		private var _heightBeforeResize : Number;
		private var _fontBeforeResize : int;
		private var _fontFamily : String = "Arial";
		
		
		private var _fullScreenRatio : Number;
		
		//ABC- specific
		private var _rowHeight : int;
		private var _colWidth : int;
		
		public var timeOffset : int =0;
		
		private var _onScreenLabelArray : Array = new Array();
		private var _lastPlayheadPos:Number;
		
		
		public function ClosedCaptions()
		{
			_currentCCFile = new Array ();
			_availableCCArray = new Object();
			_isActive = true;
			
			_label = new TextField ();
			_label.type = TextFieldType.DYNAMIC;
			_label.multiline = true;
			_label.height = 0;
			_label.text = "";
			_label.selectable = false;
			_label.mouseWheelEnabled=false;
			//	addChild (_label);
			
			/*horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;*/
			
			setText ("");
		}
		
		/*override public function initialize():void
		{
		
		}*/
		
		
		
		
		public function get isInFullScreen():Boolean
		{
			return _isInFullScreen;
		}
		
		public function set isInFullScreen(value:Boolean):void
		{
			_isInFullScreen = value;
			//refresh captions
			updatePlayhead(_lastPlayheadPos);
		}
		
		public function setDimensions(w:Number, h:Number):void
		{
			
			if ( w && h )
			{
				var widthRatio:Number = (this.width > 0) ? w / this.width : 1;
				var heightRatio:Number = (this.height > 0) ? h / this.height : 1;
				this.width = w;
				this.height = h;	
				_label.height = h;
				//setText (null);
				_colWidth = Math.round( this.width / 35 ) ;
				_rowHeight = Math.round ( this.height/15);
				//if dimensions have changed and lines were already calculated - re position them
				if (_currentCCFile && (widthRatio!=1 || heightRatio!=1))
				{
					for each (var ccLine:CCLine in _currentCCFile) {
						ccLine.x *= widthRatio;
						ccLine.y *= heightRatio;
					}
				}	
			}
		}
		
		public function setFontSize(fontSize:int):void
		{
			_fontSize = fontSize;
		}
		
		
		public function get fontFamily():String
		{
			return _fontFamily;
		}
		
		public function set fontFamily(value:String):void
		{
			_fontFamily = value;
		}
		
		
		
		
		
		public function get fullScreenRatio():Number
		{
			return _fullScreenRatio;
		}
		
		public function set fullScreenRatio(value:Number):void
		{
			_fullScreenRatio = value;
		}
		
		public function closedCaptionsClicked():void
		{
			_isActive = !_isActive;
			_label.visible = _isActive;
		}
		
		public function loadCaptions (fileUrl:String, fileType:String):void
		{
			if (!_availableCCArray[fileUrl])
			{
				var myURLReq:URLRequest = new URLRequest(fileUrl);
				
				_captionsURLLoader = new URLLoader();
				_captionsURLLoader.dataFormat = URLLoaderDataFormat.TEXT;
				_captionsURLLoader.addEventListener(Event.COMPLETE, (fileType == "tt" || fileType == KalturaCaptionType.DFXP)? parseTimedText : parseSRT);
				
				_captionsURLLoader.addEventListener(ErrorEvent.ERROR, onError)
				_captionsURLLoader.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
				_captionsURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				_captionsURLLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				
				
				try
				{
					_captionsURLLoader.load (myURLReq);
				}
				catch (e:Error)
				{
					trace (e);
				}
			}
			else
			{
				_currentCCFile = _availableCCArray[fileUrl]
			}
			
			function parseSRT (e:Event):void
			{
				try{
					if (_captionsURLLoader.data)
					{
						var lines:Array = _captionsURLLoader.data.split ("\n");
						var currLine:CCLine = null;
						_currentCCFile = new Array ();
						var ccLineInd:int = 0;
						var tempCCLines : Array = new Array();
						for (var i:int = 0; i < lines.length; i++)
						{
							var str:String = lines [i].replace (/^\s+|\s+$/g, "");
							if (str == "")
							{
								if (currLine != null)
								{
									tempCCLines.push (currLine);
									currLine = null;
								}
								
								ccLineInd = 0;
								continue;
							}
							
							if (ccLineInd == 0)
							{
								currLine = new CCLine ();
							}
							else if (ccLineInd == 1)
							{
								var times:Array = str.split (" --> ");
								currLine.start = parseStrSRTTime (times [0]);
								currLine.end = parseStrSRTTime (times [1]);
							}
							else
							{
								if (currLine.text != "")
								{
									currLine.text += "<br>";
								}
								
								currLine.text += str;
								
								if (!defaultGlowFilter && !currLine.backgroundColor)
								{
									currLine.backgroundColor = defaultBGColor;
								}
								else if ( defaultGlowFilter )
								{
									currLine.showBGColor = false;
								}
								
							}
							
							ccLineInd++;
						}
						
						_currentCCFile = _currentCCFile.concat( tempCCLines );
						_availableCCArray[fileUrl] = new Array ().concat( tempCCLines );
					}
				}catch (e : Error) {
					this.dispatchEvent( new ErrorEvent(ERROR_PARSING_SRT) );
				}
			}
			
			function parseTimedText (e:Event):void
			{
				try{	
					if (!_captionsURLLoader.data)
						return;
					var tt:XML = new XML (_captionsURLLoader.data);
					xmlns = tt.namespace();
					xmlns_tts = tt.namespace("tts");
					
					var body:XML = tt.xmlns::body[0];
					var head : XML = tt.xmlns::head[0];
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
							if (!sname) {
								sname = style.@xmlns_xml::id.toString();// @xmlns_xml::id.toString();
							}
							stylingObject[sname] = {tf: xmlToTextFormat(style), backgroundColor: xmlToBGColor(style), showBGColor: shouldShowBGColor(style)};
						}
					}
					
					var div:XML = body.xmlns::div[0];
					
					var p:XMLList = div.xmlns::p;
					var numOfLines:int = p.length ();
					_currentCCFile = new Array ();
					var tempCCLines : Array = new Array();
					for (var i:int = 0; i < numOfLines; i++)
					{
						var paragraph:XML = p [i];
						
						var pMetadata : XML = paragraph.xmlns::metadata[0];
						var currLine:CCLine = new CCLine ();
						
						if (pMetadata)
						{
							
							var rowNum : int = pMetadata.attribute("ccrow")[0].toString();
							var colNum : int = pMetadata.attribute("cccol")[0].toString();
							
							currLine.x = colNum * _colWidth;
							currLine.y = rowNum * _rowHeight;
						}
						
						currLine.start = parseStrTTTime (paragraph.attribute ("begin") [0].toString ());
						if (paragraph.attribute ("end").length())
						{
							currLine.end = parseStrTTTime (paragraph.attribute ("end") [0].toString ());
						}
							
						else if (paragraph.attribute ("dur").length())
						{
							currLine.end = currLine.start + parseStrTTTime (paragraph.attribute ("dur") [0].toString ());
						}
						
						currLine.text = "";
						currLine.innerTextFormats = new Array();
						
						for each (var innerChild:XML in paragraph.children())
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
						if (paragraph.attribute("style").length() )
						{
							currLine.textFormat = stylingObject[paragraph.attribute ("style") [0].toString ()]["tf"];
							
							currLine.backgroundColor = stylingObject[paragraph.attribute ("style") [0].toString ()]["backgroundColor"];
							
							currLine.showBGColor = stylingObject[paragraph.attribute ("style") [0].toString ()]["showBGColor"];
							
						}
						else
						{
							currLine.textFormat = new TextFormat (defaultFontFamily, defaultFontSize, defaultFontColor, null, null, null, null, null, "center");
							
							currLine.showBGColor = false;
						}
						
						
						tempCCLines.push (currLine);
					}
					
					_availableCCArray[fileUrl] = new Array().concat(tempCCLines);
					_currentCCFile = _currentCCFile.concat( tempCCLines );
					
					
				} catch ( err:Error ) {
					
					this.dispatchEvent( new ErrorEvent (ERROR_PARSING_TT) );
				}
			}
			
		}
		
		private function xmlToTextFormat (style : XML) : TextFormat
		{
			var tf : TextFormat = new TextFormat();
			
			tf.align = style.@xmlns_tts::textAlign.length() ? style.@xmlns_tts::textAlign[0].toString() : "center";
			tf.bold = (style.@xmlns_tts::fontWeight.length() && style.@xmlns_tts::fontWeight[0].toString() == "bold") ? true : false;
			tf.italic = (style.@xmlns_tts::fontStyle.length() && style.@xmlns_tts::fontStyle[0].toString() == "italic") ? true : false;
			var colorString : String;
			if (style.@xmlns_tts::color.length())
			{
				colorString = style.@xmlns_tts::color[0].toString().replace("#", "0x");		
			}
				
			else
			{
				colorString = "0xFFFFFF";
			}
			tf.color = Number(colorString);
			tf.font = style.@xmlns_tts::fontFamily.length() ? style.@xmlns_tts::fontFamily[0].toString() : defaultFontFamily;
			tf.size = style.@xmlns_tts::fontSize.length() ? style.@xmlns_tts::fontSize[0].toString() : defaultFontSize;
			
			return tf;	
			
		}
		
		private function xmlToBGColor(style : XML) : Number
		{
			var bgColor : Number = style.@xmlns_tts::backgroundColor.length() ? Number(style.@xmlns_tts::backgroundColor[0].toString().replace("#", "0x")) : 0x000000;
			return bgColor;
			
			
			
			
			
			
		}
		
		private function shouldShowBGColor (style : XML) : Boolean			
		{
			var shouldShowBGColor : Boolean = style.@xmlns_tts::backgroundColor.length() ? true : false;
			return shouldShowBGColor;	
		}
		
		private function onError(event:Event):void
		{
			this.dispatchEvent( event.clone() );
		}
		
		public function updatePlayhead (pos:Number):void
		{
			_lastPlayheadPos = pos;
			if (_currentCCFile && _currentCCFile.length)
			{
				var lastLine : CCLine = _currentCCFile[_currentCCFile.length -1];
			}
			else
			{
				return;
			}
			if (lastLine && pos && pos > lastLine.start && pos > lastLine.end)
			{
				
				removeAllFromOnScreenLabelArray();
				return;
			}
			
			if (_onScreenLabelArray.length)
			{
				removeFromOnScreenLabelArray(pos);	
			}
			
			for (var i:int = 0; i < _currentCCFile.length; i++)
			{
				var line:CCLine = _currentCCFile [i];
				
				if (pos <= line.end)
				{
					removeLabelFromOnScreenLabelArray( line.end );
					if (pos >= line.start)
					{
						//setText (line.text, line.textFormat, line.backgroundColor, line.x , line.y , line.end);
						addToOnScreenLabelArray( line );
					}
					/*	else
					{
					
					removeLabelFromOnScreenLabelArray( line.end );
					}*/
					
				}
			}
		}
		
		private function addToOnScreenLabelArray ( caption : CCLine ) : void
		{
			var captionsToAdd : TextField = createLabelFromCCLine( caption );
			var newCaptionsObj : Object = {endTime: caption.end, label : captionsToAdd};
			_onScreenLabelArray.push( newCaptionsObj );
			
			_onScreenLabelArray.sortOn( "endTime", Array.NUMERIC );
			this.addChild( captionsToAdd );
			captionsToAdd.x = caption.x;
			captionsToAdd.y = caption.y;	
		}
		
		private function removeFromOnScreenLabelArray (pos : Number) : void
		{
			while (_onScreenLabelArray.length && _onScreenLabelArray[0]["endTime"] <= pos)
			{
				this.removeChild(_onScreenLabelArray[0]["label"])
				_onScreenLabelArray.shift();
			}
			
		}
		
		private function removeLabelFromOnScreenLabelArray (endTime : Number) : void
		{
			for each ( var captionObj : Object in _onScreenLabelArray )
			{
				if (captionObj.endTime == endTime)
				{
					this.removeChild(captionObj["label"])
					_onScreenLabelArray.splice(_onScreenLabelArray.indexOf(captionObj), 1);
					break;
				}
			}
		}
		
		private function removeAllFromOnScreenLabelArray () : void
		{
			while (_onScreenLabelArray.length)
			{
				this.removeChild(_onScreenLabelArray[0]["label"])
				_onScreenLabelArray.shift();
			}
			
		}
		
		private function createLabelFromCCLine ( ccLine : CCLine) : TextField
		{
			var caption : TextField = new TextField();
			caption.type = TextFieldType.DYNAMIC;
			caption.multiline = true;
			caption.selectable = false;
			caption.mouseWheelEnabled = false;
			var tf : TextFormat;
			if (ccLine.textFormat)
			{
				tf = new TextFormat(ccLine.textFormat.font, ccLine.textFormat.size, ccLine.textFormat.color, ccLine.textFormat.bold, ccLine.textFormat.italic, ccLine.textFormat.underline, ccLine.textFormat.url, ccLine.textFormat.target, ccLine.textFormat.align, ccLine.textFormat.leftMargin, ccLine.textFormat.rightMargin, ccLine.textFormat.indent, ccLine.textFormat.leading);
			}
			else
			{
				tf = new TextFormat(fontFamily, _fontSize, 0xffffff, null, null, null, null, null, "center");
			}
			
			if (ccLine.text != null)
			{
				caption.htmlText = ccLine.text;
				
			}
			
			if (_isInFullScreen)
			{
				tf.size = Number(tf.size)*fullScreenRatio;
			}
			
			caption.setTextFormat( tf );
			//if inner text formats were defined (using "span")
			if (ccLine.innerTextFormats)
			{
				for each (var innerText:InnerTextFormat in ccLine.innerTextFormats)
				{
					var curTF:TextFormat = new TextFormat(innerText.textFormat.font, innerText.textFormat.size, innerText.textFormat.color, innerText.textFormat.bold, innerText.textFormat.italic, innerText.textFormat.underline, innerText.textFormat.url, innerText.textFormat.target, innerText.textFormat.align, innerText.textFormat.leftMargin, innerText.textFormat.rightMargin, innerText.textFormat.indent, innerText.textFormat.leading);
					if (_isInFullScreen)
					{
						curTF.size = Number(curTF.size)*fullScreenRatio;
					}
					caption.setTextFormat(curTF, innerText.startIndex, innerText.endIndex);
				}
			}	
			
			caption.height = caption.textHeight + HEIGHT_MARGIN;
			caption.width = caption.textWidth + WIDTH_MARGIN;
			
			if (defaultGlowFilter && !ccLine.showBGColor)
			{
				_label.filters = [defaultGlowFilter];
				_label.background = false;
			}
			else
			{
				_label.filters = [];
				_label.background = true;
				_label.backgroundColor = ccLine.backgroundColor;
			}
			caption.x = x;
			caption.y = y;
			
			return caption;
		}
		
		
		private function parseStrTTTime (timeStr:String):Number
		{
			var time : Number = 0;
			if (timeStr.indexOf("s") != -1)
			{
				time = Number(timeStr.replace("s", ""));
			}
			else
			{
				var timeArr : Array = timeStr.split(":");
				timeArr.reverse();
				for (var i:int = 0; i < timeArr.length; i++)
				{
					time += Number(timeArr[i]) * Math.pow(60,i);
				}
			}
			time = time - timeOffset;
			return time;
		}
		
		private function parseStrSRTTime (timeStr:String):Number
		{
			var hour:Number = parseInt (timeStr.substr(0, 2), 10);
			var minute:Number = parseInt (timeStr.substr(3, 2), 10);
			var second:Number = parseInt (timeStr.substr(6, 2), 10);
			var milli:Number = parseInt (timeStr.substr(9, 3), 10);
			
			return hour * 3600 + minute * 60 + second + milli / 1000;
		}
		
		public function setBitmapFilter(glowColor : Number, glowBlur : int):void {
			var color:Number = glowColor;
			var alpha:Number = 0.8;
			var blurX:Number = glowBlur;
			var blurY:Number = glowBlur;
			var strength:Number = 2;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.LOW;
			
			defaultGlowFilter =  new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
			
			
		}
		
		
		
		public function setText (text:String, textFormat : TextFormat = null, bgColor:Number=0, x:int=0, y:int=0 , showBGColor : Boolean = true):void
		{
			var tf : TextFormat;
			if (textFormat)
			{
				tf = new TextFormat(textFormat.font, textFormat.size, textFormat.color, textFormat.bold, textFormat.italic, textFormat.underline, textFormat.url, textFormat.target, textFormat.align, textFormat.leftMargin, textFormat.rightMargin, textFormat.indent, textFormat.leading);
			}
			else
			{
				tf = new TextFormat(defaultFontFamily, defaultFontSize, defaultFontColor, null, null, null, null, null, "center");
			}
			if (_label.htmlText == text)
			{
				return;
			}
			
			if (text != null)
			{
				_label.htmlText = text;
				
			}
			
			if (_isInFullScreen)
			{
				tf.size = Number(tf.size)*fullScreenRatio;
			}
			
			_label.setTextFormat( tf );
			
			_label.height = _label.textHeight + HEIGHT_MARGIN;
			_label.width = _label.textWidth;
			
			
			if (text != "")
			{
				if (defaultGlowFilter && !showBGColor)
				{
					_label.filters = [defaultGlowFilter];
					_label.background = false;
				}
				else
				{
					_label.filters = [];
					_label.background = true;
					_label.backgroundColor = bgColor;
				}
			}
			else
			{
				_label.background = false;
			}
			
			_label.x = x;
			
			
			
			//			_label.autoSize = TextFieldAutoSize.CENTER;
			_label.y = y;
		}
		
		public function get currentCCFile():Array
		{
			return _currentCCFile;
		}
		
		public function set currentCCFile(value:Array):void
		{
			_currentCCFile = value;
		}
		
		public function resetAll () : void
		{
			_availableCCArray = new Object();
			_currentCCFile = new Array ();
			setText("");
			removeAllFromOnScreenLabelArray();
		}
		
		
		
		
	}
}