package com.kaltura.kdpfl.view.controls {
	import com.kaltura.kdpfl.component.IComponent;
	import com.kaltura.kdpfl.style.FontManager;
	import com.kaltura.kdpfl.style.TextFormatManager;
	
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * Class KTextField represents the multi-line text-field used by the KDP.
	 * @author Hila
	 *
	 */
	public dynamic class KTextField extends UIComponent implements IComponent {
		/**
		 * should the presented text be colored by color1  
		 */		
		public var dynamicColor:Boolean = false;
		
		/**
		 * text color for dynamicColor 
		 */		
		public var color1:Number = -1;
		
		/**
		 * font to be used 
		 */		
		public var font:String = "";
		
		private var _textField:TextField;
		
		private var _truncateToFit:Boolean = true;
		
		private var _untruncatedText:String;
		
		private var _isTruncate:Boolean = false;
		
		private var _textFormat:TextFormat;
		private var _originalTextHeight:Number;
		private var _originalTextWidth:Number;
		
		private var _maxNumLines:int = 4;
		
		
		//internal static const TEXT_HEIGHT_PADDING:int = ;
		
		
		/**
		 *Constructor
		 *
		 */
		public function KTextField() {
			super();
			_textField = new TextField();
			_textField.multiline = true;
			_textField.selectable = false;
			_textField.wordWrap = true;
			_textField.scrollV=0;
			_textField.mouseWheelEnabled=false;
			this.addChild(_textField);
			this.addEventListener(Event.CHANGE, onTextChange);
		}
		
		
		public function initialize():void {}
		
		
		/**
		 * Function extracts the text format from the skin(i.e color, font)
		 * and sets it to the text field.
		 * @param styleName the text style in the skin.
		 * @param setSkinSize
		 *
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
			_textFormat = TextFormatManager.getInstance().getTextFormat(styleName);
			if (dynamicColor && color1 > -1)
				_textFormat.color = color1;
			
			var item:Font = FontManager.getInstance().getEmbeddedFont(font);
			
			if (item) {
				_textFormat.font = item.fontName;
			}
			else if (font)
				_textFormat.font = font;
			
			_textField.defaultTextFormat = _textFormat;
			_textField.setTextFormat(_textFormat);
		}
		
		
		[Bindable]
		public function set text(value:String):void 
		{
			if (value != _untruncatedText)
			{
				_textField.text = value;
				_untruncatedText = value;
				runTruncateToFit();
			}
		}
		
		/**
		 * the text presented in the KTextField 
		 */
		public function get text():String {
			return _textField.text;
		}
		
		[Bindable]
		public function set htmlText ( value : String ) : void{
			if (value != _textField.htmlText)
			{
				_textField.htmlText = value;
				_untruncatedText = _textField.text;
				runTruncateToFit();
			}
		}
		
		public function get htmlText () : String
		{
			return _untruncatedText;
		}
		
		override public function set width(value:Number):void {
			if (value != this.width)
			{
				super.width = value;
				_textField.width = value;
				runTruncateToFit();
			}
		}
		
		override public function set height(value:Number):void
		{
			if (value != this.height)
			{
				super.height = value;
				_textField.height = value;
				runTruncateToFit();
			}
		}
		
		/**
		 * Function reduces the size of the string in the text field
		 * so that it fits properly within its assigned container.
		 * @return <code>true</code> if the string has been truncated
		 *  to fit in the container, <code>false</code> otherwise.
		 */
		public function runTruncateToFit():Boolean {
			if (!truncateToFit)
				return false;
			
			var truncationIndicator:String = "...";
			
			
			var h:Number = this.height;
			
			
			
			if (_untruncatedText != null) {
				if (_untruncatedText != "" && _textField.textHeight > h ) {
					
					//Recursive function to truncate the _textField text view one word at a time
					function recursiveTruncate () : void
					{
						if (_textField.textHeight <= h)
						{
							_textField.text = _textField.text.slice(0, _textField.text.length-4);
							_textField.text = _textField.text.slice(0, _textField.text.lastIndexOf(" "));
							_textField.text = _textField.text.concat(truncationIndicator);
							return;
						}
						else
						{
							_textField.text = _textField.text.slice(0, _textField.text.lastIndexOf(" "));
							recursiveTruncate ()
						}
					}
					
					recursiveTruncate ();
					
					this.tooltip = _untruncatedText;
					_isTruncate = true;
					if (_textFormat)
						_textField.setTextFormat(_textFormat);
					return true;
				}
				else if (_isTruncate) {
					
					
					_isTruncate = false;
					_textField.text = _untruncatedText;
				}
			}
			if (_textFormat)
				_textField.setTextFormat(_textFormat);
			this.tooltip = "";
			return false;
		}
		
		
		
		/**
		 * max number of lines the KTextField presents 
		 */
		public function get maxNumLines():int {
			return _maxNumLines;
		}
		
		
		[Bindable]
		/**
		 * @private
		 */		
		public function set maxNumLines(value:int):void {
			_maxNumLines = value;
		}
		
		
		/**
		 * determines whether user can enter text in the KTextField.
		 */
		public function get editable():Boolean {
			return _textField.type == TextFieldType.INPUT;
		}
		
		
		/**
		 * @private
		 */
		public function set editable(value:Boolean):void {
			if (value) {
				_textField.type = TextFieldType.INPUT;
				_textField.selectable = true;
			}
			else {
				_textField.type = TextFieldType.DYNAMIC;
				_textField.selectable = false;
			}
		}
		
		/**
		 * determines whether user can select the text 
		 * @return 
		 * 
		 */		
		public function get selectable ():Boolean {
			return _textField.selectable;
		}
		
		/**
		 * 
		 * @private
		 * 
		 */		
		public function set selectable(value:Boolean):void {
			_textField.selectable = value;
		}
		
		/**
		 * whether the KTextField truncates its text to fit its size 
		 */
		public function get truncateToFit():Boolean {
			return _truncateToFit;
		}
		
		
		/**
		 * @private
		 */		
		public function set truncateToFit(value:Boolean):void {
			_truncateToFit = value;
		}
		
		/**
		 * Specifies whether the text field has a border. 
		 * If true, the text field has a border. If false, the text field has no border. 
		 * @default false 
		 */		
		public function get border():Boolean {
			return _textField.border;
		}
		
		/**
		 * @private
		 */		
		public function set border(b:Boolean):void {
			_textField.border = b;
		}
		
		/**
		 * The color of the text field border. 
		 * The default value is 0x000000 (black). 
		 * This property can be retrieved or set even if there currently is no border, 
		 * but the color is visible only if the text field has the border property set to true.
		 */		
		public function get borderColor():uint {
			return _textField.borderColor;
		}
		
		/**
		 * @private
		 */		
		public function set borderColor(b:uint):void {
			_textField.borderColor = b;
		}
		
		/**
		 * Specifies whether the text field has a background fill. 
		 * If true, the text field has a background fill. If false, 
		 * the text field has no background fill. Use the backgroundColor 
		 * property to set the background color of a text field.
		 * @default false 
		 */		
		public function get background():Boolean {
			return _textField.background;
		}
		
		/**
		 * @private
		 */		
		public function set background(b:Boolean):void {
			_textField.background = b;
		}
		
		
		/**
		 * The color of the text field background. 
		 * The default value is 0xFFFFFF (white). 
		 * This property can be retrieved or set even if there currently is no background, 
		 * but the color is visible only if the text field has the background property set to true.
		 */		
		public function get backgroundColor():uint {
			return _textField.backgroundColor;
		}
		
		/**
		 * @private
		 */		
		public function set backgroundColor(b:uint):void {
			_textField.backgroundColor = b;
		}
		
		private function onTextChange (e : Event) : void
		{
			_untruncatedText = _textField.text;
		}
		
		
		
	}
}