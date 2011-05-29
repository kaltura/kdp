package com.kaltura.kdpfl.plugin.component
{
	//import com.kaltura.kdpfl.component.IComponent;
	
	import com.kaltura.kdpfl.view.containers.KHBox;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
		 

 
	public class ClosedCaptions extends KHBox //implements IComponent
	{
		public static const ERROR_PARSING_SRT : String = "errorParsingSRT";
		
		public static const ERROR_PARSING_TT : String = "errorParsingTT";
		
		private var _label:TextField;
		private var _captionsURLLoader:URLLoader;
		private var _ccLines:Array;
		private var _isActive:Boolean = true;
		private var _fontSize:int = 12; 
		private var _widthBeforeResize : Number;
		private var _heightBeforeResize : Number;
		private var _fontBeforeResize : int;
		private var _fontFamily : String = "Arial";
		
		public function ClosedCaptions()
		{
			_ccLines = new Array ();
			_isActive = true;

			_label = new TextField ();
			_label.type = TextFieldType.DYNAMIC;
			_label.multiline = true;
			_label.height = 34;
			_label.text = "";
			_label.selectable = false;
			_label.mouseWheelEnabled=false;
			addChild (_label);
			
			setText ("");
		}
				

		override public function initialize():void
		{
			
		}
		
			
		
		public function setDimensions(w:Number, h:Number):void
		{
			
			 if ( w && h)
			 {
				this.width = w;
				this.height = h;
				var heightRatio : Number = 1;
				if (_label.height != h)
				{
					heightRatio = h/_label.height;
				}
				
				_label.height = h;
				_fontSize = Math.round(_fontSize * heightRatio);
				setText (null);
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
		
		public function closedCaptionsClicked():void
		{
			_isActive = !_isActive;
			_label.visible = _isActive;
		}
		
		public function loadCaptions (fileUrl:String, fileType:String):void
		{
			var myURLReq:URLRequest = new URLRequest(fileUrl);

			_captionsURLLoader = new URLLoader();
			_captionsURLLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_captionsURLLoader.addEventListener(Event.COMPLETE, fileType == "tt" ? parseTimedText : parseSRT);

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

		private function onError(event:Event):void
		{
			this.dispatchEvent( event.clone() );
		}

		public function updatePlayhead (pos:Number):void
		{
			var lastLine : CCLine = _ccLines[_ccLines.length -1];
			if (lastLine && pos && pos > lastLine.start && pos > lastLine.end)
			{
				setText("");
				return;
			}
			for (var i:int = 0; i < _ccLines.length; i++)
			{
				var line:CCLine = _ccLines [i];

				if (pos <= line.end)
				{
					if (pos >= line.start)
					{
						setText (line.text);
					}
					else
					{
						setText ("");
					}
					
					break;
				}
			}
		}
		
		public function enterFullScreen () : void
		{
			
		}
		
		public function exitFullScreen () : void
		{
			
		}
		
		private function parseSRT (e:Event):void
		{
			try{
				if (_captionsURLLoader.data)
				{
					var lines:Array = _captionsURLLoader.data.split ("\n");
					var currLine:CCLine = null;
					_ccLines = new Array ();
					var ccLineInd:int = 0;
		
					for (var i:int = 0; i < lines.length; i++)
					{
						var str:String = lines [i].replace (/^\s+|\s+$/g, "");
						if (str == "")
						{
							if (currLine != null)
							{
								_ccLines.push (currLine);
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
							currLine.start = _parseStrTime (times [0]);
							currLine.end = _parseStrTime (times [1]);
						}
						else
						{
							if (currLine.text != "")
							{
								currLine.text += "<br>";
							}
		
							currLine.text += str;
						}
						
						ccLineInd++;
					}
				}
			}catch (e : Error) {
				this.dispatchEvent( new ErrorEvent (ERROR_PARSING_SRT) );
			}
		}
		
		private function parseTimedText (e:Event):void
		{
			try{
				if (!_captionsURLLoader.data)
					return;
				var docElem:XML = new XML (_captionsURLLoader.data);
				var collElem:XMLList = docElem.children();
				var body:XML = collElem [1];
				collElem = body.children();
				var div:XML = collElem [0];
				collElem = div.children();
				var numOfLines:int = collElem.length ();
				_ccLines = new Array ();
	
				for (var i:int = 0; i < numOfLines; i++)
				{
					var resultElem:XML = collElem [i];
					var currLine:CCLine = new CCLine ();
					
					currLine.start = _parseStrTime (resultElem.attribute ("begin") [0].toString ());
					currLine.end = _parseStrTime (resultElem.attribute ("end") [0].toString ());
					currLine.text = resultElem.text ()[0];
					
					_ccLines.push (currLine);
				}
			} catch ( e:Error ) {
				
				this.dispatchEvent( new ErrorEvent (ERROR_PARSING_TT) );
			}
		}
		
		private function _parseStrTime (timeStr:String):Number
		{
			var hour:Number = parseInt (timeStr.substr(0, 2), 10);
			var minute:Number = parseInt (timeStr.substr(3, 2), 10);
			var second:Number = parseInt (timeStr.substr(6, 2), 10);
			var milli:Number = parseInt (timeStr.substr(9, 3), 10);
			
			return hour * 3600 + minute * 60 + second + milli / 1000;
		}
		
		private function setText (text:String):void
		{
			if (_label.htmlText == text)
			{
				return;
			}

			if (text != null)
			{
				_label.htmlText = text;
			}
    		
			_label.setTextFormat(new TextFormat (fontFamily, _fontSize, 0xffffff, null, null, null, null, null, "center"));
			
			_label.width = this.width - 10;
			_label.x = 5;

//			_label.autoSize = TextFieldAutoSize.CENTER;
			_label.y = ((this.height - _label.height) / 2);
		}
	}
}