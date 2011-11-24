package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.kdpfl.view.controls.KTextField;
	
	import fl.managers.IFocusManager;
	import fl.managers.IFocusManagerComponent;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextFieldWrapper implements IFocusManagerComponent
	{
		private var _kTextField:KTextField;
		private var _textFormat:TextFormat	= new TextFormat();
		private var _defaultText:String;
		private var _focusEnabled:Boolean;
		private var _tabIndex:int;
		private var _tabEnabled:Boolean;
		private var _mouseFocusEnabled:Boolean;
		
		public function set kTextField(tf:KTextField):void{
			_kTextField					= tf;
			var textField:TextField		= TextField(_kTextField.getChildAt(0));
			//_textFormat					= textField.getTextFormat();
			//textField.setTextFormat(_textFormat);
			_defaultText				= _kTextField.text;
			
			if(_kTextField.maxChars)
				textField.maxChars	= _kTextField.maxChars;
			
			if(_kTextField.clearOnFocus != undefined){
				if(_kTextField.clearOnFocus == "true"){
					textField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
					textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				//	textField.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
				//	textField.addEventListener(Event.CHANGE, onTextChange);
				}
			}

		}
		
		public function drawFocus(draw:Boolean):void{
			trace("DRAW FOCUS:::: 	"+draw);
		}
		
		
		public function setFocus():void{
			trace("SETTGIN FOCUS:::: ",_kTextField.name, _kTextField.textField.tabIndex);
		}
		
		
		
		public function get textField():TextField{
			return _kTextField.textField;
		}
		
		
		public function set focusEnabled(bool:Boolean):void{
			_focusEnabled	= bool;
		}
		
		public function get focusEnabled():Boolean{
			return _focusEnabled;
		}
		
		
		public function get tabIndex():int{
			return _tabIndex;
		}
		
		public function set tabIndex(num:int):void{
			_tabIndex		= num;
		}
		
		
		public function get tabEnabled():Boolean{
			return _tabEnabled;
		}
		
		
		public function set tabEnabled(bool:Boolean):void{
			_tabEnabled 		= bool;
		}
		
		public function set mouseFocusEnabled(bool:Boolean):void{
			_mouseFocusEnabled		= bool;
		}
		
		public function get mouseFocusEnabled():Boolean{
			return _mouseFocusEnabled;
		}
		
		
		public function resetText():void{
			if(_kTextField.resetText	!= undefined){
				if(_kTextField.resetText == "true")
					_kTextField.text		 = _defaultText;
			}
		}

		private function onFocusOut(e:FocusEvent):void{
			var textVal:String		= _kTextField.htmlText;
			//have to clear text and reinsert value in order to trigger data binding.
			_kTextField.text			= "";
			_kTextField.text			= textVal;
		}
		
		private function onFocusIn(e:FocusEvent):void{
			_kTextField.text						= "";
			
		}
		
		public function TextFieldWrapper()
		{
			
		}
	}
}