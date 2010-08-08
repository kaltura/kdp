package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.component.IComponent;
	import com.kaltura.kdpfl.style.FontManager;
	import com.kaltura.kdpfl.style.TextFormatManager;
	
	import fl.core.UIComponent;
	
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	public dynamic class KTextField extends UIComponent implements IComponent
	{
		private var _textField : TextField;
		public var color1:Number = -1;
		public var dynamicColor:Boolean = false;
		public var font:String = "";
		public var truncateToFit:Boolean = true;
		
		private var _untruncatedText:String;
		
		private var _isTruncate : Boolean = false;
		
		private var _textFormat : TextFormat;
		private var _originalTextHeight : Number;
		private var _originalTextWidth : Number;
		
		private var _maxNumLines : int = 4;
		internal static const TEXT_HEIGHT_PADDING:int = 10;
		
		public function KTextField()
		{
			super();
			_textField = new TextField();
			_textField.multiline = true;
			_textField.selectable = false;
			_textField.wordWrap = true;
			this.addChild(_textField);
			
			
		}
		
		public function initialize():void
		{
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			_textFormat = TextFormatManager.getInstance().getTextFormat( styleName );
			if(dynamicColor && color1 > -1)
				_textFormat.color = color1;
			
			var item : Font = FontManager.getInstance().getEmbeddedFont( font );
			
			if(item)
			{
				_textFormat.font = item.fontName;
			}
			else if (font)
				_textFormat.font = font;
			
			_textField.setTextFormat(_textFormat);
		}
		
		[Bindable]
		public function set text (value : String) : void
		{
			_textField.text = value;
			_untruncatedText = value;
			runTruncateToFit();
		}
		
		public function get text () : String
		{
			
			return _textField.text;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_textField.width = value;
			runTruncateToFit();
		}
		
		
		
		
		public function runTruncateToFit():Boolean
		{
			if (!truncateToFit)
				return false;
			
			var truncationIndicator:String = "...";
			
			var h:Number = parent.height;
			
			if (!_originalTextHeight || _originalTextHeight < _textField.textHeight)
				_originalTextHeight = _textField.textHeight;
			if (!_originalTextWidth || _originalTextWidth > _textField.textWidth)
				_originalTextWidth = _textField.textWidth;
			// Need to check if we should truncate, but it 
			// could be due to rounding error.  Let's check that it's not.
			// Examples of rounding errors happen with "South Africa" and "Game"
			// with verdana.ttf.
			
			if (_untruncatedText != null)
			{
				if (_untruncatedText != "" && _originalTextHeight + this.y > h - TEXT_HEIGHT_PADDING)
				{
					// This should get us into the ballpark.
					var s:String = _textField.text = _untruncatedText;
					var lineHeight : Number = _textField.textHeight/ _textField.numLines;
					
					var availableHeight :Number = Math.min(h - TEXT_HEIGHT_PADDING - this.y, this.height);
					var visibleLines : int = Math.min( Math.floor(availableHeight/lineHeight),_maxNumLines); ;
					var charsPerLine : int = Math.round(_textField.text.length/_textField.numLines);
					var insertAt : int = visibleLines * charsPerLine;
					_textField.text = s.slice(0, insertAt-3);
					_textField.text = _textField.text.slice(0, _textField.text.lastIndexOf(" "));
					_textField.text = _textField.text.concat(truncationIndicator);
					
					this.tooltip = _untruncatedText;
					_isTruncate = true;
					_textField.setTextFormat(_textFormat);
					return true;
				}
				else if(_isTruncate)
				{
					
					// if the text is Truncate and now the Label size is changed
					// and we don't need a truncat text now we will return to untruncated text
					_isTruncate = false;
					_textField.text = _untruncatedText;
					_textField.setTextFormat(_textFormat);
				}
			}
			
			this.tooltip = "";
			return false;
		}

		public function get maxNumLines():int
		{
			return _maxNumLines;
		}
		[Bindable]
		public function set maxNumLines(value:int):void
		{
			_maxNumLines = value;
		}


		

		
		
	}
}